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

import { useEffect, useMemo, useContext, useRef, useState } from 'react';
import type { FormInstance } from 'antd';
import { Button, Collapse, Form, Popconfirm } from 'antd';
import classNames from 'classnames';
import molecule from '@dtinsight/molecule';
import { DeleteOutlined, PlusOutlined } from '@ant-design/icons';
import { DATA_SOURCE_ENUM, formItemLayout, KAFKA_DATA_TYPE } from '@/constant';
import stream from '@/api';
import {
    isHaveCollection,
    isHavePartition,
    isHaveSchema,
    isHaveTableColumn,
    isHaveTableList,
    isHaveTopic,
    isAvro,
    isKafka,
    isSqlServer,
    isRDB,
} from '@/utils/is';
import ResultForm from './form';
import type { IDataSourceUsedInSyncProps, IFlinkSinkProps } from '@/interface';
import type { IRightBarComponentProps } from '@/services/rightBarService';
import { FormContext } from '@/services/rightBarService';

const { Panel } = Collapse;

export const NAME_FIELD = 'panelColumn';

interface IFormFieldProps {
    [NAME_FIELD]: Partial<IFlinkSinkProps>[];
}

const DEFAULT_INPUT_VALUE: Partial<IFlinkSinkProps> = {
    type: DATA_SOURCE_ENUM.MYSQL,
    columns: [],
    parallelism: 1,
    bulkFlushMaxActions: 100,
    batchWaitInterval: 1000,
    batchSize: 100,
    enableKeyPartitions: false,
    updateMode: 'append',
    allReplace: 'false',
};

