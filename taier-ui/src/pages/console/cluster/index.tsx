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

import { useRef, useState } from 'react';
import { history } from 'umi';
import { Button, message, Space, Divider, Modal } from 'antd';
import moment from 'moment';
import AddEngineModal from '@/components/addEngineModal';
import Api from '@/api';
import type { IActionRef } from '@/components/sketch';
import Sketch from '@/components/sketch';
import type { ColumnsType } from 'antd/lib/table';
import { DRAWER_MENU_ENUM } from '@/constant';
import './index.scss';

interface IClusterProps {
    id: string;
    gmtCreate: number;
    gmtModified: number;
    clusterName: string;
    hadoopVersion: string;
    clusterId: number;
}

export default function ClusterManage() {
    const actionRef = useRef<IActionRef>(null);
    const [modalVisible, setModalVisible] = useState(false);

    const getResourceList = (_: any, { current, pageSize }: { current: number; pageSize: number }) => {
        return Api.getClusterList({
            currentPage: current,
            pageSize,
        }).then((res) => {
            if (res.code === 1) {
                return {
                    total: res.data.totalCount,
                    data: res.data.data,
                };
            }
        });
    };

    const handleDelete = (record: IClusterProps) => {
        Modal.confirm({
            title: `???????????????????????????????????????????????? ${record.clusterName}?`,
            okText: '??????',
            onOk() {
                Api.deleteCluster({
                    clusterId: record.clusterId,
                }).then((res: any) => {
                    if (res.code === 1) {
                        message.success('??????????????????');
                        actionRef.current?.submit();
                    }
                });
            },
        });
    };

    const newCluster = () => {
        setModalVisible(true);
    };

    const onCancel = () => {
        setModalVisible(false);
    };

    const onSubmit = (params: { clusterName: string }) => {
        Api.addCluster({ ...params }).then((res) => {
            if (res.code === 1) {
                onCancel();
                history.push({
                    query: {
                        drawer: DRAWER_MENU_ENUM.CLUSTER_DETAIL,
                        clusterName: params.clusterName,
                        clusterId: res.data.toString(),
                    },
                });
                message.success('?????????????????????');
            }
        });
    };

    const viewCluster = (record: IClusterProps) => {
        history.push({
            query: {
                drawer: DRAWER_MENU_ENUM.CLUSTER_DETAIL,
                clusterName: record.clusterName,
                clusterId: record.clusterId.toString(),
            },
        });
    };

    const columns: ColumnsType<IClusterProps> = [
        {
            title: '????????????',
            dataIndex: 'clusterName',
        },
        {
            title: '????????????',
            dataIndex: 'gmtModified',
            render(text) {
                return moment(text).format('YYYY-MM-DD HH:mm:ss');
            },
        },
        {
            title: '??????',
            dataIndex: 'deal',
            width: '170px',
            render: (_, record) => {
                return (
                    <Space split={<Divider type="vertical" />}>
                        <a onClick={() => viewCluster(record)}>??????</a>
                        <a onClick={() => handleDelete(record)}>??????</a>
                    </Space>
                );
            },
        },
    ];
    return (
        <>
            <Sketch<IClusterProps, Record<string, never>>
                extra={
                    <Button type="primary" onClick={() => newCluster()}>
                        ????????????
                    </Button>
                }
                actionRef={actionRef}
                request={getResourceList}
                columns={columns}
                tableProps={{
                    rowSelection: undefined,
                }}
            />
            <AddEngineModal title="????????????" visible={modalVisible} onCancel={onCancel} onOk={onSubmit} />
        </>
    );
}
