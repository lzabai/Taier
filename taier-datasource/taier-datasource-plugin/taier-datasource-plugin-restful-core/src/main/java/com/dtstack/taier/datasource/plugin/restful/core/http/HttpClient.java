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

package com.dtstack.taier.datasource.plugin.restful.core.http;

import com.dtstack.taier.datasource.plugin.common.utils.ReflectUtil;
import com.dtstack.taier.datasource.plugin.restful.core.http.request.HttpAddressManager;
import com.dtstack.taier.datasource.plugin.restful.core.http.request.HttpDeleteWithEntity;
import com.dtstack.taier.datasource.plugin.restful.core.http.request.HttpGetWithEntity;
import com.dtstack.taier.datasource.plugin.restful.core.http.request.HttpPutWithEntity;
import com.dtstack.taier.datasource.api.dto.restful.Response;
import com.dtstack.taier.datasource.api.dto.source.DorisRestfulSourceDTO;
import com.dtstack.taier.datasource.api.dto.source.RestfulSourceDTO;
import com.dtstack.taier.datasource.api.exception.SourceException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.entity.GzipDecompressingEntity;
import org.apache.http.client.methods.HttpEntityEnclosingRequestBase;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.nio.client.CloseableHttpAsyncClient;
import org.apache.http.util.EntityUtils;

import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.Future;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

@Slf4j
public class HttpClient implements Closeable {

    public static final Charset DEFAULT_CHARSET = StandardCharsets.UTF_8;

    /**
     * ?????????HttpClient
     */
    protected final CloseableHttpAsyncClient httpclient;

    /**
     * ?????????????????? for graceful close.
     */
    protected final AtomicInteger unCompletedTaskNum;

    /**
     * ????????????????????????
     */
    private final ScheduledExecutorService clearConnService;

    protected final HttpAddressManager httpAddressManager;

    private String authorization;

    /**
     * ????????????httpClient??????
     */
    private final Boolean useCache;

    /**
     * header ??????
     */
    protected final Map<String, String> headers;

    HttpClient(RestfulSourceDTO sourceDTO, CloseableHttpAsyncClient httpclient, ScheduledExecutorService clearConnService) {
        this.httpAddressManager = HttpAddressManager.createHttpAddressManager(sourceDTO);
        this.headers = sourceDTO.getHeaders();
        this.httpclient = httpclient;
        this.unCompletedTaskNum = new AtomicInteger(0);
        this.clearConnService = clearConnService;
        this.useCache = ReflectUtil.getFieldValueNotThrow(Boolean.class, sourceDTO, "useCache", Boolean.FALSE, Boolean.FALSE);
        //???????????????base64??????
        if (sourceDTO instanceof DorisRestfulSourceDTO) {
            String userName = StringUtils.isEmpty(sourceDTO.getUsername()) ? "" : sourceDTO.getUsername();
            String password = StringUtils.isEmpty(sourceDTO.getPassword()) ? "" : sourceDTO.getPassword();
            this.authorization = "Basic " + Base64.getEncoder().encodeToString((userName + ":" + password).getBytes(StandardCharsets.UTF_8));
        }
    }

    @Override
    public void close() throws IOException {
        if (useCache == null || !useCache) {
            this.close(false);
        }
    }

    public void close(boolean force) throws IOException {
        // ????????????
        if (!force) {
            // ????????????
            while (true) {
                if (httpclient.isRunning()) { // ?????????????????????
                    int i = this.unCompletedTaskNum.get();
                    if (i == 0) {
                        break;
                    } else {
                        try {
                            // ????????????????????????
                            TimeUnit.MILLISECONDS.sleep(50);
                        } catch (InterruptedException e) {
                            log.warn("The thread {} is Interrupted", Thread.currentThread().getName());
                        }
                    }
                } else {
                    // ???????????????????????????
                    break;
                }
            }
        }
        clearConnService.shutdownNow();
        // ??????
        httpclient.close();
    }

