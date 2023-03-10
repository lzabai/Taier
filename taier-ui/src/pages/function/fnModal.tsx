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

import { useContext, useEffect, useMemo } from 'react';
import { Radio, Modal, Input, message, Select, Form } from 'antd';
import { ExclamationCircleOutlined } from '@ant-design/icons';
import FolderPicker from '../../components/folderPicker';
import { CATALOGUE_TYPE, formItemLayout, TASK_TYPE_ENUM, UDF_TYPE_NAMES, UDF_TYPE_VALUES } from '@/constant';
import type { IFunctionProps } from '@/interface';
import resourceManagerTree from '@/services/resourceManagerService';
import context from '@/context';

const FormItem = Form.Item;

interface IFnModalProps {
    visible?: boolean;
    onClose?: () => void;
    data?: Partial<IFunctionProps>;
    onAddFunction?: (data: IFormFieldProps) => Promise<boolean>;
    onEditFunction?: (data: Partial<IFunctionProps>) => Promise<boolean>;
}

interface IFormFieldProps {
    taskType: TASK_TYPE_ENUM;
    udfType?: UDF_TYPE_VALUES;
    name?: string;
    className?: string;
    resourceId?: number;
    purpose?: string;
    commandFormate: string;
    paramDesc?: string;
    nodePid?: number;
}

const TASK_TYPE_OPTIONS = [TASK_TYPE_ENUM.SPARK_SQL, TASK_TYPE_ENUM.SQL, TASK_TYPE_ENUM.HIVE_SQL];

export default function FnModal({ data, visible, onClose, onAddFunction, onEditFunction }: IFnModalProps) {
    const { supportJobTypes } = useContext(context);
    const [form] = Form.useForm<IFormFieldProps>();

    const handleSubmit = () => {
        form.validateFields().then((values) => {
            if (data?.id !== undefined) {
                onEditFunction?.({ ...data, ...values }).then((res) => {
                    if (res) {
                        message.success('????????????');
                        onClose?.();
                    }
                });
            } else {
                onAddFunction?.({ ...values }).then((res) => {
                    if (res) {
                        message.success('????????????');
                        onClose?.();
                    }
                });
            }
        });
    };

    const checkNotDir = (_: any, value: number) => {
        return resourceManagerTree.checkNotDir(value);
    };

    useEffect(() => {
        if (visible) {
            if (data) {
                form.setFieldsValue({
                    taskType: data?.taskType,
                    udfType: data?.taskType === TASK_TYPE_ENUM.SQL ? data?.udfType : undefined,
                    name: data?.name,
                    className: data?.className,
                    resourceId: data?.resources,
                    purpose: data?.purpose,
                    commandFormate: data?.commandFormate,
                    paramDesc: data?.paramDesc,
                    nodePid: data?.nodePid,
                });
            } else {
                form.resetFields();
            }
        }
    }, [visible, data]);

    const isEdit = useMemo(() => !!data?.id, [data]);
    const initialValues = useMemo<Partial<IFormFieldProps>>(
        () => ({
            taskType: TASK_TYPE_ENUM.SPARK_SQL,
        }),
        []
    );

    return (
        <Modal
            title={`${isEdit ? '??????' : '??????'}???????????????`}
            visible={visible}
            destroyOnClose
            onCancel={onClose}
            onOk={handleSubmit}
        >
            {isEdit && (
                <div className="task_offline_message">
                    <ExclamationCircleOutlined style={{ marginRight: 7 }} />
                    ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                </div>
            )}
            <Form<IFormFieldProps>
                {...formItemLayout}
                form={form}
                autoComplete="off"
                preserve={false}
                initialValues={initialValues}
            >
                <FormItem
                    label="????????????"
                    name="taskType"
                    rules={[
                        {
                            required: true,
                            message: '???????????????????????????',
                        },
                    ]}
                >
                    <Select
                        disabled={isEdit}
                        getPopupContainer={() => document.getElementById('molecule')!}
                        options={TASK_TYPE_OPTIONS.map((o) => ({
                            label: supportJobTypes.find((t) => t.key === o)?.value || '??????',
                            value: o,
                        }))}
                    />
                </FormItem>
                <FormItem noStyle dependencies={['taskType']}>
                    {({ getFieldValue }) =>
                        getFieldValue('taskType') === TASK_TYPE_ENUM.SQL && (
                            <FormItem
                                name="udfType"
                                label="UDF??????"
                                rules={[
                                    {
                                        required: true,
                                        message: '?????????UDF??????',
                                    },
                                ]}
                                initialValue={UDF_TYPE_VALUES.UDF}
                            >
                                <Radio.Group disabled={isEdit}>
                                    {Object.entries(UDF_TYPE_NAMES).map(([key, value]) => (
                                        <Radio key={key} value={Number(key)}>
                                            {value}
                                        </Radio>
                                    ))}
                                </Radio.Group>
                            </FormItem>
                        )
                    }
                </FormItem>
                <FormItem
                    label="????????????"
                    name="name"
                    rules={[
                        {
                            required: true,
                            message: '???????????????????????????',
                        },
                        {
                            pattern: /^[a-zA-Z0-9_]+$/,
                            message: '??????????????????????????????????????????????????????!',
                        },
                        {
                            max: 20,
                            message: '????????????????????????20????????????',
                        },
                    ]}
                >
                    <Input placeholder="?????????????????????" disabled={isEdit} />
                </FormItem>
                <FormItem
                    label="??????"
                    name="className"
                    rules={[
                        {
                            required: true,
                            message: '??????????????????',
                        },
                        {
                            pattern: /^[a-zA-Z]+[0-9a-zA-Z_]*(\.[a-zA-Z]+[0-9a-zA-Z_]*)*$/,
                            message: '????????????????????????!',
                        },
                    ]}
                >
                    <Input placeholder="???????????????" />
                </FormItem>
                <FormItem {...formItemLayout} label="??????" required>
                    <FormItem
                        noStyle
                        name="resourceId"
                        rules={[
                            {
                                required: true,
                                message: '?????????????????????',
                            },
                            {
                                validator: checkNotDir,
                            },
                        ]}
                    >
                        <FolderPicker dataType={CATALOGUE_TYPE.RESOURCE} showFile />
                    </FormItem>
                </FormItem>
                <FormItem label="??????" name="purpose">
                    <Input placeholder="??????" />
                </FormItem>
                <FormItem
                    label="????????????"
                    name="commandFormate"
                    rules={[
                        {
                            required: true,
                            message: '?????????????????????',
                        },
                        {
                            max: 128,
                            message: '??????????????????128??????????????????',
                        },
                    ]}
                >
                    <Input placeholder="????????????" />
                </FormItem>
                <FormItem
                    label="????????????"
                    name="paramDesc"
                    rules={[
                        {
                            max: 200,
                            message: '??????????????????200??????????????????',
                        },
                    ]}
                >
                    <Input.TextArea rows={4} placeholder="??????????????????????????????" />
                </FormItem>
                <FormItem
                    name="nodePid"
                    label="??????????????????"
                    rules={[
                        {
                            required: true,
                            message: '?????????????????????',
                        },
                    ]}
                >
                    <FolderPicker showFile={false} dataType={CATALOGUE_TYPE.FUNCTION} />
                </FormItem>
            </Form>
        </Modal>
    );
}
