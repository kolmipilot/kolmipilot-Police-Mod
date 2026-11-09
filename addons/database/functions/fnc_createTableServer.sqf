#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Creates a new table in the server database if it does not already exist.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Primary key field name <STRING> (Default: "id")
 *
 * Return Value:
 * Table HashMap <HASHMAP>
 *
 * Example:
 * ["persons", "id"] call FUNC(createTableServer);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_primaryKey", "id", [""]]
];

if (!isServer || {_tableName isEqualTo ""}) exitWith { createHashMap };

if (isNil QGVAR(tables)) then {
    GVAR(tables) = createHashMap;
};

private _table = GVAR(tables) getOrDefault [_tableName, nil];
if (!isNil "_table") exitWith { _table };

_table = createHashMapFromArray [
    ["name", _tableName],
    ["primaryKey", _primaryKey],
    ["records", createHashMap],
    ["nextId", 1000]
];

GVAR(tables) set [_tableName, _table];

if (GVAR(debug)) then {
    [format ["Created table '%1' with primary key '%2'", _tableName, _primaryKey]] call FUNC(log);
};

_table
