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

package com.dtstack.taier.datasource.plugin.es;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.parser.Feature;
import com.dtstack.taier.datasource.plugin.common.exception.IErrorPattern;
import com.dtstack.taier.datasource.plugin.common.nosql.AbsNoSqlClient;
import com.dtstack.taier.datasource.plugin.common.service.ErrorAdapterImpl;
import com.dtstack.taier.datasource.plugin.common.service.IErrorAdapter;
import com.dtstack.taier.datasource.plugin.common.utils.SearchUtil;
import com.dtstack.taier.datasource.plugin.es.pool.ElasticSearchManager;
import com.dtstack.taier.datasource.plugin.es.pool.ElasticSearchPool;
import com.dtstack.taier.datasource.api.dto.ColumnMetaDTO;
import com.dtstack.taier.datasource.api.dto.SqlQueryDTO;
import com.dtstack.taier.datasource.api.dto.source.ESSourceDTO;
import com.dtstack.taier.datasource.api.dto.source.ISourceDTO;
import com.dtstack.taier.datasource.api.exception.SourceException;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.math3.util.Pair;
import org.apache.http.HttpEntity;
import org.apache.http.HttpHost;
import org.apache.http.HttpStatus;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.entity.ContentType;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.nio.entity.NStringEntity;
import org.apache.http.util.EntityUtils;
import org.elasticsearch.action.admin.indices.alias.get.GetAliasesRequest;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.GetAliasesResponse;
import org.elasticsearch.client.Request;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.Response;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.indices.GetMappingsRequest;
import org.elasticsearch.client.indices.GetMappingsResponse;
import org.elasticsearch.cluster.metadata.AliasMetaData;
import org.elasticsearch.cluster.metadata.MappingMetaData;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @company: www.dtstack.com
 * @Author ???Nanqi
 * @Date ???Created in 21:46 2020/2/27
 * @Description???ES ?????????
 */
@Slf4j
public class EsClient extends AbsNoSqlClient {

    private static final int MAX_NUM = 10000;

    private static final String POST = "post";

    private static final String PUT = "put";

    private static final String DELETE = "delete";

    private static final String ENDPOINT_SEARCH_FORMAT = "/%s/_search";

    private static final String ENDPOINT_UPDATE_FORMAT = "/%s/_update";

    private static final String ENDPOINT_DELETE_FORMAT = "/%s";

    private static final String ENDPOINT_BULK_FORMAT = "/_bulk";

    private static final String ENDPOINT_UPDATE_QUERY_FORMAT = "/%s/_update_by_query";

    private static final String ENDPOINT_DELETE_QUERY_FORMAT = "/%s/_delete_by_query";

    private static final String RESULT_KEY = "result";

    private static ElasticSearchManager elasticSearchManager = ElasticSearchManager.getInstance();

    public static final ThreadLocal<Boolean> IS_OPEN_POOL = new ThreadLocal<>();

    private static final IErrorPattern ERROR_PATTERN = new EsErrorPattern();

    // ???????????????
    private static final IErrorAdapter ERROR_ADAPTER = new ErrorAdapterImpl();

    @Override
    public Boolean testCon(ISourceDTO iSource) {
        ESSourceDTO esSourceDTO = (ESSourceDTO) iSource;
        if (esSourceDTO == null || StringUtils.isBlank(esSourceDTO.getUrl())) {
            return false;
        }
        RestHighLevelClient client = null;
        try {
            client = getClient(esSourceDTO);
            client.info(RequestOptions.DEFAULT);
            return true;
        } catch (Exception e) {
            throw new SourceException(ERROR_ADAPTER.connAdapter(e.getMessage(), ERROR_PATTERN), e);
        } finally {
            closeResource(null, client, esSourceDTO);
        }
    }

