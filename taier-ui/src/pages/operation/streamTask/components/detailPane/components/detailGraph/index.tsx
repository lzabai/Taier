/* eslint-disable */
import moment from 'moment';
import * as React from 'react';
import HelpDoc from '@/components/helpDoc';
import {
    COLLECTION_BPS_UNIT_TYPE,
    SOURCE_INPUT_BPS_UNIT_TYPE,
    UNIT_TYPE,
    METRIC_STATUS_TYPE,
    DATA_SOURCE_TEXT,
    CHARTS_COLOR,
    TASK_TYPE_ENUM,
    DATA_SOURCE_ENUM,
} from '@/constant';
import stream from '@/api';
import { Utils } from '@dtinsight/dt-utils/lib';
import { Alert, Radio, Tooltip, Row, Col } from 'antd';
import { ReloadOutlined } from '@ant-design/icons';
import { compact, cloneDeep, chunk } from 'lodash';
import GraphTimeRange from '@/components/graphTime/graphTimeRange';
import GraphTimePicker from '@/components/graphTime/graphTimePicker';
import AlarmBaseGraph from './baseGraph';
import DataDelay from './dataDelay';
import MetricSelect from './metricSelect';
import './index.scss';

const Api = {
    checkSourceStatus: (params: any) => Promise.resolve({ code: 1, data: null }),
    getMetricStatus: (params: any) =>
        Promise.resolve({
            code: 1,
            message: null,
            data: { status: 1, msg: null },
            space: 0,
            version: null,
            success: true,
        }),
};

const defaultTimeValue = '10m';
export const metricsType = {
    FAILOVER_RATE: 'fail_over_rate',
    FAILOVER_HISTORY: 'fail_over_history',
    DELAY: 'data_delay',
    SOURCE_TPS: 'source_input_tps',
    SINK_OUTPUT_RPS: 'sink_output_rps',
    SOURCE_RPS: 'source_input_rps',
    SOURCE_INPUT_BPS: 'source_input_bps',
    SOURCE_DIRTY: 'source_dirty_data',
    SOURCE_DIRTY_OUT: 'source_dirty_out',
    DATA_COLLECTION_RPS: 'data_acquisition_rps',
    DATA_COLLECTION_BPS: 'data_acquisition_bps',
    DATA_DISABLE_TPS: 'data_discard_tps',
    DATA_DISABLE_COUNT: 'data_discard_count',
    DATA_COLLECTION_TOTAL_RPS: 'data_acquisition_record_sum',
    DATA_COLLECTION_TOTAL_BPS: 'data_acquisition_byte_sum',
};
const defaultLineData: any = {
    x: [],
    y: [[]],
    loading: true,
};
const defaultData: any = {
    [metricsType.FAILOVER_HISTORY]: defaultLineData,
    [metricsType.DELAY]: defaultLineData,
    [metricsType.SOURCE_TPS]: defaultLineData,
    [metricsType.SINK_OUTPUT_RPS]: defaultLineData,
    [metricsType.SOURCE_RPS]: defaultLineData,
    [metricsType.SOURCE_INPUT_BPS]: defaultLineData,
    [metricsType.SOURCE_DIRTY]: defaultLineData,
    [metricsType.SOURCE_DIRTY_OUT]: defaultLineData,
    [metricsType.DATA_COLLECTION_RPS]: defaultLineData,
    [metricsType.DATA_COLLECTION_BPS]: defaultLineData,
    [metricsType.DATA_DISABLE_TPS]: defaultLineData,
    [metricsType.DATA_DISABLE_COUNT]: defaultLineData,
    [metricsType.DATA_COLLECTION_TOTAL_RPS]: defaultLineData,
    [metricsType.DATA_COLLECTION_TOTAL_BPS]: defaultLineData,
};

