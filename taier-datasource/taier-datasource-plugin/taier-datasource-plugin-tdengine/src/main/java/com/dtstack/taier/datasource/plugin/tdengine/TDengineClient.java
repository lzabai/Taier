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

package com.dtstack.taier.datasource.plugin.tdengine;

import com.dtstack.taier.datasource.plugin.common.utils.ColumnUtil;
import com.dtstack.taier.datasource.plugin.common.utils.DBUtil;
import com.dtstack.taier.datasource.plugin.common.utils.SearchUtil;
import com.dtstack.taier.datasource.plugin.rdbms.AbsRdbmsClient;
import com.dtstack.taier.datasource.plugin.rdbms.ConnFactory;
import com.dtstack.taier.datasource.api.dto.ColumnMetaDTO;
import com.dtstack.taier.datasource.api.dto.SqlQueryDTO;
import com.dtstack.taier.datasource.api.dto.source.ISourceDTO;
import com.dtstack.taier.datasource.api.dto.source.RdbmsSourceDTO;
import com.dtstack.taier.datasource.api.exception.SourceException;
import com.dtstack.taier.datasource.api.source.DataSourceType;
import com.taosdata.jdbc.rs.RestfulResultSet;
import com.taosdata.jdbc.rs.RestfulResultSetMetaData;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

/**
 * TDengine?????????
 *
 * @author luming
 * date 2022/3/31
 */
@Slf4j
public class TDengineClient extends AbsRdbmsClient {
    /**
     * ????????????????????????????????????????????????????????????????????????????????????10???
     */
    private static final String CREATE_DB = "create database %s";

    private static final String GET_TABLES = "show tables";

    private static final String SHOW_TABLES_LIKE = "show tables like %s";

    private static final String GET_STABLES = "show stables";

    private static final String SHOW_STABLES_LIKE = "show stables like %s";

    private static final String CURRENT_DB = "select database()";

    private static final String SHOW_DB_SQL = "show databases";

    private static final String SHOW_VAR = "show variables";

    private static final String USE_DB = "use '%s'";

    @Override
    protected ConnFactory getConnFactory() {
        return new TDengineConFactory();
    }

    @Override
    protected DataSourceType getSourceType() {
        return DataSourceType.TDENGINE;
    }

    @Override
    protected String getCreateDatabaseSql(String dbName, String comment) {
        if (dbName.length() > 32) {
            throw new SourceException("max dbName is 32");
        }
        //??????????????????
        return String.format(CREATE_DB, dbName);
    }

    public String getQueryColumnSql(SqlQueryDTO queryDTO, RdbmsSourceDTO rdbmsSourceDTO) {
        //TDengine?????????rdbms???where 1=2????????????
        return String.format(
                "select %s from %s limit 1",
                ColumnUtil.listToStr(queryDTO.getColumns()), transferSchemaAndTableName(rdbmsSourceDTO, queryDTO));
    }

    @Override
    protected String getCurrentDbSql() {
        return CURRENT_DB;
    }

