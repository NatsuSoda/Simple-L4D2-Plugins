#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

// 定义导演所处的四个核心阶段
enum DirectorPhase {
    PHASE_RELAX = 0,
    PHASE_BUILD_UP,
    PHASE_SUSTAIN_PEAK,
    PHASE_PEAK_FADE
};

DirectorPhase g_CurrentPhase = PHASE_RELAX;
int g_iPhaseTimer = 0;
Handle g_hHudSync;

// 放松阈值：可根据需要调整（默认为0.5，通常在这个值以下导演会切回Relax）
float g_fRelaxThreshold = 0.5; 

public Plugin myinfo = {
    name = "Director Phase Visualizer",
    author = "十裡冬",
    description = "可视化 L4D2 导演系统当前阶段",
    version = "1.0",
    url = "NULL"
};

public void OnPluginStart() {
    // 创建 HUD 同步器，防止文本闪烁重叠
    g_hHudSync = CreateHudSynchronizer();
    // 创建一个每秒执行一次的计时器，用于刷新逻辑和UI
    CreateTimer(1.0, Timer_UpdateDirector, _, TIMER_REPEAT);
}

public void OnMapStart() {
    // 进图后初始化为 Relax 阶段
    g_CurrentPhase = PHASE_RELAX;
    // 进图初始 Relax 阶段时间 (根据你的描述设定为随机 0-20秒，这里取 15)
    g_iPhaseTimer = 15; 
}

public Action Timer_UpdateDirector(Handle timer) {
    float maxIntensity = 0.0;

    // 1. 获取当前所有生还者中的最大强度 (Intensity)
    for (int i = 1; i <= MaxClients; i++) {
        if (IsClientInGame(i) && GetClientTeam(i) == 2 && IsPlayerAlive(i)) {
            float intensity = 0.0;
            
            // 读取生还者当前的压力强度
            if (HasEntProp(i, Prop_Send, "m_intensity")) {
                intensity = GetEntPropFloat(i, Prop_Send, "m_intensity");
            }
            
            // 绝境模式特判：倒地后强度立即达到最大值 1.0
            if (GetEntProp(i, Prop_Send, "m_isIncapacitated", 1) == 1) {
                intensity = 1.0;
            }

            if (intensity > maxIntensity) {
                maxIntensity = intensity;
            }
        }
    }

    // 2. 根据你提供的逻辑推进导演状态机
    switch (g_CurrentPhase) {
        case PHASE_RELAX: {
            g_iPhaseTimer--;
            if (g_iPhaseTimer <= 0) {
                // 停刷结束，进入 Build Up 阶段开始刷怪
                g_CurrentPhase = PHASE_BUILD_UP;
                g_iPhaseTimer = 0; 
            }
        }
        case PHASE_BUILD_UP: {
            g_iPhaseTimer++; // 此时计时器用作记录 Build Up 的持续时间
            // 阈值判定：强度达到 0.9，进入顶峰维持
            if (maxIntensity >= 0.9) {
                g_CurrentPhase = PHASE_SUSTAIN_PEAK;
                g_iPhaseTimer = 4; // Sustain Peak 时间 3-5 秒，这里取 4 秒
            }
        }
        case PHASE_SUSTAIN_PEAK: {
            g_iPhaseTimer--;
            if (g_iPhaseTimer <= 0) {
                // 维持期结束，判断是否满强度
                if (maxIntensity >= 1.0) {
                    g_CurrentPhase = PHASE_PEAK_FADE;
                    g_iPhaseTimer = 0;
                } else {
                    // 未达到 1.0，直接跳过 Peak Fade 进入 Relax
                    g_CurrentPhase = PHASE_RELAX;
                    g_iPhaseTimer = GetRandomInt(30, 45); // Relax 持续 30-45 秒
                }
            }
        }
        case PHASE_PEAK_FADE: {
            g_iPhaseTimer++; // 记录卡在 Peak Fade 的时间 (有人倒地且未推进时)
            // 放松阈值判定：强度降至阈值以下后，才允许进入 Relax
            if (maxIntensity < g_fRelaxThreshold) {
                g_CurrentPhase = PHASE_RELAX;
                g_iPhaseTimer = GetRandomInt(30, 45);
            }
        }
    }

    // 3. 将结果绘制到屏幕上
    DrawDirectorHUD(maxIntensity);
    return Plugin_Continue;
}

void DrawDirectorHUD(float maxIntensity) {
    char phaseName[32];
    char timeText[32];
    int r = 255, g = 255, b = 255;

    // 根据不同阶段设置颜色和显示文本
    switch (g_CurrentPhase) {
        case PHASE_RELAX: {
            strcopy(phaseName, sizeof(phaseName), "Relax (停刷)");
            Format(timeText, sizeof(timeText), "倒计时: %d秒", g_iPhaseTimer);
            r = 255; g = 255; b = 255; // 绿色，表示安全
        }
        case PHASE_BUILD_UP: {
            strcopy(phaseName, sizeof(phaseName), "Build Up (刷怪)");
            Format(timeText, sizeof(timeText), "已持续: %d秒", g_iPhaseTimer);
            r = 255; g = 255; b = 255; // 黄色，表示交战积累
        }
        case PHASE_SUSTAIN_PEAK: {
            strcopy(phaseName, sizeof(phaseName), "Sustain Peak (高压)");
            Format(timeText, sizeof(timeText), "判定倒计时: %d秒", g_iPhaseTimer);
            r = 255; g = 255; b = 255; // 橙色，接近峰值
        }
        case PHASE_PEAK_FADE: {
            strcopy(phaseName, sizeof(phaseName), "Peak Fade (降温)");
            Format(timeText, sizeof(timeText), "等待强度下降...(%d秒)", g_iPhaseTimer);
            r = 255; g = 255; b = 255; // 红色，极端危险或有人倒地
        }
    }

    // 设置 HUD 参数：位于屏幕正上方（x: -1.0 表示水平居中，y: 0.05 表示贴近屏幕顶部）
    SetHudTextParams(-1.0, 0.05, 1.1, r, g, b, 255, 0, 0.0, 0.0, 0.0);

    // 对所有存活玩家显示 HUD
    for (int i = 1; i <= MaxClients; i++) {
        if (IsClientInGame(i) && !IsFakeClient(i)) {
            ShowSyncHudText(i, g_hHudSync, "【导演监控】阶段: %s | %s\n最高强度: %.2f (满值 1.0)", phaseName, timeText, maxIntensity);
        }
    }
}