#include <sourcemod>
#include <cstrike>
#include <clientprefs>
#include "include/retakes.inc"
#include "retakes/generic.sp"

#pragma semicolon 1
#pragma newdecls required

#define MENU_TIME_LENGTH 15

int nade_price_for_hegrenade = 300;
int nade_price_for_flashbang = 200;
int nade_price_for_smokegrenade = 500;
int nade_price_for_molotov = 400;
int nade_price_for_incgrenade = 600;

int gun_price_for_p250 = 300;
int gun_price_for_cz = 500;
int gun_price_for_fiveseven = 500;
int gun_price_for_tec9 = 500;
int gun_price_for_deagle = 700;

int kit_price = 400;
int kevlar_price = 650;

int  g_Gunchoice[MAXPLAYERS+1];
bool g_SilencedM4[MAXPLAYERS+1];
bool g_AwpChoice[MAXPLAYERS+1];
Handle g_hGUNChoiceCookie = INVALID_HANDLE;
Handle g_hM4ChoiceCookie = INVALID_HANDLE;
Handle g_hAwpChoiceCookie = INVALID_HANDLE;

//new convars
Handle g_h_sm_retakes_weapon_mimic_competitive_pistol_rounds = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_primary_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_hegrenade_ct_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_hegrenade_t_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_flashbang_ct_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_flashbang_t_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_smokegrenade_ct_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_smokegrenade_t_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_molotov_ct_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_molotov_t_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_helmet_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_kevlar_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_awp_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_gunrounds  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_deagle_enabled  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_cz_enabled  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_p250_enabled  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_tec9_fiveseven_enabled = INVALID_HANDLE;


public Plugin myinfo = {
    name = "CS:GO Retakes: standard weapon allocator",
    author = "BatMen",
    description = "Defines a simple weapon allocation policy and lets players set weapon preferences",
    version = PLUGIN_VERSION,
    url = "https://github.com/BatMen/csgo-retakes"
};

public void OnPluginStart() {
    g_hGUNChoiceCookie = RegClientCookie("retakes_gunchoice", "", CookieAccess_Private);
    g_hM4ChoiceCookie  = RegClientCookie("retakes_m4choice", "", CookieAccess_Private);
    g_hAwpChoiceCookie = RegClientCookie("retakes_awpchoice", "", CookieAccess_Private);

    //new convars
    g_h_sm_retakes_weapon_mimic_competitive_pistol_rounds = CreateConVar("sm_retakes_weapon_mimic_competitive_pistol_rounds", "1", "Whether pistol rounds are like 800$ rounds");
    g_h_sm_retakes_weapon_primary_enabled = CreateConVar("sm_retakes_weapon_primary_enabled", "1", "Whether the players can have primary weapon");
    g_h_sm_retakes_weapon_nades_enabled = CreateConVar("sm_retakes_weapon_nades_enabled", "1", "Whether the players can have nades");
    g_h_sm_retakes_weapon_nades_hegrenade_ct_enabled = CreateConVar("sm_retakes_weapon_nades_hegrenade_ct_enabled", "1", "Whether the CT can have hegrenade");
    g_h_sm_retakes_weapon_nades_hegrenade_t_enabled = CreateConVar("sm_retakes_weapon_nades_hegrenade_t_enabled", "1", "Whether the T can have hegrenade");
    g_h_sm_retakes_weapon_nades_flashbang_ct_enabled = CreateConVar("sm_retakes_weapon_nades_flashbang_ct_enabled", "1", "Whether the CT can have flashbang");
    g_h_sm_retakes_weapon_nades_flashbang_t_enabled = CreateConVar("sm_retakes_weapon_nades_flashbang_t_enabled", "1", "Whether the T can have flashbang");
    g_h_sm_retakes_weapon_nades_smokegrenade_ct_enabled = CreateConVar("sm_retakes_weapon_nades_smokegrenade_ct_enabled", "1", "Whether the CT can have smokegrenade");
    g_h_sm_retakes_weapon_nades_smokegrenade_t_enabled = CreateConVar("sm_retakes_weapon_nades_smokegrenade_t_enabled", "1", "Whether the T can have smokegrenade");
    g_h_sm_retakes_weapon_nades_molotov_ct_enabled = CreateConVar("sm_retakes_weapon_nades_molotov_ct_enabled", "1", "Whether the CT can have molotov");
    g_h_sm_retakes_weapon_nades_molotov_t_enabled = CreateConVar("sm_retakes_weapon_nades_molotov_t_enabled", "1", "Whether the T can have molotov");
    g_h_sm_retakes_weapon_helmet_enabled = CreateConVar("sm_retakes_weapon_helmet_enabled", "1", "Whether the players have helmet");
    g_h_sm_retakes_weapon_kevlar_enabled = CreateConVar("sm_retakes_weapon_kevlar_enabled", "1", "Whether the players have kevlar");
    g_h_sm_retakes_weapon_awp_enabled = CreateConVar("sm_retakes_weapon_awp_enabled", "1", "Whether the players can have AWP");
    g_h_sm_retakes_weapon_gunrounds = CreateConVar("sm_retakes_weapon_gunrounds", "5", "The number of gun rounds (0 = no gun round)");
    g_h_sm_retakes_weapon_deagle_enabled = CreateConVar("sm_retakes_weapon_deagle_enabled", "1", "Whether the players can choose deagle");
    g_h_sm_retakes_weapon_cz_enabled = CreateConVar("sm_retakes_weapon_cz_enabled", "1", "Whether the playres can choose CZ");
    g_h_sm_retakes_weapon_p250_enabled = CreateConVar("sm_retakes_weapon_p250_enabled", "1", "Whether the players can choose P250");
    g_h_sm_retakes_weapon_tec9_fiveseven_enabled = CreateConVar("sm_retakes_weapon_tec9_fiveseven_enabled", "1", "Whether the players can choose Tec9/Five seven");

}

