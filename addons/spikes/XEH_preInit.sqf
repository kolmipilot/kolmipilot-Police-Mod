#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Register CBA settings
[
    QGVAR(enableSpikes),
    "CHECKBOX",
    [LLSTRING(Setting_EnableSpikes), LLSTRING(Setting_EnableSpikes_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    true,
    1
] call CBA_fnc_addSetting;

[
    QGVAR(reusableAfterHit),
    "CHECKBOX",
    [LLSTRING(Setting_ReusableAfterHit), LLSTRING(Setting_ReusableAfterHit_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    true,
    1
] call CBA_fnc_addSetting;

[
    QGVAR(punctureAllWheels),
    "CHECKBOX",
    [LLSTRING(Setting_PunctureAllWheels), LLSTRING(Setting_PunctureAllWheels_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    true,
    1
] call CBA_fnc_addSetting;

ADDON = true;
