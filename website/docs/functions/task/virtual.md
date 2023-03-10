---
title: 虚节点
sidebar_label: 虚节点
---

## 新建任务
虚拟节点属于控制类型任务，是不产生任何数据的空跑任务，常用于多个任务统筹的上游任务（例如作为工作流的初始节点）  
假设：输出表由3个数据同步任务导入的源表经过SQL任务加工产出，这3个数据同步任务没有依赖关系，SQL任务需要依赖3个同步任务，则任务依赖关系如下图所示：  
![virtual](/img/readme/virtual.png)

用一个虚节点任务作为起始根节点，3个数据同步任务依赖虚节点，SQL加工任务依赖3个同步任务  

:::tip
虚节点任务不会真正的执行，虚节点具备运行条件时，将直接被置为成功，所以虚节点没有日志信息
:::