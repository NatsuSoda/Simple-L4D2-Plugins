# 自选-多特感插件(v1.3.7)(Tordecybombo, breezy)

## 简介

Provides customisable special infected spawing beyond vanilla coop limits

## 可用指令

- `sm_weight` [管理员指令] (权限: ADMFLAG_RCON)
- `sm_limit` [管理员指令] (权限: ADMFLAG_RCON)
- `sm_timer` [管理员指令] (权限: ADMFLAG_RCON)
- `sm_resetspawn` [管理员指令] (权限: ADMFLAG_RCON)
- `sm_forcetimer` [管理员指令] (权限: ADMFLAG_RCON)
- `sm_type` [管理员指令] (权限: ADMFLAG_ROOT)

## 配置指令 (ConVar)

- `ss_si_limit` 默认值: `15` - 同时存在的最大特感数量
- `ss_spawn_size` 默认值: `4` - 一次产生多少只特感
- `ss_smoker_limit` 默认值: `2` - 同时存在的最大smoker数量
- `ss_boomer_limit` 默认值: `2` - 同时存在的最大boomer数量
- `ss_hunter_limit` 默认值: `4` - 同时存在的最大hunter数量
- `ss_spitter_limit` 默认值: `2` - 同时存在的最大spitter数量
- `ss_jockey_limit` 默认值: `4` - 同时存在的最大jockey数量
- `ss_charger_limit` 默认值: `4` - 同时存在的最大charger数量
- `ss_smoker_weight` 默认值: `100` - smoker产生比重
- `ss_boomer_weight` 默认值: `200` - boomer产生比重
- `ss_hunter_weight` 默认值: `100` - hunter产生比重
- `ss_spitter_weight` 默认值: `200` - spitter产生比重
- `ss_jockey_weight` 默认值: `100` - jockey产生比重
- `ss_charger_weight` 默认值: `100` - charger产生比重
- `ss_scale_weights` 默认值: `1`
- `ss_time_min` 默认值: `10.0` - 特感的最小产生时间
- `ss_time_max` 默认值: `15.0` - 特感的最大产生时间
- `ss_time_mode` 默认值: `1`
- `ss_base_limit` 默认值: `4` - 生还者团队不超过4人时有多少个特感
- `ss_extra_limit` 默认值: `1` - 生还者团队每增加一人可增加多少个特感
- `ss_base_size` 默认值: `4` - 生还者团队不超过4人时一次产生多少只特感
- `ss_extra_size` 默认值: `1` - 生还者团队每增加多少玩家人一次多产生一只特感
- `ss_tankstatus_action` 默认值: `1`
- `ss_tankstatus_limits` 默认值: `2;1;4;1;4;4` - 坦克产生后每种特感数量的自定义参数
- `ss_tankstatus_weights` 默认值: `100;400;100;200;100;100` - 坦克产生后每种特感比重的自定义参数
- `ss_suicide_time` 默认值: `25.0` - 特感自动处死时间
- `ss_rush_distance` 默认值: `1500.0`
- `ss_spawnrange_min` 默认值: `100.0` - 特感最小生成距离
- `ss_spawnrange_max` 默认值: `1500.0` - 特感最大生成距离
- `ss_first_time` 默认值: `0.0` - 玩家离开安全区域后第一波特感的刷新时间
