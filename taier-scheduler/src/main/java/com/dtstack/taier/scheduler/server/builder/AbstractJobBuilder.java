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

package com.dtstack.taier.scheduler.server.builder;

import com.dtstack.taier.common.enums.EScheduleJobType;
import com.dtstack.taier.common.enums.Deleted;
import com.dtstack.taier.common.enums.Restarted;
import com.dtstack.taier.common.env.EnvironmentContext;
import com.dtstack.taier.common.exception.TaierDefineException;
import com.dtstack.taier.dao.domain.ScheduleJob;
import com.dtstack.taier.dao.domain.ScheduleJobJob;
import com.dtstack.taier.dao.domain.ScheduleTaskShade;
import com.dtstack.taier.pluginapi.CustomThreadFactory;
import com.dtstack.taier.pluginapi.enums.TaskStatus;
import com.dtstack.taier.pluginapi.util.DateUtil;
import com.dtstack.taier.scheduler.server.ScheduleJobDetails;
import com.dtstack.taier.scheduler.server.builder.cron.ScheduleConfManager;
import com.dtstack.taier.scheduler.server.builder.cron.ScheduleCorn;
import com.dtstack.taier.scheduler.server.builder.dependency.JobDependency;
import com.dtstack.taier.scheduler.server.builder.dependency.DependencyManager;
import com.dtstack.taier.scheduler.service.ScheduleActionService;
import com.dtstack.taier.scheduler.service.ScheduleJobService;
import com.dtstack.taier.scheduler.service.ScheduleTaskShadeService;
import com.dtstack.taier.scheduler.utils.JobExecuteOrderUtil;
import com.dtstack.taier.scheduler.utils.JobKeyUtils;
import com.google.common.collect.Lists;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * @Auther: dazhi
 * @Date: 2021/12/30 3:11 PM
 * @Email:dazhi@dtstack.com
 * @Description:
 */
public abstract class AbstractJobBuilder implements JobBuilder, InitializingBean {

    protected static final String NORMAL_TASK_FLOW_ID = "0";

    protected ExecutorService jobGraphBuildPool;

    @Autowired
    protected ScheduleJobService scheduleJobService;

    @Autowired
    protected DependencyManager dependencyManager;

    @Autowired
    protected ScheduleTaskShadeService scheduleTaskService;

    @Autowired
    protected EnvironmentContext environmentContext;

    @Autowired
    protected ScheduleActionService actionService;

    private static final Logger LOGGER = LoggerFactory.getLogger(AbstractJobBuilder.class);

    @Override
    public List<ScheduleJobDetails> buildJob(ScheduleTaskShade scheduleTaskShade,
                                             String name,
                                             String triggerDay,
                                             String beginTime,
                                             String endTime,
                                             Long fillId,
                                             JobSortWorker jobSortWorker) throws Exception {

        // ??????????????????
        ScheduleCorn corn = ScheduleConfManager.parseFromJson(scheduleTaskShade.getScheduleConf());
        ScheduleConf scheduleConf = corn.getScheduleConf();

        // ??????????????????????????????????????????????????????
        Pair<Date, Date> triggerRange = getTriggerRange(triggerDay, beginTime, endTime);

        // ?????????????????????????????????
        Date startDate = getStartData(scheduleConf, triggerRange, scheduleTaskShade.getTaskId());
        Date endDate = getEndDate(scheduleConf, triggerRange, scheduleTaskShade.getTaskId());

        List<ScheduleJobDetails> jobBuilderBeanList = Lists.newArrayList();

        Date next = corn.isMatch(startDate) ? startDate : corn.next(startDate);
        while (next != null) {
            // ???????????????????????????????????????????????????????????????????????????
            if (next.after(endDate)) {
                break;
            }
            ScheduleJobDetails jobBuilderBean = buildJobBuilderBean(scheduleTaskShade, name, fillId, jobSortWorker, corn, scheduleConf, next, NORMAL_TASK_FLOW_ID);

            if (EScheduleJobType.WORK_FLOW.getVal().equals(scheduleTaskShade.getTaskType())) {
                // ??????????????????????????? ??????????????????
                List<ScheduleTaskShade> subTasks = scheduleTaskService.lambdaQuery()
                        .eq(ScheduleTaskShade::getFlowId, scheduleTaskShade.getTaskId())
                        .eq(ScheduleTaskShade::getIsDeleted, Deleted.NORMAL.getStatus())
                        .list();
                List<ScheduleJobDetails> flowBean = Lists.newArrayList();
                ScheduleJob scheduleJob = jobBuilderBean.getScheduleJob();
                for (ScheduleTaskShade subTask : subTasks) {
                    flowBean.add(buildJobBuilderBean(subTask, name, fillId, jobSortWorker, corn, scheduleConf, next, scheduleJob.getJobId()));
                }
                jobBuilderBean.setFlowBean(flowBean);
            }


            jobBuilderBeanList.add(jobBuilderBean);
            next = corn.next(next);
        }
        return jobBuilderBeanList;
    }