export default function FlinkResultPanel({ current }: IRightBarComponentProps) {
    const currentPage = current?.tab?.data || {};
    const { form } = useContext(FormContext) as { form: FormInstance<IFormFieldProps> };

    const [panelActiveKey, setActiveKey] = useState<string[]>([]);
    /**
     * ??????????????????????????? type ????????????
     */
    const [dataSourceList, setDataSourceList] = useState<Record<string, IDataSourceUsedInSyncProps[]>>({});
    /**
     * ???????????????????????????????????? sourceId ??? schema ???????????????????????? searchKey ?????????
     * @example
     * ?????? s ?????????:
     * ```js
     * {
     * 	[sourceId-schema]:{
     * 	  's': any[]
     * 	}
     * }
     * ```
     */
    const [tableOptionList, setTableOptionList] = useState<Record<string, Record<string, any[]>>>({});
    /**
     * ?????????????????????????????? sourceId-table-schema ????????????
     */
    const [tableColumnsList, setTableColumnsList] = useState<Record<string, { key: string; type: string }[]>>({});
    const [topicOptionList, setTopicOptionList] = useState<Record<string, any[]>>({});

    // ??????????????? panel ????????????
    const isAddOrRemove = useRef(false);

    /**
     * ?????????????????????
     */
    const getTypeOriginData = (type?: DATA_SOURCE_ENUM) => {
        if (type !== undefined && !dataSourceList[type]) {
            stream.getTypeOriginData({ type }).then((v) => {
                if (v.code === 1) {
                    setDataSourceList((list) => {
                        const next = { ...list };
                        next[type] = v.data || [];
                        return next;
                    });
                }
            });
        }
    };

    /**
     * ??????Schema??????
     * @deprecated ???????????????????????? schema ??????
     */
    const getSchemaData = (..._args: any[]) => {};

    /**
     * ???????????????
     */
    const getTableType = async (
        params: { sourceId?: number; type: DATA_SOURCE_ENUM; schema?: string },
        searchKey = ''
    ) => {
        // postgresql schema????????????
        const disableReq =
            (params.type === DATA_SOURCE_ENUM.POSTGRESQL ||
                params.type === DATA_SOURCE_ENUM.KINGBASE8 ||
                isSqlServer(params.type)) &&
            !params.schema;

        if (params.sourceId && !disableReq) {
            const res = await stream.listTablesBySchema({
                sourceId: params.sourceId,
                schema: params.schema || '',
                isSys: false,
                searchKey,
            });

            setTableOptionList((list) => {
                const next = { ...list };
                if (!next[`${params.sourceId}-${params.schema || ''}`]) {
                    next[`${params.sourceId}-${params.schema || ''}`] = {};
                }
                next[`${params.sourceId}-${params.schema || ''}`][searchKey] = res.code === 1 ? res.data : [];
                return next;
            });
        }
    };

    /**
     * ?????????????????????
     */
    const getTableColumns = (sourceId?: number, tableName?: string, schema = '') => {
        if (!sourceId || !tableName) {
            return;
        }
        if (!tableColumnsList[`${sourceId}-${tableName}-${schema}`]) {
            stream
                .getStreamTableColumn({
                    sourceId,
                    tableName,
                    schema,
                    flinkVersion: currentPage?.componentVersion,
                })
                .then((v) => {
                    setTableColumnsList((list) => {
                        const next = { ...list };
                        next[`${sourceId}-${tableName}-${schema}`] = v.code === 1 ? v.data : [];
                        return next;
                    });
                });
        }
    };

    /**
     * @deprecated ???????????????????????????
     */
    const loadPartitions = async (..._args: any[]) => {};

    /**
     * ?????? topic ??????
     */
    const getTopicType = (sourceId?: number) => {
        if (sourceId !== undefined && !topicOptionList[sourceId]) {
            stream.getTopicType({ sourceId }).then((v) => {
                setTopicOptionList((list) => {
                    const next = { ...list };
                    next[sourceId] = v.code === 1 ? v.data : [];
                    return next;
                });
            });
        }
    };

    const handlePanelChanged = (type: 'add' | 'delete', panelKey?: string) => {
        if (type === 'add') {
            getTypeOriginData(DEFAULT_INPUT_VALUE.type);
        } else {
            setActiveKey((keys) => keys.filter((key) => panelKey !== key));
        }

        isAddOrRemove.current = true;
    };

    const handleSyncFormToTab = () => {
        const sink = form?.getFieldsValue()[NAME_FIELD];
        // ???????????????????????? tab ???
        molecule.editor.updateTab({
            id: current!.tab!.id,
            data: {
                ...current!.tab!.data,
                sink,
            },
        });
    };

    /**
     * ?????????????????????
     * 1. ?????????????????????????????????
     * 2. ??????????????????????????????
     */
    const handleFormValuesChange = (changedValues: IFormFieldProps, values: IFormFieldProps) => {
        if (isAddOrRemove.current) {
            isAddOrRemove.current = false;
            handleSyncFormToTab();
            return;
        }

        // ?????????????????????????????????
        const changeIndex = changedValues[NAME_FIELD].findIndex((col) => col);
        const changeKeys = Object.keys(changedValues[NAME_FIELD][changeIndex]);

        if (changeKeys.includes('type')) {
            const value = changedValues[NAME_FIELD][changeIndex].type;
            const nextValue = { ...values };

            const kafkaType =
                value === DATA_SOURCE_ENUM.KAFKA_CONFLUENT
                    ? KAFKA_DATA_TYPE.TYPE_AVRO_CONFLUENT
                    : KAFKA_DATA_TYPE.TYPE_JSON;
            // reset fields
            nextValue[NAME_FIELD][changeIndex] = {
                ...DEFAULT_INPUT_VALUE,
                type: value,
                batchWaitInterval: isRDB(value) ? 1000 : undefined,
                batchSize: isRDB(value) ? 100 : undefined,
                sinkDataType: isKafka(value) ? kafkaType : undefined,
            };
            form?.setFieldsValue(nextValue);

            getTypeOriginData(value);
        }

        if (changeKeys.includes('sourceId')) {
            const value = changedValues[NAME_FIELD][changeIndex].sourceId;
            const nextValue = { ...values };

            const kafkaType =
                nextValue[NAME_FIELD][changeIndex].type === DATA_SOURCE_ENUM.KAFKA_CONFLUENT
                    ? KAFKA_DATA_TYPE.TYPE_AVRO_CONFLUENT
                    : KAFKA_DATA_TYPE.TYPE_JSON;
            // reset fields
            nextValue[NAME_FIELD][changeIndex] = {
                ...DEFAULT_INPUT_VALUE,
                type: nextValue[NAME_FIELD][changeIndex].type,
                sourceId: value,
                customParams: nextValue[NAME_FIELD][changeIndex].customParams,
                batchWaitInterval: nextValue[NAME_FIELD][changeIndex].batchWaitInterval,
                batchSize: nextValue[NAME_FIELD][changeIndex].batchSize,
                sinkDataType: isKafka(value) ? kafkaType : undefined,
            };
            form?.setFieldsValue(nextValue);

            const panel = nextValue[NAME_FIELD][changeIndex];
            if (isHaveCollection(panel.type!)) {
                getTableType({ sourceId: value, type: panel.type!, schema: panel.schema });
            }
            if (isHaveTableList(panel.type)) {
                getTableType({ sourceId: value, type: panel.type!, schema: panel.schema });
                if (isHaveSchema(panel.type!)) {
                    getSchemaData();
                }
            }
            if (isHaveTopic(panel.type)) {
                getTopicType(value);
            }
        }

        if (changeKeys.includes('schema')) {
            const value = changedValues[NAME_FIELD][changeIndex].schema;
            const nextValue = { ...values };

            // reset fields
            nextValue[NAME_FIELD][changeIndex] = {
                ...DEFAULT_INPUT_VALUE,
                type: nextValue[NAME_FIELD][changeIndex].type,
                sourceId: nextValue[NAME_FIELD][changeIndex].sourceId,
                customParams: nextValue[NAME_FIELD][changeIndex].customParams,
                batchWaitInterval: nextValue[NAME_FIELD][changeIndex].batchWaitInterval,
                batchSize: nextValue[NAME_FIELD][changeIndex].batchSize,
                schema: value,
            };
            form?.setFieldsValue(nextValue);

            const panel = nextValue[NAME_FIELD][changeIndex];
            if (isHaveTableList(panel.type)) {
                getTableType({ sourceId: panel.sourceId, type: panel.type!, schema: value });
            }
        }

        if (changeKeys.includes('table')) {
            const value = changedValues[NAME_FIELD][changeIndex].table;
            const nextValue = { ...values };

            // reset fields
            nextValue[NAME_FIELD][changeIndex] = {
                ...DEFAULT_INPUT_VALUE,
                type: nextValue[NAME_FIELD][changeIndex].type,
                sourceId: nextValue[NAME_FIELD][changeIndex].sourceId,
                schema: nextValue[NAME_FIELD][changeIndex].schema,
                customParams: nextValue[NAME_FIELD][changeIndex].customParams,
                batchWaitInterval: nextValue[NAME_FIELD][changeIndex].batchWaitInterval,
                batchSize: nextValue[NAME_FIELD][changeIndex].batchSize,
                table: value,
            };
            form?.setFieldsValue(nextValue);

            const panel = nextValue[NAME_FIELD][changeIndex];
            if (isHaveTableColumn(panel.type)) {
                getTableColumns(panel.sourceId, panel.table, panel.schema);
            }
            if (isHavePartition(panel.type)) {
                loadPartitions();
            }
        }

        if (changeKeys.includes('collection')) {
            const value = changedValues[NAME_FIELD][changeIndex].collection;
            const nextValue = { ...values };

            // reset fields
            nextValue[NAME_FIELD][changeIndex] = {
                ...DEFAULT_INPUT_VALUE,
                type: nextValue[NAME_FIELD][changeIndex].type,
                sourceId: nextValue[NAME_FIELD][changeIndex].sourceId,
                schema: nextValue[NAME_FIELD][changeIndex].schema,
                customParams: nextValue[NAME_FIELD][changeIndex].customParams,
                batchWaitInterval: nextValue[NAME_FIELD][changeIndex].batchWaitInterval,
                batchSize: nextValue[NAME_FIELD][changeIndex].batchSize,
                table: nextValue[NAME_FIELD][changeIndex].table,
                collection: value,
            };
            form?.setFieldsValue(nextValue);

            const panel = nextValue[NAME_FIELD][changeIndex];
            if (isHaveTableColumn(panel.type)) {
                getTableColumns(panel.sourceId, panel.collection, panel.schema);
            }
            if (isHavePartition(panel.type)) {
                loadPartitions();
            }
        }

        if (changeKeys.includes('sinkDataType')) {
            const value = changedValues[NAME_FIELD][changeIndex].sinkDataType;
            if (!isAvro(value)) {
                const nextValue = { ...values };
                nextValue[NAME_FIELD][changeIndex].schemaInfo = undefined;

                form.setFieldsValue(nextValue);
            }
        }

        if (changeKeys.includes('columnsText')) {
            const nextValue = { ...values };
            nextValue[NAME_FIELD][changeIndex].partitionKeys = undefined;
            form.setFieldsValue(nextValue);
        }

        handleSyncFormToTab();
    };

    const currentInitData = (sink: IFlinkSinkProps[]) => {
        sink.forEach((v, index) => {
            getTypeOriginData(v.type);
            if (isHaveCollection(v.type)) {
                getTableType({ sourceId: v.sourceId, type: v.type, schema: v.schema });
            }
            if (isHaveTableList(v.type)) {
                getTableType({ sourceId: v.sourceId, type: v.type, schema: v.schema });

                if (isHaveSchema(v.type)) {
                    getSchemaData(index, v.sourceId);
                }

                if (isHaveTableColumn(v.type)) {
                    getTableColumns(v.sourceId, v.table, v?.schema);
                }
            }

            if (isHaveTopic(v.type)) {
                getTopicType(v.sourceId);
            }

            if (isHavePartition(v.type)) {
                loadPartitions(index, v.sourceId, v.table);
            }
        });
    };

    useEffect(() => {
        const { sink } = currentPage;
        if (sink && sink.length > 0) {
            currentInitData(sink);
        }
    }, [current]);

    const initialValues = useMemo(() => {
        return { [NAME_FIELD]: current?.tab?.data.sink || [] };
    }, []);

    return (
        <molecule.component.Scrollbar>
            <div className="panel-content">
                <Form<IFormFieldProps>
                    {...formItemLayout}
                    form={form}
                    onValuesChange={handleFormValuesChange}
                    initialValues={initialValues}
                >
                    <Form.List name={NAME_FIELD}>
                        {(fields, { add, remove }) => (
                            <>
                                <Collapse
                                    activeKey={panelActiveKey}
                                    bordered={false}
                                    onChange={(key) => setActiveKey(key as string[])}
                                    destroyInactivePanel
                                >
                                    {fields.map((field, index) => {
                                        const { sourceId, type, schema, table, tableName } =
                                            form?.getFieldValue(NAME_FIELD)[index] || {};
                                        return (
                                            <Panel
                                                header={
                                                    <div className="input-panel-title">
                                                        <span>{` ????????? ${index + 1} ${
                                                            tableName ? `(${tableName})` : ''
                                                        }`}</span>
                                                    </div>
                                                }
                                                key={field.key.toString()}
                                                extra={
                                                    <Popconfirm
                                                        placement="topLeft"
                                                        title="????????????????????????????????????"
                                                        onConfirm={() => {
                                                            handlePanelChanged('delete', field.key.toString());
                                                            remove(field.name);
                                                        }}
                                                        {...{
                                                            onClick: (e: any) => {
                                                                e.stopPropagation();
                                                            },
                                                        }}
                                                    >
                                                        <DeleteOutlined className={classNames('title-icon')} />
                                                    </Popconfirm>
                                                }
                                                style={{ position: 'relative' }}
                                                className="input-panel"
                                            >
                                                <ResultForm
                                                    index={index}
                                                    getTableType={getTableType}
                                                    dataSourceOptionList={dataSourceList[type]}
                                                    tableOptionType={tableOptionList[`${sourceId}-${schema || ''}`]}
                                                    tableColumnOptionType={
                                                        tableColumnsList[`${sourceId}-${table}-${schema || ''}`]
                                                    }
                                                    topicOptionType={topicOptionList[sourceId]}
                                                    componentVersion={currentPage.componentVersion}
                                                    onColumnsChange={handleFormValuesChange}
                                                />
                                            </Panel>
                                        );
                                    })}
                                </Collapse>
                                <Button
                                    size="large"
                                    block
                                    onClick={() => {
                                        handlePanelChanged('add');
                                        add({ ...DEFAULT_INPUT_VALUE });
                                    }}
                                    icon={<PlusOutlined />}
                                >
                                    <span>???????????????</span>
                                </Button>
                            </>
                        )}
                    </Form.List>
                </Form>
            </div>
        </molecule.component.Scrollbar>
    );
}
