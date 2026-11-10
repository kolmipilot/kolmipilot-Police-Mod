#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Register CBA settings
[
    QGVAR(soundEffects),
    "CHECKBOX",
    [LLSTRING(Setting_SoundEffects), LLSTRING(Setting_SoundEffects_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    true,
    0
] call CBA_fnc_addSetting;

[
    QGVAR(maxStopDistanceOnFoot),
    "SLIDER",
    [LLSTRING(Setting_MaxStopDistanceOnFoot), LLSTRING(Setting_MaxStopDistanceOnFoot_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    [5, 100, 20, 0],
    1
] call CBA_fnc_addSetting;

[
    QGVAR(maxStopDistanceInVehicle),
    "SLIDER",
    [LLSTRING(Setting_MaxStopDistanceInVehicle), LLSTRING(Setting_MaxStopDistanceInVehicle_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    [10, 300, 100, 0],
    1
] call CBA_fnc_addSetting;

ADDON = true;
