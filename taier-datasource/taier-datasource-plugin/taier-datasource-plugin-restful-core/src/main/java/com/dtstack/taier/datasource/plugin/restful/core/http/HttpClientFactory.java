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

import com.dtstack.taier.datasource.plugin.common.DtClassThreadFactory;
import com.dtstack.taier.datasource.plugin.common.utils.MD5Util;
import com.dtstack.taier.datasource.plugin.common.utils.ReflectUtil;
import com.dtstack.taier.datasource.plugin.common.utils.SSLUtil;
import com.dtstack.taier.datasource.plugin.kerberos.core.util.KerberosLoginUtil;
import com.dtstack.taier.datasource.api.dto.SSLConfig;
import com.dtstack.taier.datasource.api.dto.source.ISourceDTO;
import com.dtstack.taier.datasource.api.dto.source.RestfulSourceDTO;
import com.dtstack.taier.datasource.api.exception.SourceException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.KerberosCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.config.Registry;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.ssl.TrustSelfSignedStrategy;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.nio.client.CloseableHttpAsyncClient;
import org.apache.http.impl.nio.client.HttpAsyncClientBuilder;
import org.apache.http.impl.nio.client.HttpAsyncClients;
import org.apache.http.impl.nio.conn.PoolingNHttpClientConnectionManager;
import org.apache.http.impl.nio.reactor.DefaultConnectingIOReactor;
import org.apache.http.impl.nio.reactor.IOReactorConfig;
import org.apache.http.nio.conn.NoopIOSessionStrategy;
import org.apache.http.nio.conn.SchemeIOSessionStrategy;
import org.apache.http.nio.conn.ssl.SSLIOSessionStrategy;
import org.apache.http.nio.reactor.ConnectingIOReactor;
import org.apache.http.nio.reactor.IOReactorException;
import org.apache.http.ssl.SSLContexts;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.io.FileInputStream;
import java.io.InputStream;
import java.security.KeyStore;
import java.security.PrivilegedAction;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Slf4j
public class HttpClientFactory {

    /**
     * http IO ????????????????????????????????????????????????????????? ????????????
     */
    private static final Integer IO_THREAD_COUNT = 3;

    /**
     * HTTP?????????????????????????????????
     */
    private static final Integer HTTP_CONNECT_TIMEOUT = 90;

    /**
     * Socket ???????????????????????????
     */
    private static final Integer HTTP_SOCKET_TIMEOUT = 90;

    /**
     * ?????? HTTP ?????????????????????????????????
     */
    private static final Integer HTTP_CONNECTION_REQUEST_TIMEOUT = 90;

    private static final ConcurrentHashMap<String, HttpClient> HTTP_CLIENT_CACHE = new ConcurrentHashMap<>();

    public static HttpClient createHttpClientAndStart(ISourceDTO sourceDTO) {
        RestfulSourceDTO restfulSourceDTO = (RestfulSourceDTO) sourceDTO;
        Boolean useCache = ReflectUtil.getFieldValueNotThrow(Boolean.class, restfulSourceDTO, "useCache", Boolean.FALSE, Boolean.FALSE);
        HttpClient httpClient;
        if (useCache != null && useCache) {
            String key = MD5Util.getMd5String(restfulSourceDTO.getUrl());
            httpClient = HTTP_CLIENT_CACHE.get(key);
            if (httpClient == null) {
                synchronized (HttpClientFactory.class) {
                    httpClient = HTTP_CLIENT_CACHE.get(key);
                    if (httpClient == null) {
                        httpClient = createHttpClient(sourceDTO);
                        httpClient.start();
                        HTTP_CLIENT_CACHE.put(key, httpClient);
                    }
                }
            }
        } else {
            httpClient = createHttpClient(sourceDTO);
            httpClient.start();
        }
        return httpClient;
    }

