#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Retrieves a single record by primary key from a server table.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Record ID <STRING|NUMBER>
 *
 * Return Value:
 * Record HashMap or empty HashMap if not found <HASHMAP>
 *
 * Example:
 * private _person = ["persons", "P_1001"] call FUNC(getRecordServer);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_recordId", "", ["", 0]]
];

if (!isServer || _tableName isEqualTo "" || _recordId isEqualTo "") exitWith { createHashMap };

private _table = [_tableName] call FUNC(getTableServer);
if (isNil "_table") exitWith { createHashMap };

private _records = _table get "records";
private _idStr = if (_recordId isEqualType 0) then { str _recordId } else { _recordId };

private _record = _records getOrDefault [_idStr, _records getOrDefault [_recordId, createHashMap]];
+_record
