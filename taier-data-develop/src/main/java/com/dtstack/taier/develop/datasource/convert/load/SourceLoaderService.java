/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.dtstack.taier.develop.datasource.convert.load;

import com.alibaba.fastjson.JSONObject;
import com.dtstack.taier.common.enums.DataSourceTypeEnum;
import com.dtstack.taier.common.exception.DtCenterDefException;
import com.dtstack.taier.common.source.SourceDTOLoader;
import com.dtstack.taier.dao.domain.DevelopDataSource;
import com.dtstack.taier.datasource.api.dto.SSLConfig;
import com.dtstack.taier.datasource.api.dto.source.AbstractSourceDTO;
import com.dtstack.taier.datasource.api.dto.source.HdfsSourceDTO;
import com.dtstack.taier.datasource.api.dto.source.ISourceDTO;
import com.dtstack.taier.datasource.api.source.DataSourceType;
import com.dtstack.taier.develop.datasource.convert.dto.ConfigDTO;
import com.dtstack.taier.develop.datasource.convert.enums.SourceDTOType;
import com.dtstack.taier.develop.dto.devlop.DataSourceVO;
import com.dtstack.taier.develop.service.datasource.impl.DatasourceService;
import com.dtstack.taier.scheduler.service.ClusterService;
import com.google.common.collect.Maps;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import static com.dtstack.taier.develop.datasource.convert.Consistent.CONF_DIR;
import static com.dtstack.taier.develop.datasource.convert.Consistent.KERBEROS_CONFIG_KEY;
import static com.dtstack.taier.develop.datasource.convert.Consistent.KERBEROS_PATH_KEY;
import static com.dtstack.taier.develop.datasource.convert.Consistent.KERBEROS_REMOTE_PATH;
import static com.dtstack.taier.develop.datasource.convert.Consistent.KEY_PATH;
import static com.dtstack.taier.develop.datasource.convert.Consistent.PATH;
import static com.dtstack.taier.develop.datasource.convert.Consistent.REMOTE_SSL_DIR;
import static com.dtstack.taier.develop.datasource.convert.Consistent.SEPARATOR;
import static com.dtstack.taier.develop.datasource.convert.Consistent.SFTP_CONF;
import static com.dtstack.taier.develop.datasource.convert.Consistent.SSL_CLIENT_CONF;
import static com.dtstack.taier.develop.datasource.convert.Consistent.SSL_CONFIG;
import static com.dtstack.taier.develop.datasource.convert.Consistent.SSL_FILE_TIMESTAMP;

/**
 * ?????? Loader ????????????????????????????????? sourceID ???????????????????????? ??????????????????????????????????????? common-loader
 * ???????????? ISourceDTO?????????????????? kerberos ??????????????????????????????SFTP kerberos ???????????????
 *
 * @author ???wangchuan
 * date???Created in ??????10:47 2021/7/5
 * company: www.dtstack.com
 */
@Service
public class SourceLoaderService implements SourceDTOLoader {

    /**
     * ???????????????
     */
    @Autowired
    private DatasourceService datasourceService;

    @Autowired
    private ClusterService clusterService;

    /**
     * ????????? common-loader ????????? ISourceDTO
     *
     * @param datasourceId ?????????ID(???????????????)
     * @return ???????????? ISourceDTO
     * @see ISourceDTO
     */
    public ISourceDTO buildSourceDTO(Long datasourceId) {
        return buildSourceDTO(datasourceId, null);
    }

    /**
     * ????????? common-loader ????????? ISourceDTO
     *
     * @param datasourceId ?????????ID(???????????????)
     * @param schema       ????????? schema ??????
     * @return ???????????? ISourceDTO
     * @see ISourceDTO
     */
    public ISourceDTO buildSourceDTO(Long datasourceId, String schema) {
        DevelopDataSource developDataSource = getServiceInfoByDtCenterId(datasourceId);
        return buildSourceDTO(developDataSource, schema);
    }

