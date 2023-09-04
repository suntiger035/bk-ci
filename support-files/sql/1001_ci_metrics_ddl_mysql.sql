USE devops_ci_metrics;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `T_PIPELINE_OVERVIEW_DATA` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `PIPELINE_ID` varchar(34) NOT NULL  COMMENT '流水线ID',
  `PIPELINE_NAME` varchar(255) NOT NULL COMMENT '流水线名称',
  `CHANNEL_CODE` varchar(32) NOT NULL DEFAULT '' COMMENT '渠道代码',
  `TOTAL_AVG_COST_TIME` bigint(20) NOT NULL COMMENT '总平均耗时，单位：毫秒',
  `SUCCESS_AVG_COST_TIME` bigint(20) COMMENT '成功平均耗时，单位：毫秒',
  `FAIL_AVG_COST_TIME` bigint(20) COMMENT '失败平均耗时，单位：毫秒',
  `TOTAL_EXECUTE_COUNT` bigint(20) DEFAULT '0' COMMENT '总执行次数',
  `SUCCESS_EXECUTE_COUNT` bigint(20) DEFAULT '0' COMMENT '成功执行次数',
  `FAIL_EXECUTE_COUNT` bigint(20) DEFAULT '0' COMMENT '失败执行次数',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`CREATE_TIME`),
  UNIQUE KEY `UNI_TPOD_PROJECT_TIME_PIPELINE` (`PROJECT_ID`,`STATISTICS_TIME`,`PIPELINE_ID`,`CREATE_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流水线数据概览表';

CREATE TABLE IF NOT EXISTS `T_PIPELINE_STAGE_OVERVIEW_DATA` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `PIPELINE_ID` varchar(34) NOT NULL  COMMENT '流水线ID',
  `PIPELINE_NAME` varchar(255) NOT NULL COMMENT '流水线名称',
  `CHANNEL_CODE` varchar(32) NOT NULL DEFAULT '' COMMENT '渠道代码',
  `STAGE_TAG_NAME` varchar(45) DEFAULT '' COMMENT '阶段标签名称',
  `AVG_COST_TIME` bigint(20) NOT NULL COMMENT '平均耗时，单位：毫秒',
  `EXECUTE_COUNT` bigint(20) DEFAULT '0' COMMENT '总执行次数',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`CREATE_TIME`),
  UNIQUE KEY `UNI_TPSOD_PROJECT_TIME_PIPELINE_TAG` (`PROJECT_ID`,`STATISTICS_TIME`,`PIPELINE_ID`,`STAGE_TAG_NAME`,`CREATE_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流水线stage数据概览表';

CREATE TABLE IF NOT EXISTS `T_PIPELINE_FAIL_SUMMARY_DATA` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `PIPELINE_ID` varchar(34) NOT NULL  COMMENT '流水线ID',
  `PIPELINE_NAME` varchar(255) NOT NULL COMMENT '流水线名称',
  `CHANNEL_CODE` varchar(32) NOT NULL DEFAULT '' COMMENT '渠道代码',
  `ERROR_TYPE` int(11) DEFAULT NULL COMMENT '错误的类型标识',
  `ERROR_COUNT` int(11) DEFAULT NULL COMMENT '错误次数',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`CREATE_TIME`),
  UNIQUE KEY `UNI_TPFSD_PROJECT_TIME_PIPELINE_TYPE` (`PROJECT_ID`,`STATISTICS_TIME`,`PIPELINE_ID`,`ERROR_TYPE`,`CREATE_TIME`),
  KEY  `INX_TPFSD_PROJECT_TIME_TYPE` (`PROJECT_ID`, `STATISTICS_TIME`, `ERROR_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流水线失败汇总表';

CREATE TABLE IF NOT EXISTS `T_PIPELINE_FAIL_DETAIL_DATA` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `PIPELINE_ID` varchar(34) NOT NULL  COMMENT '流水线ID',
  `PIPELINE_NAME` varchar(255) NOT NULL COMMENT '流水线名称',
  `CHANNEL_CODE` varchar(32) NOT NULL DEFAULT '' COMMENT '渠道代码',
  `BUILD_ID` varchar(34) NOT NULL COMMENT '构建ID',
  `BUILD_NUM` int(20) NOT NULL COMMENT '构建序号',
  `REPO_URL` varchar(512)  COMMENT '触发代码库地址',
  `BRANCH` varchar(128)  COMMENT '触发代码库分支',
  `START_USER` varchar(64) NOT NULL COMMENT '启动用户',
  `START_TIME` datetime(3) COMMENT '启动时间',
  `END_TIME` datetime(3) COMMENT '结束时间',
  `ERROR_TYPE` int(11) DEFAULT NULL COMMENT '错误的类型标识',
  `ERROR_CODE` int(11) DEFAULT NULL COMMENT '错误的标识码',
  `ERROR_MSG` text /*!99104 COMPRESSED */ COMMENT '错误描述',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`CREATE_TIME`),
  KEY  `INX_TPFDD_PROJECT_TIME_PIPELINE_ERROR` (`PROJECT_ID`, `STATISTICS_TIME`, `PIPELINE_ID`, `ERROR_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流水线失败明细表';

CREATE TABLE IF NOT EXISTS `T_ATOM_OVERVIEW_DATA` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `PIPELINE_ID` varchar(34) NOT NULL  COMMENT '流水线ID',
  `PIPELINE_NAME` varchar(255) NOT NULL COMMENT '流水线名称',
  `CHANNEL_CODE` varchar(32) NOT NULL DEFAULT '' COMMENT '渠道代码',
  `ATOM_CODE` varchar(64) NOT NULL COMMENT '插件代码',
  `ATOM_NAME` varchar(64) NOT NULL COMMENT '插件名称',
  `CLASSIFY_CODE` varchar(32) NOT NULL COMMENT '插件分类代码',
  `CLASSIFY_NAME` varchar(32) NOT NULL COMMENT '插件分类名称',
  `SUCCESS_RATE` decimal(5,2) NOT NULL COMMENT '成功率',
  `AVG_COST_TIME` bigint(20) NOT NULL COMMENT '总平均耗时，单位：毫秒',
  `TOTAL_EXECUTE_COUNT` bigint(20) DEFAULT '0' COMMENT '总执行次数',
  `SUCCESS_EXECUTE_COUNT` bigint(20) DEFAULT '0' COMMENT '成功执行次数',
  `FAIL_EXECUTE_COUNT` bigint(20) DEFAULT '0' COMMENT '失败执行次数',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`CREATE_TIME`),
  UNIQUE KEY `UNI_TAOD_PROJECT_TIME_PIPELINE_ATOM` (`PROJECT_ID`,`STATISTICS_TIME`,`PIPELINE_ID`,`ATOM_CODE`,`CREATE_TIME`),
  KEY  `INX_TAOD_PROJECT_TIME_ATOM` (`PROJECT_ID`, `STATISTICS_TIME`, `ATOM_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='插件数据概览表';

CREATE TABLE IF NOT EXISTS `T_ATOM_FAIL_SUMMARY_DATA` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `PIPELINE_ID` varchar(34) NOT NULL  COMMENT '流水线ID',
  `PIPELINE_NAME` varchar(255) NOT NULL COMMENT '流水线名称',
  `CHANNEL_CODE` varchar(32) NOT NULL DEFAULT '' COMMENT '渠道代码',
  `ATOM_CODE` varchar(64) NOT NULL COMMENT '插件代码',
  `ATOM_NAME` varchar(64) NOT NULL COMMENT '插件名称',
  `CLASSIFY_CODE` varchar(32) NOT NULL COMMENT '插件分类代码',
  `CLASSIFY_NAME` varchar(32) NOT NULL COMMENT '插件分类名称',
  `ERROR_TYPE` int(11) DEFAULT NULL COMMENT '错误的类型标识',
  `ERROR_COUNT` int(11) DEFAULT NULL COMMENT '错误次数',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`CREATE_TIME`),
  UNIQUE KEY `UNI_TAFSD_PROJECT_TIME_PIPELINE_TYPE_CODE` (`PROJECT_ID`,`STATISTICS_TIME`,`PIPELINE_ID`,`ERROR_TYPE`,`ATOM_CODE`,`CREATE_TIME`),
  KEY  `INX_TAFSD_PROJECT_TIME_TYPE` (`PROJECT_ID`, `STATISTICS_TIME`, `ERROR_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='插件失败汇总表';

CREATE TABLE IF NOT EXISTS `T_ATOM_FAIL_DETAIL_DATA` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `PIPELINE_ID` varchar(34) NOT NULL  COMMENT '流水线ID',
  `PIPELINE_NAME` varchar(255) NOT NULL COMMENT '流水线名称',
  `CHANNEL_CODE` varchar(32) NOT NULL DEFAULT '' COMMENT '渠道代码',
  `BUILD_ID` varchar(34) NOT NULL COMMENT '构建ID',
  `BUILD_NUM` int(20) NOT NULL COMMENT '构建序号',
  `ATOM_CODE` varchar(64) NOT NULL COMMENT '插件代码',
  `ATOM_NAME` varchar(64) NOT NULL COMMENT '插件名称',
  `ATOM_POSITION` varchar(32) NOT NULL DEFAULT '' COMMENT '插件在model中的位置',
  `CLASSIFY_CODE` varchar(32) NOT NULL COMMENT '插件分类代码',
  `CLASSIFY_NAME` varchar(32) NOT NULL COMMENT '插件分类名称',
  `START_USER` varchar(64) NOT NULL COMMENT '启动用户',
  `START_TIME` datetime(3) COMMENT '启动时间',
  `END_TIME` datetime(3) COMMENT '结束时间',
  `ERROR_TYPE` int(11) DEFAULT NULL COMMENT '错误的类型标识',
  `ERROR_CODE` int(11) DEFAULT NULL COMMENT '错误的标识码',
  `ERROR_MSG` text /*!99104 COMPRESSED */ COMMENT '错误描述',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`CREATE_TIME`),
  KEY  `INX_TAFDD_PROJECT_TIME_PIPELINE_TYPE_CODE` (`PROJECT_ID`, `STATISTICS_TIME`, `PIPELINE_ID`, `ERROR_TYPE`, `ERROR_CODE`),
  KEY  `INX_TAFDD_PROJECT_TIME_TYPE_CODE` (`PROJECT_ID`, `STATISTICS_TIME`, `ERROR_TYPE`, `ERROR_CODE`),
  KEY  `INX_TAFDD_PROJECT_TIME_CODE` (`PROJECT_ID`, `STATISTICS_TIME`, `ERROR_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='插件失败明细表';

CREATE TABLE IF NOT EXISTS `T_PROJECT_THIRD_PLATFORM_DATA` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `REPO_CODECC_AVG_SCORE` decimal(5,2)  COMMENT 'codecc检查代码库平均分',
  `RESOLVED_DEFECT_NUM` int(11)  COMMENT '已解决缺陷数',
  `QUALITY_PIPELINE_INTERCEPTION_NUM` int(11)  COMMENT '使用质量红线的流水线执行被拦截次数',
  `QUALITY_PIPELINE_EXECUTE_NUM` int(11)  COMMENT '使用质量红线的流水线执行总次数',
  `TURBO_SAVE_TIME` decimal(20,2)  COMMENT '编译加速节省时间，单位：秒',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`CREATE_TIME`),
  UNIQUE KEY `UNI_TPTPD_PROJECT_TIME` (`PROJECT_ID`,`STATISTICS_TIME`,`CREATE_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目的第三方平台数据';

CREATE TABLE IF NOT EXISTS `T_PROJECT_PIPELINE_LABEL_INFO` (
  `ID` bigint(32) NOT NULL AUTO_INCREMENT  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `PIPELINE_ID` varchar(34) NOT NULL  COMMENT '流水线ID',
  `LABEL_ID` bigint(20) NOT NULL COMMENT '标签ID',
  `LABEL_NAME` varchar(64) NOT NULL COMMENT '标签名称',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY  `UNI_TPPLI_PROJECT_PIPELINE_LABEL` (`PROJECT_ID`, `PIPELINE_ID`, `LABEL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流水线标签信息';

CREATE TABLE IF NOT EXISTS `T_ATOM_DISPLAY_CONFIG` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL  COMMENT '项目ID',
  `ATOM_CODE` varchar(64) NOT NULL COMMENT '插件代码',
  `ATOM_NAME` varchar(64) NOT NULL COMMENT '插件名称',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNI_TADC_PROJECT_ATOM` (`PROJECT_ID`, `ATOM_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='插件展示配置表';

CREATE TABLE IF NOT EXISTS `T_ERROR_TYPE_DICT` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `ERROR_TYPE` int(11) NOT NULL COMMENT '错误类型',
  `NAME` varchar(128) NOT NULL COMMENT '错误类型名称',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNI_TETD_TYPE_NAME` (`ERROR_TYPE`, `NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='错误类型字典表';

CREATE TABLE IF NOT EXISTS `T_ERROR_CODE_INFO` (
  `ID` bigint(32) NOT NULL  COMMENT '主键ID',
  `ERROR_TYPE` int(11) NOT NULL COMMENT '错误类型',
  `ERROR_CODE` int(11) NOT NULL COMMENT '错误的标识码',
  `ERROR_MSG` text /*!99104 COMPRESSED */ COMMENT '错误描述',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `ATOM_CODE` varchar(64) DEFAULT NULL COMMENT '关联插件Code',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `T_ERROR_CODE_INFO_UN` (`ERROR_TYPE`,`ERROR_CODE`,`ATOM_CODE`),
  KEY `INX_TECI_CODE` (`ERROR_CODE`),
  KEY `INX_TECI_ATOM_CODE` (`ATOM_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='错误码信息表';

CREATE TABLE IF NOT EXISTS `T_ATOM_INDEX_STATISTICS_DAILY` (
  `ID` bigint(32) NOT NULL COMMENT '主键ID',
  `ATOM_CODE` varchar(64) NOT NULL COMMENT '插件代码',
  `FAIL_COMPLIANCE_COUNT` int(11) NOT NULL DEFAULT 0 COMMENT '插件错误合规次数',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `FAIL_EXECUTE_COUNT` int(11) NOT NULL DEFAULT 0 COMMENT '失败执行次数',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNI_TAISD_ATOM_TIME` (`ATOM_CODE`,`STATISTICS_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='插件每日指标数据统计表';

CREATE TABLE IF NOT EXISTS `T_ATOM_MONITOR_DATA_DAILY` (
  `ID` bigint(32) NOT NULL COMMENT '主键ID',
  `ATOM_CODE` varchar(64) NOT NULL COMMENT '插件代码',
  `EXECUTE_COUNT` bigint(20) DEFAULT '0' COMMENT '执行次数',
  `STATISTICS_TIME` datetime(3) NOT NULL COMMENT '统计时间',
  `ERROR_TYPE` int(11) DEFAULT NULL COMMENT '错误类型',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  `UPDATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '修改时间',
  `CREATE_TIME` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY (`ID`,`STATISTICS_TIME`),
  UNIQUE KEY `UNI_TAMDD_ATOM_TIME_TYPE` (`ATOM_CODE`,`STATISTICS_TIME`,`ERROR_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='插件监控数据每日统计表';

CREATE TABLE IF NOT EXISTS `T_PROJECT_ATOM` (
  `ID` bigint(32) NOT NULL COMMENT '主键ID',
  `PROJECT_ID` varchar(64) NOT NULL COMMENT '项目ID',
  `ATOM_CODE` varchar(64) NOT NULL COMMENT '插件代码',
  `ATOM_NAME` varchar(64) NOT NULL COMMENT '插件名称',
  `CREATOR` varchar(50) NOT NULL DEFAULT 'system' COMMENT '创建者',
  `MODIFIER` varchar(50) NOT NULL DEFAULT 'system' COMMENT '修改者',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNI_TPA_PROJECT_CODE` (`PROJECT_ID`,`ATOM_CODE`),
  KEY `T_PROJECT_ATOM_PROJECT_ID_IDX` (`PROJECT_ID`,`ATOM_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目下插件关联关系表';

SET FOREIGN_KEY_CHECKS = 1;