    @Override
    public Boolean isDatabaseExists(ISourceDTO source, String dbName) {
        if (StringUtils.isBlank(dbName)) {
            throw new SourceException("database name is not empty");
        }
        List<String> allDb = queryWithSingleColumn(source, null, SHOW_DB_SQL, 1, "get All database exception");
        if (CollectionUtils.isEmpty(allDb)) {
            return false;
        }

        //?????????????????????????????????????????????,?????????????????????????????????
        for (String db : allDb) {
            if (db.equalsIgnoreCase(dbName)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public Boolean isTableExistsInDatabase(ISourceDTO source, String tableName, String dbName) {
        if (StringUtils.isBlank(tableName) || StringUtils.isBlank(dbName)) {
            throw new SourceException("param can't be empty");
        }
        //??????db???????????????db?????????????????????like??????
        if (dbName.equals(getCurrentDatabase(source))) {
            List<String> tables = queryWithSingleColumn(
                    source, null, String.format(SHOW_TABLES_LIKE, tableName), 1, "query table exists error");
            if (CollectionUtils.isEmpty(tables)) {
                return false;
            }
            return tables.size() == 1 && tables.get(0).equals(tableName);
        } else {
            List<String> tables = getTableListBySchema(source, SqlQueryDTO.builder().schema(dbName).build());
            if (CollectionUtils.isEmpty(tables)) {
                return false;
            }

            //?????????????????????????????????????????????,?????????????????????????????????
            for (String dbTable : tables) {
                if (dbTable.equalsIgnoreCase(tableName)) {
                    return true;
                }
            }
            return false;
        }
    }

    @Override
    public String getVersion(ISourceDTO source) {
        List<Map<String, Object>> varList = executeQuery(source, SqlQueryDTO.builder().sql(SHOW_VAR).build());
        for (Map<String, Object> map : varList) {
            String s = new String((byte[]) map.get("name"));
            if ("version".equals(s)) {
                return new String((byte[]) map.get("value"));
            }
        }
        return "";
    }

    @Override
    public List<ColumnMetaDTO> getColumnMetaData(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        RdbmsSourceDTO rdbmsSourceDTO = (RdbmsSourceDTO) sourceDTO;
        Statement statement = null;
        ResultSet rs = null;
        List<ColumnMetaDTO> columns = new ArrayList<>();
        try {
            statement = connection.createStatement();
            statement.setMaxRows(1);
            String queryColumnSql = getQueryColumnSql(queryDTO, rdbmsSourceDTO);
            rs = statement.executeQuery(queryColumnSql);
            RestfulResultSetMetaData rsMetaData = (RestfulResultSetMetaData) rs.getMetaData();
            List<RestfulResultSet.Field> fields = rsMetaData.getFields();
            for (int i = 0; i < fields.size(); i++) {
                ColumnMetaDTO columnMetaDTO = new ColumnMetaDTO();
                columnMetaDTO.setKey(rsMetaData.getColumnName(i + 1));
                columnMetaDTO.setType(doDealType(rsMetaData, i));
                columnMetaDTO.setPart(false);
                // ??????????????????
                if (columnMetaDTO.getType().equalsIgnoreCase("binary")
                        || columnMetaDTO.getType().equalsIgnoreCase("float")
                        || columnMetaDTO.getType().equalsIgnoreCase("double")
                        || columnMetaDTO.getType().equalsIgnoreCase("nchar")) {
                    columnMetaDTO.setScale(rsMetaData.getScale(i + 1));
                    columnMetaDTO.setPrecision(rsMetaData.getPrecision(i + 1));
                }

                columns.add(columnMetaDTO);
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("doesn't exist")) {
                throw new SourceException(String.format(queryDTO.getTableName() + "table not exist,%s", e.getMessage()), e);
            } else {
                throw new SourceException(String.format("Failed to get the meta information of the fields of the table: %s. Please contact the DBA to check the database and table information: %s",
                        queryDTO.getTableName(), e.getMessage()), e);
            }
        } finally {
            DBUtil.closeDBResources(rs, statement, connection);
        }

        //?????????????????????
        return columns;
    }

    @Override
    public List<String> getTableList(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        return getTableList(sourceDTO, queryDTO, null);
    }

    /**
     * TDengine?????????????????????list
     *
     * @param sourceDTO  sourceDTO
     * @param queryDTO   queryDTO
     * @param connection jdbc connection
     * @return table list
     */
    private List<String> getTableList(ISourceDTO sourceDTO, SqlQueryDTO queryDTO, Connection connection) {
        // ???????????????show tables ????????????????????????show stables???????????????????????????
        String normalSql;
        if (Objects.nonNull(queryDTO) && StringUtils.isNotEmpty(queryDTO.getTableNamePattern())) {
            // ????????????,?????????????????????
            normalSql = String.format(SHOW_TABLES_LIKE, "'" + addFuzzySign(queryDTO) + "'");
        } else {
            normalSql = GET_TABLES;
        }
        List<String> normalTables = getTableByType(sourceDTO, queryDTO, normalSql, connection, false);

        String superSql;
        if (Objects.nonNull(queryDTO) && StringUtils.isNotEmpty(queryDTO.getTableNamePattern())) {
            superSql = String.format(SHOW_STABLES_LIKE, "'" + addFuzzySign(queryDTO) + "'");
        } else {
            superSql = GET_STABLES;
        }
        normalTables.addAll(getTableByType(sourceDTO, queryDTO, superSql, connection, true));

        return normalTables;
    }

    /**
     * ?????????????????????????????????????????????????????????
     *
     * @param sourceDTO  sourceDTO
     * @param queryDTO   queryDTO
     * @param sql        ?????????sql
     * @param connection jdbc connection
     * @param needClose  ????????????????????????????????????????????????
     * @return table list
     */
    private List<String> getTableByType(ISourceDTO sourceDTO,
                                        SqlQueryDTO queryDTO,
                                        String sql,
                                        Connection connection,
                                        boolean needClose) {
        try {
            connection = Optional.ofNullable(connection).orElse(getCon(sourceDTO, queryDTO));
            List<String> tableList = new ArrayList<>();
            try (Statement statement = connection.createStatement()) {
                if (Objects.nonNull(queryDTO) && Objects.nonNull(queryDTO.getLimit())) {
                    // ??????????????????
                    statement.setMaxRows(queryDTO.getLimit());
                }
                DBUtil.setFetchSize(statement, queryDTO);
                try (ResultSet rs = statement.executeQuery(sql)) {
                    while (rs.next()) {
                        tableList.add(rs.getString(1));
                    }
                    return SearchUtil.handleSearchAndLimit(tableList, queryDTO);
                }
            }
        } catch (Exception e) {
            throw new SourceException("getTableByType error ", e);
        } finally {
            if (needClose) {
                DBUtil.closeDBResources(null, null, connection);
            }
        }
    }

    @Override
    public List<String> getTableListBySchema(ISourceDTO source, SqlQueryDTO queryDTO) {
        //??????connection?????????use db???????????????
        Connection con = getCon(source);
        String schema = queryDTO.getSchema();
        // ????????????scheme????????????????????????????????????schema
        if (StringUtils.isBlank(schema)) {
            log.info("schema is empty???get current used schema!");
            try {
                schema = getCurrentDatabase(source);
            } catch (Exception e) {
                throw new SourceException(String.format("get current used database error???,%s", e.getMessage()), e);
            }
        } else {
            try {
                executeSqlOpenCon(con, String.format(USE_DB, schema));
            } catch (Exception e) {
                throw new SourceException(String.format("use db : %s error.", schema), e);
            }
        }
        log.info("current used schema???{}", schema);

        return getTableList(source, queryDTO, con);
    }


    /**
     * ??????sql????????????connection???????????????connection?????????????????????
     *
     * @param con
     * @param sql
     * @throws Exception
     */
    private void executeSqlOpenCon(Connection con, String sql) throws Exception {
        try (Statement statement = con.createStatement()) {
            statement.execute(sql);
        }
    }

    @Override
    protected Object dealResult(Object result) {
        if (Objects.nonNull(result) && result instanceof Timestamp) {
            return result.toString();
        }
        return result;
    }
}