    /**
     * ????????? common-loader ????????? ISourceDTO, ???????????????????????????
     *
     * @param developDataSource ???????????????
     * @return ???????????? ISourceDTO
     * @see ISourceDTO
     */
    public ISourceDTO buildSourceDTO(DevelopDataSource developDataSource) {
        return buildSourceDTO(developDataSource, null);
    }

    /**
     * ????????? common-loader ????????? ISourceDTO
     *
     * @param developDataSource ???????????????
     * @param schema            ????????? schema ??????
     * @return ???????????? ISourceDTO
     * @see ISourceDTO
     */
    public ISourceDTO buildSourceDTO(DevelopDataSource developDataSource, String schema) {
        ConfigDTO configDTO = new ConfigDTO();
        configDTO.setSchema(schema);
        // ????????????
        sftpPrepare(configDTO, developDataSource);
        kerberosPrepare(configDTO, developDataSource);
        expandConfigPrepare(configDTO, developDataSource);
        return SourceDTOType.getSourceDTO(developDataSource.getDataJson(), developDataSource.getType(), configDTO);
    }

    /**
     * ????????? common-loader ????????? ISourceDTO, ???????????????????????????
     *
     * @param dataSourceVO   ???????????????
     * @param kerberosConfig kerberos ????????????
     * @return ???????????? ISourceDTO
     * @see ISourceDTO
     */
    public ISourceDTO buildSourceDTO(DataSourceVO dataSourceVO, Map<String, Object> kerberosConfig) {
        DataSourceTypeEnum typeEnum = DataSourceTypeEnum.typeVersionOf(dataSourceVO.getDataType(), dataSourceVO.getDataVersion());
        DevelopDataSource dsServiceInfoDTO = new DevelopDataSource();
        dsServiceInfoDTO.setTenantId(dataSourceVO.getTenantId());
        dsServiceInfoDTO.setDataJson(dataSourceVO.getDataJson().toJSONString());
        dsServiceInfoDTO.setType(typeEnum.getVal());
        dsServiceInfoDTO.setTenantId(dataSourceVO.getTenantId());
        ISourceDTO sourceDTO = buildSourceDTO(dsServiceInfoDTO);
        if (MapUtils.isNotEmpty(kerberosConfig)) {
            ((AbstractSourceDTO) sourceDTO).setKerberosConfig(kerberosConfig);
        }
        return sourceDTO;
    }

    /**
     * ?????? sftp ??????
     *
     * @param configDTO         ?????????
     * @param developDataSource ???????????????
     */
    private void sftpPrepare(ConfigDTO configDTO, DevelopDataSource developDataSource) {
        if (Objects.isNull(developDataSource.getTenantId())) {
            throw new RuntimeException("?????? id ????????????");
        }
        if (Objects.isNull(configDTO.getSftpConf())) {
            configDTO.setSftpConf(clusterService.getSftp(developDataSource.getTenantId()));
        }
    }

    /**
     * ????????? kerberos ????????????????????????????????? kerberos?????????????????? SFTP ???????????? kerberos ??????????????????????????????????????????
     *
     * @param sourceInfo ??????????????????????????????
     */
    private void kerberosPrepare(ConfigDTO configDTO, DevelopDataSource sourceInfo) {
        JSONObject dataJson = JSONObject.parseObject(sourceInfo.getDataJson());
        JSONObject kerberosConfig = dataJson.getJSONObject(KERBEROS_CONFIG_KEY);
        if (MapUtils.isEmpty(kerberosConfig)) {
            return;
        }
        String kerberosDir = kerberosConfig.getString(KERBEROS_PATH_KEY);
        if (StringUtils.isEmpty(kerberosDir)) {
            return;
        }
        // ???????????? kerberos ??????????????????????????? datasourceX ??????????????????????????? kerberos ???????????????????????????
        Map<String, Object> kerberosConfigClone = new HashMap<>(kerberosConfig);
        kerberosConfigClone.put(KERBEROS_REMOTE_PATH, buildSftpPath(configDTO.getSftpConf(), kerberosDir));
        kerberosConfigClone.put(SFTP_CONF, configDTO.getSftpConf());
        configDTO.setKerberosConfig(kerberosConfigClone);
    }

