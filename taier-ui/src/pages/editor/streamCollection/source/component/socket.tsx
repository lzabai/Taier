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

import { parseRules } from '@/components/helpDoc/docs';
import { COLLECT_TYPE, DATA_SOURCE_ENUM, DATA_SOURCE_VERSION, READ_MODE_NAME, READ_MODE_TYPE } from '@/constant';
import { IDataSourceUsedInSyncProps } from '@/interface';
import { Form, Input, InputNumber, Radio, Select } from 'antd';
import React from 'react';

const FormItem = Form.Item;
const Option = Select.Option;

export default (props: { collectionData: any; sourceList: IDataSourceUsedInSyncProps[] }) => {
    const { collectionData, sourceList } = props;
    const { isEdit, sourceMap } = collectionData;
    const { type, decoder, sourceId } = sourceMap;

    const isLength = decoder == READ_MODE_TYPE.LENGTH;
    const sourceDataOptions = sourceList?.map?.((o: any) => {
        return (
            <Option key={o.id} value={o.id}>
                {o.name}
                {DATA_SOURCE_VERSION[o.type as DATA_SOURCE_ENUM] &&
                    ` (${DATA_SOURCE_VERSION[o.type as DATA_SOURCE_ENUM]})`}
            </Option>
        );
    });
    const renderCollectType = () => {
        const isCollectTypeEdit = !!sourceId;
        switch (type) {
            case DATA_SOURCE_ENUM.ORACLE: {
                return (
                    <Radio.Group style={{ position: 'relative' }} disabled={!isCollectTypeEdit}>
                        <Radio value={COLLECT_TYPE.ALL}>????????????????????????</Radio>
                        <Radio value={COLLECT_TYPE.FILE}>???????????????</Radio>
                    </Radio.Group>
                );
            }
            case DATA_SOURCE_ENUM.SQLSERVER:
            case DATA_SOURCE_ENUM.SQLSERVER_2017_LATER:
            case DATA_SOURCE_ENUM.POSTGRESQL: {
                return (
                    <Radio.Group style={{ position: 'relative' }} disabled={!isCollectTypeEdit}>
                        <Radio value={COLLECT_TYPE.ALL}>????????????????????????</Radio>
                        <Radio value={COLLECT_TYPE.LSN}>????????????LSN??????</Radio>
                    </Radio.Group>
                );
            }
            case DATA_SOURCE_ENUM.SOCKET: {
                return (
                    <Radio.Group style={{ position: 'relative' }} disabled>
                        <Radio value={COLLECT_TYPE.ALL}>????????????????????????</Radio>
                    </Radio.Group>
                );
            }
            case DATA_SOURCE_ENUM.UPDRDB: {
                return (
                    <Radio.Group disabled={!isCollectTypeEdit}>
                        <Radio value={COLLECT_TYPE.ALL}>????????????????????????</Radio>
                        <Radio value={COLLECT_TYPE.TIME}>???????????????</Radio>
                    </Radio.Group>
                );
            }
            case DATA_SOURCE_ENUM.MYSQL:
            default: {
                return (
                    <Radio.Group disabled={!isCollectTypeEdit}>
                        <Radio value={COLLECT_TYPE.ALL}>????????????????????????</Radio>
                        <Radio value={COLLECT_TYPE.TIME}>???????????????</Radio>
                        <Radio value={COLLECT_TYPE.FILE}>???????????????</Radio>
                    </Radio.Group>
                );
            }
        }
    };
    return (
        <React.Fragment>
            <FormItem name="sourceId" label="?????????" rules={[{ required: true, message: '??????????????????' }]}>
                <Select
                    getPopupContainer={(triggerNode: any) => triggerNode}
                    disabled={isEdit}
                    showSearch
                    placeholder="??????????????????"
                    className="right-select"
                    filterOption={(input: any, option: any) =>
                        option.props.children.toString().toLowerCase().indexOf(input.toLowerCase()) >= 0
                    }
                >
                    {sourceDataOptions}
                </Select>
            </FormItem>
            <FormItem name="decoder" label="????????????" rules={[{ required: true, message: '?????????????????????' }]}>
                <Select
                    getPopupContainer={(triggerNode: any) => triggerNode}
                    disabled={isEdit}
                    showSearch
                    placeholder="?????????????????????"
                    className="right-select"
                    filterOption={(input: any, option: any) =>
                        option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                    }
                >
                    {Object.entries(READ_MODE_NAME).map(([key, value]) => {
                        return (
                            <Option key={`${key}`} value={key}>
                                {value}
                            </Option>
                        );
                    })}
                </Select>
            </FormItem>
            <FormItem
                name="attr"
                label={isLength ? '????????????' : '????????????'}
                rules={
                    isLength
                        ? [
                              {
                                  required: true,
                                  message: '?????????????????????',
                              },
                          ]
                        : [
                              {
                                  required: true,
                                  message: '?????????????????????',
                              },
                              {
                                  max: 128,
                                  message: '????????????????????????128?????????',
                              },
                          ]
                }
            >
                {isLength ? (
                    <InputNumber
                        style={{ width: '100%' }}
                        min={1}
                        max={99999999}
                        placeholder="??????????????????????????????????????????????????????????????????????????????????????????????????????????????????"
                    />
                ) : (
                    <Input placeholder="?????????????????????????????? ???,??? ???;??? ???" />
                )}
            </FormItem>
            <FormItem
                name="parse"
                label="????????????"
                rules={[{ required: true, message: '?????????????????????' }]}
                tooltip={parseRules}
            >
                <Select
                    getPopupContainer={(triggerNode: any) => triggerNode}
                    disabled={isEdit}
                    showSearch
                    placeholder="?????????????????????"
                    className="right-select"
                    filterOption={(input: any, option: any) =>
                        option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                    }
                >
                    <Radio key="text" value="text">
                        text
                    </Radio>
                </Select>
            </FormItem>
            <FormItem
                name="collectType"
                label="????????????"
                style={{ textAlign: 'left' }}
                rules={[{ required: true, message: '?????????????????????' }]}
            >
                {renderCollectType()}
            </FormItem>
        </React.Fragment>
    );
};
