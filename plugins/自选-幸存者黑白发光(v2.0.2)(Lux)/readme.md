# 自选-幸存者黑白发光(v2.0.2)(Lux)

## 简介

Core of LMC, manages overlay models

## 包含文件

- LMCCore
- LMC_Black_and_White_Notifier

## 配置指令 (ConVar)

- `lmc_aggressive_model_checks` 默认值: `0`
- `lmc_blackandwhite` 默认值: `1` - 启用幸存者黑白提示? 0=禁用,1=启用.
- `lmc_glow` 默认值: `1` - 启用幸存者黑白发光. 0=禁用,1=启用.
- `lmc_glowcolour` 默认值: `0 0 255`
- `lmc_glowrange` 默认值: `800.0` - 黑白发光的幸存者最大的可视距离.
- `lmc_glowflash` 默认值: `20` - 黑白状态下的幸存者血量低于多少时黑白光环开始闪烁. 0=禁用.
- `lmc_noticetype` 默认值: `1`
- `lmc_teamnoticetype` 默认值: `0` - 幸存者黑白后通知给谁. 0=幸存者, 1=感染者, 2=幸存者和感染者.
- `lmc_hintrange` 默认值: `1200` - 使用暗示类黑白提示时幸存者队友能看见提示消息的距离. 最小值1, 最大值9999.
- `lmc_hinttime` 默认值: `10.0` - 黑白消息的提示持续时间/秒. 最小值1, 最大值20.
- `lmc_hintcolour` 默认值: `0 0 255`
