// @ts-nocheck
/* eslint-disable */
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

import api from '@/api';
import { analyticalRules, partitionType } from '@/components/helpDoc/docs';
import { PARTITION_TYPE, WRITE_TABLE_TYPE } from '@/constant';
import { isMysqlTypeSource } from '@/utils/is';
import { Form, Input, InputNumber, Radio, Select } from 'antd';
import { debounce } from 'lodash';
import React, { useEffect, useState } from 'react';

const FormItem = Form.Item;
const Option = Select.Option;
const prefixRule = '${schema}_${table}';

export default (props: { collectionData: any }) => {
    const { collectionData } = props;
    const { targetMap = {}, sourceMap = {} } = collectionData;
    const { writeTableType, table, sourceId, writeMode } = targetMap;
    const isMysqlSource = isMysqlTypeSource(sourceMap.type);

    const [tableList, setTableList] = useState([]);
    const [partitions, setPartitions] = useState([]);

    const getTableList = (sourceId: number, searchKey?: string) => {
        setTableList([]);
        api.getStreamTablelist({
            sourceId,
            isSys: false,
            searchKey,
        }).then((res: any) => {
            if (res.code === 1) {
                setTableList(res.data || []);
            }
        });
    };

    const _searchTableList = (text: string) => {
        getTableList(sourceId, text);
    };
    const searchTableList = debounce(_searchTableList, 500);

    const onHiveTableChange = async (sourceId: any, tableName: any) => {
        // this.setState({
        //     partition: [],
        //     partitions: []
        // })
        setPartitions([]);
        if (!sourceId || !tableName) {
            return;
        }
        const res = await api.getHivePartitions({
            sourceId,
            tableName,
        });
        if (res && res.code == 1) {
            const partitions = res.data;
            if (partitions && partitions.length) {
                setPartitions(res.data);
            }
        }
    };

    useEffect(() => {
        if (sourceId && table) {
            onHiveTableChange(sourceId, table);
        }
    }, [sourceId, table]);
    useEffect(() => {
        if (sourceId) getTableList(sourceId);
    }, [sourceId]);

    return (
        <React.Fragment>
            <FormItem label="?????????" name="writeTableType" rules={[{ required: true }]} tooltip={writeTableType}>
                <Radio.Group disabled>
                    {isMysqlSource ? (
                        <Radio key={WRITE_TABLE_TYPE.AUTO} value={WRITE_TABLE_TYPE.AUTO} style={{ float: 'left' }}>
                            ????????????
                        </Radio>
                    ) : null}
                    <Radio key={WRITE_TABLE_TYPE.HAND} value={WRITE_TABLE_TYPE.HAND} style={{ float: 'left' }}>
                        ?????????????????????
                    </Radio>
                </Radio.Group>
            </FormItem>
            {writeTableType === WRITE_TABLE_TYPE.AUTO && (
                <React.Fragment>
                    <FormItem
                        label="??????????????????"
                        name="analyticalRules"
                        rules={[
                            {
                                required: false,
                                message: '?????????????????????',
                            },
                            {
                                pattern: /^[^.&%\s]*$/,
                                message: '?????????????????????????????????????????????????????????Hive???????????????',
                            },
                        ]}
                        tooltip={analyticalRules}
                    >
                        <Input addonBefore={`stream_${prefixRule}`} />
                    </FormItem>
                    <FormItem
                        label="????????????"
                        name="fileType"
                        rules={[{ required: true, message: '????????????????????????' }]}
                    >
                        <Radio.Group>
                            <Radio value="orc" style={{ float: 'left', marginRight: 18 }}>
                                orc
                            </Radio>
                            <Radio value="text" style={{ float: 'left', marginRight: 18 }}>
                                text
                            </Radio>
                            <Radio value="parquet" style={{ float: 'left' }}>
                                parquet
                            </Radio>
                        </Radio.Group>
                    </FormItem>
                </React.Fragment>
            )}
            <FormItem
                label="????????????"
                name="partitionType"
                rules={[{ required: false, message: '?????????????????????' }]}
                tooltip={partitionType}
            >
                <Radio.Group>
                    <Radio value={PARTITION_TYPE.DAY} style={{ float: 'left', marginRight: 18 }}>
                        ???
                    </Radio>
                    <Radio value={PARTITION_TYPE.HOUR} style={{ float: 'left' }}>
                        ??????
                    </Radio>
                </Radio.Group>
            </FormItem>
            {writeTableType == WRITE_TABLE_TYPE.HAND && (
                <FormItem label="???" name="table" rules={[{ required: true, message: '????????????' }]}>
                    <Select
                        showSearch
                        placeholder="????????????"
                        getPopupContainer={(triggerNode: any) => triggerNode}
                        onSearch={(v) => {
                            searchTableList(v);
                        }}
                    >
                        {tableList.map((tableName: any) => {
                            return (
                                <Option key={tableName} value={tableName}>
                                    {tableName}
                                </Option>
                            );
                        })}
                    </Select>
                </FormItem>
            )}
            {writeTableType == WRITE_TABLE_TYPE.HAND && table && partitions && partitions.length && (
                <FormItem label="??????" name="partition" rules={[{ required: true, message: '???????????????' }]}>
                    <Select>
                        {partitions.map((partition: any) => {
                            return (
                                <Option key={partition} value={partition}>
                                    {partition}
                                </Option>
                            );
                        })}
                    </Select>
                </FormItem>
            )}
            <FormItem
                label={'????????????'}
                name="maxFileSize"
                rules={[
                    {
                        required: false,
                        message: '?????????????????????',
                    },
                    {
                        validator: (rule: any, value: any, callback: any) => {
                            let errorMsg: any;
                            if (!value && value !== 0) {
                                callback();
                                return;
                            }
                            try {
                                value = parseFloat(value);
                                if (value <= 0) {
                                    errorMsg = '??????????????????0';
                                } else if (value != parseInt(value, 10)) {
                                    errorMsg = '???????????????';
                                }
                            } catch (e) {
                                errorMsg = '???????????????0???????????????';
                            } finally {
                                callback(errorMsg);
                            }
                        },
                    },
                ]}
                extra={
                    <div>
                        ??????????????????????????????????????????????????????????????????{' '}
                        <span className="mtk12">flink.checkpoint.interval</span> ??????
                    </div>
                }
            >
                <FormInputNumber />
            </FormItem>
            <FormItem
                label="????????????"
                className="txt-left"
                name="writeMode"
                rules={[{ required: true }]}
                extra={
                    writeMode == 'replace' && (
                        <p style={{ color: 'red' }}>????????????????????????????????????????????????????????????????????????????????????</p>
                    )
                }
            >
                <Radio.Group>
                    <Radio value="insert" style={{ float: 'left' }}>
                        ?????????Insert Into???
                    </Radio>
                </Radio.Group>
            </FormItem>
        </React.Fragment>
    );
};

const FormInputNumber = (props: { value?: any; title?: any; onChange?: any }) => {
    const { value, title = 'MB', onChange } = props;
    return (
        <React.Fragment>
            <span style={{ marginRight: 8 }}>??????</span>
            <InputNumber style={{ width: 170 }} value={value} onChange={onChange} />
            <span style={{ marginLeft: 8 }}>{title}????????????</span>
        </React.Fragment>
    );
};
