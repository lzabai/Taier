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

package com.dtstack.taier.develop.controller.operation;

import com.dtstack.taier.common.exception.TaierDefineException;
import com.dtstack.taier.common.lang.web.R;
import com.dtstack.taier.dao.domain.ScheduleJob;
import com.dtstack.taier.develop.mapstruct.job.ActionMapStructTransfer;
import com.dtstack.taier.develop.service.schedule.ActionService;
import com.dtstack.taier.develop.service.schedule.JobService;
import com.dtstack.taier.develop.vo.schedule.ActionJobKillVO;
import com.dtstack.taier.develop.vo.schedule.QueryJobLogVO;
import com.dtstack.taier.develop.vo.schedule.ReturnJobLogVO;
import com.dtstack.taier.pluginapi.enums.TaskStatus;
import com.dtstack.taier.scheduler.enums.RestartType;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.util.List;

/**
 * @Auther: dazhi
 * @Date: 2021/12/6 10:52 AM
 * @Email:dazhi@dtstack.com
 * @Description:
 */
@RestController
@RequestMapping("/action")
@Api(value = "/action", tags = {"????????????---????????????????????????"})
public class OperationActionController {

    private static final Logger LOGGER = LoggerFactory.getLogger(OperationActionController.class);

    @Autowired
    private JobService jobService;

    @Autowired
    private ActionService actionService;

    @ApiOperation(value = "????????????")
    @PostMapping(value = "/restartJob")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "jobIds", value = "???????????????id", required = true, dataType = "array"),
            @ApiImplicitParam(name = "restartType", value = "??????????????????: RESTART_CURRENT_NODE(0)\n??????????????????: RESTART_CURRENT_AND_DOWNSTREAM_NODE(1)\n????????????????????????:SET_SUCCESSFULLY_AND_RESUME_SCHEDULING(2)\n", required = true, dataType = "Integer")
    })
    public R<Boolean> restartJob(@RequestParam("jobIds") List<String> jobIds,
                                 @RequestParam("restartType") Integer restartType) {
        RestartType byCode = RestartType.getByCode(restartType);

        if (byCode == null) {
            throw new TaierDefineException("??????????????????????????????");
        }

        return R.ok(actionService.restartJob(byCode, jobIds));
    }

    @ApiOperation(value = "??????????????????")
    @PostMapping(value = "/batchStopJobs")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "jobIds", value = "???????????????id", required = true, dataType = "array")
    })
    public R<Integer> batchStopJobs(@RequestParam("jobIds") List<String> jobIds) {
        return R.ok(actionService.batchStopJobs(jobIds));
    }

    @ApiOperation(value = "???????????????????????????")
    @RequestMapping(value = "/stopFillDataJobs", method = {RequestMethod.POST})
    @ApiImplicitParams({
            @ApiImplicitParam(name = "fillId", value = "???????????????id", required = true, dataType = "array")
    })
    public R<Integer> stopFillDataJobs(@RequestParam("fillId") Long fillId) {
        return R.ok(actionService.stopFillDataJobs(fillId));
    }

    @ApiOperation(value = "????????????????????????")
    @RequestMapping(value = "/stopJobByCondition", method = {RequestMethod.POST})
    public R<Integer> stopJobByCondition(@RequestBody ActionJobKillVO vo) {
        return R.ok(actionService.stopJobByCondition(ActionMapStructTransfer.INSTANCE.actionJobKillVOToActionJobKillDTO(vo)));
    }

    @ApiOperation(value = "??????????????????")
    @PostMapping(value = "/queryJobLog")
    public R<ReturnJobLogVO> queryJobLog(@RequestBody @Valid QueryJobLogVO vo, BindingResult bindingResult) {
        return R.ok(actionService.queryJobLog(vo.getJobId(), vo.getPageInfo()));
    }

    @ApiOperation(value = "??????????????????")
    @PostMapping(value = "/status")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "jobId", value = "??????id", required = true, dataType = "String")
    })
    public R<Integer> status(@RequestParam("jobId") String jobId) throws Exception {
        ScheduleJob scheduleJob = jobService.getScheduleJob(jobId);
        return R.ok(null == scheduleJob ? TaskStatus.NOTFOUND.getStatus() : scheduleJob.getStatus());
    }
}
