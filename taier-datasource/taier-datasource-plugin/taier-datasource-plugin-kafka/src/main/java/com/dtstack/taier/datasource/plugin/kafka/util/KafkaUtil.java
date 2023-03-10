/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.dtstack.taier.datasource.plugin.kafka.util;

import com.dtstack.taier.datasource.api.enums.KafkaAuthenticationType;
import com.dtstack.taier.datasource.plugin.common.utils.ReflectUtil;
import com.dtstack.taier.datasource.plugin.common.utils.TelUtil;
import com.dtstack.taier.datasource.plugin.kerberos.core.util.JaasUtil;
import com.dtstack.taier.datasource.plugin.kafka.KafkaConsistent;
import com.dtstack.taier.datasource.plugin.kafka.enums.EConsumeType;
import com.dtstack.taier.datasource.api.dto.KafkaConsumerDTO;
import com.dtstack.taier.datasource.api.dto.KafkaOffsetDTO;
import com.dtstack.taier.datasource.api.dto.KafkaPartitionDTO;
import com.dtstack.taier.datasource.api.dto.source.KafkaSourceDTO;
import com.dtstack.taier.datasource.api.exception.SourceException;
import com.dtstack.taier.datasource.plugin.common.constant.KerberosConstant;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import kafka.cluster.Broker;
import kafka.cluster.EndPoint;
import kafka.coordinator.group.GroupOverview;
import kafka.utils.ZkUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.admin.DescribeTopicsResult;
import org.apache.kafka.clients.admin.NewTopic;
import org.apache.kafka.clients.admin.TopicDescription;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.consumer.OffsetAndTimestamp;
import org.apache.kafka.common.KafkaFuture;
import org.apache.kafka.common.Node;
import org.apache.kafka.common.PartitionInfo;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.common.security.JaasUtils;
import scala.collection.JavaConversions;
import sun.security.krb5.Config;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;

/**
 * @company: www.dtstack.com
 * @Author ???Nanqi
 * @Date ???Created in 22:46 2020/2/26
 * @Description???Kafka ?????????
 */
@Slf4j
public class KafkaUtil {

    public static final String EARLIEST = "earliest";
    private static final int MAX_POOL_RECORDS = 5;

    // ?????? kerberos ?????? sasl.kerberos.service.name
    private static final String DEFAULT_KERBEROS_NAME = "kafka";

    private static final String KEY_PARTITIONS = "partitions";

    private static final String KEY_REPLICAS = "replicas";

    /**
     * ??? ZK ?????????????????? Kafka broker ??????
     *
     * @param zkUrls zk ??????
     * @return kafka broker ??????
     */
    public static String getAllBrokersAddressFromZk(String zkUrls) {
        log.info("Obtain Kafka Broker address through ZK : {}", zkUrls);
        if (StringUtils.isBlank(zkUrls) || !TelUtil.checkTelnetAddr(zkUrls)) {
            throw new SourceException("Please configure the correct zookeeper address");
        }

        ZkUtils zkUtils = null;
        StringBuilder stringBuilder = new StringBuilder();
        try {
            zkUtils = ZkUtils.apply(zkUrls, KafkaConsistent.SESSION_TIME_OUT,
                    KafkaConsistent.CONNECTION_TIME_OUT, JaasUtils.isZkSecurityEnabled());
            List<Broker> brokers = JavaConversions.seqAsJavaList(zkUtils.getAllBrokersInCluster());
            if (CollectionUtils.isNotEmpty(brokers)) {
                for (Broker broker : brokers) {
                    List<EndPoint> endPoints = JavaConversions.seqAsJavaList(broker.endPoints());
                    for (EndPoint endPoint : endPoints) {
                        String ip = endPoint.host();
                        int port = endPoint.port();
                        if (stringBuilder.length() > 0) {
                            stringBuilder.append(",").append(ip).append(":").append(port);
                        } else {
                            stringBuilder.append(ip).append(":").append(port);
                        }
                    }
                }
            }
        } finally {
            if (zkUtils != null) {
                zkUtils.close();
            }
        }
        return stringBuilder.toString();
    }