    /**
     * ??????????????????bean??????
     *
     * @param batchTaskShade ??????
     * @param triggerDay     ?????????
     * @param sortWorker     ?????????
     */
    public List<ScheduleJobDetails> buildJob(ScheduleTaskShade batchTaskShade, String triggerDay, AtomicJobSortWorker sortWorker) throws Exception {
        return buildJob(batchTaskShade, "", triggerDay, "00:00", "23:59", 0L, sortWorker);
    }

    /**
     * ??????????????????
     *
     * @param scheduleTaskShade ??????
     * @param name              ????????????
     * @return ??????
     */
    private String getName(ScheduleTaskShade scheduleTaskShade, String name, String cycTime) {
        return getPrefix() + "_" + name + "_" + scheduleTaskShade.getName() + "_" + cycTime;
    }

    /**
     * ??????JobBuilderBean
     *
     * @param scheduleTaskShade ????????????????????????
     * @param name              ????????????
     * @param fillId            ?????????id
     * @param jobSortWorker     ?????????
     * @param corn              ????????????
     * @param scheduleConf      ????????????
     * @param currentData       ????????????
     * @return
     */
    private ScheduleJobDetails buildJobBuilderBean(ScheduleTaskShade scheduleTaskShade,
                                                   String name,
                                                   Long fillId,
                                                   JobSortWorker jobSortWorker,
                                                   ScheduleCorn corn,
                                                   ScheduleConf scheduleConf,
                                                   Date currentData,
                                                   String flowJobId) {
        String triggerTime = DateUtil.getDate(currentData, DateUtil.STANDARD_DATETIME_FORMAT);
        String cycTime = DateUtil.getTimeStrWithoutSymbol(triggerTime);
        String jobKey = JobKeyUtils.generateJobKey(getKeyPreStr(name), scheduleTaskShade.getTaskId(), cycTime);


        // ??????
        ScheduleJob scheduleJob = new ScheduleJob();
        scheduleJob.setTenantId(scheduleTaskShade.getTenantId());
        scheduleJob.setJobId(actionService.generateUniqueSign());
        scheduleJob.setJobKey(jobKey);
        scheduleJob.setJobName(getName(scheduleTaskShade, name, cycTime));
        scheduleJob.setTaskId(scheduleTaskShade.getTaskId());
        scheduleJob.setCreateUserId(scheduleTaskShade.getCreateUserId());
        scheduleJob.setIsDeleted(Deleted.NORMAL.getStatus());
        scheduleJob.setType(getType());
        scheduleJob.setIsRestart(Restarted.NORMAL.getStatus());
        scheduleJob.setCycTime(cycTime);
        scheduleJob.setDependencyType(scheduleConf.getSelfReliance());
        scheduleJob.setFlowJobId(flowJobId);
        scheduleJob.setPeriodType(scheduleConf.getPeriodType());
        scheduleJob.setStatus(TaskStatus.UNSUBMIT.getStatus());
        scheduleJob.setTaskType(scheduleTaskShade.getTaskType());
        scheduleJob.setFillId(fillId);
        scheduleJob.setMaxRetryNum(scheduleConf.getMaxRetryNum());
        scheduleJob.setVersionId(scheduleTaskShade.getVersionId());
        scheduleJob.setComputeType(scheduleTaskShade.getComputeType());
        scheduleJob.setNextCycTime(DateUtil.getDate(corn.next(currentData), DateUtil.STANDARD_DATETIME_FORMAT));
        scheduleJob.setJobExecuteOrder(JobExecuteOrderUtil.buildJobExecuteOrder(cycTime, jobSortWorker.getSort()));

        // ????????????
        List<ScheduleJobJob> jobJobList = Lists.newArrayList();
        JobDependency dependencyHandler = dependencyManager.getDependencyHandler(getKeyPreStr(name), scheduleTaskShade, corn);
        jobJobList.addAll(dependencyHandler.generationJobJobForTask(corn, currentData, jobKey));

        ScheduleJobDetails jobBuilderBean = new ScheduleJobDetails();
        jobBuilderBean.setJobJobList(jobJobList);
        jobBuilderBean.setScheduleJob(scheduleJob);
        return jobBuilderBean;
    }

