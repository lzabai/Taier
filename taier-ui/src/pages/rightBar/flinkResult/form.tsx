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

import React, { useContext, useMemo, useRef, useState } from 'react';
import {
    DATA_SOURCE_ENUM,
    DATA_SOURCE_TEXT,
    DATA_SOURCE_VERSION,
    defaultColsText,
    DEFAULT_MAPPING_TEXT,
    FLINK_VERSIONS,
    formItemLayout,
    hbaseColsText,
    hbaseColsText112,
    HELP_DOC_URL,
    KAFKA_DATA_LIST,
    KAFKA_DATA_TYPE,
} from '@/constant';
import {
    isHaveCollection,
    isHaveDataPreview,
    isHaveParallelism,
    isHavePrimaryKey,
    isHaveTableColumn,
    isHaveTableList,
    isHaveTopic,
    isHaveUpdateMode,
    isHaveUpdateStrategy,
    isHaveUpsert,
    isAvro,
    isES,
    isHbase,
    isKafka,
    isSqlServer,
    isShowBucket,
    isShowSchema,
    isRedis,
    isRDB,
} from '@/utils/is';
import type { FormInstance } from 'antd';
import { Button, Checkbox, Form, Input, InputNumber, message, Popconfirm, Radio, Select, Table, Tooltip } from 'antd';
import { CloseOutlined, UpOutlined, DownOutlined } from '@ant-design/icons';
import Column from 'antd/lib/table/Column';
import { debounce, isUndefined } from 'lodash';
import { getColumnsByColumnsText } from '@/utils';
import { CustomParams } from '../customParams';
import type { IDataColumnsProps, IDataSourceUsedInSyncProps, IFlinkSinkProps } from '@/interface';
import Editor from '@/components/editor';
import { NAME_FIELD } from '.';
import { FormContext } from '@/services/rightBarService';
import DataPreviewModal from '@/pages/editor/streamCollection/source/dataPreviewModal';
import { taskRenderService } from '@/services';

const FormItem = Form.Item;
const { Option } = Select;

interface IResultProps {
    /**
     * Form ?????? name ??????
     */
    index: number;
    /**
     * ?????????????????????
     */
    dataSourceOptionList: IDataSourceUsedInSyncProps[];
    tableOptionType: Record<string, string[]>;
    /**
     * ???????????????
     */
    tableColumnOptionType: IDataColumnsProps[];
    /**
     * topic ????????????
     */
    topicOptionType: string[];
    /**
     * ?????? flink ??????
     */
    componentVersion?: Valueof<typeof FLINK_VERSIONS>;
    getTableType: (params: { sourceId: number; type: DATA_SOURCE_ENUM; schema?: string }, searchKey?: string) => void;
    /**
     * columns ?????????????????????
     */
    onColumnsChange?: (changedValues: any, values: any) => void;
}

enum COLUMNS_OPERATORS {
    /**
     * ??????????????????
     */
    ADD_ONE_LINE,
    /**
     * ??????????????????
     */
    ADD_ALL_LINES,
    /**
     * ??????????????????
     */
    DELETE_ALL_LINES,
    /**
     * ??????????????????
     */
    DELETE_ONE_LINE,
    /**
     * ????????????
     */
    CHANGE_ONE_LINE,
}

/**
 * ??????????????????????????????
 */
const isDisabledUpdateMode = (type: DATA_SOURCE_ENUM, isHiveTable?: boolean, version?: string): boolean => {
    if (type === DATA_SOURCE_ENUM.IMPALA) {
        if (isUndefined(isHiveTable) || isHiveTable === true) {
            return true;
        }
        if (isHiveTable === false) {
            return false;
        }

        return false;
    }

    return !isHaveUpsert(type, version);
};

/**
 * ?????? type ????????????????????? Option ??????
 */
