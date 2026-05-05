# 自选-防止地图脚本污染(v1.2)(洛琪, Forgetest)

## 简介

防止地图脚本污染

## 配置指令 (ConVar)

- `l4d2_vscript_purifier` 默认值: `2` - 是否阻止非法脚本造成脚本污染,0不阻止, 1阻止, 2阻止并控制台打印信息, 3阻止并且将阻止情况记录到日志里,\\n[注意,地图脚本必须和地图mission文件放在同一个vpk内，才会被识别为地图脚本，否则会识别为脚本类MOD]
- `l4d2_vscript_cvarRestore` 默认值: `1` - 是否在过关时自动还原被脚本修改的cvar值,1是，0否.
- `l4d2_vscript_modewhiteList` 默认值: `1` - 是否读取模式白名单内容?白名单位于configs文件夹下.[例如,mutation4在白名单内，则所有此模式脚本都会放行.]

## 备注

- 配置文件: cfg/sourcemod/configs/l4d2_vscript_mode_whitelist.cfg
