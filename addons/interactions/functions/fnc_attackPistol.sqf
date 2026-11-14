#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Function to make unit a pistol unit attacking with a pistol.
 *
 * Arguments:
 * Unit (OBJECT) - Unit to make a pistol unit attacking with a pistol.
 *
 * Return Value:
 * None
 *
 * Example:
 * [civ1] call kolmip_interactions_fnc_attackPistol;
 *
 * Public: No
 */
params ["_unit"];

private _newGroup = createGroup east;
[_unit] joinSilent _newGroup;
private _weaponsVan = [
    ["hgun_Pistol_01_F", "10Rnd_9x21_Mag"],
    ["hgun_Rook40_F", "16Rnd_9x21_Mag"],
    ["hgun_ACPC2_F", "9Rnd_45ACP_Mag"],
    ["hgun_Pistol_heavy_02_F", "6Rnd_45ACP_Cylinder"]
];

private _weaponRhs = [
    ["rhs_weap_6p53", "rhs_18rnd_9x21mm_7N28"],
    ["rhs_weap_pya", "rhs_mag_9x19_17"],
    ["rhs_weap_makarov_pm", "rhs_mag_9x18_8_57N181S"],
    ["rhsusf_weap_glock17g4", "rhsusf_mag_17Rnd_9x19_FMJ"],
    ["rhsusf_weap_m1911a1", "rhsusf_mag_7x45acp_MHP"],
    ["rhsusf_weap_m9", "rhsusf_mag_15Rnd_9x19_FMJ"]
];

private _weaponsRhsGS = [
    ["rhs_weap_tt33", "rhs_mag_762x25_8"],
    ["rhs_weap_type94_new", "rhs_mag_6x8mm_mhp"],
    ["rhs_weap_cz99", "rhssaf_mag_15Rnd_9x19_FMJ"],
    ["rhs_weap_cz99_etched", "rhssaf_mag_15Rnd_9x19_FMJ"]
];

if (isClass (configFile >> "CfgPatches" >> "rhs_c_weapons") && isClass(configFile >> "CfgPatches" >> "rhsusf_c_weapons")) then {
    _weaponsVan append _weaponRhs;
};
if (isClass (configFile >> "CfgPatches" >> "rhsgref_c_weapons") && isClass(configFile >> "CfgPatches" >> "rhssaf_c_weapons")) then {
    _weaponsVan append _weaponsRhsGS;
};
private _randomWeapon = selectRandom _weaponsVan;
_unit addMagazine (_randomWeapon select 1);
_unit addMagazine (_randomWeapon select 1);
_unit addMagazine (_randomWeapon select 1);
_unit addWeapon (_randomWeapon select 0);
private _nearestEnemy = (_unit nearEntities ["Man", 100])select 0;
_unit doFire _nearestEnemy;
