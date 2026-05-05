# 自选-扔投掷物提示(v1.0.8)(Mart)

## 简介

- Fixed fake throw announces. (thanks "KadabraZz" for reporting)

## 可用指令

- `sm_print_cvars_l4d_throwable_announcer` [管理员指令] (权限: ADMFLAG_ROOT)

## 配置指令 (ConVar)

- `l4d_throwable_announcer_enable` 默认值: `1` - 启用此插件? 0=禁用, 1=启用.
- `l4d_throwable_announcer_fake_throw` 默认值: `0.3` - 等待多少秒后检测是不是假投掷物. 0=关闭, 1=开启.
- `l4d_throwable_announcer_team` 默认值: `1` - 抛出投掷物的提示消息发送给那些团队. 0=没有, 1=幸存者, 2=感染者, 4=旁观者, 8=幸存者NPC. 如需启用多个把数字加起来. 例如: 3=幸存者+感染者.
- `l4d_throwable_announcer_self` 默认值: `1` - 抛出投掷物的提示消息发送给使用者? 0=关闭, 1=开启.
- `l4d_throwable_announcer_molotov` 默认值: `1` - 每次抛出燃烧瓶时提示. 0=关闭, 1=开启.
- `l4d_throwable_announcer_pipebomb` 默认值: `1` - 每次抛出土制炸弹时提示. 0=关闭, 1=开启.
- `l4d_throwable_announcer_vomitjar` 默认值: `1` - 每次抛出胆汁罐时提示. 0=关闭, 1=开启.
