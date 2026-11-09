#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Inserts or updates a record in a server table. Generates primary key if missing.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Record data <HASHMAP>
 *
 * Return Value:
 * [Success, RecordId] <ARRAY>
 *
 * Example:
 * private _res = ["persons", _personData] call FUNC(setRecordServer);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_recordData", createHashMap, [createHashMap]]
];

if (!isServer || {_tableName isEqualTo ""} || {count _recordData == 0}) exitWith { [false, ""] };

private _table = [_tableName] call FUNC(getTableServer);
if (isNil "_table") exitWith { [false, ""] };

private _pkField = _table get "primaryKey";
private _records = _table get "records";

private _id = _recordData getOrDefault [_pkField, ""];
if (_id isEqualTo "") then {
    private _nextId = _table getOrDefault ["nextId", 1000];
    _id = format ["%1_%2", toUpper _tableName, _nextId];
    _table set ["nextId", _nextId + 1];
    _recordData set [_pkField, _id];
};

private _idStr = if (_id isEqualType 0) then { str _id } else { _id };
_records set [_idStr, +_recordData];

if (GVAR(debug)) then {
    [format ["setRecordServer: Record '%1' saved in '%2'", _idStr, _tableName]] call FUNC(log);
};

[true, _idStr]
