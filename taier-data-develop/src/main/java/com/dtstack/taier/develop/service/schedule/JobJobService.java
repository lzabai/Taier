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

package com.dtstack.taier.develop.service.schedule;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.dtstack.taier.common.enums.Deleted;
import com.dtstack.taier.common.enums.DisplayDirect;
import com.dtstack.taier.common.enums.EScheduleJobType;
import com.dtstack.taier.common.env.EnvironmentContext;
import com.dtstack.taier.common.exception.ErrorCode;
import com.dtstack.taier.common.exception.TaierDefineException;
import com.dtstack.taier.dao.domain.ScheduleJob;
import com.dtstack.taier.dao.domain.ScheduleJobJob;
import com.dtstack.taier.dao.domain.ScheduleTaskShade;
import com.dtstack.taier.dao.mapper.ScheduleJobJobMapper;
import com.dtstack.taier.develop.service.user.UserService;
import com.dtstack.taier.develop.utils.JobUtils;
import com.dtstack.taier.develop.vo.schedule.JobNodeVO;
import com.dtstack.taier.develop.vo.schedule.ReturnJobDisplayVO;
import com.dtstack.taier.pluginapi.util.DateUtil;
import com.dtstack.taier.scheduler.dto.schedule.QueryJobDisplayDTO;
import com.dtstack.taier.scheduler.enums.RelyType;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Auther: dazhi
 * @Date: 2021/12/26 10:34 AM
 * @Email:dazhi@dtstack.com
 * @Description:
 */
@Service
public class JobJobService extends ServiceImpl<ScheduleJobJobMapper, ScheduleJobJob> {

    @Autowired
    private JobService jobService;

    @Autowired
    private TaskService taskService;

    @Autowired
    private EnvironmentContext context;

    @Autowired
    private UserService userService;

    @Autowired
    private TaskTaskService taskTaskService;

    public ReturnJobDisplayVO displayOffSpring(QueryJobDisplayDTO dto) {
        // ???????????? 0<level< max.level
        dto.setLevel(JobUtils.checkLevel(dto.getLevel(), context.getMaxLevel()));

        // ????????????????????????,?????????????????????????????????????????????????????????????????????
        ScheduleJob scheduleJob = jobService.lambdaQuery()
                .eq(ScheduleJob::getJobId, dto.getJobId())
                .eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus())
                .one();

        if (scheduleJob == null) {
            throw new TaierDefineException("job does not exist");
        }

        ReturnJobDisplayVO vo = new ReturnJobDisplayVO();
        vo.setDirectType(dto.getDirectType());

        // ??????db???????????????????????????????????????????????????
        List<String> jobKeys = Lists.newArrayList(scheduleJob.getJobKey());
        Map<String, List<String>> jobJobMaps = findJobJobByJobKeys(dto, jobKeys);

        // ??????????????????
        List<ScheduleJob> scheduleJobList = findJobByJobJob(jobJobMaps);
        scheduleJobList.add(scheduleJob);
        Map<String, ScheduleJob> jobMap = scheduleJobList.stream().collect(Collectors.groupingBy(ScheduleJob::getJobKey,
                Collectors.collectingAndThen(Collectors.toCollection(ArrayList<ScheduleJob>::new), a -> a.get(0))));

        // ??????????????????
        Map<Long, ScheduleTaskShade> taskShadeMap = findTaskJob(scheduleJobList);

