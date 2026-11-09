#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Applies the Eden person-status attribute on the server.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Status (0: not configured, 1: innocent, 2: wanted) <NUMBER>
 *
 * Return Value:
 * Applied <BOOL>
 *
 * Public: No
 */

params [
    ["_unit", objNull, [objNull]],
    ["_status", 0, [0]]
];
if (!isServer || {isNull _unit} || {!(_unit isKindOf "CAManBase")} || {!(_status in [0, 1, 2])}) exitWith { false };

_unit setVariable [QGVAR(personStatusValue), _status, true];
if (_status == 0) exitWith { true };

private _wantedReason = _unit getVariable [QGVAR(wantedReason), ""];
[_unit, _status, _wantedReason] call FUNC(registerConfiguredPerson)
