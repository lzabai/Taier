// @ts-nocheck
/* eslint-disable */
import * as React from 'react';
import { cloneDeep } from 'lodash';
import { DateTime } from '@dtinsight/dt-utils';

// import Api from '@/api'
import { lineAreaChartOptions } from '../help';
import Resize from '@/components/resize';

const echarts = require('echarts/lib/echarts');
require('echarts/lib/chart/line');
require('echarts/lib/component/legend');
require('echarts/lib/component/legendScroll');
require('echarts/lib/component/tooltip');

interface Props {
    taskId: number;
    partitionId: string;
    topicName: string;
    timespan: string;
    end: number;
}
class TopicDetailTable extends React.Component<Props, any> {
    state = {
        data: [],
        lineChart: null,
    };

    componentDidMount() {
        this.getDetail();
    }

    UNSAFE_componentWillReceiveProps(nextProps: any) {
        const { taskId, partitionId, topicName, timespan, end } = this.props;
        const {
            taskId: nextTaskId,
            partitionId: nextPartitionId,
            topicName: nextTopicName,
            timespan: nextTimespan,
            end: nextEnd,
        } = nextProps;
        if (
            taskId != nextTaskId ||
            partitionId != nextPartitionId ||
            topicName != nextTopicName ||
            timespan !== nextTimespan ||
            end !== nextEnd
        ) {
            this.getDetail(nextTaskId, nextPartitionId, nextTopicName, nextTimespan, nextEnd);
        }
    }

    getDetail(taskId?: any, partitionId?: any, topicName?: any, timespan?: string, end?: number) {
        taskId = typeof taskId == 'undefined' ? this.props.taskId : taskId;
        partitionId = typeof partitionId == 'undefined' ? this.props.partitionId : partitionId;
        topicName = typeof topicName == 'undefined' ? this.props.topicName : topicName;
        topicName = typeof topicName == 'undefined' ? this.props.topicName : topicName;
        timespan = timespan || this.props.timespan;
        end = end || this.props.end;
        if (!taskId || !partitionId || !topicName || !timespan || !end) {
            return;
        }
        // ????????????????????????
        this.setState({ data: [] });
        Api.getDelayDetail({
            taskId,
            partitionId,
            topicName,
            timespan,
            end,
        }).then((res: any) => {
            if (res.code == 1) {
                this.setState(
                    {
                        data: res.data,
                    },
                    this.initGraph.bind(this)
                );
            }
        });
    }

    initGraph(lineData?: any) {
        const { partitionId } = this.props;
        lineData = lineData || this.state.data;
        if (!lineData) {
            return;
        }
        const myChart = echarts.init(document.getElementById(`delayDetail-${partitionId}`));
        const options = cloneDeep(lineAreaChartOptions);

        options.title = {
            text: '????????????????????????',
            top: '12px',
            left: '20px',
            textStyle: { fontSize: 12 },
        };
        options.legend = {
            top: '12px',
            right: '20px',
            data: ['????????????'],
            itemHeight: 8,
            itemWidth: 8,
            icon: 'circle',
        };
        /**
         * ?????????????????????
         */
        options.xAxis[0].data = lineData.map((item: any) => {
            return item.time;
        });
        options.xAxis[0].axisLabel = {
            ...options.xAxis[0].axisLabel,
            formatter: (value: any) => {
                return DateTime.formatHours(parseInt(value));
            },
        };
        options.xAxis[0].axisPointer = {
            label: {
                formatter: (params: any) => {
                    return DateTime.formatDateTime(parseInt(params.value));
                },
            },
        };
        options.yAxis[0].name = '';
        options.grid = {
            left: '20px',
            right: '20px',
            top: '60px',
            bottom: '8px',
            containLabel: true,
        };
        /**
         * ?????????????????????
         */
        options.series = {
            name: '????????????',
            data: lineData.map((item) => item.data),
            type: 'line',
            smooth: true,
            areaStyle: {},
        };
        options.backgroundColor = '#ffffff';
        /**
         * ????????????
         */
        myChart.setOption(options);
        this.setState({ lineChart: myChart });
    }

    resize = () => {
        if (this.state.lineChart) this.state.lineChart.resize();
    };

    render() {
        const { partitionId } = this.props;
        return (
            <Resize onResize={this.resize.bind(this)}>
                {/* ?????? Table ??????????????????????????????????????????????????????????????????????????? margin ???????????? */}
                <article
                    id={`delayDetail-${partitionId}`}
                    style={{ width: 'calc(100% + 40px)', marginLeft: '-40px', height: '236px', background: '#ffffff' }}
                />
            </Resize>
        );
    }
}

export default TopicDetailTable;
