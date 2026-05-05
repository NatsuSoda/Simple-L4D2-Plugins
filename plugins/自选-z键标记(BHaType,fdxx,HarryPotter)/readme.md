# 自选-z键标记(BHaType,fdxx,HarryPotter)

## 简介

When using 'Look' in vocalize menu, print corresponding item to chat area and make item glow or create spot marker/infeced maker like back 4 blood.

## 可用指令

- `sm_bj`

## 配置指令 (ConVar)

- `l4d2_item_hint_cmd` 默认值: `1` - 如果为1,玩家可以输入!bj指令为标记
- `l4d2_item_hint_shiftE` 默认值: `1` - 如果为1,玩家可以按Shift+E进行标记
- `l4d2_item_hint_vocalize` 默认值: `1` - 如果为1,玩家可以使用“看”进行标记
- `l4d2_item_hint_mark_capped` 默认值: `0` - 如果为1,玩家可以使用标记,如果被S.I.盯住
- `l4d2_item_hint_mark_hanging` 默认值: `0` - 如果为1,玩家可以使用标记,如果是从窗台上悬挂
- `l4d2_item_hint_mark_dead` 默认值: `0` - 如果为1,玩家可以在已经死亡的情况下使用标记
- `l4d2_item_hint_instructorhint_translate` 默认值: `0`
- `l4d2_item_marker_glow_color` 默认值: `0 255 255`
- `l4d2_item_marker_cooldown_time` 默认值: `1.0` - 玩家使用语音菜单的‘看’创建查看物品的冷却时间
- `l4d2_item_marker_use_range` 默认值: `150` - 玩家使用语音菜单查看物品最远距离
- `l4d2_item_marker_use_sound` 默认值: `buttons/blip1.wav`
- `l4d2_item_marker_announce_type` 默认值: `1` - 物品标记提示的显示方式.(0:禁用,1:在聊天中,2:在提示框中,3:在屏幕中心）
- `l4d2_item_marker_glow_timer` 默认值: `15.0` - 物品发光时间
- `l4d2_item_marker_glow_range` 默认值: `1000` - 物品发光范围
- `l4d2_item_marker_instructorhint_enable` 默认值: `1` - 如果为1,则在物品上方显示物品提示
- `l4d2_item_marker_instructorhint_color` 默认值: `0 255 255`
- `l4d2_item_marker_instructorhint_icon` 默认值: `icon_interact`
- `l4d2_spot_marker_color` 默认值: `0 255 255`
- `l4d2_spot_marker_cooldown_time` 默认值: `2.5` - 玩家使用语音菜单的‘看’创建标记的冷却时间
- `l4d2_spot_marker_use_range` 默认值: `2000` - 玩家可以标记的最大范围
- `l4d2_spot_marker_use_sound` 默认值: `buttons/blip1.wav`
- `l4d2_spot_marker_announce_type` 默认值: `0`
- `l4d2_spot_marker_duration` 默认值: `15.0` - 标记持续时间
- `l4d2_spot_marker_sprite_model` 默认值: `materials/vgui/icon_download.vmt`
- `l4d2_spot_marker_instructorhint_enable` 默认值: `1` - 如果1,则在标记上方创建标记提示
- `l4d2_spot_marker_instructorhint_color` 默认值: `200 200 200` - 标记上方提示的颜色,自行去https://tool.oschina.net/commons?type=3比对颜色
- `l4d2_spot_marker_instructorhint_icon` 默认值: `` - 标记上方提示图标
- `l4d2_infected_marker_glow_color` 默认值: `255 120 203`
- `l4d2_infected_marker_cooldown_time` 默认值: `0.25` - 玩家使用语音菜单的‘看’标记发光特殊感染者的冷却时间
- `l4d2_infected_marker_use_range` 默认值: `2000` - 玩家多远可以标记特殊感染者
- `l4d2_infected_marker_use_sound` 默认值: `items/suitchargeok1.wav`
- `l4d2_infected_marker_announce_type` 默认值: `1`
- `l4d2_infected_marker_glow_timer` 默认值: `10.0` - 感染标记发光时间
- `l4d2_infected_marker_glow_range` 默认值: `2500` - 感染标记发光范围
- `l4d2_infected_marker_witch_enable` 默认值: `1` - 如果为1,在开关上启用“看”感染者标记
- `l4d2_infected_marker_instructorhint_enable` 默认值: `1`
- `l4d2_infected_marker_instructorhint_color` 默认值: `255 0 0`
- `l4d2_infected_marker_instructorhint_icon` 默认值: `` - 标记感染者上方提示图标
- `l4d2_survivor_marker_glow_color` 默认值: `0 200 0`
- `l4d2_survivor_marker_cooldown_time` 默认值: `1.0` - 玩家使用语音菜单的‘看’标记发光生者的冷却时间
- `l4d2_survivor_marker_use_range` 默认值: `1000` - 玩家多远可以标记特生还者
- `l4d2_survivor_marker_use_sound` 默认值: `player/suit_denydevice.wav`
- `l4d2_survivor_marker_announce_type` 默认值: `1` - 更改幸存者标记提示的显示方式,（0:禁用，1:聊天中,2:提示框中,3:居中文本）
- `l4d2_survivor_marker_glow_timer` 默认值: `10.0` - 生还者标记发光时间
- `l4d2_survivor_marker_glow_range` 默认值: `2000` - 生还者标记发光范围
- `l4d2_survivor_marker_instructorhint_enable` 默认值: `1` - 如果为1,在开关上启用“看”生还者标记
- `l4d2_survivor_marker_instructorhint_color` 默认值: `0 200 0`
- `l4d2_survivor_marker_instructorhint_icon` 默认值: `` - 标记生还者上方提示图标