public void OnClientConnected(int client) {
    g_Gunchoice[client] = 1;
    g_SilencedM4[client] = false;
    g_AwpChoice[client] = false;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] args) {
    char gunsChatCommands[][] = { "/gun", "/guns", "gun", "guns", ".gun", ".guns", ".setup", "!gun", "!guns", "gnus" };
    for (int i = 0; i < sizeof(gunsChatCommands); i++) {
        if (strcmp(args[0], gunsChatCommands[i], false) == 0) {
            if (GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) != 1 && 
                GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) != 1 &&
                GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) != 1 && 
                GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) != 1)
                GiveRifleMenu(client);
            else
                GiveGunMenu(client);
            break;
        }
    }

    return Plugin_Continue;
}

public void Retakes_OnWeaponsAllocated(ArrayList tPlayers, ArrayList ctPlayers, Bombsite bombsite) {
    RifleAllocator(tPlayers, ctPlayers, bombsite);
}

/**
 * Updates client weapon settings according to their cookies.
 */
public int OnClientCookiesCached(int client) {
    if (IsFakeClient(client))
        return;

    g_Gunchoice[client]  = GetCookieInt (client, g_hGUNChoiceCookie);
    g_SilencedM4[client] = GetCookieBool(client, g_hM4ChoiceCookie);
    g_AwpChoice[client]  = GetCookieBool(client, g_hAwpChoiceCookie);
}

