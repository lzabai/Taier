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

package com.dtstack.taier.develop.service.develop.saver;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.dtstack.taier.common.enums.EComponentType;
import com.dtstack.taier.common.enums.EScheduleJobType;
import com.dtstack.taier.common.enums.EScheduleStatus;
import com.dtstack.taier.common.enums.ESubmitStatus;
import com.dtstack.taier.common.env.EnvironmentContext;
import com.dtstack.taier.common.exception.ErrorCode;
import com.dtstack.taier.common.exception.TaierDefineException;
import com.dtstack.taier.common.util.SqlFormatUtil;
import com.dtstack.taier.dao.domain.DevelopResource;
import com.dtstack.taier.dao.domain.Task;
import com.dtstack.taier.dao.domain.TaskParamTemplate;
import com.dtstack.taier.dao.mapper.DevelopTaskMapper;
import com.dtstack.taier.develop.dto.devlop.TaskResourceParam;
import com.dtstack.taier.develop.dto.devlop.TaskVO;
import com.dtstack.taier.develop.mapstruct.vo.TaskMapstructTransfer;
import com.dtstack.taier.develop.service.develop.ITaskSaver;
import com.dtstack.taier.develop.service.develop.impl.DevelopTaskParamService;
import com.dtstack.taier.develop.service.develop.impl.DevelopTaskService;
import com.dtstack.taier.develop.service.develop.impl.DevelopTaskTaskService;
import com.dtstack.taier.develop.service.task.TaskTemplateService;
import com.dtstack.taier.pluginapi.constrant.ConfigConstant;
import com.dtstack.taier.scheduler.executor.DatasourceOperator;
import com.dtstack.taier.scheduler.service.ClusterService;
import com.dtstack.taier.scheduler.service.ScheduleActionService;
import com.dtstack.taier.scheduler.service.ScheduleDictService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @Author: zhichen
 * @Date: 2022/05/29/4:55 PM
 */
@Component
public abstract class AbstractTaskSaver implements ITaskSaver {

    @Autowired
    EnvironmentContext environmentContext;


    @Autowired
    ClusterService clusterService;

    protected final static String SQL_NOTE_TEMPLATE =
            "-- name %s \n" +
                    "-- type %s \n" +
                    "-- author %s \n" +
                    "-- create time %s \n" +
                    "-- desc %s \n";

    public static final String DEFAULT_SCHEDULE_CONF = "{" +
            "\"selfReliance\":0, " +
            "\"min\":0," +
            "\"hour\":0," +
            "\"periodType\":\"2\"," +
            "\"beginDate\":\"2001-01-01\"," +
            "\"endDate\":\"2121-01-01\"," +
            "\"isFailRetry\":true," +
            "\"maxRetryNum\":\"3\"" +
            "}";



    private static final String ADD_FILE_FORMAT = "ADD JAR WITH %s AS %s;";

    private static final List<Integer> ADD_JAR_JOB_TYPE = Arrays.asList(EScheduleJobType.SPARK.getVal());

    @Autowired
    public DevelopTaskService developTaskService;

    @Autowired
    public DevelopTaskMapper developTaskMapper;

    @Autowired
    public DevelopTaskParamService developTaskParamService;

    @Autowired
    private ScheduleActionService actionService;

    @Autowired
    public TaskTemplateService taskTemplateService;

    @Autowired
    private DevelopTaskTaskService developTaskTaskService;

    @Autowired
    private DatasourceOperator datasourceOperator;

    @Autowired
    private ScheduleDictService scheduleDictService;

    public abstract TaskResourceParam beforeProcessing(TaskResourceParam taskResourceParam);

    public void afterProcessing(TaskResourceParam taskResourceParam, TaskVO taskVO){

    }


    /**
     * ????????????????????????
     *
     * @param taskResourceParam
     * @return
     */
    @Override
    public TaskVO addOrUpdate(TaskResourceParam taskResourceParam) {

        beforeProcessing(taskResourceParam);

        TaskVO taskVO = updateTaskInfo(taskResourceParam);

        updateTaskTask(taskVO,taskResourceParam);

        afterProcessing(taskResourceParam, taskVO);

        return taskVO;
    }

    private void updateTaskTask(TaskVO task,TaskResourceParam taskResourceParam) {
        // ????????????????????????????????????????????????????????????????????????????????????
        if (BooleanUtils.isTrue(taskResourceParam.getEditBaseInfo())) {
            return;
        }
        developTaskTaskService.addOrUpdateTaskTask(task.getId(), task.getDependencyTasks());
    }

    @Override
    public String processScheduleRunSqlText(Task task) {
        return SqlFormatUtil.formatSql(task.getSqlText());
    }

