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

package com.dtstack.taier.develop.controller.develop;

import com.alibaba.fastjson.JSONObject;
import com.dtstack.taier.common.enums.EScheduleStatus;
import com.dtstack.taier.common.exception.ErrorCode;
import com.dtstack.taier.common.exception.TaierDefineException;
import com.dtstack.taier.common.lang.coc.APITemplate;
import com.dtstack.taier.common.lang.web.R;
import com.dtstack.taier.dao.domain.ScheduleTaskShade;
import com.dtstack.taier.develop.dto.devlop.TaskResourceParam;
import com.dtstack.taier.develop.dto.devlop.TaskVO;
import com.dtstack.taier.develop.mapstruct.vo.TaskMapstructTransfer;
import com.dtstack.taier.develop.service.develop.impl.DevelopTaskService;
import com.dtstack.taier.develop.vo.develop.query.AllProductGlobalSearchVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopDataSourceIncreColumnVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopFrozenTaskVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopScheduleTaskVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskCheckIsLoopVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskCheckNameVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskDeleteTaskVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskEditVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskGetByNameVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskGetChildTasksVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskGetComponentVersionVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskGetSupportJobTypesVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskNameCheckVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskParsingFTPFileParamVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskPublishTaskVO;
import com.dtstack.taier.develop.vo.develop.query.DevelopTaskResourceParamVO;
import com.dtstack.taier.develop.vo.develop.result.DevelopAllProductGlobalReturnVO;
import com.dtstack.taier.develop.vo.develop.result.DevelopGetChildTasksResultVO;
import com.dtstack.taier.develop.vo.develop.result.DevelopSysParameterResultVO;
import com.dtstack.taier.develop.vo.develop.result.DevelopTaskGetComponentVersionResultVO;
import com.dtstack.taier.develop.vo.develop.result.DevelopTaskGetTaskByIdResultVO;
import com.dtstack.taier.develop.vo.develop.result.DevelopTaskPublishTaskResultVO;
import com.dtstack.taier.develop.vo.develop.result.DevelopTaskResultVO;
import com.dtstack.taier.develop.vo.develop.result.DevelopTaskTypeVO;
import com.dtstack.taier.develop.vo.develop.result.ParsingFTPFileVO;
import com.dtstack.taier.develop.vo.develop.result.TaskCatalogueResultVO;
import com.dtstack.taier.scheduler.service.ScheduleTaskShadeService;
import com.google.common.base.Preconditions;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Api(value = "????????????", tags = {"????????????"})
@RestController
@RequestMapping(value = "/task")
public class DevelopTaskController {

    @Autowired
    private DevelopTaskService developTaskService;

    @Autowired
    private ScheduleTaskShadeService scheduleTaskShadeService;

    @PostMapping(value = "getTaskById")
    @ApiOperation("????????????-????????????id???????????????")
    public R<DevelopTaskGetTaskByIdResultVO> getTaskById(@RequestBody DevelopScheduleTaskVO developScheduleTaskVO) {
        return new APITemplate<DevelopTaskGetTaskByIdResultVO>() {
            @Override
            protected DevelopTaskGetTaskByIdResultVO process() {
                TaskVO taskById = developTaskService.getTaskById(TaskMapstructTransfer.INSTANCE.DevelopScheduleTaskVToTaskVO(developScheduleTaskVO));
                return TaskMapstructTransfer.INSTANCE.TaskVOToDevelopTaskGetTaskByIdResultVO(taskById);
            }
        }.execute();
    }

    @PostMapping(value = "checkIsLoop")
    @ApiOperation("??????task????????????task????????????????????????")
    public R<DevelopTaskResultVO> checkIsLoop(@RequestBody DevelopTaskCheckIsLoopVO infoVO) {
        return new APITemplate<DevelopTaskResultVO>() {
            @Override
            protected DevelopTaskResultVO process() {
                return TaskMapstructTransfer.INSTANCE.DevelopTaskToResultVO(developTaskService.checkIsLoop(infoVO.getTaskId(), infoVO.getDependencyTaskId()));
            }
        }.execute();
    }

    @PostMapping(value = "publishTask")
    @ApiOperation("????????????")
    public R<DevelopTaskPublishTaskResultVO> publishTask(@RequestBody DevelopTaskPublishTaskVO detailVO) {
        return new APITemplate<DevelopTaskPublishTaskResultVO>() {
            @Override
            protected DevelopTaskPublishTaskResultVO process() {
                return TaskMapstructTransfer.INSTANCE.TaskCheckResultVOToDevelopTaskPublishTaskResultVO(developTaskService.publishTask(detailVO.getId(),
                        detailVO.getUserId()));
            }
        }.execute();
    }