static void SetNades(char nades[NADE_STRING_LENGTH], bool terrorist, bool competitivePistolRound, int dollars_for_mimic_competitive_pistol_rounds) {
    nades = "";
    if (GetConVarInt(g_h_sm_retakes_weapon_nades_enabled) == 1)
    {

        bool hegrenade_allow = terrorist ? (GetConVarInt(g_h_sm_retakes_weapon_nades_hegrenade_t_enabled) == 1) : (GetConVarInt(g_h_sm_retakes_weapon_nades_hegrenade_ct_enabled) == 1);
        bool flashbang_allow = terrorist ? (GetConVarInt(g_h_sm_retakes_weapon_nades_flashbang_t_enabled) == 1) : (GetConVarInt(g_h_sm_retakes_weapon_nades_flashbang_ct_enabled) == 1);
        bool smokegrenade_allow = terrorist ? (GetConVarInt(g_h_sm_retakes_weapon_nades_smokegrenade_t_enabled) == 1) : (GetConVarInt(g_h_sm_retakes_weapon_nades_smokegrenade_ct_enabled) == 1);
        bool molotov_allow = terrorist ? (GetConVarInt(g_h_sm_retakes_weapon_nades_molotov_t_enabled) == 1) : (GetConVarInt(g_h_sm_retakes_weapon_nades_molotov_ct_enabled) == 1);

        int he_number = 0;
        int smoke_number = 0;
        int flashbang_number = 0;
        int molotov_number = 0;

        ConVar cvar_maxgrenades = FindConVar("ammo_grenade_limit_total");
        int maxgrenades = cvar_maxgrenades.GetInt();
        
        ConVar cvar_maxflashbang = FindConVar("ammo_grenade_limit_flashbang");
        int maxflashbang = cvar_maxflashbang.GetInt();

        int rand;
        if (competitivePistolRound)
        {
            int indice = 0;
            // be sure to spend all the money on pistol rounds
            for(int i=0; i < 10; i++)
            {
                rand = GetRandomInt(1, 4);

                // no money for molotov
                if ( rand == 4 && (
                     (terrorist && dollars_for_mimic_competitive_pistol_rounds < nade_price_for_molotov) ||
                     (!terrorist && dollars_for_mimic_competitive_pistol_rounds < nade_price_for_incgrenade) ) )
                     rand = GetRandomInt(1, 3);
                // no money for smoke or hegrenade
                if (rand != 3 && dollars_for_mimic_competitive_pistol_rounds < nade_price_for_hegrenade)
                    rand = 3;
                // no money for flashbang
                if (dollars_for_mimic_competitive_pistol_rounds < nade_price_for_flashbang)
                    break;

                if (maxgrenades <= indice)
                    break;

                switch(rand) {
                    case 1: 
                        if (hegrenade_allow && he_number == 0)
                        {
                            nades[indice] = 'h';
                            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_hegrenade;
                            indice++;
                            he_number++;
                        }
                    case 2: 
                        if (smokegrenade_allow && smoke_number == 0)
                        {
                            nades[indice] = 's';
                            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_smokegrenade;
                            indice++;
                            smoke_number++;
                        }
                    case 3: 
                        if (flashbang_allow && flashbang_number < maxflashbang)
                        {
                            nades[indice] = 'f';
                            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_flashbang;
                            indice++;
                            flashbang_number++;
                        }
                    case 4: 
                        if (molotov_allow && molotov_number == 0)
                        {
                            nades[indice] = terrorist ? 'm' : 'i';
                            if (terrorist)
                                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_molotov;
                            else
                                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_incgrenade;
                            indice++;
                            molotov_number++;
                        }
                }

            }
        }
        else
        {
            // we made 2 turns to have more nades in the round with random type (1 nade max per player)
            for(int i=0; i < 2; i++)
            {
                rand = GetRandomInt(0, 4);
                switch(rand) {
                    case 1: 
                        if (hegrenade_allow)
                        {
                            nades = "h";
                            i = 99;
                        }
                    case 2: 
                        if (flashbang_allow)
                        {
                            nades = "f";
                            i = 99;
                        }
                    case 3: 
                        if (smokegrenade_allow)
                        {
                            nades = "s";
                            i = 99;
                        }
                    case 4: 
                        if (molotov_allow)
                        {
                            nades = terrorist ? "m" : "i";
                            i = 99;
                        }
                }
            }
        }
    }
}

