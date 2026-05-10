#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0"

// 存储玩家开关状态
bool g_bAutoLaser[MAXPLAYERS + 1] = {false, ...};

public Plugin myinfo = 
{
    name = "L4D2个人红点开启or关闭",
    author = "winteroften",
    description = "输入/dot开关个人武器激光红点",
    version = PLUGIN_VERSION,
    url = "NULL"
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_dot", Command_Dot, "切换红点辅助开启或关闭");
    
    // 对在线玩家挂钩
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i))
        {
            SDKHook(i, SDKHook_WeaponEquipPost, OnWeaponEquipPost);
        }
    }
}

// 当玩家进入服务器时，挂钩
public void OnClientPutInServer(int client)
{
    g_bAutoLaser[client] = false; // 默认关
    SDKHook(client, SDKHook_WeaponEquipPost, OnWeaponEquipPost);
}

// 指令处理
public Action Command_Dot(int client, int args)
{
    if (client == 0 || !IsClientInGame(client))
        return Plugin_Handled;

    g_bAutoLaser[client] = !g_bAutoLaser[client];
    
    if (g_bAutoLaser[client])
    {
        PrintToChat(client, "\x04[提示]\x03 自动红点已【启用】。");
        ApplyLaserSight(client); // 上红点
    }
    else
    {
        PrintToChat(client, "\x04[提示]\x03 自动红点已【禁用】。");
        RemoveLaserSight(client); // 移除红点
    }

    return Plugin_Handled;
}

// 当玩家装备武器后处理
public void OnWeaponEquipPost(int client, int weapon)
{
    if (g_bAutoLaser[client] && IsValidEntity(weapon))
    {
        // 延迟处理
        RequestFrame(Frame_ApplyLaser, GetClientUserId(client));
    }
}

public void Frame_ApplyLaser(any userid)
{
    int client = GetClientOfUserId(userid);
    if (client != 0 && IsClientInGame(client) && IsPlayerAlive(client))
    {
        ApplyLaserSight(client);
    }
}

// 给当前主武器上红点
void ApplyLaserSight(int client)
{
    int weapon = GetPlayerWeaponSlot(client, 0); // 0 号位是主武器
    if (IsValidEntity(weapon))
    {
        int upgrade = GetEntProp(weapon, Prop_Send, "m_upgradeBitVec");
        upgrade |= (1 << 2); // 4 是红点位值
        SetEntProp(weapon, Prop_Send, "m_upgradeBitVec", upgrade);
    }
}

// 移除红点
void RemoveLaserSight(int client)
{
    int weapon = GetPlayerWeaponSlot(client, 0);
    if (IsValidEntity(weapon))
    {
        int upgrade = GetEntProp(weapon, Prop_Send, "m_upgradeBitVec");
        upgrade &= ~(1 << 2); // 移除红点位
        SetEntProp(weapon, Prop_Send, "m_upgradeBitVec", upgrade);
    }
}