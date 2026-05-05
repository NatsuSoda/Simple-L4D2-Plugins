# 自选-服务器没人后炸服或切换为官图(v1.2.2)(lakwsh, 豆瓣酱な)

## 简介

public Plugin myinfo = {

## 可用指令

- `sm_bom`

## 配置指令 (ConVar)

- `l4d2_empty_Log` 默认值: `1` - 服务器无人后记录日志内容? 0=禁用, 1=启用.
- `l4d2_empty_Switch` 默认值: `1` - 服务器无人后执行什么功能? 0=禁用, 1=炸服, 2=切换为指定地图.
- `l4d2_empty_code` 默认值: `c2m1_highway`
- `l4d2_empty_mode` 默认值: `coop` - 服务器无人后设置什么模式(填入模式代码.
- `l4d2_empty_crash` 默认值: `1` - 允许什么系统的服务器崩溃? 1=linux, 2=windows, 3=两者.
- `l4d2_empty_type` 默认值: `1` - 允许什么类型的服务器崩溃? 1=专用服务器, 2=本地服务器, 3=两者.
- `l4d2_empty_Command` 默认值: `10` - 设置玩家使用!Bom指令手动炸服的倒计时时间/秒. 0=禁用.
