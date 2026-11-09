#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Applies the selected innocent/wanted status to synchronized persons.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synchronized objects <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_logic", "_units", "_activated"];
if (!_activated || {!isServer} || {isNull _logic}) exitWith {};

private _status = _logic getVariable ["Status", 0];
if !(_status in [1, 2]) exitWith {};
private _wantedReason = _logic getVariable ["WantedReason", ""];

{
    if (!isNull _x && {_x isKindOf "CAManBase"}) then {
        if !([_x, _status, _wantedReason] call EFUNC(database,registerConfiguredPerson)) then {
            diag_log format ["[kolmip] Person configuration failed for %1 (side %2).", name _x, side _x];
        };
    };
} forEach _units;