function matchSourceInputUnit(metricsData: any = {}, type: string) {
    function matchType(type: string, key: UNIT_TYPE) {
        switch (type) {
            case metricsType.DATA_COLLECTION_TOTAL_BPS: {
                unit = COLLECTION_BPS_UNIT_TYPE[key];
                break;
            }
            case metricsType.SOURCE_INPUT_BPS:
            case metricsType.DATA_COLLECTION_BPS: {
                unit = SOURCE_INPUT_BPS_UNIT_TYPE[key];
                break;
            }
        }
    }

    const { y = [[]] } = metricsData;
    let unit: string | undefined = '';
    const depth = type == metricsType.SOURCE_INPUT_BPS ? 2 : 1;
    const dataFlat = y.flat(depth) || [];
    const maxVal = Math.max.apply(null, dataFlat);
    const isBps = maxVal < 1024;
    const isKbps = dataFlat.some((item: any) => item >= 1024 && item < Math.pow(1024, 2));
    const isMbps = dataFlat.some((item: any) => item >= Math.pow(1024, 2) && item < Math.pow(1024, 3));
    const isGbps = dataFlat.some((item: any) => item >= Math.pow(1024, 3) && item < Math.pow(1024, 4));
    const isTbps = dataFlat.some((item: any) => item >= Math.pow(1024, 4));

    if (isBps) {
        matchType(type, UNIT_TYPE.B);
    } else if (isKbps) {
        matchType(type, UNIT_TYPE.KB);
    } else if (isMbps) {
        matchType(type, UNIT_TYPE.MB);
    } else if (isGbps) {
        matchType(type, UNIT_TYPE.GB);
    } else if (isTbps) {
        matchType(type, UNIT_TYPE.TB);
    } else {
        matchType(type, UNIT_TYPE.B);
    }
    return unit;
}

interface IProps {
    data: any;
    graph: { taskMetrics: any };
}

const initState = {
    lineDatas: defaultData,
    sourceStatusList: [] as any,
    time: defaultTimeValue,
    endTime: moment(),
    metricValue: undefined as undefined | string,
    metricLists: [],
    metricDatas: {} as any,
    metricStatus: {
        status: METRIC_STATUS_TYPE.NORMAL, // ?????? 1, ?????? 2
        msg: '',
    },
    tabKey: 'OverView',
};

type IState = typeof initState;

export default class StreamDetailGraph extends React.Component<IProps & any, IState> {
    constructor(props: any) {
        super(props);
        this.state = {
            lineDatas: defaultData,
            sourceStatusList: [],
            time: defaultTimeValue,
            endTime: moment(),
            metricValue: undefined,
            metricLists: [],
            metricDatas: {},
            metricStatus: {
                status: METRIC_STATUS_TYPE.NORMAL, // ?????? 1, ?????? 2
                msg: '',
            },
            tabKey: 'OverView',
        };
    }
    componentDidMount() {
        this.getMetricValues();
        this.initGraph();
        this.checkSourceStatus();
        this.checkMetricStatus();
    }

    UNSAFE_componentWillReceiveProps(nextProps: any) {
        const data = nextProps.data;
        const oldData = this.props.data;
        if (oldData && data && oldData.id !== data.id) {
            this.clear(() => {
                this.initGraph(data);
                this.checkSourceStatus(data);
                this.getMetricValues(data);
                this.checkMetricStatus(data);
            });
        }
    }

    clear(callback?: () => void) {
        this.setState(
            {
                lineDatas: defaultData,
                sourceStatusList: [],
                time: defaultTimeValue,
                endTime: moment(),
                metricValue: undefined,
                metricLists: [],
                metricDatas: {},
                tabKey: 'OverView',
            },
            callback
        );
    }

    // ?????? metric ??????
    checkMetricStatus = (data?: any) => {
        data = data || this.props.data;
        if (!data?.id) {
            return;
        }
        Api.getMetricStatus({
            taskId: data?.id,
        }).then((res: any) => {
            const { code, data } = res;
            if (code === 1) {
                this.setState({ metricStatus: data });
            }
        });
    };

    // ??????????????????
    getMetricValues = (data?: any) => {
        data = data || this.props.data;
        if (!data.id) {
            return;
        }
        stream
            .getMetricValues({
                taskId: data?.id,
            })
            .then((res: any) => {
                const { code, data } = res;
                if (code === 1) {
                    const metricLists = (data || []).map((item: string) => ({
                        text: item,
                        value: item,
                    }));
                    this.setState({ metricLists });
                }
            });
    };

    // ?????????????????????????????????metrics
    initCustomMetrics = (data?: any) => {
        data = data || this.props.data;
        if (!data.id) {
            return;
        }
        const metrics = this.props.graph?.taskMetrics?.[data.id];
        Array.isArray(metrics) &&
            metrics.forEach((chartName: string) => {
                this.queryTaskMetrics(chartName, data.id);
            });
    };

