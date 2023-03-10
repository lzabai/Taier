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

import type { CSSProperties } from 'react';
import { useUpdateEffect } from 'react-use';
import { useEffect, useMemo, useRef, useState } from 'react';
import type { FormInstance, RadioChangeEvent } from 'antd';
import { Row, Col, Collapse, Radio, message } from 'antd';
import type { CheckboxChangeEvent } from 'antd/lib/checkbox';
import moment from 'moment';
import { isArray } from 'lodash';
import api from '@/api';
import { DATA_SYNC_MODE, SCHEDULE_DEPENDENCY, SCHEDULE_STATUS, TASK_PERIOD_ENUM, TASK_TYPE_ENUM } from '@/constant';
import type { IOfflineTaskProps, IScheduleConfProps, ITaskVOProps } from '@/interface';
import molecule from '@dtinsight/molecule/esm';
import FormWrap from './scheduleForm';
import TaskDependence from './taskDependence';
import HelpDoc from '@/components/helpDoc';
import type { IRightBarComponentProps } from '@/services/rightBarService';
import type { IEditorTab } from '@dtinsight/molecule/esm/model';

const { Panel } = Collapse;
const RadioGroup = Radio.Group;

const radioStyle: CSSProperties = {
    display: 'flex',
    height: 30,
    fontSize: 12,
    lineHeight: '30px',
};

const getDefaultScheduleConf = (value: TASK_PERIOD_ENUM) => {
    const scheduleConf: Record<TASK_PERIOD_ENUM, Partial<IScheduleConfProps>> = {
        [TASK_PERIOD_ENUM.MINUTE]: {
            beginMin: 0,
            endMin: 59,
            beginHour: 0,
            endHour: 23,
            gapMin: 5,
            periodType: 0,
            beginDate: '2001-01-01',
            endDate: '2121-01-01',
        },
        [TASK_PERIOD_ENUM.HOUR]: {
            beginHour: 0,
            endHour: 23,
            beginMin: 0,
            gapHour: 5,
            periodType: 1,
        },
        [TASK_PERIOD_ENUM.DAY]: {
            min: 0,
            hour: 0,
            periodType: 2,
            beginDate: '2001-01-01',
            endDate: '2121-01-01',
        },
        [TASK_PERIOD_ENUM.WEEK]: {
            weekDay: 3,
            min: 0,
            hour: 23,
            periodType: 3,
        },
        [TASK_PERIOD_ENUM.MONTH]: {
            day: 5,
            hour: 0,
            min: 23,
            periodType: 4,
        },
    };

    return scheduleConf[value];
};

