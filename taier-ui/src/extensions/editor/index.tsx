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

import { createRoot } from 'react-dom/client';
import { message, Modal } from 'antd';
import molecule from '@dtinsight/molecule';
import type { IExtension } from '@dtinsight/molecule/esm/model';
import { onTaskSwitch, runTask, syntaxValidate } from '@/utils/extensions';
import { DRAWER_MENU_ENUM, TASK_LANGUAGE, ID_COLLECTIONS, TASK_TYPE_ENUM } from '@/constant';
import { history } from 'umi';
import { debounce } from 'lodash';
import Publish, { CONTAINER_ID } from '@/components/task/publish';
import type { UniqueId } from '@dtinsight/molecule/esm/common/types';
import { createSQLProposals, prettierJSONstring } from '@/utils';
import api from '@/api';
import type { CatalogueDataProps, IOfflineTaskProps } from '@/interface';
import { IComputeType } from '@/interface';
import type { IParamsProps } from '@/services/taskParamsService';
import { languages } from '@dtinsight/molecule/esm/monaco';
import { editorActionBarService, taskRenderService, executeService, taskParamsService } from '@/services';
import notification from '@/components/notification';
import { mappingTaskTypeToLanguage } from '@/utils/enums';
import taskSaveService from '@/services/taskSaveService';
import viewStoreService from '@/services/viewStoreService';
import type { mxCell } from 'mxgraph';
import type { IGeometryPosition } from '@/components/mxGraph/container';
import { isEditing } from '@/pages/editor/workflow';

function emitEvent() {
    molecule.editor.onActionsClick(async (menuId, current) => {
        switch (menuId) {
            case ID_COLLECTIONS.TASK_RUN_ID: {
                runTask(current);
                break;
            }
            case ID_COLLECTIONS.TASK_STOP_ID: {
                const currentTabData: (CatalogueDataProps & IOfflineTaskProps & { value?: string }) | undefined =
                    current.tab?.data;
                if (!currentTabData) return;

                if (currentTabData.taskType === TASK_TYPE_ENUM.SYNC) {
                    executeService.stopDataSync(currentTabData.id, false);
                } else {
                    executeService.stopSql(currentTabData.id, currentTabData, false);
                }
                break;
            }
            case ID_COLLECTIONS.TASK_SAVE_ID: {
                taskSaveService.save().catch((err: Error | undefined) => {
                    if (err) {
                        message.error(err.message);
                    }
                });
                break;
            }
            case ID_COLLECTIONS.TASK_SUBMIT_ID: {
                const currentTab = current.tab;

                const target = document.getElementById(CONTAINER_ID);
                if (target) {
                    target.parentElement?.removeChild(target);
                }
                const node = document.createElement('div');
                node.id = CONTAINER_ID;
                document.getElementById('molecule')!.appendChild(node);

                const root = createRoot(node);

                if (currentTab) {
                    root.render(<Publish taskId={currentTab.data.id} />);
                }
                break;
            }

            case ID_COLLECTIONS.TASK_OPS_ID: {
                const currentTabData: (CatalogueDataProps & IOfflineTaskProps & { value?: string }) | undefined =
                    current.tab?.data;
                if (currentTabData) {
                    const computerType = taskRenderService
                        .getState()
                        .supportTaskList.find((t) => t.key === currentTabData.taskType)?.computeType;

                    if (computerType !== undefined) {
                        const targetDrawer =
                            computerType === IComputeType.STREAM ? DRAWER_MENU_ENUM.STREAM_TASK : DRAWER_MENU_ENUM.TASK;

                        history.push({
                            query: {
                                drawer: targetDrawer,
                                tname: currentTabData.name,
                            },
                        });
                    } else {
                        notification.error({
                            key: 'WITHOUT_SUPPORT_TASK',
                            message: `????????????????????????????????????????????????????????????????????? ${currentTabData.taskType} ?????????`,
                        });
                    }
                }
                break;
            }
            case ID_COLLECTIONS.TASK_CONVERT_SCRIPT: {
                const currentTabData: (CatalogueDataProps & IOfflineTaskProps & { value?: string }) | undefined =
                    current.tab?.data;
                if (currentTabData) {
                    Modal.confirm({
                        title: '???????????????',
                        content: (
                            <div>
                                <p style={{ color: '#f04134' }}>????????????????????????????????????</p>
                                <p>?????????????????????????????????????????????????????????????????????????????????????????????????????????</p>
                            </div>
                        ),
                        okText: '??????',
                        cancelText: '??????',
                        onOk() {
                            switch (currentTabData.taskType) {
                                case TASK_TYPE_ENUM.SYNC:
                                    api.convertDataSyncToScriptMode({
                                        id: currentTabData.id,
                                    }).then((res) => {
                                        if (res.code === 1) {
                                            message.success('???????????????');
                                            api.getOfflineTaskByID({
                                                id: currentTabData.id,
                                            }).then((result) => {
                                                if (result.code === 1) {
                                                    molecule.editor.updateTab({
                                                        id: result.data.id.toString(),
                                                        data: {
                                                            ...currentTabData,
                                                            ...result.data,
                                                            language: 'json',
                                                            value: prettierJSONstring(result.data.sqlText),
                                                        },
                                                        renderPane: undefined,
                                                    });
                                                }
                                            });
                                        }
                                    });
                                    break;
                                case TASK_TYPE_ENUM.DATA_ACQUISITION:
                                case TASK_TYPE_ENUM.SQL: {
                                    api.convertToScriptMode({
                                        id: currentTabData.id,
                                        createModel: currentTabData.createModel,
                                        componentVersion: currentTabData.componentVersion,
                                    }).then((res) => {
                                        if (res.code === 1) {
                                            message.success('???????????????');
                                            // update current values
                                            api.getOfflineTaskByID({
                                                id: currentTabData.id,
                                            }).then((result) => {
                                                if (result.code === 1) {
                                                    if (currentTabData.taskType === TASK_TYPE_ENUM.DATA_ACQUISITION) {
                                                        const nextTabData = current.tab!;
                                                        nextTabData!.data = result.data;
                                                        Reflect.deleteProperty(nextTabData, 'renderPane');
                                                        nextTabData.data.language = mappingTaskTypeToLanguage(
                                                            result.data.taskType
                                                        );
                                                        nextTabData.data.value = result?.data?.sqlText;
                                                        molecule.editor.updateTab(nextTabData);
                                                        return;
                                                    }

                                                    const nextTabData = result.data;
                                                    molecule.editor.updateTab({
                                                        id: nextTabData.id.toString(),
                                                        data: {
                                                            ...currentTabData,
                                                            ...nextTabData,
                                                        },
                                                    });
                                                    // update the editor's value
                                                    molecule.editor.editorInstance
                                                        .getModel()
                                                        ?.setValue(nextTabData.sqlText);
                                                    editorActionBarService.performSyncTaskActions();
                                                }
                                            });
                                        }
                                    });
                                    break;
                                }
                                default:
                                    break;
                            }
                        },
                    });
                }
                break;
            }
            // FlinkSQL ????????????
            case ID_COLLECTIONS.TASK_SYNTAX_ID: {
                syntaxValidate(current);
                break;
            }
            // FlinkSQL ?????????
            case ID_COLLECTIONS.TASK_FORMAT_ID: {
                api.sqlFormat({ sql: current.tab?.data.value }).then((res) => {
                    if (res.code === 1) {
                        molecule.editor.editorInstance.getModel()?.setValue(res.data);
                    }
                });
                break;
            }
            default:
                break;
        }
    });
}

