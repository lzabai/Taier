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

package com.dtstack.taier.datasource.plugin.trino;

import com.dtstack.taier.datasource.plugin.common.exception.ErrorCode;
import com.dtstack.taier.datasource.plugin.common.utils.DBUtil;
import com.dtstack.taier.datasource.plugin.common.utils.ReflectUtil;
import com.dtstack.taier.datasource.plugin.common.utils.SearchUtil;
import com.dtstack.taier.datasource.plugin.rdbms.AbsRdbmsClient;
import com.dtstack.taier.datasource.plugin.rdbms.ConnFactory;
import com.dtstack.taier.datasource.plugin.trino.download.TrinoDownloader;
import com.dtstack.taier.datasource.api.dto.ColumnMetaDTO;
import com.dtstack.taier.datasource.api.dto.SqlQueryDTO;
import com.dtstack.taier.datasource.api.dto.source.ISourceDTO;
import com.dtstack.taier.datasource.api.dto.source.RdbmsSourceDTO;
import com.dtstack.taier.datasource.api.dto.source.TrinoSourceDTO;
import com.dtstack.taier.datasource.api.exception.SourceException;
import com.dtstack.taier.datasource.api.source.DataSourceType;
import com.dtstack.taier.datasource.api.downloader.IDownloader;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * trino ??????????????????????????? catalog ??????????????????url?????????schema?????????????????????
 *
 * @author ???wangchuan
 * date???Created in ??????2:21 2021/9/9
 * company: www.dtstack.com
 */
@Slf4j
public class TrinoClient extends AbsRdbmsClient {

    // ????????????schema
    private static final String SHOW_DB_LIKE = "SHOW SCHEMAS LIKE '%s'";

    // ??????????????????catalog??????schema
    private static final String CREATE_SCHEMA = "CREATE SCHEMA \"%s\"";

    // ????????????catalog??????schema
    private static final String CREATE_SCHEMA_IN_CATALOG = "CREATE SCHEMA \"%s\".\"%s\"";

    // ??????table?????????schema??? ??????????????????
    private static final String TABLE_IS_IN_SCHEMA = "SELECT table_name FROM information_schema.tables WHERE table_schema='%s' AND table_name = '%s'";

    // ??????trino ???????????????
    private static final String SHOW_CATALOG_SQL = "SHOW CATALOGS";

    // ???????????????????????????catalog???schema
    private static final String SHOW_SCHEMA_SQL = "SHOW SCHEMAS IN \"%s\"";

    // ????????????????????????schema
    private static final String SHOW_SCHEMA_DEFAULT_SQL = "SHOW SCHEMAS";

    // ??????????????????????????????
    private static final String SHOW_TABLE_SQL = "SHOW TABLES";

    // ???????????????????????????????????????????????????
    private static final String SHOW_TABLE_LIKE_SQL = "show tables like '%s'";

    // ??????????????? sql
    private static final String TABLE_SEARCH_BASE_SQL = "SELECT %s as schema_table FROM information_schema.tables WHERE  1 = 1 ";

    // ???????????????????????????????????? schema ????????????????????????
    private static final String SCHEMA_TABLE_NAME = " '\"'||table_schema||'\".\"'||table_name||'\"' ";

    // ???????????? schema ????????????????????????????????? schema
    private static final String TABLE_NAME = " table_name ";

    // ?????? schema ??????
    private static final String SCHEMA_LIKE_SQL = " and table_schema = '%s' ";

    // ??????????????????
    private static final String TABLE_NAME_LIKE_SQL = " and table_name like '%s' ";

    // ???????????????
    private static final String TABLE_NO_VIEW_SQL = " and table_type = 'BASE TABLE' ";

    // ??????
    private static final String ORDER_BY_SQL = " order by schema_table ";

    // ????????????
    private static final String LIMIT_SQL = " limit %s ";

    // ??????????????????
    private static final String SHOW_CREATE_TABLE_SQL = "SHOW CREATE TABLE %s";

    // ???????????????
    private static final String SHOW_TABLE_COLUMN_COMMENT = "DESCRIBE %s";