    public static HttpClient createHttpClient(ISourceDTO sourceDTO) {
        RestfulSourceDTO restfulSourceDTO = (RestfulSourceDTO) sourceDTO;
        // ?????? ConnectingIOReactor
        ConnectingIOReactor ioReactor = initIOReactorConfig();
        SSLConfig sslConfig = restfulSourceDTO.getSslConfig();
        SSLIOSessionStrategy sslIS;
        if (Objects.isNull(sslConfig) || BooleanUtils.isTrue(MapUtils.getBoolean(sslConfig.getOtherConfig(), "skipSsl", false))) {
            // ?????? ssl ??????
            sslIS = getDefaultSSLConnectionSocketFactory();
        } else {
            SSLContext sslContext = getSSLContext(restfulSourceDTO);
            sslIS = sslContext == null ?
                    SSLIOSessionStrategy.getDefaultStrategy() :
                    new SSLIOSessionStrategy(sslContext, (hostname, session) -> true);
        }

        // ?????? http???https
        Registry<SchemeIOSessionStrategy> sessionStrategyRegistry =
                RegistryBuilder.<SchemeIOSessionStrategy>create()
                        .register("http", NoopIOSessionStrategy.INSTANCE)
                        .register("https", sslIS)
                        .build();
        // ?????????????????????
        PoolingNHttpClientConnectionManager cm = new PoolingNHttpClientConnectionManager(ioReactor, sessionStrategyRegistry);

        // ??????HttpAsyncClient
        CloseableHttpAsyncClient httpAsyncClient = createPoolingHttpClient(cm, restfulSourceDTO.getConnectTimeout(), restfulSourceDTO.getSocketTimeout(), restfulSourceDTO.getKerberosConfig());

        // ??????????????????
        ScheduledExecutorService clearConnService = initFixedCycleCloseConnection(cm);

        // ????????????HttpClientImpl
        return buildHttpClient(restfulSourceDTO, httpAsyncClient, clearConnService);
    }

    /**
     * ?????? ssl ??????
     * @return {@link SSLIOSessionStrategy}
     */
    public static SSLIOSessionStrategy getDefaultSSLConnectionSocketFactory() {
        final TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    @Override
                    public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                        return null;
                    }

                    @Override
                    public void checkClientTrusted(
                            java.security.cert.X509Certificate[] certs, String authType) {
                    }