const updateTaskVariables = debounce((tab: molecule.model.IEditorTab<any>) => {
    // ??????????????????????????????????????????????????????????????????
    const currentData: IOfflineTaskProps & { value?: string } = tab.data;
    let sqlText = '';
    switch (currentData.taskType) {
        case TASK_TYPE_ENUM.SYNC:
            // ???????????????????????????????????????
            sqlText = `
				${currentData.sourceMap.where}
				${currentData.sourceMap.partition}
				${currentData.sourceMap.column?.map((col) => `${col.key || col.index}\n${col.value || ''}`).join('\n')}
				${currentData.sourceMap.path}
				${currentData.targetMap?.preSql || ''}
				${currentData.targetMap?.postSql || ''}
				${currentData.targetMap?.partition || ''}
				${currentData.targetMap?.fileName || ''}
				${currentData.targetMap?.path || ''}
				`;
            break;
        default:
            sqlText = currentData.value || '';
            break;
    }
    const nextVariables = taskParamsService.matchTaskParams(sqlText);
    const preVariables: Partial<IParamsProps>[] = currentData?.taskVariables || [];

    // Prevent reset the value of the exist params
    const data = nextVariables.map((i) => {
        const existedVar = preVariables.find((v) => v.paramName === i.paramName);
        if (existedVar) {
            return existedVar;
        }
        return i;
    });

    molecule.editor.updateTab({
        id: tab.id,
        data: {
            ...currentData,
            taskVariables: data,
        },
    });
}, 300);