    /**
     * ??????es?????????????????????type?????????????????????6.0???????????????????????????index?????????type
     *
     * @param iSource
     * @param queryDTO
     * @return
     * @throws Exception
     */
    @Override
    public List<String> getTableList(ISourceDTO iSource, SqlQueryDTO queryDTO) {
        ESSourceDTO esSourceDTO = (ESSourceDTO) iSource;
        if (esSourceDTO == null || StringUtils.isBlank(esSourceDTO.getUrl())) {
            return new ArrayList<>();
        }
        RestHighLevelClient client = getClient(esSourceDTO);
        List<String> typeList = Lists.newArrayList();
        //es??????
        String index = StringUtils.isNotBlank(queryDTO.getSchema()) ? queryDTO.getSchema() : queryDTO.getTableName();
        //?????????index?????????
        if (StringUtils.isBlank(index)) {
            throw new SourceException("The index of es is not specified, and the acquisition fails");
        }
        try {
            GetMappingsRequest request = new GetMappingsRequest();
            // ????????????7.x??????????????????????????????????????????null
            request.setMasterTimeout(null);
            request.indicesOptions(null);
            GetMappingsResponse res = client.indices().getMapping(request, RequestOptions.DEFAULT);
            MappingMetaData data = res.mappings().get(index);
            typeList.add(data.type());
        } catch (NullPointerException e) {
            log.error("index not exits", e);
        } catch (Exception e) {
            log.error(String.format("get type exception,%s", e.getMessage()), e);
        } finally {
            closeResource(null, client, esSourceDTO);
        }
        return SearchUtil.handleSearchAndLimit(typeList, queryDTO);
    }


    /**
     * ??????es????????????????????????????????????
     *
     * @param iSource
     * @param queryDTO
     * @return
     */
    @Override
    public List<String> getAllDatabases(ISourceDTO iSource, SqlQueryDTO queryDTO) {
        ESSourceDTO esSourceDTO = (ESSourceDTO) iSource;
        if (esSourceDTO == null || StringUtils.isBlank(esSourceDTO.getUrl())) {
            return new ArrayList<>();
        }
        RestHighLevelClient client = getClient(esSourceDTO);
        ArrayList<String> dbs = new ArrayList<>();
        try {
            GetAliasesRequest aliasesRequest = new GetAliasesRequest();
            GetAliasesResponse alias = client.indices().getAlias(aliasesRequest, RequestOptions.DEFAULT);
            Map<String, Set<AliasMetaData>> aliases = alias.getAliases();
            Set<String> set = aliases.keySet();
            dbs = new ArrayList<>(set);
        } catch (Exception e) {
            log.error(String.format("Failed to get es index,%s", e.getMessage()), e);
        } finally {
            closeResource(null, client, esSourceDTO);
        }
        return dbs;
    }

    /**
     * es?????????????????????100????????????10000???
     *
     * @param iSource
     * @param queryDTO
     * @return
     */
    @Override
    public List<List<Object>> getPreview(ISourceDTO iSource, SqlQueryDTO queryDTO) {
        ESSourceDTO esSourceDTO = (ESSourceDTO) iSource;
        if (esSourceDTO == null || StringUtils.isBlank(esSourceDTO.getUrl())) {
            return new ArrayList<>();
        }
        RestHighLevelClient client = getClient(esSourceDTO);
        //??????
        String index = StringUtils.isNotBlank(queryDTO.getSchema()) ? queryDTO.getSchema() : queryDTO.getTableName();
        if (StringUtils.isBlank(index)) {
            throw new SourceException("The index of es is not specified???Data preview failed");
        }
        //?????????????????????10000???
        int previewNum = queryDTO.getPreviewNum() > MAX_NUM ? MAX_NUM : queryDTO.getPreviewNum();
        //??????index????????????
        SearchRequest searchRequest = new SearchRequest(index);
        SearchSourceBuilder query = new SearchSourceBuilder()
                .query(QueryBuilders.matchAllQuery())
                .size(previewNum);
        SearchRequest source = searchRequest.source(query);
        List<List<Object>> documentList = Lists.newArrayList();
        try {
            SearchResponse search = client.search(source, RequestOptions.DEFAULT);
            //?????????
            SearchHit[] hits = search.getHits().getHits();
            for (SearchHit hit : hits) {
                //????????????
                List<Object> document = Lists.newArrayList();
                Map<String, Object> sourceAsMap = hit.getSourceAsMap();
                sourceAsMap.keySet().forEach(key ->
                        document.add(new Pair<String, Object>(key, sourceAsMap.get(key))));
                documentList.add(document);
            }
        } catch (Exception e) {
            log.error("doc acquisition exception", e);
        } finally {
            closeResource(null, client, esSourceDTO);
        }
        return documentList;
    }