    /**
     * ???????????????????????????????????????
     *
     * @param datasourceId ????????????????????????id
     * @return ???????????????
     */
    private DevelopDataSource getServiceInfoByDtCenterId(Long datasourceId) {
        return datasourceService.getOne(datasourceId);
    }

    /**
     * ???????????? ssl ???????????????
     *
     * @param sourceInfo ???????????????
     */
    private void expandConfigPrepare(ConfigDTO configDTO, DevelopDataSource sourceInfo) {
        JSONObject dataJson = JSONObject.parseObject(sourceInfo.getDataJson());
        Map<String, Object> config = new HashMap<>();
        configDTO.setExpendConfig(config);
        if (DataSourceType.ICEBERG.getVal().equals(sourceInfo.getType())) {
            // iceberg ?????? core-site.xml???hdfs-site.xml
            String confDir = dataJson.getString(CONF_DIR);
            if (StringUtils.isBlank(confDir)) {
                throw new DtCenterDefException("iceberg ????????? confDir ????????????");
            }
            config.put(CONF_DIR, buildSftpPath(configDTO.getSftpConf(), confDir));
        } else if (DataSourceType.HIVE3_CDP.getVal().equals(sourceInfo.getType())
                || DataSourceType.HIVE.getVal().equals(sourceInfo.getType())
                || DataSourceType.HIVE1X.getVal().equals(sourceInfo.getType())
                || DataSourceType.HIVE3X.getVal().equals(sourceInfo.getType())) {
            // hive ssl ??????
            JSONObject sslConfig = dataJson.getJSONObject(SSL_CONFIG);
            if (MapUtils.isEmpty(sslConfig)) {
                return;
            }
            SSLConfig hiveSslConfig = SSLConfig.builder()
                    .remoteSSLDir(buildSftpPath(configDTO.getSftpConf(), sslConfig.getString(KEY_PATH)))
                    .sslClientConf(sslConfig.getString(SSL_CLIENT_CONF))
                    .sslFileTimestamp((Timestamp) sslConfig.getTimestamp(SSL_FILE_TIMESTAMP)).build();
            configDTO.setSslConfig(hiveSslConfig);
        } else if (DataSourceType.ES7.getVal().equals(sourceInfo.getType())) {
            // es7 ssl ??????
            String sftpDir = dataJson.getString(KEY_PATH);
            if (StringUtils.isEmpty(sftpDir)) {
                return;
            }
            SSLConfig sslConfig = SSLConfig.builder()
                    .remoteSSLDir(buildSftpPath(configDTO.getSftpConf(), sftpDir)).build();
            configDTO.setSslConfig(sslConfig);
        } else if (DataSourceType.TRINO.getVal().equals(sourceInfo.getType())) {
            JSONObject sslJson = dataJson.getJSONObject(SSL_CONFIG);
            if (Objects.isNull(sslJson) || sslJson.isEmpty()) {
                return;
            }
            SSLConfig sslConfig = SSLConfig.builder()
                    .sslFileTimestamp((Timestamp) sslJson.getTimestamp(SSL_FILE_TIMESTAMP))
                    .remoteSSLDir(sslJson.getString(REMOTE_SSL_DIR))
                    .sslClientConf(sslJson.getString(SSL_CLIENT_CONF))
                    .build();
            configDTO.setSslConfig(sslConfig);
        } else if (DataSourceType.Confluent5.getVal().equals(sourceInfo.getType())) {
            // ?????? confluent5 ssl
            Map<String, Object> otherConfig = Maps.newHashMap(dataJson);
            SSLConfig sslConfig = SSLConfig.builder()
                    .otherConfig(otherConfig).build();
            configDTO.setSslConfig(sslConfig);
        }
    }

    /**
     * ?????? sftp ????????????
     *
     * @param sftpConf sftp ??????
     * @param sftpDir  sftp ???????????????
     * @return sftp ????????????
     */
    public static String buildSftpPath(Map<String, String> sftpConf, String sftpDir) {
        return MapUtils.getString(sftpConf, PATH) + SEPARATOR + sftpDir;
    }
}