    // DESCRIBE ??????????????????key
    private static final String DESCRIBE_COLUMN = "Column";

    // DESCRIBE ??????????????????key
    private static final String DESCRIBE_COMMENT = "Comment";

    // ?????????schema?????????????????????
    private static final String SCHEMA_MUST_BE_SET = "Schema must be specified";

    @Override
    protected ConnFactory getConnFactory() {
        return new TrinoConnFactory();
    }

    @Override
    protected DataSourceType getSourceType() {
        return DataSourceType.TRINO;
    }

    @Override
    public List<String> getTableList(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        TrinoSourceDTO trinoSourceDTO = (TrinoSourceDTO) sourceDTO;
        // schema ??????queryDTO?????????
        String schema = StringUtils.isBlank(queryDTO.getSchema()) ? trinoSourceDTO.getSchema() : queryDTO.getSchema();
        if (StringUtils.isNotBlank(schema)) {
            return getTableListBySchema(sourceDTO, queryDTO);
        }
        try {
            String sql;
            if (StringUtils.isNotEmpty(queryDTO.getTableNamePattern())) {
                // ????????????
                sql = String.format(SHOW_TABLE_LIKE_SQL, addFuzzySign(queryDTO));
            } else {
                sql = SHOW_TABLE_SQL;
            }
            return SearchUtil.handleSearchAndLimit(queryWithSingleColumn(sourceDTO, queryDTO, sql, 1, "get table exception according to schema...", queryDTO.getLimit()), queryDTO);
        } catch (Exception e) {
            // ??????url ?????????????????? schema??????????????????catalog???????????????????????????????????? "schema"."table"
            if (e.getMessage().contains(SCHEMA_MUST_BE_SET)) {
                return getTableListBySchema(sourceDTO, queryDTO);
            }
            throw new SourceException(e.getMessage(), e);
        }
    }