// ??????????????????
function registerCompletion() {
    const COMPLETION_SQL = [
        TASK_LANGUAGE.SPARKSQL,
        TASK_LANGUAGE.HIVESQL,
        TASK_LANGUAGE.SQL,
        TASK_LANGUAGE.FLINKSQL,
    ] as const;
    COMPLETION_SQL.forEach((sql) =>
        languages.registerCompletionItemProvider(sql, {
            async provideCompletionItems(model, position) {
                const word = model.getWordUntilPosition(position);
                const range = {
                    startLineNumber: position.lineNumber,
                    endLineNumber: position.lineNumber,
                    startColumn: word.startColumn,
                    endColumn: word.endColumn,
                };

                const suggestions = await createSQLProposals(range);
                return {
                    suggestions,
                };
            },
        })
    );
}

export default class EditorExtension implements IExtension {
    id: UniqueId = 'editor';
    name = 'editor';
    dispose(): void {
        throw new Error('Method not implemented.');
    }
    activate() {
        emitEvent();
        registerCompletion();

        molecule.editor.onOpenTab((tab) => {
            viewStoreService.clearStorage(tab.id.toString());
        });

        onTaskSwitch(() =>
            // Should delay to performSyncTaskActions
            // because when onOpenTab called, the current tab was not changed
            window.requestAnimationFrame(() => {
                editorActionBarService.performSyncTaskActions();
            })
        );

        molecule.editor.onUpdateTab((tab) => {
            updateTaskVariables(tab);
            // update edited status
            molecule.editor.updateTab({ id: tab.id, status: 'edited' });
        });

        executeService.onEndRun((currentTabId) => {
            if (currentTabId.toString() !== molecule.editor.getState().current?.activeTab) {
                const groupId = molecule.editor.getGroupIdByTab(currentTabId.toString());
                if (groupId === null) return;
                const tab = molecule.editor.getTabById(currentTabId.toString(), groupId);
                if (!tab) return;
                notification.success({
                    key: `${currentTabId}-${new Date()}`,
                    message: `${tab.name} ??????????????????!`,
                });
            }
        });

        // ????????????????????????
        taskSaveService.onSaveTask(({ id }) => {
            api.getOfflineTaskByID<IOfflineTaskProps>({ id }).then((res) => {
                if (res.code === 1) {
                    const task = res.data;
                    const currentTab: molecule.model.IEditorTab<IOfflineTaskProps> | undefined =
                        molecule.editor.getState().current?.tab;

                    if (!currentTab) return;

                    // ???????????? tab ?????????????????????
                    molecule.editor.updateTab({
                        id: currentTab.id,
                        status: undefined,
                    });

                    // ??????????????????????????????
                    if (task.flowId) {
                        // 1. ?????? viewStorage ?????? cell ??????
                        const viewStorage = viewStoreService.getViewStorage<{
                            cells: mxCell[];
                            geometry: IGeometryPosition;
                        }>(task.flowId.toString());

                        const targetCell = viewStorage.cells.find((cell) => cell.value?.id === currentTab.data!.id);

                        if (targetCell) {
                            targetCell.setValue({
                                ...targetCell.value,
                                ...task,
                                [isEditing]: false,
                            });

                            viewStoreService.setViewStorage(task.flowId.toString(), {
                                ...viewStorage,
                            });
                        }

                        // ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
                        // 2. ?????? editor.tab ????????????
                        molecule.editor.updateTab({
                            id: currentTab.id,
                            data: { ...currentTab.data!, ...task },
                        });

                        // 3. ?????????????????? tab ?????????
                        const workflowId = task.flowId.toString();
                        const workflowTabGroup = molecule.editor.getGroupIdByTab(workflowId);
                        if (!workflowTabGroup) return;
                        const workflowTab = molecule.editor.getTabById(workflowId, workflowTabGroup);
                        if (!workflowTab) return;
                        if (workflowTab.status !== 'edited') {
                            molecule.editor.updateTab({
                                id: workflowTab.id,
                                status: 'edited',
                            });
                        }
                    }

                    // ???????????????????????????????????????????????????????????????
                    if (task.taskType === TASK_TYPE_ENUM.WORK_FLOW) {
                        const { groups = [] } = molecule.editor.getState();
                        groups.forEach((group) => {
                            group.data?.forEach((tab) => {
                                if (tab.data?.flowId === id) {
                                    api.getOfflineTaskByID<IOfflineTaskProps>({
                                        id: tab.data.id,
                                    }).then((subResult) => {
                                        if (subResult.code === 1) {
                                            molecule.editor.updateTab(
                                                {
                                                    id: tab.id,
                                                    data: {
                                                        ...tab.data,
                                                        ...subResult.data,
                                                    },
                                                },
                                                group.id
                                            );
                                        }
                                    });
                                }
                            });
                        });
                    }
                }
            });
        });
    }
}