    /**
     * ??????es????????????
     *
     * @param iSource
     * @param queryDTO
     * @return
     * @throws Exception
     */
    @Override
    public List<ColumnMetaDTO> getColumnMetaData(ISourceDTO iSource, SqlQueryDTO queryDTO) {
        ESSourceDTO esSourceDTO = (ESSourceDTO) iSource;
        if (esSourceDTO == null || StringUtils.isBlank(esSourceDTO.getUrl())) {
            return new ArrayList<>();
        }
        RestHighLevelClient client = getClient(esSourceDTO);
        //??????
        String index = StringUtils.isNotBlank(queryDTO.getSchema()) ? queryDTO.getSchema() : queryDTO.getTableName();
        if (StringUtils.isBlank(index)) {
            throw new SourceException("The index of es is not specified, and the field information fails to be obtained");
        }
        List<ColumnMetaDTO> columnMetaDTOS = new ArrayList<>();
        try {
            //??????index????????????
            GetMappingsRequest request = new GetMappingsRequest();
            // ????????????7.x??????????????????????????????????????????null
            request.setMasterTimeout(null);
            request.indicesOptions(null);
            GetMappingsResponse res = client.indices().getMapping(request, RequestOptions.DEFAULT);
            MappingMetaData data = res.mappings().get(index);
            // ???????????? type ?????????
            Map<String, Object> sourceAsMap = data.getSourceAsMap();
            if (sourceAsMap.containsKey("properties")) {
                fillColumnMeta((Map<String, Object>) sourceAsMap.get("properties"), columnMetaDTOS);
            } else {
                for (String key : sourceAsMap.keySet()) {
                    Map<String, Object> indexMap = (Map<String, Object>) sourceAsMap.get(key);
                    if (MapUtils.isEmpty(indexMap)) {
                        continue;
                    }
                    fillColumnMeta((Map<String, Object>) indexMap.get("properties"), columnMetaDTOS);
                }
            }
        } catch (Exception e) {
            log.error("doc acquisition exception", e);
        } finally {
            closeResource(null, client, esSourceDTO);
        }
        return columnMetaDTOS;
    }

    public void fillColumnMeta(Map<String, Object> properties, List<ColumnMetaDTO> columnMetaDTOS) {
        if (MapUtils.isEmpty(properties)) {
            return;
        }
        Set<String> metaData = properties.keySet();
        for (String meta : metaData) {
            ColumnMetaDTO columnMetaDTO = new ColumnMetaDTO();
            columnMetaDTO.setKey(meta);
            Map<String, Object> map = (Map<String, Object>) properties.get(meta);
            String type = StringUtils.isNotBlank((String) map.get("type")) ? (String) map.get("type") : "object";
            columnMetaDTO.setType(type);
            columnMetaDTOS.add(columnMetaDTO);
        }
    }

    @Override
    public List<Map<String, Object>> executeQuery(ISourceDTO iSource, SqlQueryDTO queryDTO) {
        ESSourceDTO esSourceDTO = (ESSourceDTO) iSource;
        List<Map<String, Object>> list = Lists.newArrayList();
        HashMap<String, Object> map = Maps.newHashMap();
        if (esSourceDTO == null || StringUtils.isBlank(esSourceDTO.getUrl())) {
            return new ArrayList<>();
        }
        String dsl = doDealPageSql(queryDTO.getSql());
        //??????
        String index = StringUtils.isNotBlank(queryDTO.getSchema()) ? queryDTO.getSchema() : queryDTO.getTableName();
        if (StringUtils.isBlank(index)) {
            throw new SourceException("The index of es is not specified, and the field information fails to be obtained. Please specify tableName as the index in sqlQueryDTO");
        }
        RestHighLevelClient client = null;
        RestClient lowLevelClient = null;
        JSONObject resultJsonObject = null;
        try (NStringEntity entity = new NStringEntity(dsl, ContentType.APPLICATION_JSON)) {
            client = getClient(esSourceDTO);
            lowLevelClient = client.getLowLevelClient();
            Request request = new Request(POST, String.format(ENDPOINT_SEARCH_FORMAT, index));
            request.setEntity(entity);
            Response response = lowLevelClient.performRequest(request);
            String result = EntityUtils.toString(response.getEntity());
            resultJsonObject = JSONObject.parseObject(result);
        } catch (IOException e) {
            throw new SourceException(e.getMessage(), e);
        } finally {
            closeResource(lowLevelClient, client, esSourceDTO);
        }
        map.put(RESULT_KEY, resultJsonObject);
        list.add(map);
        return list;
    }