    // ??????????????????
    queryTaskMetrics = (chartName: string, id: number) => {
        const { time, endTime } = this.state;
        stream
            .queryTaskMetrics({
                taskId: id,
                chartName,
                timespan: time,
                end: endTime.valueOf(),
            })
            .then((res: any) => {
                const { code, data } = res;
                if (code === 1) {
                    this.setMetricData(chartName, data || []);
                }
            });
    };

    // ???????????????
    setMetricData = (chartName: string, data: any[]) => {
        const { metricDatas } = this.state;
        let xAxis: Array<any> = [];
        const yAxis: Array<any> = [];
        const legend: string[] = [];
        data.forEach((item: any) => {
            const { metric, values } = item;
            const { x, y } = this.setChartValue(values);
            const key = this.setMetricKey(metric);
            if (xAxis.length === 0) {
                xAxis = x;
            }
            yAxis.push(y);
            legend.push(key);
        });
        const options = this.setCustomMetricOptions();
        this.setState({
            metricDatas: {
                ...metricDatas,
                [chartName]: {
                    loading: false,
                    legend,
                    x: xAxis,
                    y: yAxis,
                    ...options,
                },
            },
        });
    };

    // ??????????????????
    setMetricKey = (metric: any): string => {
        if (metric === undefined) {
            return '';
        }
        const NAME_KEY = '__name__';
        const SHOW_KEYS = ['job_id', 'job_name', 'exported_job', 'operator_name'];
        const key = Object.entries(metric)
            .filter((item: any[]) => SHOW_KEYS.includes(item[0]))
            .map((item: any) => `${item[0]}="${item[1]}"`)
            .join(', ');
        return metric[NAME_KEY] + '{' + key + '}';
    };

    // ????????????????????????
    setChartValue = (values: any[]) => {
        const x: Array<string | number> = [];
        const y: Array<string | number> = [];
        Array.isArray(values) &&
            values.forEach((value: any) => {
                x.push(value.time);
                y.push(value.value);
            });
        return { x, y };
    };

    // ???????????????metric???Option
    setCustomMetricOptions = () => {
        const legendOption = {
            left: '3%',
            right: '4%',
            top: '75%',
            orient: 'vertical',
            textStyle: {
                width: 200,
                overflow: 'truncate',
                ellipsis: '...',
            },
            tooltip: {
                show: true,
                formatter: function (params: any) {
                    const { __name__, content } = breakUpParams(params.name);
                    return `<div><span>${__name__}</span><br/>${content}</div>`;
                },
            },
        };
        const gridOption = {
            bottom: '30%',
        };
        const tooltipOption = {
            trigger: 'item',
            axisPointer: {
                type: 'cross',
                span: true,
            },
            formatter: function (params: any) {
                const { seriesName, marker, name, value } = params;
                const { __name__, content } = breakUpParams(seriesName);
                return `<div><span>${moment(Number(name)).format(
                    'YYYY-MM-DD HH:mm:ss'
                )}</span><br/><span>${marker}${__name__}: <span style="font-weight: 'bold'">${value}</span></span><br/>${content}</div>`;
            },
        };
        return { legendOption, gridOption, tooltipOption };

        // ????????????
        function breakUpParams(seriesName: string) {
            const [__name__, param] = seriesName.split('{');
            const keys = param
                .slice(0, -1)
                .split(', ')
                .map((item) => item.split('='));
            let content = '';
            keys.forEach(([key, value]) => {
                content += `<span style="font-weight: bold">${key}</span>: <span>${value}</span><br/>`;
            });
            return { __name__, content };
        }
    };

    checkSourceStatus(data?: any) {
        data = data || this.props.data;
        if (!data.id) {
            return;
        }
        Api.checkSourceStatus({
            taskId: data.id,
        }).then((res: any) => {
            if (res.code == 1) {
                const data = res.data || {};
                this.setState({
                    sourceStatusList: Object.entries(data),
                });
            }
        });
    }

