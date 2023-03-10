import { useContext, useEffect, useMemo, useState } from 'react';
import { FormContext } from '@/services/rightBarService';
import { Checkbox, Form, Input, InputNumber, Select, Collapse } from 'antd';
import molecule from '@dtinsight/molecule';
import { DATA_SOURCE_ENUM, DIRTY_DATA_SAVE, formItemLayout } from '@/constant';
import { dirtyMaxRecord, dirtyFailRecord, dirtySaveType, logPrintTimes } from '@/components/helpDoc/docs';
import api from '@/api';
import type { IDataSourceProps } from '@/interface';
import type { IRightBarComponentProps } from '@/services/rightBarService';
import type { FormInstance } from 'antd';

const { Panel } = Collapse;

interface IFormFieldProps {
    openDirtyDataManage: boolean;
    maxRows?: number;
    maxCollectFailedRows?: number;
    outputType?: DIRTY_DATA_SAVE;
    linkInfo?: {
        sourceId: number;
    };
    tableName?: string;
    logPrintInterval?: number;
}

export default function TaskConfig({ current }: IRightBarComponentProps) {
    const { form } = useContext(FormContext) as { form?: FormInstance<IFormFieldProps> };

    const [dataSourceList, setDataSourceList] = useState<{ label: string; value: number }[]>([]);

    const handleFormValuesChange = () => {
        setTimeout(() => {
            const { openDirtyDataManage, ...restValues } = form?.getFieldsValue() || {};

            molecule.editor.updateTab({
                ...current!.tab!,
                data: {
                    ...current!.tab!.data,
                    openDirtyDataManage,
                    taskDirtyDataManageVO: {
                        ...current!.tab!.data!.taskDirtyDataManageVO,
                        ...restValues,
                    },
                },
            });
        }, 0);
    };

    useEffect(() => {
        api.getAllDataSource({}).then((res) => {
            if (res.code === 1) {
                const mysqlDataSource =
                    (res.data as IDataSourceProps[])?.filter((d) => d.dataTypeCode === DATA_SOURCE_ENUM.MYSQL) || [];
                setDataSourceList(mysqlDataSource.map((i) => ({ label: i.dataName, value: i.dataInfoId })));
            }
        });
    }, []);

    const initialValues = useMemo<IFormFieldProps>(() => {
        if (current?.tab?.data) {
            const { maxRows, maxCollectFailedRows, outputType, linkInfo, tableName, logPrintInterval } = (current.tab
                .data.taskDirtyDataManageVO || {}) as IFormFieldProps;

            return {
                openDirtyDataManage: current.tab.data.openDirtyDataManage,
                maxRows,
                maxCollectFailedRows,
                outputType,
                linkInfo,
                tableName,
                logPrintInterval,
            };
        }
        return {
            openDirtyDataManage: false,
        };
    }, [current?.activeTab]);

    return (
        <molecule.component.Scrollbar>
            <Collapse bordered={false} ghost defaultActiveKey={['1']}>
                <Panel key="1" header="???????????????">
                    <Form
                        form={form}
                        initialValues={initialValues}
                        preserve={false}
                        onValuesChange={handleFormValuesChange}
                        {...formItemLayout}
                    >
                        <Form.Item label="???????????????" name="openDirtyDataManage" valuePropName="checked">
                            <Checkbox> ?????? </Checkbox>
                        </Form.Item>
                        <Form.Item dependencies={['openDirtyDataManage']} noStyle>
                            {({ getFieldValue }) =>
                                getFieldValue('openDirtyDataManage') && (
                                    <>
                                        <Form.Item
                                            label="??????????????????"
                                            name="maxRows"
                                            tooltip={dirtyMaxRecord}
                                            initialValue={100000}
                                        >
                                            <InputNumber
                                                style={{ width: '100%' }}
                                                addonAfter="???"
                                                max={1000000}
                                                min={-1}
                                            />
                                        </Form.Item>
                                        <Form.Item
                                            label="????????????"
                                            name="maxCollectFailedRows"
                                            tooltip={dirtyFailRecord}
                                            initialValue={100000}
                                        >
                                            <InputNumber
                                                style={{ width: '100%' }}
                                                addonAfter="???"
                                                max={1000000}
                                                min={-1}
                                            />
                                        </Form.Item>
                                        <Form.Item
                                            label="???????????????"
                                            name="outputType"
                                            tooltip={dirtySaveType}
                                            initialValue={DIRTY_DATA_SAVE.NO_SAVE}
                                        >
                                            <Select>
                                                <Select.Option value={DIRTY_DATA_SAVE.NO_SAVE}>
                                                    ???????????????????????????
                                                </Select.Option>
                                                <Select.Option value={DIRTY_DATA_SAVE.BY_MYSQL}>
                                                    ?????????MySQL
                                                </Select.Option>
                                            </Select>
                                        </Form.Item>
                                        <Form.Item dependencies={['outputType']} noStyle>
                                            {({ getFieldValue: getOutputType }) =>
                                                getOutputType('outputType') === DIRTY_DATA_SAVE.BY_MYSQL && (
                                                    <>
                                                        <Form.Item
                                                            label="??????????????????"
                                                            name={['linkInfo', 'sourceId']}
                                                            rules={[
                                                                {
                                                                    required: true,
                                                                    message: '??????????????????????????????',
                                                                },
                                                            ]}
                                                        >
                                                            <Select
                                                                placeholder="???????????????????????????MySQL???"
                                                                allowClear
                                                                showSearch
                                                                options={dataSourceList}
                                                                filterOption={(input, option) =>
                                                                    option!
                                                                        .label!.toLowerCase()
                                                                        .includes(input.toLowerCase())
                                                                }
                                                            />
                                                        </Form.Item>
                                                        <Form.Item
                                                            label="??????????????????"
                                                            name="tableName"
                                                            initialValue="flinkx_dirty_data"
                                                        >
                                                            <Input disabled />
                                                        </Form.Item>
                                                    </>
                                                )
                                            }
                                        </Form.Item>
                                        <Form.Item dependencies={['outputType', 'maxRows']} noStyle>
                                            {({ getFieldValue: innerGetFieldValue }) =>
                                                innerGetFieldValue('outputType') === DIRTY_DATA_SAVE.NO_SAVE && (
                                                    <Form.Item
                                                        label="??????????????????"
                                                        name="logPrintInterval"
                                                        tooltip={logPrintTimes}
                                                        initialValue={1}
                                                    >
                                                        <InputNumber
                                                            style={{ width: '100%' }}
                                                            addonAfter="???/???"
                                                            max={
                                                                typeof innerGetFieldValue('maxRows') === 'number'
                                                                    ? innerGetFieldValue('maxRows') + 1
                                                                    : 1000000
                                                            }
                                                            min={0}
                                                        />
                                                    </Form.Item>
                                                )
                                            }
                                        </Form.Item>
                                    </>
                                )
                            }
                        </Form.Item>
                    </Form>
                </Panel>
            </Collapse>
        </molecule.component.Scrollbar>
    );
}