    private static RestHighLevelClient getClient(ESSourceDTO esSourceDTO) {
        boolean check = esSourceDTO.getPoolConfig() != null;
        IS_OPEN_POOL.set(check);
        if (!check) {
            return getClient(esSourceDTO.getUrl(), esSourceDTO.getUsername(), esSourceDTO.getPassword());
        }
        ElasticSearchPool elasticSearchPool = elasticSearchManager.getConnection(esSourceDTO);
        RestHighLevelClient restHighLevelClient = elasticSearchPool.getResource();
        if (Objects.isNull(restHighLevelClient)) {
            throw new SourceException("No database connection available");
        }
        return restHighLevelClient;

    }

    /**
     * 1. ??????????????????????????????????????? esClient
     * 2. username??????password??????????????????????????????esClient
     *
     * @param address
     * @param username
     * @param password
     * @return
     */
    private static RestHighLevelClient getClient(String address, String username, String password) {
        log.info("Get ES data source connection, address : {}, userName : {}", address, username);
        List<HttpHost> httpHosts = dealHost(address);
        //????????????????????????
        if (StringUtils.isNotBlank(username) && StringUtils.isNotBlank(password)) {
            CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
            credentialsProvider.setCredentials(AuthScope.ANY,
                    new UsernamePasswordCredentials(username, password));
            return new RestHighLevelClient(RestClient.builder(httpHosts.toArray(new HttpHost[httpHosts.size()]))
                    .setHttpClientConfigCallback(httpClientBuilder -> httpClientBuilder.setDefaultCredentialsProvider(credentialsProvider)));
        }
        //??????????????????
        return new RestHighLevelClient(RestClient.builder(httpHosts.toArray(new HttpHost[httpHosts.size()])));
    }

    private static List<HttpHost> dealHost(String address) {
        List<HttpHost> httpHostList = new ArrayList<>();
        String[] addr = address.split(",");
        for (String add : addr) {
            String[] pair = add.split(":");
            httpHostList.add(new HttpHost(pair[0], Integer.valueOf(pair[1]), "http"));
        }
        return httpHostList;
    }

    private void closeResource(RestClient lowLevelClient, RestHighLevelClient restHighLevelClient, ESSourceDTO esSourceDTO) {
        if (BooleanUtils.isFalse(IS_OPEN_POOL.get())) {
            //??????????????????
            try {
                if (Objects.nonNull(lowLevelClient)) {
                    lowLevelClient.close();
                }
                if (Objects.nonNull(restHighLevelClient)) {
                    restHighLevelClient.close();
                }
            } catch (IOException e) {
                log.error(e.getMessage(), e);
            }
            IS_OPEN_POOL.remove();
        } else {
            //???????????????
            ElasticSearchPool elasticSearchPool = elasticSearchManager.getConnection(esSourceDTO);
            try {
                if (Objects.nonNull(lowLevelClient)) {
                    lowLevelClient.close();
                }
                if (Objects.nonNull(restHighLevelClient) && Objects.nonNull(elasticSearchPool)) {
                    elasticSearchPool.returnResource(restHighLevelClient);
                }
            } catch (Exception e) {
                log.error(e.getMessage(), e);
            }
        }
    }

