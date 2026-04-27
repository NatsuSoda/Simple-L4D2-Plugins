#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define MAX_HINT_SLOTS 5
bool g_bSlotBusy[MAXPLAYERS + 1][MAX_HINT_SLOTS];

public Plugin myinfo = 
{
    name = "特感击杀气泡-爆头判定修复版",
    author = "Gemini",
    description = "修复爆头显示不红的问题，强化事件检测",
    version = "2.1",
    url = "NULL"
};

public void OnPluginStart()
{
    // 使用更高优先级的 Hook 模式
    HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
}

public void OnClientConnected(int client)
{
    for (int i = 0; i < MAX_HINT_SLOTS; i++) g_bSlotBusy[client][i] = false;
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    // 获取受害者信息
    int victim = GetClientOfUserId(event.GetInt("userid"));
    // 获取攻击者信息
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    
    // --- 核心修复：直接读取事件中的 headshot 整数值 ---
    // 有些版本 SM 读取 Bool 可能会有偏差，读取 Int 更稳妥 (1为爆头, 0为普通)
    bool bIsHeadshot = (event.GetInt("headshot") != 0);

    // 基础过滤
    if (attacker <= 0 || attacker > MaxClients || !IsClientInGame(attacker) || GetClientTeam(attacker) != 2)
        return;

    if (victim <= 0 || victim > MaxClients || !IsClientInGame(victim) || GetClientTeam(victim) != 3)
        return;

    // --- 调试代码：如果你发现还是不红，可以取消下面这一行的注释，在控制台查看输出 ---
    // PrintToConsole(attacker, "[调试] 击杀特感 - 爆头判定状态: %s", bIsHeadshot ? "是" : "否");

    // 寻找空闲槽位
    int slot = -1;
    for (int i = 0; i < MAX_HINT_SLOTS; i++)
    {
        if (!g_bSlotBusy[attacker][i])
        {
            slot = i;
            break;
        }
    }
    if (slot == -1) slot = MAX_HINT_SLOTS - 1;

    char szMessage[64];
    char szColor[16];

    // 逻辑判定：确保爆头时文字变为红色
    if (bIsHeadshot)
    {
        Format(szMessage, sizeof(szMessage), "爆头");
        Format(szColor, sizeof(szColor), "255 0 0");     // 纯红色
    }
    else
    {
        Format(szMessage, sizeof(szMessage), "击杀");
        Format(szColor, sizeof(szColor), "255 255 255"); // 纯白色
    }

    CreateFinalHint(attacker, szMessage, szColor, slot);
}

void CreateFinalHint(int client, const char[] text, const char[] color, int slot)
{
    char targetName[32];
    Format(targetName, sizeof(targetName), "hinttarget%d", client);
    DispatchKeyValue(client, "targetname", targetName);

    int hint = CreateEntityByName("env_instructor_hint");
    if (hint == -1) return;

    g_bSlotBusy[client][slot] = true;

    float fOffset = slot * 28.0; 
    char szOffset[16];
    FloatToString(fOffset, szOffset, sizeof(szOffset));

    DispatchKeyValue(hint, "hint_static", "1");
    DispatchKeyValue(hint, "hint_caption", text);
    DispatchKeyValue(hint, "hint_color", color);         // 设置颜色
    DispatchKeyValue(hint, "hint_timeout", "5.0");
    DispatchKeyValue(hint, "hint_icon_onscreen", "icon_skull"); 
    DispatchKeyValue(hint, "hint_icon_offset", szOffset);
    
    char hintName[32];
    Format(hintName, sizeof(hintName), "hint_k_%d_%d", client, slot);
    DispatchKeyValue(hint, "hint_name", hintName);
    
    DispatchKeyValue(hint, "hint_target", targetName);
    DispatchKeyValue(hint, "hint_flags", "2");
    DispatchKeyValue(hint, "hint_instance_type", "2");

    DispatchSpawn(hint);
    AcceptEntityInput(hint, "ShowHint", client);
    
    DataPack pack;
    CreateDataTimer(1.6, Timer_Cleanup, pack);
    pack.WriteCell(client);
    pack.WriteCell(slot);
    pack.WriteCell(EntIndexToEntRef(hint));
}

public Action Timer_Cleanup(Handle timer, DataPack pack)
{
    pack.Reset();
    int client = pack.ReadCell();
    int slot = pack.ReadCell();
    int ref = pack.ReadCell();

    if (client > 0 && client <= MaxClients) g_bSlotBusy[client][slot] = false;

    int entity = EntRefToEntIndex(ref);
    if (entity != INVALID_ENT_REFERENCE && IsValidEntity(entity))
    {
        AcceptEntityInput(entity, "Kill");
    }
    return Plugin_Stop;
}