package com.dtstack.taier.develop.service.develop.task;

import com.dtstack.taier.common.enums.EScheduleJobType;
import com.dtstack.taier.common.enums.ResourceRefType;
import com.dtstack.taier.common.enums.TaskTemplateType;
import com.dtstack.taier.develop.dto.devlop.TaskResourceParam;
import com.dtstack.taier.develop.dto.devlop.TaskVO;
import com.dtstack.taier.develop.service.develop.impl.DevelopTaskResourceService;
import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: zhichen
 * @Date: 2022/05/29/5:14 PM
 */
@Component
public class DevelopFlinkTask extends DevelopTaskTemplate {

    @Autowired
    private DevelopTaskResourceService developTaskResourceService;

    public static Logger LOGGER = LoggerFactory.getLogger(DevelopFlinkTask.class);


    @Override
    public TaskResourceParam beforeProcessing(TaskResourceParam taskResourceParam) {
        taskResourceParam.setTaskParams(taskResourceParam.getTaskParams() == null ? taskTemplateService.getTaskTemplate(TaskTemplateType.TASK_PARAMS.getType(), taskResourceParam.getTaskType(), taskResourceParam.getComponentVersion()).getContent() : taskResourceParam.getTaskParams());
        return taskResourceParam;
    }

    @Override
    public void afterProcessing(TaskResourceParam taskResourceParam, TaskVO taskVO) {
        if (CollectionUtils.isEmpty(taskResourceParam.getResourceIdList())) {
            return;
        }
        developTaskResourceService.save(taskVO, taskResourceParam.getResourceIdList(), ResourceRefType.MAIN_RES.getType());
    }




    @Override
    public EScheduleJobType getEScheduleJobType() {
        return EScheduleJobType.MR;
    }


}