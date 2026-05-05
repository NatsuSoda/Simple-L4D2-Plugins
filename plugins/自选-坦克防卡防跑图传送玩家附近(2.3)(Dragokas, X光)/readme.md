# 自选-坦克防卡防跑图传送玩家附近(2.3)(Dragokas, X光)

## 简介

Teleport tank if he was stuck within collision and can't move

## 可用指令

- `sm_tkfk` [管理员指令] (权限: ADMFLAG_ROOT)

## 配置指令 (ConVar)

- `l4d_TankAntiStuck_enable` 默认值: `1`
- `l4d_TankAntiStuck_non_angry_time` 默认值: `30.0`
- `l4d_TankAntiStuck_tank_distance_max` 默认值: `2000.0`
- `l4d_TankAntiStuck_check_interval` 默认值: `10.0` - 多少秒检测一次坦克是否被卡住.
- `l4d_TankAntiStuck_non_stuck_radius` 默认值: `50.0` - 在指定秒内未移动时,坦克被判定为未卡住的最大半径.
- `l4d_TankAntiStuck_dest_object` 默认值: `3`
- `l4d_TankAntiStuck_min_transmit` 默认值: `300.0` - 坦克防卡传送距离目标以及所有幸存者最近距离.
- `l4d_TankAntiStuck_max_transmit` 默认值: `1000.0`
- `l4d_TankAntiStuck_all_intellect` 默认值: `1`
- `l4d_TankAntiStuck_apply_convar` 默认值: `1`
- `l4d_TankAntiStuck_rusher_punish` 默认值: `1`
- `l4d_TankAntiStuck_rusher_dist` 默认值: `2000.0` - 离坦克这么远被认为是在跑图.
- `l4d_TankAntiStuck_rusher_check_times` 默认值: `1` - 检测多少次玩家如果在跑图,下一次达到设置检测时间后就执行惩罚传送.
- `l4d_TankAntiStuck_rusher_check_interval` 默认值: `5.0` - 多少秒检测一次玩家是否跑图.
- `l4d_TankAntiStuck_rusher_minplayers` 默认值: `2` - 至少要这么多玩家才考虑检查是否有人跑图.
- `l4d_TankAntiStuck_rusher_Enable` 默认值: `1`
