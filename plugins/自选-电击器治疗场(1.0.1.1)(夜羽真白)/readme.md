# 自选-电击器治疗场(1.0.1.1)(夜羽真白)

## 简介

电击器治疗场，对需要治疗的对象（未死亡）按住鼠标左键，会触发治疗范围，范围内的多个对象皆可受到治疗

## 配置指令 (ConVar)

- `l4d2_defibfield_enable` 默认值: `1` - 是否开启插件：0=关闭，1=开启
- `l4d2_defibfield_chance` 默认值: `100` - 电击器可以触发治疗场的概率：0=不触发
- `l4d2_defibfield_range` 默认值: `300.0` - 治疗场的最大范围：50-500
- `l4d2_defibfield_speed` 默认值: `0.5` - 治疗场光圈的扩散速度，数值越小越快：0.1-10.0
- `l4d2_defibfield_width` 默认值: `100.0` - 治疗场的光圈宽度，数值越大光圈宽度越大
- `l4d2_defibfield_distance` 默认值: `100.0` - 需要距离目标生还者多近距离才能触发治疗场倒数提示
- `l4d2_defibfield_delay` 默认值: `3` - 需要等待多少秒才能触发治疗场
- `l4d2_defibfield_shake` 默认值: `5.0` - 治疗场触发时触发者与接受者屏幕抖动效果的强度，数值越大越强
- `l4d2_defibfield_shaketime` 默认值: `2.0` - 治疗场触发时触发者与接受者屏幕抖动的时间，数值越大越长
- `l4d2_defibfield_health` 默认值: `40` - 治疗场能为范围内生还者回复的实血
- `l4d2_defibfield_temphealth` 默认值: `0` - 治疗场能为范围内生还者回复的虚血
- `l4d2_defibfield_red` 默认值: `0` - 治疗场范围的红色颜色值（不会设置请查询RGB颜色表）
- `l4d2_defibfield_green` 默认值: `255` - 治疗场范围的绿色颜色值（不会设置请查询RGB颜色表）
- `l4d2_defibfield_blue` 默认值: `0` - 治疗场范围的蓝色颜色值（不会设置请查询RGB颜色表）
- `l4d2_defibfield_message` 默认值: `2` - 是否开启治疗场消息提示，0=不提示，1=打印到聊天框，2=中间提示