    /**
     * ??????????????????
     *
     * @param taskResourceParam
     * @return
     */
    public TaskVO updateTaskInfo(TaskResourceParam taskResourceParam) {
        TaskVO taskVO = TaskMapstructTransfer.INSTANCE.TaskResourceParamToTaskVO(taskResourceParam);
        taskVO.setModifyUserId(taskResourceParam.getUserId());
        taskVO.setDatasourceId(taskResourceParam.getDatasourceId());
        if (StringUtils.isBlank(taskVO.getName())) {
            throw new TaierDefineException("??????????????????", ErrorCode.INVALID_PARAMETERS);
        }
        taskVO.setGmtModified(Timestamp.valueOf(LocalDateTime.now()));

        Task task = developTaskService.getOne(Wrappers.lambdaQuery(Task.class)
                .eq(Task::getName, taskVO.getName())
                .eq(Task::getTenantId, taskVO.getTenantId()));

        if (taskVO.getId() != null && taskVO.getId() > 0) {
            //update
            if (Objects.nonNull(task)
                    && task.getName().equals(taskVO.getName())
                    && !task.getId().equals(taskVO.getId())) {
                throw new TaierDefineException(ErrorCode.NAME_ALREADY_EXIST);
            }
            developTaskParamService.checkParams(taskVO.getSqlText(), taskVO.getTaskVariables());
            updateTask(taskVO);

        } else {
            if (Objects.nonNull(task)) {
                throw new TaierDefineException(ErrorCode.NAME_ALREADY_EXIST);
            }
            addTask(taskVO);
        }
        developTaskParamService.addOrUpdateTaskParam(taskVO.getTaskVariables(), taskVO.getId());

        return taskVO;
    }

    private void updateTask(TaskVO taskVO) {
        Task specialTask = developTaskService.getOne(taskVO.getId());
        if (specialTask == null) {
            throw new TaierDefineException(ErrorCode.CAN_NOT_FIND_TASK);
        }
        Task specialTask1 = new Task();
        // ??????????????????
        if (!Objects.equals(EScheduleJobType.WORK_FLOW.getVal(), taskVO.getTaskType())) {
            if (StringUtils.isNotBlank(specialTask.getComponentVersion()) && !specialTask.getComponentVersion().equals(taskVO.getComponentVersion())) {
                taskVO.setTaskParams(getTaskParamByTask(taskVO));
            }


            TaskMapstructTransfer.INSTANCE.taskVOTOTask(taskVO, specialTask1);
            developTaskService.updateById(specialTask1);
        } else {
            TaskMapstructTransfer.INSTANCE.taskVOTOTask(taskVO, specialTask1);
            specialTask1.setSqlText(String.valueOf(JSONObject.toJSON(taskVO.getNodeMap())));
            developTaskService.updateById(specialTask1);
        }


        if (EScheduleJobType.WORK_FLOW.getVal().equals(specialTask.getTaskType())) {
            // ??????????????????????????????
            if (MapUtils.isNotEmpty(taskVO.getNodeMap())) {
                taskVO.setSqlText(String.valueOf(JSONObject.toJSON(taskVO.getNodeMap())));
                checkIsLoopByList(taskVO.getNodeMap());
            }
            for (Map.Entry<Long, List<Long>> entry : taskVO.getNodeMap().entrySet()) {
                List<TaskVO> dependencyTasks = getTaskByIds(entry.getValue());
                developTaskTaskService.addOrUpdateTaskTask(entry.getKey(), dependencyTasks);
            }


            List<Task> childrenTaskByFlowId = developTaskService.getFlowWorkSubTasks(specialTask.getId());
            if (CollectionUtils.isNotEmpty(childrenTaskByFlowId)) {
                developTaskService.updateSubTaskScheduleConf(taskVO.getId(), JSONObject.parseObject(taskVO.getScheduleConf()));
            }

            //????????????????????????????????????????????????
            if (!taskVO.getNodePid().equals(specialTask.getNodePid())) {
                developTaskService.updateSonTaskNodePidByFlowId(taskVO.getId(), taskVO.getNodePid());
            }
        }

    }


    /**
     * ??????????????????
     *
     * @param nodeMap ????????????????????????  key?????????  value ????????????????????????
     * @return
     */
    public void checkIsLoopByList(Map<Long, List<Long>> nodeMap) {
        if (MapUtils.isEmpty(nodeMap)) {
            return;
        }
        for (Map.Entry<Long, List<Long>> entry : nodeMap.entrySet()) {
            mapDfs(entry.getKey(), new HashSet(), nodeMap);
        }
    }