    /**
     * ?????? http response
     *
     * @param httpResponse http ??????
     * @return ????????????????????? Response
     */
    protected Response handleResponse(HttpResponse httpResponse) {
        StatusLine statusLine = httpResponse.getStatusLine();
        Response response = Response.builder()
                .statusCode(statusLine.getStatusCode())
                .build();
        HttpEntity entity = httpResponse.getEntity();
        try {
            String content;
            Header[] headers = httpResponse.getHeaders("Content-Encoding");
            // ?????? gzip ??????
            if (headers != null && headers.length > 0 && headers[0].getValue().equalsIgnoreCase("gzip")) {
                GzipDecompressingEntity gzipEntity = new GzipDecompressingEntity(entity);
                content = EntityUtils.toString(gzipEntity, HttpClient.DEFAULT_CHARSET);
            } else {
                content = EntityUtils.toString(entity, HttpClient.DEFAULT_CHARSET);
            }
            response.setContent(content);
        } catch (Exception e) {
            handleException(response, "Failed to parse HttpEntity", e);
        }
        return response;
    }

    /**
     * get ??????
     *
     * @return response
     */
    public Response get() {
        return get(null, null, null);
    }

    /**
     * get ??????
     *
     * @param params  params ??????
     * @param cookies cookie ??????
     * @param headers header ??????
     * @return response
     */
    public Response get(Map<String, String> params, Map<String, String> cookies, Map<String, String> headers) {
        HttpGetWithEntity request = new HttpGetWithEntity(createURI(params));
        setHeaderAndCookie(request, cookies, headers);
        return execute(request, null);
    }

    /**
     * post ??????
     *
     * @param bodyData body ??????
     * @param cookies  cookie ??????
     * @param headers  header ??????
     * @return response
     */
    public Response post(String bodyData, Map<String, String> cookies, Map<String, String> headers) {
        HttpPost request = new HttpPost(httpAddressManager.getAddress());
        setHeaderAndCookie(request, cookies, headers);
        return execute(request, bodyData);
    }

    /**
     * delete ??????
     *
     * @param bodyData body ??????
     * @param cookies  cookie ??????
     * @param headers  header ??????
     * @return response
     */
    public Response delete(String bodyData, Map<String, String> cookies, Map<String, String> headers) {
        HttpDeleteWithEntity request = new HttpDeleteWithEntity(httpAddressManager.getAddress());
        setHeaderAndCookie(request, cookies, headers);
        return execute(request, bodyData);
    }

    /**
     * put ??????
     *
     * @param bodyData body ??????
     * @param cookies  cookie ??????
     * @param headers  header ??????
     * @return response
     */
    public Response put(String bodyData, Map<String, String> cookies, Map<String, String> headers) {
        HttpPutWithEntity request = new HttpPutWithEntity(httpAddressManager.getAddress());
        setHeaderAndCookie(request, cookies, headers);
        return execute(request, bodyData);
    }

    /**
     * post ?????? Multipart
     *
     * @param params  params ??????
     * @param cookies cookie ??????
     * @param headers header ??????
     * @param files   ????????????
     * @return response
     */
    public Response postMultipart(Map<String, String> params, Map<String, String> cookies, Map<String, String> headers, Map<String, File> files) {
        HttpPost request = new HttpPost(httpAddressManager.getAddress());
        setHeaderAndCookie(request, cookies, headers);
        MultipartEntityBuilder builder = MultipartEntityBuilder.create();
        if (MapUtils.isNotEmpty(files)) {
            // ???????????????
            for (Map.Entry<String, File> file : files.entrySet()) {
                builder.addBinaryBody(file.getKey(), file.getValue(), ContentType.MULTIPART_FORM_DATA.withCharset(DEFAULT_CHARSET), file.getValue().getName());
            }
        }
        if (MapUtils.isNotEmpty(params)) {
            // ??????????????????
            for (Map.Entry<String, String> entry : params.entrySet()) {
                builder.addTextBody(entry.getKey(), entry.getValue(), ContentType.MULTIPART_FORM_DATA.withCharset(DEFAULT_CHARSET));
            }
        }
        request.setEntity(builder.build());
        return execute(request, null);
    }

