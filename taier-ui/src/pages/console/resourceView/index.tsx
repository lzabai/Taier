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
import { useEffect, useMemo, useState } from 'react';
import { Table, Progress } from 'antd';
import Api from '../../../api';
import { findKey } from 'lodash';
import type {
    ICapacityProps,
    IClusterResourceProps,
    IFairProps,
    IFIFOProps,
    INodeProps,
    IQueueProps,
    IResourceMetrics,
} from './helper';
import { NODE_COLUMNS, ResourceCard, RESOURCE_DETAIL_COLUMNS } from './helper';
import type { ColumnsType, TableProps } from 'antd/lib/table';
import { SCHEDULE_TYPE } from '@/constant';
import './index.scss';

export default ({
    clusterId,
    onGetQueueList,
}: {
    clusterId?: number;
    onGetQueueList?: (queueList: IQueueProps[]) => void;
}) => {
    const [nodeLists, setNodeLists] = useState<INodeProps[]>([]);
    const [resourceMetrics, setMetrics] = useState<IResourceMetrics>({
        coresRate: 0,
        memRate: 0,
        totalCores: 0,
        totalMem: 0,
        usedCores: 0,
        usedMem: 0,
    });
    const [scheduleType, setScheduleType] = useState<SCHEDULE_TYPE>(SCHEDULE_TYPE.Capacity);
    const [queueLists, setQueueLists] = useState<IQueueProps[]>([]);

    const getClusterResources = () => {
        Api.getClusterResources({
            clusterId,
        }).then((res) => {
            if (res.code === 1) {
                const data = res.data as IClusterResourceProps;
                if (!data) return;
                setNodeLists(data.nodes || []);
                if (data.resourceMetrics) {
                    setMetrics(data.resourceMetrics);
                }
                if (data.scheduleInfo) {
                    setScheduleType(data.scheduleInfo.type);
                }

                let queuesListSource = [];
                switch (data.scheduleInfo?.type) {
                    case SCHEDULE_TYPE.Capacity: {
                        queuesListSource = data.queues || [];
                        break;
                    }
                    case SCHEDULE_TYPE.Fair: {
                        const childQueues = data.scheduleInfo?.rootQueue?.childQueues;
                        queuesListSource = childQueues?.queue ?? childQueues;
                        break;
                    }
                    case SCHEDULE_TYPE.FIFO: {
                        queuesListSource = [{ ...data?.scheduleInfo }];
                        break;
                    }
                    default:
                        break;
                }
                onGetQueueList?.(queuesListSource || []);
                setQueueLists(queuesListSource || []);
            }
        });
    };

    const renderSubTable = (record: ICapacityProps) => {
        return (
            <Table
                size="middle"
                className="resourceView__subTable"
                rowKey="username"
                columns={RESOURCE_DETAIL_COLUMNS}
                dataSource={record.users}
                pagination={false}
            />
        );
    };

    useEffect(() => {
        getClusterResources();
    }, [clusterId]);

    const queueColumns = useMemo(() => {
        switch (scheduleType) {
            case SCHEDULE_TYPE.Capacity:
                return [
                    {
                        title: '????????????',
                        dataIndex: 'queueName',
                    },
                    {
                        title: '???????????????',
                        dataIndex: 'usedCapacity',
                        render(text: number) {
                            return (
                                <Progress
                                    style={{ paddingRight: 20 }}
                                    percent={text}
                                    strokeColor="rgb(57, 227, 169)"
                                    size="small"
                                />
                            );
                        },
                    },
                    {
                        title: '????????????',
                        dataIndex: 'capacity',
                        render(text) {
                            return `${text}%`;
                        },
                    },
                    {
                        title: '????????????',
                        dataIndex: 'maxCapacity',
                        render(text) {
                            return `${text}%`;
                        },
                    },
                ] as ColumnsType<ICapacityProps>;
            case SCHEDULE_TYPE.Fair:
                return [
                    {
                        title: '????????????',
                        dataIndex: 'queueName',
                    },
                    {
                        title: '???????????????',
                        dataIndex: 'usedResources',
                        render(text: IFairProps['usedResources']) {
                            return (
                                <span>
                                    memory:
                                    <span style={{ margin: 5 }}>{text?.memory},&nbsp;</span>
                                    vCores:
                                    <span style={{ margin: 5 }}>{text?.vCores}</span>
                                </span>
                            );
                        },
                    },
                    {
                        title: '???????????????',
                        dataIndex: 'maxResources',
                        render(text: IFairProps['maxResources']) {
                            return (
                                <span>
                                    memory:
                                    <span style={{ margin: 5 }}>{text?.memory},&nbsp;</span>
                                    vCores:
                                    <span style={{ margin: 5 }}>{text?.vCores}</span>
                                </span>
                            );
                        },
                    },
                    {
                        title: '???????????????',
                        dataIndex: 'minResources',
                        render(text: IFairProps['minResources']) {
                            return (
                                <span>
                                    memory:
                                    <span style={{ margin: 5 }}>{text?.memory},&nbsp;</span>
                                    vCores:
                                    <span style={{ margin: 5 }}>{text?.vCores}</span>
                                </span>
                            );
                        },
                    },
                ] as ColumnsType<IFairProps>;
            case SCHEDULE_TYPE.FIFO:
                return [
                    {
                        title: '??????',
                        dataIndex: 'capacity',
                    },
                    {
                        title: '???????????????',
                        dataIndex: 'usedCapacity',
                    },
                    {
                        title: '????????????',
                        dataIndex: 'numNodes',
                    },
                ] as ColumnsType<IFIFOProps>;
            default:
                return [];
        }
    }, [scheduleType]);

    return (
        <>
            <div className="c-resourceView__container">
                <div style={{ height: 110, width: '50%', marginRight: 10 }}>
                    <ResourceCard
                        type="cpu"
                        title="CPU???core???"
                        useNum={resourceMetrics.usedCores}
                        total={resourceMetrics.totalCores}
                        value={resourceMetrics.coresRate}
                    />
                </div>
                <div style={{ height: 110, width: '50%', marginLeft: 10 }}>
                    <ResourceCard
                        type="memory"
                        title="?????????GB???"
                        useNum={resourceMetrics.usedMem}
                        total={resourceMetrics.totalMem}
                        value={resourceMetrics.memRate}
                    />
                </div>
            </div>
            <RenderTable
                columns={NODE_COLUMNS}
                dataSource={nodeLists}
                title="Yarn-NodeManager ????????????"
                rowKey="nodeName"
            />
            <RenderTable
                columns={queueColumns}
                dataSource={queueLists}
                expandable={{
                    expandedRowRender: renderSubTable,
                }}
                rowKey="queueName"
                title={`???????????????????????????`}
                desc={`???????????????${findKey(SCHEDULE_TYPE, (val) => val === scheduleType)}`}
            />
        </>
    );
};

/**
 * Table with title
 */
export const RenderTable = ({
    title,
    desc = '',
    ...tableProps
}: { title: React.ReactNode; desc?: string } & Omit<TableProps<any>, 'title'>) => (
    <div className="c-resourceView__table__container">
        <p>
            <span className="resourceView__table__title">{title}</span>
            {desc && <span className="resourceView__table__desc">{`???${desc}???`}</span>}
        </p>
        <Table pagination={false} className="resourceView__table-border" size="middle" {...tableProps} />
    </div>
);