    /**
     * ???????????????
     *
     * @param taskId  ??????ID
     * @param set     ????????????????????????
     * @param nodeMap ????????????????????????  key?????????  value ????????????????????????
     */
    private void mapDfs(Long taskId, HashSet<Long> set, Map<Long, List<Long>> nodeMap) {
        HashSet<Long> node = new HashSet<>(set);
        // ?????????????????????????????????????????????????????????????????????
        if (set.contains(taskId)) {
            Task task = developTaskMapper.selectById(taskId);
            if (Objects.nonNull(task)) {
                throw new TaierDefineException(String.format("%s????????????????????????", task.getName()));
            }
        }
        node.add(taskId);
        for (Long j : nodeMap.get(taskId)) {
            mapDfs(j, node, nodeMap);
        }
    }

    /**
     * ????????????
     *
     * @param task ????????????
     */
    private void addTask(TaskVO task) {
        task.setJobId(actionService.generateUniqueSign());
        task.setGmtCreate(Timestamp.valueOf(LocalDateTime.now()));
        if (StringUtils.isBlank(task.getTaskParams())) {
            task.setTaskParams(getTaskParamByTask(task));
        }
        task.setScheduleStatus(EScheduleStatus.NORMAL.getVal());
        task.setScheduleConf(task.getScheduleConf());
        task.setSqlText(Objects.isNull(task.getSqlText()) ? "" : task.getSqlText());
        task.setVersion(Objects.isNull(task.getVersion()) ? 0 : task.getVersion());
        task.setMainClass(Objects.isNull(task.getMainClass()) ? "" : task.getMainClass());
        task.setTaskDesc(Objects.isNull(task.getTaskDesc()) ? "" : task.getTaskDesc());
        task.setSubmitStatus(ESubmitStatus.UNSUBMIT.getStatus());
        task.setCreateUserId(task.getModifyUserId());
        task.setScheduleConf(StringUtils.isBlank(task.getScheduleConf()) ? AbstractTaskSaver.DEFAULT_SCHEDULE_CONF : task.getScheduleConf());
        developTaskService.save(task);
    }

    private String getTaskParamByTask(TaskVO task) {
        String versionName = scheduleDictService.convertVersionNameToValue(task.getComponentVersion(), task.getTaskType(), null);
        TaskParamTemplate taskTemplate = taskTemplateService.getTaskTemplate(task.getTaskType(), versionName);
        return taskTemplate == null ? "" : taskTemplate.getParams();
    }

    public List<TaskVO> getTaskByIds(List<Long> taskIdArray) {
        if (CollectionUtils.isEmpty(taskIdArray)) {
            return Collections.EMPTY_LIST;
        }
        List<Task> tasks = developTaskMapper.selectList(
                Wrappers.lambdaQuery(Task.class).in(Task::getId, taskIdArray));
        ArrayList<TaskVO> taskVOS = new ArrayList<>();
        if (CollectionUtils.isNotEmpty(tasks)) {
            tasks.stream().forEach(x -> {
                TaskVO taskVO = new TaskVO();
                BeanUtils.copyProperties(x, taskVO);
                taskVOS.add(taskVO);
            });
        }
        return taskVOS;
    }



    protected String getAddJarSql(Integer taskType, String mainClass, List<DevelopResource> resourceList, String sql) {
        if (EScheduleJobType.SPARK.getVal().equals(taskType)) {
            if (resourceList.size() != 1) {
                //?????????????????????????????????
                throw new TaierDefineException("spark task ref resource size must be one");
            }
        }
        if (ADD_JAR_JOB_TYPE.contains(taskType)) {
            if (CollectionUtils.isNotEmpty(resourceList)) {
                String url = resourceList.get(0).getUrl();
                return formatAddJarSQL(url, mainClass);
            }
        } else if (taskType.equals(EScheduleJobType.SYNC.getVal())) {
            return "";
        }
        return sql;
    }


    protected String formatAddJarSQL(String url, String mainClass) {
        return String.format(ADD_FILE_FORMAT, url, mainClass);
    }


    protected String uploadSqlText(Long tenantId, String content, Integer taskType, String taskName) {
        String fileName = null;

        if (taskType.equals(EScheduleJobType.SPARK_PYTHON.getVal())) {
            fileName = String.format("pyspark_%s_%s_%s.py", tenantId, taskName, System.currentTimeMillis());
        }

        if (org.apache.commons.lang3.StringUtils.isBlank(fileName)) {
            return "";
        }
        JSONObject hdfsConf = clusterService.getConfigByKey(tenantId, EComponentType.HDFS.getConfName(), null);
        String hdfsURI = hdfsConf.getString(ConfigConstant.FS_DEFAULT);
        String hdfsPath = environmentContext.getHdfsTaskPath() + fileName;
        datasourceOperator.uploadInputStreamToHdfs(hdfsConf, tenantId, content.getBytes(), hdfsPath);
        return hdfsURI + hdfsPath;
    }
}
