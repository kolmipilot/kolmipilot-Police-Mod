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

ADDON = true;
