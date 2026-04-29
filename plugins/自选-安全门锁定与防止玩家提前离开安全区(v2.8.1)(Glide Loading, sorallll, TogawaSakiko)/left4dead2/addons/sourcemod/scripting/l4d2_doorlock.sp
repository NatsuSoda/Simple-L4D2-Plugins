#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <left4dhooks>

#define PLUGIN_NAME				"L4D2 Door Lock"
#define PLUGIN_AUTHOR			"Glide Loading, sorallll, TogawaSakiko"
#define PLUGIN_DESCRIPTION		"Saferoom Door locked until all players loaded"
#define PLUGIN_VERSION			"2.8.1"
#define PLUGIN_URL				"http://forums.alliedmods.net/showpost.php?p=1373587&postcount=136"

#define CVAR_FLAGS				FCVAR_NOTIFY
#define SOUND_COUNTDOWN			"buttons/blip1.wav"
#define SOUND_MOVEOUT			"ui/survival_teamrec.wav"
#define SOUND_BREAK1			"physics/metal/metal_box_break1.wav"
#define SOUND_BREAK2			"physics/metal/metal_box_break2.wav"

Handle
	g_hTimer;

ConVar
	g_cAllow,
	g_cGameMode,
	g_cModes,
	g_cModesOff,
	g_cBreakTheDoor,
	g_cPrepareTime,
	g_cClientTimeOut,
	g_cGod,
	g_cInfAmmo;

bool
	g_bCvarAllow,
	g_bMapStarted,
	g_bFirstRound,
	g_bBreakTheDoor,
	g_bIsLoading[MAXPLAYERS + 1];

int
	g_iStartDoor,
	g_iCountDown,
	g_iRoundStart,
	g_iPlayerSpawn,
	g_iPrepareTime,
	g_iClientTimeOut,
	g_iTimeout[MAXPLAYERS + 1];

static const char g_sPrefixes[][] = {
    "MyGO!!!!!", "Tomori", "Anon", "Rāna", "Soyo", "Taki", "AveMujica", "Sakiko",
    "Oblivionis", "Uika", "Doloris", "Mutsumi", "Mortis", "Umiri", "Timoris", "Nyamu", "Amoris"
};

stock void GetRandomPrefix(char[] buffer, int maxlen)
{
    int index = GetRandomInt(0, sizeof(g_sPrefixes) - 1);
    Format(buffer, maxlen, "\x04[\x03%s\x04] \x05", g_sPrefixes[index]);
}

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};

public void OnPluginStart() {
	CreateConVar("l4d2_dlock_version", PLUGIN_VERSION, "插件版本", FCVAR_SPONLY|FCVAR_NOTIFY|FCVAR_REPLICATED);

	g_cAllow =			CreateConVar("l4d2_dlock_allow",		"1",	"插件开关 (0=禁用, 1=启用)", CVAR_FLAGS);
	g_cModes =			CreateConVar("l4d2_dlock_modes",		"",		"开启插件的游戏模式，用逗号分隔，例如 'coop,versus'. (空 = 所有模式)", CVAR_FLAGS);
	g_cModesOff =		CreateConVar("l4d2_dlock_modes_off",	"",		"关闭插件的游戏模式，用逗号分隔，例如 'coop,versus'. (空 = 所有模式)", CVAR_FLAGS);
	g_cBreakTheDoor =	CreateConVar("l4d2_dlock_weakdoor",		"1",	"是否在倒计时结束时破坏安全门", CVAR_FLAGS);
	g_cPrepareTime =	CreateConVar("l4d2_dlock_prepare_time",	"10",	"所有玩家加载完成后，额外等待几秒开始游戏", CVAR_FLAGS);
	g_cClientTimeOut =	CreateConVar("l4d2_dlock_timeout",		"30",	"等待玩家加载的超时时间", CVAR_FLAGS);

	g_cGod = FindConVar("god");
	g_cInfAmmo = FindConVar("sv_infinite_primary_ammo");
	g_cGameMode =	FindConVar("mp_gamemode");
	g_cGameMode.AddChangeHook(CvarChanged_Allow);
	g_cModes.AddChangeHook(CvarChanged_Allow);
	g_cModesOff.AddChangeHook(CvarChanged_Allow);
	g_cAllow.AddChangeHook(CvarChanged_Allow);

	g_cBreakTheDoor.AddChangeHook(CvarChanged);
	g_cPrepareTime.AddChangeHook(CvarChanged);
	g_cClientTimeOut.AddChangeHook(CvarChanged);
}

