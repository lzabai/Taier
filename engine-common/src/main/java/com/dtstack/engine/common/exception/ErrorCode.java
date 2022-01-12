package com.dtstack.engine.common.exception;

import org.springframework.context.i18n.LocaleContextHolder;

import java.io.Serializable;
import java.util.Locale;

/**
 * @author yuebai
 * @date 2021-09-07
 */
public enum ErrorCode implements ExceptionEnums, Serializable {


    /**
     * 0 ~ 100 常用错误code
     * 100 ~ 200 运维中心错误code
     * 200 ~ 300 控制台配置错误code
     * 300 ~ 400 任务开发错误code
     * 400 ~ 500 数据源错误code
     */
    NOT_LOGIN(0, "not login", "未登录"),
    SUCCESS(1, "success", ""),
    //权限不足 前端页面会进入404
    PERMISSION_LIMIT(3, "permission limit", "权限不足"),
    TOKEN_IS_NULL(4, "dt_token is null", "token信息为空"),
    USER_IS_NULL(5, "user is null", "用户不存在"),
    TOKEN_IS_INVALID(6, "dt_token is invalid", "无效token"),
    TENANT_IS_NULL(7, "tenant is null", "租户为空"),

    UNKNOWN_ERROR(10, "unknown error", "未知错误"),
    SERVER_EXCEPTION(11, "server exception", "服务异常"),



    INVALID_PARAMETERS(13, "invalid parameters", "非法参数"),
    NAME_ALREADY_EXIST(14, "name already exist","名称已存在"),
    NAME_FORMAT_ERROR(15, "","名称格式错误"),
    DATA_NOT_FIND(17, "data not exist","数据不存在"),
    INVALID_TASK_STATUS(20, "invalid task status","无效的task"),
    INVALID_TASK_RUN_MODE(21, "invalid task run mod","无效的运行模式"),
    JOB_CACHE_NOT_EXIST(22, "job cache not exist this job","任务不存在cache"),
    JOB_STATUS_IS_SAME(23, "job status is same as cluster","任务状态与集群一致"),
    FUNCTION_CAN_NOT_FIND(28, "function can not found","方法不存在"),

    UPDATE_EXCEPTION(30, "update exception", "更新异常"),
    CONFIG_ERROR(51, "config error","配置错误"),

    HTTP_CALL_ERROR(64, "http call error", "远程调用失败"),

    INVALID_PAGE_PARAM(102, "page params invalid","无效的分页数据"),
    TENANT_ID_NOT_NULL(103, "dtuicTenantId cat not be null","租户id不能为空"),

    SYSTEM_FUNCTION_CAN_NOT_MODIFY(29, "","系统方法不能修改"),
    CATALOGUE_NO_EMPTY(130, "","目录非空"),
    CAN_NOT_FIND_CATALOGUE(131,"", "该目录不存在"),
    CAN_NOT_MOVE_CATALOGUE(132, "","该目录不允许移动至当前目录和子目录"),
    CAN_NOT_DELETE_RESOURCE(133, "","该资源被引用,不能被删除"),
    CAN_NOT_FIND_RESOURCE(134, "","资源不存在"),
    FILE_NOT_EXISTS(135, "","文件不存在"),
    FILE_MUST_NOT_DIR(136, "","不能选择文件夹"),
    FILE_TYPE_NOT_SUPPORTED(137, "","不支持该文件格式"),
    RESOURCE_TYPE_NOT_MATCH(138, "","资源类型不匹配"),
    PARENT_NODE_NOT_EXISTS(139, "","父节点不存在"),
    SUBDIRECTORY_OR_FILE_AMOUNT_RESTRICTIONS(140,"", "当前目录下直接一层的子目录或者文件的个数总数不可超过2000"),
    CREATE_TENANT_CATALOGUE_LEVE(141, "","创建目录层级不能大于3"),
    FILE_NAME_REPETITION(142, "","同一路径下不能存在同名文件夹"),

