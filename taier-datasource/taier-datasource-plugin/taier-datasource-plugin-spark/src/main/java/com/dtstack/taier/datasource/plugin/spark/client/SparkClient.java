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

package com.dtstack.taier.datasource.plugin.spark.client;

import com.dtstack.taier.datasource.plugin.common.DtClassConsistent;
import com.dtstack.taier.datasource.plugin.common.enums.StoredType;
import com.dtstack.taier.datasource.plugin.common.utils.DBUtil;
import com.dtstack.taier.datasource.plugin.common.utils.ReflectUtil;
import com.dtstack.taier.datasource.plugin.common.utils.SearchUtil;
import com.dtstack.taier.datasource.plugin.common.utils.TableUtil;
import com.dtstack.taier.datasource.plugin.kerberos.core.hdfs.HadoopConfUtil;
import com.dtstack.taier.datasource.plugin.kerberos.core.hdfs.HdfsOperator;
import com.dtstack.taier.datasource.plugin.kerberos.core.util.KerberosLoginUtil;
import com.dtstack.taier.datasource.plugin.rdbms.AbsRdbmsClient;
import com.dtstack.taier.datasource.plugin.rdbms.ConnFactory;
import com.dtstack.taier.datasource.plugin.spark.SparkConnFactory;
import com.dtstack.taier.datasource.plugin.spark.downloader.SparkJdbcDownload;
import com.dtstack.taier.datasource.plugin.spark.downloader.SparkORCDownload;
import com.dtstack.taier.datasource.plugin.spark.downloader.SparkParquetDownload;
import com.dtstack.taier.datasource.plugin.spark.downloader.SparkTextDownload;
import com.dtstack.taier.datasource.api.client.ITable;
import com.dtstack.taier.datasource.api.dto.ColumnMetaDTO;
import com.dtstack.taier.datasource.api.dto.Database;
import com.dtstack.taier.datasource.api.dto.SqlQueryDTO;
import com.dtstack.taier.datasource.api.dto.Table;
import com.dtstack.taier.datasource.api.dto.source.ISourceDTO;
import com.dtstack.taier.datasource.api.dto.source.SparkSourceDTO;
import com.dtstack.taier.datasource.api.exception.SourceException;
import com.dtstack.taier.datasource.api.source.DataSourceType;
import com.dtstack.taier.datasource.api.downloader.IDownloader;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.hadoop.conf.Configuration;
import org.jetbrains.annotations.NotNull;

import java.security.PrivilegedAction;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @company: www.dtstack.com
 * @Author ???Nanqi
 * @Date ???Created in 17:06 2020/1/7
 * @Description???Spark ??????
 */
@Slf4j
public class SparkClient extends AbsRdbmsClient {

    // ???????????????????????????
    private static final String CURRENT_DB = "select current_database()";

    // ?????????????????????
    private static final String CREATE_DB_WITH_COMMENT = "create database %s comment '%s'";

    // ?????????
    private static final String CREATE_DB = "create database %s";

    // ????????????schema?????????
    private static final String TABLE_BY_SCHEMA = "show tables in %s";

    // ????????????????????????schema?????????
    private static final String TABLE_BY_SCHEMA_LIKE = "show tables in %s like '%s'";

    // ????????????database
    private static final String SHOW_DB_LIKE = "show databases like '%s'";

    // null ??????????????????
    private static final String NULL_COLUMN = "null";

    // spark table client
    private static final ITable TABLE_CLIENT = new SparkTableClient();

    // show tables
    private static final String SHOW_TABLE_SQL = "show tables";

    // show tables like 'xxx'
    private static final String SHOW_TABLE_LIKE_SQL = "show tables like '*%s*'";

    // desc db info
    private static final String DESC_DB_INFO = "desc database %s";

    @Override
    protected ConnFactory getConnFactory() {
        return new SparkConnFactory();
    }

    @Override
    protected DataSourceType getSourceType() {
        return DataSourceType.Spark;
    }