    @PostMapping(value = "addOrUpdateTask")
    @ApiOperation("????????????-??????/?????? ??????")
    public R<TaskCatalogueResultVO> addOrUpdateTask(@RequestBody DevelopTaskResourceParamVO paramVO) {
        return new APITemplate<TaskCatalogueResultVO>() {
            @Override
            protected TaskCatalogueResultVO process() {
                TaskResourceParam taskResourceParam = TaskMapstructTransfer.INSTANCE.TaskResourceParamVOToTaskResourceParam(paramVO);
                return TaskMapstructTransfer.INSTANCE.TaskVOToResultVO(developTaskService.addOrUpdateTask(taskResourceParam));
            }
        }.execute();
    }

    @PostMapping(value = "guideToTemplate")
    @ApiOperation("?????????????????????")
    public R<TaskCatalogueResultVO> guideToTemplate(@RequestBody DevelopTaskResourceParamVO paramVO) {
        return new APITemplate<TaskCatalogueResultVO>() {
            @Override
            protected TaskCatalogueResultVO process() {
                TaskResourceParam taskResourceParam = TaskMapstructTransfer.INSTANCE.TaskResourceParamVOToTaskResourceParam(paramVO);
                return TaskMapstructTransfer.INSTANCE.TaskCatalogueVOToResultVO(developTaskService.guideToTemplate(taskResourceParam));
            }
        }.execute();
    }

    @PostMapping(value = "getChildTasks")
    @ApiOperation("???????????????")
    public R<List<DevelopGetChildTasksResultVO>> getChildTasks(@RequestBody DevelopTaskGetChildTasksVO tasksVO) {
        return new APITemplate<List<DevelopGetChildTasksResultVO>>() {
            @Override
            protected List<DevelopGetChildTasksResultVO> process() {
                return TaskMapstructTransfer.INSTANCE.notDeleteTaskVOsToDevelopGetChildTasksResultVOs(developTaskService.getChildTasks(tasksVO.getTaskId()));
            }
        }.execute();
    }

    @PostMapping(value = "deleteTask")
    @ApiOperation("????????????")
    public R<Long> deleteTask(@RequestBody DevelopTaskDeleteTaskVO detailVO) {
        return new APITemplate<Long>() {
            @Override
            protected Long process() {
                return developTaskService.deleteTask(detailVO.getTaskId(), detailVO.getUserId());
            }
        }.execute();
    }

    @PostMapping(value = "getSysParams")
    @ApiOperation("????????????????????????")
    public R<Collection<DevelopSysParameterResultVO>> getSysParams() {
        return new APITemplate<Collection<DevelopSysParameterResultVO>>() {
            @Override
            protected Collection<DevelopSysParameterResultVO> process() {
                return TaskMapstructTransfer.INSTANCE.DevelopSysParameterCollectionToDevelopSysParameterResultVOCollection(developTaskService.getSysParams());
            }
        }.execute();
    }

    @PostMapping(value = "checkName")
    @ApiOperation("??????????????????/??????/??????/??????????????????????????????")
    public R<Void> checkName(@RequestBody DevelopTaskCheckNameVO detailVO) {
        return new APITemplate<Void>() {
            @Override
            protected Void process() {
                developTaskService.checkName(detailVO.getName(), detailVO.getType(), detailVO.getPid(), detailVO.getIsFile(), detailVO.getTenantId());
                return null;
            }
        }.execute();
    }

    @PostMapping(value = "getByName")
    @ApiOperation("????????????????????????")
    public R<DevelopTaskResultVO> getByName(@RequestBody DevelopTaskGetByNameVO detailVO) {
        return new APITemplate<DevelopTaskResultVO>() {
            @Override
            protected DevelopTaskResultVO process() {
                return TaskMapstructTransfer.INSTANCE.DevelopTaskToResultVO(developTaskService.getByName(detailVO.getName(), detailVO.getTenantId()));
            }
        }.execute();
    }

    @PostMapping(value = "getComponentVersionByTaskType")
    @ApiOperation("?????????????????????")
    public R<List<DevelopTaskGetComponentVersionResultVO>> getComponentVersionByTaskType(@RequestBody DevelopTaskGetComponentVersionVO getComponentVersionVO) {
        return new APITemplate<List<DevelopTaskGetComponentVersionResultVO>>() {
            @Override
            protected List<DevelopTaskGetComponentVersionResultVO> process() {
                return developTaskService.getComponentVersionByTaskType(getComponentVersionVO.getTenantId(), getComponentVersionVO.getTaskType());
            }
        }.execute();
    }

