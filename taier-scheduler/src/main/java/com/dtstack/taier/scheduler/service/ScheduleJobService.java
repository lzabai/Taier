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

package com.dtstack.taier.scheduler.service;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.dtstack.taier.common.enums.Deleted;
import com.dtstack.taier.common.enums.EScheduleType;
import com.dtstack.taier.common.enums.ForceCancelFlag;
import com.dtstack.taier.common.enums.OperatorType;
import com.dtstack.taier.common.enums.Restarted;
import com.dtstack.taier.common.env.EnvironmentContext;
import com.dtstack.taier.common.exception.TaierDefineException;
import com.dtstack.taier.common.util.GenerateErrorMsgUtil;
import com.dtstack.taier.dao.domain.ScheduleJob;
import com.dtstack.taier.dao.domain.ScheduleJobExpand;
import com.dtstack.taier.dao.domain.ScheduleJobJob;
import com.dtstack.taier.dao.domain.ScheduleJobOperatorRecord;
import com.dtstack.taier.dao.domain.ScheduleTaskShade;
import com.dtstack.taier.dao.domain.po.SimpleScheduleJobPO;
import com.dtstack.taier.dao.mapper.ScheduleJobMapper;
import com.dtstack.taier.pluginapi.enums.TaskStatus;
import com.dtstack.taier.pluginapi.util.RetryUtil;
import com.dtstack.taier.scheduler.dto.scheduler.SimpleScheduleJobDTO;
import com.dtstack.taier.scheduler.enums.JobPhaseStatus;
import com.dtstack.taier.scheduler.impl.pojo.ParamActionExt;
import com.dtstack.taier.scheduler.mapstruct.ScheduleJobMapStruct;
import com.dtstack.taier.scheduler.server.JobPartitioner;
import com.dtstack.taier.scheduler.server.ScheduleJobDetails;
import com.dtstack.taier.scheduler.server.pipeline.operator.UnnecessaryPreprocessJobPipeline;
import com.dtstack.taier.scheduler.zookeeper.ZkService;
import com.google.common.collect.Lists;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @Auther: dazhi
 * @Date: 2021/12/28 8:14 PM
 * @Email: dazhi@dtstack.com
 * @Description:
 */
