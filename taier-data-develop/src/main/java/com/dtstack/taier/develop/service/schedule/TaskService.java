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

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.dtstack.taier.common.enums.Deleted;
import com.dtstack.taier.common.enums.EScheduleJobType;
import com.dtstack.taier.common.enums.EScheduleStatus;
import com.dtstack.taier.common.exception.DtCenterDefException;
import com.dtstack.taier.common.exception.ErrorCode;
import com.dtstack.taier.dao.domain.ScheduleTaskShade;
import com.dtstack.taier.dao.domain.ScheduleTaskShadeInfo;
import com.dtstack.taier.dao.domain.ScheduleTaskTaskShade;
import com.dtstack.taier.dao.domain.User;
import com.dtstack.taier.dao.mapper.ScheduleTaskShadeMapper;
import com.dtstack.taier.dao.pager.PageResult;
import com.dtstack.taier.develop.graph.FlatDirectedGraphLoopJudge;
import com.dtstack.taier.develop.graph.GenericFlatFlatDirectedGraphLoopJudge;
import com.dtstack.taier.develop.graph.adapter.ScheduleTaskTaskShadeFlatGraphSideAdapterFlat;
import com.dtstack.taier.develop.mapstruct.task.ScheduleTaskMapstructTransfer;
import com.dtstack.taier.develop.service.user.UserService;
import com.dtstack.taier.develop.vo.schedule.ReturnScheduleTaskVO;
import com.dtstack.taier.develop.vo.schedule.ReturnTaskSupportTypesVO;
import com.dtstack.taier.pluginapi.enums.ComputeType;
import com.dtstack.taier.scheduler.dto.schedule.QueryTaskListDTO;
import com.dtstack.taier.scheduler.dto.schedule.SavaTaskDTO;
import com.dtstack.taier.scheduler.service.ScheduleTaskShadeInfoService;
import com.google.common.collect.Lists;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Auther: dazhi
 * @Date: 2021/12/6 3:48 PM
 * @Email:dazhi@dtstack.com
 * @Description:
 */
@Service
public class TaskService extends ServiceImpl<ScheduleTaskShadeMapper, ScheduleTaskShade> {

    private static final Logger LOGGER = LoggerFactory.getLogger(TaskService.class);

    @Autowired
    private UserService userService;

    @Autowired
    private TaskTaskService tasktaskService;

    @Autowired
    private ScheduleTaskShadeInfoService scheduleTaskShadeInfoService;

    /**
     * ????????????id????????????
     *
     * @param taskId ??????id
     * @return ??????
     */
    public ScheduleTaskShade findTaskByTaskId(Long taskId){
        return taskId != null ? this.lambdaQuery()
                .eq(ScheduleTaskShade::getTaskId, taskId)
                .eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                .one() : null;
    }

