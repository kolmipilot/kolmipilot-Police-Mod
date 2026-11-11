#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

[QGVAR(switchMove), {
    params ["_unit", "_move"];
    if (isNull _unit) exitWith {};
    _unit switchMove _move;
}] call CBA_fnc_addEventHandler;

[QGVAR(removeHitPartHandlers), {
    params ["_unit"];
    if (isNull _unit) exitWith {};
    _unit removeAllEventHandlers "HitPart";
}] call CBA_fnc_addEventHandler;

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

ADDON = true;