export default function SchedulingConfig({ current }: IRightBarComponentProps) {
    const [selfReliance, setSelfReliance] = useState<SCHEDULE_DEPENDENCY>(SCHEDULE_DEPENDENCY.NULL);
    const form = useRef<FormInstance<IScheduleConfProps & { scheduleStatus: boolean }>>(null);

    /**
     * ?????? tab ??????
     */
    const changeScheduleConf = (currentTab: IEditorTab, value: any) => {
        const { data } = currentTab;
        const tab = {
            ...currentTab,
            data: {
                ...data,
                ...value,
            },
        };
        molecule.editor.updateTab(tab);
    };

    const getInitScheduleConf = () => {
        const tabData: IOfflineTaskProps = current!.tab!.data;
        let initConf: Partial<IScheduleConfProps>;
        try {
            initConf = JSON.parse(tabData.scheduleConf);
        } catch (error) {
            initConf = {};
        }

        let scheduleConf = Object.assign(getDefaultScheduleConf(TASK_PERIOD_ENUM.MINUTE), {
            beginDate: '2001-01-01',
            endDate: '2121-01-01',
        });

        scheduleConf = Object.assign(scheduleConf, initConf);
        // ???????????????????????????????????????
        if (isWorkflowNode) {
            scheduleConf = Object.assign(
                getDefaultScheduleConf(TASK_PERIOD_ENUM.DAY),
                {
                    beginDate: '2001-01-01',
                    endDate: '2121-01-01',
                },
                scheduleConf
            );
            scheduleConf.periodType = 2;
        }

        return scheduleConf;
    };

    // ???????????? change ????????????
    const handleScheduleStatus = (evt: CheckboxChangeEvent) => {
        const { checked } = evt.target;
        const status = checked ? SCHEDULE_STATUS.FORZON : SCHEDULE_STATUS.NORMAL;
        const tabData: IOfflineTaskProps = current!.tab!.data;
        const sucInfo = checked ? '????????????' : '????????????';
        const errInfo = checked ? '????????????' : '????????????';
        api.forzenTask({
            taskIds: [tabData.id],
            scheduleStatus: status,
        }).then((res) => {
            if (res.code === 1) {
                changeScheduleConf?.(current!.tab!, {
                    scheduleStatus: status,
                });
                message.success(sucInfo);
            } else {
                message.error(errInfo);
            }
        });
    };

    // ????????????change????????????
    const handleScheduleConf = () => {
        const tabData: IOfflineTaskProps = current!.tab!.data;
        let defaultScheduleConf: Partial<IScheduleConfProps>;
        try {
            defaultScheduleConf = JSON.parse(tabData.scheduleConf);
        } catch (error) {
            defaultScheduleConf = {};
        }
        if (!defaultScheduleConf.periodType) {
            defaultScheduleConf = getDefaultScheduleConf(TASK_PERIOD_ENUM.DAY);
        }

        form.current?.validateFields().then((values: Partial<IScheduleConfProps>) => {
            let formData = values;
            formData.selfReliance = selfReliance;
            /**
             * ?????????????????? 3???
             */
            if (formData.isFailRetry) {
                if (!formData.maxRetryNum) {
                    formData.maxRetryNum = 3;
                }
            } else {
                formData.maxRetryNum = undefined;
            }
            formData = Object.assign(defaultScheduleConf, formData);
            Reflect.deleteProperty(formData, 'scheduleStatus');

            // the properties about date needed format
            const dateProperty = ['beginDate', 'endDate'] as const;
            dateProperty.forEach((dateKey) => {
                if (moment.isMoment(formData[dateKey])) {
                    formData[dateKey] = (formData[dateKey] as unknown as moment.Moment).format('YYYY-MM-DD');
                }
            });

            if (formData.weekDay && isArray(formData.weekDay)) {
                formData.weekDay = formData.weekDay.join(',');
            }
            if (formData.day && isArray(formData.day)) {
                formData.day = formData.day.join(',');
            }

            const newData = {
                scheduleConf: JSON.stringify(formData),
            };
            changeScheduleConf?.(current!.tab!, newData);
        });
    };

    // ???????????? change ????????????
    const handleScheduleType = (type: string) => {
        const dft = getDefaultScheduleConf(Number(type));
        if (form.current) {
            const {
                isFailRetry,
                scheduleStatus,
                beginDate,
                endDate,
                selfReliance: nextSelfReliance,
                maxRetryNum,
            } = form.current.getFieldsValue();
            const values = {
                ...dft,
                scheduleStatus,
                periodType: type,
                isFailRetry,
                beginDate,
                endDate,
                selfReliance: nextSelfReliance,
            };
            if (isFailRetry) {
                values.maxRetryNum = maxRetryNum;
            }
            const newData = {
                scheduleConf: JSON.stringify(values),
            };
            changeScheduleConf?.(current!.tab!, newData);
        }
    };

    const handleAddVOS = (record: Partial<ITaskVOProps>) => {
        const dependencyTasks = (current!.tab?.data.dependencyTasks || []).concat();
        dependencyTasks.push(record);
        changeScheduleConf?.(current!.tab!, { dependencyTasks });
    };

    const handleDelVOS = (record: ITaskVOProps) => {
        const dependencyTasks: ITaskVOProps[] = (current!.tab?.data.dependencyTasks || []).concat();
        const index = dependencyTasks.findIndex((vo) => vo.id === record.id);
        if (index === -1) return;
        dependencyTasks.splice(index, 1);
        changeScheduleConf?.(current!.tab!, { dependencyTasks });
    };

    const handleRadioChanged = (evt: RadioChangeEvent) => {
        const { value } = evt.target;
        setSelfReliance(value);
    };

    // Only update scheduleConf after reliance changed
    useUpdateEffect(() => {
        handleScheduleConf();
    }, [selfReliance]);

    useEffect(() => {
        const tabData: IOfflineTaskProps = current!.tab!.data;
        let initConf: Partial<IScheduleConfProps>;
        try {
            initConf = JSON.parse(tabData.scheduleConf);
        } catch (error) {
            initConf = {};
        }
        setSelfReliance(Number(initConf.selfReliance));
    }, [current]);

    const isIncrementMode = useMemo(() => current?.tab?.data?.sourceMap?.syncModel === DATA_SYNC_MODE.INCREMENT, []);

    const tabData: IOfflineTaskProps = current!.tab!.data;
    const scheduleConf = getInitScheduleConf();

    /**
     * ????????????????????????????????????
     */
    const isWorkflowNode = useMemo(() => !!tabData.flowId, [tabData]);

    return (
        <molecule.component.Scrollbar>
            <div className="m-scheduling" style={{ position: 'relative' }}>
                <Collapse bordered={false} defaultActiveKey={['1', '2', '3']}>
                    <Panel key="1" header="????????????">
                        <FormWrap
                            isWorkflowNode={isWorkflowNode}
                            isWorkflowRoot={tabData.taskType === TASK_TYPE_ENUM.WORK_FLOW}
                            scheduleConf={scheduleConf}
                            status={tabData?.scheduleStatus}
                            handleScheduleStatus={handleScheduleStatus}
                            handleScheduleConf={handleScheduleConf}
                            handleScheduleType={handleScheduleType}
                            ref={form}
                        />
                    </Panel>
                    {!isWorkflowNode && tabData && (
                        <Panel key="2" header="???????????????">
                            <TaskDependence handleAddVOS={handleAddVOS} handleDelVOS={handleDelVOS} tabData={tabData} />
                        </Panel>
                    )}
                    {!isWorkflowNode && (
                        <Panel key="3" header="???????????????">
                            <Row style={{ marginBottom: '16px' }}>
                                <Col offset={1}>
                                    <RadioGroup onChange={handleRadioChanged} value={selfReliance}>
                                        {!isIncrementMode && (
                                            <Radio style={radioStyle} value={SCHEDULE_DEPENDENCY.NULL}>
                                                ???????????????????????????
                                            </Radio>
                                        )}
                                        <Radio style={radioStyle} value={SCHEDULE_DEPENDENCY.AFTER_SUCCESS}>
                                            ???????????????????????????????????????????????????????????????
                                        </Radio>
                                        <Radio style={radioStyle} value={SCHEDULE_DEPENDENCY.AFTER_DONE}>
                                            ???????????????????????????????????????????????????????????????&nbsp;
                                            <HelpDoc
                                                style={{
                                                    position: 'inherit',
                                                }}
                                                doc={
                                                    !isIncrementMode
                                                        ? 'taskDependentTypeDesc'
                                                        : 'incrementModeScheduleTypeHelp'
                                                }
                                            />
                                        </Radio>
                                        {!isIncrementMode && (
                                            <Radio
                                                style={radioStyle}
                                                value={SCHEDULE_DEPENDENCY.AFTER_SUCCESS_IN_QUEUE}
                                            >
                                                ????????????????????????????????????????????????????????????
                                            </Radio>
                                        )}
                                        {!isIncrementMode && (
                                            <Radio style={radioStyle} value={SCHEDULE_DEPENDENCY.AFTER_DONE_IN_QUEUE}>
                                                ????????????????????????????????????????????????????????????&nbsp;
                                                <HelpDoc
                                                    style={{
                                                        position: 'inherit',
                                                    }}
                                                    doc="taskDependentTypeDesc"
                                                />
                                            </Radio>
                                        )}
                                    </RadioGroup>
                                </Col>
                            </Row>
                        </Panel>
                    )}
                </Collapse>
            </div>
        </molecule.component.Scrollbar>
    );
}
