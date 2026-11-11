#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Deletes a vehicle record and removes its plate from the owner's record.
 *
 * Arguments:
 * 0: Vehicle ID <STRING>
 *
 * Return Value:
 * Deleted <BOOL>
 *
 * Public: No
 */

params [["_vehicleId", "", ["", 0]]];
if (!isServer || _vehicleId isEqualTo "") exitWith { false };

private _table = ["vehicles"] call FUNC(getTableServer);
if (isNil "_table") exitWith { false };
private _records = _table get "records";
private _vehicleIdString = if (_vehicleId isEqualType 0) then { str _vehicleId } else { _vehicleId };
private _record = _records getOrDefault [_vehicleIdString, createHashMap];
if (count _record == 0) exitWith { false };

private _ownerId = _record getOrDefault ["ownerId", ""];
private _plate = _record getOrDefault ["plate", ""];
if (_ownerId isNotEqualTo "") then {
    private _owner = ["persons", _ownerId] call FUNC(getRecordServer);
    if (count _owner > 0) then {
        private _vehicles = _owner getOrDefault ["vehicles", []];
        if (_vehicles isEqualType []) then {
            _owner set ["vehicles", _vehicles - [_plate]];
        };
        _owner set ["id", _ownerId];
        ["persons", _owner] call FUNC(setRecordServer);
        [QGVAR(recordChanged), ["persons", _ownerId, "save"]] call CBA_fnc_globalEvent;
    };
};

_records deleteAt _vehicleIdString;
true
