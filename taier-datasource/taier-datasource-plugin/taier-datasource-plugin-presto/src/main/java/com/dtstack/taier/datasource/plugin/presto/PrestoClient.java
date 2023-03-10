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

package com.dtstack.taier.datasource.plugin.presto;

import com.dtstack.taier.datasource.plugin.common.exception.ErrorCode;
import com.dtstack.taier.datasource.plugin.common.utils.DBUtil;
import com.dtstack.taier.datasource.plugin.common.utils.ReflectUtil;
import com.dtstack.taier.datasource.plugin.common.utils.SearchUtil;
import com.dtstack.taier.datasource.plugin.rdbms.AbsRdbmsClient;
import com.dtstack.taier.datasource.plugin.rdbms.ConnFactory;
import com.dtstack.taier.datasource.api.dto.ColumnMetaDTO;
import com.dtstack.taier.datasource.api.dto.SqlQueryDTO;
import com.dtstack.taier.datasource.api.dto.source.ISourceDTO;
import com.dtstack.taier.datasource.api.dto.source.PrestoSourceDTO;
import com.dtstack.taier.datasource.api.dto.source.RdbmsSourceDTO;
import com.dtstack.taier.datasource.api.exception.SourceException;
import com.dtstack.taier.datasource.api.source.DataSourceType;
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

/**
 * presto ??????????????????????????? catalog ??????????????????url?????????schema?????????????????????
 *
 * @author ???wangchuan
 * date???Created in ??????9:50 2021/3/23
 * company: www.dtstack.com
 */
@Slf4j
public class PrestoClient extends AbsRdbmsClient {

    // ????????????schema
    private static final String SHOW_DB_LIKE = "SHOW SCHEMAS LIKE '%s'";

    // ??????schema
    private static final String CREATE_SCHEMA = "CREATE SCHEMA %s";

    // ??????table?????????schema??? ??????????????????
    private static final String TABLE_IS_IN_SCHEMA = "SELECT table_name FROM information_schema.tables WHERE table_schema='%s' AND table_name = '%s'";

    // ??????presto ???????????????
    private static final String SHOW_CATALOG_SQL = "SHOW CATALOGS";

    // ????????????????????????schema
    private static final String SHOW_SCHEMA_SQL = "SHOW SCHEMAS";

    // ??????????????????????????????
    private static final String SHOW_TABLE_SQL = "SHOW TABLES";

    // ????????????schema????????????????????????
    private static final String SHOW_TABLE_AND_VIEW_BY_SCHEMA_SQL = "SELECT table_name FROM information_schema.tables WHERE table_schema = '%s' ";

    // ????????????schema???????????????????????????
    private static final String SHOW_TABLE_BY_SCHEMA_SQL = "SELECT table_name FROM information_schema.tables WHERE table_schema = '%s' AND table_type = 'BASE TABLE' ";

    // ???????????????????????????????????????????????????schema?????????schema???tableName???????????????????????????
    private static final String ALL_TABLE_AND_VIEW_SQL = "SELECT '\"'||table_schema||'\".\"'||table_name||'\"' AS schema_table FROM information_schema.tables order by schema_table ";

    // ??????????????????????????????????????????????????????schema?????????schema???tableName???????????????????????????
    private static final String ALL_TABLE_SQL = "SELECT '\"'||table_schema||'\".\"'||table_name||'\"' AS schema_table FROM information_schema.tables WHERE table_type = 'BASE TABLE'  order by schema_table ";

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
        return new PrestoConnFactory();
    }

    @Override
    protected DataSourceType getSourceType() {
        return DataSourceType.Presto;
    }

    @Override
    public List<String> getTableList(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        try {
            Integer fetchSize = ReflectUtil.fieldExists(SqlQueryDTO.class, "fetchSize") ? queryDTO.getFetchSize() : null;
            return SearchUtil.handleSearchAndLimit(queryWithSingleColumn(sourceDTO, queryDTO, SHOW_TABLE_SQL, 1,"get table exception according to schema..."), queryDTO);
        } catch (Exception e) {
            // ??????url ?????????????????? schema??????????????????catalog???????????????????????????????????? "schema"."table"
            if (e.getMessage().contains(SCHEMA_MUST_BE_SET)) {
                return SearchUtil.handleSearchAndLimit(getTableListBySchema(sourceDTO, queryDTO), queryDTO);
            }
            throw new SourceException(e.getMessage(), e);
        }
    }

    @Override
    public String getTableMetaComment(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        // presto????????????????????????
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
        PrestoSourceDTO prestoSourceDTO = (PrestoSourceDTO) sourceDTO;
        // schema ??????queryDTO?????????
        String schema = StringUtils.isBlank(queryDTO.getSchema()) ? prestoSourceDTO.getSchema() : queryDTO.getSchema();
        // ????????????
        if (BooleanUtils.isTrue(queryDTO.getView())) {
            // schema????????????????????????schema?????????
            if (StringUtils.isBlank(schema)) {
                return ALL_TABLE_AND_VIEW_SQL;
            } else {
                return String.format(SHOW_TABLE_AND_VIEW_BY_SCHEMA_SQL, schema);
            }
        } else {
            if (StringUtils.isBlank(schema)) {
                return ALL_TABLE_SQL;
            } else {
                return String.format(SHOW_TABLE_BY_SCHEMA_SQL, schema);
            }
        }
    }

    @Override
    public List<ColumnMetaDTO> getColumnMetaData(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO);
        PrestoSourceDTO prestoSourceDTO = (PrestoSourceDTO) sourceDTO;
        // schema ??????queryDTO?????????
        String schema = StringUtils.isBlank(queryDTO.getSchema()) ? prestoSourceDTO.getSchema() : queryDTO.getSchema();
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
        PrestoSourceDTO prestoSourceDTO = (PrestoSourceDTO) sourceDTO;
        // ????????????????????????schema???????????????????????????????????????schema??????
        String tableName = transferSchemaAndTableName(prestoSourceDTO, queryDTO);
        List<String> result = queryWithSingleColumn(sourceDTO, null, String.format(SHOW_CREATE_TABLE_SQL, tableName), 1, "failed to get table create sql...");
        if (CollectionUtils.isEmpty(result)) {
            throw new SourceException("failed to get table create sql...");
        }
        return result.get(0);
    }

    @Override
    protected String getShowDbSql() {
        return SHOW_SCHEMA_SQL;
    }

    @Override
    protected String getCatalogSql() {
        return SHOW_CATALOG_SQL;
    }

    /**
     * ????????????schema???????????????????????????
     *
     * @param schema  schema
     * @param comment ??????
     * @return sql??????
     */
    @Override
    protected String getCreateDatabaseSql(String schema, String comment) {
        return String.format(CREATE_SCHEMA, schema);
    }

    /**
     * ?????? presto schema???tableName?????????schema???tableName??????.?????????
     *
     * @param schema    schema???
     * @param tableName ??????
     * @return ??????????????????
     */
    @Override
    protected String transferSchemaAndTableName(String schema, String tableName) {
        if (StringUtils.isBlank(schema)) {
            return tableName;
        }
        return String.format("%s.%s", schema, tableName);
    }
}