public void OnPluginEnd() {
	ToggleSafeRoomCheats(false);
}

public void OnConfigsExecuted() {
	IsAllowed();
}

void CvarChanged_Allow(ConVar convar, const char[] oldValue, const char[] newValue) {
	IsAllowed();
}

void CvarChanged(ConVar convar, const char[] oldValue, const char[] newValue) {
	GetCvars();
}

void GetCvars() {
	bool last = g_bBreakTheDoor;

	g_bBreakTheDoor =	g_cBreakTheDoor.BoolValue;
	g_iPrepareTime =	g_cPrepareTime.IntValue;
	g_iClientTimeOut =	g_cClientTimeOut.IntValue;

	if (last != g_bBreakTheDoor) {
		if (g_iStartDoor && EntRefToEntIndex(g_iStartDoor) != -1)
			UnhookSingleEntityOutput(g_iStartDoor, "OnOpen", OnOpen);
	}
}

void IsAllowed() {
	bool bCvarAllow = g_cAllow.BoolValue;
	bool bAllowMode = IsAllowedGameMode();
	GetCvars();

	if (g_bCvarAllow == false && bCvarAllow == true && bAllowMode == true) {
		g_bCvarAllow = true;
		HookEvents(true);
	}
	else if (g_bCvarAllow == true && (bCvarAllow == false || bAllowMode == false)) {
		g_bCvarAllow = false;
		HookEvents(false);
		ResetPlugin();
		DeleteTimer();

		if (g_iStartDoor && EntRefToEntIndex(g_iStartDoor) != -1)
			UnhookSingleEntityOutput(g_iStartDoor, "OnOpen", OnOpen);
	}
}

bool IsAllowedGameMode() {
	if (!g_cGameMode)
		return false;

	if (!g_bMapStarted)
		return false;

	char sGameModes[64], sGameMode[64];
	g_cGameMode.GetString(sGameMode, sizeof sGameMode);
	Format(sGameMode, sizeof sGameMode, ",%s,", sGameMode);

	g_cModes.GetString(sGameModes, sizeof sGameModes);
	if (sGameModes[0]) {
		Format(sGameModes, sizeof sGameModes, ",%s,", sGameModes);
		if (StrContains(sGameModes, sGameMode, false) == -1)
			return false;
	}

	g_cModesOff.GetString(sGameModes, sizeof sGameModes);
	if (sGameModes[0]) {
		Format(sGameModes, sizeof sGameModes, ",%s,", sGameModes);
		if (StrContains(sGameModes, sGameMode, false) != -1)
			return false;
	}

	return true;
}

void HookEvents(bool hook) {
	if (hook) {
		HookEvent("round_end",		Event_RoundEnd,		EventHookMode_PostNoCopy);
		HookEvent("round_start",	Event_RoundStart,	EventHookMode_PostNoCopy);
		HookEvent("player_spawn",	Event_PlayerSpawn,	EventHookMode_PostNoCopy);
		HookEvent("player_team",	Event_PlayerTeam);
	}
	else {
		UnhookEvent("round_end",	Event_RoundEnd,		EventHookMode_PostNoCopy);
		UnhookEvent("round_start",	Event_RoundStart,	EventHookMode_PostNoCopy);
		UnhookEvent("player_spawn",	Event_PlayerSpawn,	EventHookMode_PostNoCopy);
		UnhookEvent("player_team",	Event_PlayerTeam);
	}
}

public void OnClientDisconnect(int client) {
	g_iTimeout[client] = 0;
	g_bIsLoading[client] = false;
}

public void OnMapStart() {
	g_bMapStarted = true;
	g_bFirstRound = true;

	PrecacheSound(SOUND_BREAK1);
	PrecacheSound(SOUND_BREAK2);
	PrecacheSound(SOUND_MOVEOUT);
	PrecacheSound(SOUND_COUNTDOWN);
}

public void OnMapEnd() {
	ResetPlugin();
	g_bMapStarted = false;
}

void Event_RoundEnd(Event event, const char[] name, bool dontBroadcast) {
	ResetPlugin();
	g_bFirstRound = false;
}

void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
	if (g_iRoundStart == 0 && g_iPlayerSpawn == 1)
		InitPlugin();
	g_iRoundStart = 1;
}

