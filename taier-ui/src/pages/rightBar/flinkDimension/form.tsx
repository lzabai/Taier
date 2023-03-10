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

import React, { useContext, useRef, useState } from 'react';
import { debounce } from 'lodash';
import { DATA_SOURCE_ENUM, DATA_SOURCE_TEXT, formItemLayout, HELP_DOC_URL } from '@/constant';
import {
    isHaveTableColumn,
    isShowSchema,
    isES,
    isCacheOnlyAll,
    isCacheExceptLRU,
    isHaveAsyncPoolSize,
    isHaveCustomParams,
    isSchemaRequired,
} from '@/utils/is';
import type { FormInstance } from 'antd';
import { Button, Form, Input, InputNumber, message, Popconfirm, Select, Switch, Table, Tooltip } from 'antd';
import { QuestionCircleOutlined, CloseOutlined } from '@ant-design/icons';
import Editor from '@/components/editor';
import { asyncTimeoutNumDoc, queryFault, targetColText } from '@/components/helpDoc/docs';
import { CustomParams } from '../customParams';
import DataPreviewModal from '../../editor/streamCollection/source/dataPreviewModal';
import type { IDataColumnsProps, IDataSourceUsedInSyncProps, IFlinkSideProps } from '@/interface';
import { createSeries } from '@/utils';
import { NAME_FIELD } from '.';
import { FormContext } from '@/services/rightBarService';
import { taskRenderService } from '@/services';

const FormItem = Form.Item;
const { Option } = Select;

type IFormFieldProps = IFlinkSideProps;

interface IDimensionFormProps {
    /**
     * ?????? name ??????
     */
    index: number;
    sourceOptions?: IDataSourceUsedInSyncProps[];
    /**
     * @deprecated ???????????????????????? schema ????????????
     */
    schemaOptions?: string[];
    /**
     * ??? searchkey ???????????????????????? value
     */
    tableOptions?: Record<string, string[]>;
    columnsOptions?: IDataColumnsProps[];
    isFlink112?: boolean;
    onTableSearch?: (
        type: DATA_SOURCE_ENUM,
        sourceId: number,
        schema?: string | undefined,
        searchKey?: string | undefined
    ) => Promise<void>;
    onColumnsChange?: (changedValue: any, values: any) => void;
}

/**
 * ?????????????????????
 */
enum ColOperatorKind {
    ADD,
    ADD_ALL,
    REMOVE_ALL,
    SET_COL,
    SET_TYPE,
    SET_TARGET,
    REMOVE,
}

