#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Retrieves a table HashMap from the server database.
 *
 * Arguments:
 * 0: Table name <STRING>
 *
 * Return Value:
 * Table HashMap or nil if not found <HASHMAP|NIL>
 *
 * Example:
 * private _table = ["persons"] call FUNC(getTableServer);
 *
 * Public: No
 */

params [["_tableName", "", [""]]];

if (!isServer || {_tableName isEqualTo ""} || {isNil QGVAR(tables)}) exitWith { nil };

GVAR(tables) getOrDefault [_tableName, nil]