void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
	if (g_iRoundStart == 1 && g_iPlayerSpawn == 0)
		InitPlugin();
	g_iPlayerSpawn = 1;
}

void ResetPlugin() {
	g_iCountDown = 0;
	g_iStartDoor = 0;
	g_iRoundStart = 0;
	g_iPlayerSpawn = 0;

	ToggleSafeRoomCheats(false);
	DeleteTimer();
}

void DeleteTimer() {
	delete g_hTimer;
}

void Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast) {
	if (!g_iCountDown)
		return;

	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client && IsClientInGame(client) && !IsFakeClient(client))
		ResetLoadingState(client);
}

void ResetLoadingState(int client, bool state = false) {
	g_iTimeout[client] = 0;
	g_bIsLoading[client] = state;
}

void StartSequence() {
	DeleteTimer();

	for (int i = 1; i <= MaxClients; i++)
		ResetLoadingState(i, true);

	g_iCountDown = -1;
	
	if (g_iStartDoor && EntRefToEntIndex(g_iStartDoor) != -1) {
		LockDoor();
	}

	// 开启无敌和无限子弹
	ToggleSafeRoomCheats(true);
	
	g_hTimer = CreateTimer(1.0, tmrLoading, _, TIMER_REPEAT);
}

// 落水传送
// ---------
public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if (g_hTimer != null && IsSurvivor(client))
	{
		if (GetEntProp(client, Prop_Send, "m_nWaterLevel") >= 2 && IsPlayerAlive(client))
		{
			ReturnPlayerToSaferoom(client);
		}
	}
	return Plugin_Continue;
}

// 拦截玩家离开安全区
// -------------------
public Action L4D_OnFirstSurvivorLeftSafeArea(int client) 
{
	if (g_hTimer != null) 
	{
		if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client))
		{
			ReturnPlayerToSaferoom(client);
			
			char sPrefix[64];
			GetRandomPrefix(sPrefix, sizeof(sPrefix));
			PrintToChat(client, "%s队友未加载完成前禁止离开安全区！", sPrefix);
		}
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

void ReturnPlayerToSaferoom(int client)
{
	int warp_flags = GetCommandFlags("warp_to_start_area");
	SetCommandFlags("warp_to_start_area", warp_flags & ~FCVAR_CHEAT);

	if (GetEntProp(client, Prop_Send, "m_isHangingFromLedge"))
	{
		L4D_ReviveSurvivor(client);
	}

	FakeClientCommand(client, "warp_to_start_area");
	SetCommandFlags("warp_to_start_area", warp_flags);
	
	float vVel[3] = {0.0, 0.0, 0.0};
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
}

Action tmrLoading(Handle timer) {
	if (g_iCountDown >= 0) {
		if (g_iCountDown >= g_iPrepareTime) {
			g_iCountDown = 0;

			UnLockDoor();

			// 倒计时结束后关闭无敌和无限子弹
			ToggleSafeRoomCheats(false);
			PlaySound(SOUND_MOVEOUT);
			PrintTextAll("游戏开始！");
			g_hTimer = null;
			return Plugin_Stop;
		}
		else {
			PlaySound(SOUND_COUNTDOWN);
			PrintTextAll("游戏将于 %d 秒后开始", g_iPrepareTime - g_iCountDown);
			g_iCountDown++;
		}
	}
	else
		g_iCountDown = IsFinishedLoading() ? 0 : -1;

	return Plugin_Continue;
}