export default function DimensionForm({
    index,
    sourceOptions = [],
    schemaOptions = [],
    tableOptions = {},
    columnsOptions = [],
    isFlink112 = true,
    onTableSearch,
    onColumnsChange,
}: IDimensionFormProps) {
    const { form } = useContext(FormContext) as {
        form?: FormInstance<{ [NAME_FIELD]: IFormFieldProps[] }>;
    };
    const [visible, setVisible] = useState(false);
    const [params, setParams] = useState<Record<string, any>>({});
    const currentSearchKey = useRef('');

    const handleSearchTable = debounce((key: string) => {
        currentSearchKey.current = key;
        const { sourceId, schema, type } = form!.getFieldsValue()[NAME_FIELD][index];
        onTableSearch?.(type, sourceId, schema, key);
    }, 300);

    const handleColsChanged = (ops: ColOperatorKind, idx?: number, value?: string) => {
        switch (ops) {
            case ColOperatorKind.ADD: {
                const nextCols = form?.getFieldsValue()[NAME_FIELD][index].columns?.concat() || [];
                nextCols.push({});

                const nextValue = form!.getFieldsValue();
                nextValue[NAME_FIELD][index].columns = nextCols;
                form?.setFieldsValue({ ...nextValue });

                // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                const changedValue: any[] = [];
                changedValue[index] = {
                    columns: nextValue[NAME_FIELD][index].columns,
                };
                onColumnsChange?.({ [NAME_FIELD]: changedValue }, form!.getFieldsValue());
                break;
            }

            case ColOperatorKind.ADD_ALL: {
                const nextCols = columnsOptions.map((col) => ({
                    column: col.key,
                    type: col.type,
                }));

                const nextValue = form!.getFieldsValue();
                nextValue[NAME_FIELD][index].columns = nextCols;
                form?.setFieldsValue(nextValue);

                // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                const changedValue: any[] = [];
                changedValue[index] = {
                    columns: nextValue[NAME_FIELD][index].columns,
                };
                onColumnsChange?.({ [NAME_FIELD]: changedValue }, form!.getFieldsValue());
                break;
            }

            case ColOperatorKind.REMOVE_ALL: {
                const nextValue = form!.getFieldsValue();
                nextValue[NAME_FIELD][index].columns = [];
                form?.setFieldsValue(nextValue);

                // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                const changedValue: any[] = [];
                changedValue[index] = {
                    columns: nextValue[NAME_FIELD][index].columns,
                };
                onColumnsChange?.({ [NAME_FIELD]: changedValue }, form!.getFieldsValue());
                break;
            }

            case ColOperatorKind.SET_COL: {
                const nextCols = form?.getFieldsValue()[NAME_FIELD][index].columns?.concat() || [];
                if (idx !== undefined && value) {
                    nextCols[idx].column = value;
                    nextCols[idx].type = columnsOptions.find((c) => c.key === value)?.type;

                    const nextValue = form!.getFieldsValue();
                    nextValue[NAME_FIELD][index].columns = nextCols;
                    form?.setFieldsValue(nextValue);

                    // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                    const changedValue: any[] = [];
                    changedValue[index] = {
                        columns: nextValue[NAME_FIELD][index].columns,
                    };
                    onColumnsChange?.({ [NAME_FIELD]: changedValue }, form!.getFieldsValue());
                }
                break;
            }

            case ColOperatorKind.SET_TYPE: {
                const nextCols = form?.getFieldsValue()[NAME_FIELD][index].columns?.concat() || [];
                if (idx !== undefined && value) {
                    nextCols[idx].type = value;

                    const nextValue = form!.getFieldsValue();
                    nextValue[NAME_FIELD][index].columns = nextCols;
                    form?.setFieldsValue(nextValue);

                    // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                    const changedValue: any[] = [];
                    changedValue[index] = {
                        columns: nextValue[NAME_FIELD][index].columns,
                    };
                    onColumnsChange?.({ [NAME_FIELD]: changedValue }, form!.getFieldsValue());
                }
                break;
            }

            case ColOperatorKind.SET_TARGET: {
                const nextCols = form?.getFieldsValue()[NAME_FIELD][index].columns?.concat() || [];
                if (idx !== undefined && value) {
                    nextCols[idx].targetCol = value;

                    const nextValue = form!.getFieldsValue();
                    nextValue[NAME_FIELD][index].columns = nextCols;
                    form?.setFieldsValue(nextValue);

                    // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                    const changedValue: any[] = [];
                    changedValue[index] = {
                        columns: nextValue[NAME_FIELD][index].columns,
                    };
                    onColumnsChange?.({ [NAME_FIELD]: changedValue }, form!.getFieldsValue());
                }
                break;
            }

            case ColOperatorKind.REMOVE: {
                const nextCols = form?.getFieldsValue()[NAME_FIELD][index].columns?.concat() || [];
                if (idx !== undefined) {
                    nextCols.splice(idx, 1);

                    const nextValue = form!.getFieldsValue();
                    nextValue[NAME_FIELD][index].columns = nextCols;
                    form?.setFieldsValue(nextValue);

                    // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                    const changedValue: any[] = [];
                    changedValue[index] = {
                        columns: nextValue[NAME_FIELD][index].columns,
                    };
                    onColumnsChange?.({ [NAME_FIELD]: changedValue }, form!.getFieldsValue());
                }
                break;
            }

            default:
                break;
        }
    };

    const showPreviewModal = () => {
        const { type, sourceId, index: tableIndex, table, schema } = form!.getFieldsValue()[NAME_FIELD][index];
        let nextParams = {};
        switch (type) {
            case DATA_SOURCE_ENUM.ES7: {
                if (!sourceId || !tableIndex) {
                    message.error('?????????????????????????????????????????????');
                    return;
                }
                nextParams = { sourceId, tableName: tableIndex };
                break;
            }
            case DATA_SOURCE_ENUM.REDIS:
            case DATA_SOURCE_ENUM.UPRedis:
            case DATA_SOURCE_ENUM.HBASE:
            case DATA_SOURCE_ENUM.TBDS_HBASE:
            case DATA_SOURCE_ENUM.HBASE_HUAWEI:
            case DATA_SOURCE_ENUM.MYSQL:
            case DATA_SOURCE_ENUM.UPDRDB:
            case DATA_SOURCE_ENUM.INCEPTOR: {
                if (!sourceId || !table) {
                    message.error('??????????????????????????????????????????');
                    return;
                }
                nextParams = { sourceId, tableName: table };
                break;
            }
            case DATA_SOURCE_ENUM.ORACLE: {
                if (!sourceId || !table || !schema) {
                    message.error('??????????????????????????????????????????schema???');
                    return;
                }
                nextParams = { sourceId, tableName: table, schema };
                break;
            }
            case DATA_SOURCE_ENUM.SQLSERVER:
            case DATA_SOURCE_ENUM.SQLSERVER_2017_LATER: {
                if (!sourceId || !table) {
                    message.error('??????????????????????????????????????????');
                    return;
                }
                nextParams = { sourceId, tableName: table, schema };
                break;
            }
            default:
                break;
        }

        setVisible(true);
        setParams(nextParams);
    };

    return (
        <>
            <FormItem label="????????????" name={[index, 'type']} rules={[{ required: true, message: '?????????????????????' }]}>
                <Select
                    showSearch
                    filterOption={(input: any, option: any) =>
                        option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                    }
                >
                    {taskRenderService.getState().supportSourceList.flinkSqlSides.map((v) => (
                        <Option value={v} key={v}>
                            {DATA_SOURCE_TEXT[v]}
                        </Option>
                    ))}
                </Select>
            </FormItem>
            <FormItem label="?????????" name={[index, 'sourceId']} rules={[{ required: true, message: '??????????????????' }]}>
                <Select
                    placeholder="??????????????????"
                    showSearch
                    filterOption={(input: any, option: any) =>
                        option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                    }
                >
                    {sourceOptions.map((v) => (
                        <Option key={v.dataInfoId} value={v.dataInfoId}>
                            {v.dataName}
                        </Option>
                    ))}
                </Select>
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) =>
                    isShowSchema(getFieldValue(NAME_FIELD)[index].type) && (
                        <FormItem
                            label="Schema"
                            name={[index, 'schema']}
                            rules={[
                                {
                                    required: isSchemaRequired(getFieldValue('type')),
                                    message: '?????????Schema',
                                },
                            ]}
                        >
                            <Select
                                showSearch
                                placeholder="?????????Schema"
                                allowClear
                                filterOption={(input: any, option: any) =>
                                    option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                }
                            >
                                {schemaOptions.map((v) => (
                                    <Option key={v} value={v}>
                                        {v}
                                    </Option>
                                ))}
                            </Select>
                        </FormItem>
                    )
                }
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) => {
                    const { type } = getFieldValue(NAME_FIELD)[index] as IFormFieldProps;
                    switch (type) {
                        case DATA_SOURCE_ENUM.REDIS:
                        case DATA_SOURCE_ENUM.UPRedis: {
                            return (
                                <FormItem
                                    label="???"
                                    name={[index, 'table']}
                                    rules={[{ required: true, message: '???????????????' }]}
                                >
                                    <Input placeholder="???????????????" />
                                </FormItem>
                            );
                        }
                        case DATA_SOURCE_ENUM.ES6:
                        case DATA_SOURCE_ENUM.ES7: {
                            return null;
                        }
                        default: {
                            return (
                                <FormItem
                                    label="???"
                                    name={[index, 'table']}
                                    rules={[{ required: true, message: '????????????' }]}
                                >
                                    <Select
                                        onSearch={handleSearchTable}
                                        filterOption={false}
                                        showSearch
                                        placeholder="????????????"
                                    >
                                        {(tableOptions[currentSearchKey.current] || []).map((v) => (
                                            <Option key={v} value={v}>
                                                {v}
                                            </Option>
                                        ))}
                                    </Select>
                                </FormItem>
                            );
                        }
                    }
                }}
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) =>
                    isES(getFieldValue(NAME_FIELD)[index].type) && (
                        <FormItem
                            label="??????"
                            name={[index, 'index']}
                            rules={[{ required: true, message: '???????????????' }]}
                        >
                            <Input placeholder="???????????????" />
                        </FormItem>
                    )
                }
            </FormItem>
            <FormItem
                wrapperCol={{
                    offset: formItemLayout.labelCol.sm.span,
                    span: formItemLayout.wrapperCol.sm.span,
                }}
            >
                <Button block type="link" onClick={showPreviewModal}>
                    ????????????
                </Button>
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) =>
                    isES(getFieldValue(NAME_FIELD)[index].type) &&
                    getFieldValue(NAME_FIELD)[index].type !== DATA_SOURCE_ENUM.ES7 && (
                        <FormItem
                            label="????????????"
                            name={[index, 'esType']}
                            rules={[{ required: true, message: '?????????????????????' }]}
                        >
                            <Input placeholder="?????????????????????" />
                        </FormItem>
                    )
                }
            </FormItem>
            <FormItem
                label="?????????"
                name={[index, 'tableName']}
                rules={[{ required: true, message: '?????????????????????' }]}
            >
                <Input placeholder="?????????????????????" />
            </FormItem>
            <FormItem
                required
                label="??????"
                dependencies={[
                    [index, 'type'],
                    [index, 'columns'],
                ]}
            >
                {({ getFieldValue }) =>
                    isHaveTableColumn(getFieldValue(NAME_FIELD)[index].type) ? (
                        <div className="column-container">
                            <Table
                                rowKey="column"
                                dataSource={getFieldValue(NAME_FIELD)[index].columns || []}
                                pagination={false}
                                size="small"
                            >
                                <Table.Column
                                    title="??????"
                                    dataIndex="column"
                                    key="??????"
                                    width="35%"
                                    render={(text, _, i) => {
                                        return (
                                            <Select
                                                value={text}
                                                style={{ maxWidth: 74 }}
                                                onChange={(value) =>
                                                    handleColsChanged(ColOperatorKind.SET_COL, i, value)
                                                }
                                                showSearch
                                            >
                                                {columnsOptions.map((col) => (
                                                    <Option key={col.key} value={col.key}>
                                                        <Tooltip placement="topLeft" title={col.key}>
                                                            {col.key}
                                                        </Tooltip>
                                                    </Option>
                                                ))}
                                            </Select>
                                        );
                                    }}
                                />
                                <Table.Column
                                    title="??????"
                                    dataIndex="type"
                                    key="??????"
                                    width="25%"
                                    render={(text, _, i) => (
                                        <span
                                            className={
                                                text?.toLowerCase() === 'Not Support'.toLowerCase() ? 'has-error' : ''
                                            }
                                        >
                                            <Tooltip title={text} trigger="hover" placement="topLeft">
                                                <Input
                                                    value={text}
                                                    onChange={(e) =>
                                                        handleColsChanged(ColOperatorKind.SET_TYPE, i, e.target.value)
                                                    }
                                                />
                                            </Tooltip>
                                        </span>
                                    )}
                                />
                                <Table.Column
                                    title={
                                        <div>
                                            <Tooltip placement="top" title={targetColText} arrowPointAtCenter>
                                                <span>
                                                    ?????? &nbsp;
                                                    <QuestionCircleOutlined />
                                                </span>
                                            </Tooltip>
                                        </div>
                                    }
                                    dataIndex="targetCol"
                                    key="??????"
                                    width="30%"
                                    render={(text, _, i) => {
                                        return (
                                            <Input
                                                value={text}
                                                onChange={(e) =>
                                                    handleColsChanged(ColOperatorKind.SET_TARGET, i, e.target.value)
                                                }
                                            />
                                        );
                                    }}
                                />
                                <Table.Column
                                    key="delete"
                                    render={(_, __, i) => {
                                        return (
                                            <CloseOutlined
                                                style={{
                                                    fontSize: 12,
                                                    color: 'var(--editor-foreground)',
                                                }}
                                                onClick={() => handleColsChanged(ColOperatorKind.REMOVE, i)}
                                            />
                                        );
                                    }}
                                />
                            </Table>
                            <div style={{ padding: '0 20 20' }}>
                                <div className="column-btn">
                                    <span>
                                        <a onClick={() => handleColsChanged(ColOperatorKind.ADD)}>????????????</a>
                                    </span>
                                    <span>
                                        <a
                                            onClick={() => handleColsChanged(ColOperatorKind.ADD_ALL)}
                                            style={{ marginRight: 12 }}
                                        >
                                            ??????????????????
                                        </a>
                                        <Popconfirm
                                            title="???????????????????????????"
                                            onConfirm={() => handleColsChanged(ColOperatorKind.REMOVE_ALL)}
                                            okText="??????"
                                            cancelText="??????"
                                        >
                                            <a>??????</a>
                                        </Popconfirm>
                                    </span>
                                </div>
                            </div>
                        </div>
                    ) : (
                        <Editor
                            style={{
                                height: '100%',
                            }}
                            sync
                        />
                    )
                }
            </FormItem>
            <FormItem hidden name={[index, 'columns']} />
            <FormItem
                noStyle
                dependencies={[
                    [index, 'type'],
                    [index, 'columns'],
                ]}
            >
                {({ getFieldValue }) => {
                    const { type, columns = [] } = getFieldValue(NAME_FIELD)[index] as IFormFieldProps;
                    switch (type) {
                        case DATA_SOURCE_ENUM.KUDU:
                        case DATA_SOURCE_ENUM.POSTGRESQL:
                        case DATA_SOURCE_ENUM.CLICKHOUSE:
                        case DATA_SOURCE_ENUM.ORACLE:
                        case DATA_SOURCE_ENUM.POLAR_DB_For_MySQL:
                        case DATA_SOURCE_ENUM.MYSQL:
                        case DATA_SOURCE_ENUM.UPDRDB:
                        case DATA_SOURCE_ENUM.TIDB:
                        case DATA_SOURCE_ENUM.IMPALA:
                        case DATA_SOURCE_ENUM.INCEPTOR:
                        case DATA_SOURCE_ENUM.KINGBASE8:
                        case DATA_SOURCE_ENUM.SQLSERVER:
                        case DATA_SOURCE_ENUM.SQLSERVER_2017_LATER: {
                            return (
                                <FormItem label="??????" name={[index, 'primaryKey']}>
                                    <Select
                                        mode="multiple"
                                        showSearch
                                        showArrow
                                        filterOption={(input: any, option: any) =>
                                            option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                        }
                                    >
                                        {columns.map((v) => (
                                            <Option key={v.column} value={v.column}>
                                                {v.column}
                                            </Option>
                                        )) || []}
                                    </Select>
                                </FormItem>
                            );
                        }
                        case DATA_SOURCE_ENUM.ES6:
                        case DATA_SOURCE_ENUM.ES7: {
                            return (
                                <FormItem name={[index, 'primaryKey']} label="??????">
                                    <Input placeholder="???????????????" />
                                </FormItem>
                            );
                        }
                        case DATA_SOURCE_ENUM.MONGODB:
                        case DATA_SOURCE_ENUM.REDIS:
                        case DATA_SOURCE_ENUM.UPRedis: {
                            return (
                                <FormItem
                                    label="??????"
                                    name={[index, 'primaryKey']}
                                    rules={[{ required: true, message: '???????????????' }]}
                                >
                                    <Input
                                        placeholder={
                                            type === DATA_SOURCE_ENUM.MONGODB
                                                ? '???????????????'
                                                : '????????????????????????????????????????????????'
                                        }
                                    />
                                </FormItem>
                            );
                        }
                        case DATA_SOURCE_ENUM.HBASE:
                        case DATA_SOURCE_ENUM.TBDS_HBASE:
                        case DATA_SOURCE_ENUM.HBASE_HUAWEI: {
                            return (
                                <FormItem
                                    label="??????"
                                    tooltip={
                                        isFlink112 && (
                                            <React.Fragment>
                                                Hbase ????????????????????????????????????&nbsp;
                                                <a href={HELP_DOC_URL.HBASE} target="_blank" rel="noopener noreferrer">
                                                    ????????????
                                                </a>
                                            </React.Fragment>
                                        )
                                    }
                                >
                                    <div style={{ display: 'flex' }}>
                                        <FormItem
                                            style={{ flex: 1 }}
                                            name={[index, 'hbasePrimaryKey']}
                                            rules={[
                                                { required: true, message: '???????????????' },
                                                isFlink112
                                                    ? {
                                                          pattern: /^\w{1,64}$/,
                                                          message: '?????????????????????????????????????????????????????????64?????????',
                                                      }
                                                    : {},
                                            ]}
                                        >
                                            <Input placeholder="???????????????" />
                                        </FormItem>
                                        {isFlink112 && (
                                            <>
                                                <span>&nbsp; ?????????</span>
                                                <FormItem
                                                    style={{ flex: 1 }}
                                                    name={[index, 'hbasePrimaryKeyType']}
                                                    rules={[
                                                        {
                                                            required: true,
                                                            message: '???????????????',
                                                        },
                                                    ]}
                                                >
                                                    <Input placeholder="???????????????" />
                                                </FormItem>
                                            </>
                                        )}
                                    </div>
                                </FormItem>
                            );
                        }
                        default:
                            return null;
                    }
                }}
            </FormItem>
            <FormItem name={[index, 'parallelism']} label="?????????">
                <InputNumber style={{ width: '100%' }} min={1} />
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) => (
                    <FormItem
                        label="????????????"
                        name={[index, 'cache']}
                        rules={[{ required: true, message: '?????????????????????' }]}
                    >
                        <Select
                            placeholder="?????????"
                            showSearch
                            filterOption={(input: any, option: any) =>
                                option.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                            }
                        >
                            <Option key="None" value="None" disabled={isCacheOnlyAll(getFieldValue('type'))}>
                                None
                            </Option>
                            <Option key="LRU" value="LRU" disabled={isCacheExceptLRU(getFieldValue('type'))}>
                                LRU
                            </Option>
                            <Option key="ALL" value="ALL">
                                ALL
                            </Option>
                        </Select>
                    </FormItem>
                )}
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'cache']]}>
                {({ getFieldValue }) => {
                    switch (getFieldValue(NAME_FIELD)[index].cache) {
                        case 'LRU':
                            return (
                                <>
                                    <FormItem
                                        label="????????????(???)"
                                        name={[index, 'cacheSize']}
                                        rules={[{ required: true, message: '?????????????????????' }]}
                                    >
                                        <InputNumber style={{ width: '100%' }} min={0} />
                                    </FormItem>
                                    <FormItem
                                        label="??????????????????"
                                        name={[index, 'cacheTTLMs']}
                                        rules={[{ required: true, message: '???????????????????????????' }]}
                                    >
                                        <InputNumber style={{ width: '100%' }} min={0} addonAfter="ms" />
                                    </FormItem>
                                </>
                            );

                        case 'ALL':
                            return (
                                <FormItem
                                    label="??????????????????"
                                    name={[index, 'cacheTTLMs']}
                                    rules={[{ required: true, message: '???????????????????????????' }]}
                                >
                                    <InputNumber style={{ width: '100%' }} min={0} addonAfter="ms" />
                                </FormItem>
                            );
                        default:
                            break;
                    }
                }}
            </FormItem>
            <FormItem label="??????????????????" tooltip={asyncTimeoutNumDoc} name={[index, 'errorLimit']}>
                <InputNumber style={{ width: '100%' }} placeholder="??????????????????" min={0} />
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) =>
                    getFieldValue(NAME_FIELD)[index].type === DATA_SOURCE_ENUM.KUDU && (
                        <FormItem label="????????????" tooltip={queryFault} name={[index, 'isFaultTolerant']}>
                            <Switch />
                        </FormItem>
                    )
                }
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) =>
                    isHaveAsyncPoolSize(getFieldValue(NAME_FIELD)[index].type) && (
                        <FormItem name={[index, 'asyncPoolSize']} label="???????????????">
                            <Select>
                                {createSeries(20).map((opt) => {
                                    return (
                                        <Option key={opt} value={opt}>
                                            {opt}
                                        </Option>
                                    );
                                })}
                            </Select>
                        </FormItem>
                    )
                }
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) =>
                    isHaveCustomParams(getFieldValue(NAME_FIELD)[index].type) && <CustomParams index={index} />
                }
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) => (
                    <DataPreviewModal
                        visible={visible}
                        type={getFieldValue(NAME_FIELD)[index].type}
                        onCancel={() => setVisible(false)}
                        params={params}
                    />
                )}
            </FormItem>
        </>
    );
}
