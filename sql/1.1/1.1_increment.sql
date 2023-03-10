DELETE FROM dict WHERE dict_code = 'flink_version' AND dict_value IN ('110','112');
DELETE FROM dict WHERE dict_code = 'typename_mapping' AND dict_value IN ('yarn2-hdfs2-flink110','yarn2-hdfs2-flink110');

DELETE FROM console_component_config WHERE cluster_id = -2 and component_type_code = 0;

INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('flink_version', '1.12', '112', null, 1, 2, 'INTEGER', '0,1,2', 0, now(),now(), 0);

DELETE FROM dict WHERE dict_code = 'component_model_config' AND depend_name = 'YARN';

INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'Apache Hadoop 2.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn2-hdfs2-hadoop2"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:01:55', '2021-12-28 11:01:55', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'Apache Hadoop 3.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn3-hdfs3-hadoop3"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:03:45', '2021-12-28 11:03:45', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'HDP 3.0.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn3-hdfs3-hadoop3"
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
        "HDFS":"yarn3-hdfs3-hadoop3"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:04:40', '2021-12-28 11:04:40', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'CDH 6.1.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn3-hdfs3-hadoop3"
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
        "HDFS":"yarn2-hdfs2-hadoop2"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:06:38', '2021-12-28 11:06:38', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'CDH 5.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn2-hdfs2-hadoop2"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:07:19', '2021-12-28 11:07:19', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'HDP 3.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn3-hdfs3-hadoop3"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:43:05', '2021-12-28 11:43:05', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'TDH 5.2.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn2-hdfs2-hadoop2"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:44:33', '2021-12-28 11:44:33', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'TDH 6.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn2-hdfs2-hadoop2"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:44:43', '2021-12-28 11:44:43', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'TDH 7.x', '{
    "YARN":"yarn2",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn2-hdfs2-hadoop2"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:45:02', '2021-12-28 11:45:02', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('component_model_config', 'CDP 7.x', '{
    "YARN":"yarn3",
    "HDFS":{
        "FLINK":[
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
        "HDFS":"yarn3-hdfs3-hadoop3"
    }
}', null, 14, 1, 'STRING', 'YARN', 0, '2021-12-28 11:45:02', '2021-12-28 11:45:02', 0);

INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'yarn2-hdfs2-flink112', '-115', null, 6, 0, 'LONG', '', 0, '2021-05-18 11:29:00', '2021-05-18 11:29:00', 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('typename_mapping', 'yarn3-hdfs3-flink112', '-115', null, 6, 0, 'LONG', '', 0, '2021-05-18 11:29:00', '2021-05-18 11:29:00', 0);


INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'CHECKBOX', 1, 'deploymode', '["perjob","session"]', null, '', '', null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'GROUP', 1, 'perjob', 'perjob', null, 'deploymode', 'perjob', null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'akka.ask.timeout', '60 s', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'classloader.dtstack-cache', 'true', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'classloader.resolve-order', 'child-first', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'clusterMode', 'perjob', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'env.java.opts', '-XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:MaxMetaspaceSize=500m -Dfile.encoding=UTF-8', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'flinkLibDir', '/data/insight_plugin1.12/flink_lib', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'flinkxDistDir', '/data/insight_plugin1.12/flinkxplugin', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'jobmanager.memory.process.size', '1600m', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'high-availability', 'ZOOKEEPER', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'taskmanager.memory.process.size', '2048m', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'high-availability.storageDir', 'hdfs://ns1/dtInsight/flink112/ha', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'high-availability.zookeeper.path.root', '/flink112', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'high-availability.zookeeper.quorum', '', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'taskmanager.numberOfTaskSlots', '1', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'jobmanager.archive.fs.dir', 'hdfs://ns1/dtInsight/flink112/completed-jobs', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'metrics.reporter.promgateway.class', 'org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'SELECT', 1, 'metrics.reporter.promgateway.deleteOnShutdown', 'true', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, '', 1, 'false', 'false', null, 'deploymode$perjob$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, '', 1, 'true', 'true', null, 'deploymode$perjob$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'metrics.reporter.promgateway.host', '', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'metrics.reporter.promgateway.jobName', '112job', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'metrics.reporter.promgateway.port', '9091', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'SELECT', 1, 'metrics.reporter.promgateway.randomJobNameSuffix', 'true', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, '', 1, 'false', 'false', null, 'deploymode$perjob$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, '', 1, 'true', 'true', null, 'deploymode$perjob$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'monitorAcceptedApp', 'false', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'pluginLoadMode', 'shipfile', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'prometheusHost', '', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'prometheusPort', '9090', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'state.backend', 'RocksDB', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'state.backend.incremental', 'true', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'state.checkpoints.dir', 'hdfs://ns1/dtInsight/flink112/checkpoints', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'state.checkpoints.num-retained', '11', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'state.savepoints.dir', 'hdfs://ns1/dtInsight/flink112/savepoints', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'yarn.application-attempt-failures-validity-interval', '3600000', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'yarn.application-attempts', '3', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'yarnAccepterTaskNumber', '3', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'GROUP', 1, 'session', 'session', null, 'deploymode', 'session', null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'checkSubmitJobGraphInterval', '60', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'classloader.dtstack-cache', 'true', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'classloader.resolve-order', 'parent-first', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'clusterMode', 'session', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'env.java.opts', '-XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:MaxMetaspaceSize=500m -Dfile.encoding=UTF-8', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'flinkLibDir', '/data/insight_plugin1.12/flink_lib', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'flinkxDistDir', '/data/insight_plugin1.12/flinkxplugin', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'slotmanager.number-of-slots.max', '10', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'jobmanager.memory.process.size', '1600m', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'high-availability', 'NONE', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'taskmanager.memory.process.size', '2048m', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'high-availability.storageDir', 'hdfs://ns1/dtInsight/flink112/ha', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'high-availability.zookeeper.path.root', '/flink112', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'high-availability.zookeeper.quorum', '', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'jobmanager.archive.fs.dir', 'hdfs://ns1/dtInsight/flink112/completed-jobs', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'metrics.reporter.promgateway.class', 'org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'SELECT', 1, 'metrics.reporter.promgateway.deleteOnShutdown', 'true', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, '', 1, 'false', 'false', null, 'deploymode$session$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, '', 1, 'true', 'true', null, 'deploymode$session$metrics.reporter.promgateway.deleteOnShutdown', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'metrics.reporter.promgateway.host', '', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'metrics.reporter.promgateway.jobName', '112job', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'metrics.reporter.promgateway.port', '9091', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'SELECT', 1, 'metrics.reporter.promgateway.randomJobNameSuffix', 'true', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, '', 1, 'false', 'false', null, 'deploymode$session$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, '', 1, 'true', 'true', null, 'deploymode$session$metrics.reporter.promgateway.randomJobNameSuffix', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'monitorAcceptedApp', 'false', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'pluginLoadMode', 'shipfile', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'prometheusHost', '', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'prometheusPort', '9090', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'sessionRetryNum', '5', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'sessionStartAuto', 'true', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'state.backend', 'RocksDB', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'state.backend.incremental', 'true', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'state.checkpoints.dir', 'hdfs://ns1/dtInsight/flink112/checkpoints', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'state.checkpoints.num-retained', '11', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'state.savepoints.dir', 'hdfs://ns1/dtInsight/flink112/savepoints', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'taskmanager.numberOfTaskSlots', '1', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'yarn.application-attempt-failures-validity-interval', '3600000', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'yarn.application-attempts', '3', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'yarnAccepterTaskNumber', '3', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'remoteFlinkxDistDir', '/data/insight_plugin1.12/flinkxplugin', null, 'deploymode$perjob', null, null, '2021-07-27 13:56:15', '2021-07-27 13:56:15', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'akka.tcp.timeout', '60 s', null, 'deploymode$perjob', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'remoteFlinkxDistDir', '/data/insight_plugin1.12/flinkxplugin', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'flinkSessionName', 'flink_session', null, 'deploymode$session', null, null, '2021-07-27 13:52:46', '2021-07-27 13:52:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'checkpoint.retain.time', '7', null, 'deploymode$perjob', null, null, '2021-08-24 17:22:06', '2021-08-24 17:22:06', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'remoteFlinkLibDir', '/data/insight_plugin1.12/flink_lib', null, 'deploymode$perjob', null, null, '2021-08-24 20:40:39', '2021-08-24 20:40:39', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 1, 'remoteFlinkLibDir', '/data/insight_plugin1.12/flink_lib', null, 'deploymode$session', null, null, '2021-08-24 20:41:46', '2021-08-24 20:41:46', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'restart-strategy', 'failure-rate', null, 'deploymode$perjob', null, null, '2021-09-24 12:07:31', '2021-09-24 12:07:31', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'restart-strategy.failure-rate.delay', '10s', null, 'deploymode$perjob', null, null, '2021-09-24 12:07:31', '2021-09-24 12:07:31', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'restart-strategy.failure-rate.failure-rate-intervalattempts', '5 min', null, 'deploymode$perjob', null, null, '2021-09-24 12:07:31', '2021-09-24 12:07:31', 0);
INSERT INTO console_component_config (cluster_id, component_id, component_type_code, type, required, `key`, value, `values`, dependencyKey, dependencyValue, `desc`, gmt_create, gmt_modified, is_deleted) VALUES (-2, -115, 0, 'INPUT', 0, 'restart-strategy.failure-rate.max-failures-per-interval', '3', null, 'deploymode$perjob', null, null, '2021-09-24 12:07:31', '2021-09-24 12:07:31', 0);


create table schedule_job_history
(
    id              int auto_increment
        primary key,
    job_id          varchar(32)                          not null comment '????????????id',
    exec_start_time datetime                             null comment '??????????????????',
    exec_end_time   datetime                             null comment '??????????????????',
    engine_job_id   varchar(256)                         null comment '??????id',
    application_id  varchar(256)                         null comment 'applicationId',
    gmt_create      datetime   default CURRENT_TIMESTAMP not null comment '????????????',
    gmt_modified    datetime   default CURRENT_TIMESTAMP not null comment '????????????',
    is_deleted      tinyint(1) default 0                 not null comment '0?????? 1????????????'
)
    charset = utf8;

create index index_engine_job_id
    on schedule_job_history (engine_job_id(128));

create index index_job_id
    on schedule_job_history (job_id, is_deleted);


ALTER TABLE `develop_task` ADD COLUMN `source_str` longtext COMMENT '?????????' AFTER `component_version`,
ADD COLUMN `target_str` longtext COMMENT '?????????' AFTER `source_str`,
ADD COLUMN `setting_str` longtext COMMENT '??????' AFTER `target_str`,
ADD COLUMN `create_model` tinyint COMMENT '???????????? 0 ????????????  1 ????????????' AFTER `setting_str`,
ADD COLUMN `side_str` longtext COMMENT '??????' AFTER `target_str`,
ADD COLUMN `job_id` varchar(64) default null AFTER `side_str`
;


drop table if exists develop_task_template;
drop table if exists task_template;

CREATE TABLE `task_template` (
                                 `id` bigint(20) NOT NULL AUTO_INCREMENT,
                                 `task_type` int(11) DEFAULT '0' COMMENT '????????????',
                                 `type` int(11) DEFAULT NULL COMMENT '????????????',
                                 `value_type` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '???????????????',
                                 `content` text COLLATE utf8_bin COMMENT '?????????',
                                 `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP,
                                 `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP,
                                 `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0?????? 1????????????',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (1, 0, 1, '1', 'create table if not exists ods_order_header (
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
PARTITIONED BY (ds string) ;', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (3, 0, 1, '2', 'create table if not exists exam_dwd_sales_ord_df (
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
', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (5, 0, 1, '3', 'create table if not exists exam_dws_sales_shop_1d (
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
group by shop_id;', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (7, 0, 1, '4', 'create table if not exists exam_ads_sales_all_d (
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
group by shop_id;', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (9, 0, 1, '5', 'create table if not exists exam_dim_shop (
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
and status = ''open'';', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (11, 15, 1, '0', 'create table if not exists customer_base
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
', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (13, 15, 1, '1', '
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
', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (15, 15, 1, '2', '
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
', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (17, 15, 1, '3', 'create table if not exists exam_dws_sales_shop_1d (
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
', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (19, 15, 1, '4', 'create table if not exists exam_ads_sales_all_d (
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
', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (21, 15, 1, '5', 'create table if not exists exam_dim_shop (
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
', '2022-04-13 14:30:03', '2022-04-13 14:30:03', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (31, 0, 0, '2.1', '## Driver???????????????CPU??????,?????????1
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
# spark.yarn.executor.memoryOverhead', '2022-04-13 14:30:53', '2022-04-13 14:30:53', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (33, 2, 0, '1.10', '## ?????????????????????
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
## job.priority=10', '2022-04-13 14:30:53', '2022-04-13 14:30:53', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (35, 5, 0, '1.12', '## ????????????
parallelism.default=1
taskmanager.numberOfTaskSlots=1
jobmanager.memory.process.size=1g
taskmanager.memory.process.size=2g

## ????????????
## ??????Flink??????????????????ProcessingTime,EventTime,IngestionTime??????
## ????????????????????????Kafka????????????????????????????????????ProcessingTime
# pipeline.time-characteristic=EventTime

## Checkpoint??????
## ??????checkpoint?????????????????????????????????????????????:5??????,???????????????????????????checkpoint??????
execution.checkpointing.interval=5min
## ??????????????????,????????????EXACTLY_ONCE,AT_LEAST_ONCE????????????EXACTLY_ONCE
# execution.checkpointing.mode=EXACTLY_ONCE
##?????????????????????hdfs??????checkpoint??????
execution.checkpointing.externalized-checkpoint-retention=RETAIN_ON_CANCELLATION

# Flink SQL???????????????????????????
table.exec.state.ttl=1d

log.level=INFO

## ??????Iceberg???Hive????????????
# table.dynamic-table-options.enabled=true

## Kerberos??????
# security.kerberos.login.contexts=Client,KafkaClient


## ????????????
## ????????????????????????
# table.exec.emit.early-fire.enabled=true
# table.exec.emit.early-fire.delay=1s

## ??????????????????????????????????????????????????????????????????????????????????????????
# table.exec.source.idle-timeout=10ms

## ????????????minibatch
## ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
# table.exec.mini-batch.enabled=true
## ??????????????????
# table.exec.mini-batch.allow-latency=5s
## ????????????????????????
# table.exec.mini-batch.size=5000

## ????????????Local-Global ???????????????????????????minibatch
## ????????????????????????????????????????????????????????? MapReduce ?????? Combine + Reduce ??????
# table.optimizer.agg-phase-strategy=TWO_PHASE

## ?????????????????? distinct ??????
## Local-Global ?????????????????????????????????????????? distinct ??????????????????????????????????????????
## ??????SELECT day, COUNT(DISTINCT user_id) FROM T GROUP BY day ?????? distinct key ?????? user_id????????????????????????????????????
# table.optimizer.distinct-agg.split.enabled=true


## Flink??????chaining??????????????????true??????????????????????????????????????????false?????????????????????
# pipeline.operator-chaining=true', '2022-04-13 14:30:53', '2022-04-13 14:30:53', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (36, 6, 0, '1.12', '## ????????????
parallelism.default=1
taskmanager.numberOfTaskSlots=1
jobmanager.memory.process.size=1g
taskmanager.memory.process.size=2g

## ????????????
## ??????Flink??????????????????ProcessingTime,EventTime,IngestionTime??????
## ????????????????????????Kafka????????????????????????????????????ProcessingTime
# pipeline.time-characteristic=EventTime

## Checkpoint??????
## ??????checkpoint?????????????????????????????????????????????:5??????,???????????????????????????checkpoint??????
execution.checkpointing.interval=5min
## ??????????????????,????????????EXACTLY_ONCE,AT_LEAST_ONCE????????????EXACTLY_ONCE
# execution.checkpointing.mode=EXACTLY_ONCE
##?????????????????????hdfs??????checkpoint??????
execution.checkpointing.externalized-checkpoint-retention=RETAIN_ON_CANCELLATION

# Flink SQL???????????????????????????
table.exec.state.ttl=1d

log.level=INFO

## ??????Iceberg???Hive????????????
# table.dynamic-table-options.enabled=true

## Kerberos??????
# security.kerberos.login.contexts=Client,KafkaClient


## ????????????
## ????????????????????????
# table.exec.emit.early-fire.enabled=true
# table.exec.emit.early-fire.delay=1s

## ??????????????????????????????????????????????????????????????????????????????????????????
# table.exec.source.idle-timeout=10ms

## ????????????minibatch
## ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
# table.exec.mini-batch.enabled=true
## ??????????????????
# table.exec.mini-batch.allow-latency=5s
## ????????????????????????
# table.exec.mini-batch.size=5000

## ????????????Local-Global ???????????????????????????minibatch
## ????????????????????????????????????????????????????????? MapReduce ?????? Combine + Reduce ??????
# table.optimizer.agg-phase-strategy=TWO_PHASE

## ?????????????????? distinct ??????
## Local-Global ?????????????????????????????????????????? distinct ??????????????????????????????????????????
## ??????SELECT day, COUNT(DISTINCT user_id) FROM T GROUP BY day ?????? distinct key ?????? user_id????????????????????????????????????
# table.optimizer.distinct-agg.split.enabled=true


## Flink??????chaining??????????????????true??????????????????????????????????????????false?????????????????????
# pipeline.operator-chaining=true', '2022-04-13 14:30:53', '2022-04-13 14:30:53', 0);
INSERT INTO task_template (id, task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (37, 17, 0, '', '## ??????mapreduce???yarn?????????????????????????????????????????????????????????
#hiveconf:mapreduce.job.name=

## ??????mapreduce?????????????????????????????????????????????queue
# hiveconf:mapreduce.job.queuename=default_queue_name

## hivevar??????,?????????????????????
#hivevar:ageParams=30## ??????mapreduce???yarn?????????????????????????????????????????????????????????
#hiveconf:mapreduce.job.name=

## ??????mapreduce?????????????????????????????????????????????queue
# hiveconf:mapreduce.job.queuename=default_queue_name

## hivevar??????,?????????????????????
#hivevar:ageParams=30', '2022-04-13 14:30:53', '2022-04-13 14:30:53', 0);


INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type,
                  depend_name, is_default, gmt_create, gmt_modified, is_deleted)
VALUES ('hive_version', '1.x', '1.x', null, 4, 1, 'STRING', '', 0, now(),now(), 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type,
                  depend_name, is_default, gmt_create, gmt_modified, is_deleted)
VALUES ('hive_version', '2.x', '2.x', null, 4, 2, 'STRING', '', 1, now(),now(), 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type,
                  depend_name, is_default, gmt_create, gmt_modified, is_deleted)
VALUES ('hive_version', '3.x-apache', '3.x-apache', null, 4, 3, 'STRING', '', 1, now(),now(), 0);
INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type,
                  depend_name, is_default, gmt_create, gmt_modified, is_deleted)
VALUES ('hive_version', '3.x-cdp', '3.x-cdp', null, 4, 3, 'STRING', '', 1, now(),now(), 0);


INSERT INTO task_template (task_type, type, value_type, content, gmt_create, gmt_modified, is_deleted) VALUES (7, 0, '', '## ??????mapreduce???yarn?????????????????????????????????????????????????????????
#hiveconf:mapreduce.job.name=

## ??????mapreduce?????????????????????????????????????????????queue
# hiveconf:mapreduce.job.queuename=default_queue_name

## hivevar??????,?????????????????????
#hivevar:ageParams=30## ??????mapreduce???yarn?????????????????????????????????????????????????????????
#hiveconf:mapreduce.job.name=

## ??????mapreduce?????????????????????????????????????????????queue
# hiveconf:mapreduce.job.queuename=default_queue_name

## hivevar??????,?????????????????????
#hivevar:ageParams=30', '2021-11-18 10:36:13', '2021-11-18 10:36:13', 0);




begin;
INSERT into develop_catalogue(tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type) VALUES ( -1, 'Flink????????????', 0, 3, 1, now(), now(), -1, 0, 0);
set @stream_sys_id=(select id from develop_catalogue where node_name='Flink????????????');
INSERT into develop_catalogue(tenant_id, node_name, node_pid, order_val, level, gmt_create, gmt_modified, create_user_id, is_deleted, catalogue_type)
VALUES (-1,'????????????',@stream_sys_id,3, 1, '2022-04-12 23:33:10', '2022-04-12 23:33:10', -1, 0, 0),
       (-1,'????????????',@stream_sys_id,3, 1, '2022-04-12 23:33:10', '2022-04-12 23:33:10', -1, 0, 0),
       (-1,'????????????',@stream_sys_id,3, 1, '2022-04-12 23:33:10', '2022-04-12 23:33:10', -1, 0, 0),
       (-1,'????????????',@stream_sys_id,3, 1, '2022-04-12 23:33:10', '2022-04-12 23:33:10', -1, 0, 0),
       (-1,'????????????',@stream_sys_id,3, 1, '2022-04-12 23:33:10', '2022-04-12 23:33:10', -1, 0, 0);
commit;

ALTER TABLE `develop_function` ADD COLUMN `udf_type` int COMMENT '????????????' AFTER `type`;

begin;
set @math=(select id from develop_catalogue where node_name='????????????' and node_pid = (select id from develop_catalogue where node_name='Flink????????????'));
INSERT INTO `develop_function`(name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, udf_type, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text)
VALUES ('POWER', '', '????????????', 'POWER(numeric1, numeric2)', '?????? numeric1 ??? numeric2 ??????.', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('ABS', '', '??????numeric????????????', 'ABS(numeric)', '??????numeric????????????.', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('MOD', '', 'numeric1 ??? numeric2 ??????', 'MOD(numeric1, numeric2)', '??????numeric1??????numeric2?????????(??????). ??????numeric1?????????????????????.', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('SQRT', '', '???????????????', 'SQRT(numeric)', '??????numeric?????????.', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('LN', '', '	????????????????????????', 'LN(numeric)', '??????numeric???????????????(???e??????)', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('LOG10', '', '	????????????10?????????', 'LOG10(numeric) ', '??????numeric?????????(???10??????)', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('EXP', '', '	???????????????????????????', 'EXP(numeric)', '??????????????????e???numeric?????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('CEIL', '', '????????????', 'CEIL(numeric) or CEILING(numeric)', '???????????????????????????????????????????????????ceil(6.1)= ceil(6.9) = 7', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('FLOOR', '', '????????????', 'FLOOR(numeric)', '????????????????????????????????????????????????FLOOR(6.1)= FLOOR(6.9) = 6', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('SIN', '', '???????????????', 'SIN(numeric)', '???????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('COS', '', '???????????????', 'COS(numeric)', '???????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('TAN', '', '???????????????', 'TAN(numeric)', '???????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('COT', '', '???????????????', 'COT(numeric)', '???????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('ASIN', '', '??????????????????', 'ASIN(numeric)', '??????????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('ACOS', '', '??????????????????', 'ACOS(numeric)', '??????????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('ATAN', '', '??????????????????', 'ATAN(numeric)', '??????????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('DEGREES', '', '????????????????????????', 'DEGREES(numeric)', '????????????????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('RADIANS', '', '??????????????????????????????', 'RADIANS(numeric)', '??????????????????????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('SIGN', '', '?????????????????????', 'SIGN(numeric)', '??????numeric??????????????????1.0, ??????????????????-1.0, ????????????0.0 ', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('ROUND', '', '????????????', 'ROUND(numeric, int)', '??????numeric?????????int?????????????????????', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('PI', '', '???????????????pi', 'PI()', '???????????????pi', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('E', '', '???????????????e', 'E()', '???????????????e', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('RAND', '', '????????????', 'RAND() or RAND(seed integer)', '????????????0???1?????????????????????,??????????????????seed?????????????????????????????????????????????.', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('RAND_INTEGER', '', '????????????', 'RAND_INTEGER(bound integer) or RAND_INTEGER(seed integer, bound integer) ', '??????0.0(??????)????????????(?????????)???????????????????????????, ??????????????????seed????????????????????????????????????????????? ', @math, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('LOG', '', '????????????', 'LOG(x numeric) or LOG(base numeric, x numeric)', '?????????base ???????????????e??????', @math,  -1, -1, -1, 0, 1, 5, now(), now(), 0, null);

set @date=(select id from develop_catalogue where node_name='????????????' and node_pid = (select id from develop_catalogue where node_name='Flink????????????'));
INSERT INTO `develop_function`(name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, udf_type, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text)
VALUES ('EXTRACT', '', '?????????????????????????????????', 'EXTRACT(timeintervalunit FROM temporal)', '???????????????????????????,??????????????????, ?????? EXTRACT(DAY FROM DATE \'2006-06-05\') ?????? 5.', @date,  -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('QUARTER', '', '????????????', 'QUARTER(date)', '???????????????????????????????????? ???QUARTER(DATE \'1994-09-27\') ?????? 3', @date, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('DATE_FORMAT', '', '???????????????', 'DATE_FORMAT(timestamp, format)', '????????????format ?????????timestamp ??????????????????, format ?????????mysql????????????????????????(date_parse), ??????:DATE_FORMAT(ts, \'%Y, %d %M\') results in strings formatted as \'2017, 05 May\'', @date,  -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('TIMESTAMPADD', '', '??????????????????', 'TIMESTAMPADD(unit, interval, timestamp)', '???(?????????)??????interval?????????timestamp. interval????????????unit????????????, ??????????????????????????????SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, or YEAR. ?????????TIMESTAMPADD(WEEK, 1, \'2003-01-02\') ?????? 2003-01-09', @date,  -1, -1, -1, 0, 1, 5, now(), now(), 0, null);


set @char=(select id from develop_catalogue where node_name='????????????' and node_pid = (select id from develop_catalogue where node_name='Flink????????????'));
INSERT INTO `develop_function`(name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, udf_type, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text)
VALUES ('CHAR_LENGTH', '', '?????????????????????', 'CHAR_LENGTH(string)', '????????????????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('CHARACTER_LENGTH', '', '?????????????????????', 'CHARACTER_LENGTH(string)', '????????????????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('UPPER', '', '??????????????????????????????????????????', 'UPPER(string)', '??????????????????????????????????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('LOWER', '', '??????????????????????????????????????????', 'LOWER(string)', '??????????????????????????????????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('POSITION', '', '??????string2??????????????????string1?????????', 'POSITION(string1 IN string2)', '??????string2??????????????????string1?????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('TRIM', '', '??????????????????', 'TRIM( { BOTH | LEADING | TRAILING } string1 FROM string2)', '???string2 ????????????????????????String1, ??????????????????????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('OVERLAY', '', '???????????????', 'OVERLAY(string1 PLACING string2 FROM integer [ FOR integer2 ])', '???string2??????string1???????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('SUBSTRING', '', '???????????????', 'SUBSTRING(string FROM integer) or SUBSTRING(string FROM integer FOR integer)', '??????????????????start????????????????????????????????? ??????????????????start????????????????????????length????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('INITCAP', '', '????????????????????????????????????', 'INITCAP(string)', '??????????????????????????????????????????????????????, ???????????????????????????????????????. ?????????????????????.', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('CONCAT', '', '????????????????????????', 'CONCAT(string1, string2,...)', '????????????????????????????????????concat(\'foo\', \'bar\') = \'foobar\', ??????????????????????????????????????????????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('CONCAT_WS', '', '???????????????????????????????????????', 'CONCAT_WS(separator, string1, string2,...)', '???????????????????????????????????????', @char, -1, -1, -1, 0, 1, 5, now(), now(), 0, null);

set @merge=(select id from develop_catalogue where node_name='????????????' and node_pid = (select id from develop_catalogue where node_name='Flink????????????'));
INSERT INTO `develop_function`(name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, udf_type, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text)
VALUES ('COUNT', '', '???????????????', 'COUNT(*) or COUNT(value [, value]* )', '??????????????????????????????NULL?????????, ???????????????NULL???expr?????????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('AVG', '', '????????????????????????', 'AVG(numeric)', '????????????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('SUM', '', '??????????????????', 'SUM(numeric)', '??????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('MAX', '', '????????????????????????', 'MAX(value)', '????????????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('MIN', '', '????????????????????????', 'MIN(value)', '????????????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('STDDEV_POP', '', '?????????????????????????????????', 'STDDEV_POP(value)', '?????????????????????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('STDDEV_SAMP', '', '???????????????????????????????????????', 'STDDEV_SAMP(value)', '???????????????????????????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('VAR_POP', '', '???????????????????????????', 'VAR_POP(value)', '???????????????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('VAR_SAMP', '', '?????????????????????????????????', 'VAR_POP(value)', '?????????????????????????????????.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('COLLECT', '', '??????????????????multiset', 'COLLECT(value)', '??????????????????multiset. null????????????.???????????????null,??????????????????multiset.', @merge, -1, -1, -1, 0, 1, 5, now(), now(), 0, null);

set @other=(select id from develop_catalogue where node_name='????????????' and node_pid = (select id from develop_catalogue where node_name='Flink????????????'));
INSERT INTO `develop_function`(name, class_name, purpose, command_formate, param_desc, node_pid, tenant_id, create_user_id, modify_user_id, udf_type, type, task_type, gmt_create, gmt_modified, is_deleted, sql_text)
VALUES ('NULLIF', '', '????????????????????????null', 'NULLIF(value, value)', '????????????????????????null, ?????? NULLIF(5, 5) ?????? NULL; NULLIF(5, 0) ?????? 5.', @other, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('COALESCE', '', '???????????????null??????', 'COALESCE(value, value [, value ]* )', '???????????????null??????, ??????: COALESCE(NULL, 5) ?????? 5.', @other, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('CAST', '', '????????????', 'CAST(value AS type)', '???value ???????????????type', @other, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('GROUP_ID', '', '??????????????????????????????????????????', 'GROUP_ID()', '??????????????????????????????????????????.', @other,  -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('GROUPING', '', '???????????????????????????????????????????????????1, ????????????0', 'GROUPING(expression)', '???????????????????????????????????????????????????1, ????????????0.', @other, -1, -1, -1, 0, 1, 5, now(), now(), 0, null),
       ('GROUPING_ID', '', '???????????????????????????????????????', 'GROUPING_ID(expression [, expression]* )', '???????????????????????????????????????.', @other,  -1, -1, -1, 0, 1, 5, now(), now(), 0, null);

commit;


INSERT INTO dict (dict_code, dict_name, dict_value, dict_desc, type, sort, data_type, depend_name, is_default, gmt_create, gmt_modified, is_deleted) VALUES ('FlinkSQLFunction', 'FlinkSQLFunction', '4', 'FlinkSQL', 31, 4, 'STRING', '', 1, now(), now(), 0);


DROP TABLE IF EXISTS `stream_metric_support`;
CREATE TABLE `stream_metric_support` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '??????id',
  `name` varchar(255) NOT NULL COMMENT '??????????????????',
  `task_type` tinyint(4) NOT NULL COMMENT '???????????????????????????',
  `value` varchar(255) NOT NULL COMMENT '??????key',
  `metric_tag` int(11) NOT NULL COMMENT 'metric????????????',
  `component_version` varchar(255) NOT NULL DEFAULT '1.10' COMMENT '????????????',
  `gmt_create` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '????????????',
  `gmt_modified` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '????????????',
  `is_deleted` tinyint(4) DEFAULT NULL COMMENT '????????????',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8 COMMENT='???????????????metric??????';

-- ----------------------------
--  Records of `stream_metric_support_copy`
-- ----------------------------
BEGIN;
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '231', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_numReadPerSecond', '5', '2021-09-26 17:04:01', '1', '???source rps????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '233', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_byteReadPerSecond', '5', '2021-09-26 17:04:01', '1', '???source bps????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '235', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_byteWritePerSecond', '5', '2021-09-26 17:04:01', '1', '???sink bps????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '237', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_numWritePerSecond', '5', '2021-09-26 17:04:01', '1', '???sink rps??????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '239', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_KafkaConsumer_topic_partition_lag', '5', '2021-09-26 17:04:01', '1', '????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '241', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_numReadPerSecond', '6', '2021-09-26 17:04:01', '1', '??????rps');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '243', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_numWritePerSecond', '6', '2021-09-26 17:04:01', '1', '??????rps');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '245', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_byteReadPerSecond', '6', '2021-09-26 17:04:01', '1', '??????bps');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '247', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_byteWritePerSecond', '6', '2021-09-26 17:04:01', '1', '??????bps');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '249', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_numRead', '6', '2021-09-26 17:04:01', '1', '?????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '251', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_numWrite', '6', '2021-09-26 17:04:01', '1', '?????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '253', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_byteRead', '6', '2021-09-26 17:04:01', '1', '?????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '255', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_operator_flinkx_byteWrite', '6', '2021-09-26 17:04:01', '1', '?????????????????????');
  insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '143', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_CPU_Load', '99', '2021-09-26 17:04:01', '2', 'jobmanager cpu??????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '145', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_CPU_Time', '99', '2021-09-26 17:04:01', '2', 'jobmanager cpu????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '147', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_CPU_Load', '99', '2021-09-26 17:04:01', '2', 'taskmanager cpu??????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '149', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_CPU_Time', '99', '2021-09-26 17:04:01', '2', 'taskmanager cpu????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '151', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_Memory_Heap_Max', '99', '2021-09-26 17:04:01', '2', 'bmanager jvm???????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '153', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_Memory_Heap_Max', '99', '2021-09-26 17:04:01', '2', 'taskmanager jvm???????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '155', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_Memory_Heap_Used', '99', '2021-09-26 17:04:01', '2', 'jobmanager jvm??????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '157', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_Memory_Heap_Used', '99', '2021-09-26 17:04:01', '2', 'taskmanager jvm??????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '159', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_Memory_NonHeap_Max', '99', '2021-09-26 17:04:01', '2', 'jobmanager jvm??????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '161', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_Memory_NonHeap_Max', '99', '2021-09-26 17:04:01', '2', 'taskmanager jvm??????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '163', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_Memory_NonHeap_Used', '99', '2021-09-26 17:04:01', '2', 'jobmanager jvm?????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '165', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_Memory_NonHeap_Used', '99', '2021-09-26 17:04:01', '2', 'taskmanager jvm?????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '167', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_Memory_Direct_TotalCapacity', '99', '2021-09-26 17:04:01', '2', 'jobmanager????????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '169', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_Memory_Direct_TotalCapacity', '99', '2021-09-26 17:04:01', '2', 'taskmanager????????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '171', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_Memory_Direct_MemoryUsed', '99', '2021-09-26 17:04:01', '2', 'jobmanager??????????????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '173', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_Memory_Direct_MemoryUsed', '99', '2021-09-26 17:04:01', '2', 'taskmanager??????????????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '175', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_Status_JVM_Threads_Count', '99', '2021-09-26 17:04:01', '2', 'jobmanager ?????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '177', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_Status_JVM_Threads_Count', '99', '2021-09-26 17:04:01', '2', 'taskmanager ?????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '179', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_buffers_inputQueueLength', '99', '2021-09-26 17:04:01', '1', '????????????????????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '181', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_buffers_outputQueueLength', '99', '2021-09-26 17:04:01', '1', '????????????????????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '183', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_job_numRestarts', '99', '2021-09-26 17:04:01', '1', '??????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '185', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_job_restartingTime', '99', '2021-09-26 17:04:01', '1', '????????????????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '187', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_job_lastCheckpointDuration', '99', '2021-09-26 17:04:01', '1', '??????????????????checkpoint????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '189', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_job_lastCheckpointSize', '99', '2021-09-26 17:04:01', '1', '??????????????????checkpoint??????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '191', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_job_totalNumberOfCheckpoints', '99', '2021-09-26 17:04:01', '1', '??????checkpoint?????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '193', '1.12', '2021-09-26 17:04:01', 'flink_jobmanager_job_numberOfFailedCheckpoints', '99', '2021-09-26 17:04:01', '1', '??????checkpoint????????????');
insert into `stream_metric_support` ( `is_deleted`, `id`, `component_version`, `gmt_modified`, `value`, `task_type`, `gmt_create`, `metric_tag`, `name`) values ( '0', '195', '1.12', '2021-09-26 17:04:01', 'flink_taskmanager_job_task_checkpointAlignmentTime', '99', '2021-09-26 17:04:01', '1', 'barrier ??????????????????');


alter table tenant add tenant_identity varchar(64) default '' null comment '????????????';

UPDATE task_template SET value_type = '1.12' WHERE task_type = 2 and type = 0;

alter table develop_resource add compute_type int default 0 null comment '??????????????????';

COMMIT;