const originOption = (type: string, arrData: any[]) => {
    switch (type) {
        case 'currencyType':
            return arrData.map((v) => {
                return (
                    <Option key={v} value={`${v}`}>
                        <Tooltip placement="topLeft" title={v}>
                            <span className="panel-tooltip">{v}</span>
                        </Tooltip>
                    </Option>
                );
            });
        case 'columnType':
            return arrData.map((v) => {
                return (
                    <Option key={v.key} value={`${v.key}`}>
                        <Tooltip placement="topLeft" title={v.key}>
                            <span className="panel-tooltip">{v.key}</span>
                        </Tooltip>
                    </Option>
                );
            });
        case 'primaryType':
            return arrData.map((v) => {
                return (
                    <Option key={v.column} value={`${v.column}`}>
                        {v.column}
                    </Option>
                );
            });
        case 'kafkaPrimaryType':
            return arrData.map((v) => {
                return (
                    <Option key={v.field} value={`${v.field}`}>
                        {v.field}
                    </Option>
                );
            });
        default:
            return null;
    }
};

export default function ResultForm({
    index,
    dataSourceOptionList = [],
    tableOptionType = {},
    tableColumnOptionType = [],
    topicOptionType = [],
    componentVersion = FLINK_VERSIONS.FLINK_1_12,
    getTableType,
    onColumnsChange,
}: IResultProps) {
    const { form } = useContext(FormContext) as {
        form?: FormInstance<{ [NAME_FIELD]: Partial<IFlinkSinkProps>[] }>;
    };
    const [visible, setVisible] = useState(false);
    const [params, setParams] = useState<Record<string, any>>({});
    const [showAdvancedParams, setShowAdvancedParams] = useState(false);
    const searchKey = useRef('');

    // ???????????????
    const debounceHandleTableSearch = debounce((value: string) => {
        const currentData = form?.getFieldsValue()[NAME_FIELD][index];
        if (currentData?.sourceId) {
            searchKey.current = value;
            getTableType(
                {
                    sourceId: currentData.sourceId,
                    type: currentData.type!,
                    schema: currentData.schema,
                },
                value
            );
        }
    }, 300);

    const getPlaceholder = (sourceType: DATA_SOURCE_ENUM) => {
        if (isHbase(sourceType)) {
            return componentVersion === FLINK_VERSIONS.FLINK_1_12 ? hbaseColsText112 : hbaseColsText;
        }
        return defaultColsText;
    };

    const showPreviewModal = () => {
        if (!form?.getFieldValue(NAME_FIELD)[index]) return;
        const { sourceId, index: tableIndex, table, type, schema } = form.getFieldValue(NAME_FIELD)[index];
        let nextParams: Record<string, any> = {};

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
            case DATA_SOURCE_ENUM.HIVE:
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

    const renderTableOptions = () =>
        tableOptionType[searchKey.current]?.map((v) => (
            <Option key={v} value={`${v}`}>
                {v}
            </Option>
        )) || [];

    const handleColumnsChanged = (
        ops: COLUMNS_OPERATORS,
        i?: number,
        value?: Partial<{
            type: string;
            column: string | number;
        }>
    ) => {
        switch (ops) {
            case COLUMNS_OPERATORS.ADD_ALL_LINES: {
                const nextValue = form!.getFieldsValue();
                nextValue[NAME_FIELD][index].columns = tableColumnOptionType.map((column) => ({
                    column: column.key,
                    type: column.type,
                }));
                form!.setFieldsValue({ ...nextValue });

                // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                const changedValue: any[] = [];
                changedValue[index] = {
                    columns: nextValue[NAME_FIELD][index].columns,
                };
                onColumnsChange?.({ [NAME_FIELD]: changedValue }, form?.getFieldsValue());
                break;
            }

            case COLUMNS_OPERATORS.DELETE_ALL_LINES: {
                const nextValue = form!.getFieldsValue();
                nextValue[NAME_FIELD][index].columns = [];
                nextValue[NAME_FIELD][index].primaryKey = [];
                form!.setFieldsValue({ ...nextValue });

                // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                const changedValue: any[] = [];
                changedValue[index] = {
                    columns: [],
                    primaryKey: [],
                };
                onColumnsChange?.({ [NAME_FIELD]: changedValue }, form?.getFieldsValue());
                break;
            }

            case COLUMNS_OPERATORS.ADD_ONE_LINE: {
                const nextValue = form!.getFieldsValue();
                nextValue[NAME_FIELD][index].columns = nextValue[NAME_FIELD][index].columns || [];
                nextValue[NAME_FIELD][index].columns!.push({});
                form!.setFieldsValue({ ...nextValue });

                // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                const changedValue: any[] = [];
                changedValue[index] = {
                    columns: nextValue[NAME_FIELD][index].columns,
                };
                onColumnsChange?.({ [NAME_FIELD]: changedValue }, form?.getFieldsValue());
                break;
            }

            case COLUMNS_OPERATORS.DELETE_ONE_LINE: {
                const nextValue = form!.getFieldsValue();
                const deleteCol = nextValue[NAME_FIELD][index].columns?.splice(i!, 1) || [];
                // ????????????????????????????????????????????? primaryKey ?????????
                if (deleteCol.length) {
                    const { primaryKey } = nextValue[NAME_FIELD][index];
                    if (
                        Array.isArray(primaryKey) &&
                        primaryKey.findIndex((key) => key === deleteCol[0].column) !== -1
                    ) {
                        const idx = primaryKey.findIndex((key) => key === deleteCol[0].column);
                        primaryKey.splice(idx, 1);
                    }
                }
                form!.setFieldsValue({ ...nextValue });

                // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                const changedValue: any[] = [];
                changedValue[index] = {
                    columns: nextValue[NAME_FIELD][index].columns,
                    primaryKey: nextValue[NAME_FIELD][index].primaryKey,
                };
                onColumnsChange?.({ [NAME_FIELD]: changedValue }, form?.getFieldsValue());

                break;
            }

            case COLUMNS_OPERATORS.CHANGE_ONE_LINE: {
                const nextValue = form!.getFieldsValue();
                nextValue[NAME_FIELD][index].columns![i!] = value!;
                form!.setFieldsValue({ ...nextValue });

                // ?????? setFieldsValue ????????????????????? onValuesChange ??????????????????????????? columns ????????? tab ???
                const changedValue: any[] = [];
                changedValue[index] = {
                    columns: nextValue[NAME_FIELD][index].columns,
                };
                onColumnsChange?.({ [NAME_FIELD]: changedValue }, form?.getFieldsValue());
                break;
            }

            default:
                break;
        }
    };

    const topicOptionTypes = originOption('currencyType', topicOptionType);
    const tableColumnOptionTypes = originOption('columnType', tableColumnOptionType);

    // isShowPartition ??? false ??? kudu ???
    const disableUpdateMode = false;

    // ????????????
    const data = form?.getFieldsValue()[NAME_FIELD][index];

    const schemaRequired = data?.type
        ? [
              DATA_SOURCE_ENUM.POSTGRESQL,
              DATA_SOURCE_ENUM.KINGBASE8,
              DATA_SOURCE_ENUM.SQLSERVER,
              DATA_SOURCE_ENUM.SQLSERVER_2017_LATER,
          ].includes(data?.type)
        : false;

    const isFlink112 = useMemo(() => componentVersion === FLINK_VERSIONS.FLINK_1_12, [componentVersion]);

    const primaryKeyOptionTypes = useMemo(
        () =>
            isFlink112 && isKafka(data?.type)
                ? originOption('kafkaPrimaryType', getColumnsByColumnsText(data?.columnsText))
                : originOption('primaryType', data?.columns || []),
        [isFlink112, data]
    );

    return (
        <>
            <FormItem label="????????????" name={[index, 'type']} rules={[{ required: true, message: '?????????????????????' }]}>
                <Select
                    className="right-select"
                    showSearch
                    style={{ width: '100%' }}
                    filterOption={(input, option) =>
                        option?.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                    }
                >
                    {taskRenderService.getState().supportSourceList.flinkSqlSinks.map((item) => (
                        <Option key={item} value={item}>
                            {DATA_SOURCE_TEXT[item]}
                        </Option>
                    ))}
                </Select>
            </FormItem>
            <FormItem label="?????????" name={[index, 'sourceId']} rules={[{ required: true, message: '??????????????????' }]}>
                <Select
                    showSearch
                    placeholder="??????????????????"
                    className="right-select"
                    filterOption={(input, option) =>
                        option?.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                    }
                >
                    {dataSourceOptionList.map((v) => (
                        <Option key={v.dataInfoId} value={v.dataInfoId}>
                            {v.dataName}
                            {DATA_SOURCE_VERSION[v.dataTypeCode] && ` (${DATA_SOURCE_VERSION[v.dataTypeCode]})`}
                        </Option>
                    ))}
                </Select>
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) => (
                    <>
                        {isHaveCollection(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem
                                label="Collection"
                                name={[index, 'collection']}
                                rules={[{ required: true, message: '?????????Collection' }]}
                            >
                                <Select
                                    showSearch
                                    allowClear
                                    placeholder="?????????Collection"
                                    className="right-select"
                                    filterOption={(input, option) =>
                                        option?.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                    }
                                >
                                    {renderTableOptions()}
                                </Select>
                            </FormItem>
                        )}
                        {isShowBucket(getFieldValue(NAME_FIELD)[index].type) && (
                            <>
                                <FormItem
                                    label="Bucket"
                                    name={[index, 'bucket']}
                                    rules={[
                                        {
                                            required: Boolean(schemaRequired),
                                            message: '?????????Bucket',
                                        },
                                    ]}
                                >
                                    <Select showSearch allowClear placeholder="?????????Bucket" className="right-select">
                                        {renderTableOptions()}
                                    </Select>
                                </FormItem>
                                <FormItem
                                    label="ObjectName"
                                    name={[index, 'objectName']}
                                    rules={[{ required: true, message: '?????????ObjectName' }]}
                                    tooltip="????????????????????????txt???????????????S3 Bucket???"
                                >
                                    <Input placeholder="?????????ObjectName" style={{ width: '90%' }} />
                                </FormItem>
                            </>
                        )}
                        {isShowSchema(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem
                                label="Schema"
                                name={[index, 'schema']}
                                rules={[
                                    {
                                        required: Boolean(schemaRequired),
                                        message: '?????????Schema',
                                    },
                                ]}
                            >
                                <Select
                                    showSearch
                                    allowClear
                                    placeholder="?????????Schema"
                                    className="right-select"
                                    options={[]}
                                />
                            </FormItem>
                        )}
                        {isHaveTopic(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem
                                label="Topic"
                                name={[index, 'topic']}
                                rules={[{ required: true, message: '?????????Topic' }]}
                            >
                                <Select placeholder="?????????Topic" className="right-select" showSearch>
                                    {topicOptionTypes}
                                </Select>
                            </FormItem>
                        )}
                        {isHaveTableList(getFieldValue(NAME_FIELD)[index].type) &&
                            ![DATA_SOURCE_ENUM.S3, DATA_SOURCE_ENUM.CSP_S3].includes(
                                getFieldValue(NAME_FIELD)[index].type
                            ) && (
                                <FormItem
                                    label="???"
                                    name={[index, 'table']}
                                    rules={[{ required: true, message: '????????????' }]}
                                >
                                    <Select
                                        showSearch
                                        placeholder="????????????"
                                        className="right-select"
                                        onSearch={(value: string) => debounceHandleTableSearch(value)}
                                        filterOption={false}
                                    >
                                        {renderTableOptions()}
                                    </Select>
                                </FormItem>
                            )}
                        {isRedis(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem
                                label="???"
                                name={[index, 'table']}
                                rules={[{ required: true, message: '???????????????' }]}
                            >
                                <Input placeholder="???????????????" />
                            </FormItem>
                        )}
                        {isES(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem
                                label="??????"
                                tooltip={
                                    <span>
                                        {'????????????{column_name}?????????????????????????????????????????????????????????????????????????????????'}
                                        <a rel="noopener noreferrer" target="_blank" href={HELP_DOC_URL.INDEX}>
                                            ????????????
                                        </a>
                                    </span>
                                }
                                name={[index, 'index']}
                                rules={[{ required: true, message: '???????????????' }]}
                            >
                                <Input placeholder="???????????????" />
                            </FormItem>
                        )}
                        {isHaveDataPreview(getFieldValue(NAME_FIELD)[index].type) && (
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
                        )}
                        {isRedis(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem
                                label="??????"
                                name={[index, 'primaryKey']}
                                rules={[{ required: true, message: '???????????????' }]}
                            >
                                <Input placeholder="???????????????????????????????????????????????????" />
                            </FormItem>
                        )}
                        {isES(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem
                                label="id"
                                tooltip="id????????????????????????????????????????????????0?????????"
                                name={[index, 'esId']}
                            >
                                <Input placeholder="?????????id" />
                            </FormItem>
                        )}
                        {[DATA_SOURCE_ENUM.ES, DATA_SOURCE_ENUM.ES6].includes(
                            getFieldValue(NAME_FIELD)[index].type
                        ) && (
                            <FormItem
                                label="????????????"
                                name={[index, 'esType']}
                                rules={[{ required: true, message: '?????????????????????' }]}
                            >
                                <Input placeholder="?????????????????????" />
                            </FormItem>
                        )}
                        {getFieldValue(NAME_FIELD)[index].type === DATA_SOURCE_ENUM.HBASE && (
                            <FormItem
                                label="rowKey"
                                tooltip={
                                    isFlink112 ? (
                                        <>
                                            Hbase ??? rowkey ???????????????????????????&nbsp;
                                            <a href={HELP_DOC_URL.HBASE} target="_blank" rel="noopener noreferrer">
                                                ????????????
                                            </a>
                                        </>
                                    ) : (
                                        "?????????????????????md5(fieldA+fieldB) + fieldC + '????????????'"
                                    )
                                }
                            >
                                <div style={{ display: 'flex' }}>
                                    <FormItem
                                        style={{ flex: 1 }}
                                        name={[index, 'rowKey']}
                                        rules={[
                                            { required: true, message: '?????????rowKey' },
                                            isFlink112
                                                ? {
                                                      pattern: /^\w{1,64}$/,
                                                      message: '?????????????????????????????????????????????????????????64?????????',
                                                  }
                                                : {},
                                        ]}
                                    >
                                        <Input
                                            placeholder={
                                                isFlink112 ? '????????? rowkey' : 'rowKey ?????????????????????1+????????????2'
                                            }
                                        />
                                    </FormItem>
                                    {isFlink112 && (
                                        <>
                                            <span>&nbsp; ?????????</span>
                                            <FormItem
                                                style={{ flex: 1 }}
                                                name={[index, 'rowKeyType']}
                                                rules={[
                                                    {
                                                        required: true,
                                                        message: '?????????rowKey??????',
                                                    },
                                                ]}
                                            >
                                                <Input placeholder="???????????????" />
                                            </FormItem>
                                        </>
                                    )}
                                </div>
                            </FormItem>
                        )}
                        {[DATA_SOURCE_ENUM.TBDS_HBASE, DATA_SOURCE_ENUM.HBASE_HUAWEI].includes(
                            getFieldValue(NAME_FIELD)[index].type
                        ) && (
                            <FormItem
                                label="rowKey"
                                tooltip="?????????????????????md5(fieldA+fieldB) + fieldC + '????????????'"
                                name={[index, 'rowKey']}
                                rules={[{ required: true, message: '?????????rowKey' }]}
                            >
                                <Input placeholder="rowKey ?????????????????????1+????????????2 " />
                            </FormItem>
                        )}
                    </>
                )}
            </FormItem>
            <FormItem
                label="?????????"
                name={[index, 'tableName']}
                rules={[{ required: true, message: '?????????????????????' }]}
            >
                <Input placeholder="?????????????????????" />
            </FormItem>
            {/* ?????? columns ??????????????? table ?????? */}
            <FormItem hidden name="columns" />
            <FormItem
                label="??????"
                required
                dependencies={[
                    [index, 'type'],
                    [index, 'columns'],
                ]}
            >
                {({ getFieldValue }) =>
                    isHaveTableColumn(getFieldValue(NAME_FIELD)[index].type) ? (
                        <div className="column-container">
                            <Table<IFlinkSinkProps['columns'][number]>
                                rowKey="column"
                                dataSource={getFieldValue(NAME_FIELD)[index].columns || []}
                                pagination={false}
                                size="small"
                            >
                                <Column<IFlinkSinkProps['columns'][number]>
                                    title="??????"
                                    dataIndex="column"
                                    key="??????"
                                    width="45%"
                                    render={(text, record, i) => {
                                        return (
                                            <Select
                                                value={text}
                                                showSearch
                                                className="sub-right-select column-table__select"
                                                onChange={(val) =>
                                                    handleColumnsChanged(COLUMNS_OPERATORS.CHANGE_ONE_LINE, i, {
                                                        column: val,
                                                        // assign type automatically
                                                        type: tableColumnOptionType.find(
                                                            (c) => c.key.toString() === val
                                                        )?.type,
                                                    })
                                                }
                                            >
                                                {tableColumnOptionTypes}
                                            </Select>
                                        );
                                    }}
                                />
                                <Column<IFlinkSinkProps['columns'][number]>
                                    title="??????"
                                    dataIndex="type"
                                    key="??????"
                                    width="45%"
                                    render={(text: string, record, i) => (
                                        <span
                                            className={
                                                text?.toLowerCase() === 'Not Support'.toLowerCase() ? 'has-error' : ''
                                            }
                                        >
                                            <Tooltip
                                                title={text}
                                                trigger={'hover'}
                                                placement="topLeft"
                                                overlayClassName="numeric-input"
                                            >
                                                <Input
                                                    value={text}
                                                    className="column-table__input"
                                                    onChange={(e) => {
                                                        handleColumnsChanged(COLUMNS_OPERATORS.CHANGE_ONE_LINE, i, {
                                                            ...record,
                                                            type: e.target.value,
                                                        });
                                                    }}
                                                />
                                            </Tooltip>
                                        </span>
                                    )}
                                />
                                <Column
                                    key="delete"
                                    render={(_, __, i) => {
                                        return (
                                            <CloseOutlined
                                                style={{
                                                    fontSize: 12,
                                                    color: 'var(--editor-foreground)',
                                                }}
                                                onClick={() =>
                                                    handleColumnsChanged(COLUMNS_OPERATORS.DELETE_ONE_LINE, i)
                                                }
                                            />
                                        );
                                    }}
                                />
                            </Table>
                            <div className="column-btn">
                                <span>
                                    <a onClick={() => handleColumnsChanged(COLUMNS_OPERATORS.ADD_ONE_LINE)}>????????????</a>
                                </span>
                                <span>
                                    <a
                                        onClick={() => handleColumnsChanged(COLUMNS_OPERATORS.ADD_ALL_LINES)}
                                        style={{ marginRight: 12 }}
                                    >
                                        ??????????????????
                                    </a>
                                    {getFieldValue(NAME_FIELD)[index]?.columns?.length ? (
                                        <Popconfirm
                                            title="???????????????????????????"
                                            onConfirm={() => handleColumnsChanged(COLUMNS_OPERATORS.DELETE_ALL_LINES)}
                                            okText="??????"
                                            cancelText="??????"
                                        >
                                            <a>??????</a>
                                        </Popconfirm>
                                    ) : (
                                        <a style={{ color: 'var(--editor-foreground)' }}>??????</a>
                                    )}
                                </span>
                            </div>
                        </div>
                    ) : (
                        <FormItem name="columnsText" noStyle>
                            <Editor
                                style={{
                                    minHeight: 202,
                                }}
                                sync
                                options={{
                                    minimap: {
                                        enabled: false,
                                    },
                                }}
                                placeholder={getPlaceholder(getFieldValue(NAME_FIELD)[index].type!)}
                            />
                        </FormItem>
                    )
                }
            </FormItem>
            <FormItem noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) => (
                    <>
                        {isKafka(getFieldValue(NAME_FIELD)[index].type) && (
                            <React.Fragment>
                                <FormItem
                                    label="????????????"
                                    name={[index, 'sinkDataType']}
                                    rules={[{ required: true, message: '?????????????????????' }]}
                                >
                                    <Select style={{ width: '100%' }}>
                                        {getFieldValue(NAME_FIELD)[index].type === DATA_SOURCE_ENUM.KAFKA_CONFLUENT ? (
                                            <Option
                                                value={KAFKA_DATA_TYPE.TYPE_AVRO_CONFLUENT}
                                                key={KAFKA_DATA_TYPE.TYPE_AVRO_CONFLUENT}
                                            >
                                                {KAFKA_DATA_TYPE.TYPE_AVRO_CONFLUENT}
                                            </Option>
                                        ) : (
                                            KAFKA_DATA_LIST.map(({ text, value }) => (
                                                <Option value={value} key={text + value}>
                                                    {text}
                                                </Option>
                                            ))
                                        )}
                                    </Select>
                                </FormItem>
                                <FormItem noStyle dependencies={[[index, 'sinkDataType']]}>
                                    {({ getFieldValue: getField }) =>
                                        isAvro(getField(NAME_FIELD)[index].sinkDataType) && (
                                            <FormItem
                                                label="Schema"
                                                name={[index, 'schemaInfo']}
                                                rules={[
                                                    {
                                                        required: !isFlink112,
                                                        message: '?????????Schema',
                                                    },
                                                ]}
                                            >
                                                <Input.TextArea
                                                    rows={9}
                                                    placeholder={`??????Avro Schema????????????????????????\n{\n\t"name": "testAvro",\n\t"type": "record",\n\t"fields": [{\n\t\t"name": "id",\n\t\t"type": "string"\n\t}]\n}`}
                                                />
                                            </FormItem>
                                        )
                                    }
                                </FormItem>
                            </React.Fragment>
                        )}
                        {isHaveUpdateMode(getFieldValue(NAME_FIELD)[index].type) && (
                            <>
                                <FormItem
                                    label="????????????"
                                    name={[index, 'updateMode']}
                                    rules={[{ required: true, message: '?????????????????????' }]}
                                >
                                    <Radio.Group
                                        disabled={isDisabledUpdateMode(
                                            getFieldValue(NAME_FIELD)[index].type,
                                            disableUpdateMode,
                                            componentVersion
                                        )}
                                        className="right-select"
                                    >
                                        <Radio value="append">??????(append)</Radio>
                                        <Radio
                                            value="upsert"
                                            disabled={
                                                getFieldValue(NAME_FIELD)[index].type === DATA_SOURCE_ENUM.CLICKHOUSE
                                            }
                                        >
                                            ??????(upsert)
                                        </Radio>
                                    </Radio.Group>
                                </FormItem>
                                <FormItem noStyle dependencies={[[index, 'updateMode']]}>
                                    {({ getFieldValue: getField }) => (
                                        <>
                                            {getField(NAME_FIELD)[index].updateMode === 'upsert' &&
                                                isHaveUpdateStrategy(getFieldValue(NAME_FIELD)[index].type) && (
                                                    <FormItem
                                                        label="????????????"
                                                        name={[index, 'allReplace']}
                                                        initialValue="false"
                                                        rules={[
                                                            {
                                                                required: true,
                                                                message: '?????????????????????',
                                                            },
                                                        ]}
                                                    >
                                                        <Select className="right-select">
                                                            <Option key="true" value="true">
                                                                Null?????????????????????
                                                            </Option>
                                                            <Option key="false" value="false">
                                                                Null????????????????????????
                                                            </Option>
                                                        </Select>
                                                    </FormItem>
                                                )}
                                            {getField(NAME_FIELD)[index].updateMode === 'upsert' &&
                                                (isHavePrimaryKey(getFieldValue(NAME_FIELD)[index].type) ||
                                                    !isDisabledUpdateMode(
                                                        getFieldValue(NAME_FIELD)[index].type,
                                                        disableUpdateMode,
                                                        componentVersion
                                                    )) && (
                                                    <FormItem
                                                        label="??????"
                                                        tooltip="?????????????????????????????????"
                                                        name={[index, 'primaryKey']}
                                                        rules={[
                                                            {
                                                                required: true,
                                                                message: '???????????????',
                                                            },
                                                        ]}
                                                    >
                                                        <Select
                                                            className="right-select"
                                                            listHeight={200}
                                                            mode="multiple"
                                                            showSearch
                                                            showArrow
                                                            filterOption={(input, option) =>
                                                                option?.props.children
                                                                    .toLowerCase()
                                                                    .indexOf(input.toLowerCase()) >= 0
                                                            }
                                                        >
                                                            {primaryKeyOptionTypes}
                                                        </Select>
                                                    </FormItem>
                                                )}
                                        </>
                                    )}
                                </FormItem>
                            </>
                        )}
                    </>
                )}
            </FormItem>
            {/* ?????????????????? */}
            <FormItem wrapperCol={{ span: 24 }}>
                <Button block type="link" onClick={() => setShowAdvancedParams(!showAdvancedParams)}>
                    ????????????{showAdvancedParams ? <UpOutlined /> : <DownOutlined />}
                </Button>
            </FormItem>
            {/* ?????????????????? */}
            <FormItem hidden={!showAdvancedParams} noStyle dependencies={[[index, 'type']]}>
                {({ getFieldValue }) => (
                    <>
                        {isHaveParallelism(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem name={[index, 'parallelism']} label="?????????">
                                <InputNumber style={{ width: '100%' }} min={1} precision={0} />
                            </FormItem>
                        )}
                        {isES(getFieldValue(NAME_FIELD)[index].type) && isFlink112 && (
                            <FormItem name={[index, 'bulkFlushMaxActions']} label="??????????????????">
                                <InputNumber style={{ width: '100%' }} min={1} max={10000} precision={0} />
                            </FormItem>
                        )}
                        {isKafka(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem label="" name={[index, 'enableKeyPartitions']} valuePropName="checked">
                                <Checkbox style={{ marginLeft: 90 }} defaultChecked={false}>
                                    ????????????(Key)??????
                                </Checkbox>
                            </FormItem>
                        )}
                        {getFieldValue(NAME_FIELD)[index].type === DATA_SOURCE_ENUM.ES7 && (
                            <FormItem
                                label="????????????"
                                tooltip={
                                    <span>
                                        ElasticSearch?????????????????????????????????????????????????????????????????????
                                        <a rel="noopener noreferrer" target="_blank" href={HELP_DOC_URL.INDEX}>
                                            ????????????
                                        </a>
                                    </span>
                                }
                                name={[index, 'indexDefinition']}
                            >
                                <Input.TextArea placeholder={DEFAULT_MAPPING_TEXT} style={{ minHeight: '200px' }} />
                            </FormItem>
                        )}
                        <FormItem noStyle dependencies={[[index, 'enableKeyPartitions']]}>
                            {({ getFieldValue: getField }) =>
                                getField(NAME_FIELD)[index].enableKeyPartitions && (
                                    <FormItem
                                        label="????????????"
                                        name={[index, 'partitionKeys']}
                                        rules={[{ required: true, message: '?????????????????????' }]}
                                    >
                                        <Select
                                            className="right-select"
                                            mode="multiple"
                                            showSearch
                                            showArrow
                                            filterOption={(input, option) =>
                                                option?.props.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                            }
                                        >
                                            {getColumnsByColumnsText(getField(NAME_FIELD)[index].columnsText).map(
                                                (column) => {
                                                    const fields = column.field?.trim();
                                                    return (
                                                        <Option value={fields} key={fields}>
                                                            {fields}
                                                        </Option>
                                                    );
                                                }
                                            )}
                                        </Select>
                                    </FormItem>
                                )
                            }
                        </FormItem>
                        {isRDB(getFieldValue(NAME_FIELD)[index].type) && (
                            <>
                                <FormItem
                                    label="??????????????????"
                                    name={[index, 'batchWaitInterval']}
                                    rules={[{ required: true, message: '???????????????????????????' }]}
                                >
                                    <InputNumber
                                        style={{ width: '100%' }}
                                        min={0}
                                        max={600000}
                                        precision={0}
                                        addonAfter="ms/???"
                                    />
                                </FormItem>
                                <FormItem
                                    label="??????????????????"
                                    name={[index, 'batchSize']}
                                    rules={[{ required: true, message: '???????????????????????????' }]}
                                >
                                    <InputNumber
                                        style={{ width: '100%' }}
                                        min={0}
                                        max={
                                            getFieldValue(NAME_FIELD)[index].type === DATA_SOURCE_ENUM.KUDU
                                                ? 100000
                                                : 10000
                                        }
                                        precision={0}
                                        addonAfter="???/???"
                                    />
                                </FormItem>
                            </>
                        )}
                        {!isHaveParallelism(getFieldValue(NAME_FIELD)[index].type) && (
                            <FormItem
                                label="????????????"
                                tooltip="?????????????????? DAY???HOUR???MINUTE????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"
                                name={[index, 'partitionType']}
                                initialValue="DAY"
                            >
                                <Select className="right-select">
                                    <Option value="DAY">DAY</Option>
                                    <Option value="HOUR">HOUR</Option>
                                    <Option value="MINUTE">MINUTE</Option>
                                </Select>
                            </FormItem>
                        )}
                        {/* ????????????????????? */}
                        {!isSqlServer(getFieldValue(NAME_FIELD)[index].type) && <CustomParams index={index} />}
                    </>
                )}
            </FormItem>
            <FormItem shouldUpdate noStyle>
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
