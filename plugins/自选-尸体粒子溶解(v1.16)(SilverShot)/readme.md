# 自选-尸体粒子溶解(v1.16)(SilverShot)

## 简介

Dissolves the witch, common or special infected when killed.

## 可用指令

- `sm_dissolve` [管理员指令] (权限: ADMFLAG_ROOT)

## 配置指令 (ConVar)

- `l4d_dissolve_allow` 默认值: `1` - 0=Plugin off, 1=Plugin on.
- `l4d_dissolve_modes` 默认值: ``
- `l4d_dissolve_modes_off` 默认值: ``
- `l4d_dissolve_modes_tog` 默认值: `0` - Turn on the plugin in these game modes. 0=All, 1=Coop, 2=Survival, 4=Versus, 8=Scavenge. Add numbers together.
- `l4d_dissolve_chance` 默认值: `100` - Out of 100 the chance of dissolving a zombie when it dies. Note: stays activate for 0.5 seconds after triggering.
- `l4d_dissolve_infected` 默认值: `511` - Dissolve these on death: 1=Common, 2=Witch, 4=Smoker, 8=Boomer, 16=Hunter, 32=Spitter, 64=Jockey, 128=Charger, 256=Tank, 511=All.
- `l4d_dissolve_time` 默认值: `0.2`
- `l4d_dissolve_time_min` 默认值: `0.0` - When time_min and time_max are not 0.0 the dissolve time will randomly be set to a value between these.
- `l4d_dissolve_time_max` 默认值: `0.0` - When time_min and time_max are not 0.0 the dissolve time will randomly be set to a value between these.