        vo.setRootNode(buildRootNode(dto.getDirectType(), scheduleJob, taskShadeMap, jobMap, jobJobMaps));
        return vo;
    }

    /**
     * ???????????????
     *
     * @param directType   ????????????????????????:??????
     * @param scheduleJob  ??????????????????
     * @param taskShadeMap ????????????
     * @param jobMap       ????????????
     * @param jobJobMaps   ?????????????????????
     * @return ?????????
     */
    private JobNodeVO buildRootNode(Integer directType,
                                    ScheduleJob scheduleJob,
                                    Map<Long, ScheduleTaskShade> taskShadeMap,
                                    Map<String, ScheduleJob> jobMap,
                                    Map<String, List<String>> jobJobMaps) {
        JobNodeVO rootNode = new JobNodeVO();
        rootNode.setJobId(scheduleJob.getJobId());
        rootNode.setStatus(scheduleJob.getStatus());
        rootNode.setTaskId(scheduleJob.getTaskId());
        rootNode.setTaskType(scheduleJob.getTaskType());
        rootNode.setCycTime(DateUtil.addTimeSplit(scheduleJob.getCycTime()));
        String userName = userService.getUserName(scheduleJob.getCreateUserId());
        rootNode.setOperatorId(scheduleJob.getCreateUserId());
        rootNode.setOperatorName(userName);

        ScheduleTaskShade taskShade = taskShadeMap.get(scheduleJob.getTaskId());
        if (taskShade != null) {
            rootNode.setTaskName(taskShade.getName());
            rootNode.setTaskGmtCreate(taskShade.getGmtCreate());
        }

        if (DisplayDirect.CHILD.getType().equals(directType)) {
            rootNode.setChildNode(displayLevelNode(directType, scheduleJob.getJobKey(), taskShadeMap, jobMap, jobJobMaps));
        } else {
            rootNode.setParentNode(displayLevelNode(directType, scheduleJob.getJobKey(), taskShadeMap, jobMap, jobJobMaps));
        }
        return rootNode;
    }

    /**
     * ??????????????????
     *
     * @param directType   ????????????????????????:??????
     * @param rootJobKey   ?????????key
     * @param taskShadeMap ????????????
     * @param jobMap       ????????????
     * @param jobJobMaps   ?????????????????????
     * @return ????????????
     */
    private List<JobNodeVO> displayLevelNode(Integer directType,
                                             String rootJobKey,
                                             Map<Long, ScheduleTaskShade> taskShadeMap,
                                             Map<String, ScheduleJob> jobMap,
                                             Map<String, List<String>> jobJobMaps) {

        List<String> jobKeys = jobJobMaps.get(rootJobKey);
        List<JobNodeVO> jobNodeVOList = Lists.newArrayList();
        if (CollectionUtils.isEmpty(jobKeys)) {
            return Lists.newArrayList();
        }

        for (String jobKey : jobKeys) {
            JobNodeVO vo = new JobNodeVO();
            ScheduleJob scheduleJob = jobMap.get(jobKey);

            if (scheduleJob != null) {
                vo.setJobId(scheduleJob.getJobId());
                vo.setStatus(scheduleJob.getStatus());
                vo.setTaskId(scheduleJob.getTaskId());
                vo.setTaskType(scheduleJob.getTaskType());
                vo.setCycTime(DateUtil.addTimeSplit(scheduleJob.getCycTime()));

                ScheduleTaskShade taskShade = taskShadeMap.get(scheduleJob.getTaskId());
                if (taskShade != null) {
                    vo.setTaskName(taskShade.getName());
                    vo.setTaskGmtCreate(taskShade.getGmtCreate());
                }

                if (DisplayDirect.CHILD.getType().equals(directType)) {
                    vo.setChildNode(displayLevelNode(directType, scheduleJob.getJobKey(), taskShadeMap, jobMap, jobJobMaps));
                } else {
                    vo.setParentNode(displayLevelNode(directType, scheduleJob.getJobKey(), taskShadeMap, jobMap, jobJobMaps));
                }

                jobNodeVOList.add(vo);
            }
        }
        return jobNodeVOList;
    }

    /**
     * ???????????????????????????
     *
     * @param scheduleJobList ????????????
     * @return ????????????
     */
    private Map<Long, ScheduleTaskShade> findTaskJob(List<ScheduleJob> scheduleJobList) {
        List<Long> taskIdList = scheduleJobList.stream().map(ScheduleJob::getTaskId).collect(Collectors.toList());
        if (CollectionUtils.isEmpty(taskIdList)) {
            return Maps.newHashMap();
        }
        List<ScheduleTaskShade> taskShadeList = taskService.lambdaQuery()
                .in(ScheduleTaskShade::getTaskId, taskIdList)
                .eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                .list();
        return taskShadeList.stream().collect(Collectors.toMap(ScheduleTaskShade::getTaskId, g -> (g)));
    }

    /**
     * ??????????????????
     *
     * @param allJobJob ?????????????????????
     * @return ????????????
     */
    private List<ScheduleJob> findJobByJobJob(Map<String, List<String>> allJobJob) {
        Set<String> jobKeySet = Sets.newHashSet(allJobJob.keySet());
        for (List<String> jobKeyList : allJobJob.values()) {
            jobKeySet.addAll(jobKeyList);
        }

        if (CollectionUtils.isEmpty(jobKeySet)) {
            return Lists.newArrayList();
        }
        return jobService.lambdaQuery()
                .in(ScheduleJob::getJobKey, jobKeySet)
                .eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus())
                .list();
    }

    /**
     * ????????????????????????
     *
     * @param dto     ?????????????????????
     * @param jobKeys ????????????key
     * @return ??????????????????????????????
     */
    private Map<String, List<String>> findJobJobByJobKeys(QueryJobDisplayDTO dto, List<String> jobKeys) {
        Integer level = dto.getLevel();
        Integer directType = dto.getDirectType();
        Map<String, List<String>> jobJobKeyMap = Maps.newHashMap();
        // ?????????????????????jobjob???
        for (int i = 0; i < level; i++) {
            if (CollectionUtils.isEmpty(jobKeys)) {
                break;
            }
            if (DisplayDirect.CHILD.getType().equals(directType)) {
                // ????????????
                List<ScheduleJobJob> jobJobList = this.lambdaQuery()
                        .in(ScheduleJobJob::getParentJobKey, jobKeys)
                        .eq(ScheduleJobJob::getJobKeyType, RelyType.UPSTREAM.getType())
                        .eq(ScheduleJobJob::getIsDeleted, Deleted.NORMAL.getStatus())
                        .list();

                jobJobKeyMap.putAll(jobJobList.stream().collect(Collectors.groupingBy(ScheduleJobJob::getParentJobKey, Collectors.mapping(ScheduleJobJob::getJobKey, Collectors.toList()))));
                jobKeys = jobJobList.stream().map(ScheduleJobJob::getJobKey).collect(Collectors.toList());
            } else {
                // ????????????
                List<ScheduleJobJob> jobJobList = this.lambdaQuery()
                        .in(ScheduleJobJob::getJobKey, jobKeys)
                        .eq(ScheduleJobJob::getJobKeyType, RelyType.UPSTREAM.getType())
                        .eq(ScheduleJobJob::getIsDeleted, Deleted.NORMAL.getStatus())
                        .list();

                jobJobKeyMap.putAll(jobJobList.stream().collect(Collectors.groupingBy(ScheduleJobJob::getJobKey, Collectors.mapping(ScheduleJobJob::getParentJobKey, Collectors.toList()))));
                jobKeys = jobJobList.stream().map(ScheduleJobJob::getParentJobKey).collect(Collectors.toList());
            }
        }

        return jobJobKeyMap;
    }


    public List<String> getWorkFlowTopTask(String jobId) {
        ScheduleJob workFlowJob = jobService.getScheduleJob(jobId);
        if (null == workFlowJob || !Objects.equals(EScheduleJobType.WORK_FLOW.getType(), workFlowJob.getTaskType())) {
            throw new TaierDefineException(ErrorCode.CAN_NOT_FIND_TASK);
        }
        List<Long> workFlowTopTaskId = taskTaskService.getWorkFlowTopTask(workFlowJob.getTaskId());
        List<ScheduleJob> workFlowTopJobs = jobService.getBaseMapper().selectList(Wrappers.lambdaQuery(ScheduleJob.class)
                .eq(ScheduleJob::getFlowJobId, jobId)
                .in(ScheduleJob::getTaskId, workFlowTopTaskId)
                .eq(ScheduleJob::getIsDeleted, Deleted.NORMAL.getStatus()));
        return workFlowTopJobs.stream()
                .map(ScheduleJob::getJobId)
                .collect(Collectors.toList());
    }
}
