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

package com.dtstack.taier.datasource.plugin.rdbms;

import com.dtstack.taier.datasource.plugin.common.DtClassConsistent;
import com.dtstack.taier.datasource.plugin.common.DtClassThreadFactory;
import com.dtstack.taier.datasource.plugin.common.exception.ErrorCode;
import com.dtstack.taier.datasource.plugin.common.service.ConnectionDealer;
import com.dtstack.taier.datasource.plugin.common.utils.ColumnUtil;
import com.dtstack.taier.datasource.plugin.common.utils.CommonUtil;
import com.dtstack.taier.datasource.plugin.common.utils.DBUtil;
import com.dtstack.taier.datasource.plugin.common.utils.FileUtil;
import com.dtstack.taier.datasource.plugin.common.utils.DateUtil;
import com.dtstack.taier.datasource.plugin.common.utils.ReflectUtil;
import com.dtstack.taier.datasource.plugin.common.utils.SearchUtil;
import com.dtstack.taier.datasource.plugin.common.utils.StringUtil;
import com.dtstack.taier.datasource.api.client.IClient;
import com.dtstack.taier.datasource.api.dto.ColumnMetaDTO;
import com.dtstack.taier.datasource.api.dto.Database;
import com.dtstack.taier.datasource.api.dto.SqlQueryDTO;
import com.dtstack.taier.datasource.api.dto.Table;
import com.dtstack.taier.datasource.api.dto.TableInfo;
import com.dtstack.taier.datasource.api.dto.WriteFileDTO;
import com.dtstack.taier.datasource.api.dto.source.ISourceDTO;
import com.dtstack.taier.datasource.api.dto.source.RdbmsSourceDTO;
import com.dtstack.taier.datasource.api.enums.ImportDataMatchType;
import com.dtstack.taier.datasource.api.enums.MatchType;
import com.dtstack.taier.datasource.api.exception.SourceException;
import com.dtstack.taier.datasource.api.source.DataSourceType;
import com.dtstack.taier.datasource.api.utils.AssertUtils;
import com.dtstack.taier.datasource.api.downloader.IDownloader;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;

import java.math.BigDecimal;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.stream.Collectors;

/**
 * @author ???nanqi
 * company: www.dtstack.com
 * date ???Created in 15:59 2020/1/3
 * description????????????
 */
@Slf4j
public abstract class AbsRdbmsClient implements IClient {

    private final ConnFactory connFactory = getConnFactory();

    /**
     * ??????????????????
     *
     * @return connection ??????
     */
    protected abstract ConnFactory getConnFactory();

    /**
     * ?????????????????????
     *
     * @return ???????????????
     */
    protected abstract DataSourceType getSourceType();

    private static final String DONT_EXIST = "doesn't exist";

    private static final String SHOW_DB_SQL = "show databases";

    private static final String SEMICOLON = ";";

    private static final String SHOW_CREATE_TABLE_SQL = "show create table %s";

    private static final String DESC_KEY = "desc ";

    private static final String META_SCHEMA_PATH = "/.metastore/schema";

    //????????? - ????????????????????????????????????????????????
    protected static ExecutorService executor = new ThreadPoolExecutor(5, 10, 1L, TimeUnit.MINUTES, new ArrayBlockingQueue<>(5), new DtClassThreadFactory("testConnFactory"));

    /**
     * rdbms?????????????????????????????????????????????????????????????????????
     *
     * @param sourceDTO ???????????????
     * @return jdbc connection
     */
    public Connection getCon(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection con = getCon(sourceDTO);
        if (Objects.nonNull(queryDTO) && CollectionUtils.isNotEmpty(queryDTO.getPreSqlList())) {
            executePreSql(con, queryDTO.getPreSqlList());
        }
        return con;
    }

    private void executePreSql(Connection conn, List<String> preSqlList) {
        preSqlList.forEach(sql -> DBUtil.executeSql(conn, sql));
    }

    /**
     * rdbms ?????????????????????????????????????????????????????????????????????
     *
     * @param sourceDTO ???????????????
     * @return jdbc connection
     */
    public Connection getCon(ISourceDTO sourceDTO) {
        try {
            // ?????? sourceDTO ???????????? connection, ???????????? connection
            Connection connOrigin = sourceDTO.getConnection();
            if (Objects.nonNull(connOrigin) && connFactory.testConnection(connOrigin)) {
                ConnectionDealer.put(connOrigin, true, getSourceType().getVal());
                return connOrigin;
            }
            Connection connection = connFactory.getConn(sourceDTO);
            ConnectionDealer.put(connection, false, getSourceType().getVal());
            return connection;
        } catch (Exception e) {
            throw new SourceException(e.getMessage(), e);
        }
    }

    @Override
    public Boolean testCon(ISourceDTO sourceDTO) {
        return connFactory.testConn(sourceDTO);
    }

    @Override
    public Boolean executeBatchQuery(ISourceDTO source, SqlQueryDTO queryDTO) {
        //?????????????????????
        String sql = queryDTO.getSql();
        if (StringUtils.isBlank(sql)) {
            throw new SourceException("sql ????????????");
        }

        if (connFactory.supportProcedure(sql)) {
            //????????????????????????
            String procName = CommonUtil.createShortUuid();
            StringBuilder sb = new StringBuilder(connFactory.getCreateProcHeader(procName));
            sb.append(sql);
            if (!sql.trim().endsWith(SEMICOLON)) {
                sb.append(SEMICOLON);
            }
            sb.append(connFactory.getCreateProcTail());
            queryDTO.setSql(sb.toString());
            return executeProc(source, queryDTO, procName);
        } else {
            List<String> sqlList = connFactory.buildSqlList(queryDTO);
            return executeWithTransaction(source, sqlList);
        }
    }

