#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Reapplies Eden-configured status after its warrant-reason attribute changes.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Registered <BOOL>
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];
if (!isServer || {isNull _unit} || {!(_unit isKindOf "CAManBase")}) exitWith { false };

private _status = _unit getVariable [QGVAR(personStatusValue), 0];
if !(_status in [1, 2]) exitWith { true };

private _wantedReason = _unit getVariable [QGVAR(wantedReason), ""];
[_unit, _status, _wantedReason] call FUNC(registerConfiguredPerson)