public void RifleAllocator(ArrayList tPlayers, ArrayList ctPlayers, Bombsite bombsite) {
    int tCount = GetArraySize(tPlayers);
    int ctCount = GetArraySize(ctPlayers);

    bool isPistolRound = GetConVarInt(g_h_sm_retakes_weapon_primary_enabled) == 0 || Retakes_GetRetakeRoundsPlayed() < GetConVarInt(g_h_sm_retakes_weapon_gunrounds);
    bool mimicCompetitivePistolRounds = GetConVarInt(g_h_sm_retakes_weapon_mimic_competitive_pistol_rounds) == 1;

    char primary[WEAPON_STRING_LENGTH];
    char secondary[WEAPON_STRING_LENGTH];
    char nades[NADE_STRING_LENGTH];

    int health = 100;
    int kevlar = 100;
    bool helmet = true;
    bool kit = true;

    int odds = 0;

    bool giveTAwp = true;
    bool giveCTAwp = true;
    if (GetConVarInt(g_h_sm_retakes_weapon_awp_enabled) != 1)
    {
        giveTAwp = false;
        giveCTAwp = false;
    }
    int dollars_for_mimic_competitive_pistol_rounds = 800;

    for (int i = 0; i < tCount; i++) {
        int client = GetArrayCell(tPlayers, i);

        dollars_for_mimic_competitive_pistol_rounds = 800;

        primary = "";
        if (!isPistolRound)
        {
            int randGiveAwp = GetRandomInt(0, 1);

            if (giveTAwp && g_AwpChoice[client] && randGiveAwp == 1) {
                primary = "weapon_awp";
                giveTAwp = false;
            } else {
                primary = "weapon_ak47";
            }
        }

        if (g_Gunchoice[client] == 2 && GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
        {
            secondary = "weapon_p250";
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_p250;
        }
        else if (g_Gunchoice[client] == 3 && GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
        {
            secondary = "weapon_tec9";
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_tec9;
        }
        else if (g_Gunchoice[client] == 4 && GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
        {
            secondary = "weapon_cz75a";
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_cz;
        }
        else if (g_Gunchoice[client] == 5 && GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
        {
            secondary = "weapon_deagle";
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_deagle;
        }
        else
        {
            secondary = "weapon_glock";
        }

        health = 100;
        kevlar = 100;
        {
            if (GetConVarInt(g_h_sm_retakes_weapon_kevlar_enabled) != 1 && GetConVarInt(g_h_sm_retakes_weapon_helmet_enabled) != 1)
                kevlar = 0;
            if (mimicCompetitivePistolRounds && isPistolRound)
            {
                kevlar = 0;
                if (dollars_for_mimic_competitive_pistol_rounds >= kevlar_price)
                {
                    odds = GetRandomInt(0,2);
                    // 66% to have kevlar if money
                    if (odds < 2)
                    {
                        kevlar = 100;
                        dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - kevlar_price;
                    }
                }
            }
        }

        helmet = true;
        {
            if (GetConVarInt(g_h_sm_retakes_weapon_helmet_enabled) != 1 || (isPistolRound && mimicCompetitivePistolRounds))
                helmet = false;
        }

        kit = false;
        
        SetNades(nades, true, mimicCompetitivePistolRounds && isPistolRound, dollars_for_mimic_competitive_pistol_rounds);

        Retakes_SetPlayerInfo(client, primary, secondary, nades, health, kevlar, helmet, kit);
    }
    
    for (int i = 0; i < ctCount; i++) {
        int client = GetArrayCell(ctPlayers, i);
        
        dollars_for_mimic_competitive_pistol_rounds = 800;

        primary = "";
        if (!isPistolRound)
        {
            int randGiveAwp = GetRandomInt(0, 1);

            if (giveCTAwp && g_AwpChoice[client] && randGiveAwp == 1) {
                primary = "weapon_awp";
                giveCTAwp = false;
            } else if (g_SilencedM4[client]) {
                primary = "weapon_m4a1_silencer";
            } else {
                primary = "weapon_m4a1";
            }
        }

        if (g_Gunchoice[client] == 2 && GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
        {
            secondary = "weapon_p250";
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_p250;
        }
        else if (g_Gunchoice[client] == 3 && GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
        {
            secondary = "weapon_fiveseven";
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_fiveseven;
        }
        else if (g_Gunchoice[client] == 4 && GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
        {
            secondary = "weapon_cz75a";
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_cz;
        }
        else if (g_Gunchoice[client] == 5 && GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
        {
            secondary = "weapon_deagle";
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_deagle;
        }
        else
        {
            secondary = "weapon_hkp2000";
        }

        health = 100;
        kevlar = 100;
        {
            if (GetConVarInt(g_h_sm_retakes_weapon_kevlar_enabled) != 1 && GetConVarInt(g_h_sm_retakes_weapon_helmet_enabled) != 1)
                kevlar = 0;
            if (mimicCompetitivePistolRounds && isPistolRound)
            {
                kevlar = 0;
                if (dollars_for_mimic_competitive_pistol_rounds >= kevlar_price)
                {
                    odds = GetRandomInt(0,2);
                    // 66% to have kevlar if money before kit and nades
                    if (odds < 2)
                    {
                        kevlar = 100;
                        dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - kevlar_price;
                    }
                }
            }
        }

        helmet = true;
        {
            if (GetConVarInt(g_h_sm_retakes_weapon_helmet_enabled) != 1 || (isPistolRound && mimicCompetitivePistolRounds))
                helmet = false;
        }

        kit = false;
        if(dollars_for_mimic_competitive_pistol_rounds >= kit_price && isPistolRound && mimicCompetitivePistolRounds)
        {
            odds = GetRandomInt(0,2);
            // 66% to get kit if money before nades
            if (odds < 2)
            {
                kit = true;
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - kit_price;
            }
        }

	if (!isPistolRound || (isPistolRound && !mimicCompetitivePistolRounds))
	    kit = true;

        SetNades(nades, false, mimicCompetitivePistolRounds && isPistolRound, dollars_for_mimic_competitive_pistol_rounds);

        Retakes_SetPlayerInfo(client, primary, secondary, nades, health, kevlar, helmet, kit);
    }
}

public void GiveGunMenu(int client) {
    Handle menu = CreateMenu(MenuHandler_GUN);
    SetMenuTitle(menu, "Select a gun :");
    AddMenuInt(menu, 1, "Glock/P2000/Usp)");
    if (GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
        AddMenuInt(menu, 2, "P250");
    if (GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
        AddMenuInt(menu, 3, "Fiveseven/Tec9");
    if (GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
        AddMenuInt(menu, 4, "CZ");
    if (GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
        AddMenuInt(menu, 5, "Deagle");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public int MenuHandler_GUN(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        int gunchoice = GetMenuInt(menu, param2);
        g_Gunchoice[client] = gunchoice;
        SetCookieInt(client, g_hGUNChoiceCookie, gunchoice);
        GiveRifleMenu(client);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public void GiveRifleMenu(int client) {
    Handle menu = CreateMenu(MenuHandler_M4);
    SetMenuTitle(menu, "Select a CT rifle:");
    AddMenuBool(menu, false, "M4A4");
    AddMenuBool(menu, true, "M4A1-S");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public int MenuHandler_M4(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        bool useSilenced = GetMenuBool(menu, param2);
        g_SilencedM4[client] = useSilenced;
        SetCookieBool(client, g_hM4ChoiceCookie, useSilenced);
        if (GetConVarInt(g_h_sm_retakes_weapon_awp_enabled) == 1)
            GiveAwpMenu(client);
        else
            CloseHandle(menu);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public void GiveAwpMenu(int client) {
    Handle menu = CreateMenu(MenuHandler_AWP);
    SetMenuTitle(menu, "Allow yourself to receive AWPs?");
    AddMenuBool(menu, true, "Yes");
    AddMenuBool(menu, false, "No");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public int MenuHandler_AWP(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        bool allowAwps = GetMenuBool(menu, param2);
        g_AwpChoice[client] = allowAwps;
        SetCookieBool(client, g_hAwpChoiceCookie, allowAwps);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}
