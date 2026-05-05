# 自选-安全门锁定与防止玩家提前离开安全区(v2.8.1)(Glide Loading, sorallll, TogawaSakiko)

## 简介

static const char g_sPrefixes[][] = {

## 配置指令 (ConVar)

- `l4d2_dlock_allow` 默认值: `1`
- `l4d2_dlock_modes` 默认值: ``
- `l4d2_dlock_modes_off` 默认值: ``
- `l4d2_dlock_weakdoor` 默认值: `1` - 是否在倒计时结束时破坏安全门
- `l4d2_dlock_prepare_time` 默认值: `10` - 所有玩家加载完成后，额外等待几秒开始游戏
- `l4d2_dlock_timeout` 默认值: `30` - 等待玩家加载的超时时间