    /**
     * ?????? header ??? cookie
     *
     * @param request ??????
     * @param cookies cookie
     * @param headers header
     */
    public void setHeaderAndCookie(HttpEntityEnclosingRequestBase request, Map<String, String> cookies, Map<String, String> headers) {
        if (MapUtils.isNotEmpty(cookies)) {
            request.addHeader("Cookie", getCookieFormat(cookies));
        }
        // ?????????????????? header????????? sourceDTO ?????? header
        if (MapUtils.isNotEmpty(headers)) {
            for (Map.Entry<String, String> entry : headers.entrySet()) {
                request.addHeader(entry.getKey(), String.valueOf(entry.getValue()));
            }
        } else if (MapUtils.isNotEmpty(this.headers)) {
            for (Map.Entry<String, String> entry : this.headers.entrySet()) {
                request.addHeader(entry.getKey(), String.valueOf(entry.getValue()));
            }
        }
    }

    /**
     * ????????????
     *
     * @param request  ??????
     * @param bodyData body ??????
     * @return Response
     */
    private Response execute(HttpEntityEnclosingRequestBase request, String bodyData) {

        request.addHeader("Content-Type", "application/json");
        if (Objects.nonNull(authorization)) {
            request.addHeader("Authorization", authorization);
        }
        // body ?????????????????? entity
        if (StringUtils.isNotEmpty(bodyData)) {
            request.setEntity(generateStringEntity(bodyData));
        }
        unCompletedTaskNum.incrementAndGet();
        Future<HttpResponse> future = httpclient.execute(request, null);
        try {
            HttpResponse httpResponse = future.get();
            return handleResponse(httpResponse);
        } catch (Throwable e) {
            Response errResponse = Response.builder()
                    .build();
            handleException(errResponse, "execute http request error", e);
            return errResponse;
        } finally {
            unCompletedTaskNum.decrementAndGet();
        }
    }

    /**
     * ?????? StringEntity
     *
     * @param bodyData body ??????
     * @return StringEntity
     */
    protected StringEntity generateStringEntity(String bodyData) {
        return new StringEntity(bodyData, DEFAULT_CHARSET);
    }

    /**
     * ????????? cookie
     *
     * @param cookies cookie ??????
     * @return cookie
     */
    public static String getCookieFormat(Map<String, String> cookies) {
        StringBuilder sb = new StringBuilder();
        Set<Entry<String, String>> sets = cookies.entrySet();
        for (Map.Entry<String, String> s : sets) {
            String value = Objects.isNull(s.getValue()) ? "" : s.getValue();
            sb.append(s.getKey()).append("=").append(value).append(";");
        }
        return sb.toString();
    }

    /**
     * ??????????????????
     *
     * @param response  ???????????? response
     * @param errPrefix ??????????????????
     * @param e         ??????
     */
    protected void handleException(Response response, String errPrefix, Throwable e) {
        log.error(errPrefix, e);
        response.setStatusCode(-1);
        response.setErrorMsg(errPrefix + ":" + e.getMessage());
    }

    /**
     * ?????? URI
     *
     * @param params ????????????
     * @return uri
     */
    private URI createURI(Map<String, String> params) {
        URIBuilder builder;
        try {
            builder = new URIBuilder(httpAddressManager.getAddress());
        } catch (URISyntaxException e) {
            throw new SourceException(e.getMessage(), e);
        }

        if (params != null && !params.isEmpty()) {
            for (Entry<String, String> entry : params.entrySet()) {
                builder.setParameter(entry.getKey(), entry.getValue());
            }
        }

        URI uri;
        try {
            uri = builder.build();
        } catch (URISyntaxException e) {
            throw new SourceException(e.getMessage(), e);
        }
        return uri;
    }

    public void start() {
        this.httpclient.start();
    }
}
