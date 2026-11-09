#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Registers vehicles synchronized to the Eden or Zeus module.
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

private _plate = _logic getVariable ["Plate", ""];
private _ownerId = _logic getVariable ["OwnerId", ""];
private _isWanted = _logic getVariable ["IsWanted", false];
private _wantedReason = _logic getVariable ["WantedReason", ""];
private _notes = _logic getVariable ["Notes", ""];
private _vehicles = _units select { !isNull _x && {_x isKindOf "AllVehicles"} && {!(_x isKindOf "CAManBase")} };
private _owners = _units select { !isNull _x && {_x isKindOf "CAManBase"} };

if (count _owners > 1) then {
    diag_log "[kolmip] Vehicle registration module has multiple synchronized persons; using the first person as owner.";
};
if (_owners isNotEqualTo []) then {
    private _owner = _owners select 0;
    if !([_owner, 0] call EFUNC(database,registerConfiguredPerson)) then {
        diag_log format ["[kolmip] Could not register vehicle owner %1.", name _owner];
    } else {
        _ownerId = _owner getVariable [QEGVAR(database,personId), _ownerId];
    };
};

{
    private _result = [_x, _plate, _ownerId, _isWanted, _wantedReason, _notes] call EFUNC(database,registerVehicleServer);
    if !(_result select 0) then {
        diag_log format ["[kolmip] Vehicle registration failed for %1. Check that the plate is unique and the optional owner identifies a registered person.", typeOf _x];
    };
} forEach _vehicles;
