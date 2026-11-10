#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Requests a server-authoritative stop for the nearest target in front.
 *
 * Arguments:
 * 0: Officer <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_officer", player, [objNull]]];
if !([_officer] call FUNC(canUsePoliceActions)) exitWith {};

private _target = [_officer] call FUNC(findStopTarget);
if (isNull _target) exitWith {};

if ((vehicle _officer) isEqualTo _officer) then {
    [_officer, "gestureFreeze"] call ace_common_fnc_doGesture;
};

[
    QGVAR(encounterRequest),
    [clientOwner, _officer, _target, "stop"]
] call CBA_fnc_serverEvent;

if (_target isKindOf "CAManBase") then {
    [_target, "id", false] call FUNC(interactWithPerson);
} else {
    [_target, false] call FUNC(registerEncounterVehicle);
};
