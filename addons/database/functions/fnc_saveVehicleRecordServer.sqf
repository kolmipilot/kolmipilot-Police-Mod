#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Validates and stores a vehicle record and its person ownership link.
 *
 * Arguments:
 * 0: Vehicle record <HASHMAP>
 *
 * Return Value:
 * [Success, Vehicle ID] <ARRAY>
 *
 * Public: No
 */

params [["_recordData", createHashMap, [createHashMap]]];
if (!isServer || {count _recordData == 0}) exitWith { [false, ""] };

private _record = +_recordData;
private _plateInput = _record getOrDefault ["plate", ""];
if !(_plateInput isEqualType "") exitWith { [false, ""] };
private _plate = toUpper _plateInput;
private _plateChars = toArray _plate;
private _validPlate = count _plateChars >= 3 && {count _plateChars <= 10};
{
    if !(_x == 45 || {_x >= 48 && {_x <= 57}} || {_x >= 65 && {_x <= 90}}) exitWith {
        _validPlate = false;
    };
} forEach _plateChars;
if (!_validPlate) exitWith { [false, ""] };

private _table = ["vehicles"] call FUNC(getTableServer);
if (isNil "_table") exitWith { [false, ""] };
private _records = _table get "records";
private _vehicleId = _record getOrDefault ["vehicleId", ""];
private _netId = _record getOrDefault ["netId", ""];
if !(_vehicleId isEqualType "" && {_netId isEqualType ""}) exitWith { [false, ""] };

if (_vehicleId isEqualTo "" && {_netId isNotEqualTo ""}) then {
    {
        if ((_y getOrDefault ["netId", ""]) isEqualTo _netId) exitWith {
            _vehicleId = _x;
        };
    } forEach _records;
};
if (_vehicleId isNotEqualTo "") then {
    private _existing = _records getOrDefault [_vehicleId, createHashMap];
    if (count _existing == 0 || {(_existing getOrDefault ["netId", ""]) isNotEqualTo _netId}) then {
        _vehicleId = "";
    };
};

if (_vehicleId isEqualTo "") then {
    private _nextId = _table getOrDefault ["nextId", 1000];
    _vehicleId = format ["VEH_%1", _nextId];
    _table set ["nextId", _nextId + 1];
};

private _ownerIdentifier = _record getOrDefault ["ownerId", ""];
if !(_ownerIdentifier isEqualType "") exitWith { [false, ""] };
private _ownerId = "";
private _ownerName = "";
private _ownerValid = true;
if (_ownerIdentifier isNotEqualTo "") then {
    private _persons = ["persons"] call FUNC(getTableServer);
    if (isNil "_persons") then {
        _ownerValid = false;
    } else {
        {
            if ((_y getOrDefault ["id", ""]) isEqualTo _ownerIdentifier
                || {(_y getOrDefault ["uid", ""]) isEqualTo _ownerIdentifier}) exitWith {
                _ownerId = _y getOrDefault ["id", ""];
                _ownerName = _y getOrDefault ["fullName", ""];
            };
        } forEach (_persons get "records");
        if (_ownerId isEqualTo "") then {
            _ownerValid = false;
        };
    };
};
if (!_ownerValid) exitWith { [false, ""] };

private _previousRecord = _records getOrDefault [_vehicleId, createHashMap];
{
    if (_x isNotEqualTo _vehicleId && {(_y getOrDefault ["plate", ""]) isEqualTo _plate}) exitWith {
        _vehicleId = "";
    };
} forEach _records;
if (_vehicleId isEqualTo "") exitWith { [false, ""] };

_record set ["vehicleId", _vehicleId];
_record set ["plate", _plate];
_record set ["ownerId", _ownerId];
_record set ["ownerName", _ownerName];
private _className = _record getOrDefault ["className", ""];
private _displayName = _record getOrDefault ["displayName", ""];
private _isWanted = _record getOrDefault ["isWanted", false];
private _wantedReason = _record getOrDefault ["wantedReason", ""];
private _notes = _record getOrDefault ["notes", ""];
if !(_className isEqualType "" && {_displayName isEqualType ""} && {_isWanted isEqualType false}
    && {_wantedReason isEqualType ""} && {_notes isEqualType ""}) exitWith { [false, ""] };
_record set ["className", _className];
_record set ["displayName", _displayName];
_record set ["isRegistered", true];
_record set ["isWanted", _isWanted];
_record set ["wantedReason", _wantedReason];
_record set ["notes", _notes];
_record set ["netId", _netId];

private _oldOwnerId = _previousRecord getOrDefault ["ownerId", ""];
private _oldPlate = _previousRecord getOrDefault ["plate", ""];
if (_oldOwnerId isNotEqualTo "" && {_oldOwnerId isNotEqualTo _ownerId || {_oldPlate isNotEqualTo _plate}}) then {
    private _oldOwner = ["persons", _oldOwnerId] call FUNC(getRecordServer);
    if (count _oldOwner > 0) then {
        private _oldVehicles = _oldOwner getOrDefault ["vehicles", []];
        if (_oldVehicles isEqualType []) then {
            _oldOwner set ["vehicles", _oldVehicles - [_oldPlate]];
        };
        _oldOwner set ["id", _oldOwnerId];
        ["persons", _oldOwner] call FUNC(setRecordServer);
        [QGVAR(recordChanged), ["persons", _oldOwnerId, "save"]] call CBA_fnc_globalEvent;
    };
};

_records set [_vehicleId, _record];
if (_ownerId isNotEqualTo "") then {
    private _owner = ["persons", _ownerId] call FUNC(getRecordServer);
    private _ownerVehicles = _owner getOrDefault ["vehicles", []];
    if !(_ownerVehicles isEqualType []) then {
        _ownerVehicles = [];
    };
    _ownerVehicles pushBackUnique _plate;
    _owner set ["vehicles", _ownerVehicles];
    _owner set ["id", _ownerId];
    ["persons", _owner] call FUNC(setRecordServer);
    [QGVAR(recordChanged), ["persons", _ownerId, "save"]] call CBA_fnc_globalEvent;
};

private _vehicle = objectFromNetId _netId;
if (!isNull _vehicle) then {
    _vehicle setVariable [QGVAR(vehicleId), _vehicleId, true];
    _vehicle setVariable [QGVAR(plate), _plate, true];
    _vehicle setVariable [QGVAR(isWanted), _record get "isWanted", true];
};

[true, _vehicleId]