    CAN_NOT_FIND_DATA_SOURCE(150, "","数据源不存在"),
    CAN_NOT_FITABLE_SOURCE_TYPE(151, "not found table source table ","找不到对应source Type"),
    CAN_NOT_MODIFY_ACTIVE_SOURCE(152, "","不能修改使用中的数据源."),
    TEST_CONN_FAIL(153, "","测试连接失败"),
    DATA_SOURCE_NAME_ALREADY_EXISTS(154,"", "数据源名称已存在"),
    DATA_SOURCE_NOT_SET(155, "","未配置数据源"),
    CAN_NOT_MODIFY_DEFAULT_DATA_SOURCE(156, "","默认数据源不允许修改"),
    ERROR_DEFAULT_FS_FORMAT(157, "error default fs format","defaultFS格式不正确"),
    DATASOURCE_CONF_ERROR(159, "source conf is error","数据源信息配置错误"),
    DATASOURCE_DUP_NAME(160, "has same name source","数据源有重名!"),
    CAN_NOT_DEL_AUTH_DS(161, "","数据源已授权给产品，不可删除"),
    CAN_NOT_DEL_META_DS(162, "","不可删除默认数据源"),
    SHIFT_DATASOURCE_ERROR(163, "","迁移数据源发生错误"),
    IMPORT_DATA_SOURCE_DUP_FAIL(164, "","存在数据源重复引入, 引入失败"),
    NOT_FIND_EDIT_CONSOLE_DS(165, "","控制台修改的数据源不存在, 修改失败"),
    IMPORT_DS_NOT_MATCH_APP(166, "","该数据源类型不属于该产品，无法授权"),
    CONSOLE_EDIT_JDBC_FORMAT_ERROR(167, "","控制台修改jdbcUrl格式不正确!"),
    CONSOLE_EDIT_CAN_NOT_CONNECT(168, "","控制台修改信息连接失败, 无法保存!"),
    API_CANT_DEL_NOT_META_DS(169, "","API服务调用无法删除非默认数据源!"),
    API_CANT_DEL_NOT_TENANT(170, "","该数据源非该租户创建，无法删除!"),
    IMPORT_DATA_SOURCE_AUTH_FAIL(171, "","存在数据源未授权, 引入失败"),
    CANCEL_AUTH_DATA_SOURCE_FAIL(172, "","取消授权的产品已引入该数据源，授权失败"),


    RESOURCE_COMPONENT_NOT_CONFIG(200,"please config resource component", "请先配置调度组件"),
    STORE_COMPONENT_NOT_CONFIG(201,"please config store component", "请先配置存储组件"),
    UNSUPPORTED_PLUGIN(203, "unsupported plugin", "插件不支持"),


    CAN_NOT_FIND_TASK(250, "task can not found","该任务不存在"),
    CAN_NOT_DELETE_TASK(251, "","该任务不能被删除"),
    VIRTUAL_TASK_UNSUPPORTED_OPERATION(253, "","虚节点任务不支持该操作"),
    CAN_NOT_PARSE_SYNC_TASK(262, "","同步任务json无法解析"),
    LOCK_IS_NOT_EXISTS(10055,"","该锁不存在"),
    TASK_CAN_NOT_SUBMIT(254, "","任务不能发布"),
    NO_FILLDATA_TASK_IS_GENERATE(256, "can not build fill data","没有补数据任务生成"),
    CAN_NOT_FIND_JOB(258, "job can not found","任务实例不存在"),
    JOB_CAN_NOT_STOP(259, "job can not stop","该任务处于不可停止状态"),
    JOB_ID_CAN_NOT_EMPTY(260, "job id can not empty","jobId不能为空"),
    ROLE_SIZE_LIMIT(300, "role size limit","超过管理员用户限制"),
    USER_NOT_ADMIN(301, "user not admin","当前操作用户不是管理员"),
    APPLICATION_CAT_NOT_EMPTY(302, "application can not be empty","application不能为空"),
    APPLICATION_NOT_FOUND(303, "application not found on yarn","获取不到application信息"),
    APPLICATION_NOT_MATCH(304, "application not match on yarn","application和当前任务jobId不匹配"),
    GET_APPLICATION_INFO_ERROR(305, "get application information error","获取applicationId信息错误"),

    SOURCE_CAN_NOT_AS_INPUT(451, "","该数据源不能作为输入数据源"),
    SOURCE_CAN_NOT_AS_OUTPUT(452, "","该数据源不能作为输出数据源"),
    CAN_NOT_FIND_SFTP(158, "","开启kerberos认证后，需配置SFTP服务"),
    GET_COLUMN_ERROR(547, "","获取数据库中相关表、字段信息时失败. 请联系 DBA 核查该库、表信息。"),
    TABLE_CAN_NOT_FIND(600, "","该表不存在"),
    NOT_EXISTS_PROJECT(601, "","不存在项目对应的数据库"),
    TABLE_INFO_ERR(602, "","table info ref not right"),
    CREATE_TABLE_ERR(603, "","创建表失败"),
    ALTER_TABLE_ERR(604, "","修改表出错"),
    GET_DIRTY_ERROR(605, "","get dirty data error"),
    CANT_NOT_FIND_CLUSTER(651, "cluster can not found","该集群不存在"),
    SQLPARSE_ERROR(652, "sql parse error", "sql解析失败"),
    BIND_COMPONENT_NOT_DELETED(653, "component can not deleted","集群已绑定租户，对应计算和调度组件不能删除"),
    METADATA_COMPONENT_NOT_DELETED(654, "metadata component can not deleted","集群已绑定租户，对应元数据不能删除"),;


    private final int code;
    private final String enMsg;
    private final String zhMsg;

    ErrorCode(int code, String enMsg, String zhMsg) {
        this.code = code;
        this.enMsg = enMsg;
        this.zhMsg = zhMsg;
    }

    @Override
    public int getCode() {
        return this.code;
    }

    @Override
    public String getDescription() {
        return getMsg();
    }

    public String getMsg() {
        if (Locale.SIMPLIFIED_CHINESE.getLanguage().equals(LocaleContextHolder.getLocale().getLanguage())) {
            return this.zhMsg;
        } else {
            return this.enMsg;
        }
    }
}