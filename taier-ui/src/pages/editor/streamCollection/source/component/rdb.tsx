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

import stream from '@/api';
import {
    extralConfig,
    intervalColumn,
    multipleTableTip,
    sourceFormat,
    startLocation,
    temporary,
} from '@/components/helpDoc/docs';
import {
    CAT_TYPE,
    COLLECT_TYPE,
    DATA_SOURCE_ENUM,
    DATA_SOURCE_VERSION,
    SLOAR_CONFIG_TYPE,
    SYNC_TYPE,
} from '@/constant';
import { Button, Card, Checkbox, DatePicker, Form, Input, InputNumber, Radio, Select, Tag, Tooltip } from 'antd';
import { isSqlServer } from '@/utils/is';
import { QuestionCircleOutlined, PlusOutlined, DeleteOutlined } from '@ant-design/icons';
import React, { useEffect, useState } from 'react';
import { streamTaskActions } from '../../taskFunc';
import { debounce, get } from 'lodash';
import { isPostgre } from '../../helper';
import TablePreview from './tablePreview';
import EditMultipleTableModal from './editMultipleTableModal';
import { IDataSourceUsedInSyncProps } from '@/interface';

const FormItem = Form.Item;
const Option = Select.Option;

export default (props: { collectionData: any; sourceList: IDataSourceUsedInSyncProps[] }) => {
    const { collectionData, sourceList } = props;
    const { isEdit, sourceMap, componentVersion } = collectionData;
    const {
        allTable,
        allFileds,
        type,
        multipleTable,
        distributeTable = [],
        rdbmsDaType,
        slotConfig,
        slotName,
        sourceId,
        pdbName,
        schema,
        tableName,
        tableFields,
    } = sourceMap || {};

    const [showPDB, setShowPDB] = useState(false);
    const [PDBList, setPDBList] = useState([]);
    const [schemaList, setSchemaList] = useState([]);
    const [tableList, setTableList] = useState([]);
    const [tableFieldsList, setTableFieldsList] = useState([]);
    const [increaseColumns, setIncreaseColumns] = useState([]);
    const [binLogList, setBinLogList] = useState([]);
    const [slotList, setSlotList] = useState([]);
    const [editMultipleTableModalVisible, setEditMultipleTableModalVisible] = useState(false);
    const [multipleTableDataIndex, setMultipleTableDataIndex] = useState();

    const needSchema = () => {
        const isInterval = rdbmsDaType == SYNC_TYPE.INTERVAL;
        return (
            isInterval ||
            type == DATA_SOURCE_ENUM.ORACLE ||
            type == DATA_SOURCE_ENUM.SQLSERVER ||
            type == DATA_SOURCE_ENUM.SQLSERVER_2017_LATER ||
            type == DATA_SOURCE_ENUM.POSTGRESQL
        );
    };

    const getPDB = (dataInfoId: number) => {
        setPDBList([]);
        if (!dataInfoId || type !== DATA_SOURCE_ENUM.ORACLE) {
            return;
        }
        stream
            .isOpenCdb({ dataInfoId })
            .then((res: any) => {
                if (res.code === 1) {
                    setShowPDB(res.data);
                    if (res.data) {
                        return stream.getPDBList({ dataInfoId });
                    }
                }
            })
            .then((res: any) => {
                setPDBList(res?.data || []);
            });
    };
    const getSchema = async (sourceId: number, db: string) => {
        setSchemaList([]);
        if (!sourceId) {
            return;
        }
        const res = await stream.getAllSchemas({ sourceId, db });
        if (res && res.code == 1) {
            setSchemaList(res.data || []);
        }
    };

    const getTableList = (sourceId: any, searchKey?: any) => {
        stream
            .getOfflineTableList({
                sourceId,
                // schema,
                isSys: false,
                name: searchKey,
                isRead: true,
            })
            .then((res: any) => {
                if (res.code === 1) {
                    setTableList(res.data || []);
                }
            });
    };
    const getSchemaTableList = async (sourceId: any, schema: any, pdbName: string, searchKey?: any) => {
        setTableList([]);
        if (!sourceId || !schema) {
            return;
        }
        const res = await stream.listTablesBySchema({
            sourceId,
            schema,
            searchKey,
            db: pdbName,
        });
        if (res && res.code == 1) {
            setTableList(res.data || []);
        }
    };

    /**
     * ???????????????
     * @param sourceId
     * @param tableName
     * @param schema
     * @returns
     */
    const getTableFieldsList = async (sourceId: number, tableName: string, schema: string) => {
        setTableFieldsList([]);
        if (!sourceId || !schema || !tableName) {
            return;
        }
        const res = await stream.getStreamTableColumn({
            sourceId,
            schema,
            tableName,
            flinkVersion: componentVersion,
        });
        if (res.code == 1) {
            setTableFieldsList(res.data || []);
        }
    };
    const getIncreaseColumns = (sourceId: number, tableName: string, schema: string, tableFields: any[]) => {
        setIncreaseColumns([]);
        if (!sourceId || !tableName || !schema) {
            return;
        }
        setTimeout(() => {
            stream
                .getSchemaTableColumn({
                    sourceId,
                    tableName,
                    schema,
                    tableFields,
                })
                .then((res: any) => {
                    if (res && res.code == 1) {
                        setIncreaseColumns(res.data || []);
                    }
                });
        }, 500);
    };
    const getSlotList = (sourceId: number, slotName?: string) => {
        stream
            .getSlotList({
                sourceId,
                slotName: slotName ?? '',
            })
            .then((res: any) => {
                if (res.code === 1) {
                    setSlotList(res.data || []);
                }
            });
    };
    const getBinLogList = (params: { sourceId: any; journalName?: string }) => {
        setBinLogList([]);
        stream.getBinlogListBySource(params).then((res: any) => {
            if (res.code == 1) {
                setBinLogList(res.data || []);
            }
        });
    };
    const searchByJournalName = (journalName: string) => {
        getBinLogList({
            sourceId,
            journalName,
        });
    };
    const debounceSearchByJournalName = debounce(searchByJournalName, 500);

    const onTableNameSearch = (searchKey: any) => {
        if (!sourceId) return;
        if (needSchema()) {
            if (!schema) return;
            getSchemaTableList(sourceId, schema, pdbName, searchKey);
            return;
        }
        getTableList(sourceId, searchKey);
    };

    const debounceTableNameSearch = debounce(onTableNameSearch, 500);

    /**
     * ??????PDB
     * @param pdbName
     */
    const changePDB = (pdbName: string) => {
        getSchema(sourceId, pdbName);
    };

    /**
     * ?????????????????????
     * @param index
     * @param e
     */
    const changeMultipleGroupName = (index: any, e: any) => {
        const value = e.target.value;
        const newDistributeTable: any = [...distributeTable];
        newDistributeTable.splice(index, 1, {
            ...distributeTable[index],
            name: value,
        });
        streamTaskActions.updateSourceMap({
            distributeTable: newDistributeTable,
        });
    };

    // ????????????
    const onAddDistributeTable = () => {
        streamTaskActions.updateSourceMap({
            distributeTable: [...distributeTable, { name: null, tables: [] }],
        });
    };
    const editMultipleTable = (index: any) => {
        setEditMultipleTableModalVisible(true);
        setMultipleTableDataIndex(index);
    };
    const changeMultipleTable = (index: any, keys: any) => {
        const newDistributeTable: any = [...distributeTable];
        newDistributeTable.splice(index, 1, {
            ...distributeTable[index],
            tables: keys,
        });
        streamTaskActions.updateSourceMap({
            distributeTable: newDistributeTable,
        });
        setEditMultipleTableModalVisible(false);
        setMultipleTableDataIndex(undefined);
    };

    // ??????????????????
    const onDeleteMultipleTableSelect = (tableName: string, index: number) => {
        const newDistributeTable: any = [...distributeTable];
        const multipleTable = distributeTable[index];
        const tables: any = multipleTable.tables.filter((name: string) => name !== tableName);
        newDistributeTable.splice(index, 1, {
            ...multipleTable,
            tables,
        });
        streamTaskActions.updateSourceMap({ distributeTable: newDistributeTable });
    };

    const deleteGroup = (index: any) => {
        const newDistributeTable: any = [...distributeTable];
        newDistributeTable.splice(index, 1);
        streamTaskActions.updateSourceMap({
            distributeTable: newDistributeTable,
        });
    };

    const resetList = () => {
        setSchemaList([]);
        setPDBList([]);
        setTableList([]);
        setTableFieldsList([]);
    };

    useEffect(() => {
        if (sourceId) {
            resetList();
            if (needSchema()) {
                getSchema(sourceId, pdbName);
                isOracle && getPDB(sourceId);
                getSchemaTableList(sourceId, schema, pdbName);
                if (isPostgre(type)) {
                    getSlotList(sourceId, slotName);
                }
            } else if (
                [DATA_SOURCE_ENUM.MYSQL, DATA_SOURCE_ENUM.UPDRDB, DATA_SOURCE_ENUM.POLAR_DB_For_MySQL].includes(
                    sourceMap.type
                )
            ) {
                getTableList(sourceId);
            }
            if (rdbmsDaType === SYNC_TYPE.INTERVAL) {
                getTableFieldsList(sourceId, tableName, schema);
                getIncreaseColumns(sourceId, tableName, schema, tableFields);
            }
        }
    }, [sourceId]);
    useEffect(() => {
        getSchemaTableList(sourceId, schema, pdbName);
    }, [schema]);

    useEffect(() => {
        if (needSchema()) {
            getTableFieldsList(sourceId, tableName, schema);
            getIncreaseColumns(sourceId, tableName, schema, tableFields);
        }
    }, [tableName]);

    useEffect(() => {
        if (needSchema()) {
            getIncreaseColumns(sourceId, tableName, schema, tableFields);
        }
    }, [tableFields]);

    useEffect(() => {
        resetList();
    }, [type]);

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
    const renderByCatType = (isOracle: boolean) => {
        const collectTypeValue = sourceMap.collectType;
        switch (collectTypeValue) {
            case COLLECT_TYPE.ALL:
            case COLLECT_TYPE.BEGIN: {
                return null;
            }
            case COLLECT_TYPE.TIME: {
                return (
                    <FormItem
                        label="????????????"
                        style={{ textAlign: 'left' }}
                        name="timestamp"
                        rules={[{ required: true, message: '?????????????????????' }]}
                    >
                        <DatePicker showTime placeholder="?????????????????????" format="YYYY-MM-DD HH:mm:ss" />
                    </FormItem>
                );
            }
            case COLLECT_TYPE.FILE: {
                if (isOracle) {
                    return (
                        <FormItem
                            label="????????????"
                            name="startSCN"
                            rules={[{ required: true, message: '?????????????????????' }]}
                        >
                            <Select
                                getPopupContainer={(triggerNode: any) => triggerNode}
                                placeholder="?????????????????????"
                                showSearch
                                onSearch={debounceSearchByJournalName}
                                filterOption={false}
                            >
                                {binLogList.map((binlog: any) => {
                                    return <Option key={binlog.scn}>{binlog.journalName}</Option>;
                                })}
                            </Select>
                        </FormItem>
                    );
                }
                return (
                    <FormItem
                        label="????????????"
                        name="journalName"
                        rules={[{ required: true, message: '?????????????????????' }]}
                    >
                        <Select
                            getPopupContainer={(triggerNode: any) => triggerNode}
                            placeholder="?????????????????????"
                            showSearch
                            onSearch={debounceSearchByJournalName}
                        >
                            {binLogList.map((binlog: any) => {
                                return <Option key={binlog.journalName}>{binlog.journalName}</Option>;
                            })}
                        </Select>
                    </FormItem>
                );
            }
            case COLLECT_TYPE.LSN: {
                return (
                    <FormItem
                        label="LSN???"
                        style={{ textAlign: 'left' }}
                        name="lsn"
                        rules={[
                            {
                                required: true,
                                message: '?????????LSN???',
                            },
                            {
                                pattern: /^\d{1,64}$/,
                                message: 'LSN????????????????????????64?????????',
                            },
                        ]}
                    >
                        <Input placeholder="?????????LSN???" style={{ width: '100%' }} />
                    </FormItem>
                );
            }
        }
    };
    const renderSlot = (isPostgre: boolean) => {
        if (!isPostgre) return null;
        const slotOptions = slotList.map((slot: any) => {
            return (
                <Option key={`${slot}`} value={slot}>
                    {slot}
                </Option>
            );
        });
        return (
            <>
                <FormItem name="slotConfig" label="Slot??????" rules={[{ required: true, message: '?????????Slot??????' }]}>
                    <Radio.Group style={{ position: 'relative' }} disabled={isEdit}>
                        {Object.entries(SLOAR_CONFIG_TYPE).map(([key, value]) => {
                            return (
                                <Radio key={value} value={Number(key)}>
                                    {value}
                                </Radio>
                            );
                        })}
                    </Radio.Group>
                </FormItem>
                {slotConfig === Number(Object.keys(SLOAR_CONFIG_TYPE)[0]) ? (
                    <FormItem name="slotName" label="Slot" rules={[{ required: true, message: '?????????Slot' }]}>
                        <Select
                            getPopupContainer={(triggerNode: any) => triggerNode}
                            disabled={isEdit}
                            style={{ width: '100%' }}
                            placeholder="???????????????Slot??????"
                            showSearch
                            onSearch={(value) => getSlotList(sourceId, value)}
                        >
                            {slotOptions}
                        </Select>
                    </FormItem>
                ) : (
                    <FormItem
                        name="temporary"
                        label="Slot?????????"
                        rules={[{ required: true, message: '?????????Slot?????????' }]}
                        tooltip={temporary}
                    >
                        <Radio.Group style={{ position: 'relative' }} disabled={isEdit}>
                            <Radio value={false}>??????</Radio>
                            <Radio value>??????</Radio>
                        </Radio.Group>
                    </FormItem>
                )}
            </>
        );
    };
    const renderTransferType = (type: number, isEdit: boolean) => {
        return (
            <FormItem name="pavingData" label="????????????" valuePropName="checked" tooltip={sourceFormat}>
                <Checkbox disabled={isEdit}>??????JSON??????</Checkbox>
            </FormItem>
        );
    };
    const sourceDataOptions = sourceList
        ?.filter((d) => d.dataTypeCode === sourceMap?.type)
        .map?.((o: IDataSourceUsedInSyncProps) => {
            return (
                <Option key={o.dataInfoId} value={o.dataInfoId}>
                    {o.dataName}
                    {DATA_SOURCE_VERSION[o.dataTypeCode] && ` (${DATA_SOURCE_VERSION[o.dataTypeCode]})`}
                </Option>
            );
        });
    const schemaOptions = schemaList.map((schema: any) => {
        return (
            <Option key={`${schema}`} value={schema}>
                {schema}
            </Option>
        );
    });
    const isOracle = type === DATA_SOURCE_ENUM.ORACLE;
    const multipleTableData = multipleTableDataIndex === undefined ? null : distributeTable[multipleTableDataIndex];
    return (
        <React.Fragment>
            <FormItem name="sourceId" label="?????????" rules={[{ required: true, message: '??????????????????' }]}>
                <Select
                    getPopupContainer={(triggerNode: any) => triggerNode}
                    disabled={isEdit}
                    placeholder="??????????????????"
                    style={{ width: '100%' }}
                >
                    {sourceDataOptions}
                </Select>
            </FormItem>
            {isOracle && showPDB && (
                <FormItem name="pdbName" label="PDB" rules={[{ required: isOracle && showPDB, message: '?????????PDB' }]}>
                    <Select
                        getPopupContainer={(triggerNode: any) => triggerNode}
                        disabled={isEdit}
                        placeholder="?????????PDB"
                        style={{ width: '100%' }}
                        onChange={changePDB}
                        showSearch
                    >
                        {PDBList.map((item: any) => (
                            <Option key={item} value={item}>
                                {item}
                            </Option>
                        ))}
                    </Select>
                </FormItem>
            )}
            {needSchema() && (
                <FormItem name="schema" label="schema" rules={[{ required: true, message: '?????????schema' }]}>
                    <Select
                        getPopupContainer={(triggerNode: any) => triggerNode}
                        disabled={isEdit}
                        style={{ width: '100%' }}
                        placeholder="?????????schema"
                        showSearch
                    >
                        {schemaOptions}
                    </Select>
                </FormItem>
            )}
            {rdbmsDaType === SYNC_TYPE.INTERVAL && (
                <React.Fragment>
                    <FormItem name="tableName" label="???" rules={[{ required: true, message: '????????????' }]}>
                        <Select
                            getPopupContainer={(triggerNode: any) => triggerNode}
                            disabled={isEdit}
                            style={{ width: '100%' }}
                            placeholder="????????????"
                            showSearch
                            onSearch={debounceTableNameSearch}
                        >
                            {tableList.map((table: any) => {
                                return (
                                    <Option key={`${table}`} value={table}>
                                        {table}
                                    </Option>
                                );
                            })}
                        </Select>
                    </FormItem>
                    <FormItem
                        name="tableFields"
                        label="????????????"
                        rules={[{ required: true, message: '?????????????????????' }]}
                    >
                        <Select
                            getPopupContainer={(triggerNode: any) => triggerNode}
                            mode="multiple"
                            showArrow
                            style={{ width: '100%' }}
                            placeholder="?????????????????????"
                        >
                            {tableFieldsList.length
                                ? [
                                      <Option key={-1} value={-1}>
                                          ??????
                                      </Option>,
                                  ].concat(
                                      tableFieldsList.map((table: any) => {
                                          return (
                                              <Option disabled={allFileds} key={table.key} value={table.key}>
                                                  {table.key}
                                              </Option>
                                          );
                                      })
                                  )
                                : [
                                      <Option key={-1} value={-1}>
                                          ??????
                                      </Option>,
                                  ]}
                        </Select>
                    </FormItem>
                    <FormItem
                        name="increColumn"
                        label="??????????????????"
                        rules={[{ required: true, message: '???????????????????????????' }]}
                        tooltip={intervalColumn}
                    >
                        <Select
                            getPopupContainer={(triggerNode: any) => triggerNode}
                            disabled={isEdit}
                            placeholder="???????????????????????????"
                            style={{ width: '100%' }}
                            showSearch
                        >
                            {increaseColumns
                                ?.map((item: any) => {
                                    return (
                                        <Option key={item.key} value={item.key}>
                                            {item.key}
                                        </Option>
                                    );
                                })
                                .filter(Boolean)}
                        </Select>
                    </FormItem>
                    <FormItem name="startLocation" label="????????????" tooltip={startLocation}>
                        <Input />
                    </FormItem>
                    <FormItem
                        name="pollingInterval"
                        label="??????????????????"
                        rules={[{ required: true, message: '???????????????????????????' }]}
                    >
                        <InputNumber
                            style={{ width: 'calc(100% - 20px)', marginRight: 8 }}
                            min={5}
                            max={3600}
                            step={1}
                            addonAfter="???"
                        />
                    </FormItem>
                    <FormItem name="extralConfig" label="????????????" tooltip={extralConfig}>
                        <Input.TextArea style={{ width: '100%' }} rows={3} placeholder="???JSON????????????????????????" />
                    </FormItem>
                    <TablePreview data={sourceMap} key="tp" />
                </React.Fragment>
            )}

            {rdbmsDaType !== SYNC_TYPE.INTERVAL && (
                <React.Fragment>
                    {!isSqlServer(type) && type !== DATA_SOURCE_ENUM.ORACLE && (
                        <FormItem name="multipleTable" label="????????????" tooltip={multipleTableTip}>
                            <Radio.Group>
                                <Radio value={false}>?????????</Radio>
                                <Radio value>??????</Radio>
                            </Radio.Group>
                        </FormItem>
                    )}
                    {multipleTable && (
                        <FormItem
                            wrapperCol={{
                                xs: { span: 24 },
                                sm: { span: 17, offset: 5 },
                            }}
                        >
                            {distributeTable &&
                                distributeTable.map((table: any, index: any) => {
                                    const couldEdit = !(isEdit && table.isSaved);
                                    const distributeTableFormLayout = {
                                        labelCol: {
                                            xs: { span: 24 },
                                            sm: { span: 4 },
                                        },
                                        wrapperCol: {
                                            xs: { span: 24 },
                                            sm: { span: 20 },
                                        },
                                    };
                                    return (
                                        <div className="distribute-table-box" key={`${index}`}>
                                            <Card className="distribute-table-box__ant-card" title={null}>
                                                <FormItem
                                                    label={
                                                        <span>
                                                            ?????????&nbsp;
                                                            <Tooltip
                                                                title={
                                                                    '???????????????????????????????????????????????????????????????Hive???????????????????????????Hive??????????????????'
                                                                }
                                                            >
                                                                <QuestionCircleOutlined style={{ color: '#999' }} />
                                                            </Tooltip>
                                                        </span>
                                                    }
                                                    required
                                                    {...distributeTableFormLayout}
                                                >
                                                    <Input
                                                        onChange={(e) => {
                                                            changeMultipleGroupName(index, e);
                                                        }}
                                                        value={table.name}
                                                        disabled={!couldEdit}
                                                        placeholder="?????????????????????????????????????????????????????????"
                                                    />
                                                </FormItem>
                                                <FormItem label="?????????" required {...distributeTableFormLayout}>
                                                    {Array.isArray(table.tables) && table.tables.length > 0 ? (
                                                        <div className="card-select">
                                                            {table.tables.map((tableName: any) => (
                                                                <Tag
                                                                    key={tableName}
                                                                    className="card-select__ant-tag"
                                                                    closable
                                                                    onClose={() =>
                                                                        onDeleteMultipleTableSelect(tableName, index)
                                                                    }
                                                                >
                                                                    <span>{tableName}</span>
                                                                </Tag>
                                                            ))}
                                                            <a
                                                                className="card-select_btn-edit"
                                                                onClick={() => editMultipleTable(index)}
                                                            >
                                                                ????????????
                                                            </a>
                                                        </div>
                                                    ) : (
                                                        <Button
                                                            type="primary"
                                                            ghost
                                                            block
                                                            onClick={() => editMultipleTable(index)}
                                                        >
                                                            <PlusOutlined />
                                                            ???????????????
                                                        </Button>
                                                    )}
                                                </FormItem>
                                            </Card>
                                            {couldEdit && (
                                                <DeleteOutlined
                                                    className="distribute-table-box__icon-delete"
                                                    onClick={() => deleteGroup(index)}
                                                />
                                            )}
                                        </div>
                                    );
                                })}
                            <Button type="primary" ghost onClick={onAddDistributeTable}>
                                <PlusOutlined />
                                ????????????
                            </Button>
                            <EditMultipleTableModal
                                // key={editMultipleTableModalVisible}
                                visible={editMultipleTableModalVisible}
                                tableList={tableList}
                                selectKeys={get(multipleTableData || {}, 'tables')}
                                onCancel={() => {
                                    setMultipleTableDataIndex(undefined);
                                    setEditMultipleTableModalVisible(false);
                                }}
                                onOk={(keys: any) => {
                                    changeMultipleTable(multipleTableDataIndex, keys);
                                }}
                                onSearch={debounceTableNameSearch}
                            />
                        </FormItem>
                    )}
                    {!multipleTable && (
                        <FormItem name="table" label="???" rules={[{ required: true, message: '????????????' }]}>
                            <Select
                                getPopupContainer={(triggerNode: any) => triggerNode}
                                mode="multiple"
                                style={{ width: '100%' }}
                                placeholder="????????????"
                                showSearch
                                showArrow
                                onSearch={debounceTableNameSearch}
                            >
                                {tableList.length
                                    ? [
                                          <Option key={-1} value={-1}>
                                              ??????
                                          </Option>,
                                      ].concat(
                                          tableList.map((table: any) => {
                                              return (
                                                  <Option disabled={allTable} key={`${table}`} value={table}>
                                                      {table}
                                                  </Option>
                                              );
                                          })
                                      )
                                    : []}
                                {/* https://github.com/ant-design/ant-design/issues/10711 */}
                            </Select>
                        </FormItem>
                    )}
                    <FormItem
                        name="collectType"
                        label="????????????"
                        style={{ textAlign: 'left' }}
                        rules={[{ required: true, message: '?????????????????????' }]}
                    >
                        {renderCollectType()}
                    </FormItem>
                    {renderByCatType(isOracle)}
                    <FormItem name="cat" label="????????????" rules={[{ required: true, message: '?????????????????????' }]}>
                        <Checkbox.Group
                            options={[
                                { label: 'Insert', value: CAT_TYPE.INSERT },
                                { label: 'Update', value: CAT_TYPE.UPDATE },
                                { label: 'Delete', value: CAT_TYPE.DELETE },
                            ]}
                        />
                    </FormItem>
                    {renderSlot(isPostgre(type) && sourceId)}
                    {renderTransferType(type, isEdit)}
                    <FormItem name="extralConfig" label="????????????" tooltip={extralConfig}>
                        <Input.TextArea style={{ width: '100%' }} rows={3} placeholder="???JSON????????????????????????" />
                    </FormItem>
                </React.Fragment>
            )}
        </React.Fragment>
    );
};