void LoadingPanel() {
	int i = 1;
	int loading;
	int connected;
	int loadFailed;
	for (; i <= MaxClients; i++) {
		if (IsClientConnected(i) && !IsFakeClient(i)) {
			if (g_bIsLoading[i])
				loading++;
			else if (g_iTimeout[i] >= g_iClientTimeOut)
				loadFailed++;
			else 
				connected++;
		}
	}

	Panel panel;
	static char buffer[254];

	for (int client = 1; client <= MaxClients; client++) {
		if (IsClientInGame(client) && !IsFakeClient(client)) {
			panel = new Panel();

			FormatEx(buffer, sizeof buffer, "---------加载状态---------");
			panel.DrawText(buffer);

			if (loading) {
				FormatEx(buffer, sizeof buffer, "努力加载中～");
				panel.DrawText(buffer);

				loading = 0;
				for (i = 1; i <= MaxClients; i++) {
					if (IsClientConnected(i) && !IsFakeClient(i) && g_bIsLoading[i]) {
						loading++;
						FormatEx(buffer, sizeof buffer, "->%d. %N", loading, i);
						panel.DrawText(buffer);
					}
				}
			}

			if (connected) {
				FormatEx(buffer, sizeof buffer, "游戏中");
				panel.DrawText(buffer);

				connected = 0;
				for (i = 1; i <= MaxClients; i++) {
					if (IsClientConnected(i) && !IsFakeClient(i) && !g_bIsLoading[i] && g_iTimeout[i] < g_iClientTimeOut) {
						connected++;
						FormatEx(buffer, sizeof buffer, "->%d. %N", connected, i);
						panel.DrawText(buffer);
					}
				}
			}

			if (loadFailed) {
				FormatEx(buffer, sizeof buffer, "寄了！");
				panel.DrawText(buffer);

				loadFailed = 0;
				for (i = 1; i <= MaxClients; i++) {
					if (IsClientConnected(i) && !IsFakeClient(i) && !g_bIsLoading[i] && g_iTimeout[i] >= g_iClientTimeOut) {
						loadFailed++;
						FormatEx(buffer, sizeof buffer, "->%d. %N", loadFailed, i);
						panel.DrawText(buffer);
					}
				}
			}

			panel.Send(client, PanelHandler, 5);
			delete panel;
		}
	}
}

int PanelHandler(Menu menu, MenuAction action, int param1, int param2) {
	return 0;
}

void LockDoor() {
	if (g_iStartDoor && EntRefToEntIndex(g_iStartDoor) != -1)
		SetEntProp(g_iStartDoor, Prop_Send, "m_spawnflags", DOOR_FLAG_SILENT|DOOR_FLAG_IGNORE_USE);
}

void UnLockDoor() {
	if (g_iStartDoor && EntRefToEntIndex(g_iStartDoor) != -1)
		SetEntProp(g_iStartDoor, Prop_Send, "m_spawnflags", DOOR_FLAG_USE_CLOSES);
}

void InitPlugin() {
	g_iStartDoor = 0;
	int ent = L4D_GetCheckpointFirst();
	if (ent != -1 && GetEntProp(ent, Prop_Send, "m_bLocked") == 1) {
		g_iStartDoor = EntIndexToEntRef(ent);
		if (!g_bBreakTheDoor) {
			SetVariantString("OnOpen !self:Lock::0.0:-1");
			AcceptEntityInput(ent, "AddOutput");
		}
		else
			HookSingleEntityOutput(ent, "OnOpen", OnOpen);
	}

	StartSequence();
}

void OnOpen(const char[] output, int entity, int activator, float delay) {
	char sModel[PLATFORM_MAX_PATH];
	GetEntPropString(entity, Prop_Data, "m_ModelName", sModel, sizeof sModel);

	float vPos[3], vAng[3], vDir[3];
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", vPos);
	GetEntPropVector(entity, Prop_Send, "m_angRotation", vAng);

	SetEntProp(entity, Prop_Send, "m_CollisionGroup", 1);
	SetEntProp(entity, Prop_Data, "m_CollisionGroup", 1);

	vPos[2] += 10000.0;
	TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
	vPos[2] -= 10000.0;

	SetEntityRenderMode(entity, RENDER_TRANSALPHA);
	SetEntityRenderColor(entity, 0, 0, 0, 0);

	UnhookSingleEntityOutput(entity, "OnOpen", OnOpen);

	int ent = CreateEntityByName("prop_physics");
	DispatchKeyValue(ent, "spawnflags", "4"); 
	DispatchKeyValue(ent, "model", sModel);
	DispatchSpawn(ent);

	TeleportEntity(ent, vPos, vAng, NULL_VECTOR);

	SetVariantString("unlock");
	AcceptEntityInput(entity, "SetAnimation");

	SetEntProp(entity, Prop_Send, "m_eDoorState", DOOR_STATE_CLOSING_IN_PROGRESS);
	SetEntProp(entity, Prop_Send, "m_spawnflags", DOOR_FLAG_SILENT|DOOR_FLAG_IGNORE_USE);

	entity = EntRefToEntIndex(entity);
	for (int att; att < 2048; att++) {
		if (IsValidEdict(att)) {
			if (HasEntProp(att, Prop_Send, "moveparent") && GetEntPropEnt(att, Prop_Send, "moveparent") == entity) {
				SetVariantString("!activator");
				AcceptEntityInput(att, "SetParent", ent);
			}
		}
	}

	float dist = strcmp(sModel, "models/props_doors/checkpoint_door_-01.mdl") == 0 ? -10.0 : 10.0;

	GetAngleVectors(vAng, vDir, NULL_VECTOR, NULL_VECTOR);
	vPos[0] += (vDir[0] * dist);
	vPos[1] += (vDir[1] * dist);
	vAng[0] = dist;
	vDir[0] = 0.0;
	vDir[1] = vAng[1] < 270.0 ? 10.0 : -10.0 * dist;
	vDir[2] = 0.0;

	TeleportEntity(ent, vPos, vAng, vDir);

	EmitSoundToAll(GetRandomInt(0, 1) ? SOUND_BREAK1 : SOUND_BREAK2, ent);
}

