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

package com.dtstack.taier.develop.service.develop.impl;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.dtstack.taier.common.enums.EMetricTag;
import com.dtstack.taier.common.enums.EScheduleJobType;
import com.dtstack.taier.common.enums.ETimeCarry;
import com.dtstack.taier.common.exception.TaierDefineException;
import com.dtstack.taier.common.metric.batch.IMetric;
import com.dtstack.taier.common.metric.prometheus.PrometheusMetricQuery;
import com.dtstack.taier.common.metric.stream.CustomMetric;
import com.dtstack.taier.common.metric.stream.StreamMetricBuilder;
import com.dtstack.taier.common.metric.stream.prometheus.CustomPrometheusMetricQuery;
import com.dtstack.taier.common.metric.stream.prometheus.ICustomMetricQuery;
import com.dtstack.taier.common.param.MetricResultVO;
import com.dtstack.taier.dao.domain.ScheduleJob;
import com.dtstack.taier.dao.domain.StreamMetricSupport;
import com.dtstack.taier.dao.domain.Task;
import com.dtstack.taier.develop.dto.devlop.StreamTaskMetricDTO;
import com.dtstack.taier.develop.dto.devlop.TimespanVO;
import com.dtstack.taier.develop.service.schedule.JobService;
import com.dtstack.taier.develop.utils.TimeUtil;
import com.dtstack.taier.pluginapi.enums.ComputeType;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.math3.util.Pair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class StreamJobMetricService {
    private static final Logger LOGGER = LoggerFactory.getLogger(StreamJobMetricService.class);
    @Autowired
    private JobService jobService;

    @Autowired
    private DevelopTaskService taskService;
    @Autowired
    private DevelopServerLogService serverLogService;

    @Autowired
    private StreamMetricSupportService streamMetricSupportService;

    private static Map<String,List<String>> chartMetricMap = new HashMap<>();

    static {
        chartMetricMap.put("data_acquisition_rps",Arrays.asList("data_acquisition_input_rps","data_acquisition_output_rps"));
        chartMetricMap.put("data_acquisition_bps",Arrays.asList("data_acquisition_input_bps","data_acquisition_output_bps"));
        chartMetricMap.put("data_acquisition_record_sum",Arrays.asList("data_acquisition_input_record_sum","data_acquisition_output_record_sum"));
        chartMetricMap.put("data_acquisition_byte_sum",Arrays.asList("data_acquisition_input_byte_sum","data_acquisition_output_byte_sum"));
        chartMetricMap.put("dirtyErrors",Arrays.asList("nErrors","conversionErrors","duplicateErrors","nullErrors","otherErrors"));
    }

    public PrometheusMetricQuery buildPrometheusMetric(Long dtUicTenantId, String componentVersion) {
        Pair<String, String> prometheusHostAndPort = serverLogService.getPrometheusHostAndPort(dtUicTenantId, null, ComputeType.STREAM);
        if (prometheusHostAndPort == null){
            throw new TaierDefineException("promethues????????????");
        }
        return new PrometheusMetricQuery(String.format("%s:%s", prometheusHostAndPort.getKey(), prometheusHostAndPort.getValue()));
    }

    /**
     * ????????????????????????????????? prometheus ??????
     *
     * @param taskId ??????id
     * @return ?????? key ??????
     */
    public List<String> getMetricsByTaskType(Long taskId) {
        Task streamTask = taskService.getOne(taskId);
        List<String> metric = streamMetricSupportService.getMetricKeyByType(streamTask.getTaskType(), streamTask.getComponentVersion());
        // ????????? key????????????????????????????????? 1.10 ?????????
        List<String> commonMetric = streamMetricSupportService.getMetricKeyByType(99, "1.12");
        metric.addAll(commonMetric);
        return metric;
    }
    /**
     * ??????????????????
     *
     * @param metricDTO ???????????????
     * @return ????????????
     */
    public JSONArray getTaskMetrics(StreamTaskMetricDTO metricDTO){
        if (CollectionUtils.isEmpty(metricDTO.getChartNames())) {
            throw new TaierDefineException("chartName????????????");
        }

        Task task = taskService.getDevelopTaskById(metricDTO.getTaskId());

        TimespanVO formatTimespan = formatTimespan(metricDTO.getTimespan());
        if (!formatTimespan.getCorrect()) {
            throw new TaierDefineException(String.format("timespan format error: %s", formatTimespan.getMsg()));
        }
        Long span = formatTimespan.getSpan();
        long endTime = metricDTO.getEnd().getTime();
        long startTime = TimeUtil.getStartTime(endTime, span);
        String jobName = EScheduleJobType.DATA_ACQUISITION.getVal().equals(task.getTaskType()) ? task.getName() :  task.getName() + "_" + task.getId();
        ScheduleJob scheduleJob = jobService.getScheduleJob(task.getJobId());
        JSONArray chartDatas = new JSONArray();
        if(Objects.isNull(scheduleJob)) {
            return chartDatas;
        }
        String jobId = scheduleJob.getEngineJobId();
        Long dtuicTenantId = task.getTenantId();
        PrometheusMetricQuery prometheusMetricQuery = buildPrometheusMetric(dtuicTenantId, task.getComponentVersion());
        for (String chartName : metricDTO.getChartNames()) {
            if (chartMetricMap.containsKey(chartName)) {
                List<JSONObject> metricDatas = new ArrayList<>();
                for (String metricName : chartMetricMap.get(chartName)) {
                    IMetric metric = StreamMetricBuilder.buildMetric(metricName, startTime, endTime, jobName, jobId, buildGranularity(span), prometheusMetricQuery, task.getComponentVersion());
                    if (metric != null) {
                        metricDatas.add((JSONObject) metric.getMetric());
                    }
                }

                chartDatas.add(StreamMetricBuilder.mergeMetric(metricDatas, chartName, buildGranularity(span)));
            } else {
                IMetric metric = StreamMetricBuilder.buildMetric(chartName, startTime, endTime, jobName, jobId, buildGranularity(span), prometheusMetricQuery, task.getComponentVersion());
                if (metric != null) {
                    chartDatas.add(metric.getMetric());
                }
            }
        }

        return chartDatas;
    }

    /**
     * ??????????????????????????????????????????????????? 300 ??????
     * @param timespan ????????????
     * @return ????????????
     */
    public String buildGranularity(Long timespan) {
        // ????????????????????????????????? 300 ??????
        long granularity = timespan / (300 * 1000);
        return (granularity < 1 ? 1 : granularity) + ETimeCarry.SECOND.getType();
    }

    /**
     * ?????????????????????
     *
     * @param timespan ????????????
     * @return ???????????????
     */
    public TimespanVO formatTimespan(String timespan) {
        TimespanVO timespanVO = TimeUtil.formatTimespan(timespan);
        // ????????????????????????2y
        if (timespanVO.getCorrect() && timespanVO.getSpan() > 2 * 1000L * ETimeCarry.YEAR.getConvertToSecond()) {
            timespanVO.setCorrect(false);
            timespanVO.setFormatResult(null);
            timespanVO.setMsg("timespan cannot be greater than 2y");
        }
        return timespanVO;
    }

    /**
     * ????????????????????????
     *
     * @param dtUicTenantId UIC ?????? id
     * @param taskId        ??????id
     * @param end           ????????????
     * @param timespan      ????????????
     * @param chartName     ??????key
     * @return ??????????????????
     */
    public List<MetricResultVO> queryTaskMetrics(Long dtUicTenantId, Long taskId, Long end, String timespan, String chartName) {
        Task streamTask = taskService.getOne(taskId);
        StreamMetricSupport metric = streamMetricSupportService.getMetricByValue(chartName, streamTask.getComponentVersion());
        EMetricTag metricTag = EMetricTag.getByTagVal(metric.getMetricTag());
        String tagValue;
        if (metricTag.equals(EMetricTag.JOB_ID)) {
            // ????????? engine ?????????????????? ??????id
            tagValue = jobService.getScheduleJob(streamTask.getJobId()).getEngineJobId();
        } else {
            tagValue = streamTask.getJobId();
        }
        Pair<String, String> prometheusHostAndPort = serverLogService.getPrometheusHostAndPort(dtUicTenantId, null, ComputeType.STREAM);
        if (prometheusHostAndPort == null){
            throw new TaierDefineException("promethues????????????");
        }
        ICustomMetricQuery<List<MetricResultVO>> prometheusMetricQuery = new CustomPrometheusMetricQuery<>(String.format("%s:%s", prometheusHostAndPort.getKey(), prometheusHostAndPort.getValue()));
        TimespanVO formatTimespan = formatTimespan(timespan);
        if (!formatTimespan.getCorrect()) {
            throw new TaierDefineException(String.format("timespan format error: %s", formatTimespan.getMsg()));
        }
        Long span = formatTimespan.getSpan();
        long startTime = end - span;
        CustomMetric<List<MetricResultVO>> listCustomMetric = CustomMetric.buildCustomMetric(chartName, startTime, end, metricTag, tagValue, buildGranularity(span), prometheusMetricQuery);
        return listCustomMetric.getMetric(Integer.MAX_VALUE);
    }
}
