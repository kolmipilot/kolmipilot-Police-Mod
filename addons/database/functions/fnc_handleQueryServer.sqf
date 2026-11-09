#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Server network handler for query requests from clients.
 *
 * Arguments:
 * 0: Request ID <STRING>
 * 1: Sender client owner ID <NUMBER>
 * 2: Client unit object <OBJECT>
 * 3: Table name <STRING>
 * 4: Criteria <HASHMAP>
 * 5: Max results <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_requestId, _owner, _unit, _table, _crit, 50] call FUNC(handleQueryServer);
 *
 * Public: No
 */

params [
    ["_requestId", "", [""]],
    ["_senderOwner", 2, [0]],
    ["_clientUnit", objNull, [objNull]],
    ["_tableName", "", [""]],
    ["_criteria", createHashMap, [createHashMap]],
    ["_maxResults", 50, [0]]
];

if (!isServer || {_requestId isEqualTo ""} || {_tableName isEqualTo ""}) exitWith {};

// Enforce server-authoritative police authorization
if (GVAR(requirePoliceAuth) && {
    isNull _clientUnit
    || {owner _clientUnit != _senderOwner}
    || {!([_clientUnit] call EFUNC(common,isPolice))}
}) exitWith {
    if (GVAR(debug)) then {
        [format ["handleQueryServer: Rejected unauthorized query request '%1' from client %2 (unit: %3)", _requestId, _senderOwner, _clientUnit]] call FUNC(log);
    };
    [QGVAR(queryResponse), [_requestId, false, []], _senderOwner] call CBA_fnc_targetEvent;
};

if (GVAR(debug)) then {
    [format ["handleQueryServer: Request '%1' from owner %2 for table '%3'", _requestId, _senderOwner, _tableName]] call FUNC(log);
};

private _results = [_tableName, _criteria, _maxResults] call FUNC(queryServer);

[QGVAR(queryResponse), [_requestId, true, _results], _senderOwner] call CBA_fnc_targetEvent;
