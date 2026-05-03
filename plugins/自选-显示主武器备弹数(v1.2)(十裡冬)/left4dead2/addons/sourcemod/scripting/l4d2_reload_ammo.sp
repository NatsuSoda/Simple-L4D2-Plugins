#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

ConVar g_hEnable;
ConVar g_hDisplayType;

public Plugin myinfo = 
{
    name = "主武器换弹提示",
    author = "十裡冬",
    description = "换弹显示主武器备弹",
    version = "1.2",
    url = "NULL"
};

public void OnPluginStart()
{
    g_hEnable = CreateConVar("l4d2_reload_ammo_enable", "1", "1=开启插件, 0=关闭");
    g_hDisplayType = CreateConVar("l4d2_reload_ammo_type", "2", "1=屏幕中下方(Hint), 2=聊天栏(Chat)");
    
    AutoExecConfig(true, "l4d2_reload_ammo");

    HookEvent("weapon_reload", Event_WeaponReload);
}

public void Event_WeaponReload(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_hEnable.BoolValue) return;

    int client = GetClientOfUserId(event.GetInt("userid"));

    // 基础校验：玩家有效、在游戏中、幸存者、存活
    if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client))
    {
        int primaryWeapon = GetPlayerWeaponSlot(client, 0); // 0号位即为主武器
        int activeWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

        // 仅当当前手持的是主武器时生效
        if (activeWeapon != -1 && activeWeapon == primaryWeapon)
        {
            int ammoType = GetEntProp(activeWeapon, Prop_Send, "m_iPrimaryAmmoType");
            if (ammoType != -1)
            {
                int ammoCount = GetEntProp(client, Prop_Send, "m_iAmmo", _, ammoType);
                
                char message[64];
                // 严格按照你要求的格式：只有一行
                Format(message, sizeof(message), "剩余备弹->%d", ammoCount);

                if (g_hDisplayType.IntValue == 1)
                {
                    // HintText 本身就是单行居中显示在准星下方，非常适合提示
                    PrintHintText(client, "%s", message);
                }
                else
                {
                    // Chat 模式增加了简单的绿色前缀，方便分辨
                    PrintToChat(client, "\x04[剩余备弹]->\x05%s", message);
                }
            }
        }
    }
}