    public List<ScheduleTaskShade> findTaskByTaskIds(List<Long> taskIds) {
        if(CollectionUtils.isEmpty(taskIds)){
            return new ArrayList<>();
        }
        return this.lambdaQuery()
                .in(ScheduleTaskShade::getTaskId, taskIds)
                .eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus()).list();
    }

    /**
     * ??????????????????
     *
     * @param taskId ??????id
     * @param name   ????????????
     * @return ??????????????????
     */
    public Boolean updateTaskName(Long taskId, String name) {
        if (taskId==null || StringUtils.isBlank(name)) {
            return Boolean.FALSE;
        }

        ScheduleTaskShade scheduleTaskShade = new ScheduleTaskShade();
        scheduleTaskShade.setName(name);
        return this.lambdaUpdate()
                .eq(ScheduleTaskShade::getTaskId, taskId)
                .eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                .update(scheduleTaskShade);
    }

    /**
     * ????????????
     */
    public Boolean deleteTask(Long taskId, Long modifyUserId) {
        if (taskId == null) {
            return Boolean.FALSE;
        }

        // ??????????????????
        ScheduleTaskShade scheduleTaskShade = new ScheduleTaskShade();
        scheduleTaskShade.setIsDeleted(Deleted.DELETED.getStatus());
        scheduleTaskShade.setModifyUserId(modifyUserId);
        this.lambdaUpdate().eq(ScheduleTaskShade::getTaskId, taskId).update(scheduleTaskShade);

        // ????????????????????????
        return tasktaskService.lambdaUpdate().eq(ScheduleTaskTaskShade::getTaskId, taskId).remove();
    }

    /**
     * ??????????????????????????????
     *
     * @param taskId ??????id
     * @return
     */
    public List<ScheduleTaskShade> listRelyCurrentTask(Long taskId) {
        List<ScheduleTaskTaskShade> scheduleTaskTaskShadeList = tasktaskService.lambdaQuery()
                .eq(ScheduleTaskTaskShade::getParentTaskId, taskId)
                .eq(ScheduleTaskTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                .list();

        if (CollectionUtils.isEmpty(scheduleTaskTaskShadeList)) {
            return Lists.newArrayList();
        }

        List<Long> childTaskIdList = scheduleTaskTaskShadeList.stream().map(ScheduleTaskTaskShade::getTaskId).collect(Collectors.toList());
        return this.lambdaQuery().in(ScheduleTaskShade::getTaskId,childTaskIdList).eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus()).list();
    }

    /**
     * ?????????????????? (??????????????????)
     * @param savaTaskDTO ??????
     * @return ??????????????????
     */
    public Boolean saveTask(SavaTaskDTO savaTaskDTO) {
        ScheduleTaskShade scheduleTaskShade = savaTaskDTO.getScheduleTaskShade();

        ScheduleTaskShade dbTaskShade = this.lambdaQuery()
                .eq(ScheduleTaskShade::getTaskId, scheduleTaskShade.getTaskId())
                .eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                .one();

        ScheduleTaskShadeInfo scheduleTaskShadeInfo = new ScheduleTaskShadeInfo();
        scheduleTaskShadeInfo.setInfo(scheduleTaskShade.getExtraInfo());
        scheduleTaskShadeInfo.setTaskId(scheduleTaskShade.getTaskId());
        // ??????????????????????????????
        if (dbTaskShade != null) {
            scheduleTaskShade.setId(dbTaskShade.getId());
            this.updateById(scheduleTaskShade);
            scheduleTaskShadeInfoService.update(scheduleTaskShadeInfo,scheduleTaskShade.getTaskId());
        } else {
            this.save(scheduleTaskShade);
            scheduleTaskShadeInfoService.insert(scheduleTaskShadeInfo);
        }


        // ????????????
        List<Long> parentTaskIdList = savaTaskDTO.getParentTaskIdList();

        List<ScheduleTaskTaskShade> scheduleTaskTaskShadeList = Lists.newArrayList();
        for (Long parentTaskId : parentTaskIdList) {
            ScheduleTaskTaskShade scheduleTaskTaskShade = new ScheduleTaskTaskShade();

            scheduleTaskTaskShade.setTenantId(scheduleTaskShade.getTenantId());
            scheduleTaskTaskShade.setTaskId(scheduleTaskShade.getTaskId());
            scheduleTaskTaskShade.setParentTaskId(parentTaskId);
            scheduleTaskTaskShadeList.add(scheduleTaskTaskShade);
        }
        // ????????????
        if (checkLoop(scheduleTaskTaskShadeList)) {
            throw new DtCenterDefException(ErrorCode.TASK_DEPENDENCY_IS_LOOP);
        }
        // ??????????????????
        tasktaskService.lambdaUpdate().eq(ScheduleTaskTaskShade::getTaskId, scheduleTaskShade.getTaskId()).remove();
        return tasktaskService.saveBatch(scheduleTaskTaskShadeList);
    }

    private boolean checkLoop(List<ScheduleTaskTaskShade> scheduleTaskTaskShadeList) {
        if (CollectionUtils.isEmpty(scheduleTaskTaskShadeList)) {
            return false;
        }
        Function<List<Long>, List<ScheduleTaskTaskShadeFlatGraphSideAdapterFlat>> parentProvider = taskIds -> {
            List<ScheduleTaskTaskShade> parentScheduleTaskTaskShadeList = tasktaskService.lambdaQuery()
                    .in(ScheduleTaskTaskShade::getTaskId, taskIds)
                    .eq(ScheduleTaskTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                    .list();
            return ScheduleTaskTaskShadeFlatGraphSideAdapterFlat.build(parentScheduleTaskTaskShadeList);
        };

        Function<List<Long>, List<ScheduleTaskTaskShadeFlatGraphSideAdapterFlat>> childProvider = parentIds -> {
            List<ScheduleTaskTaskShade> scheduleTaskTaskShadeList1 = tasktaskService.lambdaQuery()
                    .in(ScheduleTaskTaskShade::getParentTaskId, parentIds)
                    .eq(ScheduleTaskTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                    .list();
            return ScheduleTaskTaskShadeFlatGraphSideAdapterFlat.build(scheduleTaskTaskShadeList1);
        };

        List<ScheduleTaskTaskShadeFlatGraphSideAdapterFlat> adapters = ScheduleTaskTaskShadeFlatGraphSideAdapterFlat.build(scheduleTaskTaskShadeList);

        FlatDirectedGraphLoopJudge<Long, Long, ScheduleTaskTaskShadeFlatGraphSideAdapterFlat> loopJudge
                = new GenericFlatFlatDirectedGraphLoopJudge<>(adapters);

        return loopJudge.isLoop(parentProvider, childProvider);
    }

    /**
     * ??????????????????
     *
     * @param dto ????????????
     * @return
     */
    public PageResult<List<ReturnScheduleTaskVO>> queryTasks(QueryTaskListDTO dto) {
        Page<ScheduleTaskShade> page = new Page<>(dto.getCurrentPage(), dto.getPageSize());
        // ????????????
        Page<ScheduleTaskShade> resultPage = this.lambdaQuery()
                .eq(ScheduleTaskShade::getFlowId,0L)
                .eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                .like(StringUtils.isNotBlank(dto.getName()), ScheduleTaskShade::getName, dto.getName())
                .eq(dto.getOperatorId() != null, ScheduleTaskShade::getCreateUserId, dto.getOperatorId())
                .eq(ScheduleTaskShade::getComputeType, ComputeType.BATCH.getType())
                .eq(dto.getTenantId() != null, ScheduleTaskShade::getTenantId, dto.getTenantId())
                .eq(dto.getScheduleStatus() != null, ScheduleTaskShade::getScheduleStatus, dto.getScheduleStatus())
                .between(dto.getStartModifiedTime() != null && dto.getEndModifiedTime() != null, ScheduleTaskShade::getGmtModified,
                        null == dto.getStartModifiedTime() ? null : new Timestamp(dto.getStartModifiedTime()),
                        null == dto.getEndModifiedTime() ? null : new Timestamp(dto.getEndModifiedTime()))
                .in(CollectionUtils.isNotEmpty(dto.getTaskTypeList()), ScheduleTaskShade::getTaskType, dto.getTaskTypeList())
                .in(CollectionUtils.isNotEmpty(dto.getPeriodTypeList()), ScheduleTaskShade::getPeriodType, dto.getPeriodTypeList())
                .page(page);

        List<ReturnScheduleTaskVO> scheduleTaskVOS = ScheduleTaskMapstructTransfer.INSTANCE.beanToTaskVO(resultPage.getRecords());
        List<Long> userIds = resultPage.getRecords().stream().map(ScheduleTaskShade::getCreateUserId).collect(Collectors.toList());
        Map<Long, User> userMap = userService.getUserMap(userIds);
        scheduleTaskVOS.forEach(vo -> vo.setOperatorName(userMap.get(vo.getOperatorId()) != null ? userMap.get(vo.getOperatorId()).getUserName() : ""));
        return new PageResult<>(dto.getCurrentPage(), dto.getPageSize(), resultPage.getTotal(), (int) resultPage.getPages(), scheduleTaskVOS);
    }

    /**
     * ????????????????????????
     *
     * @param taskIdList ??????id
     * @param scheduleStatus ????????????
     * @return ??????????????????
     */
    public Boolean frozenTask(List<Long> taskIdList, Integer scheduleStatus) {
        if (CollectionUtils.isEmpty(taskIdList)) {
            LOGGER.error("taskIdList is null");
            return Boolean.FALSE;
        }

        if (EScheduleStatus.getStatus(scheduleStatus) == null) {
            LOGGER.error("scheduleStatus is null");
            return Boolean.FALSE;
        }

        ScheduleTaskShade scheduleTask = new ScheduleTaskShade();
        scheduleTask.setScheduleStatus(scheduleStatus);
        return this.lambdaUpdate()
                .in(ScheduleTaskShade::getTaskId,taskIdList)
                .eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                .update(scheduleTask);
    }

    /**
     * ???????????????????????????idc????????????
     *
     * @param taskName ????????????
     * @param ownerId ????????????id
     * @return taskIds
     */
    public List<ScheduleTaskShade> findTaskByTaskName(String taskName, Long tenantId, Long ownerId) {
        if (StringUtils.isBlank(taskName) && ownerId == null) {
            return Lists.newArrayList();
        }
        return this.lambdaQuery()
                .like(StringUtils.isNotBlank(taskName), ScheduleTaskShade::getName, taskName)
                .eq(ownerId != null, ScheduleTaskShade::getCreateUserId, ownerId)
                .eq(tenantId != null, ScheduleTaskShade::getTenantId, tenantId)
                .list();
    }

    /**
     * ?????????????????????????????????
     *
     * @param taskId ??????i
     * @return ??????????????????
     */
    public List<ScheduleTaskShade> findAllFlowTasks(Long taskId) {
        if (taskId == null) {
            return Lists.newArrayList();
        }
        return this.lambdaQuery()
                .eq(ScheduleTaskShade::getIsDeleted,Deleted.NORMAL.getStatus())
                .eq(ScheduleTaskShade::getFlowId,taskId)
                .list();
    }

    /**
     * ????????????????????????
     *
     * @return ????????????
     */
    public List<ReturnTaskSupportTypesVO> querySupportJobTypes() {
        List<ReturnTaskSupportTypesVO> returnTaskSupportTypesVOS = Lists.newArrayList();
        EScheduleJobType[] eScheduleJobTypes = EScheduleJobType.values();

        for (EScheduleJobType eScheduleJobType : eScheduleJobTypes) {
            ReturnTaskSupportTypesVO vo = new ReturnTaskSupportTypesVO();
            vo.setTaskTypeName(eScheduleJobType.getName());
            vo.setTaskTypeCode(eScheduleJobType.getType());
            returnTaskSupportTypesVOS.add(vo);
        }
        return returnTaskSupportTypesVOS;
    }
}