    @Override
    public String getTableMetaComment(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        // trino ????????????????????????
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    protected Map<String, String> getColumnComments(RdbmsSourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        // ???????????????????????????sql
        String queryColumnCommentSql = String.format(SHOW_TABLE_COLUMN_COMMENT, transferSchemaAndTableName(sourceDTO, queryDTO));
        log.info("The SQL executed by method getColumnComments is:{}", queryColumnCommentSql);
        List<Map<String, Object>> result = executeQuery(sourceDTO, SqlQueryDTO.builder().sql(queryColumnCommentSql).build());
        Map<String, String> columnComments = Maps.newHashMap();
        if (CollectionUtils.isNotEmpty(result)) {
            result.stream().filter(MapUtils::isNotEmpty).forEach(row -> {
                String column = MapUtils.getString(row, DESCRIBE_COLUMN);
                if (StringUtils.isNotBlank(column)) {
                    columnComments.putIfAbsent(column, MapUtils.getString(row, DESCRIBE_COMMENT));
                }
            });
        }
        return columnComments;
    }

    @Override
    public Boolean isDatabaseExists(ISourceDTO source, String schema) {
        if (StringUtils.isBlank(schema)) {
            throw new SourceException("database schema not null");
        }
        return CollectionUtils.isNotEmpty(executeQuery(source, SqlQueryDTO.builder().sql(String.format(SHOW_DB_LIKE, schema)).build()));
    }

    @Override
    public Boolean isTableExistsInDatabase(ISourceDTO source, String tableName, String dbName) {
        if (StringUtils.isBlank(dbName)) {
            throw new SourceException("database name is not empty");
        }
        return CollectionUtils.isNotEmpty(executeQuery(source, SqlQueryDTO.builder().sql(String.format(TABLE_IS_IN_SCHEMA, dbName, tableName)).build()));
    }

    /**
     * ????????????schema???????????????????????????schema??????????????????schema??????
     *
     * @param sourceDTO ???????????????
     * @param queryDTO  ????????????
     * @return ??????sql
     */
    @Override
    protected String getTableBySchemaSql(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        TrinoSourceDTO trinoSourceDTO = (TrinoSourceDTO) sourceDTO;
        // schema ??????queryDTO?????????
        String schema = StringUtils.isBlank(queryDTO.getSchema()) ? trinoSourceDTO.getSchema() : queryDTO.getSchema();
        StringBuilder tableSearchSql = new StringBuilder();
        String tName = StringUtils.isNotBlank(schema) ? TABLE_NAME : SCHEMA_TABLE_NAME;
        // ?????????????????????
        tableSearchSql.append(String.format(TABLE_SEARCH_BASE_SQL, tName));
        // ???????????? schema
        if (StringUtils.isNotBlank(schema)) {
            tableSearchSql.append(String.format(SCHEMA_LIKE_SQL, schema));
        }

        // ??????????????????
        if (StringUtils.isNotBlank(queryDTO.getTableNamePattern())) {
            tableSearchSql.append(String.format(TABLE_NAME_LIKE_SQL, addFuzzySign(queryDTO)));
        }

        // ???????????????
        if (BooleanUtils.isFalse(queryDTO.getView())) {
            tableSearchSql.append(TABLE_NO_VIEW_SQL);
        }

        // ??????
        tableSearchSql.append(ORDER_BY_SQL);

        // ????????????
        if (Objects.nonNull(queryDTO.getLimit())) {
            tableSearchSql.append(String.format(LIMIT_SQL, queryDTO.getLimit()));
        }
        return tableSearchSql.toString();
    }

    @Override
    public List<ColumnMetaDTO> getColumnMetaData(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        TrinoSourceDTO trinoSourceDTO = (TrinoSourceDTO) sourceDTO;
        // schema ??????queryDTO?????????
        String schema = StringUtils.isBlank(queryDTO.getSchema()) ? trinoSourceDTO.getSchema() : queryDTO.getSchema();
        try {
            return getColumnMetaData(connection, schema, queryDTO.getTableName());
        } finally {
            DBUtil.closeDBResources(null, null, connection);
        }
    }

    private List<ColumnMetaDTO> getColumnMetaData(Connection conn, String schema, String tableName) {
        List<ColumnMetaDTO> columnList = new ArrayList<>();
        Statement stmt = null;
        ResultSet resultSet = null;
        try {
            stmt = conn.createStatement();
            resultSet = stmt.executeQuery("DESCRIBE " + transferSchemaAndTableName(schema, tableName));
            while (resultSet.next()) {
                String colName = resultSet.getString("Column");
                String dataType = resultSet.getString("Type");
                String extra = resultSet.getString("Extra");
                String comment = resultSet.getString("Comment");
                ColumnMetaDTO metaDTO = new ColumnMetaDTO();
                metaDTO.setKey(colName);
                metaDTO.setType(dataType.trim());
                metaDTO.setComment(comment);
                if (StringUtils.isNotBlank(extra) && extra.contains("partition key")) {
                    metaDTO.setPart(true);
                }
                columnList.add(metaDTO);
            }
        } catch (SQLException e) {
            throw new SourceException(String.format("Failed to get meta information for the fields of table :%s. Please contact the DBA to check the database table information.",
                    transferSchemaAndTableName(schema, tableName)), e);
        } finally {
            DBUtil.closeDBResources(resultSet, stmt, null);
        }
        return columnList;
    }

    @Override
    public String getCreateTableSql(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        TrinoSourceDTO trinoSourceDTO = (TrinoSourceDTO) sourceDTO;
        // ????????????????????????schema???????????????????????????????????????schema??????
        String tableName = transferSchemaAndTableName(trinoSourceDTO, queryDTO);
        List<String> result = queryWithSingleColumn(sourceDTO, null, String.format(SHOW_CREATE_TABLE_SQL, tableName), 1, "failed to get table create sql...");
        if (CollectionUtils.isEmpty(result)) {
            throw new SourceException("failed to get table create sql...");
        }
        return result.get(0);
    }

    @Override
    public List<String> getAllDatabases(ISourceDTO source, SqlQueryDTO queryDTO) {
        TrinoSourceDTO trinoSource = (TrinoSourceDTO) source;

        String catalog = null;
        if (ReflectUtil.fieldExists(SqlQueryDTO.class, "catalog")
                && StringUtils.isNotBlank(queryDTO.getCatalog())) {
            catalog = queryDTO.getCatalog();
        } else if (ReflectUtil.fieldExists(TrinoSourceDTO.class, "catalog")) {
            catalog = trinoSource.getCatalog();
        }

        String sql = StringUtils.isBlank(catalog) ? SHOW_SCHEMA_DEFAULT_SQL : String.format(SHOW_SCHEMA_SQL, catalog);
        return queryWithSingleColumn(source, null, sql, 1, "get All database exception");
    }

    @Override
    protected String getCatalogSql() {
        return SHOW_CATALOG_SQL;
    }

    @Override
    public Boolean createDatabase(ISourceDTO source, String dbName, String comment) {
        if (StringUtils.isBlank(dbName)) {
            throw new SourceException("database or schema cannot be empty");
        }

        TrinoSourceDTO trinoSource = (TrinoSourceDTO) source;
        String createSchemaSql;

        if (ReflectUtil.fieldExists(TrinoSourceDTO.class, "catalog")
                && StringUtils.isNotBlank(trinoSource.getCatalog())) {
            createSchemaSql = String.format(CREATE_SCHEMA_IN_CATALOG, trinoSource.getCatalog(), dbName);
        } else {
            createSchemaSql = String.format(CREATE_SCHEMA, dbName);
        }
        if (StringUtils.isEmpty(trinoSource.getSchema())) {
            trinoSource.setSchema(dbName);
        }
        return executeSqlWithoutResultSet(source, SqlQueryDTO.builder().sql(createSchemaSql).build());
    }

    /**
     * ?????? trino schema???tableName????????????????????? schema ?????? . ?????????
     *
     * @param schema    schema???
     * @param tableName ??????
     * @return ??????????????????
     */
    @Override
    protected String transferSchemaAndTableName(String schema, String tableName) {
        if (StringUtils.isBlank(schema) || tableName.contains(".")) {
            return tableName;
        }
        return String.format("\"%s\".\"%s\"", schema, tableName);
    }

    @Override
    public List<Map<String, Object>> executeQuery(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        try {
            return super.executeQuery(sourceDTO, queryDTO);
        } catch (SourceException e) {
            //??????????????????????????????catalog or schema or table?????????????????????????????????
            if (e.getCause() instanceof SQLException
                    && e.getMessage().contains("Formatted query does not parse")) {
                throw new SourceException(
                        "Precompiled statements do not support starting with illegal characters such as numbers", e);
            }
            throw e;
        }
    }

    @Override
    public IDownloader getDownloader(ISourceDTO source, SqlQueryDTO queryDTO) throws Exception {
        TrinoSourceDTO sourceDTO = (TrinoSourceDTO) source;
        if (StringUtils.isBlank(queryDTO.getSql())) {
            if (StringUtils.isBlank(queryDTO.getTableName())) {
                throw new SourceException("It must has tableName or sql when get downloader");
            }
            queryDTO.setSql(String.format("select * from \"%s\"", queryDTO.getTableName()));
        }
        TrinoDownloader downloader = new TrinoDownloader(getCon(sourceDTO), queryDTO.getSql());
        downloader.configure();
        return downloader;
    }

    @Override
    public Connection getCon(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        if (Objects.isNull(queryDTO)) {
            return super.getCon(sourceDTO, queryDTO);
        }
        TrinoSourceDTO trinoSourceDTO = (TrinoSourceDTO) sourceDTO;
        if (ReflectUtil.fieldExists(SqlQueryDTO.class, "catalog")
                && StringUtils.isNotBlank(queryDTO.getCatalog())) {
            trinoSourceDTO.setCatalog(queryDTO.getCatalog());
        }
        if (StringUtils.isNotBlank(queryDTO.getSchema())) {
            trinoSourceDTO.setSchema(queryDTO.getSchema());
        }
        return super.getCon(trinoSourceDTO, queryDTO);
    }
}
