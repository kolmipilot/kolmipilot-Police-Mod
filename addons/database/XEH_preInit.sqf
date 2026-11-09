#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Register CBA settings
[
    QGVAR(debug),
    "CHECKBOX",
    [LLSTRING(Setting_Debug), LLSTRING(Setting_Debug_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    false,
    0
] call CBA_fnc_addSetting;

[
    QGVAR(maxSearchResults),
    "SLIDER",
    [LLSTRING(Setting_MaxSearchResults), LLSTRING(Setting_MaxSearchResults_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    [5, 200, 50, 0],
    1
] call CBA_fnc_addSetting;

[
    QGVAR(requirePoliceAuth),
    "CHECKBOX",
    [LLSTRING(Setting_RequirePoliceAuth), LLSTRING(Setting_RequirePoliceAuth_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    true,
    1
] call CBA_fnc_addSetting;

ADDON = true;