    @PostMapping(value = "allProductGlobalSearch")
    @ApiOperation("????????????????????????????????????")
    public R<List<DevelopAllProductGlobalReturnVO>> allProductGlobalSearch(@RequestBody AllProductGlobalSearchVO allProductGlobalSearchVO) {
        return new APITemplate<List<DevelopAllProductGlobalReturnVO>>() {
            @Override
            protected List<DevelopAllProductGlobalReturnVO> process() {
                return developTaskService.allProductGlobalSearch(allProductGlobalSearchVO);
            }
        }.execute();
    }

    @PostMapping(value = "frozenTask")
    @ApiOperation("????????????????????????????????????")
    public R<Boolean> frozenTask(@RequestBody DevelopFrozenTaskVO vo) {
        return new APITemplate<Boolean>() {
            @Override
            protected void checkParams() throws IllegalArgumentException {
                EScheduleStatus targetStatus = EScheduleStatus.getStatus(vo.getScheduleStatus());
                if (Objects.isNull(targetStatus)) {
                    throw new TaierDefineException(ErrorCode.INVALID_PARAMETERS);
                }
                if (CollectionUtils.isEmpty(vo.getTaskIds())) {
                    throw new TaierDefineException(ErrorCode.CAN_NOT_FIND_TASK);
                }
            }

            @Override
            protected Boolean process() {
                developTaskService.frozenTask(vo.getTaskIds(), vo.getScheduleStatus(), vo.getUserId());
                return true;
            }
        }.execute();
    }

    @PostMapping(value = "getSupportJobTypes")
    @ApiOperation("?????????????????????????????????")
    public R<List<DevelopTaskTypeVO>> getSupportJobTypes(@RequestBody(required = false) DevelopTaskGetSupportJobTypesVO detailVO) {
        return new APITemplate<List<DevelopTaskTypeVO>>() {
            @Override
            protected List<DevelopTaskTypeVO>  process() {
                return developTaskService.getSupportJobTypes(detailVO.getTenantId());
            }
        }.execute();
    }

    @PostMapping(value = "getIncreColumn")
    @ApiOperation(value = "???????????????????????????????????????")
    public R<List<JSONObject>> getIncreColumn(@RequestBody(required = false) DevelopDataSourceIncreColumnVO vo) {
        return new APITemplate<List<JSONObject>>() {
            @Override
            protected List<JSONObject> process() {
                return developTaskService.getIncreColumn(vo.getSourceId(), vo.getTableName(), vo.getSchema());
            }
        }.execute();
    }

    @PostMapping(value = "editTask")
    @ApiOperation(value = "????????????")
    public R<Void> editTask(@RequestBody DevelopTaskEditVO vo) {
        return new APITemplate<Void>() {
            @Override
            protected void checkParams() throws IllegalArgumentException {
                Preconditions.checkNotNull(vo.getTaskId(), "parameters of taskId not be null.");
                Preconditions.checkNotNull(vo.getName(), "parameters of name not be null.");
                Preconditions.checkNotNull(vo.getCatalogueId(), "parameters of catalogueId not be null.");
            }

            @Override
            protected Void process() {
                developTaskService.editTask(vo.getTaskId(), vo.getName(), vo.getCatalogueId(), vo.getDesc(),
                        vo.getTenantId(), vo.getComponentVersion());
                return null;
            }
        }.execute();
    }

    @PostMapping(value = "checkTaskNameRepeat")
    @ApiOperation("????????????-??????????????????????????????")
    public R<Boolean> checkTaskNameRepeat(@RequestBody DevelopTaskNameCheckVO vo) {
        return new APITemplate<Boolean>() {
            @Override
            protected Boolean process() {
                return developTaskService.checkTaskNameRepeat(vo.getTaskName(), vo.getTenantId());
            }
        }.execute();
    }

    @PostMapping(value = "getFlowWorkSubTasks")
    @ApiOperation("????????????-????????????????????????????????????")
    public R<List<ScheduleTaskShade>> getFlowWorkSubTasks(@RequestBody DevelopScheduleTaskVO vo) {
        return new APITemplate<List<ScheduleTaskShade>>() {
            @Override
            protected List<ScheduleTaskShade> process() {
                return scheduleTaskShadeService.getFlowWorkSubTasks(vo.getTaskId());
            }
        }.execute();
    }


    @PostMapping(value = "getSyncProperties")
    @ApiOperation("????????????-??????????????????????????????")
    public R<JSONObject> getSyncProperties() {
        return R.ok(developTaskService.getSyncProperties());
    }

    @PostMapping(value = "/parsing_ftp_columns")
    @ApiOperation("????????????-??????ftp??????????????????")
    public R<ParsingFTPFileVO> parsingFtpTaskFile(@RequestBody DevelopTaskParsingFTPFileParamVO payload) throws IOException {
        return R.ok(developTaskService.parsingFtpTaskFile(payload));
    }

}