    private String getKeyPreStr(String name) {
        if (StringUtils.isBlank(name)) {
            return getPrefix();
        }
        return getPrefix() + "_" + name;
    }

    /**
     * ??????????????????
     */
    protected abstract String getPrefix();

    /**
     * ??????????????????
     *
     * @return ????????????
     */
    protected abstract Integer getType();

    /**
     * ??????????????????????????????????????????????????????
     *
     * @param triggerDay ????????????
     * @param beginTime  ????????????
     * @param endTime    ????????????
     * @return ????????????
     */
    private Pair<Date, Date> getTriggerRange(String triggerDay, String beginTime, String endTime) {
        if (StringUtils.isBlank(triggerDay)) {
            throw new TaierDefineException("triggerDay is not null");
        }

        if (StringUtils.isBlank(beginTime)) {
            beginTime = "00:00:00";
        }

        if (StringUtils.isBlank(endTime)) {
            endTime = "23:59:59";
        }

        String start = triggerDay + " " + beginTime + ":00";
        String end = triggerDay + " " + endTime + ":59";

        Date startDate = DateUtil.parseDate(start, DateUtil.STANDARD_DATETIME_FORMAT, Locale.CHINA);
        Date endDate = DateUtil.parseDate(end, DateUtil.STANDARD_DATETIME_FORMAT, Locale.CHINA);
        if (startDate == null || endDate == null) {
            throw new TaierDefineException("triggerDay or beginTime or endTime invalid");
        }

        return new ImmutablePair<>(startDate, endDate);
    }

    /**
     * ???????????????????????????????????????????????????
     *
     * @param scheduleConf ??????
     * @param triggerRange ??????????????????
     * @return ??????????????????
     */
    private Date getStartData(ScheduleConf scheduleConf, Pair<Date, Date> triggerRange, Long taskId) {
        int beginHour = scheduleConf.getBeginHour() != null ? scheduleConf.getBeginHour() : 0;
        int beginMin = scheduleConf.getBeginMin() != null ? scheduleConf.getBeginMin() : 0;
        String startStr = DateUtil.getDate(scheduleConf.getBeginDate(), DateUtil.DATE_FORMAT) + " " + beginHour + ":" + beginMin + ":00";
        Date beginDate = DateUtil.parseDate(startStr, DateUtil.STANDARD_DATETIME_FORMAT, Locale.CHINA);
        // ??????????????????????????? 1 ??????????????????????????? 2 ?????????????????????
        // ????????????????????????????????????????????? ?????????????????????????????????????????????
        if (beginDate.before(triggerRange.getLeft()) || beginDate.after(triggerRange.getLeft()) && beginDate.before(triggerRange.getRight())) {
            DateTime dateTime = new DateTime(triggerRange.getLeft());
            return compareAndReplaceMinuteAndHour(dateTime, beginHour, beginMin, true).toDate();
        }

        throw new TaierDefineException("task:" + taskId + " out of time range");
    }