    @Override
    public List<String> getTableList(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        // ???????????????????????????show tables ??????
        String sql;
        if (Objects.nonNull(queryDTO) && StringUtils.isNotEmpty(queryDTO.getTableNamePattern())) {
            // ????????????
            sql = String.format(SHOW_TABLE_LIKE_SQL, queryDTO.getTableNamePattern());
        } else {
            sql = SHOW_TABLE_SQL;
        }
        Statement statement = null;
        ResultSet rs = null;
        List<String> tableList = new ArrayList<>();
        try {
            statement = connection.createStatement();
            if (Objects.nonNull(queryDTO) && Objects.nonNull(queryDTO.getLimit())) {
                // ??????????????????
                statement.setMaxRows(queryDTO.getLimit());
            }
            DBUtil.setFetchSize(statement, queryDTO);
            rs = statement.executeQuery(sql);
            int columnSize = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                tableList.add(rs.getString(columnSize == 1 ? 1 : 2));
            }
        } catch (Exception e) {
            throw new SourceException(String.format("get table exception,%s", e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(rs, statement, connection);
        }
        return SearchUtil.handleSearchAndLimit(tableList, queryDTO);
    }

    @Override
    public List<String> getTableListBySchema(ISourceDTO source, SqlQueryDTO queryDTO) {
        SparkSourceDTO sparkSourceDTO = (SparkSourceDTO) source;
        if (Objects.nonNull(queryDTO) && StringUtils.isNotBlank(queryDTO.getSchema())) {
            sparkSourceDTO.setSchema(queryDTO.getSchema());
        }
        return getTableList(sparkSourceDTO, queryDTO);
    }

    @Override
    public String getTableMetaComment(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        try {
            return getTableMetaComment(connection, queryDTO.getTableName());
        } finally {
            DBUtil.closeDBResources(null, null, connection);
        }
    }

    /**
     * ?????????????????????
     *
     * @param conn
     * @param tableName
     * @return
     */
    private String getTableMetaComment(Connection conn, String tableName) {
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            statement = conn.createStatement();
            resultSet = statement.executeQuery(String.format(DtClassConsistent.HadoopConfConsistent.DESCRIBE_EXTENDED
                    , tableName));
            boolean tableInfoFlag = false;
            while (resultSet.next()) {
                String columnName = resultSet.getString(1);
                // ?????? key ???????????????????????????
                if (StringUtils.isBlank(columnName)) {
                    continue;
                }

                // ?????????????????????????????????????????? tableInfoFlag
                if (columnName.toLowerCase().contains(DtClassConsistent.HadoopConfConsistent.TABLE_INFORMATION)) {
                    tableInfoFlag = true;
                }

                // ?????????????????????????????????????????????????????????
                if (!tableInfoFlag) {
                    continue;
                }

                // ?????????????????????????????????
                String metaValue = resultSet.getString(2);
                if (StringUtils.isBlank(metaValue)) {
                    continue;
                }

                // ThriftServer 2.1.x ????????? tableInformation ???????????????????????????????????????
                if (metaValue.contains(DtClassConsistent.HadoopConfConsistent.COMMENT_WITH_COLON)) {
                    String[] split = metaValue.split(DtClassConsistent.HadoopConfConsistent.COMMENT_WITH_COLON);
                    if (split.length > 1) {
                        return split[1].split(DtClassConsistent.PublicConsistent.LINE_SEPARATOR)[0].trim();
                    }
                }

                // ThriftServer 2.4.x ?????????????????????????????????
                if (DtClassConsistent.HadoopConfConsistent.COMMENT.equalsIgnoreCase(columnName)) {
                    return metaValue.trim();
                }
            }
        } catch (SQLException e) {
            throw new SourceException(String.format("get table: %s's information error. Please contact the DBA to check the database???table information. %s",
                    tableName, e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(resultSet, statement, null);
        }
        return "";
    }

    private List<ColumnMetaDTO> getColumnMetaData(Connection conn, String tableName, Boolean filterPartitionColumns) {
        List<ColumnMetaDTO> columnMetaDTOS = new ArrayList<>();
        Statement stmt = null;
        ResultSet resultSet = null;

        try {
            stmt = conn.createStatement();
            resultSet = stmt.executeQuery("desc extended " + tableName);
            while (resultSet.next()) {
                String dataType = resultSet.getString(DtClassConsistent.PublicConsistent.DATA_TYPE);
                String colName = resultSet.getString(DtClassConsistent.PublicConsistent.COL_NAME);
                if (StringUtils.isEmpty(dataType) || StringUtils.isBlank(colName)) {
                    break;
                }

                colName = colName.trim();
                ColumnMetaDTO metaDTO = new ColumnMetaDTO();
                metaDTO.setType(dataType.trim());
                metaDTO.setKey(colName);
                metaDTO.setComment(resultSet.getString(DtClassConsistent.PublicConsistent.COMMENT));

                if (colName.startsWith("#") || "Detailed Table Information".equals(colName)) {
                    break;
                }
                columnMetaDTOS.add(metaDTO);
            }

            DBUtil.closeDBResources(resultSet, null, null);
            resultSet = stmt.executeQuery("desc extended " + tableName);
            boolean partBegin = false;
            while (resultSet.next()) {
                String colName = resultSet.getString(DtClassConsistent.PublicConsistent.COL_NAME).trim();

                if (colName.contains("# Partition Information")) {
                    partBegin = true;
                }

                if (colName.startsWith("#")) {
                    continue;
                }

                if (colName.contains("Detailed Table Information")) {
                    break;
                }

                // ??????????????????
                if (partBegin && !colName.contains("Partition Type")) {
                    Optional<ColumnMetaDTO> metaDTO =
                            columnMetaDTOS.stream().filter(meta -> colName.trim().equals(meta.getKey())).findFirst();
                    if (metaDTO.isPresent()) {
                        metaDTO.get().setPart(true);
                    }
                } else if (colName.contains("Partition Type")) {
                    //??????????????????
                    partBegin = false;
                }
            }

            return columnMetaDTOS.stream().filter(column -> !filterPartitionColumns || !column.getPart()).collect(Collectors.toList());
        } catch (SQLException e) {
            throw new SourceException(String.format("Failed to get meta information for the fields of table :%s. Please contact the DBA to check the database table information,%s", tableName, e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(resultSet, stmt, null);
        }
    }

    @Override
    public List<ColumnMetaDTO> getColumnMetaData(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        try {
            return getColumnMetaData(connection, queryDTO.getTableName(), queryDTO.getFilterPartitionColumns());
        } finally {
            DBUtil.closeDBResources(null, null, connection);
        }
    }

    @Override
    public List<ColumnMetaDTO> getColumnMetaDataWithSql(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        List<ColumnMetaDTO> columns = super.getColumnMetaDataWithSql(sourceDTO, queryDTO);
        columns.forEach(column -> {
            String key = column.getKey();
            if (StringUtils.isNotBlank(key) && key.split("\\.", -1).length ==2) {
                column.setKey(key.split("\\.", -1)[1]);
            }
        });
        return columns;
    }

    @Override
    public Boolean testCon(ISourceDTO sourceDTO) {
        // ???????????????????????????
        Boolean testCon = super.testCon(sourceDTO);
        if (!testCon) {
            return Boolean.FALSE;
        }
        SparkSourceDTO sparkSourceDTO = (SparkSourceDTO) sourceDTO;
        if (StringUtils.isBlank(sparkSourceDTO.getDefaultFS())) {
            return Boolean.TRUE;
        }

        return HdfsOperator.checkConnection(sparkSourceDTO.getDefaultFS(), sparkSourceDTO.getConfig(), sparkSourceDTO.getKerberosConfig());
    }

    @Override
    public IDownloader getDownloader(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        SparkSourceDTO sparkSourceDTO = (SparkSourceDTO) sourceDTO;
        Table table;
        // ??????????????????
        ArrayList<ColumnMetaDTO> commonColumn = new ArrayList<>();
        // ??????????????????
        ArrayList<String> partitionColumns = new ArrayList<>();
        // ????????????????????? ????????? null ????????????????????????????????????????????????????????????
        List<String> partitions = null;
        try {
            // ?????????????????????
            table = getTable(sparkSourceDTO, queryDTO);
            //?????????????????????????????????eg:hyperbase,es????????????jdbc?????????????????????sql??????
            if (table.getStoreType() == null && StringUtils.isBlank(queryDTO.getSql())) {
                queryDTO.setSql(String.format("select * from %s", queryDTO.getTableName()));
            }
            for (ColumnMetaDTO columnMetaDatum : table.getColumns()) {
                // ???????????????
                if (columnMetaDatum.getPart()) {
                    partitionColumns.add(columnMetaDatum.getKey());
                    continue;
                }
                commonColumn.add(columnMetaDatum);
            }
            // ?????????
            if (CollectionUtils.isNotEmpty(partitionColumns)) {
                partitions = TABLE_CLIENT.showPartitions(sparkSourceDTO, queryDTO.getTableName());
                if (CollectionUtils.isNotEmpty(partitions)) {
                    // ?????????????????????????????????????????????????????? hdfs ?????????????????????
                    partitions = partitions.stream()
                            .filter(StringUtils::isNotEmpty)
                            .map(String::toLowerCase)
                            .collect(Collectors.toList());
                }
            }
        } catch (Exception e) {
            throw new SourceException(String.format("failed to get table detail: %s", e.getMessage()), e);
        }
        // ???????????????????????????????????????????????????
        List<String> columns = queryDTO.getColumns();
        // ???????????????????????????????????????????????????
        List<Integer> needIndex = Lists.newArrayList();
        // columns???????????????????????????*??????????????????????????????
        if (CollectionUtils.isNotEmpty(columns) && !columns.contains("*")) {
            // ???????????????????????????!
            for (String column : columns) {
                if (NULL_COLUMN.equalsIgnoreCase(column)) {
                    needIndex.add(Integer.MAX_VALUE);
                    continue;
                }
                // ??????????????????????????????
                boolean check = false;
                for (int j = 0; j < table.getColumns().size(); j++) {
                    if (column.equalsIgnoreCase(table.getColumns().get(j).getKey())) {
                        needIndex.add(j);
                        check = true;
                        break;
                    }
                }
                if (!check) {
                    throw new SourceException("The query field does not exist! Field name???" + column);
                }
            }
        }

        // ?????????????????????
        if (StringUtils.isBlank(sparkSourceDTO.getDefaultFS())) {
            throw new SourceException("defaultFS incorrect format");
        }
        List<String> finalPartitions = partitions;
        return KerberosLoginUtil.loginWithUGI(sparkSourceDTO.getKerberosConfig()).doAs(
                (PrivilegedAction<IDownloader>) () -> {
                    try {
                        Configuration conf = HadoopConfUtil.getHdfsConf(sparkSourceDTO.getDefaultFS(), sparkSourceDTO.getConfig(), sparkSourceDTO.getKerberosConfig());
                        return createDownloader(table.getStoreType(), conf, table.getPath(), commonColumn, table.getDelim(), partitionColumns, needIndex, queryDTO.getPartitionColumns(), finalPartitions, sparkSourceDTO, queryDTO.getSql());
                    } catch (Exception e) {
                        throw new SourceException(String.format("create downloader exception,%s", e.getMessage()), e);
                    }
                }
        );
    }

    /**
     * ?????????????????????????????????hiveDownloader
     *
     * @param storageMode      ????????????
     * @param conf             ??????
     * @param tableLocation    ???hdfs??????
     * @param columns          ????????????
     * @param fieldDelimiter   textFile ???????????????
     * @param partitionColumns ??????????????????
     * @param needIndex        ?????????????????????????????????
     * @param filterPartitions ?????????????????????
     * @param partitions       ????????????
     * @param sparkSourceDTO   sourceDTO
     * @param sql              ?????????jdbc downloader?????????
     * @return downloader
     * @throws Exception ????????????
     */
    private @NotNull IDownloader createDownloader(String storageMode, Configuration conf, String tableLocation,
                                                  List<ColumnMetaDTO> columns, String fieldDelimiter,
                                                  ArrayList<String> partitionColumns, List<Integer> needIndex,
                                                  Map<String, String> filterPartitions, List<String> partitions,
                                                  SparkSourceDTO sparkSourceDTO, String sql) throws Exception {
        // ?????????????????????????????????hiveDownloader
        List<String> columnNames = columns.stream().map(ColumnMetaDTO::getKey).collect(Collectors.toList());
        if (StringUtils.containsIgnoreCase(storageMode, "text")) {
            SparkTextDownload sparkTextDownload = new SparkTextDownload(conf, tableLocation, columnNames,
                    fieldDelimiter, partitionColumns, filterPartitions, needIndex, partitions, sparkSourceDTO.getKerberosConfig());
            sparkTextDownload.configure();
            return sparkTextDownload;
        }

        if (StringUtils.containsIgnoreCase(storageMode, "orc")) {
            SparkORCDownload sparkORCDownload = new SparkORCDownload(conf, tableLocation, columnNames,
                    partitionColumns, needIndex, partitions, sparkSourceDTO.getKerberosConfig());
            sparkORCDownload.configure();
            return sparkORCDownload;
        }

        if (StringUtils.containsIgnoreCase(storageMode, "parquet")) {
            SparkParquetDownload sparkParquetDownload = new SparkParquetDownload(conf, tableLocation, columns,
                    partitionColumns, needIndex, filterPartitions, partitions, sparkSourceDTO.getKerberosConfig());
            sparkParquetDownload.configure();
            return sparkParquetDownload;
        }

        //es & hbase??????????????????storageMode???null??????jdbc???downloader??????
        if (StringUtils.isBlank(storageMode)) {
            SparkJdbcDownload jdbcDownload = new SparkJdbcDownload(getCon(sparkSourceDTO), sql);
            jdbcDownload.configure();
            return jdbcDownload;
        }

        throw new SourceException("Hive table reads for this storage type are not supported");
    }

    /**
     * ??????hive???????????????sql??????
     *
     * @param sqlQueryDTO ????????????
     * @return
     */
    @Override
    protected String dealSql(ISourceDTO iSourceDTO, SqlQueryDTO sqlQueryDTO) {
        Map<String, String> partitions = sqlQueryDTO.getPartitionColumns();
        StringBuilder partSql = new StringBuilder();
        //??????????????????
        if (MapUtils.isNotEmpty(partitions)) {
            boolean check = true;
            partSql.append(" where ");
            Set<String> set = partitions.keySet();
            for (String column : set) {
                if (check) {
                    partSql.append(column + "=").append(partitions.get(column));
                    check = false;
                } else {
                    partSql.append(" and ").append(column + "=").append(partitions.get(column));
                }
            }
        }
        return "select * from " + sqlQueryDTO.getTableName() + partSql.toString() + limitSql(sqlQueryDTO.getPreviewNum());
    }

    @Override
    public List<ColumnMetaDTO> getPartitionColumn(ISourceDTO source, SqlQueryDTO queryDTO) {
        List<ColumnMetaDTO> columnMetaDTOS = getColumnMetaData(source, queryDTO);
        List<ColumnMetaDTO> partitionColumnMeta = new ArrayList<>();
        columnMetaDTOS.forEach(columnMetaDTO -> {
            if (columnMetaDTO.getPart()) {
                partitionColumnMeta.add(columnMetaDTO);
            }
        });
        return partitionColumnMeta;
    }

    @Override
    public Table getTable(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        SparkSourceDTO sparkSourceDTO = (SparkSourceDTO) sourceDTO;

        Table tableInfo = new Table();
        try {
            tableInfo.setName(queryDTO.getTableName());
            // ???????????????
            tableInfo.setComment(getTableMetaComment(connection, queryDTO.getTableName()));
            // ?????????????????????????????????
            List<ColumnMetaDTO> columnMetaDTOS = getColumnMetaData(connection, queryDTO.getTableName(), false);
            // ???????????????????????????????????????
            if (ReflectUtil.fieldExists(Table.class, "isPartitionTable")) {
                tableInfo.setIsPartitionTable(CollectionUtils.isNotEmpty(TableUtil.getPartitionColumns(columnMetaDTOS)));
            }
            tableInfo.setColumns(TableUtil.filterPartitionColumns(columnMetaDTOS, queryDTO.getFilterPartitionColumns()));
            // ?????????????????????
            getTable(tableInfo, sparkSourceDTO, queryDTO.getTableName());
        } catch (Exception e) {
            throw new SourceException(String.format("SQL executed exception, %s", e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(null, null, connection);
        }
        return tableInfo;
    }

    /**
     * ?????????????????????
     *
     * @param tableInfo
     * @param sparkSourceDTO
     * @param tableName
     */
    private void getTable(Table tableInfo, SparkSourceDTO sparkSourceDTO, String tableName) {
        List<Map<String, Object>> result = executeQuery(sparkSourceDTO, SqlQueryDTO.builder().sql("desc formatted " + tableName).build());
        boolean isTableInfo = false;
        for (Map<String, Object> row : result) {
            String colName = MapUtils.getString(row, "col_name");
            String comment = MapUtils.getString(row, "comment", "");
            String dataTypeOrigin = MapUtils.getString(row, "data_type");
            if (StringUtils.isBlank(colName) || StringUtils.isEmpty(dataTypeOrigin)) {
                if (StringUtils.isNotBlank(colName) && colName.contains("# Detailed Table Information")) {
                    isTableInfo = true;
                }
                continue;
            }
            // ???????????????
            String dataType = dataTypeOrigin.trim();
            if (!isTableInfo) {
                continue;
            }

            if (colName.contains("Location")) {
                tableInfo.setPath(dataType);
                continue;
            }

            if (colName.contains("Table Type")) {
                if (ReflectUtil.fieldExists(Table.class, "isView")) {
                    tableInfo.setIsView(StringUtils.containsIgnoreCase(dataType, "VIEW"));
                }
                tableInfo.setExternalOrManaged(dataType);
                continue;
            }

            // ????????????????????? Type ?????????
            if (("Type".equals(colName.trim()) || "Type:".equals(colName.trim())) && StringUtils.isEmpty(tableInfo.getExternalOrManaged())) {
                if (ReflectUtil.fieldExists(Table.class, "isView")) {
                    tableInfo.setIsView(StringUtils.containsIgnoreCase(dataType, "VIEW"));
                }
                tableInfo.setExternalOrManaged(dataType);
                continue;
            }

            // ThriftServer 2.1.x ???????????? key
            if (colName.contains("field.delim")) {
                // trim ????????????????????? trim ?????????
                tableInfo.setDelim(StringUtils.isEmpty(dataType) ? dataTypeOrigin : dataType);
                continue;
            }

            // ThriftServer 2.4.x ???????????????????????? [field.delim=,, serialization.format=,]
            // ThriftServer 2.2.x ???????????????????????? [serialization.format=,, field.delim=,]
            if ("Storage Properties".equals(colName)) {
                int serializationFormatLos = dataType.indexOf("serialization.format=");
                int fieldDelimLos = dataType.indexOf("field.delim=");
                // ??????????????????????????????????????????????????????
                if (serializationFormatLos == -1 || fieldDelimLos == -1) {
                    continue;
                }

                // ???????????????
                if (serializationFormatLos > fieldDelimLos) {
                    tableInfo.setDelim(dataType.substring(fieldDelimLos + 12, serializationFormatLos - 2));
                } else {
                    tableInfo.setDelim(dataType.substring(serializationFormatLos + 21, fieldDelimLos - 2));
                }
                continue;
            }

            if (colName.contains("Owner")) {
                tableInfo.setOwner(dataType);
                continue;
            }

            if (colName.contains("Create Time") || colName.contains("Created Time")) {
                tableInfo.setCreatedTime(dataType);
                continue;
            }

            if (colName.contains("Last Access")) {
                tableInfo.setLastAccess(dataType);
                continue;
            }

            if (colName.contains("Created By")) {
                tableInfo.setCreatedBy(dataType);
                continue;
            }

            if (colName.contains("Database")) {
                tableInfo.setDb(dataType);
                continue;
            }

            if (StringUtils.containsIgnoreCase(dataType, "transactional")) {
                if (ReflectUtil.fieldExists(Table.class, "isTransTable") && StringUtils.containsIgnoreCase(comment, "true")) {
                    tableInfo.setIsTransTable(true);
                }
                continue;
            }

            if (tableInfo.getStoreType() == null && colName.contains("InputFormat")) {
                for (StoredType hiveStoredType : StoredType.values()) {
                    if (dataType.contains(hiveStoredType.getInputFormatClass())) {
                        tableInfo.setStoreType(hiveStoredType.getValue());
                        break;
                    }
                }
            }
        }
        // text ?????????????????????????????????????????????
        if (StringUtils.equalsIgnoreCase(StoredType.TEXTFILE.getValue(), tableInfo.getStoreType()) && Objects.isNull(tableInfo.getDelim())) {
            tableInfo.setDelim(DtClassConsistent.HiveConsistent.DEFAULT_FIELD_DELIMIT);
        }
    }

    @Override
    protected String getCurrentDbSql() {
        return CURRENT_DB;
    }

    @Override
    protected String getCreateDatabaseSql(String dbName, String comment) {
        return StringUtils.isBlank(comment) ? String.format(CREATE_DB, dbName) : String.format(CREATE_DB_WITH_COMMENT, dbName, comment);
    }

    @Override
    public Boolean isDatabaseExists(ISourceDTO source, String dbName) {
        if (StringUtils.isBlank(dbName)) {
            throw new SourceException("database name cannot be empty!");
        }
        return CollectionUtils.isNotEmpty(executeQuery(source, SqlQueryDTO.builder().sql(String.format(SHOW_DB_LIKE, dbName)).build()));
    }

    @Override
    public Boolean isTableExistsInDatabase(ISourceDTO source, String tableName, String dbName) {
        if (StringUtils.isBlank(dbName)) {
            throw new SourceException("database name cannot be empty!");
        }
        return CollectionUtils.isNotEmpty(executeQuery(source, SqlQueryDTO.builder().sql(String.format(TABLE_BY_SCHEMA_LIKE, dbName, tableName)).build()));
    }

    @Override
    public String getDescDbSql(String dbName) {
        return String.format(DESC_DB_INFO, dbName);
    }

    @Override
    public Database parseDbResult(List<Map<String, Object>> result) {
        Database database = new Database();
        for (Map<String, Object> rowMap : result) {
            String descKey = MapUtils.getString(rowMap, DtClassConsistent.PublicConsistent.SPARK_DESC_DATABASE_KEY);
            String descValue = MapUtils.getString(rowMap, DtClassConsistent.PublicConsistent.SPARK_DESC_DATABASE_VALUE);
            if (StringUtils.equalsIgnoreCase(DtClassConsistent.PublicConsistent.DATABASE_NAME, descKey)) {
                database.setDbName(descValue);
                continue;
            }

            if (StringUtils.equalsIgnoreCase(DtClassConsistent.PublicConsistent.DESCRIPTION, descKey)) {
                database.setComment(descValue);
                continue;
            }

            if (StringUtils.equalsIgnoreCase(DtClassConsistent.PublicConsistent.LOCATION_SPARK, descKey)) {
                database.setLocation(descValue);
            }
        }
        return database;
    }

    @Override
    public String getCreateTableSql(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        String sql = String.format("show create table %s", queryDTO.getTableName());
        Statement statement = null;
        ResultSet rs = null;
        StringBuilder createTableSql = new StringBuilder();
        try {
            statement = connection.createStatement();
            rs = statement.executeQuery(sql);
            int columnSize = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                createTableSql.append(rs.getString(columnSize == 1 ? 1 : 2));
            }
        } catch (Exception e) {
            throw new SourceException(String.format("failed to get the create table sql???%s", e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(rs, statement, connection);
        }
        return createTableSql.toString();
    }

    @Override
    protected Pair<Character, Character> getSpecialSign() {
        return Pair.of('`', '`');
    }
}
