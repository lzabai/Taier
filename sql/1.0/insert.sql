INSERT INTO console_cluster (id, cluster_name, gmt_create, gmt_modified, is_deleted) VALUES (-1, 'default', '2022-01-28 10:26:01', '2022-02-11 11:11:32', 0);


INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'CHECKBOX', 1, 'deploymode', '["perjob","session"]', null, '', '', null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'GROUP', 1, 'perjob', '', null, 'deploymode', 'perjob', null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'akka.ask.timeout', '60 s', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'classloader.dtstack-cache', 'true', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'classloader.resolve-order', 'child-first', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'clusterMode', 'perjob', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'env.java.opts', '-XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:MaxMetaspaceSize=500m -Dfile.encoding=UTF-8', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'flinkJarPath', '/data/insight_plugin/flink110_lib', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'flinkPluginRoot', '/data/insight_plugin', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'gatewayJobName', 'pushgateway', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'high-availability', 'ZOOKEEPER', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.cluster-id', '/default', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.storageDir', 'hdfs://ns1/dtInsight/flink110/ha', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.zookeeper.path.root', '/flink110', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.zookeeper.quorum', '', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'jarTmpDir', './tmp110', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'jobmanager.archive.fs.dir', 'hdfs://ns1/dtInsight/flink110/completed-jobs', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.class', 'org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'SELECT', 1, 'metrics.reporter.promgateway.deleteOnShutdown', 'true', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'false', 'false', null, 'deploymode$perjob$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'true', 'true', null, 'deploymode$perjob$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.host', '', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.jobName', '110job', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.port', '9091', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'SELECT', 1, 'metrics.reporter.promgateway.randomJobNameSuffix', 'true', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'false', 'false', null, 'deploymode$perjob$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'true', 'true', null, 'deploymode$perjob$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'monitorAcceptedApp', 'false', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'pluginLoadMode', 'shipfile', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusClass', 'com.dtstack.jlogstash.metrics.promethues.PrometheusPushGatewayReporter', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusHost', '', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusPort', '9090', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'remotePluginRootDir', '/data/insight_plugin', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.backend', 'RocksDB', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.backend.incremental', 'true', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'state.checkpoints.dir', 'hdfs://ns1/dtInsight/flink110/checkpoints', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'state.checkpoints.num-retained', '11', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.savepoints.dir', 'hdfs://ns1/dtInsight/flink110/savepoints', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'submitTimeout', '5', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'yarn.application-attempt-failures-validity-interval', '3600000', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'yarn.application-attempts', '3', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'yarnAccepterTaskNumber', '3', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'GROUP', 1, 'session', '', null, 'deploymode', 'session', null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'blob.service.cleanup.interval', '900', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'checkSubmitJobGraphInterval', '60', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'classloader.dtstack-cache', 'true', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'classloader.resolve-order', 'parent-first', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'clusterMode', 'session', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'env.java.opts', '-XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:MaxMetaspaceSize=300m -Dfile.encoding=UTF-8 -Djavax.xml.parsers.DocumentBuilderFactory=com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'flinkJarPath', '/data/insight_plugin/flink110_lib', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'flinkPluginRoot', '/data/insight_plugin', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'flinkSessionSlotCount', '10', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'gatewayJobName', 'pushgateway', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'high-availability', 'ZOOKEEPER', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.cluster-id', '/default', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.storageDir', 'hdfs://ns1/dtInsight/flink110/ha', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.zookeeper.path.root', '/flink110', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.zookeeper.quorum', '', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'jarTmpDir', './tmp110', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'jobmanager.archive.fs.dir', 'hdfs://ns1/dtInsight/flink110/completed-jobs', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'jobmanager.memory.mb', '2048', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'jobstore.expiration-time', '900', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.class', 'org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'SELECT', 1, 'metrics.reporter.promgateway.deleteOnShutdown', 'true', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'false', 'false', null, 'deploymode$session$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'true', 'true', null, 'deploymode$session$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.host', '', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.jobName', '110job', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.port', '9091', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'SELECT', 1, 'metrics.reporter.promgateway.randomJobNameSuffix', 'true', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'false', 'false', null, 'deploymode$session$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'true', 'true', null, 'deploymode$session$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'monitorAcceptedApp', 'false', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'pluginLoadMode', 'shipfile', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusClass', 'com.dtstack.jlogstash.metrics.promethues.PrometheusPushGatewayReporter', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusHost', '', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusPort', '9090', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'remotePluginRootDir', '/data/insight_plugin', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'sessionRetryNum', '6', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'sessionStartAuto', 'true', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.backend', 'RocksDB', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.backend.incremental', 'true', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'state.checkpoints.dir', 'hdfs://ns1/dtInsight/flink110/checkpoints', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'state.checkpoints.num-retained', '11', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.savepoints.dir', 'hdfs://ns1/dtInsight/flink110/savepoints', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'submitTimeout', '5', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'taskmanager.heap.mb', '2048', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'taskmanager.numberOfTaskSlots', '1', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'web.timeout', '100000', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'yarn.application-attempt-failures-validity-interval', '3600000', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'yarn.application-attempts', '3', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'yarnAccepterTaskNumber', '3', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'clusterMode', 'standalone', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'env.java.opts', '-XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:MaxMetaspaceSize=500m -Dfile.encoding=UTF-8', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'flinkJarPath', '/data/insight_plugin/flink110_lib', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'flinkPluginRoot', '/data/insight_plugin', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'gatewayJobName', 'pushgateway', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability', 'zookeeper', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.cluster-id', '/default', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.storageDir', 'hdfs://ns1/dtInsight/flink110/ha', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.zookeeper.path.root', '/flink110', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'high-availability.zookeeper.quorum', '', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'jobmanager.archive.fs.dir', 'hdfs://ns1/dtInsight/flink110/completed-jobs', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'jobmanager.heap.mb', '1024', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.class', 'org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'SELECT', 1, 'metrics.reporter.promgateway.deleteOnShutdown', 'true', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'false', 'false', null, 'deploymode$standalone$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'true', 'true', null, 'deploymode$standalone$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.host', '', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.jobName', '110job', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'metrics.reporter.promgateway.port', '9091', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'SELECT', 1, 'metrics.reporter.promgateway.randomJobNameSuffix', 'true', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'false', 'false', null, 'deploymode$standalone$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, '', 1, 'true', 'true', null, 'deploymode$standalone$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusClass', 'com.dtstack.jlogstash.metrics.promethues.PrometheusPushGatewayReporter', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusHost', '', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'prometheusPort', '9090', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'remotePluginRootDir', '/data/insight_plugin', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.backend', 'RocksDB', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.backend.incremental', 'true', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'state.checkpoints.dir', 'hdfs://ns1/dtInsight/flink110/checkpoints', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'state.checkpoints.num-retained', '11', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'state.savepoints.dir', 'hdfs://ns1/dtInsight/flink110/savepoints', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'taskmanager.heap.mb', '1024', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'yarnAccepterTaskNumber', '3', null, 'deploymode$standalone', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 1);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'remoteFlinkJarPath', '', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'remoteFlinkJarPath', '', null, 'deploymode$session', null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'RADIO_LINKAGE', 1, 'auth', '1', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, '', 1, 'password', '1', null, 'auth', '1', null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'PASSWORD', 1, 'password', '', null, 'auth$password', '', null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, '', 1, 'rsaPath', '2', null, 'auth', '2', null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'input', 1, 'rsaPath', '', null, 'auth$rsaPath', '', null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'fileTimeout', '300000', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'host', '', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'isUsePool', 'true', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'maxIdle', '16', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'maxTotal', '16', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'maxWaitMillis', '3600000', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'minIdle', '16', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'path', '/data/sftp', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'port', '22', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'timeout', '0', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -101, 10, 'INPUT', 1, 'username', '', null, null, null, null, '2021-02-25 18:12:54', '2021-02-25 18:12:54', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 1, 'security.kerberos.login.contexts', 'KafkaClient', null, 'deploymode$session', null, null, '2021-05-25 11:50:59', '2021-05-25 11:50:59', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'checkpoint.retain.time', '7', null, 'deploymode$perjob', null, null, '2021-08-24 17:22:06', '2021-08-24 17:22:06', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -109, 0, 'INPUT', 0, 'taskmanager.heap.mb', '2048', null, 'deploymode$perjob', null, null, '2021-10-13 15:16:41', '2021-10-13 15:16:41', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'CHECKBOX', 1, 'deploymode', '["perjob"]', null, '', '', null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'GROUP', 1, 'perjob', '', null, 'deploymode', 'perjob', null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'addColumnSupport', 'true', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.cores.max', '1', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'spark.driver.extraJavaOptions', '-Dfile.encoding=utf-8', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'spark.eventLog.compress', 'true', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'spark.eventLog.dir', 'hdfs://ns1/tmp/spark-yarn-logs', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'spark.eventLog.enabled', 'true', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.executor.cores', '1', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'spark.executor.extraJavaOptions', '-Dfile.encoding=utf-8', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.executor.heartbeatInterval', '10s', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.executor.instances', '1', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.executor.memory', '512m', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.network.timeout', '700s', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.rpc.askTimeout', '600s', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.speculation', 'true', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.submit.deployMode', 'cluster', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'spark.yarn.appMasterEnv.PYSPARK_DRIVER_PYTHON', '/data/miniconda2/bin/python3', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'spark.yarn.appMasterEnv.PYSPARK_PYTHON', '/data/miniconda2/bin/python3', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'spark.yarn.maxAppAttempts', '1', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'sparkPythonExtLibPath', 'hdfs://ns1/dtInsight/pythons/pyspark.zip,hdfs://ns1/dtInsight/pythons/py4j-0.10.7-src.zip', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'sparkSqlProxyPath', 'hdfs://ns1/dtInsight/spark/spark-sql-proxy.jar', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 1, 'sparkYarnArchive', 'hdfs://ns1/dtInsight/sparkjars/jars', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -108, 1, 'INPUT', 0, 'yarnAccepterTaskNumber', '3', null, 'deploymode$perjob', null, null, '2021-02-25 18:12:53', '2021-02-25 18:12:53', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -117, 9, 'INPUT', 1, 'jdbcUrl', '', null, null, null, null, '2022-02-14 11:27:44', '2022-02-14 11:27:44', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -117, 9, 'INPUT', 0, 'maxJobPoolSize', '', null, null, null, null, '2022-02-14 11:27:44', '2022-02-14 11:27:44', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -117, 9, 'INPUT', 0, 'minJobPoolSize', '', null, null, null, null, '2022-02-14 11:27:44', '2022-02-14 11:27:44', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -117, 9, 'PASSWORD', 0, 'password', '', null, null, null, null, '2022-02-14 11:27:44', '2022-02-14 11:27:44', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -117, 9, 'INPUT', 0, 'queue', '', null, null, null, null, '2022-02-14 11:27:44', '2022-02-14 11:27:44', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -117, 9, 'INPUT', 0, 'username', '', null, null, null, null, '2022-02-14 11:27:44', '2022-02-14 11:27:44', 0);




INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('total', 100, '??????', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:42', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('mostUse', 90, '??????', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:43', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('relational', 80, '?????????', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:43', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('bigData', 70, '???????????????', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:43', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('mpp', 60, 'MPP', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:43', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('semiStruct', 50, '????????????', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:43', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('analytic', 40, '?????????', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:44', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('NoSQL', 30, 'NoSQL', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:44', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('actualTime', 20, '??????', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:44', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('api', 0, '??????', 0, '2021-03-15 17:49:27', '2021-03-15 17:50:44', 0, 0);
INSERT INTO datasource_classify (classify_code, sorted, classify_name, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('sequential', 10, '??????', 0, '2021-06-09 17:19:27', '2021-06-09 17:19:27', 0, 0);



INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('dataName', '???????????????', 'Input', 1, 0, null, null, null, 0, '{"length":{"max":128, "message":"????????????128?????????"}}', null, null, null, 'common', 0, '2021-03-15 17:33:21', '2021-03-30 16:09:06', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('dataDesc', '??????', 'TextArea', 0, 0, null, null, null, 0, '{"length":{"max":200, "message":"????????????200?????????"}}', null, null, null, 'common', 0, '2021-03-15 17:33:21', '2021-03-30 16:09:15', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:mysql://host:3306/dbName', null, '/jdbc:mysql:\\/\\/(.)+/', 'MySQL', 0, '2021-03-23 20:35:57', '2021-07-28 16:06:50', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'MySQL', 0, '2021-03-23 20:35:57', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'MySQL', 0, '2021-03-23 20:35:57', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:mysql://host:port/dbName', null, '/jdbc:mysql:\\/\\/(.)+/', 'PolarDB for MySQL8', 0, '2021-03-23 20:35:57', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'PolarDB for MySQL8', 0, '2021-03-23 20:35:57', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'PolarDB for MySQL8', 0, '2021-03-23 20:35:57', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', 'SID?????????jdbc:oracle:thin:@host:port:dbName
ServiceName?????????jdbc:oracle:thin:@//host:port/service_name', null, '/jdbc:oracle:thin:@(\\/\\/)?(.)+/', 'Oracle', 0, '2021-03-23 20:35:57', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'Oracle', 0, '2021-03-23 20:35:57', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Oracle', 0, '2021-03-23 20:35:57', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '', '?????????jdbc:sqlserver://localhost:1433;DatabaseName=dbName
???
 jdbc:jtds:sqlserver://localhost:1433/dbName', null, '', 'SQL Server', 0, '2021-03-23 20:35:57', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'SQL Server', 0, '2021-03-23 20:35:57', '2021-04-02 16:50:08', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'SQL Server', 0, '2021-03-23 20:35:57', '2021-04-02 16:50:10', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:postgresql://host:port/database', null, '/jdbc:postgresql:\\/\\/(.)+/', 'PostgreSQL', 0, '2021-03-23 20:35:57', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'PostgreSQL', 0, '2021-03-23 20:35:57', '2021-04-02 16:50:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'PostgreSQL', 0, '2021-03-23 20:35:57', '2021-04-02 16:50:18', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:db2://host:port/dbName', null, '/jdbc:db2:\\/\\/(.)+/', 'DB2', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'DB2', 0, '2021-03-23 20:35:58', '2021-04-13 16:31:26', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'DB2', 0, '2021-03-23 20:35:58', '2021-04-13 16:31:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:dm://host:port/database', null, '/jdbc:dm:\\/\\/(.)+/', 'DMDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'DMDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'DMDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:kingbase8://host:port/database', null, '/jdbc:kingbase8:\\/\\/(.)+/', 'KingbaseES8', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'KingbaseES8', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'KingbaseES8', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:pivotal:greenplum://host:port;DatabaseName=database', null, '/jdbc:pivotal:greenplum:\\/\\/(.)+/', 'Greenplum', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'Greenplum', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Greenplum', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:postgresql://host:port/database', null, '/jdbc:postgresql:\\/\\/(.)+/', 'GaussDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'GaussDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'GaussDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:gbase://host:port/dbName', null, '/jdbc:gbase:\\/\\/(.)+/', 'GBase_8a', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'GBase_8a', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'GBase_8a', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:clickhouse://<host>:<port>[/<database>]', null, '/jdbc:clickhouse:\\/\\/(.)+/', 'ClickHouse', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'ClickHouse', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'ClickHouse', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:mysql://host:port/dbName', null, '/jdbc:mysql:\\/\\/(.)+/', 'TiDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'TiDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'TiDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:mysql://host:port/dbName', null, '/jdbc:mysql:\\/\\/(.)+/', 'AnalyticDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'AnalyticDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'AnalyticDB', 0, '2021-03-23 20:35:58', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:hive://host:port/dbName', null, '/jdbc:(\\w|:)+:\\/\\/(.)+/', 'Hive-1.x', 0, '2021-03-23 20:37:29', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-1.x', 0, '2021-03-23 20:37:29', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-1.x', 0, '2021-03-23 20:37:29', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('defaultFS', 'defaultFS', 'Input', 1, 0, null, 'hdfs://host:port', null, 1, '', null, null, null, 'Hive-1.x', 0, '2021-03-23 20:37:29', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hadoopConfig', '???????????????', 'TextAreaWithCopy', 0, 0, null, '{
"dfs.nameservices": "defaultDfs",
"dfs.ha.namenodes.defaultDfs": "namenode1",
"dfs.namenode.rpc-address.defaultDfs.namenode1": "",
"dfs.client.failover.proxy.provider.defaultDfs": "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider"
}', null, 0, '', '????????????????????????????????????
1?????????????????????nameservice????????? namenode????????????????????????????????????proxy.provider?????????
2??????????????????JSON???????????????
3???????????????
"dfs.nameservices": "nameservice??????", "dfs.ha.namenodes.nameservice??????": "namenode????????????????????????", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.client.failover.proxy.provider.
nameservice??????": "org.apache.hadoop.
hdfs.server.namenode.ha.
ConfiguredFailoverProxyProvider"
4???????????????????????????????????????????????????<a href=''http://hadoop.apache.org/docs/r2.7.4/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html''>Hadoop????????????</a>', null, null, 'Hive-1.x', 0, '2021-03-23 20:37:29', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-1.x', 0, '2021-03-23 20:37:29', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:hive2://host:port/dbName', null, '/jdbc:(\\w|:)+:\\/\\/(.)+/', 'Hive-2.x', 0, '2021-03-23 20:37:30', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-2.x', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-2.x', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('defaultFS', 'defaultFS', 'Input', 1, 0, null, 'hdfs://host:port', null, 1, '', null, null, null, 'Hive-2.x', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hadoopConfig', '???????????????', 'TextAreaWithCopy', 0, 0, null, '{
"dfs.nameservices": "defaultDfs",
"dfs.ha.namenodes.defaultDfs": "namenode1",
"dfs.namenode.rpc-address.defaultDfs.namenode1": "",
"dfs.client.failover.proxy.provider.defaultDfs": "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider"
}', null, 0, '', '????????????????????????????????????
1?????????????????????nameservice????????? namenode????????????????????????????????????proxy.provider?????????
2??????????????????JSON???????????????
3???????????????
"dfs.nameservices": "nameservice??????", "dfs.ha.namenodes.nameservice??????": "namenode????????????????????????", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.client.failover.proxy.provider.
nameservice??????": "org.apache.hadoop.
hdfs.server.namenode.ha.
ConfiguredFailoverProxyProvider"
4???????????????????????????????????????????????????<a href=''http://hadoop.apache.org/docs/r2.7.4/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html''>Hadoop????????????</a>', null, null, 'Hive-2.x', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-2.x', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:hive2://host:port/dbName', null, '/jdbc:hive2:\\/\\/(.)+/', 'SparkThrift', 0, '2021-03-23 20:37:30', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'SparkThrift', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'SparkThrift', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('defaultFS', 'defaultFS', 'Input', 1, 0, null, 'hdfs://host:port', null, 1, '', null, null, null, 'SparkThrift', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hadoopConfig', '???????????????', 'TextAreaWithCopy', 0, 0, null, '{
"dfs.nameservices": "defaultDfs",
"dfs.ha.namenodes.defaultDfs": "namenode1",
"dfs.namenode.rpc-address.defaultDfs.namenode1": "",
"dfs.client.failover.proxy.provider.defaultDfs": "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider"
}', null, 0, '', '????????????????????????????????????
1?????????????????????nameservice????????? namenode????????????????????????????????????proxy.provider?????????
2??????????????????JSON???????????????
3???????????????
"dfs.nameservices": "nameservice??????", "dfs.ha.namenodes.nameservice??????": "namenode????????????????????????", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.client.failover.proxy.provider.
nameservice??????": "org.apache.hadoop.
hdfs.server.namenode.ha.
ConfiguredFailoverProxyProvider"
4???????????????????????????????????????????????????<a href=''http://hadoop.apache.org/docs/r2.7.4/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html''>Hadoop????????????</a>', null, null, 'SparkThrift', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'SparkThrift', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:impala://host:port/dbName', null, '/jdbc:impala:\\/\\/(.)+/', 'Impala', 0, '2021-03-23 20:37:30', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'Impala', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Impala', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('defaultFS', 'defaultFS', 'Input', 1, 0, null, 'hdfs://host:port', null, 1, '', null, null, null, 'Impala', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hadoopConfig', '???????????????', 'TextAreaWithCopy', 0, 0, null, '{
"dfs.nameservices": "defaultDfs",
"dfs.ha.namenodes.defaultDfs": "namenode1",
"dfs.namenode.rpc-address.defaultDfs.namenode1": "",
"dfs.client.failover.proxy.provider.defaultDfs": "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider"
}', null, 0, '', '????????????????????????????????????
1?????????????????????nameservice????????? namenode????????????????????????????????????proxy.provider?????????
2??????????????????JSON???????????????
3???????????????
"dfs.nameservices": "nameservice??????", "dfs.ha.namenodes.nameservice??????": "namenode????????????????????????", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.client.failover.proxy.provider.
nameservice??????": "org.apache.hadoop.
hdfs.server.namenode.ha.
ConfiguredFailoverProxyProvider"
4???????????????????????????????????????????????????<a href=''http://hadoop.apache.org/docs/r2.7.4/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html''>Hadoop????????????</a>', null, null, 'Impala', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Impala', 0, '2021-03-23 20:37:30', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('accessId', 'AccessId', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'Maxcompute', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('accessKey', 'AccessKey', 'Input', 1, 0, null, null, null, 0, '', null, null, null, 'Maxcompute', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('project', 'Project Name', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'Maxcompute', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('endPoint', 'End Point', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'Maxcompute', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('host', '?????????/IP', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'FTP', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('port', '??????', 'Integer', 1, 0, null, 'FTP??????21, SFTP??????22', null, 1, '', null, null, null, 'FTP', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'FTP', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'FTP', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('ftpReact', 'ftpReact', 'FtpReact', 0, 0, null, null, null, 0, '', null, null, null, 'FTP', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:hive2://host:port/dbName', null, '/jdbc:(\\w|:)+:\\/\\/(.)+/
', 'CarbonData', 0, '2021-03-23 20:38:06', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'CarbonData', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'CarbonData', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('carbonReact', 'carbonReact', 'CarbonReact', 0, 0, null, null, null, 0, '', null, null, null, 'CarbonData', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hostPorts', '????????????', 'TextArea', 1, 0, null, '????????????????????????IP1:Port,IP2:Port,IP3:Port3?????????IP???????????????????????????', null, 1, '', null, null, null, 'Kudu', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('others', '????????????', 'TextAreaWithCopy', 0, 0, null, '??????JSON????????????????????????????????????????????????
{
    "openKerberos":false,
    "user":"",
    "keytabPath":"",
    "workerCount":4,
    "bossCount":1,
    "operationTimeout":30000,
    "adminOperationTimeout":30000
}', null, 0, '', null, null, null, 'Kudu', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Kudu', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('authURL', 'RESTful URL', 'Input', 1, 0, null, 'http://ip:port', null, 1, '', '??????Kylin??????????????????????????????http://host:7000', null, '/http:\\/\\/([\\w, .])+:(.)+/', 'Kylin URL-3.x', 0, '2021-03-23 20:38:06', '2021-07-28 16:06:35', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'Kylin URL-3.x', 0, '2021-03-23 20:38:06', '2021-07-28 16:06:35', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Kylin URL-3.x', 0, '2021-03-23 20:38:06', '2021-07-28 16:06:35', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('project', 'Project', 'Input', 1, 0, null, 'DEFAULT', null, 0, '', null, null, null, 'Kylin URL-3.x', 0, '2021-03-23 20:38:06', '2021-07-28 16:06:35', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('config', '???????????????', 'TextAreaWithCopy', 0, 0, null, '{
    "socketTimeout":10000,
    "connectTimeout":10000
}', null, 0, '', null, null, null, 'Kylin URL-3.x', 0, '2021-03-23 20:38:06', '2021-07-28 16:06:35', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hbase_quorum', '????????????', 'TextArea', 1, 0, null, '????????????????????????IP1:Port,IP2:Port,IP3:Port', null, 1, '', null, null, null, 'HBase-1.x', 0, '2021-03-23 20:38:06', '2021-07-28 15:33:28', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hbase_parent', '?????????', 'Input', 0, 0, null, 'ZooKeeper???hbase??????????????????????????????/hbase', null, 0, '', null, null, null, 'HBase-1.x', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hbase_other', '????????????', 'TextArea', 0, 0, null, 'hbase.rootdir": "hdfs: //ip:9000/hbase', null, 0, '', null, null, null, 'HBase-1.x', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'HbaseKerberos', 0, 0, null, null, null, 0, '', null, null, null, 'HBase-1.x', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hbase_quorum', '????????????', 'TextArea', 1, 0, null, '????????????????????????IP1:Port,IP2:Port,IP3:Port', null, 1, '', null, null, null, 'HBase-2.x', 0, '2021-03-23 20:38:07', '2021-07-28 15:33:28', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hbase_parent', '?????????', 'Input', 0, 0, null, 'ZooKeeper???hbase??????????????????????????????/hbase', null, 0, '', null, null, null, 'HBase-2.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hbase_other', '????????????', 'TextArea', 0, 0, null, 'hbase.rootdir": "hdfs: //ip:9000/hbase', null, 0, '', null, null, null, 'HBase-2.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'HbaseKerberos', 0, 0, null, null, null, 0, '', null, null, null, 'HBase-2.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:phoenix:zk1,zk2,zk3:port/hbase2', null, '/jdbc:phoenix:(.)+/', 'Phoenix-4.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Phoenix-4.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:phoenix:zk1,zk2,zk3:port/hbase2', null, '/jdbc:phoenix:(.)+/', 'Phoenix-5.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Phoenix-5.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', '????????????', 'TextArea', 1, 0, null, '???????????????????????????????????????host:port?????????????????????????????????????????????', null, 1, '', null, null, null, 'Elasticsearch-5.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('clusterName', '????????????', 'Input', 0, 0, null, '?????????????????????', null, 0, '{"length":{"max":128, "message":"????????????128?????????"}}', null, null, null, 'Elasticsearch-5.x', 0, '2021-03-23 20:38:07', '2021-07-28 16:05:37', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'Elasticsearch-5.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Elasticsearch-5.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', '????????????', 'TextArea', 1, 0, null, '???????????????????????????????????????host:port?????????????????????????????????????????????', null, 1, '', null, null, null, 'Elasticsearch-6.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('clusterName', '????????????', 'Input', 0, 0, null, '?????????????????????', null, 0, '{"length":{"max":128, "message":"????????????128?????????"}}', null, null, null, 'Elasticsearch-6.x', 0, '2021-03-23 20:38:07', '2021-07-28 16:05:37', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'Elasticsearch-6.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Elasticsearch-6.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', '????????????', 'TextArea', 1, 0, null, '???????????????????????????????????????host:port?????????????????????????????????????????????', null, 1, '', null, null, null, 'Elasticsearch-7.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('clusterName', '????????????', 'Input', 0, 0, null, '?????????????????????', null, 0, '{"length":{"max":128, "message":"????????????128?????????"}}', null, null, null, 'Elasticsearch-7.x', 0, '2021-03-23 20:38:07', '2021-07-28 16:05:37', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'Elasticsearch-7.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Elasticsearch-7.x', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hostPorts', '????????????', 'TextArea', 1, 0, null, 'MongoDB????????????????????????IP1:Port,IP2:Port,IP3:Port', null, 1, '', null, null, null, 'MongoDB', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'MongoDB', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'MongoDB', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('database', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'MongoDB', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('redisReact', 'redisReact', 'RedisReact', 0, 0, null, null, null, 0, '', null, null, null, 'Redis', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hostname', 'hostname', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'S3', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('accessKey', 'AccessKey', 'Input', 1, 0, null, null, null, 0, '', null, null, null, 'S3', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('secretKey', 'SecretKey', 'Input', 1, 0, null, null, null, 0, '', null, null, null, 'S3', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', '????????????', 'TextArea', 0, 1, null, '?????????Kafka?????????ZooKeeper????????????????????????IP1:Port,IP2???Port,IP3???Port/?????????', null, 1, '', null, null, null, 'Kafka-1.x', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:38', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('brokerList', 'broker??????', 'TextArea', 1, 1, null, 'Broker???????????????IP1:Port,IP2:Port,IP3:Port/?????????', null, 1, '', null, null, null, 'Kafka-1.x', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:39', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', '????????????', 'TextArea', 0, 1, null, '?????????Kafka?????????ZooKeeper????????????????????????IP1:Port,IP2???Port,IP3???Port/?????????', null, 1, '', null, null, null, 'Kafka-2.x', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:40', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('brokerList', 'broker??????', 'TextArea', 1, 1, null, 'Broker???????????????IP1:Port,IP2:Port,IP3:Port/?????????', null, 1, '', null, null, null, 'Kafka-2.x', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:41', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', '????????????', 'TextArea', 0, 1, null, '?????????Kafka?????????ZooKeeper????????????????????????IP1:Port,IP2???Port,IP3???Port/?????????', null, 1, '', null, null, null, 'Kafka-0.9', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:41', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('brokerList', 'broker??????', 'TextArea', 1, 1, null, 'Broker???????????????IP1:Port,IP2:Port,IP3:Port/?????????', null, 1, '', null, null, null, 'Kafka-0.9', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:43', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', '????????????', 'TextArea', 0, 1, null, '?????????Kafka?????????ZooKeeper????????????????????????IP1:Port,IP2???Port,IP3???Port/?????????', null, 1, '', null, null, null, 'Kafka-0.10', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:43', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('brokerList', 'broker??????', 'TextArea', 1, 1, null, 'Broker???????????????IP1:Port,IP2:Port,IP3:Port/?????????', null, 1, '', null, null, null, 'Kafka-0.10', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:45', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', '????????????', 'TextArea', 0, 1, null, '?????????Kafka?????????ZooKeeper????????????????????????IP1:Port,IP2???Port,IP3???Port/?????????', null, 1, '', null, null, null, 'Kafka-0.11', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:45', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('brokerList', 'broker??????', 'TextArea', 1, 1, null, 'Broker???????????????IP1:Port,IP2:Port,IP3:Port/?????????', null, 1, '', null, null, null, 'Kafka-0.11', 0, '2021-03-23 20:38:07', '2021-04-13 17:37:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('address', 'Broker URL', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'EMQ', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'EMQ', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'EMQ', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('url', 'URL', 'Input', 1, 0, null, null, null, 1, '', '???????????????????????????&??????????????????URL???????????????ws://host:port/test?Username=sanshui&password=xx', null, null, 'WebSocket', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('webSocketParams', '????????????', 'WebSocketSub', 0, 0, null, null, null, 0, '', null, null, null, 'WebSocket', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('url', 'URL', 'Input', 1, 0, null, 'host:port', null, 1, '', null, null, null, 'Socket', 0, '2021-03-23 20:38:07', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('protocol', 'Protocol', 'Input', 1, 1, null, null, null, 1, '', null, null, null, 'FTP', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:presto://host:port/dbName', null, '/jdbc:presto:\\/\\/(.)+/', 'Presto', 0, '2021-04-07 14:47:08', '2021-04-07 14:47:14', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, null, null, null, null, 'Presto', 0, '2021-04-07 14:47:08', '2021-04-07 14:47:14', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, null, null, null, null, 'Presto', 0, '2021-04-07 14:47:08', '2021-04-07 14:47:14', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hostPort', '??????', 'TextArea', 1, 1, null, null, null, 1, null, null, null, null, 'Redis', 0, '2021-04-15 19:48:41', '2021-04-15 19:48:48', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('database', '?????????', 'Input', 1, 1, null, null, null, 1, null, null, null, null, 'Redis', 0, '2021-04-15 19:48:41', '2021-04-15 19:48:48', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('zkHost', '????????????', 'TextArea', 1, 0, null, '?????????????????????:ip1:port,ip2:port,ip3:port', null, 1, null, null, null, null, 'Solr-7.x', 0, '2021-05-28 14:07:00', '2021-05-28 14:07:00', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('chroot', 'chroot', 'Input', 1, 0, null, '?????????Zookeeper chroot??????,??????/Solr', null, 1, null, null, null, null, 'Solr-7.x', 0, '2021-05-28 14:07:00', '2021-05-28 14:07:00', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Solr-7.x', 0, '2021-03-23 20:37:29', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('kafkaReact', 'kafkaReact', 'KafkaReact', 0, 0, null, '', null, 0, '', null, null, null, 'Kafka-0.9', 0, '2021-06-01 11:50:07', '2021-06-01 11:50:07', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('kafkaReact', 'kafkaReact', 'KafkaReact', 0, 0, null, '', null, 0, '', null, null, null, 'Kafka-0.10', 0, '2021-06-01 11:50:07', '2021-06-01 11:50:07', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('kafkaReact', 'kafkaReact', 'KafkaReact', 0, 0, null, '', null, 0, '', null, null, null, 'Kafka-0.11', 0, '2021-06-01 11:50:07', '2021-06-01 11:50:07', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('kafkaReact', 'kafkaReact', 'KafkaReact', 0, 0, null, '', null, 0, '', null, null, null, 'Kafka-1.x', 0, '2021-06-01 11:50:07', '2021-06-01 11:50:07', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('kafkaReact', 'kafkaReact', 'KafkaReact', 0, 0, null, '', null, 0, '', null, null, null, 'Kafka-2.x', 0, '2021-06-01 11:50:07', '2021-06-01 11:50:07', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('url', 'URL', 'Input', 1, 0, null, 'http://localhost:8086', null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', null, null, '/http:\\/\\/([\\w, .])+:(.)+/', 'InfluxDB-1.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'InfluxDB-1.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'InfluxDB-1.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:hive://host:port/dbName', null, '/jdbc:(\\w|:)+:\\/\\/(.)+/', 'Hive-3.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-3.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-3.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('defaultFS', 'defaultFS', 'Input', 1, 0, null, 'hdfs://host:port', null, 1, '', null, null, null, 'Hive-3.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hadoopConfig', '???????????????', 'TextAreaWithCopy', 0, 0, null, '{
"dfs.nameservices": "defaultDfs",
"dfs.ha.namenodes.defaultDfs": "namenode1",
"dfs.namenode.rpc-address.defaultDfs.namenode1": "",
"dfs.client.failover.proxy.provider.defaultDfs": "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider"
}', null, 0, '', '????????????????????????????????????
1?????????????????????nameservice????????? namenode????????????????????????????????????proxy.provider?????????
2??????????????????JSON???????????????
3???????????????
"dfs.nameservices": "nameservice??????", "dfs.ha.namenodes.nameservice??????": "namenode????????????????????????", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.client.failover.proxy.provider.
nameservice??????": "org.apache.hadoop.
hdfs.server.namenode.ha.
ConfiguredFailoverProxyProvider"
4???????????????????????????????????????????????????<a href=''http://hadoop.apache.org/docs/r2.7.4/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html''>Hadoop????????????</a>', null, null, 'Hive-3.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Hive-3.x', 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('region', 'Region', 'Select', 1, 0, null, '', null, 0, '', null, null, null, 'AWS S3', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '[{key:''1'',value:''cn-north-1'',label:''cn-north-1 (??????)''},{key:''2'',value:''cn-northwest-1'',label:''cnnorthwest-1 (??????)''}]');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('accessKey', 'ACCESS KEY', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'AWS S3', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('secretKey', 'SECRET KEY', 'Password', 1, 0, null, null, null, 0, '', null, null, null, 'AWS S3', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:hive2://host:port/dbName', null, '/jdbc:(\\w|:)+:\\/\\/(.)+/', 'Inceptor', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 0, '', null, null, null, 'Inceptor', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Inceptor', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('defaultFS', 'defaultFS', 'Input', 1, 0, null, 'hdfs://host:port', null, 1, '', null, null, null, 'Inceptor', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('metaStoreUris', 'hive.metastore.uris', 'Input', 0, 0, null, '', null, 0, '', 'hive.metastore.uris???????????????????????????????????????', null, null, 'Inceptor', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hadoopConfig', '???????????????', 'TextAreaWithCopy', 0, 0, null, '{
"dfs.nameservices": "defaultDfs",
"dfs.ha.namenodes.defaultDfs": "namenode1",
"dfs.namenode.rpc-address.defaultDfs.namenode1": "",
"dfs.client.failover.proxy.provider.defaultDfs": "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider"
}', null, 0, '', '????????????????????????????????????
1?????????????????????nameservice????????? namenode????????????????????????????????????proxy.provider?????????
2??????????????????JSON???????????????
3???????????????
"dfs.nameservices": "nameservice??????", "dfs.ha.namenodes.nameservice??????": "namenode????????????????????????", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.namenode.rpc-address.nameservice??????.namenode??????": "", "dfs.client.failover.proxy.provider.
nameservice??????": "org.apache.hadoop.
hdfs.server.namenode.ha.
ConfiguredFailoverProxyProvider"
4???????????????????????????????????????????????????<a href=''http://hadoop.apache.org/docs/r2.7.4/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html''>Hadoop????????????</a>', null, null, 'Inceptor', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'Inceptor', 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:postgresql://host:port/database', null, '/jdbc:postgresql:\\/\\/(.)+/', 'AnalyticDB PostgreSQL', 0, '2021-06-01 12:22:10', '2021-06-01 12:22:10', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'AnalyticDB PostgreSQL', 0, '2021-06-01 12:22:10', '2021-06-01 12:22:10', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 1, 0, null, null, null, 0, '', null, null, null, 'AnalyticDB PostgreSQL', 0, '2021-06-01 12:22:10', '2021-06-01 12:22:10', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:vertica://host:port/dbName', null, '/jdbc:vertica:\\/\\/(.)+/', 'Vertica', 0, '2021-06-01 12:22:10', '2021-06-01 12:22:10', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 1, 0, null, null, null, 1, '', null, null, null, 'Vertica', 0, '2021-06-01 12:22:10', '2021-06-01 12:22:10', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 1, 0, null, null, null, 0, '', null, null, null, 'Vertica', 0, '2021-06-01 12:22:10', '2021-06-01 12:22:10', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('url', 'URL', 'Input', 1, 0, null, 'http://localhost:4242', null, 1, '{"regex":{"message":"URL?????????????????????!"}}', null, null, '/http:\\/\\/([\\w, .])+:(.)+/', 'OpenTSDB-2.x', 0, '2021-07-06 10:37:27', '2021-07-06 10:37:42', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:mysql://host:3306/dbName', null, '/jdbc:mysql:\\/\\/(.)+/', 'Doris-0.14.x', 0, '2021-07-06 09:35:57', '2021-07-06 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'Doris-0.14.x', 0, '2021-07-06 09:35:57', '2021-07-06 10:08:08', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Doris-0.14.x', 0, '2021-07-06 09:35:57', '2021-07-06 10:08:12', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:kylin://host:7070/project_name', null, '/jdbc:kylin:\\/\\/(.)+/', 'Kylin JDBC-3.x', 0, '2021-07-06 09:35:57', '2021-07-06 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'Kylin JDBC-3.x', 0, '2021-07-06 09:35:57', '2021-07-06 10:08:08', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'Kylin JDBC-3.x', 0, '2021-07-06 09:35:57', '2021-07-06 10:08:12', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('jdbcUrl', 'JDBC URL', 'Input', 1, 0, null, null, null, 1, '{"regex":{"message":"JDBC URL?????????????????????!"}}', '?????????jdbc:sqlserver://localhost:1433;DatabaseName=dbName', null, '/jdbc:sqlserver:\\/\\/(.)+/', 'SQLServer JDBC', 0, '2021-07-06 09:35:57', '2021-07-06 16:07:17', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('username', '?????????', 'Input', 0, 0, null, null, null, 1, '', null, null, null, 'SQLServer JDBC', 0, '2021-07-06 09:35:57', '2021-07-06 10:08:08', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('password', '??????', 'Password', 0, 0, null, null, null, 0, '', null, null, null, 'SQLServer JDBC', 0, '2021-07-06 09:35:57', '2021-07-06 10:08:12', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('defaultFS', 'defaultFS', 'Input', 1, 0, null, 'hdfs://host:port', null, 1, '', null, null, null, 'HDFS-2.x', 0, '2021-03-23 20:38:06', '2021-09-17 13:51:06', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hadoopConfig', '???????????????', 'TextAreaWithCopy', 0, 0, null, null, null, 0, '', null, null, null, 'HDFS-2.x', 0, '2021-03-23 20:38:06', '2021-09-17 13:51:06', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('openKerberos', '??????Kerberos??????', 'Kerberos', 0, 0, null, null, null, 0, '', null, null, null, 'HDFS-2.x', 0, '2021-03-23 20:38:06', '2021-09-17 13:51:06', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('defaultFS', 'defaultFS', 'Input', 1, 0, null, 'hdfs://host:port', null, 1, '', null, null, null, 'HDFS-TBDS', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('hadoopConfig', '???????????????', 'TextAreaWithCopy', 0, 0, null, null, null, 0, '', null, null, null, 'HDFS-TBDS', 0, '2021-03-23 20:38:06', '2021-03-30 16:08:46', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('tbds_id', 'ID', 'Input', 1, 0, null, '?????????ID', null, 0, '', null, null, null, 'HDFS-TBDS', 0, '2021-09-17 10:38:27', '2021-09-17 10:38:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('tbds_key', 'KEY', 'Input', 1, 0, null, '?????????KEY', null, 0, '', null, null, null, 'HDFS-TBDS', 0, '2021-09-17 10:38:27', '2021-09-17 10:38:27', 0, 0, '');
INSERT INTO datasource_form_field (name, label, widget, required, invisible, default_value, place_hold, request_api, is_link, valid_info, tooltip, style, regex, type_version, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id, options) VALUES ('tbds_username', 'USERNAME', 'Input', 1, 0, null, '?????????username', null, 0, '', null, null, null, 'HDFS-TBDS', 0, '2021-10-15 10:38:27', '2021-10-15 10:38:27', 0, 0, '');


INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('MySQL', 3, 6.5, 'MySQL.png', 2500, 0, 0, '2021-03-15 17:50:44', '2022-02-11 18:51:23', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('PolarDB for MySQL8', 3, 0.0, 'PolarDB for MySQL8.png', 2450, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Oracle', 3, 1.5, 'Oracle.png', 2400, 0, 0, '2021-03-15 17:50:44', '2021-09-17 15:46:39', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('SQL Server', 3, 0.0, 'SQLServer.png', 2350, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('PostgreSQL', 3, 1.0, 'PostgreSQL.png', 2300, 0, 0, '2021-03-15 17:50:44', '2021-09-17 16:55:58', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('DB2', 3, 0.0, 'DB2.png', 2250, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('DMDB', 3, 0.0, 'DMDB.png', 2200, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('KingbaseES8', 3, 0.0, 'KingbaseES8.png', 2100, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Hive', 4, 4.5, 'Hive.png', 2050, 0, 0, '2021-03-15 17:50:44', '2022-02-10 15:18:13', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('SparkThrift', 4, 5.0, 'SparkThrift.png', 2000, 0, 0, '2021-03-15 17:50:44', '2022-02-11 11:20:06', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Maxcompute', 4, 0.0, 'Maxcompute.png', 1950, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Phoenix', 4, 0.0, 'Phoenix.png', 1900, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Greenplum', 5, 0.0, 'Greenplum.png', 1850, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('GaussDB', 5, 0.0, 'GaussDB.png', 1800, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('GBase_8a', 5, 0.0, 'GBase_8a.png', 1750, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('HDFS', 6, 0.0, 'HDFS.png', 1700, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('FTP', 6, 0.0, 'FTP.png', 1650, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('S3', 6, 0.0, 'S3.png', 1600, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Impala', 7, 0.0, 'Impala.png', 1550, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('ClickHouse', 7, 0.0, 'ClickHouse.png', 1500, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('TiDB', 7, 0.0, 'TiDB.png', 1450, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kudu', 7, 0.0, 'Kudu.png', 1400, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('AnalyticDB', 7, 0.0, 'AnalyticDB.png', 1350, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('CarbonData', 7, 0.0, 'CarbonData.png', 1300, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kylin URL', 7, 0.0, 'Kylin.png', 1250, 0, 0, '2021-03-15 17:50:44', '2021-07-28 16:06:35', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('HBase', 8, 0.0, 'HBase.png', 1200, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Elasticsearch', 8, 0.0, 'Elasticsearch.png', 1150, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('MongoDB', 8, 0.0, 'MongoDB.png', 1050, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Redis', 8, 0.0, 'Redis.png', 1000, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kafka', 9, 0.5, 'Kafka.png', 950, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('EMQ', 9, 0.0, 'EMQ.png', 900, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('WebSocket', 10, 0.0, 'WebSocket.png', 850, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Socket', 10, 0.0, 'Socket.png', 800, 0, 0, '2021-03-15 17:50:44', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Presto', 1, 0.0, null, 750, 1, 0, '2021-03-24 12:01:00', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Solr', 8, 0.0, 'Solr.png', 1100, 0, 0, '2021-05-28 11:18:00', '2021-05-28 11:18:00', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('InfluxDB', 11, 0.0, 'InfluxDB.png', 875, 0, 0, '2021-06-09 14:49:27', '2021-07-28 16:05:37', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('AWS S3', 6, 0.0, 'AWS S3.png', 1575, 0, 0, '2021-06-21 19:48:27', '2021-06-21 19:48:27', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Inceptor', 4, 0.0, 'Inceptor.png', 1875, 0, 0, '2021-06-21 22:07:27', '2021-06-21 22:07:27', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('AnalyticDB PostgreSQL', 7, 0.0, 'ADB_PostgreSQL.png', 1220, 0, 0, '2021-06-01 12:22:10', '2021-06-01 12:22:10', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Vertica', 5, 0.0, 'Vertica.png', 1720, 0, 0, '2021-06-01 12:22:10', '2021-06-01 12:22:10', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('OpenTSDB', 11, 0.0, 'OpenTSDB.png', 862, 0, 0, '2021-07-06 10:37:27', '2021-07-06 10:37:42', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Doris', 7, 0.0, 'Doris.png', 1200, 0, 0, '2021-07-06 12:22:10', '2021-07-06 15:49:09', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kylin JDBC', 7, 0.0, 'Kylin.png', 1300, 0, 0, '2021-07-06 12:22:10', '2021-07-06 15:49:09', 0, 0);
INSERT INTO datasource_type (data_type, data_classify_id, weight, img_url, sorted, invisible, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('SQLServer JDBC', 3, 0.0, 'SQLServer.png', 1200, 0, 0, '2021-07-06 12:22:10', '2021-07-06 15:49:09', 0, 0);



INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Hive', '1.x', 0, 0, '2021-03-15 17:51:55', '2021-03-15 17:53:11', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Hive', '2.x', 1, 0, '2021-03-15 17:51:55', '2021-03-15 17:54:16', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('HBase', '1.x', 0, 0, '2021-03-15 17:51:55', '2021-03-15 17:53:11', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('HBase', '2.x', 1, 0, '2021-03-15 17:51:55', '2021-03-15 17:54:38', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Phoenix', '4.x', 0, 0, '2021-03-15 17:51:55', '2021-03-15 17:53:11', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Phoenix', '5.x', 1, 0, '2021-03-15 17:51:55', '2021-04-01 14:43:21', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Elasticsearch', '5.x', 0, 0, '2021-03-15 17:51:55', '2021-03-15 17:53:11', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Elasticsearch', '6.x', 1, 0, '2021-03-15 17:51:55', '2021-03-15 17:54:24', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Elasticsearch', '7.x', 2, 0, '2021-03-15 17:51:55', '2021-03-15 17:54:24', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kafka', '1.x', 3, 0, '2021-03-15 17:51:55', '2021-03-15 17:54:54', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kafka', '2.x', 4, 0, '2021-03-15 17:51:55', '2021-03-15 17:54:49', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kafka', '0.9', 0, 1, '2021-03-15 17:51:55', '2021-03-15 17:53:11', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kafka', '0.10', 1, 0, '2021-03-15 17:51:55', '2021-03-15 17:54:56', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kafka', '0.11', 2, 0, '2021-03-15 17:51:55', '2021-03-15 17:54:55', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Solr', '7.x', 0, 0, '2021-05-28 14:48:00', '2021-05-28 14:48:00', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('InfluxDB', '1.x', 0, 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Hive', '3.x', 2, 0, '2021-06-09 14:49:27', '2021-06-09 14:49:42', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('OpenTSDB', '2.x', 0, 0, '2021-07-06 10:37:27', '2021-07-06 10:37:42', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Doris', '0.14.x', 0, 0, '2021-07-06 14:49:27', '2021-07-06 14:49:42', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kylin URL', '3.x', 0, 0, '2021-07-06 14:49:27', '2021-07-06 14:49:42', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('Kylin JDBC', '3.x', 0, 0, '2021-07-06 14:49:27', '2021-07-06 14:49:42', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('HDFS', '2.x', 0, 0, '2022-02-17 15:51:08', '2022-02-17 15:51:08', 0, 0);
INSERT INTO datasource_version (data_type, data_version, sorted, is_deleted, gmt_create, gmt_modified, create_user_id, modify_user_id) VALUES ('HDFS', 'TBDS', 1, 0, '2022-02-17 15:51:08', '2022-02-17 15:51:08', 0, 0);



INSERT INTO develop_catalogue (id, tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES (1, -1, '????????????', -1, 3, 1, '2022-02-12 23:33:10', '2022-02-12 23:33:10', -1, 0, 0);
INSERT INTO develop_catalogue (id, tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES (3, -1, '????????????', 1, null, 2, '2022-02-12 23:33:10', '2022-02-12 23:33:10', -1, 0, 0);
INSERT INTO develop_catalogue (id, tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES (5, -1, '????????????', 1, null, 2, '2022-02-12 23:33:10', '2022-02-12 23:33:10', -1, 0, 0);
INSERT INTO develop_catalogue (id, tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES (7, -1, '????????????', 1, null, 2, '2022-02-12 23:33:10', '2022-02-12 23:33:10', -1, 0, 0);
INSERT INTO develop_catalogue (id, tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES (9, -1, '????????????', 1, null, 2, '2022-02-12 23:33:10', '2022-02-12 23:33:10', -1, 0, 0);
INSERT INTO develop_catalogue (id, tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES (11, -1, '????????????', 1, null, 2, '2022-02-12 23:33:10', '2022-02-12 23:33:10', -1, 0, 0);
INSERT INTO develop_catalogue (id, tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES (13, -1, '????????????', 1, null, 2, '2022-02-12 23:33:10', '2022-02-12 23:33:10', -1, 0, 0);
INSERT INTO develop_catalogue (id, tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES (15, -1, '???????????????', 1, null, 2, '2022-02-12 23:33:10', '2022-02-12 23:33:10', -1, 0, 0);

INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (1, 'round', '', '????????????', 'double  round(double a)  double  round(double a, int d)', 'round(double a)????????????a???????????????bigint???  round(double a, int d)?????????double???a?????????d????????????double???????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (3, 'bround', '', '??????????????????', 'double  bround(double a)  double  bround(double a, int d)', 'bround(double a)???1~4?????????6~9?????????5->????????????????????????5->?????????????????????  bround(double a, int d)?????????d?????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (5, 'floor', '', '????????????', 'bigint  floor(double a)', '??????????????????????????????????????????????????? ???????6.10->6 ? -3.4->-4', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (7, 'ceil', '', '??????', 'bigint  ceil(double a)', '???????????????????????????????????????????????????ceil(6) = ceil(6.1)= ceil(6.9) = 6', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (9, 'rand', '', '????????????', 'double  rand()  double  rand(int seed)', '????????????0???1??????????????????????????????????????????seed?????????????????????????????????????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (11, 'exp', '', '???????????????????????????', 'double  exp(double a)  double  exp(decimal a)', '??????????????????e???a???????????? a????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (13, 'ln', '', '????????????????????????', 'double  ln(double a)  double  ln(decimal a)', '??????????????????d????????????a????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (15, 'log10', '', '??????10???????????????', 'double  log10(double a)  double  log10(decimal a)', '?????????10??????d????????????a????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (17, 'log2', '', '??????2??????????????????', 'double  log2(double a)  double  log2(decimal a)', '???2?????????d????????????a????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (19, 'log', '', '????????????', 'double  log(double base, double a)  double  log(decimal base, decimal a)', '???base??????????????????base ??? a??????double??????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (21, 'pow', '', '????????????', 'double  pow(double a, double p)', '??????a???p??????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (23, 'sqrt', '', '???????????????', 'double  sqrt(double a)  double  sqrt(decimal a)', '??????a????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (25, 'bin', '', '???????????????a???string?????????a???bigint??????', 'string  bin(bigint a)', '???????????????a???string?????????a???bigint??????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (27, 'hex', '', '?????????????????????string??????', 'string  hex(bigint a)   string  hex(string a)   string  hex(binary a)', '??????????????????a???string???????????????a???string????????????????????????????????????????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (29, 'unhex', '', 'hex????????????', 'binary  unhex(string a)', 'hex????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (31, 'conv', '', '????????????', 'string  conv(bigint num, int from_base, int to_base)  string  conv(string num, int from_base, int to_base)', '???bigint/string?????????num???from_base???????????????to_base??????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (33, 'abs', '', '??????a????????????', 'double  abs(double a)', '??????a????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (35, 'pmod', '', 'a???b??????', 'int  pmod(int a, int b),   double  pmod(double a, double b)', 'a???b??????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (37, 'sin', '', '???????????????', 'double  sin(double a)  double  sin(decimal a)', '???????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (39, 'asin', '', '??????????????????', 'double  asin(double a)  double  asin(decimal a)', '??????????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (41, 'cos', '', '???????????????', 'double  cos(double a)  double  cos(decimal a)', '???????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (43, 'acos', '', '??????????????????', 'double  acos(double a)  double  acos(decimal a)', '??????????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (45, 'tan', '', '???????????????', 'double  tan(double a)  double  tan(decimal a)', '???????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (47, 'atan', '', '??????????????????', 'double  atan(double a)  double  atan(decimal a)', '??????????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (49, 'degrees', '', '????????????????????????', 'double  degrees(double a)  double  degrees(decimal a)', '????????????????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (51, 'radians', '', '??????????????????????????????', 'double  radians(double a)  double  radians(double a)', '??????????????????????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (53, 'positive', '', '??????a', 'int positive(int a),   double  positive(double a)', '??????a', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (55, 'negative', '', '???????????????', 'int negative(int a),   double  negative(double a)', '??????a????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (57, 'sign', '', '?????????????????????', 'double  sign(double a)  int  sign(decimal a)', 'sign(double a)?????????a??????????????????1.0?????????????????????-1.0???????????????0.0  sign(decimal a)??????????????????????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (59, 'e', '', '???????????????e', 'double  e()', '???????????????e', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (61, 'pi', '', '???????????????pi', 'double  pi()', '???????????????pi', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (63, 'factorial', '', '????????????', 'bigint  factorial(int a)', '???a?????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (65, 'cbrt', '', '???????????????', 'double  cbrt(double a)', '??????a????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (67, 'shiftleft', '', '????????????', 'int   shiftleft(TINYint|SMALLint|int a, int b)  bigint  shiftleft(bigint a, int???)', '????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (69, 'shiftright', '', '????????????', 'int  shiftright(TINYint|SMALLint|int a, intb)  bigint  shiftright(bigint a, int???)', '????????????', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (71, 'shiftrightunsigned', '', '????????????????????????<<<???', 'int  shiftrightunsigned(TINYint|SMALLint|inta, int b)  bigint  shiftrightunsigned(bigint a, int b)', '????????????????????????<<<???', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (73, 'greatest', '', '????????????', 'T  greatest(T v1, T v2, ...)', '?????????????????????????????????????????????????????????NULL', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (75, 'least', '', '????????????', 'T  least(T v1, T v2, ...)', '??????????????????????????????????????????NULL???????????????NULL', 3, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (77, 'size', '', '??????????????????', 'int  size(Map<K.V>)  int  size(Array<T>)', '?????????Map??????????????????Map???????????????????????????????????????????????????', 5, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (79, 'map_keys', '', '??????map????????????key', 'array<K>  map_keys(Map<K.V>)', '??????map????????????key', 5, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (81, 'map_values', '', '??????map????????????value', 'array<V>  map_values(Map<K.V>)', '??????map????????????value', 5, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (83, 'array_contains', '', '?????????????????????????????????', 'boolean  array_contains(Array<T>, value)', '????????????Array<T>??????value??????true??????????????????false', 5, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (85, 'sort_array', '', '????????????', 'array  sort_array(Array<T>)', '?????????????????????????????????????????????', 5, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (87, 'row_number', '', '?????????????????????????????????', 'row_number() OVER (partition by COL1 order by COL2 desc ) rank', '????????????COL1?????????????????????????????? COL2?????????????????????????????????????????????????????????????????????????????????????????????????????????)', 5, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (89, 'from_unixtime', '', '???????????????', 'string  from_unixtime(bigint unixtime[, string format])', '???????????????????????????format?????????format?????????yyyy-MM-dd hh:mm:ss???,???yyyy-MM-dd hh???,???yyyy-MM-dd hh:mm???????????????from_unixtime(1250111000,"yyyy-MM-dd") ??????2009-03-12', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (91, 'unix_timestamp', '', '???????????????', 'bigint  unix_timestamp()  bigint  unix_timestamp(string date)  bigint  unix_timestamp(string date, string pattern)', '1.unix_timestamp()????????????????????????????????????  2.unix_timestamp(string date)???????????????yyyy-MM-dd HH:mm:ss??????????????????????????????????????????unix_timestamp("2009-03-20 11:30:01") = 1237573801  3.unix_timestamp(string date, string pattern)???????????????????????????????????????????????????Unix????????????????????????????????????0 ??????unix_timestamp("2009-03-20", "yyyy-MM-dd") = 1237532400', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (93, 'to_date', '', '????????????', 'string  to_date(string timestamp)', '?????????????????????????????????????????????to_date("1970-01-01 00:00:00") = "1970-01-01".', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (95, 'year', '', '????????????', 'int  year(string date)', '?????????????????????????????????????????????year("1970-01-01 00:00:00") = 1970, year("1970-01-01") = 1970.', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (97, 'quarter', '', '????????????', 'int  quarter(date/timestamp/string)', '???????????????????????????????????? ???quarter("2015-04-08") = 2', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (99, 'month', '', '????????????', 'int  month(string date)', '?????????????????????????????????????????????month("1970-11-01 00:00:00") = 11, month("1970-11-01") = 11.', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (101, 'day', '', '?????????', 'int  day(string date)', '?????????????????????????????????????????????day("1970-11-01 00:00:00") = 1, day("1970-11-01") = 1.', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (103, 'hour', '', '????????????', 'int  hour(string date)', '??????????????????????????????????????? hour("2009-07-30 12:58:59") = 12, hour("12:58:59") = 12.', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (105, 'minute', '', '????????????', 'int  minute(string date)', '??????????????????????????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (107, 'second', '', '????????????', 'int  second(string date)', '???????????????????????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (109, 'weekofyear', '', '?????????', 'int  weekofyear(string date)', '???????????????????????????????????????????????????????????????weekofyear("1970-11-01 00:00:00") = 44, weekofyear("1970-11-01") = 44', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (111, 'datediff', '', '???????????????', 'int  datediff(string enddate, string startdate)', '??????????????????startdate???????????????enddate????????????????????????datediff("2009-03-01", "2009-02-27") = 2.', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (113, 'date_add', '', '???????????????startdate??????days', 'string  date_add(string startdate, int days)', '???????????????startdate??????days?????????date_add("2008-12-31", 1) = "2009-01-01".', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (115, 'date_sub', '', '???????????????startdate??????days', 'string  date_sub(string startdate, int days)', '???????????????startdate??????days?????????date_sub("2008-12-31", 1) = "2008-12-30".', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (117, 'from_utc_timestamp', '', '???????????????', 'timestamp  from_utc_timestamp(timestamp, string timezone)', '???????????????????????????UTC?????????????????????????????????????????????????????????from_utc_timestamp("1970-01-01 08:00:00","PST")=1970-01-01 00:00:00.', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (119, 'to_utc_timestamp', '', '???????????????', 'timestamp  to_utc_timestamp(timestamp, string timezone)', '??????????????????????????????UTC????????????????????????to_utc_timestamp("1970-01-01 00:00:00","PST") =1970-01-01 08:00:00', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (121, 'current_date', '', '????????????????????????', 'date  current_date', '????????????????????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (123, 'current_timestamp', '', '?????????????????????', 'timestamp  current_timestamp', '?????????????????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (125, 'add_months', '', '??????????????????????????????num_months???????????????', 'string  add_months(string start_date, int num_months)', '??????start_date?????????num_months???????????? start_date?????????????????????????????????????????? num_months?????????????????? start_date??????????????????????????? ??????start_date?????????????????????????????????????????????????????????start_date????????????????????????????????????????????????????????????????????? ??????????????????start_date???????????????????????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (127, 'last_day', '', '???????????????????????????????????????', 'string  last_day(string date)', '????????????????????????????????????????????? date????????????"yyyy-MM-dd HH???mm???ss"???"yyyy-MM-dd"??????????????? ?????????????????????????????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (129, 'next_day', '', '????????????????????????????????????X??????????????????', 'string  next_day(string start_date, string day_of_week)', '????????????????????????????????????X???????????????????????????next_day("2015-01-14", "TU") = 2015-01-20 ????2015-01-14????????????????????????????????????????????????????????????2015-01-20', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (131, 'trunc', '', '????????????????????????????????????', 'string  trunc(string date, string format)', '?????????????????????????????????????????????trunc("2016-06-26",???MM???)=2016-06-01 ?trunc("2016-06-26",???YY???)=2016-01-01 ? ???????????????????????????MONTH/MON/MM, YEAR/YYYY/YY', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (133, 'months_between', '', '??????date1???date2?????????????????????', 'double  months_between(date1, date2)', '??????date1???date2???????????????????????????date1>date2????????????????????????date1<date2,???????????????????????????0.0 ???????months_between("1997-02-28 10:30:00", "1996-10-30") = 3.94959677 ?1997-02-28 10:30:00???1996-10-30??????3.94959677??????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (135, 'date_format', '', '???????????????', 'string  date_format(date/timestamp/string ts, string fmt)', '???????????????????????????date?????????date_format("2016-06-22","MM-dd")=06-22', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (137, 'if', '', '??????testCondition ???true?????????valueTrue,????????????valueFalseOrNull ', 'T  if(boolean testCondition, T valueTrue, T valueFalseOrNull)', 'valueTrue???valueFalseOrNull?????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (139, 'nvl', '', '??????value??????NULL?????????default_value,????????????value', 'T  nvl(T value, T default_value)', '??????value??????NULL?????????default_value,????????????value', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (141, 'coalesce', '', '???????????????null??????', 'T  coalesce(T v1, T v2, ...)', '??????????????????NULL?????????NULL ???????COALESCE (NULL,44,55)=44', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (143, 'isnull', '', '??????a????????????', 'boolean  isnull( a )', '??????a???null?????????true???????????????false', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (145, 'isnotnull', '', '??????a???????????????', 'boolean  isnotnull ( a )', '??????a??????null?????????true???????????????false', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (147, 'assert_true', '', '????????????????????????', 'assert_true(boolean condition)', '????????????????????????????????????????????????????????????null??????Hive 0.8.0?????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (149, 'cast', '', '????????????', 'type  cast(expr as <type>)', '????????????expr??????????????????<type>??? ?????????cast???"1"???BIGINT???????????????"1"??????????????????????????? ?????????????????????????????????null???', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (151, 'binary', '', '?????????????????????????????????', 'binary  binary(string|binary)', '?????????????????????????????????', 7, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (153, 'ascii', '', '??????str?????????ASCII?????????????????????', 'int  ascii(string str)', '??????str?????????ASCII?????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (155, 'base64', '', '?????????????????????', 'string  base64(binary bin)', '????????????bin?????????64???????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (157, 'concat', '', '????????????????????????', 'string  concat(string|binary A, string|binary B...)', '????????????????????????????????????concat("foo", "bar") = "foobar"????????????????????????????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (159, 'chr', '', '??????A?????????ASCII??????', 'string chr(bigint|double A)', '??????A?????????ASCII???????????????A??????256?????????????????????chr???A???256?????? ?????????chr???@date???=???X??????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (161, 'context_ngrams', '', '??????????????????TOP K???????????????', 'array<struct<string,double>>  context_ngrams(array<array<string>>, array<string>, int K, int pf)', '??????????????????TOP K?????????????????????context_ngram()??????????????????????????????(??????)?????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (163, 'concat_ws', '', '???????????????????????????????????????', 'string  concat_ws(string SEP, string A, string B...)  string  concat_ws(string SEP, array<string>)', '???????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (165, 'decode', '', '??????', 'string  decode(binary bin, string charset)', '????????????????????????charset???????????????bin?????????????????????????????????????????????"US-ASCII", "ISO-8@math9-1", "UTF-8", "UTF-16BE", "UTF-16LE", "UTF-16"??????????????????????????????NULL????????????NULL', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (167, 'encode', '', '??????', 'binary  encode(string src, string charset)', '????????????????????????charset????????????????????????????????????????????????????????????"US-ASCII", "ISO-8@math9-1", "UTF-8", "UTF-16BE", "UTF-16LE", "UTF-16"??????????????????????????????NULL????????????NULL', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (169, 'find_in_set', '', '????????????????????????????????????str???????????????', 'int  find_in_set(string str, string strList)', '????????????????????????????????????str??????????????????????????????str?????????????????????????????????0????????????????????????NULL?????????NULL???', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (171, 'format_number', '', '????????????', 'string  format_number(number x, int d)', '?????????X?????????"#,###,###.##"???????????????????????????d??????????????????d???0??????????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (173, 'get_json_object', '', '?????????????????????JSON??????', 'string  get_json_object(string json_string, string path)', '?????????????????????JSON??????????????????JSON?????????????????????????????????JSON????????????????????????JSON?????????????????????NULL,??????????????????JSON???????????????????????? ?????? ????????????????????????????????????????????????????????????key????????????????????????????????????Hive??????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (175, 'in_file', '', '???????????????????????????????????????', 'boolean  in_file(string str, string filename)', '??????????????????filename???????????????????????????????????????str?????????????????????true', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (177, 'instr', '', '???????????????str???????????????substr???????????????', 'int  instr(string str, string substr)', '???????????????str???????????????substr?????????????????????????????????????????????0????????????????????????Null?????????null?????????????????????1?????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (179, 'length', '', '?????????????????????', 'int  length(string A)', '????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (181, 'locate', '', '?????????pos????????????str??????????????????substr?????????', 'int  locate(string substr, string str[, int pos])', '?????????pos????????????str??????????????????substr?????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (183, 'lower', '', '????????????A????????????????????????????????????', 'string  lower(string A)', '????????????A????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (185, 'lpad', '', '???????????????????????????str???????????????pad???????????????len??????????????????????????????str???????????????len????????????????????????????????????', 'string  lpad(string str, int len, string pad)', '???????????????????????????str???????????????pad???????????????????????????len????????????????????????str???????????????len????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (187, 'ltrim', '', '???????????????A???????????????', 'string  ltrim(string A)', '???????????????A???????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (189, 'ngrams', '', '??????????????????TOP K???????????????', 'array<struct<string,double>>  ngrams(array<array<string>>, int N, int???, int pf)', '??????????????????TOP K???????????????,n????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (191, 'parse_url', '', '?????????URL??????????????????????????????', 'string  parse_url(string urlstring, string partToExtract [, string keyToExtract])', '?????????URL???????????????????????????????????????url???URL?????????????????????partToExtract??????????????????????????????????????????(HOST, PATH, QUERY, REF, PROTOCOL, AUTHORITY, FILE, and USERINFO,?????????parse_url("http://facebook.com/path1/p.php?k1=v1&k2=v2#Ref1", "HOST") ="facebook.com"???????????????partToExtract??????QUERY??????????????????????????????key ???????parse_url("http://facebook.com/path1/p.php?k1=v1&k2=v2#Ref1", "QUERY", "k1") =???v1???', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (193, 'printf', '', '??????printf???????????????????????????', 'string  printf(string format, Obj... args)', '??????printf???????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (195, 'regexp_extract', '', '????????????????????????????????????', 'string  regexp_extract(string subject, string pattern, int index)', '???????????????subject????????????????????????pattern??????index??????????????????????????? ?????????regexp_extract("foothebar", "foo(.*?)(bar)", 2)="bar"??? ????????????????????????????????????????????????????????????????????? s???????????????????????????????????????s; ""?????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (197, 'regexp_replace', '', '?????????????????????????????????', 'string regexp_replace(string INITIAL_STRING, string PATTERN, string REPLACEMENT)', '??????Java???????????????PATTERN????????????INITIAL_STRING?????????????????????????????????REPLACEMENT??????????????????????????????REPLACEMENT??????????????????????????????????????????????????? ???????regexp_replace("foobar", "oo|ar", "") = "fb."???', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (199, 'repeat', '', '????????????n????????????str', 'string  repeat(string str, int n)', '????????????n????????????str', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (201, 'reverse', '', '???????????????', 'string  reverse(string A)', '???????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (203, 'rpad', '', '???????????????', 'string  rpad(string str, int len, string pad)', '???????????????????????????str???????????????pad???????????????????????????len????????????????????????str???????????????len????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (205, 'rtrim', '', '????????????????????????????????????', 'string  rtrim(string A)', '????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (207, 'sentences', '', '????????????str????????????????????????', 'array<array<string>>  sentences(string str, string lang, string locale)', '?????????str????????????????????????????????????sentences("Hello there! How are you?") =( ("Hello", "there"), ("How", "are", "you") )', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (209, 'space', '', '??????n?????????', 'string  space(int n)', '??????n?????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (211, 'split', '', '?????????????????????pat??????????????????str', 'array  split(string str, string pat)', '?????????????????????pat??????????????????str,??????????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (213, 'str_to_map', '', '????????????str??????????????????????????????Map', 'map<string,string>  str_to_map(text[, delimiter1, delimiter2])', '????????????str??????????????????????????????Map???????????????????????????????????????????????????????????????????????????????????????????????????????????????;??????????????????????????????????????????????????????"="', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (215, 'substr', '', '???????????????', 'string  substr(string|binary A, int start) string  substr(string|binary A, int start, int len) ', '???????????????A???start?????????????????????????????????  ???????????????A???start????????????????????????length????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (217, 'substring_index', '', '???????????????', 'string  substring_index(string A, string delim, int count)', '?????????count?????????????????????????????????count?????????????????????????????????????????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (219, 'translate', '', '???????????????', 'string  translate(string|char|varchar input, string|char|varchar from, string|char|varchar to)', '???input?????????from????????????????????????to??????????????? ??????translate("MOBIN","BIN","M")="MOM"', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (221, 'trim', '', '????????????A???????????????????????????', 'string  trim(string A)', '????????????A???????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (223, 'unbase64', '', '???64?????????????????????????????????', 'binary  unbase64(string str)', '???64?????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (225, 'upper', '', '????????????A?????????????????????????????????', 'string  upper(string A)', '????????????A?????????????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (227, 'initcap', '', '????????????????????????????????????', 'string  initcap(string A)', '??????????????????????????????????????????????????????????????????????????????????????????????????? ????????????????????????', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (229, 'levenshtein', '', '??????????????????????????????????????????', 'int  levenshtein(string A, string B)', '?????????????????????????????????????????? ???????levenshtein("kitten", "sitting") = 3', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (231, 'soundex', '', '???????????????????????????soundex?????????', 'string  soundex(string A)', '???????????????????????????soundex??????????????????soundex("Miller") = M460.', 11, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (233, 'count', '', '???????????????', 'bigint  count(*)  bigint  count(expr)  bigint  count(DISTINCT expr[, expr...])', '??????????????????????????????NULL?????????  ???????????????NULL???expr?????????????????????  ???????????????NULL???????????????expr?????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (235, 'sum', '', '????????????????????????', 'double  sum(col)  double  sum(DISTINCT col)', 'sum(col),???????????????????????????sum(DISTINCT col)??????????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (237, 'avg', '', '????????????????????????', 'double  avg(col)  double  avg(DISTINCT col)', 'avg(col),?????????????????????????????????avg(DISTINCT col)????????????????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (239, 'min', '', '????????????????????????', 'double  min(col)', '????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (241, 'max', '', '????????????????????????', 'double  max(col)', '????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (243, 'variance', '', '???????????????????????????', 'double  variance(col)  double  var_pop(col)', '???????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (245, 'var_samp', '', '?????????????????????????????????', 'double  var_samp(col)', '?????????????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (247, 'stddev_pop', '', '?????????????????????????????????', 'double  stddev_pop(col)', '?????????????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (249, 'stddev_samp', '', '???????????????????????????????????????', 'double  stddev_samp(col)', '???????????????????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (251, 'covar_pop', '', '??????????????????????????????', 'double  covar_pop(col1, col2)', '??????????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (253, 'covar_samp', '', '????????????????????????????????????', 'double  covar_samp(col1, col2)', '????????????????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (255, 'corr', '', '?????????????????????????????????', 'double  corr(col1, col2)', '?????????????????????????????????', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (257, 'percentile', '', '??????col???p%?????????', 'double  percentile(bigint col, p)', ' p?????????0???1?????????????????????????????????????????????????????????????????? ', 13, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (259, 'explode', '', '??????a????????????????????????????????????????????????', 'Array Type  explode(array<TYPE> a)  N rows  explode(ARRAY)  N rows  explode(MAP)', '??????a????????????????????????????????????????????????  ???????????????????????????????????????  ???????????????????????????????????????????????????????????????????????????????????????????????????????????????', 15, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (261, 'posexplode', '', '???????????????????????????????????????', 'N rows  posexplode(ARRAY)', '???explode????????????????????????????????????????????????????????????', 15, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (263, 'stack', '', '???M????????????N???', 'N rows  stack(int n, v_1, v_2, ..., v_k)', '???v_1???...???v_k?????????n?????? ????????????k / n?????? n??????????????????', 15, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (265, 'json_tuple', '', '?????????JSON??????????????????????????????????????????????????????', 'tuple  json_tuple(jsonStr, k1, k2, ...)', '?????????JSON????????????????????????????????????????????????????????????get_json_object????????????????????????????????????????????????', 15, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (267, 'parse_url_tuple', '', '?????????URL???????????????N???????????????', 'tuple  parse_url_tuple(url, p1, p2, ...)', '?????????URL???????????????N????????????????????????url???URL?????????????????????p1,p2,....??????????????????????????????????????????HOST, PATH, QUERY, REF, PROTOCOL, AUTHORITY, FILE, USERINFO, QUERY:<KEY>', 15, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);
INSERT INTO develop_function (id, name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text) VALUES (269, 'inline', '', '????????????????????????????????????????????????', 'inline(ARRAY<STRUCT[,STRUCT]>)', '????????????????????????????????????????????????', 15, -1, -1, -1, 1, 0, '2022-02-12 23:33:10', '2022-02-12 23:33:10', 0, null);


INSERT INTO develop_sys_parameter (param_name, param_command, gmt_create, gmt_modified, is_deleted) VALUES ('bdp.system.bizdate', 'yyyyMMdd-1', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_sys_parameter (param_name, param_command, gmt_create, gmt_modified, is_deleted) VALUES ('bdp.system.cyctime', 'yyyyMMddHHmmss', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_sys_parameter (param_name, param_command, gmt_create, gmt_modified, is_deleted) VALUES ('bdp.system.currmonth', 'yyyyMM-0', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_sys_parameter (param_name, param_command, gmt_create, gmt_modified, is_deleted) VALUES ('bdp.system.premonth', 'yyyyMM-1', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_sys_parameter (param_name, param_command, gmt_create, gmt_modified, is_deleted) VALUES ('bdp.system.runtime', '${bdp.system.currenttime}', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_sys_parameter (param_name, param_command, gmt_create, gmt_modified, is_deleted) VALUES ('bdp.system.bizdate2', 'yyyy-MM-dd,-1', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);


INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (0, 1, 'create table if not exists ods_order_header (
     order_header_id     string comment ''?????????id''
    ,order_date          bigint comment ''????????????''
    ,shop_id             string comment ''??????id''
    ,customer_id         string comment ''??????id''
    ,order_status        bigint comment ''????????????''
    ,pay_date            bigint comment ''????????????''

)comment ''?????????????????????''
PARTITIONED BY (ds string) ;

create table if not exists ods_order_detail (
     order_header_id     string comment ''?????????id''
    ,order_detail_id     string comment ''????????????id''
    ,item_id             string comment ''??????id''
    ,quantity            double comment ''????????????''
    ,unit_price          double comment ''????????????''
    ,dist_amout          double comment ''????????????''
)comment ''?????????????????????''
PARTITIONED BY (ds string) ;


create table if not exists exam_ods_shop_info (
     shop_id                string comment ''??????id''
    ,shop_name              string comment ''????????????''
    ,shop_type              string comment ''????????????''
    ,address                string comment ''????????????''
    ,status                 string comment ''????????????,open/closed''
)comment ''???????????????''
PARTITIONED BY (ds string) ;', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (0, 2, 'create table if not exists exam_dwd_sales_ord_df (
     order_header_id     string comment ''?????????id''
    ,order_detail_id     string comment ''????????????id''
    ,order_date          bigint comment ''????????????''
    ,pay_date            bigint comment ''????????????''
    ,shop_id             string comment ''??????id''
    ,customer_id         string comment ''??????id''
    ,item_id             string comment ''??????id''
    ,quantity            bigint comment ''????????????''
    ,unit_price          double comment ''????????????''
    ,amount              double comment ''?????????''
)comment ''?????????????????????''
PARTITIONED BY (ds string) ;


INSERT OVERWRITE TABLE exam_dwd_sales_ord_df PARTITION(ds = ''${bdp.system.bizdate}'')
select
 d.order_header_id
,d.order_detail_id
,h.order_date
,h.pay_date
,h.shop_id
,h.customer_id
,d.item_id
,d.quantity
,d.unit_price
,d.quantity*d.unit_price-d.dist_amout as amount
from ods_order_header as h join ods_order_detail as d on h.order_header_id = d.order_header_id
where h.ds = ''${bdp.system.bizdate}'' and d.ds= ''${bdp.system.bizdate}''
and h.order_status = 0;
', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (0, 3, 'create table if not exists exam_dws_sales_shop_1d (
     stat_date              string comment ''????????????''
    ,shop_id                string comment ''????????????id''
    ,ord_quantity_1d        bigint comment ''????????????????????????''
    ,ord_amount_1d          double comment ''????????????????????????''
    ,pay_quantity_1d        bigint comment ''????????????????????????''
    ,pay_amount_1d          double comment ''????????????????????????''
)comment ''???????????????????????????????????????''
PARTITIONED BY (ds string) ;

INSERT OVERWRITE TABLE exam_dws_sales_shop_1d PARTITION(ds = ''${bdp.system.bizdate}'')
select
 ''${bdp.system.bizdate}'' as stat_date
,shop_id
,sum(case when order_date = ''${bdp.system.bizdate}'' then quantity end) as ord_quantity_1d
,sum(case when order_date = ''${bdp.system.bizdate}'' then amount end)   as ord_amount_1d
,sum(case when pay_date = ''${bdp.system.bizdate}''   then quantity end) as pay_quantity_1d
,sum(case when pay_date = ''${bdp.system.bizdate}''   then amount end)   as pay_amount_1d
from
exam_dwd_sales_ord_df
where ds = ''${bdp.system.bizdate}''
group by shop_id;', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (0, 4, 'create table if not exists exam_ads_sales_all_d (
     stat_date              string comment ''????????????''
    ,ord_quantity           bigint comment ''????????????''
    ,ord_amount             double comment ''????????????''
    ,pay_quantity           bigint comment ''????????????''
    ,pay_amount             double comment ''????????????''
    ,shop_cnt               bigint comment ''????????????????????????''
)comment ''??????????????????''
PARTITIONED BY (ds string) lifecycle 7;

INSERT OVERWRITE TABLE exam_ads_sales_all_d PARTITION(ds = ''${bdp.system.bizdate}'')
select
 ''${bdp.system.bizdate}'' as stat_date
,sum(ord_quantity_1d) as ord_quantity
,sum(ord_amount_1d)   as ord_amount
,sum(pay_quantity_1d) as pay_quantity
,sum(pay_amount_1d)   as pay_amount
,count(distinct shop_id) as shop_cnt
from
exam_dws_sales_shop_1d
where ds = ''${bdp.system.bizdate}''
group by shop_id;', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (0, 5, 'create table if not exists exam_dim_shop (
     shop_id                string comment ''??????id''
    ,shop_name              string comment ''????????????''
    ,shop_type              string comment ''????????????''
    ,address                string comment ''????????????''
)comment ''???????????????''
PARTITIONED BY (ds string) lifecycle 365;

INSERT OVERWRITE TABLE exam_dim_shop PARTITION(ds = ''${bdp.system.bizdate}'')
select
 shop_id
,shop_name
,shop_type
,address
from exam_ods_shop_info
where ds = ''${bdp.system.bizdate}''
and status = ''open'';', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (15, 0, 'create table if not exists customer_base
(
    id                    varchar(20),
	cust_name             varchar(20),
	cust_phone            varchar(20),
	cust_wechat           varchar(20),
	cust_cefi_number      varchar(20),
	cust_car_number       varchar(20),
	cust_house_number     varchar(20),
	cust_job              varchar(20),
	cust_company          varchar(20),
	cust_work_address     varchar(20),
	cust_bank_number      varchar(20),
	cust_gate_card        varchar(20)
);
-- COMMENT ON customer_base IS ''???????????????'';


create table if not exists customer_in_call
(
    id                        varchar,
    in_call_phone_number      varchar,
    in_call_time              varchar,--????????????????????????????????????????????????libra??????????????????timestamp????????????????????????varchar??????
    in_call_duration          bigint,
    in_call_consult_problem   varchar
);
-- COMMENT ON customer_in_call IS ''?????????????????????'';


create table if not exists customer_in_and_out
(
    id                      varchar,
    cust_gate_card          varchar,
    in_or_out               varchar,
    in_or_out_time          varchar
);
-- COMMENT ON customer_in_and_out IS ''?????????????????????'';


create table if not exists customer_complain(
    id                        varchar,
    complain_phone            varchar,
    complain_name             varchar,
    complain_problem          varchar,
    complain_time             varchar
);

-- COMMENT ON customer_complain IS ''?????????????????????'';

-- --?????????Libra????????????????????????????????????
', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (15, 1, '
create table if not exists ods_order_header (
    order_header_id     varchar,
    order_date          bigint,
    shop_id             bigint,
    customer_id         varchar,
    order_status        bigint,
    pay_date            bigint
);

create table if not exists ods_order_detail (
    order_header_id     varchar,
    order_detail_id     varchar,
    item_id             varchar,
    quantity            varchar,
    unit_price          varchar,
    dist_amout          varchar
);

create table if not exists exam_ods_shop_info (
    shop_id                bigint,
    shop_name              varchar,
    shop_type              varchar,
    address                varchar,
    status                 varchar
);
', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (15, 2, '
create table if not exists exam_dwd_sales_ord_df (
    order_header_id     varchar,
    order_detail_id     varchar,
    order_date          bigint,
    pay_date            bigint,
    shop_id             bigint,
    customer_id         varchar,
    item_id             varchar,
    quantity            varchar,
    unit_price          varchar,
    amount              varchar
);

INSERT INTO exam_dwd_sales_ord_df
select
 d.order_header_id
,d.order_detail_id
,h.order_date
,h.pay_date
,h.shop_id
,h.customer_id
,d.item_id
,d.quantity
,d.unit_price
from ods_order_header as h join ods_order_detail as d
on h.order_header_id = d.order_header_id and h.order_status = 0;
', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (15, 3, 'create table if not exists exam_dws_sales_shop_1d (
     stat_date              string comment ''????????????''
    ,shop_id                string comment ''????????????id''
    ,ord_quantity_1d        bigint comment ''????????????????????????''
    ,ord_amount_1d          double comment ''????????????????????????''
    ,pay_quantity_1d        bigint comment ''????????????????????????''
    ,pay_amount_1d          double comment ''????????????????????????''
)comment ''???????????????????????????????????????''
PARTITIONED BY (ds string) ;

INSERT OVERWRITE TABLE exam_dws_sales_shop_1d PARTITION(ds = ''${bdp.system.bizdate}'')
select
 ''${bdp.system.bizdate}'' as stat_date
,shop_id
,sum(case when order_date = ''${bdp.system.bizdate}'' then quantity end) as ord_quantity_1d
,sum(case when order_date = ''${bdp.system.bizdate}'' then amount end)   as ord_amount_1d
,sum(case when pay_date = ''${bdp.system.bizdate}''   then quantity end) as pay_quantity_1d
,sum(case when pay_date = ''${bdp.system.bizdate}''   then amount end)   as pay_amount_1d
from
exam_dwd_sales_ord_df
where ds = ''${bdp.system.bizdate}''
group by shop_id;
', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (15, 4, 'create table if not exists exam_ads_sales_all_d (
     stat_date              string comment ''????????????''
    ,ord_quantity           bigint comment ''????????????''
    ,ord_amount             double comment ''????????????''
    ,pay_quantity           bigint comment ''????????????''
    ,pay_amount             double comment ''????????????''
    ,shop_cnt               bigint comment ''????????????????????????''
)comment ''??????????????????''
PARTITIONED BY (ds string) lifecycle 7;

INSERT OVERWRITE TABLE exam_ads_sales_all_d PARTITION(ds = ''${bdp.system.bizdate}'')
select
 ''${bdp.system.bizdate}'' as stat_date
,sum(ord_quantity_1d) as ord_quantity
,sum(ord_amount_1d)   as ord_amount
,sum(pay_quantity_1d) as pay_quantity
,sum(pay_amount_1d)   as pay_amount
,count(distinct shop_id) as shop_cnt
from
exam_dws_sales_shop_1d
where ds = ''${bdp.system.bizdate}''
group by shop_id;
', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);
INSERT INTO develop_task_template (task_type, type, content, gmt_create, gmt_modified, is_deleted) VALUES (15, 5, 'create table if not exists exam_dim_shop (
     shop_id                string comment ''??????id''
    ,shop_name              string comment ''????????????''
    ,shop_type              string comment ''????????????''
    ,address                string comment ''????????????''
)comment ''???????????????''
PARTITIONED BY (ds string) lifecycle 365;

INSERT OVERWRITE TABLE exam_dim_shop PARTITION(ds = ''${bdp.system.bizdate}'')
select
 shop_id
,shop_name
,shop_type
,address
from exam_ods_shop_info
where ds = ''${bdp.system.bizdate}''
and status = ''open'';
', '2022-02-12 23:31:50', '2022-02-12 23:31:50', 0);



INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('spark_version', '2.1', '210', null, 2, 1, 'INTEGER', '', 1, '2021-03-02 14:15:23', '2021-03-02 14:15:23', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('spark_thrift_version', '1.x', '1.x', null, 3, 1, 'STRING', '', 0, '2021-03-02 14:16:41', '2021-03-02 14:16:41', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('flink_version', '1.10', '110', null, 1, 2, 'INTEGER', '0,1,2', 0, '2021-03-02 14:14:12', '2021-03-02 14:14:12', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('spark_thrift_version', '2.x', '2.x', null, 3, 2, 'STRING', '', 1, '2021-03-02 14:16:41', '2021-03-02 14:16:41', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_config', 'HDP 3.1.x', '-200', '', 5, 0, 'LONG', 'SPARK', 0, '2021-02-05 11:53:21', '2021-02-05 11:53:21', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'yarn3-hdfs3-spark210', '-108', null, 6, 0, 'LONG', '', 0, '2021-03-04 17:50:23', '2021-03-04 17:50:23', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'yarn2-hdfs2-spark210', '-108', null, 6, 0, 'LONG', '', 0, '2021-03-04 17:50:24', '2021-03-04 17:50:24', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'yarn3-hdfs3-flink110', '-109', null, 6, 0, 'LONG', '', 0, '2021-03-04 17:50:24', '2021-03-04 17:50:24', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'dummy', '-101', null, 6, 0, 'LONG', '', 0, '2021-03-04 17:50:24', '2021-03-04 17:50:24', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'yarn2-hdfs2-flink110', '-109', null, 6, 0, 'LONG', '', 0, '2021-03-04 17:50:24', '2021-03-04 17:50:24', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'hive', '-117', null, 6, 0, 'LONG', '', 0, '2021-03-04 17:50:24', '2021-03-04 17:50:24', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'hive2', '-117', null, 6, 0, 'LONG', '', 0, '2021-03-04 17:50:24', '2021-03-04 17:50:24', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'hive3', '-117', null, 6, 0, 'LONG', '', 0, '2021-03-04 17:50:24', '2021-03-04 17:50:24', 0);


INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'Apache Hadoop 2.x', '2.7.6', null, 0, 1, 'STRING', 'Apache Hadoop', 0, '2021-12-28 10:18:58', '2021-12-28 10:18:58', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'Apache Hadoop 3.x', '3.0.0', null, 0, 2, 'STRING', 'Apache Hadoop', 0, '2021-12-28 10:18:58', '2021-12-28 10:18:58', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'HDP 2.6.x', '2.7.3', null, 0, 1, 'STRING', 'HDP', 0, '2021-12-28 10:18:59', '2021-12-28 10:18:59', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'HDP 3.x', '3.1.1', null, 0, 2, 'STRING', 'HDP', 0, '2021-12-28 10:18:59', '2021-12-28 10:18:59', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'CDH 5.x', '2.3.0', null, 0, 1, 'STRING', 'CDH', 0, '2021-12-28 10:19:00', '2021-12-28 10:19:00', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'CDH 6.0.x', '3.0.0', null, 0, 11, 'STRING', 'CDH', 0, '2021-12-28 10:19:01', '2021-12-28 10:19:01', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'CDH 6.1.x', '3.0.0', null, 0, 12, 'STRING', 'CDH', 0, '2021-12-28 10:19:01', '2021-12-28 10:19:01', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'CDH 6.2.x', '3.0.0', null, 0, 13, 'STRING', 'CDH', 0, '2021-12-28 10:19:01', '2021-12-28 10:19:01', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'CDP 7.x', '3.1.1', null, 0, 15, 'STRING', 'CDH', 0, '2021-12-28 10:19:02', '2021-12-28 10:19:02', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'TDH 5.2.x', '2.7.0', null, 0, 1, 'STRING', 'TDH', 0, '2021-12-28 10:19:02', '2021-12-28 10:19:02', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'TDH 7.x', '2.7.0', null, 0, 2, 'STRING', 'TDH', 0, '2021-12-28 10:19:02', '2021-12-28 10:19:02', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('hadoop_version', 'TDH 6.x', '2.7.0', null, 0, 1, 'STRING', 'TDH', 0, '2021-12-28 11:44:02', '2021-12-28 11:44:02', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model', 'HDFS', '{
	"owner": "STORAGE",
	"dependsOn": ["RESOURCE"],
	"allowCoexistence": false,
	"versionDictionary": "HADOOP_VERSION"
}', null, 12, 0, 'STRING', '', 0, '2021-12-07 11:26:57', '2021-12-07 11:26:57', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model', 'FLINK', '{
	"owner": "COMPUTE",
	"dependsOn": ["RESOURCE", "STORAGE"],
	"allowCoexistence": true,
	"versionDictionary": "FLINK_VERSION"
}', null, 12, 0, 'STRING', '', 0, '2021-12-07 11:26:57', '2021-12-07 11:26:57', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model', 'SPARK', '{
	"owner": "COMPUTE",
	"dependsOn": ["RESOURCE", "STORAGE"],
	"allowCoexistence": true,
	"versionDictionary": "SPARK_VERSION"
}', null, 12, 0, 'STRING', '', 0, '2021-12-07 11:26:57', '2021-12-28 16:54:54', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model', 'SPARK_THRIFT', '{
	"owner": "COMPUTE",
	"dependsOn": ["RESOURCE", "STORAGE"],
	"allowCoexistence": false,
	"versionDictionary": "SPARK_THRIFT_VERSION"
}', null, 12, 0, 'STRING', '', 0, '2021-12-07 11:26:57', '2021-12-07 11:26:57', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model', 'HIVE_SERVER', '{
	"owner": "COMPUTE",
    "dependsOn": ["RESOURCE", "STORAGE"],
	"allowCoexistence": false,
	"versionDictionary": "HIVE_VERSION"
}', null, 12, 0, 'STRING', '', 0, '2021-12-07 11:26:57', '2021-12-07 11:26:57', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model', 'SFTP', '{
	"owner": "COMMON",
	"dependsOn": [],
	"allowCoexistence": false,
	"nameTemplate": "dummy"
}', null, 12, 0, 'STRING', '', 0, '2021-12-07 11:26:57', '2021-12-07 11:26:57', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model', 'YARN', '{
	"owner": "RESOURCE",
	"dependsOn": [],
	"allowCoexistence": false,
	"versionDictionary": "HADOOP_VERSION"
}', null, 12, 0, 'STRING', '', 0, '2021-12-07 11:26:57', '2021-12-07 11:26:57', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'Apache Hadoop 2.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn2-hdfs2-flink180"
            },
            {
                "1.10":"yarn2-hdfs2-flink110"
            },
            {
                "1.12":"yarn2-hdfs2-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn2-hdfs2-spark210",
                "2.4":"yarn2-hdfs2-spark240"
            }
        ],
        "DT_SCRIPT":"yarn2-hdfs2-dtscript",
        "HDFS":"yarn2-hdfs2-hadoop2",
        "TONY":"yarn2-hdfs2-tony",
        "LEARNING":"yarn2-hdfs2-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:01:55', '2021-12-28 11:01:55', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'Apache Hadoop 3.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn3-hdfs3-flink180"
            },
            {
                "1.10":"yarn3-hdfs3-flink110"
            },
            {
                "1.12":"yarn3-hdfs3-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn3-hdfs3-spark210",
                "2.4":"yarn3-hdfs3-spark240"
            }
        ],
        "DT_SCRIPT":"yarn3-hdfs3-dtscript",
        "HDFS":"yarn3-hdfs3-hadoop3",
        "TONY":"yarn3-hdfs3-tony",
        "LEARNING":"yarn3-hdfs3-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:03:45', '2021-12-28 11:03:45', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'HDP 3.0.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn3-hdfs3-flink180"
            },
            {
                "1.10":"yarn3-hdfs3-flink110"
            },
            {
                "1.12":"yarn3-hdfs3-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn3-hdfs3-spark210",
                "2.4":"yarn3-hdfs3-spark240"
            }
        ],
        "DT_SCRIPT":"yarn3-hdfs3-dtscript",
        "HDFS":"yarn3-hdfs3-hadoop3",
        "TONY":"yarn3-hdfs3-tony",
        "LEARNING":"yarn3-hdfs3-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:04:23', '2021-12-28 11:04:23', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'CDH 6.0.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn3-hdfs3-flink180"
            },
            {
                "1.10":"yarn3-hdfs3-flink110"
            },
            {
                "1.12":"yarn3-hdfs3-flink112"
            }
        ],
        "SPARK":[
            {   "2.1":"yarn3-hdfs3-spark210",
                "2.4":"yarn3-hdfs3-spark240"
            }
        ],
        "DT_SCRIPT":"yarn3-hdfs3-dtscript",
        "HDFS":"yarn3-hdfs3-hadoop3",
        "TONY":"yarn3-hdfs3-tony",
        "LEARNING":"yarn3-hdfs3-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:04:40', '2021-12-28 11:04:40', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'CDH 6.1.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn3-hdfs3-flink180"
            },
            {
                "1.10":"yarn3-hdfs3-flink110"
            },
            {
                "1.12":"yarn3-hdfs3-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn3-hdfs3-spark210",
                "2.4":"yarn3-hdfs3-spark240"
            }
        ],
        "DT_SCRIPT":"yarn3-hdfs3-dtscript",
        "HDFS":"yarn3-hdfs3-hadoop3",
        "TONY":"yarn3-hdfs3-tony",
        "LEARNING":"yarn3-hdfs3-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:04:55', '2021-12-28 11:04:55', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'CDH 6.2.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn3-hdfs3-flink180"
            },
            {
                "1.10":"yarn3-hdfs3-flink110"
            },
            {
                "1.12":"yarn3-hdfs3-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn3-hdfs3-spark210",
                "2.4(CDH 6.2)":"yarn3-hdfs3-spark240cdh620"
            }
        ],
        "DT_SCRIPT":"yarn3-hdfs3-dtscript",
        "HDFS":"yarn3-hdfs3-hadoop3",
        "TONY":"yarn3-hdfs3-tony",
        "LEARNING":"yarn3-hdfs3-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:05:06', '2021-12-28 11:05:06', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'HDP 2.6.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn2-hdfs2-flink180"
            },
            {
                "1.10":"yarn2-hdfs2-flink110"
            },
            {
                "1.12":"yarn2-hdfs2-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn2-hdfs2-spark210",
                "2.4":"yarn2-hdfs2-spark240"
            }
        ],
        "DT_SCRIPT":"yarn2-hdfs2-dtscript",
        "HDFS":"yarn2-hdfs2-hadoop2",
        "TONY":"yarn2-hdfs2-tony",
        "LEARNING":"yarn2-hdfs2-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:06:38', '2021-12-28 11:06:38', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'CDH 5.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn2-hdfs2-flink180"
            },
            {
                "1.10":"yarn2-hdfs2-flink110"
            },
            {
                "1.12":"yarn2-hdfs2-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn2-hdfs2-spark210",
                "2.4":"yarn2-hdfs2-spark240"
            }
        ],
        "DT_SCRIPT":"yarn2-hdfs2-dtscript",
        "HDFS":"yarn2-hdfs2-hadoop2",
        "TONY":"yarn2-hdfs2-tony",
        "LEARNING":"yarn2-hdfs2-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:07:19', '2021-12-28 11:07:19', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'HDP 3.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn3-hdfs3-flink180"
            },
            {
                "1.10":"yarn3-hdfs3-flink110"
            },
            {
                "1.12":"yarn3-hdfs3-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn3-hdfs3-spark210",
                "2.4":"yarn3-hdfs3-spark240"
            }
        ],
        "DT_SCRIPT":"yarn3-hdfs3-dtscript",
        "HDFS":"yarn3-hdfs3-hadoop3",
        "TONY":"yarn3-hdfs3-tony",
        "LEARNING":"yarn3-hdfs3-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:43:05', '2021-12-28 11:43:05', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'TDH 5.2.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn2-hdfs2-flink180"
            },
            {
                "1.10":"yarn2-hdfs2-flink110"
            },
            {
                "1.12":"yarn2-hdfs2-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn2-hdfs2-spark210",
                "2.4":"yarn2-hdfs2-spark240"
            }
        ],
        "DT_SCRIPT":"yarn2-hdfs2-dtscript",
        "HDFS":"yarn2-hdfs2-hadoop2",
        "TONY":"yarn2-hdfs2-tony",
        "LEARNING":"yarn2-hdfs2-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:44:33', '2021-12-28 11:44:33', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'TDH 6.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn2-hdfs2-flink180"
            },
            {
                "1.10":"yarn2-hdfs2-flink110"
            },
            {
                "1.12":"yarn2-hdfs2-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn2-hdfs2-spark210",
                "2.4":"yarn2-hdfs2-spark240"
            }
        ],
        "DT_SCRIPT":"yarn2-hdfs2-dtscript",
        "HDFS":"yarn2-hdfs2-hadoop2",
        "TONY":"yarn2-hdfs2-tony",
        "LEARNING":"yarn2-hdfs2-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:44:43', '2021-12-28 11:44:43', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'TDH 7.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn2-hdfs2-flink180"
            },
            {
                "1.10":"yarn2-hdfs2-flink110"
            },
            {
                "1.12":"yarn2-hdfs2-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn2-hdfs2-spark210",
                "2.4":"yarn2-hdfs2-spark240"
            }
        ],
        "DT_SCRIPT":"yarn2-hdfs2-dtscript",
        "HDFS":"yarn2-hdfs2-hadoop2",
        "TONY":"yarn2-hdfs2-tony",
        "LEARNING":"yarn2-hdfs2-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:45:02', '2021-12-28 11:45:02', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'CDP 7.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
            {
                "1.8":"yarn3-hdfs3-flink180"
            },
            {
                "1.10":"yarn3-hdfs3-flink110"
            },
            {
                "1.12":"yarn3-hdfs3-flink112"
            }
        ],
        "SPARK":[
            {
                "2.1":"yarn3-hdfs3-spark210",
                "2.4":"yarn3-hdfs3-spark240"
            }
        ],
        "DT_SCRIPT":"yarn3-hdfs3-dtscript",
        "HDFS":"yarn3-hdfs3-hadoop3",
        "TONY":"yarn3-hdfs3-tony",
        "LEARNING":"yarn3-hdfs3-learning"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:45:02', '2021-12-28 11:45:02', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', '1.x', '{
    "1.x":"hive"
}', null, 14, 1, 'STRING', 'HIVE_SERVER', 0, '2021-12-31 14:53:44', '2021-12-31 14:53:44', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', '2.x', '{
    "2.x":"hive2"
}', null, 14, 1, 'STRING', 'HIVE_SERVER', 0, '2021-12-31 14:53:44', '2021-12-31 14:53:44', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', '3.x-apache', '{
    "3.x-apache":"hive3"
}', null, 14, 1, 'STRING', 'HIVE_SERVER', 0, '2021-12-31 14:53:44', '2021-12-31 14:53:44', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', '3.x-cdp', '{
    "3.x-cdp":"hive3"
}', null, 14, 1, 'STRING', 'HIVE_SERVER', 0, '2021-12-31 14:53:44', '2021-12-31 14:53:44', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', '1.x', '{
    "1.x":"hive"
}', null, 14, 1, 'STRING', 'SPARK_THRIFT', 0, '2021-12-31 15:00:16', '2021-12-31 15:00:16', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', '2.x', '{
    "2.x":"hive2"
}', null, 14, 1, 'STRING', 'SPARK_THRIFT', 0, '2021-12-31 15:00:16', '2021-12-31 15:00:16', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('SPARK_SQL', 'SPARK_SQL', '0', 'SparkSQL', 30, 1, 'STRING', '', 1, '2022-02-11 10:28:45', '2022-02-11 10:28:45', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('SYNC', '????????????', '2', '????????????', 30, 5, 'STRING', '', 1, '2022-02-11 10:28:45', '2022-02-11 10:28:45', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('VIRTUAL', '?????????', '-1', '?????????', 30, 11, 'STRING', '', 1, '2022-02-11 10:28:45', '2022-02-11 10:28:45', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('ResourceManager', 'ResourceManager', '3', '????????????', 31, 3, 'STRING', '', 1, '2022-02-11 10:40:14', '2022-02-11 10:40:14', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('SparkSQLFunction', 'SparkSQLFunction', '4', 'SparkSQL', 31, 4, 'STRING', '', 1, '2022-02-11 10:40:14', '2022-02-11 10:40:14', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('TableQuery', 'TableQuery', '5', '?????????', 31, 5, 'STRING', '', 1, '2022-02-11 10:40:14', '2022-02-11 10:40:14', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('TaskDevelop', 'TaskDevelop', '1', '????????????', 31, 1, 'STRING', '', 1, '2022-02-11 10:40:14', '2022-02-11 10:40:14', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('FunctionManager', 'FunctionManager', '4', '????????????', 32, 4, 'STRING', '', 1, '2022-02-11 10:42:19', '2022-02-11 10:42:19', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('ResourceManager', 'ResourceManager', '3', '????????????', 32, 3, 'STRING', '', 1, '2022-02-11 10:42:19', '2022-02-11 10:42:19', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('TaskManager', 'TaskManager', '1', '????????????', 32, 1, 'STRING', '', 1, '2022-02-11 10:42:19', '2022-02-11 10:42:19', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('CustomFunction', 'CustomFunction', '6', '???????????????', 33, 4, 'STRING', '', 1, '2022-02-11 10:42:57', '2022-02-11 10:42:57', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('SystemFunction', 'SystemFunction', '6', '????????????', 33, 2, 'STRING', '', 1, '2022-02-11 10:42:57', '2022-02-11 10:42:57', 0);


INSERT INTO task_param_template (task_type, task_name, task_version, params, gmt_create, gmt_modified, is_deleted) VALUES (0, 'SPARK_SQL', '2.1', '## Driver???????????????CPU??????,?????????1
# driver.cores=1

## Driver????????????????????????,??????512m
# driver.memory=512m

## ???Spark??????action????????????????????????????????????1M????????????0?????????????????????
## ???Job??????????????????????????????????????????????????????????????????????????????OOM???????????????1g
# driver.maxResultSize=1g

## ?????????executor?????????????????????1
executor.instances=1

## ??????executor?????????CPU??????????????????1
executor.cores=1

## ??????executor????????????,??????512m
executor.memory=512m

## ???????????????, ????????????????????????????????????:1-1000
job.priority=10

## spark ??????????????????ALL, DEBUG, ERROR, FATAL, INFO, OFF, TRACE, WARN
# logLevel = INFO

## spark??????????????????????????????????????????
# spark.network.timeout=120s

## executor???OffHeap????????????spark.executor.memory????????????
# spark.yarn.executor.memoryOverhead', '2021-11-18 10:36:13', '2021-11-18 10:36:13', 0);
INSERT INTO task_param_template (task_type, task_name, task_version, params, gmt_create, gmt_modified, is_deleted) VALUES (2, 'SYNC', '1.10', '## ?????????????????????
## per_job:?????????????????????flink yarn session??????????????????????????????????????????
## session???????????????????????????flink yarn session???????????????????????????????????????????????????per_job
## flinkTaskRunMode=per_job
## per_job?????????jobManager??????????????????????????????1024?????????M)
## jobmanager.memory.mb=1024
## per_job?????????taskManager??????????????????????????????1024?????????M???
## taskmanager.memory.mb=1024
## per_job???????????????taskManager ?????? slot?????????
## slots=1
## checkpoint??????????????????
## flink.checkpoint.interval=300000
## ???????????????, ??????:1-1000
## job.priority=10', '2021-11-18 10:37:24', '2021-11-18 10:37:24', 0);


INSERT INTO tenant (tenant_name, tenant_desc, gmt_create, gmt_modified, create_user_id, is_deleted) VALUES ('taier', null, '2021-08-13 16:39:40', '2021-08-13 16:39:40', 1, 0);
INSERT INTO user (user_name, password, phone_number, email, status, gmt_create, gmt_modified, is_deleted) VALUES ('admin@dtstack.com', '0192023A7BBD73250516F069DF18B500', '', 'admin@dtstack.com', 0, '2017-06-05 20:35:16', '2017-06-05 20:35:16', 0);