    setLineData(data = []) {
        const { lineDatas } = this.state;
        const stateLineData: any = { ...lineDatas };
        for (let i = 0; i < data.length; i++) {
            const item: any = data[i];
            const lineData = item.data;
            const type = item.chartName;
            let x = [];
            const y = [];
            const ext: any = {};
            x = lineData.map((data: any) => {
                return data.time;
            });
            switch (type) {
                case metricsType.SOURCE_INPUT_BPS:
                case metricsType.SINK_OUTPUT_RPS:
                case metricsType.SOURCE_TPS:
                case metricsType.SOURCE_RPS:
                case metricsType.SOURCE_DIRTY:
                case metricsType.SOURCE_DIRTY_OUT:
                case metricsType.DELAY: {
                    const tmpMap: any = {};
                    const legend = [];
                    for (let i = 0; i < lineData.length; i++) {
                        const chartData = lineData[i];
                        for (const key in chartData) {
                            if (key == 'time') {
                                continue;
                            }
                            if (tmpMap[key]) {
                                tmpMap[key].push([i, chartData[key]]);
                            } else {
                                tmpMap[key] = [[i, chartData[key]]];
                            }
                        }
                    }
                    for (const key in tmpMap) {
                        const datas = tmpMap[key];
                        y.push(datas);
                        legend.push(key);
                    }
                    ext.legend = legend;
                    break;
                }
                case metricsType.FAILOVER_HISTORY: {
                    y[0] = lineData.map((data: any) => {
                        return data.fail_over_history;
                    });
                    break;
                }
                case metricsType.DATA_COLLECTION_BPS: {
                    y[0] = lineData.map((data: any) => {
                        return data.data_acquisition_input_bps;
                    });
                    y[1] = lineData.map((data: any) => {
                        return data.data_acquisition_output_bps;
                    });
                    break;
                }
                case metricsType.DATA_COLLECTION_RPS: {
                    y[0] = lineData.map((data: any) => {
                        return data.data_acquisition_input_rps;
                    });
                    y[1] = lineData.map((data: any) => {
                        return data.data_acquisition_output_rps;
                    });
                    break;
                }
                case metricsType.DATA_DISABLE_TPS: {
                    y[0] = lineData.map((data: any) => {
                        return data.data_discard_tps;
                    });
                    break;
                }
                case metricsType.DATA_DISABLE_COUNT: {
                    y[0] = lineData.map((data: any) => {
                        return data.data_discard_count;
                    });
                    break;
                }
                case metricsType.DATA_COLLECTION_TOTAL_BPS: {
                    y[0] = lineData.map((data: any) => {
                        return data.data_acquisition_input_byte_sum;
                    });
                    y[1] = lineData.map((data: any) => {
                        return data.data_acquisition_output_byte_sum;
                    });
                    break;
                }
                case metricsType.DATA_COLLECTION_TOTAL_RPS: {
                    y[0] = lineData.map((data: any) => {
                        return data.data_acquisition_input_record_sum;
                    });
                    y[1] = lineData.map((data: any) => {
                        return data.data_acquisition_output_record_sum;
                    });
                    break;
                }
                default:
                    break;
            }
            stateLineData[type] = {
                x,
                y,
                loading: false,
                ...ext,
            };
        }
        this.setState({
            lineDatas: stateLineData,
        });
    }

    // ???????????????
    initGraph = (data?: any) => {
        this.initData(data);
        this.initCustomMetrics(data);
    };