@Service
public class ScheduleJobService extends ServiceImpl<ScheduleJobMapper, ScheduleJob> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ScheduleJobService.class);

    @Autowired
    private ZkService zkService;

    @Autowired
    private ScheduleActionService actionService;

    @Autowired
    private JobPartitioner jobPartitioner;

    @Autowired
    private EnvironmentContext environmentContext;

    @Autowired
    private ScheduleJobJobService scheduleJobJobService;

    @Autowired
    private ScheduleJobExpandService scheduleJobExpandService;

    @Autowired
    private ScheduleJobOperatorRecordService scheduleJobOperatorRecordService;

    @Autowired
    private ScheduleTaskShadeInfoService scheduleTaskShadeInfoService;

    @Autowired
    private UnnecessaryPreprocessJobPipeline unnecessaryPreprocessJobPipeline;

    /**
     * ??????????????????
     *
     * @param scheduleJobDetails ??????
     */
    public void startJob(ScheduleJobDetails scheduleJobDetails) throws Exception {
        ScheduleJob scheduleJob = scheduleJobDetails.getScheduleJob();
        ScheduleTaskShade scheduleTaskShade = scheduleJobDetails.getScheduleTaskShade();

        // ????????????????????????
        JSONObject extraInfo = scheduleTaskShadeInfoService.getInfoJSON(scheduleJob.getTaskId());
        if (null == extraInfo) {
            //?????????????????? ?????????????????????
            this.updateStatusAndLogInfoById(scheduleJob.getJobId(), TaskStatus.FAILED.getStatus(), "task run extra info is empty");
            LOGGER.error(" job  {} run fail with info is null", scheduleJob.getJobId());
        }
        ParamActionExt paramActionExt = actionService.paramActionExt(scheduleTaskShade, scheduleJob, extraInfo);
        if (paramActionExt != null && !unnecessaryPreprocessJobPipeline.isMatch(scheduleJobDetails.getScheduleJob().getTaskType())) {
            updateStatusByJobIdAndVersionId(scheduleJob.getJobId(), TaskStatus.SUBMITTING.getStatus(), scheduleTaskShade.getVersionId());
            actionService.start(paramActionExt);
        }
    }

    /**
     * ????????????????????????
     *
     * @param resumeBatchJobs ????????????
     */
    @Transactional(rollbackFor = Exception.class)
    public void restartScheduleJob(Map<String, String> resumeBatchJobs) {
        if (MapUtils.isNotEmpty(resumeBatchJobs)) {
            List<String> restartJobId = new ArrayList<>(resumeBatchJobs.size());
            resumeBatchJobs.entrySet()
                    .stream()
                    .sorted(Comparator.nullsFirst(Map.Entry.comparingByValue(Comparator.nullsFirst(String::compareTo))))
                    .forEachOrdered(v -> {
                        if (null != v && StringUtils.isNotBlank(v.getKey())) {
                            restartJobId.add(v.getKey());
                        }
                    });

            List<List<String>> partition = Lists.partition(restartJobId, environmentContext.getBatchInsertSize());
            for (List<String> scheduleJobs : partition) {
                Set<String> jobIds = new HashSet<>(scheduleJobs.size());
                Set<ScheduleJobOperatorRecord> records = new HashSet<>(scheduleJobs.size());
                //???????????????????????????--??????????????????????????????
                for (String jobId : scheduleJobs) {
                    jobIds.add(jobId);
                    ScheduleJobOperatorRecord record = new ScheduleJobOperatorRecord();
                    record.setJobId(jobId);
                    record.setForceCancelFlag(ForceCancelFlag.NO.getFlag());
                    record.setOperatorType(OperatorType.RESTART.getType());
                    record.setNodeAddress(environmentContext.getLocalAddress());
                    records.add(record);
                }

                ScheduleJob scheduleJob = new ScheduleJob();
                scheduleJob.setStatus(TaskStatus.UNSUBMIT.getStatus());
                scheduleJob.setPhaseStatus(JobPhaseStatus.CREATE.getCode());
                scheduleJob.setIsRestart(Restarted.RESTARTED.getStatus());
                scheduleJob.setNodeAddress(environmentContext.getLocalAddress());
                scheduleJob.setRetryNum(0);

                // ????????????
                this.lambdaUpdate()
                        .eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus())
                        .in(ScheduleJob::getJobId, jobIds)
                        .update(scheduleJob);

                // ????????????
                scheduleJobExpandService.clearData(jobIds);
                scheduleJobOperatorRecordService.insertBatch(records);
                LOGGER.info("reset job {}", jobIds);
            }
        }
    }

    /**
     * ???????????????????????? jobSize ?????????????????? ?????? scheduleType??????????????? ??? ????????????
     *
     * @param jobBuilderBeanCollection ????????????
     * @param scheduleType             ???????????? ???????????? ??? ?????????
     */
    @Transactional(rollbackFor = Exception.class)
    public Long insertJobList(Collection<ScheduleJobDetails> jobBuilderBeanCollection, Integer scheduleType) {
        if (CollectionUtils.isEmpty(jobBuilderBeanCollection)) {
            return null;
        }

        Iterator<ScheduleJobDetails> batchJobIterator = jobBuilderBeanCollection.iterator();

        //count%20 ?????????
        //1: ????????????BatchJob
        //2: ????????????BatchJobJobList
        int count = 0;
        int jobBatchSize = environmentContext.getBatchInsertSize();
        int jobJobBatchSize = environmentContext.getBatchJobJobInsertSize();
        Long minJobId = null;
        List<ScheduleJob> jobWaitForSave = Lists.newArrayList();
        List<ScheduleJobJob> jobJobWaitForSave = Lists.newArrayList();

        Map<String, Integer> nodeJobSize = computeJobSizeForNode(jobBuilderBeanCollection.size(), scheduleType);
        for (Map.Entry<String, Integer> nodeJobSizeEntry : nodeJobSize.entrySet()) {
            String nodeAddress = nodeJobSizeEntry.getKey();
            int nodeSize = nodeJobSizeEntry.getValue();
            final int finalBatchNodeSize = nodeSize;
            while (nodeSize > 0 && batchJobIterator.hasNext()) {
                nodeSize--;
                count++;

                ScheduleJobDetails jobBuilderBean = batchJobIterator.next();

                ScheduleJob scheduleJob = jobBuilderBean.getScheduleJob();
                scheduleJob.setNodeAddress(nodeAddress);

                jobWaitForSave.add(scheduleJob);
                jobJobWaitForSave.addAll(jobBuilderBean.getJobJobList());

                LOGGER.debug("insertJobList count:{} batchJobs:{} finalBatchNodeSize:{}", count, jobBuilderBeanCollection.size(), finalBatchNodeSize);
                if (count % jobBatchSize == 0 || count == (jobBuilderBeanCollection.size() - 1) || jobJobWaitForSave.size() > jobJobBatchSize) {
                    minJobId = persistJobs(jobWaitForSave, jobJobWaitForSave, minJobId, jobJobBatchSize);
                    LOGGER.info("insertJobList count:{} batchJobs:{} finalBatchNodeSize:{} jobJobSize:{}", count, jobBuilderBeanCollection.size(), finalBatchNodeSize, jobJobWaitForSave.size());
                }
            }
            LOGGER.info("insertJobList count:{} batchJobs:{} finalBatchNodeSize:{}", count, jobBuilderBeanCollection.size(), finalBatchNodeSize);
            //?????????persist?????????flush??????jobs
            minJobId = persistJobs(jobWaitForSave, jobJobWaitForSave, minJobId, jobJobBatchSize);

        }
        return minJobId;
    }

    /**
     * ???????????????????????????ip
     *
     * @param jobSize      ?????????
     * @param scheduleType ???????????? ???????????? ??? ?????????
     */
    private Map<String, Integer> computeJobSizeForNode(int jobSize, int scheduleType) {
        Map<String, Integer> jobSizeInfo = jobPartitioner.computeBatchJobSize(scheduleType, jobSize);
        if (jobSizeInfo == null) {
            //if empty
            List<String> aliveNodes = zkService.getAliveBrokersChildren();
            jobSizeInfo = new HashMap<>(aliveNodes.size());
            int size = jobSize / aliveNodes.size() + 1;
            for (String aliveNode : aliveNodes) {
                jobSizeInfo.put(aliveNode, size);
            }
        }
        return jobSizeInfo;
    }

    /**
     * ????????????
     */
    private Long persistJobs(List<ScheduleJob> jobWaitForSave, List<ScheduleJobJob> jobJobWaitForSave, Long minJobId, Integer jobJobSize) {
        try {
            return RetryUtil.executeWithRetry(() -> {
                Long curMinJobId = minJobId;
                if (jobWaitForSave.size() > 0) {
                    this.saveBatch(jobWaitForSave);
                    if (Objects.isNull(minJobId)) {
                        curMinJobId = jobWaitForSave.stream().map(ScheduleJob::getId).min(Long::compareTo).orElse(null);
                    }

                    // ??????????????????
                    List<ScheduleJobExpand> scheduleJobExpandList = ScheduleJobMapStruct.INSTANCE.scheduleJobTOScheduleJobExpand(jobWaitForSave);
                    scheduleJobExpandService.saveBatch(scheduleJobExpandList);
                    jobWaitForSave.clear();
                }
                if (jobJobWaitForSave.size() > 0) {
                    if (jobJobWaitForSave.size() > jobJobSize) {
                        List<List<ScheduleJobJob>> partition = Lists.partition(jobJobWaitForSave, jobJobSize);
                        for (List<ScheduleJobJob> scheduleJobJobs : partition) {
                            scheduleJobJobService.saveBatch(scheduleJobJobs);
                            jobJobWaitForSave.removeAll(scheduleJobJobs);
                        }
                    } else {
                        scheduleJobJobService.saveBatch(jobJobWaitForSave);
                    }
                    jobJobWaitForSave.clear();
                }
                return curMinJobId;
            }, environmentContext.getBuildJobErrorRetry(), 200, false);
        } catch (Exception e) {
            LOGGER.error("!!!!! persistJobs job error !!!! job {} jobjob {}", jobWaitForSave, jobJobWaitForSave, e);
            throw new TaierDefineException(e);
        } finally {
            if (jobWaitForSave.size() > 0) {
                jobWaitForSave.clear();
            }
            if (jobJobWaitForSave.size() > 0) {
                jobJobWaitForSave.clear();
            }
        }
    }

    /**
     * ???????????????????????????
     *
     * @param jobId     ??????id
     * @param status    ??????
     * @param versionId ??????
     */
    private Boolean updateStatusByJobIdAndVersionId(String jobId, Integer status, Integer versionId) {
        ScheduleJob scheduleJob = new ScheduleJob();
        scheduleJob.setStatus(status);
        scheduleJob.setVersionId(versionId);
        return this.lambdaUpdate()
                .eq(ScheduleJob::getJobId, jobId)
                .eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus())
                .update(scheduleJob);
    }

    /**
     * ?????????????????????
     *
     * @param jobId   ??????id
     * @param status  ????????????
     * @param logInfo ????????????
     */
    public void updateStatusAndLogInfoById(String jobId, Integer status, String logInfo) {
        if (StringUtils.isNotBlank(logInfo) && logInfo.length() > 5000) {
            logInfo = logInfo.substring(0, 5000) + "...";
        }
        if (StringUtils.isNotBlank(jobId) && status != null) {
            updateJobStatusAndExecTime(jobId, status);
        }

        ScheduleJobExpand scheduleJobExpand = new ScheduleJobExpand();
        String errorLog = GenerateErrorMsgUtil.generateErrorMsg(logInfo);
        scheduleJobExpand.setLogInfo(errorLog);
        scheduleJobExpandService.lambdaUpdate()
                .eq(ScheduleJobExpand::getJobId, jobId)
                .eq(ScheduleJobExpand::getIsDeleted, Deleted.NORMAL.getStatus())
                .update(scheduleJobExpand);
    }

    /**
     * ??????????????????
     *
     * @param jobId  ?????? id
     * @param status ??????
     * @return ?????????
     */
    public Integer updateJobStatusAndExecTime(String jobId, Integer status) {
        if (StringUtils.isNotBlank(jobId) && status != null) {
            return this.baseMapper.updateJobStatusAndExecTime(jobId, status);
        }
        return 0;
    }

    /**
     * ??????????????????
     *
     * @param jobId ??????id
     * @return ??????????????????????????????????????????null
     */
    public Integer getJobStatusByJobId(String jobId) {
        if (StringUtils.isBlank(jobId)) {
            return null;
        }
        ScheduleJob scheduleJob = this.lambdaQuery().eq(ScheduleJob::getJobId, jobId).eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus()).one();

        if (scheduleJob == null) {
            return null;
        }
        return scheduleJob.getStatus();
    }

    /**
     * ?????????????????????????????????????????????JobPhaseStatus??????????????????????????????????????????????????????
     *
     * @param id       ??????id
     * @param original ????????????????????????
     * @param update   ?????????????????????????????????
     * @return ??????????????????
     */
    public boolean updatePhaseStatusById(Long id, JobPhaseStatus original, JobPhaseStatus update) {
        if (id == null || original == null || update == null) {
            return Boolean.FALSE;
        }

        Integer integer = this.baseMapper.updatePhaseStatusById(id, original.getCode(), update.getCode());

        if (integer != null && !integer.equals(0)) {
            return Boolean.TRUE;
        }
        return Boolean.FALSE;
    }

    /**
     * ????????????????????????
     *
     * @param startSort      ??????id
     * @param nodeAddress    ??????
     * @param type           ??????
     * @param isEq           ????????????????????????
     * @param jobPhaseStatus ????????????
     * @return ??????????????????
     */
    public List<ScheduleJob> listCycleJob(Long startSort, String nodeAddress, Integer type, Boolean isEq, Integer jobPhaseStatus) {
        if (startSort == null) {
            return Lists.newArrayList();
        }

        return this.baseMapper.listCycleJob(startSort, nodeAddress, type, isEq, jobPhaseStatus);
    }


    /**
     * ????????????
     *
     * @param jobId ??????id
     * @return ??????
     */
    public ScheduleJob getByJobId(String jobId) {
        return this.baseMapper
                .selectOne(Wrappers.lambdaQuery(ScheduleJob.class).eq(ScheduleJob::getJobId, jobId));
    }

    /**
     * ??????????????????
     *
     * @param jobIds ??????id
     * @return ??????
     */
    public List<ScheduleJob> getByJobIds(List<String> jobIds) {
        return this.baseMapper
                .selectList(Wrappers.lambdaQuery(ScheduleJob.class).in(ScheduleJob::getJobId, jobIds));
    }

    /**
     * ??????????????????
     *
     * @param scheduleJob ???????????????
     * @return ??????????????????
     */
    public int updateByJobId(ScheduleJob scheduleJob) {
        if (null == scheduleJob || StringUtils.isBlank(scheduleJob.getJobId())) {
            return 0;
        }
        return this.baseMapper.update(scheduleJob,
                Wrappers.lambdaQuery(ScheduleJob.class)
                        .eq(ScheduleJob::getJobId, scheduleJob.getJobId()));
    }

    /**
     * ????????????
     *
     * @param jobId     ??????id
     * @param engineLog ????????????
     * @param logInfo   ????????????
     * @return ???????????????
     */
    public Boolean updateExpandByJobId(String jobId, String engineLog, String logInfo) {
        if (StringUtils.isBlank(jobId)) {
            return Boolean.FALSE;
        }
        ScheduleJobExpand scheduleJobExpand = new ScheduleJobExpand();
        scheduleJobExpand.setJobId(jobId);
        scheduleJobExpand.setEngineLog(engineLog);
        scheduleJobExpand.setLogInfo(logInfo);
        return scheduleJobExpandService
                .lambdaUpdate()
                .eq(ScheduleJobExpand::getJobId, scheduleJobExpand.getJobId())
                .update(scheduleJobExpand);
    }

    /**
     * ????????????
     *
     * @param scheduleJob ??????
     * @return ???????????????
     */
    public int insert(ScheduleJob scheduleJob) {
        int insert = this.baseMapper.insert(scheduleJob);
        ScheduleJobExpand scheduleJobExpand = new ScheduleJobExpand();
        scheduleJobExpand.setJobId(scheduleJob.getJobId());
        scheduleJobExpandService.save(scheduleJobExpand);
        return insert;
    }

    /**
     * ??????????????????
     *
     * @param jobId            ??????id
     * @param status           ??????
     * @param generateErrorMsg ????????????
     */
    @Transactional(rollbackFor = Exception.class)
    public void jobFail(String jobId, Integer status, String generateErrorMsg) {
        updateStatus(jobId, status);
        updateExpandByJobId(jobId, null, generateErrorMsg);
    }

    /**
     * ??????????????????
     *
     * @param jobIds      ??????id
     * @param status      ????????????
     * @param phaseStatus ????????????
     */
    public int updateJobStatusByJobIds(List<String> jobIds, Integer status, Integer phaseStatus) {
        ScheduleJob scheduleJob = new ScheduleJob();
        scheduleJob.setStatus(status);
        scheduleJob.setPhaseStatus(phaseStatus);
        return this.baseMapper.update(scheduleJob, Wrappers.lambdaQuery(ScheduleJob.class)
                .in(ScheduleJob::getJobId, jobIds));
    }

    /**
     * ??????????????????????????????
     *
     * @param jobStartId     ??????id
     * @param unSubmitStatus ????????????
     * @param localAddress   ??????
     * @param phaseStatus    ????????????
     * @return ?????????????????????
     */
    public List<SimpleScheduleJobPO> listJobByStatusAddressAndPhaseStatus(Long jobStartId, List<Integer> unSubmitStatus, String localAddress, Integer phaseStatus) {
        return this.baseMapper.listJobByStatusAddressAndPhaseStatus(jobStartId, unSubmitStatus, localAddress, phaseStatus);
    }

    /**
     * ???????????? engineJobId???appId
     *
     * @param jobId       ??????id
     * @param engineJobId ??????id
     * @param appId       ??????id
     */
    public void updateJobSubmitSuccess(String jobId, String engineJobId, String appId) {
        ScheduleJob scheduleJob = getByJobId(jobId);
        LambdaUpdateWrapper<ScheduleJob> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.set(ScheduleJob::getApplicationId, appId);
        updateWrapper.set(ScheduleJob::getEngineJobId, engineJobId);
        updateWrapper.set(ScheduleJob::getExecStartTime, Timestamp.valueOf(LocalDateTime.now()));
        updateWrapper.set(ScheduleJob::getExecEndTime, null);
        updateWrapper.set(ScheduleJob::getGmtModified, Timestamp.valueOf(LocalDateTime.now()));
        updateWrapper.eq(ScheduleJob::getJobId, jobId);
        this.baseMapper.update(scheduleJob, updateWrapper);
    }

    /**
     * ????????????
     *
     * @param jobId  ??????id
     * @param status ??????
     */
    public void updateStatus(String jobId, Integer status) {
        ScheduleJob updateScheduleJob = new ScheduleJob();
        updateScheduleJob.setJobId(jobId);
        updateScheduleJob.setStatus(status);
        this.baseMapper.update(updateScheduleJob, Wrappers.lambdaQuery(ScheduleJob.class)
                .eq(ScheduleJob::getJobId, jobId));
    }

    /**
     * ??????????????????
     *
     * @param jobId    ??????id
     * @param retryNum ????????????
     */
    public void updateRetryNum(String jobId, Integer retryNum) {
        ScheduleJob updateScheduleJob = new ScheduleJob();
        updateScheduleJob.setJobId(jobId);
        updateScheduleJob.setRetryNum(retryNum);
        this.baseMapper.update(updateScheduleJob, Wrappers.lambdaQuery(ScheduleJob.class)
                .eq(ScheduleJob::getJobId, jobId));
    }


    public void clearInterruptJob(Long startExecuteOrder) {
        this.baseMapper.delete(Wrappers.lambdaQuery(ScheduleJob.class).ge(ScheduleJob::getJobExecuteOrder, startExecuteOrder)
                .eq(ScheduleJob::getType, EScheduleType.NORMAL_SCHEDULE.getType())
                .eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus()));
    }

    /**
     * ???????????????????????????
     *
     * @param startId            ??????id
     * @param unfinishedStatuses ?????????????????????
     * @param nodeAddress        ??????
     * @return ?????????????????????job??????
     */
    public List<SimpleScheduleJobDTO> listSimpleJobByStatusAddress(Long startId, List<Integer> unfinishedStatuses, String nodeAddress) {
        if (startId < 0 || StringUtils.isBlank(nodeAddress)) {
            return Lists.newArrayList();
        }
        List<ScheduleJob> simpleScheduleJobPOS = this.baseMapper.listSimpleJobByStatusAddress(startId, unfinishedStatuses, nodeAddress);
        return ScheduleJobMapStruct.INSTANCE.scheduleJobTOSimpleScheduleJobDTO(simpleScheduleJobPOS);
    }

    public void updateStatusWithExecTime(ScheduleJob job) {
        ScheduleJob updateScheduleJob = new ScheduleJob();
        updateScheduleJob.setExecStartTime(job.getExecStartTime());
        updateScheduleJob.setExecEndTime(job.getExecEndTime());
        updateScheduleJob.setExecTime(job.getExecTime());
        updateScheduleJob.setStatus(job.getStatus());
        this.baseMapper.update(updateScheduleJob, Wrappers.lambdaQuery(ScheduleJob.class)
                .eq(ScheduleJob::getJobId, job.getJobId()));
    }

    /**
     * ??????????????????
     *
     * @param jobIds jobId
     * @return ??????
     */
    public List<ScheduleJob> getWorkFlowSubJobs(List<String> jobIds) {
        return this.baseMapper
                .selectList(Wrappers.lambdaQuery(ScheduleJob.class)
                        .in(ScheduleJob::getFlowJobId, jobIds)
                        .eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus()));
    }
}
