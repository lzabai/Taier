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

package com.dtstack.taier.scheduler.server.scheduler;

import com.dtstack.taier.common.enums.Deleted;
import com.dtstack.taier.common.enums.OperatorType;
import com.dtstack.taier.dao.domain.ScheduleEngineJobCache;
import com.dtstack.taier.dao.domain.ScheduleJob;
import com.dtstack.taier.dao.domain.ScheduleJobJob;
import com.dtstack.taier.dao.domain.ScheduleJobOperatorRecord;
import com.dtstack.taier.pluginapi.enums.TaskStatus;
import com.dtstack.taier.scheduler.server.ScheduleJobDetails;
import com.dtstack.taier.scheduler.service.ScheduleJobCacheService;
import com.dtstack.taier.scheduler.service.ScheduleJobJobService;
import com.dtstack.taier.scheduler.service.ScheduleJobOperatorRecordService;
import com.dtstack.taier.scheduler.service.ScheduleJobService;
import com.google.common.collect.Lists;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Auther: dazhi
 * @Date: 2022/1/10 7:02 PM
 * @Email:dazhi@dtstack.com
 * @Description:
 */
public abstract class OperatorRecordJobScheduler extends AbstractJobSummitScheduler {

    @Autowired
    protected ScheduleJobService scheduleJobService;

    @Autowired
    protected ScheduleJobJobService scheduleJobJobService;

    @Autowired
    protected ScheduleJobCacheService scheduleJobCacheService;

    @Autowired
    private ScheduleJobOperatorRecordService scheduleJobOperatorRecordService;

    private Long operatorRecordStartId = 0L;

    @Override
    protected List<ScheduleJobDetails> listExecJob(Long startSort, String nodeAddress, Boolean isEq) {
        List<ScheduleJobOperatorRecord> records = scheduleJobOperatorRecordService.listOperatorRecord(operatorRecordStartId, nodeAddress, getOperatorType().getType(), isEq);
        //empty
        if (CollectionUtils.isEmpty(records)) {
            operatorRecordStartId = 0L;
            return new ArrayList<>();
        }

        Set<String> jobIds = records.stream().map(ScheduleJobOperatorRecord::getJobId).collect(Collectors.toSet());
        List<ScheduleJob> scheduleJobList = getScheduleJob(jobIds);

        if (CollectionUtils.isEmpty(scheduleJobList)) {
            operatorRecordStartId = 0L;
            removeOperatorRecord(Lists.newArrayList(jobIds));
        }

        //set max
        records.stream().max(Comparator.comparing(ScheduleJobOperatorRecord::getId))
                .ifPresent(scheduleJobOperatorRecord -> operatorRecordStartId = scheduleJobOperatorRecord.getId());

        if (jobIds.size() != scheduleJobList.size()) {
            List<String> jodExecIds = scheduleJobList.stream().map(ScheduleJob::getJobId).collect(Collectors.toList());
            // ????????????????????????????????????????????????????????????
            List<String> deleteJobIdList = jobIds.stream().filter(jobId -> !jodExecIds.contains(jobId)).collect(Collectors.toList());
            removeOperatorRecord(deleteJobIdList);
        }

        List<String> jobKeys = scheduleJobList.stream().map(ScheduleJob::getJobKey).collect(Collectors.toList());
        List<ScheduleJobJob> scheduleJobJobList = scheduleJobJobService.listByJobKeys(jobKeys);
        Map<String, List<ScheduleJobJob>> jobJobMap = scheduleJobJobList.stream().collect(Collectors.groupingBy(ScheduleJobJob::getJobKey));

        return scheduleJobList.stream().map(scheduleJob -> {
            ScheduleJobDetails scheduleJobDetails = new ScheduleJobDetails();
            scheduleJobDetails.setScheduleJob(scheduleJob);
            scheduleJobDetails.setJobJobList(jobJobMap.get(scheduleJob.getJobKey()));
            return scheduleJobDetails;
        }).collect(Collectors.toList());
    }

    /**
     * ??????????????????????????????
     *
     * @param deleteJobIdList ??????id
     */
    private void removeOperatorRecord(List<String> deleteJobIdList) {
        // ??????OperatorRecord?????????????????????????????????
        // 1. ?????????jobId??????????????????????????????????????????????????????id????????????
        // 2. ??????cache???????????????????????????????????????
        //      ???????????????????????????cache???????????????Operator?????????
        //      ?????????job??????????????????????????????Operator????????????

        // ??????cache????????????
        Map<String, ScheduleEngineJobCache> scheduleEngineJobCacheMaps = scheduleJobCacheService
                .lambdaQuery()
                .in(ScheduleEngineJobCache::getJobId, deleteJobIdList)
                .eq(ScheduleEngineJobCache::getIsDeleted, Deleted.NORMAL.getStatus())
                .list()
                .stream()
                .collect(Collectors.toMap(ScheduleEngineJobCache::getJobId, g -> (g)));

        // ?????????????????????OperatorRecord???????????????
        Map<String, ScheduleJob> scheduleJobMap = scheduleJobService
                .lambdaQuery()
                .in(ScheduleJob::getJobId, deleteJobIdList)
                .eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus())
                .list()
                .stream()
                .collect(Collectors.toMap(ScheduleJob::getJobId, g -> (g)));
        List<String> needDeleteJobIdList = Lists.newArrayList();

        for (String jobId : deleteJobIdList) {
            ScheduleEngineJobCache scheduleEngineJobCache = scheduleEngineJobCacheMaps.get(jobId);

            if (scheduleEngineJobCache != null) {
                // cache????????? ???????????? ????????????2??????????????????????????????????????????job?????????
                ScheduleJob scheduleJob = scheduleJobMap.get(jobId);

                // ?????????????????????????????????????????????job??????????????????????????????Operator????????????
                if (scheduleJob != null && TaskStatus.STOPPED_STATUS.contains(scheduleJob.getStatus())) {
                    needDeleteJobIdList.add(jobId);
                }

                if (scheduleJob == null) {
                    // ??????????????????????????????????????????????????????????????????OperatorRecord??????????????????????????????????????????????????????
                    needDeleteJobIdList.add(jobId);
                }

            } else {
                if (TaskStatus.STOPPED_STATUS.contains(scheduleJobMap.get(jobId).getStatus())) {
                    // ?????????????????????
                    needDeleteJobIdList.add(jobId);
                }
            }
        }

        // ??????OperatorRecord??????
        if (CollectionUtils.isNotEmpty(needDeleteJobIdList)) {
            scheduleJobOperatorRecordService
                    .lambdaUpdate()
                    .in(ScheduleJobOperatorRecord::getJobId, needDeleteJobIdList)
                    .remove();
        }
    }

    /**
     * ??????operator??????
     *
     * @return ?????????
     */
    public abstract OperatorType getOperatorType();

    /**
     * ??????????????????
     *
     * @param jobIds ??????id
     * @return ??????
     */
    protected abstract List<ScheduleJob> getScheduleJob(Set<String> jobIds);
}