                    @Override
                    public void checkServerTrusted(
                            java.security.cert.X509Certificate[] certs, String authType) {
                    }
                }
        };

        try {
            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            return new SSLIOSessionStrategy(sc, (hostname, session) -> true);
        } catch (Exception e) {
            throw new SourceException("skip ssl error.", e);
        }
    }

    /**
     * ?????? http sslContext
     *
     * @param sourceDTO ???????????????
     * @return SSLContext
     */
    public static SSLContext getSSLContext(ISourceDTO sourceDTO) {
        SSLUtil.SSLConfiguration sslConfiguration = SSLUtil.getSSLConfiguration(sourceDTO);
        if (Objects.isNull(sslConfiguration)) {
            return null;
        }
        try {
            InputStream in = new FileInputStream(sslConfiguration.getTrustStorePath());
            KeyStore trustStore = KeyStore.getInstance(StringUtils.isNotBlank(sslConfiguration.getTrustStoreType()) ?
                    sslConfiguration.getTrustStoreType() : KeyStore.getDefaultType());
            try {
                trustStore.load(in, StringUtils.isNotBlank(sslConfiguration.getTrustStorePassword()) ?
                        sslConfiguration.getTrustStorePassword().toCharArray() : null);
            } finally {
                in.close();
            }
            return SSLContexts
                    .custom()
                    .loadTrustMaterial(trustStore, new TrustSelfSignedStrategy())  //????????????????????????
                    .build();
        } catch (Exception e) {
            log.info("get sslContext failed.", e);
            return null;
        }
    }


    /**
     * ????????? http ????????????
     *
     * @param connectTimeout ??????????????????
     * @param socketTimeout  socket ????????????
     * @return http ????????????
     */
    private static RequestConfig initRequestConfig(Integer connectTimeout, Integer socketTimeout) {
        final RequestConfig.Builder requestConfigBuilder = RequestConfig.custom();
        // ConnectTimeout:????????????.?????????????????????????????????????????????.
        Integer connTimeout = Objects.isNull(connectTimeout) ? HTTP_CONNECT_TIMEOUT : connectTimeout;
        Integer sockTimeout = Objects.isNull(socketTimeout) ? HTTP_SOCKET_TIMEOUT : socketTimeout;
        requestConfigBuilder.setConnectTimeout(connTimeout * 1000);
        // SocketTimeout:Socket????????????.?????????????????????????????????????????????????????????.
        requestConfigBuilder.setSocketTimeout(sockTimeout * 1000);
        // ConnectionRequestTimeout:httpclient??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        requestConfigBuilder.setConnectionRequestTimeout(HTTP_CONNECTION_REQUEST_TIMEOUT * 1000);
        return requestConfigBuilder.build();
    }

    /**
     * ??????????????????
     *
     * @return ConnectingIOReactor
     */
    private static ConnectingIOReactor initIOReactorConfig() {
        IOReactorConfig ioReactorConfig = IOReactorConfig.custom().setIoThreadCount(IO_THREAD_COUNT).build();
        ConnectingIOReactor ioReactor;
        try {
            ioReactor = new DefaultConnectingIOReactor(ioReactorConfig);
            return ioReactor;
        } catch (IOReactorException e) {
            throw new SourceException(e.getMessage(), e);
        }
    }

    /**
     * ???????????????????????????????????????????????????
     *
     * @param cm connection ?????????
     * @return ?????????????????????
     */
    private static ScheduledExecutorService initFixedCycleCloseConnection(final PoolingNHttpClientConnectionManager cm) {
        // ??????????????????????????????
        ScheduledExecutorService connectionGcService = Executors.newSingleThreadScheduledExecutor(new DtClassThreadFactory("Loader-close-connection"));
        connectionGcService.scheduleAtFixedRate(() -> {
            try {
                if (log.isDebugEnabled()) {
                    log.debug("Close idle connections, fixed cycle operation");
                }
                cm.closeIdleConnections(3, TimeUnit.MINUTES);
            } catch (Exception ex) {
                log.error("", ex);
            }
        }, 30, 30, TimeUnit.SECONDS);
        return connectionGcService;
    }

    /**
     * ???????????? http client
     *
     * @param cm             http connection ?????????
     * @param connectTimeout ??????????????????
     * @param socketTimeout  socket ????????????
     * @param kerberosConfig kerberos ??????
     * @return ?????? http client
     */
    private static CloseableHttpAsyncClient createPoolingHttpClient(PoolingNHttpClientConnectionManager cm, Integer connectTimeout, Integer socketTimeout, Map<String, Object> kerberosConfig) {

        if (MapUtils.isNotEmpty(kerberosConfig)) {
            return KerberosLoginUtil.loginWithUGI(kerberosConfig).doAs(
                    (PrivilegedAction<CloseableHttpAsyncClient>) () -> {
                        RequestConfig requestConfig = initRequestConfig(connectTimeout, socketTimeout);
                        HttpAsyncClientBuilder httpAsyncClientBuilder = HttpAsyncClients.custom();

                        // ?????????????????????
                        httpAsyncClientBuilder.setConnectionManager(cm);

                        // ??????RequestConfig
                        if (requestConfig != null) {
                            httpAsyncClientBuilder.setDefaultRequestConfig(requestConfig);
                        }

                        // ?????? kerberos ??????
                        CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
                        credentialsProvider.setCredentials(AuthScope.ANY, new KerberosCredentials(null));
                        httpAsyncClientBuilder.setDefaultCredentialsProvider(credentialsProvider);
                        return httpAsyncClientBuilder.build();
                    });

        }
        RequestConfig requestConfig = initRequestConfig(connectTimeout, socketTimeout);
        HttpAsyncClientBuilder httpAsyncClientBuilder = HttpAsyncClients.custom();

        // ?????????????????????
        httpAsyncClientBuilder.setConnectionManager(cm);

        // ??????RequestConfig
        if (requestConfig != null) {
            httpAsyncClientBuilder.setDefaultRequestConfig(requestConfig);
        }
        return httpAsyncClientBuilder.build();
    }

    /**
     * ?????????????????????????????????????????????HttpClient
     *
     * @param restfulSourceDTO
     * @param httpAsyncClient
     * @param clearConnService
     * @return
     */
    private static HttpClient buildHttpClient(RestfulSourceDTO restfulSourceDTO,
                                              CloseableHttpAsyncClient httpAsyncClient,
                                              ScheduledExecutorService clearConnService) {
        // TODO ????????????
        if (restfulSourceDTO.getSourceType().equals(99)) {
            return new HbaseHttpClient(restfulSourceDTO, httpAsyncClient, clearConnService);
        } else {
            return new HttpClient(restfulSourceDTO, httpAsyncClient, clearConnService);
        }
    }
}
