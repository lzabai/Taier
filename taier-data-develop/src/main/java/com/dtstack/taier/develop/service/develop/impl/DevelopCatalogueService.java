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

package com.dtstack.taier.develop.service.develop.impl;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.dtstack.taier.common.enums.CatalogueLevel;
import com.dtstack.taier.common.enums.CatalogueType;
import com.dtstack.taier.common.enums.Deleted;
import com.dtstack.taier.common.enums.DictType;
import com.dtstack.taier.common.enums.EScheduleJobType;
import com.dtstack.taier.common.enums.EngineCatalogueType;
import com.dtstack.taier.common.exception.DtCenterDefException;
import com.dtstack.taier.common.exception.ErrorCode;
import com.dtstack.taier.common.exception.TaierDefineException;
import com.dtstack.taier.dao.domain.DevelopCatalogue;
import com.dtstack.taier.dao.domain.DevelopFunction;
import com.dtstack.taier.dao.domain.DevelopResource;
import com.dtstack.taier.dao.domain.Dict;
import com.dtstack.taier.dao.domain.Task;
import com.dtstack.taier.dao.mapper.DevelopCatalogueMapper;
import com.dtstack.taier.develop.dto.devlop.CatalogueVO;
import com.dtstack.taier.develop.dto.devlop.DevelopCatalogueVO;
import com.dtstack.taier.develop.enums.develop.RdosBatchCatalogueTypeEnum;
import com.dtstack.taier.develop.service.console.ClusterTenantService;
import com.dtstack.taier.scheduler.service.ScheduleDictService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class DevelopCatalogueService {

    @Autowired
    private DevelopCatalogueMapper developCatalogueMapper;

    @Autowired
    private DevelopResourceService developResourceService;

    @Autowired
    private DevelopFunctionService developFunctionService;

    @Autowired
    private ScheduleDictService dictService;

    @Autowired
    public DevelopTaskService developTaskService;

    @Autowired
    private ClusterTenantService clusterTenantService;


    private static final String FUNCTION_MANAGER_NAME = "????????????";

    private static final Long DEFAULT_NODE_PID = 0L;

    private static Integer SUB_AMOUNTS_LIMIT = 2000;

    private final static String FILE_TYPE_FOLDER = "folder";


    /**
     * ???????????????????????????????????????????????????????????????
     *
     * @return
     */
    public CatalogueVO getLocation(Long tenantId, String catalogueType, Long id, String name) {
        // ?????????????????????????????????id???????????????????????????
        List<Long> grandCatalogueIds = grandCatalogueIds(tenantId, catalogueType, id, name);
        //???????????????
        DevelopCatalogue rootCatalogue = getRootCatalogueByType(tenantId, catalogueType);

        CatalogueVO root = CatalogueVO.toVO(rootCatalogue);
        root.setType("folder");
        getTree(root, grandCatalogueIds, tenantId, catalogueType);
        return root;
    }

    public List<Long> grandCatalogueIds(Long tenantId, String catalogueType, Long id, String name) {
        // ?????????????????????????????????id???????????????????????????
        List<Long> grandCatalogueIds = new ArrayList<>();
        if (CatalogueType.TASK_DEVELOP.getType().equals(catalogueType)) {
            grandCatalogueIds = grandCatalogueTaskIds(tenantId, id, name);
        } else if (CatalogueType.RESOURCE_MANAGER.getType().equals(catalogueType)) {
            grandCatalogueIds = grandCatalogueResourceIds(id);
        }else {
            throw new DtCenterDefException("???????????????");
        }
        return grandCatalogueIds;
    }


    /**
     * ?????????????????????????????????
     *
     * @param tenantId
     * @param catalogueType
     * @return
     */
    private DevelopCatalogue getRootCatalogueByType(Long tenantId, String catalogueType) {
        DevelopCatalogue rootCatalogue = null;
        if (CatalogueType.TASK_DEVELOP.getType().equals(catalogueType)) {
            //??????????????????????????????
            rootCatalogue = developCatalogueMapper.selectOne(Wrappers.lambdaQuery(DevelopCatalogue.class)
                    .eq(DevelopCatalogue::getTenantId, tenantId)
                    .eq(DevelopCatalogue::getNodePid, 0)
                    .eq(DevelopCatalogue::getNodeName, "????????????")
                    .last("limit 1"));
        } else if (CatalogueType.RESOURCE_MANAGER.getType().equals(catalogueType)) {
            //??????????????????????????????
            rootCatalogue = developCatalogueMapper.selectOne(Wrappers.lambdaQuery(DevelopCatalogue.class)
                    .eq(DevelopCatalogue::getTenantId, tenantId)
                    .eq(DevelopCatalogue::getNodePid, 0)
                    .eq(DevelopCatalogue::getNodeName, "????????????")
                    .last("limit 1"));
        }
        if (rootCatalogue == null) {
            throw new DtCenterDefException("??????????????????");
        }
        return rootCatalogue;
    }


    private void getTree(CatalogueVO root, List<Long> grandCatalogueIds, Long tenantId, String catalogueType) {
        if (StringUtils.isBlank(root.getCatalogueType())) {
            root.setCatalogueType(catalogueType);
        }

        if (grandCatalogueIds.contains(root.getId())) {
            if (CollectionUtils.isEmpty(root.getChildren()) && "folder".equals(root.getType())) {
                getChildNode(root, true, tenantId);
            }
        } else {
            getChildNode(root, false, tenantId);
        }

        if (CollectionUtils.isNotEmpty(root.getChildren())) {
            for (CatalogueVO vo : root.getChildren()) {
                if ("folder".equals(vo.getType())) {
                    getTree(vo, grandCatalogueIds, tenantId, catalogueType);
                }
            }
        }
    }

    /**
     * ????????????ID????????????????????????????????????id???????????????????????????
     *
     * @param tenantId
     * @param taskId
     * @param name
     * @return
     */
    private List<Long> grandCatalogueTaskIds(Long tenantId, Long taskId, String name) {
        List<Long> grandCatalogueIds = new ArrayList<>();
        if (taskId != null) {
            Task task = developTaskService.getOne(taskId);
            if (task != null) {
                getGrandCatalogueIds(task.getNodePid(), grandCatalogueIds);
            }
        } else if (StringUtils.isNotEmpty(name)) {
            List<Task> tasks = developTaskService.getByLikeName(name, tenantId);
            if (CollectionUtils.isNotEmpty(tasks)) {
                for (Task task : tasks) {
                    getGrandCatalogueIds(task.getNodePid(), grandCatalogueIds);
                }
            }
        }
        return grandCatalogueIds;
    }


    /**
     * ????????????ID????????????????????????????????????id???????????????????????????
     *
     * @param resourceId
     * @return
     */
    public List<Long> grandCatalogueResourceIds(Long resourceId) {
        List<Long> grandCatalogueIds = new ArrayList<>();
        if (resourceId != null) {
            DevelopResource developResource = developResourceService.getResource(resourceId);
            if (developResource != null) {
                getGrandCatalogueIds(developResource.getNodePid(), grandCatalogueIds);
            }
        }
        return grandCatalogueIds;
    }

    /**
     * ?????? and ????????????
     *
     * @param catalogue
     * @return
     */
    public CatalogueVO addCatalogue(DevelopCatalogue catalogue) {
        if (Objects.isNull(catalogue)) {
            throw new TaierDefineException(ErrorCode.CATALOGUE_NOT_EMPTY);
        }
        if (StringUtils.isBlank(catalogue.getNodeName())) {
            throw new TaierDefineException(ErrorCode.CATALOGUE_NAME_NOT_EMPTY);
        }
        catalogue.setNodeName(catalogue.getNodeName().trim());
        // ????????????????????????????????????
        if (catalogue.getNodeName().contains(" ")) {
            throw new TaierDefineException(ErrorCode.CATALOGUE_NAME_CANNOT_CONTAIN_SPACES);
        }
        DevelopCatalogue dbCatalogue = developCatalogueMapper.selectOne(Wrappers.lambdaQuery(DevelopCatalogue.class)
                .eq(DevelopCatalogue::getTenantId, catalogue.getTenantId())
                .eq(DevelopCatalogue::getNodePid, catalogue.getNodePid())
                .eq(DevelopCatalogue::getNodeName, catalogue.getNodeName())
                .last("limit 1"));
        if (dbCatalogue != null) {
            throw new TaierDefineException(ErrorCode.CATALOGUE_EXISTS);
        }

        // ?????????????????????????????????????????????????????????????????????????????????SUB_AMOUNTS_LIMIT(2000)
        Integer subAmountsByNodePid = developCatalogueMapper.selectCount(
                Wrappers.lambdaQuery(DevelopCatalogue.class)
                        .eq(DevelopCatalogue::getNodePid, catalogue.getNodePid())
                        .eq(DevelopCatalogue::getTenantId, catalogue.getTenantId()));
        if (subAmountsByNodePid >= SUB_AMOUNTS_LIMIT) {
            throw new TaierDefineException(ErrorCode.SUBDIRECTORY_OR_FILE_AMOUNT_RESTRICTIONS);
        }

        int parentCatalogueLevel = catalogue.getNodePid() == 0L ? 0 : this.isOverLevelLimit(catalogue.getNodePid());

        catalogue.setLevel(parentCatalogueLevel + 1);
        catalogue.setCreateUserId(catalogue.getCreateUserId());
        catalogue.setGmtModified(Timestamp.valueOf(LocalDateTime.now()));
        catalogue.setGmtCreate(Timestamp.valueOf(LocalDateTime.now()));

        if (null == catalogue.getCatalogueType()) {
            catalogue.setCatalogueType(RdosBatchCatalogueTypeEnum.NORAML.getType());
        }
        if (RdosBatchCatalogueTypeEnum.TENANT.getType().equals(catalogue.getCatalogueType())) {
            if (catalogue.getLevel() > 3) {
                throw new TaierDefineException(ErrorCode.CREATE_TENANT_CATALOGUE_LEVE);
            }
        }
        addOrUpdate(catalogue);

        CatalogueVO cv = CatalogueVO.toVO(catalogue);
        cv.setType(DevelopCatalogueService.FILE_TYPE_FOLDER);
        return cv;
    }


    /**
     * ?????? and ????????????
     *
     * @param developCatalogue
     * @return
     */
    private DevelopCatalogue addOrUpdate(DevelopCatalogue developCatalogue) {
        developCatalogue.setGmtModified(new Timestamp(System.currentTimeMillis()));
        if (developCatalogue.getId() != null && developCatalogue.getId() > 0) {
            LambdaUpdateWrapper<DevelopCatalogue> developCatalogueLambdaUpdateWrapper = new LambdaUpdateWrapper<>();
            developCatalogueLambdaUpdateWrapper.eq(DevelopCatalogue::getIsDeleted, Deleted.NORMAL.getStatus()).eq(DevelopCatalogue::getId, developCatalogue.getId());
            developCatalogueMapper.update(developCatalogue, developCatalogueLambdaUpdateWrapper);
        } else {
            developCatalogue.setGmtCreate(new Timestamp(System.currentTimeMillis()));
            developCatalogueMapper.insert(developCatalogue);
        }
        return developCatalogue;
    }

    /**
     * ???????????????????????????????????????
     *
     * @param tenantId
     * @param userId
     */
    @Transactional(rollbackFor = Exception.class)
    public void initCatalogue(Long tenantId, Long userId) {
        List<Dict> catalogueLevel1List = dictService.listByDictType(DictType.DATA_DEVELOP_CATALOGUE);
        List<Dict> catalogueLevel2List = dictService.listByDictType(DictType.DATA_DEVELOP_CATALOGUE_L1);
        Map<String, Set<String>> oneCatalogueValueAndNameMapping = catalogueLevel2List.stream()
                .collect(Collectors.groupingBy(Dict::getDictValue, Collectors.mapping(Dict::getDictDesc, Collectors.toSet())));
        for (Dict zeroDict : catalogueLevel1List) {
            //????????? 0 ?????????
            DevelopCatalogue zeroBatchCatalogue = new DevelopCatalogue();
            zeroBatchCatalogue.setNodeName(zeroDict.getDictDesc());
            zeroBatchCatalogue.setNodePid(DEFAULT_NODE_PID);
            zeroBatchCatalogue.setOrderVal(zeroDict.getSort());
            zeroBatchCatalogue.setLevel(CatalogueLevel.ONE.getLevel());
            zeroBatchCatalogue.setTenantId(tenantId);
            zeroBatchCatalogue.setCreateUserId(userId);
            zeroBatchCatalogue.setCatalogueType(RdosBatchCatalogueTypeEnum.NORAML.getType());
            addOrUpdate(zeroBatchCatalogue);
            if (CollectionUtils.isNotEmpty(oneCatalogueValueAndNameMapping.get(zeroDict.getDictValue()))) {
                for (String oneCatalogueName : oneCatalogueValueAndNameMapping.get(zeroDict.getDictValue())) {
                    //????????? 1 ?????????
                    DevelopCatalogue oneBatchCatalogue = new DevelopCatalogue();
                    oneBatchCatalogue.setNodeName(oneCatalogueName);
                    oneBatchCatalogue.setLevel(CatalogueLevel.SECOND.getLevel());
                    oneBatchCatalogue.setNodePid(zeroBatchCatalogue.getId());
                    oneBatchCatalogue.setTenantId(tenantId);
                    oneBatchCatalogue.setCreateUserId(userId);
                    oneBatchCatalogue.setCatalogueType(RdosBatchCatalogueTypeEnum.NORAML.getType());
                    addOrUpdate(oneBatchCatalogue);
                }
            }
        }
    }

    /**
     * ????????????????????????????????????????????????????????????????????????
     *
     * @param currentId
     * @param ids
     * @return
     */
    private void getGrandCatalogueIds(Long currentId, List<Long> ids) {
        ids.add(currentId);
        getGrandCatalogueId(currentId, ids);
    }

    /**
     * ???????????????????????????????????????????????????
     *
     * @param currentId
     * @param ids
     * @return ???????????????
     */
    private void getGrandCatalogueId(Long currentId, List<Long> ids) {
        DevelopCatalogue catalogue = developCatalogueMapper.selectById(currentId);
        if (catalogue != null && catalogue.getLevel() >= 1) {
            ids.add(catalogue.getNodePid());
            getGrandCatalogueId(catalogue.getNodePid(), ids);
        }
    }

    /**
     * ??????????????????
     *
     * @param isGetFile
     * @param nodePid
     * @param catalogueType
     * @param tenantId
     * @return
     */
    public CatalogueVO getCatalogue(Boolean isGetFile, Long nodePid, String catalogueType, Long tenantId) {
        beforeGetCatalogue(tenantId);
        CatalogueVO rootCatalogue = new CatalogueVO();
        //0???????????????
        if (nodePid == 0) {
            List<CatalogueVO> catalogues = getCatalogueOne(tenantId);
            rootCatalogue.setChildren(catalogues);
        } else {
            rootCatalogue.setId(nodePid);
            rootCatalogue.setCatalogueType(catalogueType);
            rootCatalogue = getChildNode(rootCatalogue, isGetFile, tenantId);
        }
        return rootCatalogue;
    }

    /**
     * ????????????????????????
     *
     * @param tenantId
     */
    public void beforeGetCatalogue(Long tenantId) {
        if (Objects.isNull(tenantId)) {
            throw new TaierDefineException(ErrorCode.TENANT_ID_NOT_NULL);
        }
        Long clusterId = clusterTenantService.getClusterIdByTenantId(tenantId);
        if (Objects.isNull(clusterId)) {
            throw new TaierDefineException(ErrorCode.CLUSTER_NOT_CONFIG);
        }
    }

    /**
     * ?????????????????????????????????)
     *
     * @param catalogueInput
     */
    public void updateCatalogue(DevelopCatalogueVO catalogueInput) {
        DevelopCatalogue catalogue = developCatalogueMapper.selectById(catalogueInput.getId());
        catalogueOneNotUpdate(catalogue);
        if (catalogue.getIsDeleted() == 1) {
            throw new TaierDefineException(ErrorCode.CAN_NOT_FIND_CATALOGUE);
        }

        if (canNotMoveCatalogue(catalogueInput.getId(), catalogueInput.getNodePid())) {
            throw new TaierDefineException(ErrorCode.CAN_NOT_MOVE_CATALOGUE);
        }
        DevelopCatalogue updateCatalogue = new DevelopCatalogue();
        updateCatalogue.setId(catalogueInput.getId());
        //?????????
        if (catalogueInput.getNodeName() != null) {
            updateCatalogue.setNodeName(catalogueInput.getNodeName());
        }
        //??????
        if (catalogueInput.getNodePid() != null && catalogueInput.getNodePid() != 0) {
            int parentLevel = this.isOverLevelLimit(catalogueInput.getNodePid());
            updateCatalogue.setLevel(parentLevel + 1);
            updateCatalogue.setNodePid(catalogueInput.getNodePid());
        } else {
            updateCatalogue.setNodePid(catalogue.getNodePid());
        }
        //???????????????????????? ?????????????????????????????????
        DevelopCatalogue byLevelAndPIdAndTenantIdAndName = developCatalogueMapper.selectOne(Wrappers.lambdaQuery(DevelopCatalogue.class)
                .eq(DevelopCatalogue::getTenantId, catalogue.getTenantId())
                .eq(DevelopCatalogue::getNodeName, updateCatalogue.getNodeName())
                .eq(DevelopCatalogue::getNodePid, updateCatalogue.getNodePid())
                .last("limit 1"));
        if (byLevelAndPIdAndTenantIdAndName != null && (!byLevelAndPIdAndTenantIdAndName.getId().equals(catalogue.getId()))) {
            throw new TaierDefineException(ErrorCode.FILE_NAME_REPETITION);
        }
        updateCatalogue.setGmtModified(Timestamp.valueOf(LocalDateTime.now()));
        addOrUpdate(updateCatalogue);

    }

    /**
     * ????????????
     *
     * @param catalogueInput
     */
    public void deleteCatalogue(DevelopCatalogue catalogueInput) {
        DevelopCatalogue catalogue = developCatalogueMapper.selectById(catalogueInput.getId());
        if (Objects.isNull(catalogue) || catalogue.getIsDeleted() == 1) {
            throw new TaierDefineException(ErrorCode.CAN_NOT_FIND_CATALOGUE);
        }

        catalogueOneNotUpdate(catalogue);

        //????????????????????????
        List<Task> taskList = developTaskService.listBatchTaskByNodePid(catalogueInput.getTenantId(), catalogue.getId());
        List<DevelopResource> resourceList = developResourceService.listByPidAndTenantId(catalogueInput.getTenantId(), catalogue.getId());

        if (taskList.size() > 0 || resourceList.size() > 0) {
            throw new TaierDefineException(ErrorCode.CATALOGUE_NO_EMPTY);
        }

        //???????????????????????????
        List<DevelopCatalogue> developCatalogues = developCatalogueMapper.selectList(Wrappers.lambdaQuery(DevelopCatalogue.class)
                .eq(DevelopCatalogue::getTenantId, catalogueInput.getTenantId())
                .eq(DevelopCatalogue::getNodePid, catalogue.getId())
                .orderByDesc(DevelopCatalogue::getGmtCreate));
        if (CollectionUtils.isNotEmpty(developCatalogues)) {
            throw new TaierDefineException(ErrorCode.CATALOGUE_NO_EMPTY);
        }

        catalogue.setIsDeleted(Deleted.DELETED.getStatus());
        catalogue.setGmtModified(Timestamp.valueOf(LocalDateTime.now()));
        developCatalogueMapper.deleteById(catalogue.getId());
    }

    /**
     * ???????????????????????????
     *
     * @param catalogue
     * @author
     */
    private void catalogueOneNotUpdate(DevelopCatalogue catalogue) {
        if (catalogue.getCatalogueType().equals(RdosBatchCatalogueTypeEnum.TENANT.getType())) {
            if (catalogue.getLevel() == 0) {
                throw new TaierDefineException(ErrorCode.PERMISSION_LIMIT);
            }
        } else {
            if (catalogue.getLevel() == 0 || catalogue.getLevel() == 1) {
                throw new TaierDefineException(ErrorCode.PERMISSION_LIMIT);
            }
        }
    }

    /**
     * ????????????????????????????????????
     *
     * @param nodePid ?????????id
     * @return
     * @author
     */
    private int isOverLevelLimit(long nodePid) {
        DevelopCatalogue parentCatalogue = developCatalogueMapper.selectById(nodePid);
        return parentCatalogue.getLevel();
    }

    /**
     * ?????? ?????? ?????? 0 ????????????????????????
     *
     * @param tenantId
     * @return
     */
    public List<CatalogueVO> getCatalogueOne(Long tenantId) {
        //?????? 0 ?????????
        List<DevelopCatalogue> zeroCatalogues = developCatalogueMapper.selectList(Wrappers.lambdaQuery(DevelopCatalogue.class)
                .eq(DevelopCatalogue::getTenantId, tenantId)
                .eq(DevelopCatalogue::getLevel, 0)
                .orderByAsc(DevelopCatalogue::getOrderVal));
        //???????????????????????????????????? 0 ?????????
        List<Dict> zeroCatalogueDictList = dictService.listByDictType(DictType.DATA_DEVELOP_CATALOGUE);
        //???????????????????????????????????? 1 ?????????
        List<Dict> oneCatalogueDictList = dictService.listByDictType(DictType.DATA_DEVELOP_CATALOGUE_L1);

        // 0 ?????????????????????????????????
        Map<String, String> zeroCatalogueType = zeroCatalogueDictList.stream().collect(Collectors.toMap(Dict::getDictDesc, Dict::getDictName, (key1, key2) -> key1));
        // 1 ?????????????????????????????????
        Map<String, String> oneCatalogueType = oneCatalogueDictList.stream().collect(Collectors.toMap(Dict::getDictDesc, Dict::getDictName, (key1, key2) -> key1));

        List<CatalogueVO> zeroCatalogueVOList = new ArrayList<>(zeroCatalogues.size());
        for (DevelopCatalogue zeroCatalogue : zeroCatalogues) {
            CatalogueVO zeroCatalogueVO = CatalogueVO.toVO(zeroCatalogue);
            zeroCatalogueVO.setCatalogueType(zeroCatalogueType.get(zeroCatalogue.getNodeName()));
            zeroCatalogueVO.setType(FILE_TYPE_FOLDER);
            zeroCatalogueVOList.add(zeroCatalogueVO);

            //?????????????????????????????????
            List<DevelopCatalogue> oneChildCatalogues = developCatalogueMapper.selectList(Wrappers.lambdaQuery(DevelopCatalogue.class)
                    .eq(DevelopCatalogue::getTenantId, tenantId)
                    .eq(DevelopCatalogue::getNodePid, zeroCatalogue.getId())
                    .orderByDesc(DevelopCatalogue::getGmtCreate));
            if (FUNCTION_MANAGER_NAME.equals(zeroCatalogue.getNodeName())) {
                //?????????????????????????????????????????????????????????
                DevelopCatalogue systemFuncCatalogue = developCatalogueMapper.selectOne(Wrappers.lambdaQuery(DevelopCatalogue.class)
                        .eq(DevelopCatalogue::getNodePid, EngineCatalogueType.SPARK.getType())
                        .eq(DevelopCatalogue::getLevel, 1)
                        .eq(DevelopCatalogue::getTenantId, -1)
                        .last("limit 1"));
                if (systemFuncCatalogue != null) {
                    oneChildCatalogues.add(systemFuncCatalogue);
                }
            }
            List<CatalogueVO> oneChildCatalogueVOList = new ArrayList<>(oneChildCatalogues.size());
            for (DevelopCatalogue oneChildCatalogue : oneChildCatalogues) {
                CatalogueVO oneChildCatalogueVO = CatalogueVO.toVO(oneChildCatalogue);
                if (EngineCatalogueType.SPARK.getDesc().equals(oneChildCatalogueVO.getName())) {
                    // spark  ???????????? ????????????
                    oneChildCatalogueVO.setType("catalogue");
                } else {
                    oneChildCatalogueVO.setType("folder");
                }
                oneChildCatalogueVO.setCatalogueType(oneCatalogueType.get(oneChildCatalogue.getNodeName()));
                oneChildCatalogueVOList.add(oneChildCatalogueVO);
            }
            zeroCatalogueVO.setChildren(oneChildCatalogueVOList);
        }
        return zeroCatalogueVOList;
    }


    /**
     * ???????????????????????????????????????????????????????????????????????????
     *
     * @param tenantId  ??????id
     * @param isGetFile
     * @return
     * @author
     */
    private CatalogueVO getChildNode(CatalogueVO currentCatalogueVO, Boolean isGetFile, Long tenantId) {
        DevelopCatalogue currentCatalogue = developCatalogueMapper.selectById(currentCatalogueVO.getId());
        if (Objects.isNull(currentCatalogue)) {
            throw new TaierDefineException(ErrorCode.CAN_NOT_FIND_CATALOGUE);
        }
        currentCatalogueVO.setTenantId(currentCatalogue.getTenantId());
        currentCatalogueVO.setName(currentCatalogue.getNodeName());
        currentCatalogueVO.setLevel(currentCatalogue.getLevel());
        currentCatalogueVO.setParentId(currentCatalogue.getNodePid());
        currentCatalogueVO.setType(FILE_TYPE_FOLDER);

        //???????????????????????????????????????
        if (isGetFile) {
            //????????????????????????
            List<CatalogueVO> catalogueChildFileList = Lists.newArrayList();
            //??????????????????
            Map<Long, List<CatalogueVO>> flowChildren = Maps.newHashMap();
            //????????????
            if (CatalogueType.TASK_DEVELOP.getType().equals(currentCatalogueVO.getCatalogueType())) {
                List<Task> taskList = developTaskService.catalogueListBatchTaskByNodePid(tenantId, currentCatalogueVO.getId());
                taskList.sort(Comparator.comparing(Task::getName));
                if (CollectionUtils.isNotEmpty(taskList)) {
                    //??????????????????????????????
                    for (Task task : taskList) {
                        CatalogueVO childCatalogueTask = new CatalogueVO();
                        BeanUtils.copyProperties(task, childCatalogueTask);
                        if (task.getTaskType().intValue() == EScheduleJobType.WORK_FLOW.getVal()) {
                            childCatalogueTask.setType("flow");
                        } else {
                            childCatalogueTask.setType("file");
                        }
                        childCatalogueTask.setLevel(currentCatalogueVO.getLevel() + 1);

                        childCatalogueTask.setParentId(currentCatalogueVO.getId());
                        if (task.getFlowId() > 0L) {
                            List<CatalogueVO> temp = flowChildren.get(task.getFlowId());
                            if (CollectionUtils.isEmpty(temp)) {
                                temp = Lists.newArrayList();
                                temp.add(childCatalogueTask);
                                flowChildren.put(task.getFlowId(), temp);
                            } else {
                                flowChildren.get(task.getFlowId()).add(childCatalogueTask);
                            }
                        } else {
                            catalogueChildFileList.add(childCatalogueTask);
                        }
                    }

                    //????????????????????????
                    for (CatalogueVO catalogueVO : catalogueChildFileList) {
                        List<CatalogueVO> children = flowChildren.get(catalogueVO.getId());
                        if (CollectionUtils.isNotEmpty(children)){
                            catalogueVO.setChildren(children);
                        }
                    }
                }
            } else if (CatalogueType.FUNCTION_MANAGER.getType().equals(currentCatalogueVO.getCatalogueType())) {
                //??????????????????
                List<DevelopFunction> functionList = developFunctionService.listByNodePidAndTenantId(currentCatalogueVO.getTenantId(), currentCatalogueVO.getId());
                if (CollectionUtils.isNotEmpty(functionList)) {
                    functionList.sort(Comparator.comparing(DevelopFunction::getName));
                    for (DevelopFunction function : functionList) {
                        CatalogueVO child = new CatalogueVO();
                        BeanUtils.copyProperties(function, child);
                        child.setLevel(currentCatalogueVO.getLevel() + 1);
                        child.setType("file");
                        child.setParentId(function.getNodePid());
                        catalogueChildFileList.add(child);
                    }
                }
            } else if (CatalogueType.RESOURCE_MANAGER.getType().equals(currentCatalogueVO.getCatalogueType())) {
                //??????????????????
                List<DevelopResource> resourceList = developResourceService.listByPidAndTenantId(tenantId, currentCatalogueVO.getId());
                resourceList.sort(Comparator.comparing(DevelopResource::getResourceName));
                if (CollectionUtils.isNotEmpty(resourceList)) {
                    for (DevelopResource resource : resourceList) {
                        CatalogueVO childResource = new CatalogueVO();
                        BeanUtils.copyProperties(resource, childResource);
                        childResource.setName(resource.getResourceName());
                        childResource.setType("file");
                        childResource.setLevel(currentCatalogueVO.getLevel() + 1);
                        childResource.setParentId(currentCatalogueVO.getId());
                        catalogueChildFileList.add(childResource);
                    }
                }
            }
            currentCatalogueVO.setChildren(catalogueChildFileList);
        }

        //???????????????????????????
        List<DevelopCatalogue> childCatalogues = this.getChildCataloguesByNodePid(currentCatalogueVO.getId());
        childCatalogues.sort(Comparator.comparing(DevelopCatalogue::getNodeName));
        List<CatalogueVO> children = new ArrayList<>();
        for (DevelopCatalogue catalogue : childCatalogues) {
            CatalogueVO cv = CatalogueVO.toVO(catalogue);
            cv.setCatalogueType(currentCatalogueVO.getCatalogueType());
            cv.setType(FILE_TYPE_FOLDER);
            children.add(cv);
        }

        if (Objects.isNull(currentCatalogueVO.getChildren())) {
            currentCatalogueVO.setChildren(children);
        } else {
            currentCatalogueVO.getChildren().addAll(0, children);
        }

        return currentCatalogueVO;
    }

    /**
     * ???????????????????????????????????????????????????
     *
     * @param catalogueId
     * @return
     */
    private List<DevelopCatalogue> getChildCataloguesByNodePid(Long catalogueId) {
        List<DevelopCatalogue> childCatalogues = developCatalogueMapper.selectList(Wrappers.lambdaQuery(DevelopCatalogue.class)
                .eq(DevelopCatalogue::getNodePid, catalogueId)
                .orderByDesc(DevelopCatalogue::getGmtCreate));
        return childCatalogues;
    }

    /**
     * ???????????????????????????????????????
     *
     * @param catalogueId
     * @param catalogueNodePid
     * @return
     */
    private boolean canNotMoveCatalogue(Long catalogueId, Long catalogueNodePid) {
        List<Long> ids = Lists.newArrayList();
        getGrandCatalogueIds(catalogueNodePid, ids);
        return ids.contains(catalogueId);
    }

    /**
     * ?????? ??????Id ??????????????????
     *
     * @param nodeId
     * @return
     */
    public DevelopCatalogue getOne(Long nodeId) {
        return developCatalogueMapper.selectById(nodeId);
    }

    /**
     * ?????? ??????Id ??????????????????
     *
     * @param nodeId
     * @return
     */
    public DevelopCatalogue getOneWithError(Long nodeId) {
        DevelopCatalogue catalogue = getOne(nodeId);
        if (Objects.isNull(catalogue)) {
            throw new TaierDefineException(ErrorCode.CAN_NOT_FIND_CATALOGUE);
        }
        return catalogue;
    }

    /**
     * ????????????????????????Id??????
     *
     * @param tenantId ??????ID
     * @param nodePid  ?????????ID
     * @param name     ??????
     * @return
     */
    public DevelopCatalogue getByPidAndName(Long tenantId, Long nodePid, String name) {
        return developCatalogueMapper.selectOne(Wrappers.lambdaQuery(DevelopCatalogue.class)
                .eq(DevelopCatalogue::getTenantId, tenantId)
                .eq(DevelopCatalogue::getNodePid, nodePid)
                .eq(DevelopCatalogue::getNodeName, name)
                .last("limit 1"));
    }

}