# 自选-惩罚使用某些指令的玩家和隐藏某些不想看见的指令(v1.0)(sorallll)

## 简介

public Plugin myinfo =

## 配置指令 (ConVar)

- `blockcmds_list` 默认值: `sm_pw;sm_rpg;sm_explode;sm_vip;sm_help` - 使用';'号分隔要禁用的命令.
- `l4d2_blockcmds_punish_Type` 默认值: `0` - 玩家输入了限制的指令后的惩罚方式. 0=仅提示, 1=处死, 2=踢出, 3=封禁.
- `l4d2_blockcmds_punish_time` 默认值: `5` - 设置被封禁的时间/分钟. 0=永久封禁.