bool IsFinishedLoading() {
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientConnected(i)) {
			if (!IsClientInGame(i) && !IsFakeClient(i)) {
				g_iTimeout[i]++;
				if (g_bIsLoading[i] && g_iTimeout[i] == 1)
					g_bIsLoading[i] = true;

				if (g_iTimeout[i] == g_iClientTimeOut)
					g_bIsLoading[i] = false;
			}
			else
				g_bIsLoading[i] = false;
		}
		else
			g_bIsLoading[i] = false;
	}
	if (g_bFirstRound)
		LoadingPanel();

	return !IsAnyClientLoading();
}

bool IsAnyClientLoading() {
	for (int i = 1; i <= MaxClients; i++) {
		if (g_bIsLoading[i])
			return true;
	}
	return false;
}

void PrintTextAll(const char[] format, any ...) {
	char buffer[254];
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i) && !IsFakeClient(i)) {
			SetGlobalTransTarget(i);
			VFormat(buffer, sizeof buffer, format, 2);
			PrintHintText(i, "%s", buffer);
		}
	}
}

void PlaySound(const char[] sample) {
	EmitSoundToAll(sample, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
}

void ToggleSafeRoomCheats(bool enable) {
	if (g_cGod != null) {
		int flags = g_cGod.Flags;
		g_cGod.Flags = flags & ~(FCVAR_CHEAT|FCVAR_NOTIFY);
		g_cGod.SetInt(enable ? 1 : 0);
		g_cGod.Flags = flags;
	}
	
	if (g_cInfAmmo != null) {
		int flags = g_cInfAmmo.Flags;
		g_cInfAmmo.Flags = flags & ~(FCVAR_CHEAT|FCVAR_NOTIFY);
		g_cInfAmmo.SetInt(enable ? 1 : 0);
		g_cInfAmmo.Flags = flags;
	}
}

// 免疫特感控制
// --------------
bool IsSurvivor(int client) {
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2);
}
public Action L4D_OnGrabWithTongue(int victim, int attacker) {
	if (g_hTimer != null && IsSurvivor(victim))
		return Plugin_Handled;
	return Plugin_Continue;
}
public Action L4D_OnPouncedOnSurvivor(int victim, int attacker) {
	if (g_hTimer != null && IsSurvivor(victim))
		return Plugin_Handled;
	return Plugin_Continue;
}
public Action L4D2_OnJockeyRide(int victim, int attacker) {
	if (g_hTimer != null && IsSurvivor(victim))
		return Plugin_Handled;
	return Plugin_Continue;
}
public Action L4D2_OnStartCarryingVictim(int victim, int attacker) {
	if (g_hTimer != null && IsSurvivor(victim))
		return Plugin_Handled;
	return Plugin_Continue;
}
public Action L4D2_OnPummelVictim(int attacker, int victim) {
	if (g_hTimer != null && IsSurvivor(victim)) {
		DataPack pack = new DataPack();
		pack.WriteCell(GetClientUserId(victim));
		pack.WriteCell(GetClientUserId(attacker));
		RequestFrame(OnPummelTeleport, pack);
		
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
void OnPummelTeleport(DataPack pack) {
	pack.Reset();
	pack.ReadCell();
	int attacker = GetClientOfUserId(pack.ReadCell());
	delete pack;

	if (attacker > 0 && IsClientInGame(attacker)) {
		float vPos[3];
		GetClientAbsOrigin(attacker, vPos);
		vPos[2] += 5.0;
		TeleportEntity(attacker, vPos, NULL_VECTOR, NULL_VECTOR);
	}
}