    private boolean executeProc(ISourceDTO source, SqlQueryDTO queryDTO, String procName) {
        Connection conn = null;
        Statement procStmt = null;
        CallableStatement callStmt = null;
        try {
            conn = getCon(source, queryDTO);
            //??????????????????
            procStmt = conn.createStatement();
            procStmt.execute(queryDTO.getSql());

            //??????????????????
            String procCall = connFactory.getCallProc(procName);
            callStmt = conn.prepareCall(procCall);
            callStmt.execute();
            return true;
        } catch (Exception e) {
            log.error("execute sql error ", e);
            throw new SourceException(String.format("execute sql error: %s", e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(null, procStmt, null);
            Statement dropStmt = null;
            try {
                if (conn != null) {
                    //??????????????????
                    String dropSql = connFactory.getDropProc(procName);
                    dropStmt = conn.createStatement();
                    dropStmt.execute(dropSql);
                }
            } catch (Exception e) {
                log.error("", e);
            } finally {
                DBUtil.closeDBResources(null, dropStmt, null);
            }
            DBUtil.closeDBResources(null, callStmt, conn);
        }
    }

    private boolean executeWithTransaction(ISourceDTO source, List<String> sqlList) {
        Connection conn = null;
        Statement statement = null;

        try {
            conn = getCon(source);
            if (connFactory.supportTransaction()) {
                conn.setAutoCommit(false);
            }
            statement = conn.createStatement();

            for (int i = 0; i < sqlList.size(); i++) {
                String sql = sqlList.get(i);
                boolean skipExec = DBUtil.isSelectSql(sql)
                        && !connFactory.supportSelectSql()
                        && !DBUtil.isSelectFunctionSql(sql);
                if (skipExec) {
                    log.info("exe {} line skip", i + 1);
                    continue;
                }

                Matcher matcher = DBUtil.OUTPUT_DIR_PATTERN.matcher(sql);
                if (matcher.find()) {
                    String outputSql = sql.replace("output directory", "insert overwrite directory");
                    try {
                        statement.execute(outputSql);
                    } catch (SQLException e) {
                        log.error("output sql exec error, sql: {}", outputSql, e);
                    }
                    Matcher insertMatcher = DBUtil.INSERT_DIR_PATTERN.matcher(outputSql);

                    if (insertMatcher.find()) {
                        String outputDir = insertMatcher.group(2) + META_SCHEMA_PATH;
                        String descSql = DESC_KEY + insertMatcher.group(4);
                        if (statement.execute(descSql)) {
                            ResultSet resultSet = statement.getResultSet();
                            List<String> columns = Lists.newArrayList();
                            while (resultSet.next()) {
                                columns.add(resultSet.getString(1));
                            }
                            String schema = StringUtils.join(columns.toArray(new String[]{}), "\n");
                            writeSchemaFile(source, schema, outputDir);
                        }
                    }
                    continue;
                }

                long sqlStart = System.currentTimeMillis();
                statement.execute(sqlList.get(i));
                log.info("exe {} line success,cost={} ms", i + 1, System.currentTimeMillis() - sqlStart);
            }
            if (connFactory.supportTransaction()) {
                conn.commit();
            }
            return true;
        } catch (Exception e) {
            log.error("exe error , ex= ", e);
            if (connFactory.supportTransaction()) {
                try {
                    if (conn != null) {
                        conn.rollback();
                    }
                } catch (SQLException e1) {
                    log.error("rollback error,ex= ", e1);
                }
            }
            throw new SourceException(String.format("execute sql error: %s", e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(null, statement, conn);
        }
    }

    protected void writeSchemaFile(ISourceDTO source, String schema, String outputDir) {
    }

    /**
     * ?????? sql , ????????????????????? connection
     *
     * @param connection jdbc ??????
     * @param queryDTO   ????????????
     * @param closeConn  ???????????? connection
     * @return ????????????
     */
    public List<Map<String, Object>> executeQuery(Connection connection, SqlQueryDTO queryDTO, boolean closeConn) {
        try {
            // ???????????????
            if (CollectionUtils.isNotEmpty(queryDTO.getPreFields())) {
                return DBUtil.executePreSql(connection, queryDTO.getSql(), queryDTO.getLimit(), queryDTO.getPreFields(), queryDTO.getQueryTimeout(), queryDTO.getSetMaxRow(), this::dealResult);
            }
            return DBUtil.executeSql(connection, queryDTO.getSql(), queryDTO.getLimit(), queryDTO.getQueryTimeout(), queryDTO.getSetMaxRow(), this::dealResult);
        } finally {
            DBUtil.closeDBResources(null, null, closeConn ? connection : null);
        }
    }

    @Override
    public List<Map<String, Object>> executeQuery(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        return executeQuery(getCon(sourceDTO, queryDTO), queryDTO, true);
    }

    @Override
    public Map<String, List<Map<String, Object>>> executeMultiQuery(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        try {
            return DBUtil.executeMultiQuery(connection, queryDTO.getSqlMultiDTOList(), queryDTO.getLimit(), queryDTO.getQueryTimeout(), queryDTO.getSetMaxRow(), this::dealResult);
        } finally {
            DBUtil.closeDBResources(null, null, connection);
        }
    }

    @Override
    public Integer executeUpdate(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        try {
            // ???????????????
            if (CollectionUtils.isNotEmpty(queryDTO.getPreUpsertFields())) {
                return DBUtil.executeUpdate(connection, queryDTO.getSql(), queryDTO.getPreUpsertFields(), queryDTO.getAutoCommit(), queryDTO.getRollback());
            }
            return DBUtil.executeUpdate(connection, queryDTO.getSql(), queryDTO.getAutoCommit(), queryDTO.getRollback());

        } finally {
            DBUtil.closeDBResources(null, null, connection);
        }
    }

    @Override
    public Boolean executeSqlWithoutResultSet(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        executeQuery(sourceDTO, queryDTO);
        return true;
    }

    @Override
    public List<String> getTableList(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        RdbmsSourceDTO rdbmsSourceDTO = (RdbmsSourceDTO) sourceDTO;
        ResultSet rs = null;
        List<String> tableList = new ArrayList<>();
        try {
            DatabaseMetaData meta = connection.getMetaData();
            if (null == queryDTO) {
                rs = meta.getTables(null, null, null, null);
            } else {
                rs = meta.getTables(null, rdbmsSourceDTO.getSchema(), null, DBUtil.getTableTypes(queryDTO));
            }
            while (rs.next()) {
                tableList.add(rs.getString(3));
            }
        } catch (Exception e) {
            throw new SourceException(String.format("Get database table exception???%s", e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(rs, null, connection);
        }
        return SearchUtil.handleSearchAndLimit(tableList, queryDTO);
    }

    /**
     * ???????????????????????????
     *
     * @param source   ???????????????
     * @param queryDTO ????????????
     * @return ?????????
     */
    @Override
    public List<String> getTableListBySchema(ISourceDTO source, SqlQueryDTO queryDTO) {
        String sql = getTableBySchemaSql(source, queryDTO);
        return queryWithSingleColumn(source, queryDTO, sql, 1, "get table exception according to schema...");
    }

    /**
     * ????????????sql??????????????????
     *
     * @param source      ???????????????
     * @param queryDTO    ????????????
     * @param sql         sql??????
     * @param columnIndex ????????????
     * @param errMsg      ????????????
     * @return ????????????
     */
    protected List<String> queryWithSingleColumn(ISourceDTO source, SqlQueryDTO queryDTO, String sql, Integer columnIndex, String errMsg) {
        return queryWithSingleColumn(source, queryDTO, sql, columnIndex, errMsg, null);
    }

    /**
     * ????????????sql??????????????????
     *
     * @param source      ???????????????
     * @param queryDTO    ????????????
     * @param sql         sql??????
     * @param columnIndex ????????????
     * @param errMsg      ????????????
     * @param limit       ????????????
     * @return ????????????
     */
    protected List<String> queryWithSingleColumn(ISourceDTO source, SqlQueryDTO queryDTO, String sql, Integer columnIndex, String errMsg, Integer limit) {
        AssertUtils.notBlank(sql, "execute sql can't be null.");
        Connection connection = getCon(source, queryDTO);
        log.info("The SQL executed by method queryWithSingleColumn is:{}", sql);
        Statement statement = null;
        ResultSet rs = null;
        List<String> result = new ArrayList<>();
        try {
            statement = connection.createStatement();
            DBUtil.setFetchSize(statement, Objects.isNull(queryDTO) ? null : queryDTO.getFetchSize());
            if (Objects.nonNull(limit)) {
                statement.setMaxRows(limit);
            }
            rs = statement.executeQuery(sql);
            while (rs.next()) {
                result.add(rs.getString(columnIndex == null ? 1 : columnIndex));
            }
        } catch (Exception e) {
            throw new SourceException(String.format("%s:%s", errMsg, e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(rs, statement, connection);
        }
        return result;
    }

    @Override
    public List<String> getColumnClassInfo(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        RdbmsSourceDTO rdbmsSourceDTO = (RdbmsSourceDTO) sourceDTO;

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = connection.createStatement();
            String queryColumnSql = getQueryColumnSql(queryDTO, rdbmsSourceDTO);
            rs = stmt.executeQuery(queryColumnSql);
            ResultSetMetaData rsmd = rs.getMetaData();
            int cnt = rsmd.getColumnCount();
            List<String> columnClassNameList = Lists.newArrayList();

            for (int i = 0; i < cnt; i++) {
                String columnClassName = rsmd.getColumnClassName(i + 1);
                columnClassNameList.add(columnClassName);
            }

            return columnClassNameList;
        } catch (Exception e) {
            throw new SourceException(e.getMessage(), e);
        } finally {
            DBUtil.closeDBResources(rs, stmt, connection);
        }
    }

    public String getQueryColumnSql(SqlQueryDTO queryDTO, RdbmsSourceDTO rdbmsSourceDTO) {
        return "select " + ColumnUtil.listToStr(queryDTO.getColumns())
                + " from " + transferSchemaAndTableName(rdbmsSourceDTO, queryDTO)
                + " where 1=2";
    }

    @Override
    public List<ColumnMetaDTO> getColumnMetaDataWithSql(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        Statement statement = null;
        ResultSet rs = null;
        List<ColumnMetaDTO> columns = new ArrayList<>();
        try {
            statement = connection.createStatement();
            statement.setMaxRows(1);
            String queryColumnSql = queryDTO.getSql();
            rs = statement.executeQuery(queryColumnSql);
            ResultSetMetaData rsMetaData = rs.getMetaData();
            for (int i = 0, len = rsMetaData.getColumnCount(); i < len; i++) {
                ColumnMetaDTO columnMetaDTO = new ColumnMetaDTO();
                columnMetaDTO.setKey(rsMetaData.getColumnLabel(i + 1));
                columnMetaDTO.setType(doDealType(rsMetaData, i));
                columnMetaDTO.setPart(false);
                // ??????????????????
                if (columnMetaDTO.getType().equalsIgnoreCase("decimal")
                        || columnMetaDTO.getType().equalsIgnoreCase("float")
                        || columnMetaDTO.getType().equalsIgnoreCase("double")
                        || columnMetaDTO.getType().equalsIgnoreCase("numeric")) {
                    columnMetaDTO.setScale(rsMetaData.getScale(i + 1));
                    columnMetaDTO.setPrecision(rsMetaData.getPrecision(i + 1));
                }

                columns.add(columnMetaDTO);
            }
            return columns;

        } catch (SQLException e) {
            if (e.getMessage().contains(DONT_EXIST)) {
                throw new SourceException(String.format(queryDTO.getTableName() + "table not exist,%s", e.getMessage()), e);
            } else {
                throw new SourceException(String.format("Failed to get the meta information of the fields of the table: %s. Please contact the DBA to check the database and table information: %s",
                        queryDTO.getTableName(), e.getMessage()), e);
            }
        } finally {
            DBUtil.closeDBResources(rs, statement, connection);
        }
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
            ResultSetMetaData rsMetaData = rs.getMetaData();
            for (int i = 0, len = rsMetaData.getColumnCount(); i < len; i++) {
                ColumnMetaDTO columnMetaDTO = new ColumnMetaDTO();
                columnMetaDTO.setKey(rsMetaData.getColumnName(i + 1));
                columnMetaDTO.setType(doDealType(rsMetaData, i));
                columnMetaDTO.setPart(false);
                // ??????????????????
                if (columnMetaDTO.getType().equalsIgnoreCase("decimal")
                        || columnMetaDTO.getType().equalsIgnoreCase("float")
                        || columnMetaDTO.getType().equalsIgnoreCase("double")
                        || columnMetaDTO.getType().equalsIgnoreCase("numeric")) {
                    columnMetaDTO.setScale(rsMetaData.getScale(i + 1));
                    columnMetaDTO.setPrecision(rsMetaData.getPrecision(i + 1));
                }

                columns.add(columnMetaDTO);
            }
        } catch (SQLException e) {
            if (e.getMessage().contains(DONT_EXIST)) {
                throw new SourceException(String.format(queryDTO.getTableName() + "table not exist,%s", e.getMessage()), e);
            } else {
                throw new SourceException(String.format("Failed to get the meta information of the fields of the table: %s. Please contact the DBA to check the database and table information: %s",
                        queryDTO.getTableName(), e.getMessage()), e);
            }
        } finally {
            DBUtil.closeDBResources(rs, statement, connection);
        }

        //??????????????????
        Map<String, String> columnComments = getColumnComments(rdbmsSourceDTO, queryDTO);
        if (Objects.isNull(columnComments)) {
            return columns;
        }
        for (ColumnMetaDTO columnMetaDTO : columns) {
            if (columnComments.containsKey(columnMetaDTO.getKey())) {
                columnMetaDTO.setComment(columnComments.get(columnMetaDTO.getKey()));
            }
        }
        return columns;

    }

    @Override
    public List<ColumnMetaDTO> getFlinkColumnMetaData(ISourceDTO iSource, SqlQueryDTO queryDTO) {
        return getColumnMetaData(iSource, queryDTO);
    }

    @Override
    public String getTableMetaComment(ISourceDTO iSource, SqlQueryDTO queryDTO) {
        return "";
    }

    /**
     * rdbms ????????????
     *
     * @param sourceDTO ???????????????
     * @param queryDTO  ????????????
     * @return ??????????????????
     */
    @Override
    public List<List<Object>> getPreview(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        RdbmsSourceDTO rdbmsSourceDTO = (RdbmsSourceDTO) sourceDTO;
        List<List<Object>> previewList = new ArrayList<>();
        if (StringUtils.isBlank(queryDTO.getTableName())) {
            return previewList;
        }
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = connection.createStatement();
            //??????sql???????????????100???
            String querySql = dealSql(rdbmsSourceDTO, queryDTO);
            if (queryDTO.getPreviewNum() != null) {
                stmt.setMaxRows(queryDTO.getPreviewNum());
            }
            rs = stmt.executeQuery(querySql);
            ResultSetMetaData rsmd = rs.getMetaData();
            //??????????????????
            List<Object> metaDataList = Lists.newArrayList();
            //????????????
            int len = rsmd.getColumnCount();
            for (int i = 0; i < len; i++) {
                metaDataList.add(rsmd.getColumnLabel(i + 1));
            }
            previewList.add(metaDataList);
            while (rs.next()) {
                //??????columnData????????????????????????
                ArrayList<Object> columnData = Lists.newArrayList();
                for (int i = 0; i < len; i++) {
                    String result = dealPreviewResult(rs.getObject(i + 1));
                    columnData.add(result);
                }
                previewList.add(columnData);
            }
        } catch (Exception e) {
            throw new SourceException(e.getMessage(), e);
        } finally {
            DBUtil.closeDBResources(rs, stmt, connection);
        }
        return previewList;
    }

    /**
     * ?????? RDBMS ???????????????????????????????????? string ??????
     *
     * @param result ????????????
     * @return ??????????????????
     */
    protected String dealPreviewResult(Object result) {
        Object dealResult = dealResult(result);
        if (dealResult instanceof BigDecimal) {
            return ((BigDecimal) dealResult).toPlainString();
        }
        // ???????????? toString
        return Objects.isNull(dealResult) ? "" : dealResult.toString();
    }

    /**
     * ??????jdbc????????????
     *
     * @param result ????????????
     * @return ??????????????????
     */
    protected Object dealResult(Object result) {
        if (Objects.nonNull(result) && result instanceof Timestamp) {
            Timestamp ts = (Timestamp) result;
            return DateUtil.getFormattedDateTime(ts.getTime());
        }
        return result;
    }

    /**
     * ??????sql??????????????????
     *
     * @param sqlQueryDTO ????????????
     * @return ??????????????????sql
     */
    protected String dealSql(ISourceDTO sourceDTO, SqlQueryDTO sqlQueryDTO) {
        return "select * from " + transferSchemaAndTableName(sourceDTO, sqlQueryDTO);
    }

    /**
     * ?????? schema ??? ?????????????????? SqlQueryDTO ?????? schema
     *
     * @param sourceDTO   ?????????????????????
     * @param sqlQueryDTO ????????????
     * @return ???????????? schema ??? table
     */
    protected String transferSchemaAndTableName(ISourceDTO sourceDTO, SqlQueryDTO sqlQueryDTO) {
        RdbmsSourceDTO rdbmsSourceDTO = (RdbmsSourceDTO) sourceDTO;
        String schema = StringUtils.isNotBlank(sqlQueryDTO.getSchema()) ? sqlQueryDTO.getSchema() : rdbmsSourceDTO.getSchema();
        return transferSchemaAndTableName(schema, sqlQueryDTO.getTableName());
    }

    /**
     * ?????????????????? sql
     *
     * @param limit ????????????
     * @return ???????????? sql
     */
    protected String limitSql(Integer limit) {
        if (Objects.isNull(limit) || limit < 1) {
            throw new SourceException(String.format("limit number [%s] is error", limit));
        }
        return " limit " + limit;
    }

    /**
     * ??????schema?????????
     *
     * @param schema
     * @param tableName
     * @return
     */
    protected String transferSchemaAndTableName(String schema, String tableName) {
        return transferTableName(tableName);
    }

    /**
     * ????????????
     *
     * @param tableName
     * @return
     */
    @Deprecated
    protected String transferTableName(String tableName) {
        return tableName;
    }

    /**
     * ??????????????????
     */
    protected String doDealType(ResultSetMetaData rsMetaData, Integer los) throws SQLException {
        return rsMetaData.getColumnTypeName(los + 1);
    }

    protected Map<String, String> getColumnComments(RdbmsSourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        return Collections.emptyMap();
    }

    /**
     * ??????schema??????????????????????????????????????????????????????????????????????????????
     *
     * @param queryDTO ??????queryDTO
     * @return sql??????
     */
    protected String getTableBySchemaSql(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    public IDownloader getDownloader(ISourceDTO source, SqlQueryDTO queryDTO) throws Exception {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    public IDownloader getDownloader(ISourceDTO source, String sql, Integer pageSize) throws Exception {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    public List<String> getAllDatabases(ISourceDTO source, SqlQueryDTO queryDTO) {
        // ???????????????????????????show databases ??????
        String sql = getShowDbSql();
        return queryWithSingleColumn(source, null, sql, 1, "get All database exception");
    }

    @Override
    public List<String> getRootDatabases(ISourceDTO source, SqlQueryDTO queryDTO) {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    public String getCreateTableSql(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Connection connection = getCon(sourceDTO, queryDTO);
        String tableName = transferSchemaAndTableName(sourceDTO, queryDTO);
        String sql = queryDTO.getSql() == null ? String.format(SHOW_CREATE_TABLE_SQL, tableName) : queryDTO.getSql();
        Statement statement = null;
        ResultSet rs = null;
        String createTableSql = null;
        try {
            statement = connection.createStatement();
            rs = statement.executeQuery(sql);
            int columnSize = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                createTableSql = rs.getString(columnSize == 1 ? 1 : 2);
                break;
            }
        } catch (Exception e) {
            throw new SourceException(String.format("failed to get the create table sql???%s", e.getMessage()), e);
        } finally {
            DBUtil.closeDBResources(rs, statement, connection);
        }
        return createTableSql;
    }

    @Override
    public List<ColumnMetaDTO> getPartitionColumn(ISourceDTO source, SqlQueryDTO queryDTO) {
        return Collections.emptyList();
    }

    @Override
    public Table getTable(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        Table table = new Table();
        List<ColumnMetaDTO> columnMetaData = getColumnMetaData(sourceDTO, queryDTO);
        String tableComment = getTableMetaComment(sourceDTO, queryDTO);
        table.setColumns(columnMetaData);
        table.setName(queryDTO.getTableName());
        table.setComment(tableComment);
        return table;
    }

    /**
     * ???????????? ?????????/schema sql??????
     *
     * @return
     */
    protected String getShowDbSql() {
        return SHOW_DB_SQL;
    }

    public String getCurrentSchema(ISourceDTO source) {
        // ????????????schema????????????sql
        String sql = getCurrentSchemaSql();
        List<String> result = queryWithSingleColumn(source, null, sql, 1, "failed to get the currently used database");
        if (CollectionUtils.isEmpty(result)) {
            throw new SourceException("failed to get the currently used database");
        }
        return result.get(0);
    }

    protected String getCurrentSchemaSql() {
        return getCurrentDbSql();
    }

    ;


    @Override
    public String getCurrentDatabase(ISourceDTO source) {
        // ????????????schema????????????sql
        String sql = getCurrentDbSql();
        List<String> result = queryWithSingleColumn(source, null, sql, 1, "failed to get the currently used database");
        if (CollectionUtils.isEmpty(result)) {
            throw new SourceException("failed to get the currently used database");
        }
        return result.get(0);
    }

    /**
     * ??????????????????db???sql???????????????????????????????????????????????????
     *
     * @return ?????????sql
     */
    protected String getCurrentDbSql() {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    public Boolean createDatabase(ISourceDTO source, String dbName, String comment) {
        if (StringUtils.isBlank(dbName)) {
            throw new SourceException("database or schema cannot be empty");
        }
        String createSchemaSql = getCreateDatabaseSql(dbName, comment);
        return executeSqlWithoutResultSet(source, SqlQueryDTO.builder().sql(createSchemaSql).build());
    }

    @Override
    public List<String> getCatalogs(ISourceDTO source) {
        String showCatalogsSql = getCatalogSql();
        return queryWithSingleColumn(source, null, showCatalogsSql, 1, "failed to get data source directory list");
    }

    /**
     * ??????????????????sql?????????????????????????????????????????????
     *
     * @param dbName  ??????
     * @param comment ??????
     * @return sql
     */
    protected String getCreateDatabaseSql(String dbName, String comment) {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }


    @Override
    public Boolean isDatabaseExists(ISourceDTO source, String dbName) {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    public Boolean isTableExistsInDatabase(ISourceDTO source, String tableName, String dbName) {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    /**
     * ???????????????/????????????????????????sql?????????????????????????????????????????????
     *
     * @return sql
     */
    protected String getCatalogSql() {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    /**
     * ??????????????????????????????????????????
     *
     * @param queryDTO ????????????
     * @return ???????????????????????????????????????
     */
    protected String addFuzzySign(SqlQueryDTO queryDTO) {
        String fuzzySign = getFuzzySign();
        if (Objects.isNull(queryDTO) || StringUtils.isBlank(queryDTO.getTableNamePattern())) {
            return fuzzySign;
        }
        String defaultSign = fuzzySign + queryDTO.getTableNamePattern() + fuzzySign;
        if (!ReflectUtil.fieldExists(SqlQueryDTO.class, "matchType")
                || Objects.isNull(queryDTO.getMatchType())) {
            return defaultSign;
        }
        if (MatchType.ALL.equals(queryDTO.getMatchType())) {
            return queryDTO.getTableNamePattern();
        }
        if (MatchType.PREFIX.equals(queryDTO.getMatchType())) {
            return queryDTO.getTableNamePattern() + fuzzySign;
        }
        if (MatchType.SUFFIX.equals(queryDTO.getMatchType())) {
            return fuzzySign + queryDTO.getTableNamePattern();
        }
        return defaultSign;
    }

    /**
     * ????????????????????????
     *
     * @return ??????????????????
     */
    protected String getFuzzySign() {
        return "%";
    }

    @Override
    public String getVersion(ISourceDTO source) {
        String showVersionSql = getVersionSql();
        List<String> result = queryWithSingleColumn(source, null, showVersionSql, 1, "failed to get data source version");
        return CollectionUtils.isNotEmpty(result) ? result.get(0) : "";
    }

    /**
     * ????????????????????????sql?????????????????????????????????????????????
     *
     * @return ????????????????????? sql
     */
    protected String getVersionSql() {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    public List<String> listFileNames(ISourceDTO sourceDTO, String path, Boolean includeDir, Boolean recursive, Integer maxNum, String regexStr) {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    @Override
    public Database getDatabase(ISourceDTO sourceDTO, String dbName) {
        AssertUtils.notBlank(dbName, "database name can't be empty.");
        String descDbSql = getDescDbSql(dbName);
        List<Map<String, Object>> result = executeQuery(sourceDTO, SqlQueryDTO.builder().sql(descDbSql).build());
        if (CollectionUtils.isEmpty(result)) {
            throw new SourceException("result is empty when get database info.");
        }
        return parseDbResult(result);
    }

    /**
     * ??????????????????
     *
     * @param result ????????????
     * @return db ??????
     */
    public Database parseDbResult(List<Map<String, Object>> result) {
        Map<String, Object> dbInfoMap = result.get(0);
        Database database = new Database();
        database.setDbName(MapUtils.getString(dbInfoMap, DtClassConsistent.PublicConsistent.DB_NAME));
        database.setComment(MapUtils.getString(dbInfoMap, DtClassConsistent.PublicConsistent.COMMENT));
        database.setOwnerName(MapUtils.getString(dbInfoMap, DtClassConsistent.PublicConsistent.OWNER_NAME));
        database.setLocation(MapUtils.getString(dbInfoMap, DtClassConsistent.PublicConsistent.LOCATION));
        return database;
    }

    /**
     * ?????????????????????????????? sql???????????????????????????
     *
     * @param dbName ???????????????
     * @return sql for desc database
     */
    public String getDescDbSql(String dbName) {
        throw new SourceException(ErrorCode.NOT_SUPPORT.getDesc());
    }

    /**
     * ?????? schema ??????, ????????? queryDTO ??????
     *
     * @param sourceDTO ???????????????
     * @param queryDTO  ????????????
     * @return schema ??????
     */
    protected String getSchema(ISourceDTO sourceDTO, SqlQueryDTO queryDTO) {
        RdbmsSourceDTO rdbmsSourceDTO = (RdbmsSourceDTO) sourceDTO;
        if (Objects.isNull(queryDTO)) {
            return rdbmsSourceDTO.getSchema();
        }
        return StringUtils.isNotBlank(queryDTO.getSchema()) ? queryDTO.getSchema() : rdbmsSourceDTO.getSchema();
    }

    @Override
    public Boolean writeByFile(ISourceDTO sourceDTO, WriteFileDTO dto) {
        //????????????????????????????????????
        if (StringUtils.isBlank(dto.getTableName())) {
            throw new SourceException("it must need tableName when query columns");
        }
        List<ColumnMetaDTO> dbColumns = getColumnMetaData(sourceDTO, SqlQueryDTO.builder().tableName(dto.getTableName()).build());
        String charset = StringUtils.isNotBlank(dto.getOriCharset()) ? dto.getOriCharset().trim() : dto.getOriCharset();

        //??????????????????????????????????????????,??????????????????????????????????????????
        int importSize = checkWriteFileParam(dto, dbColumns);

        //????????????????????????????????????
        File file = FileUtil.checkFileExists(dto.getLocalPath());

        try (Connection con = getCon(sourceDTO);
             InputStreamReader reader = new InputStreamReader(new FileInputStream(file), charset);
             BufferedReader bufferedReader = new BufferedReader(reader)) {
            con.setAutoCommit(false);

            try {
                String template = getImportTemplate(dbColumns, dto.getTableName(), dto.getImportColumns(), dto.getMatchType());

                try (PreparedStatement ps = con.prepareStatement(template)) {
                    Map<Integer, Integer> mappingIndex = new HashMap<>(importSize);
                    String lineStr;
                    int currLineNum = 0;
                    int batchInsertSize = 100;
                    int batchWriteLineSize = 0;
                    while ((lineStr = bufferedReader.readLine()) != null) {
                        currLineNum++;
                        if (currLineNum == 1 && dto.getTopLineIsTitle()) {
                            parseNameByFirstLine(
                                    dto.getSeparator(), dto.getMatchType(), lineStr, mappingIndex, dto.getImportColumns());
                            continue;
                        }
                        if (currLineNum < dto.getStartLine()) {
                            continue;
                        }
                        String[] arr = lineStr.split(dto.getSeparator());
                        if (arr.length < importSize) {
                            log.error("There are not enough data columns in the file, line number: {}", currLineNum);
                            continue;
                        }
                        parseColumnByLine(importSize, arr, ps, mappingIndex, dto.getMatchType());
                        batchWriteLineSize++;
                        //???????????? ????????????
                        if (batchWriteLineSize == batchInsertSize) {
                            ps.executeBatch();
                            con.commit();
                            batchWriteLineSize = 0;
                        }
                    }

                    ps.executeBatch();
                    con.commit();
                    con.setAutoCommit(true);
                }
            } catch (Exception e) {
                con.rollback();
                log.error("rollback success!");
                throw new SourceException("" + e);
            }
        } catch (Exception e) {
            throw new SourceException("write data by file error,detail: " + e);
        }

        return true;
    }

    private int checkWriteFileParam(WriteFileDTO dto, List<ColumnMetaDTO> dbColumns) {
        List<WriteFileDTO.ImportColum> importColumns = dto.getImportColumns();
        ImportDataMatchType matchType = dto.getMatchType();
        if (matchType == null) {
            throw new SourceException("matchType can't be null");
        }
        if (CollectionUtils.isEmpty(dbColumns)) {
            throw new SourceException("table of database doesn't have columns");
        }
        if (CollectionUtils.isEmpty(importColumns)) {
            throw new SourceException("importColumns can't be null");
        }

        //???????????????????????????????????????????????????dbColumns???size??????????????????????????????????????????????????????????????????importColumns???size
        int importSize = 0;
        boolean canImport = false;
        if (ImportDataMatchType.BY_POS.equals(matchType)) {
            importSize = importColumns.size();
            canImport = dbColumns.size() >= importSize;
        } else if (ImportDataMatchType.BY_NAME.equals(matchType)) {
            if (!dto.getTopLineIsTitle()) {
                throw new SourceException("topLineIsTitle param must be true when write by name");
            }
            importSize = (int) importColumns.stream()
                    .filter(colum -> StringUtils.isNotBlank(colum.getKey()))
                    .count();
            //?????????????????????????????????key???????????????????????????
            canImport = importSize > 0 && dbColumns.size() >= importSize;
        }
        if (!canImport) {
            throw new SourceException(
                    String.format("columnsList: %s , importColumns : %s, they are different", dbColumns, importColumns));
        }

        return importSize;
    }

    /**
     * ????????????????????????
     *
     * @param dbColumns
     * @param tableName
     * @param importColumns
     * @param matchType
     * @return insert??????
     */
    private String getImportTemplate(List<ColumnMetaDTO> dbColumns,
                                     String tableName,
                                     List<WriteFileDTO.ImportColum> importColumns,
                                     ImportDataMatchType matchType) {
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("INSERT INTO %s (", tableName));

        for (int i = 0; i < dbColumns.size(); i++) {
            //????????????????????????????????????
            if (ImportDataMatchType.BY_NAME.equals(matchType)) {
                if (StringUtils.isBlank(importColumns.get(i).getKey())) {
                    continue;
                }
            }
            sb.append(dbColumns.get(i).getKey());
            sb.append(i == dbColumns.size() - 1 ? ") VALUES (" : ",");
        }

        for (int i = 0; i < dbColumns.size(); i++) {
            //????????????????????????????????????
            if (ImportDataMatchType.BY_NAME.equals(matchType)) {
                if (StringUtils.isBlank(importColumns.get(i).getKey())) {
                    continue;
                }
            }
            sb.append("?");
            sb.append(i == dbColumns.size() - 1 ? ")" : ",");
        }
        return sb.toString();
    }

    /**
     * ????????????????????????????????????????????????db??????????????????????????????
     *
     * @param separator
     * @param matchType
     * @param lineStr
     * @param mappingIndex
     * @param importColumns
     */
    private void parseNameByFirstLine(String separator,
                                      ImportDataMatchType matchType,
                                      String lineStr,
                                      Map<Integer, Integer> mappingIndex,
                                      List<WriteFileDTO.ImportColum> importColumns) {
        if (ImportDataMatchType.BY_NAME.equals(matchType)) {
            String[] split = lineStr.split(separator);
            //???????????????????????????
            List<WriteFileDTO.ImportColum> validColumns = importColumns.stream()
                    .filter(column -> StringUtils.isNotBlank(column.getKey()))
                    .collect(Collectors.toList());

            if (split.length < validColumns.size()) {
                throw new SourceException("column size in file is not correct, columns in file: "
                        + split.length + " , columns in set : " + validColumns.size());
            }
            for (int i = 0; i < split.length; i++) {
                // file???????????????importColumns??????????????????
                for (int j = 0; j < validColumns.size(); j++) {
                    if (split[i].equalsIgnoreCase(validColumns.get(j).getKey())) {
                        mappingIndex.put(j, i);
                    }
                }
            }
        }
    }

    /**
     * ??????insert?????????values?????????
     *
     * @param importSize
     * @param arr
     * @param ps
     * @param mappingIndex
     * @param matchType
     */
    private void parseColumnByLine(int importSize,
                                   String[] arr,
                                   PreparedStatement ps,
                                   Map<Integer, Integer> mappingIndex,
                                   ImportDataMatchType matchType) {
        try {
            for (int i = 0; i < importSize; i++) {
                if (ImportDataMatchType.BY_NAME.equals(matchType)) {
                    ps.setObject(i + 1, arr[mappingIndex.get(i)]);
                } else if (ImportDataMatchType.BY_POS.equals(matchType)) {
                    ps.setObject(i + 1, arr[i]);
                }
            }
            ps.addBatch();
        } catch (SQLException e) {
            log.error("parseColumnByLine error: ", e);
        }
    }

    @Override
    public TableInfo getTableInfo(ISourceDTO sourceDTO, String tableName) {
        TableInfo tableInfo = TableInfo.builder().build();
        RdbmsSourceDTO rdbmsSourceDTO = (RdbmsSourceDTO) sourceDTO;
        // ??????????????????????????????????????? schema , ??????????????????????????? schema
        List<String> result = StringUtil.splitWithOutQuota(tableName, '.', getSpecialSign());
        if (result.size() == 1) {
            tableInfo.setTableName(result.get(0));
            if (StringUtils.isNotBlank(rdbmsSourceDTO.getSchema())) {
                tableInfo.setSchema(rdbmsSourceDTO.getSchema());
            } else {
                try {
                    // ?????? try catch
                    tableInfo.setSchema(getCurrentSchema(sourceDTO));
                } catch (Exception e) {
                    // ignore error
                    log.warn("get current schema error.", e);
                }
            }
        } else if (result.size() == 2) {
            tableInfo.setSchema(result.get(0));
            tableInfo.setTableName(result.get(1));
        } else {
            throw new SourceException(String.format("tableName:[%s] does not conform to the rule", tableName));
        }
        return tableInfo;
    }

    /**
     * ????????????????????????????????????????????????????????????, ?????????????????????
     *
     * @return ??????????????????
     */
    protected Pair<Character, Character> getSpecialSign() {
        return Pair.of('\"', '\"');
    }
}