    initData(data?: any) {
        data = data || this.props.data;
        if (!data.id) {
            return;
        }
        const { taskType } = data;
        const isDataCollection = taskType == TASK_TYPE_ENUM.DATA_ACQUISITION;
        const { time, endTime } = this.state;
        const metricsList = [];

        if (isDataCollection) {
            metricsList.push(metricsType.DATA_COLLECTION_BPS);
            metricsList.push(metricsType.DATA_COLLECTION_RPS);
            metricsList.push(metricsType.DATA_COLLECTION_TOTAL_BPS);
            metricsList.push(metricsType.DATA_COLLECTION_TOTAL_RPS);
        } else {
            // ??????????????????
            metricsList.push(metricsType.FAILOVER_HISTORY);
            metricsList.push(metricsType.DELAY);
            metricsList.push(metricsType.SOURCE_TPS);
            metricsList.push(metricsType.SINK_OUTPUT_RPS);
            metricsList.push(metricsType.SOURCE_RPS);
            metricsList.push(metricsType.SOURCE_INPUT_BPS);
            metricsList.push(metricsType.SOURCE_DIRTY);
            metricsList.push(metricsType.SOURCE_DIRTY_OUT);
            metricsList.push(metricsType.DATA_DISABLE_COUNT);
            metricsList.push(metricsType.DATA_DISABLE_TPS);
        }

        const successFunc = (res: any) => {
            if (res.code == 1) {
                this.setLineData(res.data);
            }
        };

        for (let i = 0; i < metricsList.length; i++) {
            const serverChart = metricsList[i];
            // ???????????????????????????
            setTimeout(() => {
                stream
                    .getTaskMetrics({
                        taskId: data.id,
                        timespan: time,
                        end: endTime.valueOf(),
                        chartNames: [serverChart],
                    })
                    .then(successFunc);
            }, 100 + 25 * i);
        }
    }

    renderAlertMsg() {
        const { sourceStatusList = [], metricStatus } = this.state;
        const { status, msg } = metricStatus;

        const sourceMsg = Utils.textOverflowExchange(
            sourceStatusList
                .map(([sourceName, type]: any[]) => {
                    return `${sourceName}(${DATA_SOURCE_TEXT[type as DATA_SOURCE_ENUM]})`;
                })
                .join('???'),
            60
        );

        const msgs = [status === METRIC_STATUS_TYPE.ABNORMAL ? msg : '', sourceMsg ? `?????????${sourceMsg}????????????` : ''];
        const errorMsg = compact(msgs).join(', ');

        return errorMsg && <Alert style={{ marginBottom: 8 }} message={errorMsg} type="warning" showIcon />;
    }

    // ??????????????????
    graphTimeRangeChange = (time: string) => {
        this.setState({ time }, this.initGraph);
    };

    // ?????????????????????
    graphTimeRangeInput = (value: string) => {
        this.setState({ time: value }, this.initGraph);
    };

    // ??????????????????
    endTimeChange = (endTime: moment.Moment) => {
        this.setState({ endTime }, this.initGraph);
    };

    // ??????metric
    handleMetricSelect = (value: string) => {
        if (value) {
            const { data } = this.props;
            // dispatch(GraphAction.saveTaskMetrics(data.id, value));
            this.queryTaskMetrics(value, data.id);
            this.setState({
                metricValue: undefined,
            });
        }
    };

    // ??????metric
    handleMetricDelete = (name: string) => {
        // const { dispatch, data } = this.props;
        const metricDatas: any = cloneDeep(this.state.metricDatas);
        delete metricDatas[name];
        this.setState({
            metricDatas,
        });
        // dispatch(GraphAction.deleteTaskMetric(data.id, name));
    };

    // ??????
    refreshGraph = () => {
        const initTime = {
            time: defaultTimeValue,
            endTime: moment(),
        };
        this.setState({ ...initTime }, this.initGraph);
    };