    private String doDealPageSql(String dsl) {
        if (StringUtils.isNotBlank(dsl)) {
            // Feature.OrderedField ??????????????????????????? json ????????????????????????
            JSONObject jsonObject = JSONObject.parseObject(dsl, Feature.OrderedField);
            return JSONObject.toJSONString(jsonObject, true);
        }
        return "";
    }

    /**
     * ????????????????????????
     * <p><p/>
     * ????????????POST???????????????????????????tableName??????esclient???endpoint.
     * <p><p/>
     * ?????????????????????????????????POST????????????esCommandType ???0
     *
     * <ul>
     *     <li>DEFAULT(0) insert ???????????????????????????_id</li>
     *     <li>INSERT(1) insert ???????????????????????????_id</li>
     *     <li>UPDATE(2) _update ???????????????_id</li>
     *     <li>DELETE(3) delete????????????????????????????????????_id</li>
     *     <li>BULK(4) _bulk?????????????????????/_bulk,?????????endpoint?????????_index???_type</li>
     *     <li>UPDATE_BY_QUERY(5) _update_by_query ??????????????????,?????????endpoint?????????_index???_type</li>
     *     <li>DELETE_BY_QUERY(6) _delete_by_query ??????????????????,?????????endpoint?????????_index???_type</li>
     * <ul/>
     * @param iSource
     * @param queryDTO
     * @return
     * @throws Exception
     */
    @Override
    public Boolean executeSqlWithoutResultSet(ISourceDTO iSource, SqlQueryDTO queryDTO) {
        ESSourceDTO esSourceDTO = (ESSourceDTO) iSource;
        Boolean result = false;
        if (esSourceDTO == null || StringUtils.isBlank(esSourceDTO.getUrl())) {
            return false;
        }
        //??????
        String index = StringUtils.isNotBlank(queryDTO.getSchema()) ? queryDTO.getSchema() : queryDTO.getTableName();

        RestHighLevelClient client = null;
        RestClient lowLevelClient = null;
        NStringEntity entity = null;
        try {
            client = getClient(esSourceDTO);
            lowLevelClient = client.getLowLevelClient();

            if (queryDTO.getSql() != null) {
                entity = new NStringEntity(queryDTO.getSql(), ContentType.APPLICATION_JSON);
            }
            Integer esCommandType = queryDTO.getEsCommandType();
            String httpMethod = POST;
            String endpoint = index;
            switch (esCommandType) {
                case 0:
                case 1:
                    // PUT /${index}
                    httpMethod = PUT;
                    break;
                case 2:
                    // POST /${index}/_update
                    endpoint = String.format(ENDPOINT_UPDATE_FORMAT, index);
                    break;
                case 3:
                    // DELETE /${index}
                    httpMethod = DELETE;
                    log.info("delete es index, index : {}", index);
                    endpoint = String.format(ENDPOINT_DELETE_FORMAT, index);
                    break;
                case 4:
                    // POST /_bulk
                    endpoint = String.format(ENDPOINT_BULK_FORMAT, index);
                    break;
                case 5:
                    // POST /${index}/_update_by_query
                    endpoint = String.format(ENDPOINT_UPDATE_QUERY_FORMAT, index);
                    break;
                case 6:
                    // POST /${index}/_delete_by_query
                    endpoint = String.format(ENDPOINT_DELETE_QUERY_FORMAT, index);
                    break;
                default:
            }
            Response response = execute(lowLevelClient, entity, httpMethod, endpoint);
            if (response != null && (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK
                    || response.getStatusLine().getStatusCode() == HttpStatus.SC_CREATED) ) {
                result = true;
            }
        } catch (IOException e) {
            throw new SourceException(e.getMessage(), e);
        } finally {
            closeResource(lowLevelClient, client, esSourceDTO);
            if (entity != null) {
                entity.close();
            }
        }
        return result;
    }

    private Response execute(RestClient lowLevelClient, HttpEntity entity, String httpMethod, String endpoint) throws IOException {
        Request request = new Request(httpMethod, endpoint);
        request.setEntity(entity);
        return lowLevelClient.performRequest(request);
    }
}
