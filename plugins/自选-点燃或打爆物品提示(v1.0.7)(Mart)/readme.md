# 自选-点燃或打爆物品提示(v1.0.7)(Mart)

## 简介

- Fixed compability with other plugins. (thanks "ddd123" for reporting)

## 可用指令

- `sm_print_cvars_l4d_explosion_announcer` [管理员指令] (权限: ADMFLAG_ROOT)

## 配置指令 (ConVar)

- `l4d_explosion_announcer_enable` 默认值: `1` - 启用此插件? 0=禁用, 1=启用.
- `l4d_explosion_announcer_spam_protection` 默认值: `3.0` - 来自同一个客户端的消息延迟多少秒输出到聊天窗. 0=关闭.
- `l4d_explosion_announcer_spam_type_check` 默认值: `1` -  是不一样的实体类型. 0=关闭, 1=开启.
- `l4d_explosion_announcer_team` 默认值: `1` - 提示消息发送给那些团队. 0=没有, 1=幸存者, 2=感染者, 4=旁观者, 8=幸存者NPC. 如需启用多个把数字加起来. 例如: 3=幸存者+感染者.
- `l4d_explosion_announcer_self` 默认值: `1` - 提示消息发送给点燃或引爆者?. 0=关闭, 1=开启.
- `l4d_explosion_announcer_gascan` 默认值: `1` - 启用幸存者引燃汽油桶提示? 0=关闭, 1=开启.
- `l4d_explosion_announcer_fuelbarrel` 默认值: `1` - 启用幸存者打爆白色大油桶提示? 0=关闭, 1=开启.
- `l4d_explosion_announcer_propanecanister` 默认值: `1` - 启用幸存者打爆煤气罐提示? 0=关闭, 1=开启.
- `l4d_explosion_announcer_oxygentank` 默认值: `1` - 启用幸存者打爆氧气罐提示? 0=关闭, 1=开启.
- `l4d_explosion_announcer_barricadegascan` 默认值: `1` - 启用幸存者引燃路障油桶提示? 0=关闭, 1=开启.
- `l4d_explosion_announcer_gaspump` 默认值: `1` - 启用幸存者打爆汽油泵提示? 0=关闭, 1=开启.
- `l4d_explosion_announcer_oildrumexplosive` 默认值: `1`
- `l4d_explosion_announcer_fireworkscrate` 默认值: `1` - 启用幸存者点燃烟花盒提示? 0=关闭, 1=开启.
