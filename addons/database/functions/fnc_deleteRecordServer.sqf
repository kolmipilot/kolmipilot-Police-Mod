#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Deletes a record by primary key from a server table.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Record ID <STRING|NUMBER>
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * private _deleted = ["persons", "P_1001"] call FUNC(deleteRecordServer);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_recordId", "", ["", 0]]
];

if (!isServer || {_tableName isEqualTo ""} || {_recordId isEqualTo ""}) exitWith { false };

private _table = [_tableName] call FUNC(getTableServer);
if (isNil "_table") exitWith { false };

private _records = _table get "records";
private _idStr = if (_recordId isEqualType 0) then { str _recordId } else { _recordId };

if (_idStr in _records) then {
    _records deleteAt _idStr;
    if (GVAR(debug)) then {
        [format ["deleteRecordServer: Record '%1' deleted from '%2'", _idStr, _tableName]] call FUNC(log);
    };
    true
} else {
    if (_recordId in _records) then {
        _records deleteAt _recordId;
        if (GVAR(debug)) then {
            [format ["deleteRecordServer: Record '%1' deleted from '%2'", _recordId, _tableName]] call FUNC(log);
        };
        true
    } else {
        false
    };
};