    /**
     * ???????????????????????????????????????????????????
     *
     * @param scheduleConf ??????
     * @param triggerRange ??????????????????
     * @return ??????????????????
     */
    private Date getEndDate(ScheduleConf scheduleConf, Pair<Date, Date> triggerRange, Long taskId) {
        int endHour = scheduleConf.getBeginHour() != null ? scheduleConf.getEndHour() : 23;
        int endMin = scheduleConf.getBeginMin() != null ? scheduleConf.getEndMin() : 59;
        String endDateStr = DateUtil.getDate(scheduleConf.getEndDate(), DateUtil.DATE_FORMAT) + " " + endHour + ":" + endMin + ":00";
        Date endDate = DateUtil.parseDate(endDateStr, DateUtil.STANDARD_DATETIME_FORMAT, Locale.CHINA);
        if ((endDate.after(triggerRange.getLeft()) && endDate.before(triggerRange.getRight())) || endDate.after(triggerRange.getRight())) {
            DateTime dateTime = new DateTime(triggerRange.getRight());
            return compareAndReplaceMinuteAndHour(dateTime, endHour, endMin, false).toDate();
        }

        throw new TaierDefineException("task:" + taskId + " out of time range");
    }

    /**
     * ?????????????????????
     *
     * @param dateTime
     * @param minute
     * @param hour
     * @return
     */
    private DateTime replaceMinuteAndHour(DateTime dateTime, Integer minute, Integer hour) {
        if (dateTime != null) {
            if (minute != null && minute >= 0 && minute < 60) {
                dateTime = dateTime.withMinuteOfHour(minute);
            }

            if (hour != null && hour >= 0 && hour < 24) {
                dateTime = dateTime.withHourOfDay(hour);
            }
        }
        return dateTime;
    }

    /**
     * ?????????????????????
     *
     * @param dateTime         ??????????????????
     * @param scheduleHour     ????????????????????????
     * @param scheduleMin      ????????????????????????
     * @param startTimeCompare ?????????????????? true , false ??????????????????
     * @return
     */
    private DateTime compareAndReplaceMinuteAndHour(DateTime dateTime, Integer scheduleHour, Integer scheduleMin, boolean startTimeCompare) {
        Integer hour = dateTime.getHourOfDay();
        Integer min = dateTime.getMinuteOfHour();
        DateTime dateTimeNew = new DateTime(dateTime.getYear(), dateTime.getMonthOfYear(), dateTime.getDayOfMonth(), scheduleHour, scheduleMin, dateTime.getSecondOfMinute(), DateTimeZone.forID("+08:00"));
        if (startTimeCompare) {
            if (dateTimeNew.compareTo(dateTime) >= 0) {
                hour = scheduleHour;
                min = scheduleMin;
            }

        } else {
            if (dateTimeNew.compareTo(dateTime) < 0) {
                hour = scheduleHour;
                min = scheduleMin;
            }
        }

        return replaceMinuteAndHour(dateTime, min, hour);

    }


    @Override
    public void afterPropertiesSet() throws Exception {
        jobGraphBuildPool = new ThreadPoolExecutor(environmentContext.getGraphBuildPoolCorePoolSize(), environmentContext.getGraphBuildPoolMaximumPoolSize(), 10L, TimeUnit.SECONDS,
                new LinkedBlockingQueue<>(environmentContext.getGraphBuildPoolQueueSize()), new CustomThreadFactory(getPrefix()));

    }
}
