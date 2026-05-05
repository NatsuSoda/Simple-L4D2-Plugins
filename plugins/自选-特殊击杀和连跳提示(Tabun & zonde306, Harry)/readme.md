# 自选-特殊击杀和连跳提示(Tabun & zonde306, Harry)

## 简介

Plugin to detect and forward reports about 'skill'-actions,

## 配置指令 (ConVar)

- `sm_skill_report_enable` 默认值: `1`
- `sm_skill_skeet_shotgun` 默认值: `1` - Whether to count/forward shotgun skeets.
- `sm_skill_skeet_magnum` 默认值: `1` - Whether to count/forward magnum pistol skeets.
- `sm_skill_skeet_melee` 默认值: `1` - Whether to count/forward melee skeets.
- `sm_skill_skeet_sniper` 默认值: `1` - Whether to count/forward sniper as skeets.
- `sm_skill_skeet_grenade_launcher` 默认值: `1` - Whether to count/forward direct grenade launcher hits as skeets.
- `sm_skill_drawcrown_damage` 默认值: `500` - How much damage a survivor must at least do in the final shot for it to count as a drawcrown.
- `sm_skill_selfclear_damage` 默认值: `200` - How much damage a survivor must at least do to a smoker for him to count as self-clearing.
- `sm_skill_hunterdp_height` 默认值: `400` - Minimum height of hunter pounce for it to count as a DP.
- `sm_skill_jockeydp_height` 默认值: `300` - How much height distance a jockey must make for his 'DP' to count as a reportable highpounce.
- `sm_skill_hidefakedamage` 默认值: `1` - If set, any damage done that exceeds the health of a victim is hidden in reports.
- `sm_skill_deathcharge_height` 默认值: `400` - How much height distance a charger must take its victim for a deathcharge to be reported.
- `sm_skill_instaclear_time` 默认值: `0.75`
- `sm_skill_bhopstreak` 默认值: `3` - The lowest bunnyhop streak that will be reported.
- `sm_skill_bhopinitspeed` 默认值: `150`
- `sm_skill_bhopkeepspeed` 默认值: `300` - The minimal speed at which hops are considered succesful even if not speed increase is made.
- `sm_skill_vomit_number` 默认值: `4` - How many survivors a boomer must at least vomit to count as wonderful-vomit.
- `z_pounce_damage_range_max` 默认值: `1000.0` - Not available on this server, added by l4d2_skill_detect.
- `z_pounce_damage_range_min` 默认值: `300.0` - Not available on this server, added by l4d2_skill_detect.
- `z_hunter_max_pounce_bonus_damage` 默认值: `24` - Not available on this server, added by l4d2_skill_detect.