    render() {
        const { lineDatas, time, metricValue, metricLists, metricDatas = {}, tabKey, endTime } = this.state;
        const { data = {} } = this.props;
        const { taskType } = data;
        const isDataCollection = taskType == TASK_TYPE_ENUM.DATA_ACQUISITION;
        const sourceIptUnit = matchSourceInputUnit(
            { ...lineDatas[metricsType.SOURCE_INPUT_BPS] },
            metricsType.SOURCE_INPUT_BPS
        );
        const colBpsUnit = matchSourceInputUnit(
            { ...lineDatas[metricsType.DATA_COLLECTION_BPS] },
            metricsType.DATA_COLLECTION_BPS
        );
        const colTotalBpsUnit = matchSourceInputUnit(
            { ...lineDatas[metricsType.DATA_COLLECTION_TOTAL_BPS] },
            metricsType.DATA_COLLECTION_TOTAL_BPS
        );

        return (
            <div className="c-graph__container">
                <header className="c-graph__header">
                    <div>{this.renderAlertMsg()}</div>
                    <div className="c-graph__time-picker">
                        <Radio.Group
                            style={{ marginRight: 'auto' }}
                            value={tabKey}
                            onChange={(e) => {
                                this.setState({ tabKey: e.target.value });
                            }}
                        >
                            <Radio.Button value="OverView">OverView</Radio.Button>
                            <Radio.Button value="WaterMark">WaterMark</Radio.Button>
                            {data.taskType === TASK_TYPE_ENUM.SQL && (
                                <Radio.Button value="dataDelay">
                                    ????????????
                                    <HelpDoc
                                        style={{
                                            position: 'relative',
                                            marginLeft: '5px',
                                            right: 'initial',
                                            top: 'initial',
                                            marginRight: '0px',
                                        }}
                                        doc="delayTabWarning"
                                    />
                                </Radio.Button>
                            )}
                            <Radio.Button value="Metric">?????????Metric</Radio.Button>
                        </Radio.Group>
                        {['OverView', 'WaterMark', 'Metric'].includes(tabKey) && (
                            <>
                                <GraphTimeRange
                                    value={time}
                                    onRangeChange={this.graphTimeRangeChange}
                                    onInputChange={this.graphTimeRangeInput}
                                />
                                <GraphTimePicker
                                    style={{ marginLeft: 20 }}
                                    value={endTime}
                                    timeRange={time}
                                    onChange={this.endTimeChange}
                                />
                                <Tooltip title="??????">
                                    <ReloadOutlined
                                        onClick={this.refreshGraph.bind(this, null)}
                                        style={{ color: '#666', marginLeft: 20, cursor: 'pointer' }}
                                    />
                                </Tooltip>
                            </>
                        )}
                    </div>
                </header>
                <div className="c-graph__content">
                    {tabKey === 'OverView' && (
                        <>
                            {isDataCollection ? (
                                <>
                                    <div className="alarm-graph-row">
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.DATA_COLLECTION_RPS],
                                                    color: CHARTS_COLOR,
                                                    unit: 'rps',
                                                    legend: ['??????RPS', '??????RPS'],
                                                }}
                                                desc="??????/???????????????????????????RecordPerSecond???"
                                                title="??????/??????RPS"
                                            />
                                        </section>
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.DATA_COLLECTION_BPS],
                                                    color: CHARTS_COLOR,
                                                    unit: colBpsUnit,
                                                    legend: [
                                                        `??????${colBpsUnit.toLocaleUpperCase()}`,
                                                        `??????${colBpsUnit.toLocaleUpperCase()}`,
                                                    ],
                                                    metricsType: metricsType.DATA_COLLECTION_BPS,
                                                }}
                                                desc="??????/???????????????????????????BytePerSecond???"
                                                title="??????/??????BPS"
                                            />
                                        </section>
                                    </div>
                                    <div className="alarm-graph-row">
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.DATA_COLLECTION_TOTAL_RPS],
                                                    color: CHARTS_COLOR,
                                                    unit: '???',
                                                    legend: ['?????????????????????', '?????????????????????'],
                                                }}
                                                desc="????????????/??????????????????????????????"
                                                title="????????????/???????????????"
                                            />
                                        </section>
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.DATA_COLLECTION_TOTAL_BPS],
                                                    color: CHARTS_COLOR,
                                                    unit: colTotalBpsUnit,
                                                    legend: ['?????????????????????', '?????????????????????'],
                                                    metricsType: metricsType.DATA_COLLECTION_TOTAL_BPS,
                                                }}
                                                desc="????????????/???????????????????????????Bytes?????????????????????"
                                                title="????????????/???????????????"
                                            />
                                        </section>
                                    </div>
                                </>
                            ) : (
                                <>
                                    <div className="alarm-graph-row">
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.FAILOVER_HISTORY],
                                                    color: CHARTS_COLOR,
                                                    legend: ['History'],
                                                }}
                                                desc="?????????????????? Failover???????????????????????????????????????"
                                                title="FailOver History"
                                            />
                                        </section>
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.DELAY],
                                                    color: CHARTS_COLOR,
                                                    unit: 's',
                                                }}
                                                desc="???????????? = ?????????????????? ??? ?????????????????????????????????????????????????????????Event time???"
                                                title="????????????"
                                            />
                                        </section>
                                    </div>
                                    <div className="alarm-graph-row">
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.SOURCE_RPS],
                                                    color: CHARTS_COLOR,
                                                    unit: 'rps',
                                                }}
                                                desc="????????????????????????Kafka???????????????????????????RPS(Record Per Second)???"
                                                title="???Source???RPS????????????"
                                            />
                                        </section>
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.SOURCE_DIRTY],
                                                    color: CHARTS_COLOR,
                                                }}
                                                desc="???Source????????????????????????????????? Flink???Source?????????????????????????????????"
                                                title="???Source????????????"
                                            />
                                        </section>
                                    </div>
                                    <div className="alarm-graph-row">
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.SINK_OUTPUT_RPS],
                                                    color: CHARTS_COLOR,
                                                    unit: 'rps',
                                                }}
                                                desc="????????????????????????MySQL???HBase???ElasticSearch??????????????????????????????????????????????????????RPS???Record Per Second??????"
                                                title="???Sink???RPS????????????"
                                            />
                                        </section>
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.SOURCE_DIRTY_OUT],
                                                    color: CHARTS_COLOR,
                                                }}
                                                desc="???Sink????????????????????????????????? Flink???Sink????????????????????????"
                                                title="???Sink??????????????????"
                                            />
                                        </section>
                                    </div>
                                    <div className="alarm-graph-row">
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    color: CHARTS_COLOR,
                                                    ...lineDatas[metricsType.SOURCE_TPS],
                                                    unit: 'tps',
                                                }}
                                                desc="????????????????????????Kafka???????????????????????????TPS(Transaction Per Second)???"
                                                title="???Source???TPS????????????"
                                            />
                                        </section>
                                        <section>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...lineDatas[metricsType.SOURCE_INPUT_BPS],
                                                    color: CHARTS_COLOR,
                                                    unit: sourceIptUnit,
                                                    metricsType: metricsType.SOURCE_INPUT_BPS,
                                                }}
                                                desc="????????????????????????Kafka???????????????????????????BPS(Byte Per Second)?????????????????????????????????????????????????????????Mbps???Gbps???"
                                                title="???Source???BPS????????????"
                                            />
                                        </section>
                                    </div>
                                </>
                            )}
                        </>
                    )}
                    {tabKey === 'WaterMark' && (
                        <div className="alarm-graph-row">
                            <section>
                                <AlarmBaseGraph
                                    time={time}
                                    lineData={{
                                        ...lineDatas[metricsType.DATA_DISABLE_TPS],
                                        color: CHARTS_COLOR,
                                        legend: ['??????????????????TPS'],
                                    }}
                                    desc="?????????????????????EventTime???????????????????????????element????????????????????????????????????????????????????????????????????????????????????element??????????????????"
                                    title="??????????????????TPS"
                                />
                            </section>
                            <section>
                                <AlarmBaseGraph
                                    time={time}
                                    lineData={{
                                        ...lineDatas[metricsType.DATA_DISABLE_COUNT],
                                        color: CHARTS_COLOR,
                                        legend: ['???????????????????????????'],
                                    }}
                                    desc="??????????????????????????????????????????"
                                    title="???????????????????????????"
                                />
                            </section>
                        </div>
                    )}
                    {tabKey === 'dataDelay' && <DataDelay data={data} tabKey={tabKey} />}
                    {tabKey === 'Metric' && (
                        <>
                            <MetricSelect
                                style={{ padding: '0 0 2px 2px' }}
                                placeholder="?????????Metric"
                                enterButton="Add Metric"
                                value={metricValue}
                                options={metricLists}
                                onChange={(value: string) => this.setState({ metricValue: value })}
                                onOk={this.handleMetricSelect}
                            />
                            {chunk(Object.keys(metricDatas), 2).map((row: string[], index: number) => (
                                <Row
                                    key={index}
                                    gutter={10}
                                    style={{ marginTop: 10, paddingLeft: 2 }}
                                    className="alarm-graph-row"
                                >
                                    {row.map((name: string) => (
                                        <Col key={name} span={12}>
                                            <AlarmBaseGraph
                                                time={time}
                                                lineData={{
                                                    ...metricDatas[name],
                                                    color: CHARTS_COLOR,
                                                }}
                                                title={name}
                                                allowDelete
                                                onDelete={() => this.handleMetricDelete(name)}
                                            />
                                        </Col>
                                    ))}
                                </Row>
                            ))}
                        </>
                    )}
                </div>
            </div>
        );
    }
}
