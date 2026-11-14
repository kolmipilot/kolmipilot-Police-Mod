#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

[QGVAR(playDeathSound), {
    params ["_unit", "_soundName", "_soundRadius", "_secondsToDelete"];
    if (!hasInterface || {isNull _unit}) exitWith {};

    private _soundSource = "Helper_Base_F" createVehicleLocal (getPos _unit);
    _soundSource attachTo [_unit, [0, 0, 0.2], "Spine3"];
    _soundSource say3D [_soundName, _soundRadius];

    [
        {
            params ["_soundSource"];
            deleteVehicle _soundSource;
        },
        [_soundSource],
        _secondsToDelete
    ] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;

[
    QGVAR(hideWeaponOnDismount),
    "CHECKBOX",
    [LLSTRING(Setting_HideWeaponOnDismount), LLSTRING(Setting_HideWeaponOnDismount_Tooltip)],
    [QUOTE(MOD_NAME), QUOTE(COMPONENT_BEAUTIFIED)],
    true,
    0
] call CBA_fnc_addSetting;

ADDON = true;