    /**
     * ??? KAFKA ????????? TOPIC ?????????
     *
     * @param kafkaSourceDTO kafka ???????????????
     * @return topic ??????
     */
    public static List<String> getTopicList(KafkaSourceDTO kafkaSourceDTO) {
        Properties defaultKafkaConfig = initProperties(kafkaSourceDTO);
        List<String> results = Lists.newArrayList();
        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(defaultKafkaConfig)) {
            Map<String, List<PartitionInfo>> topics = consumer.listTopics();
            if (topics != null) {
                results.addAll(topics.keySet());
            }
        } catch (Exception e) {
            throw new SourceException(String.format("failed to get topics from broker. %s", e.getMessage()), e);
        } finally {
            destroyProperty();
        }
        return results;
    }

    /**
     * ?????? KAFKA ????????? TOPIC ?????????
     *
     * @param sourceDTO         ???????????????
     * @param topicName         topic ??????
     * @param partitions        ????????????
     * @param replicationFactor ???????????????????????????
     */
    public static void createTopicFromBroker(KafkaSourceDTO sourceDTO, String topicName,
                                             Integer partitions, Short replicationFactor) {
        Properties defaultKafkaConfig = initProperties(sourceDTO);
        try (AdminClient client = AdminClient.create(defaultKafkaConfig);) {
            NewTopic topic = new NewTopic(topicName, partitions, replicationFactor);
            client.createTopics(Collections.singleton(topic));
        } catch (Exception e) {
            throw new SourceException(e.getMessage(), e);
        }
    }

    /**
     * ?????????????????????????????????????????????
     *
     * @param sourceDTO ???????????????
     * @param topic     kafka topic
     * @return kafka ??????????????????????????? offset
     */
    public static List<KafkaOffsetDTO> getPartitionOffset(KafkaSourceDTO sourceDTO, String topic) {
        Properties defaultKafkaConfig = initProperties(sourceDTO);
        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(defaultKafkaConfig)) {
            List<TopicPartition> partitions = new ArrayList<>();
            List<PartitionInfo> allPartitionInfo = consumer.partitionsFor(topic);
            for (PartitionInfo partitionInfo : allPartitionInfo) {
                partitions.add(new TopicPartition(partitionInfo.topic(), partitionInfo.partition()));
            }

            Map<Integer, KafkaOffsetDTO> kafkaOffsetDTOMap = new HashMap<>();
            Map<TopicPartition, Long> beginningOffsets = consumer.beginningOffsets(partitions);
            for (Map.Entry<TopicPartition, Long> entry : beginningOffsets.entrySet()) {
                KafkaOffsetDTO offsetDTO = new KafkaOffsetDTO();
                offsetDTO.setPartition(entry.getKey().partition());
                offsetDTO.setFirstOffset(entry.getValue());
                offsetDTO.setLastOffset(entry.getValue());
                kafkaOffsetDTOMap.put(entry.getKey().partition(), offsetDTO);
            }

            Map<TopicPartition, Long> endOffsets = consumer.endOffsets(partitions);
            for (Map.Entry<TopicPartition, Long> entry : endOffsets.entrySet()) {
                KafkaOffsetDTO offsetDTO = kafkaOffsetDTOMap.getOrDefault(entry.getKey().partition(),
                        new KafkaOffsetDTO());
                offsetDTO.setPartition(entry.getKey().partition());
                offsetDTO.setFirstOffset(null == offsetDTO.getFirstOffset() ? entry.getValue() :
                        offsetDTO.getFirstOffset());
                offsetDTO.setLastOffset(entry.getValue());
                kafkaOffsetDTOMap.put(entry.getKey().partition(), offsetDTO);
            }

            return new ArrayList<>(kafkaOffsetDTOMap.values());
        } catch (Exception e) {
            throw new SourceException(e.getMessage(), e);
        } finally {
            destroyProperty();
        }
    }

    /**
     * ?????? Kafka ?????? ???????????????
     *
     * @param sourceDTO ???????????????
     * @return ????????????
     */
    public static boolean checkConnection(KafkaSourceDTO sourceDTO) {
        Properties props = initProperties(sourceDTO);
        /* ??????consumer */
        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props)) {
            consumer.listTopics();
        } catch (Exception e) {
            throw new SourceException(String.format("connect kafka fail: %s", e.getMessage()), e);
        } finally {
            destroyProperty();
        }
        return true;
    }

    private static void destroyProperty() {
        System.clearProperty("java.security.auth.login.config");
        System.clearProperty("javax.security.auth.useSubjectCredsOnly");
    }

    /**
     * ?????? kafka broker ??????????????? broker ?????????????????? zookeeper ?????????
     *
     * @param sourceDTO kafka ???????????????
     * @return kafka broker ??????
     */
    private static String getKafkaBroker(KafkaSourceDTO sourceDTO) {
        String brokerUrls = StringUtils.isEmpty(sourceDTO.getBrokerUrls()) ? getAllBrokersAddressFromZk(sourceDTO.getUrl()) : sourceDTO.getBrokerUrls();
        if (StringUtils.isBlank(brokerUrls)) {
            throw new SourceException("failed to get broker from zookeeper.");
        }
        return brokerUrls;
    }

    /**
     * ????????? Kafka ????????????
     *
     * @param sourceDTO ???????????????
     * @return kafka ??????
     */
    private synchronized static Properties initProperties(KafkaSourceDTO sourceDTO) {
        try {
            String brokerUrls = getKafkaBroker(sourceDTO);
            log.info("Initialize Kafka configuration information, brokerUrls : {}, kerberosConfig : {}", brokerUrls, sourceDTO.getKerberosConfig());
            Properties props = new Properties();
            if (StringUtils.isBlank(brokerUrls)) {
                throw new SourceException("Kafka Broker address cannot be empty");
            }
            /* ??????kakfa ????????????????????????????????????broker????????? */
            props.put("bootstrap.servers", brokerUrls);
            /* ??????????????????offset */
            props.put("enable.auto.commit", "true");
            /* ??????group id */
            props.put("group.id", KafkaConsistent.KAFKA_GROUP);
            /* ????????????offset??????????????? */
            props.put("auto.commit.interval.ms", "1000");
            //heart beat ??????3s
            props.put("session.timeout.ms", "10000");
            //??????????????????????????????
            props.put("max.poll.records", "5");
            props.put("auto.offset.reset", "earliest");
            /* key??????????????? */
            props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
            /* value??????????????? */
            props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");

            /*??????????????????*/
            props.put("request.timeout.ms", "10500");

            // username ??? password ????????????????????? SASL/PLAIN ????????????
            if (StringUtils.isNotBlank(sourceDTO.getUsername()) && StringUtils.isNotBlank(sourceDTO.getPassword())) {
                // SASL/PLAIN ????????????
                props.put("security.protocol", "SASL_PLAINTEXT");
                String saslType = ReflectUtil.getFieldValueNotThrow(String.class, sourceDTO, "authentication", KafkaAuthenticationType.SASL_PLAINTEXT.name());
                if (KafkaAuthenticationType.SASL_SCRAM.name().equalsIgnoreCase(saslType)) {
                    // scram
                    props.put("sasl.mechanism", KafkaAuthenticationType.SASL_SCRAM.getMechanism());
                    props.put("sasl.jaas.config", String.format(KafkaConsistent.KAFKA_SASL_SCRAM_CONTENT, sourceDTO.getUsername(), sourceDTO.getPassword()));
                } else if (KafkaAuthenticationType.SASL_SCRAM_512.name().equalsIgnoreCase(saslType)) {
                    // scram-512
                    props.put("sasl.mechanism", KafkaAuthenticationType.SASL_SCRAM_512.getMechanism());
                    props.put("sasl.jaas.config", String.format(KafkaConsistent.KAFKA_SASL_SCRAM_CONTENT, sourceDTO.getUsername(), sourceDTO.getPassword()));
                }else {
                    props.put("sasl.mechanism", KafkaAuthenticationType.SASL_PLAINTEXT.getMechanism());
                    props.put("sasl.jaas.config", String.format(KafkaConsistent.KAFKA_SASL_PLAIN_CONTENT, sourceDTO.getUsername(), sourceDTO.getPassword()));
                }
                return props;
            }

            if (MapUtils.isEmpty(sourceDTO.getKerberosConfig())) {
                //?????????kerberos?????? ????????????
                return props;
            }
            // ???????????????????????????
            String kafkaKbrServiceName = MapUtils.getString(sourceDTO.getKerberosConfig(), KerberosConstant.KAFKA_KERBEROS_SERVICE_NAME, DEFAULT_KERBEROS_NAME);
            kafkaKbrServiceName = kafkaKbrServiceName.split("/")[0];
            String kafkaLoginConf = JaasUtil.writeJaasConf(sourceDTO.getKerberosConfig(),JaasUtil.KAFKA_JAAS_CONTENT);

            // ??????kerberos???????????????????????????java.security.krb5.conf????????????????????????????????????krb5???????????? refresh ??????????????????
            try {
                Config.refresh();
                javax.security.auth.login.Configuration.setConfiguration(null);
            } catch (Exception e) {
                log.error("Kafka kerberos authentication information refresh failed!");
            }
            // kerberos ????????????
            props.put("security.protocol", "SASL_PLAINTEXT");
            props.put("sasl.mechanism", "GSSAPI");
            // kafka broker???????????????
            props.put("sasl.kerberos.service.name", kafkaKbrServiceName);
            System.setProperty("java.security.auth.login.config", kafkaLoginConf);
            System.setProperty("javax.security.auth.useSubjectCredsOnly", "false");
            return props;
        } catch (Exception e) {
            destroyProperty();
            throw new SourceException("init kafka properties error", e);
        }

    }


    public static List<String> getRecordsFromKafka(KafkaSourceDTO sourceDTO, String topic, String autoReset) {
        List<String> result = new ArrayList<>();
        Properties props = initProperties(sourceDTO);
        /*??????????????????*/
        props.remove("request.timeout.ms");
        props.put("max.poll.records", MAX_POOL_RECORDS);
        /* ??????consumer */
        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);) {
            List<TopicPartition> partitions = new ArrayList<>();
            List<PartitionInfo> all = consumer.partitionsFor(topic);
            for (PartitionInfo partitionInfo : all) {
                partitions.add(new TopicPartition(partitionInfo.topic(), partitionInfo.partition()));
            }

            consumer.assign(partitions);
            //?????????????????????????????????????????????????????????offset?????????????????????
            //https://stackoverflow.com/questions/41008610/kafkaconsumer-0-10-java-api-error-message-no-current-assignment-for-partition
            //????????????????????????
            consumer.poll(1000);

            //??????autoReset ????????????
            if (EARLIEST.equals(autoReset)) {
                consumer.seekToBeginning(partitions);
            } else {
                Map<TopicPartition, Long> partitionLongMap = consumer.endOffsets(partitions);
                for (Map.Entry<TopicPartition, Long> entry : partitionLongMap.entrySet()) {
                    long offset = entry.getValue() - MAX_POOL_RECORDS;
                    offset = offset > 0 ? offset : 0;
                    consumer.seek(entry.getKey(), offset);
                }
            }

            /* ????????????????????????????????????100ms */
            ConsumerRecords<String, String> records = consumer.poll(1000);
            for (ConsumerRecord<String, String> record : records) {
                String value = record.value();
                if (StringUtils.isBlank(value)) {
                    continue;
                }
                if (result.size() >= MAX_POOL_RECORDS) {
                    break;
                }
                result.add(record.value());
            }
        } catch (Exception e) {
            throw new SourceException(String.format("consumption data from kafka error: %s", e.getMessage()), e);
        } finally {
            destroyProperty();
        }
        return result;
    }

    public static List<KafkaPartitionDTO> getPartitions(KafkaSourceDTO sourceDTO, String topic) {
        Properties defaultKafkaConfig = initProperties(sourceDTO);
        List<KafkaPartitionDTO> partitionDTOS = Lists.newArrayList();
        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(defaultKafkaConfig)) {
            // PartitionInfo?????????????????????????????????????????? fastJson ????????????
            List<PartitionInfo> partitions = consumer.partitionsFor(topic);
            if (CollectionUtils.isEmpty(partitions)) {
                return partitionDTOS;
            }
            for (PartitionInfo partition : partitions) {
                // ????????????
                List<KafkaPartitionDTO.Node> replicas = Lists.newArrayList();
                for (Node node : partition.replicas()) {
                    replicas.add(buildKafkaPartitionNode(node));
                }
                // ???isr??????????????????
                List<KafkaPartitionDTO.Node> inSyncReplicas = Lists.newArrayList();
                for (Node node : partition.inSyncReplicas()) {
                    inSyncReplicas.add(buildKafkaPartitionNode(node));
                }
                KafkaPartitionDTO kafkaPartitionDTO = KafkaPartitionDTO.builder()
                        .topic(partition.topic())
                        .partition(partition.partition())
                        .leader(buildKafkaPartitionNode(partition.leader()))
                        .replicas(replicas.toArray(new KafkaPartitionDTO.Node[]{}))
                        .inSyncReplicas(inSyncReplicas.toArray(new KafkaPartitionDTO.Node[]{}))
                        .build();
                partitionDTOS.add(kafkaPartitionDTO);
            }
            return partitionDTOS;
        } catch (Exception e) {
            throw new SourceException(String.format("Get topic: %s partition information is exception???%s", topic, e.getMessage()), e);
        }
    }

    /**
     * ??????kafka node
     *
     * @param node kafka????????????
     * @return common-loader????????????kafka????????????
     */
    private static KafkaPartitionDTO.Node buildKafkaPartitionNode(Node node) {
        if (Objects.isNull(node)) {
            return KafkaPartitionDTO.Node.builder().build();
        }
        return KafkaPartitionDTO.Node.builder()
                .host(node.host())
                .id(node.id())
                .idString(node.idString())
                .port(node.port())
                .rack(node.rack())
                .build();
    }


    /**
     * ??? kafka ????????????
     *
     * @param sourceDTO       kafka ???????????????
     * @param topic           ????????????
     * @param collectNum      ????????????
     * @param offsetReset     ????????????
     * @param timestampOffset ???????????????
     * @param maxTimeWait     ??????????????????
     * @return ??????????????????
     */
    public static List<String> consumeData(KafkaSourceDTO sourceDTO, String topic, Integer collectNum,
                                           String offsetReset, Long timestampOffset, Integer maxTimeWait) {
        // ?????????
        List<String> result = new ArrayList<>();
        Properties prop = initProperties(sourceDTO);
        // ????????????????????????
        prop.put("max.poll.records", MAX_POOL_RECORDS);
        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(prop)) {
            List<TopicPartition> partitions = Lists.newArrayList();
            // ?????????????????????
            List<PartitionInfo> allPartitions = consumer.partitionsFor(topic);
            for (PartitionInfo partitionInfo : allPartitions) {
                partitions.add(new TopicPartition(partitionInfo.topic(), partitionInfo.partition()));
            }
            consumer.assign(partitions);

            // ???????????????????????????
            if (EConsumeType.EARLIEST.name().toLowerCase().equals(offsetReset)) {
                consumer.seekToBeginning(partitions);
            } else if (EConsumeType.TIMESTAMP.name().toLowerCase().equals(offsetReset) && Objects.nonNull(timestampOffset)) {
                Map<TopicPartition, Long> timestampsToSearch = Maps.newHashMap();
                for (TopicPartition partition : partitions) {
                    timestampsToSearch.put(partition, timestampOffset);
                }
                Map<TopicPartition, OffsetAndTimestamp> offsetsForTimes = consumer.offsetsForTimes(timestampsToSearch);
                // ????????????offset ??????????????????????????????
                if (MapUtils.isEmpty(offsetsForTimes)) {
                    consumer.seekToEnd(partitions);
                } else {
                    for (Map.Entry<TopicPartition, OffsetAndTimestamp> entry : offsetsForTimes.entrySet()) {
                        consumer.seek(entry.getKey(), entry.getValue().offset());
                    }
                }
            } else {
                // ????????????????????????????????????
                if (EConsumeType.LATEST.name().toLowerCase().equals(offsetReset)) {
                    consumer.seekToEnd(partitions);
                }
            }

            // ????????????
            long start = System.currentTimeMillis();
            // ??????????????????
            long endTime = start + maxTimeWait * 1000;
            while (true) {
                long nowTime = System.currentTimeMillis();
                if (nowTime >= endTime) {
                    break;
                }
                ConsumerRecords<String, String> records = consumer.poll(1000);
                for (ConsumerRecord<String, String> record : records) {
                    String value = record.value();
                    if (StringUtils.isBlank(value)) {
                        continue;
                    }
                    result.add(value);
                    if (result.size() >= collectNum) {
                        break;
                    }
                }
                if (result.size() >= collectNum) {
                    break;
                }
            }
        } catch (Exception e) {
            throw new SourceException(String.format("consumption data from Kafka exception: %s", e.getMessage()), e);
        } finally {
            destroyProperty();
        }
        return result;
    }

    /**
     * ?????? kafka ??????????????????
     *
     * @param sourceDTO kakfa ???????????????
     * @param topic     kafka ??????
     * @return ??????????????????
     */
    public static List<String> listConsumerGroup(KafkaSourceDTO sourceDTO, String topic) {
        List<String> consumerGroups = new ArrayList<>();
        Properties prop = initProperties(sourceDTO);
        // ??????kafka client
        kafka.admin.AdminClient adminClient = kafka.admin.AdminClient.create(prop);
        try {
            // scala seq ??? java list
            List<GroupOverview> groups = JavaConversions.seqAsJavaList(adminClient.listAllConsumerGroupsFlattened().toSeq());
            groups.forEach(group -> consumerGroups.add(group.groupId()));
            // ?????????topic ????????????
            if (StringUtils.isBlank(topic)) {
                return consumerGroups;
            }
            List<String> consumerGroupsByTopic = Lists.newArrayList();
            for (String groupId : consumerGroups) {
                kafka.admin.AdminClient.ConsumerGroupSummary groupSummary = adminClient.describeConsumerGroup(groupId, 5000L);
                // ??????????????????????????????
                if (Objects.isNull(groupSummary) || "Dead".equals(groupSummary.state())) {
                    continue;
                }
                Map<TopicPartition, Object> offsets = JavaConversions.mapAsJavaMap(adminClient.listGroupOffsets(groupId));
                for (TopicPartition topicPartition : offsets.keySet()) {
                    if (topic.equals(topicPartition.topic())) {
                        consumerGroupsByTopic.add(groupId);
                        break;
                    }
                }
            }
            return consumerGroupsByTopic;
        } catch (Exception e) {
            log.error("listConsumerGroup error:{}", e.getMessage(), e);
        } finally {
            if (Objects.nonNull(adminClient)) {
                adminClient.close();
            }
            destroyProperty();
        }
        return Lists.newArrayList();
    }

    /**
     * ?????? kafka ????????????????????????
     *
     * @param sourceDTO kafka ???????????????
     * @param groupId   ????????????
     * @param srcTopic  kafka ??????
     * @return ????????????????????????
     */
    public static List<KafkaConsumerDTO> getGroupInfoByGroupId(KafkaSourceDTO sourceDTO, String groupId, String srcTopic) {
        List<KafkaConsumerDTO> result = Lists.newArrayList();
        Properties prop = initProperties(sourceDTO);
        // ??????kafka client
        kafka.admin.AdminClient adminClient = kafka.admin.AdminClient.create(prop);
        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(prop)){

            if (StringUtils.isNotBlank(groupId)) {
                kafka.admin.AdminClient.ConsumerGroupSummary groupSummary = adminClient.describeConsumerGroup(groupId, 5000L);
                // ??????????????????????????????
                if (Objects.isNull(groupSummary) || "Dead".equals(groupSummary.state())) {
                    return result;
                }
            } else {
                // groupId ????????????????????????????????????
                List<PartitionInfo> allPartitions = consumer.partitionsFor(srcTopic);
                for (PartitionInfo partitionInfo : allPartitions) {
                    TopicPartition topicPartition = new TopicPartition(partitionInfo.topic(), partitionInfo.partition());
                    // ??????????????????
                    consumer.assign(Lists.newArrayList(topicPartition));
                    consumer.seekToEnd(Lists.newArrayList(topicPartition));
                    long logEndOffset = consumer.position(topicPartition);
                    String brokerHost = Objects.isNull(partitionInfo.leader()) ? null : partitionInfo.leader().host();
                    // ??????kafka consumer ??????
                    KafkaConsumerDTO kafkaConsumerDTO = KafkaConsumerDTO.builder()
                            .groupId(groupId)
                            .topic(partitionInfo.topic())
                            .partition(partitionInfo.partition())
                            .logEndOffset(logEndOffset)
                            .brokerHost(brokerHost)
                            .build();
                    result.add(kafkaConsumerDTO);
                }
                return result;
            }

            Map<TopicPartition, Object> offsets = JavaConversions.mapAsJavaMap(adminClient.listGroupOffsets(groupId));
            for (TopicPartition topicPartition : offsets.keySet()) {
                String topic = topicPartition.topic();
                // ????????????topic ?????? partition
                if (StringUtils.isNotBlank(srcTopic) && !srcTopic.equals(topic)) {
                    continue;
                }
                int partition = topicPartition.partition();
                // ??????????????????
                Long currentOffset = (Long) offsets.get(topicPartition);
                List<TopicPartition> singleTopicPartition = Lists.newArrayList(topicPartition);
                // ??????????????????
                consumer.assign(singleTopicPartition);
                consumer.seekToEnd(singleTopicPartition);
                long logEndOffset = consumer.position(topicPartition);

                List<PartitionInfo> partitions = consumer.partitionsFor(topic);

                // ??????kafka consumer ??????
                KafkaConsumerDTO kafkaConsumerDTO = KafkaConsumerDTO.builder()
                        .groupId(groupId)
                        .topic(topic)
                        .partition(partition)
                        .currentOffset(currentOffset)
                        .logEndOffset(logEndOffset)
                        .lag(logEndOffset - currentOffset)
                        .build();

                // ?????????????????? leader ???????????????host
                for (PartitionInfo partitionInfo : partitions) {
                    if (partition == partitionInfo.partition() && Objects.nonNull(partitionInfo.leader())) {
                        kafkaConsumerDTO.setBrokerHost(partitionInfo.leader().host());
                        break;
                    }
                }
                result.add(kafkaConsumerDTO);
            }
        } catch (Exception e) {
            log.error("getGroupInfoByGroupId error:{}", e.getMessage(), e);
        } finally {
            if (Objects.nonNull(adminClient)) {
                adminClient.close();
            }
            destroyProperty();
        }
        return result;
    }

    /**
     * ??????topic????????????????????????
     *
     * @return ?????????????????????
     */
    public static Map<String, Integer> getTopicPartitionCountAndReplicas(KafkaSourceDTO sourceDTO, String topic) throws Exception {
        Properties properties = initProperties(sourceDTO);
        Properties clientProp = removeExtraParam(properties);
        AdminClient client = AdminClient.create(clientProp);
        //????????????
        Map<String, Integer> countAndReplicas = new HashMap<>();
        DescribeTopicsResult result = client.describeTopics(Collections.singletonList(topic));
        Map<String, KafkaFuture<TopicDescription>> values = result.values();
        KafkaFuture<TopicDescription> topicDescription = values.get(topic);
        int partitions, replicas;
        try {
            partitions = topicDescription.get().partitions().size();
            replicas = topicDescription.get().partitions().iterator().next().replicas().size();
        } catch (Exception e) {
            log.error("get topic partition count and replicas error:{}", e.getMessage(), e);
            throw new Exception(e);
        } finally {
            client.close();
        }
        countAndReplicas.put(KEY_PARTITIONS, partitions);
        countAndReplicas.put(KEY_REPLICAS, replicas);
        return countAndReplicas;
    }

    /**
     * ??????properties???kafka client ?????????????????????
     *
     * @param properties properties
     * @return prop
     */
    private static Properties removeExtraParam(Properties properties) {
        Properties prop = new Properties();
        prop.putAll(properties);
        //??????????????????kafka client?????????
        prop.remove("enable.auto.commit");
        prop.remove("auto.commit.interval.ms");
        prop.remove("session.timeout.ms");
        prop.remove("max.poll.records");
        prop.remove("auto.offset.reset");
        prop.remove("key.deserializer");
        prop.remove("value.deserializer");
        return prop;
    }
}
