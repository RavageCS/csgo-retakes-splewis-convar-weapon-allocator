Customised Weapon Allocator 
-------------------

This plugin is an alternate weapon allocator of [Splewis RETAKES Plugin](https://github.com/splewis/csgo-retakes)

**Please be sure to create Issues if you've got trouble on your server, even for a simple question**

Install
---------------------

**The compiled SMX file for linux is in the source code zip file**

Just replace the smx file in */csgo/addons/sourcemod/plugins*

Explanations
---------------------

I've created those **cvars** to customise your server. 

Just add those cvars to change their default value in **server.cfg / autoexec.cfg** :
> - sm_retakes_weapon_primary_enabled
>   - **default 1**
>   - *you can set it to 0 if you want a gunmode*
> - sm_retakes_weapon_nades_enabled
>   - **default 1**
>   - *you can set it to 0 if you don't want nades (all types)*
> - sm_retakes_weapon_nades_hegrenade_ct_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid hegrenade on CT side*
> - sm_retakes_weapon_nades_hegrenade_t_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid hegrenade on T side*
> - sm_retakes_weapon_nades_flashbang_ct_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid flashbang on CT side*
> - sm_retakes_weapon_nades_flashbang_t_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid flashbang on T side*
> - sm_retakes_weapon_nades_smokegrenade_ct_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid smokegrenade on CT side*
> - sm_retakes_weapon_nades_smokegrenade_t_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid smokegrenade on T side*
> - sm_retakes_weapon_nades_molotov_ct_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid molotov on CT side*
> - sm_retakes_weapon_nades_molotov_t_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid molotov on T side*
> - sm_retakes_weapon_helmet_enabled
>   - **default 1**
>   - *you can set it to 0 to remove helmet*
> - sm_retakes_weapon_kevlar_enabled
>   - **default 1**
>   - *you can set it to 0 to remove kevlar (previous cvar must be set to 0)*
> - sm_retakes_weapon_awp_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid AWP*
> - sm_retakes_weapon_gunrounds
>   - **default 5**
>   - *this is the number of gun rounds at the beginning of the map. You can set 0 if you always want primary weapon*
> - sm_retakes_weapon_deagle_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid Deagle*
> - sm_retakes_weapon_cz_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid CZ*
> - sm_retakes_weapon_p250_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid P250*
> - sm_retakes_weapon_tec9_fiveseven_enabled
>   - **default 1**
>   - *you can set it to 0 to forbid Tec9/Fiveseven*

Guns !
-----------------------
**Players can write /guns /gun .guns .gun !guns !gun to change their weapons'preferences**


> **Gun choice**
> - HKP2000 / USP / Glock
> - Tec9 / Fiveseven
> - P250
> - CZ
> - Deagle

> **Rifle choice for CT**
> - M4A1
> - M4A4

> **If you want AWP sometimes**
> - Yes
> - No


