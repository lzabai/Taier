---
title: 运维中心
sidebar_label: 运维中心
---

# 运维中心

## 运维中心功能

- 任务管理：展示提交到调度的任务，可以可以进行补数据，冻结任务等操作
- 周期实例：展示每天生成的周期实例，当然你也可以对实例进行一些操作，例如停止，重跑等
- 补数据实例： 展示补数据列表，可以通过补数据列表查看补数据实例

## 基本使用介绍

- 任务： 这里是指调度任务（已经提交置调度的任务）。
- 实例： 实例表示任务执行一次的记录，对实例进行重跑的，相关日志等信息会被覆盖。
- 补数据： 生成局部的DAG图的方式，周期实例是完成的DAG图，在前一天的10点生成（配置文件可改），属于系统自动生成。补数据生成的局部DAG图，是使用者手动触发生成
- 补数据实例：手动生成局部的DAG图中的最新单位，当然这个实例和周期实例一样，可以进行停止，重跑等一些操作