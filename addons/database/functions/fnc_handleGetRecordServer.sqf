#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Server network handler for get record requests from clients.
 *
 * Arguments:
 * 0: Request ID <STRING>
 * 1: Sender client owner ID <NUMBER>
 * 2: Client unit object <OBJECT>
 * 3: Table name <STRING>
 * 4: Record ID <STRING|NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_requestId, _owner, _unit, _table, _id] call FUNC(handleGetRecordServer);
 *
 * Public: No
 */

params [
    ["_requestId", "", [""]],
    ["_senderOwner", 2, [0]],
    ["_clientUnit", objNull, [objNull]],
    ["_tableName", "", [""]],
    ["_recordId", "", ["", 0]]
];

if (!isServer || {_requestId isEqualTo ""} || {_tableName isEqualTo ""}) exitWith {};

// Enforce server-authoritative police authorization
if (GVAR(requirePoliceAuth) && {
    isNull _clientUnit
    || {owner _clientUnit != _senderOwner}
    || {!([_clientUnit] call EFUNC(common,isPolice))}
}) exitWith {
    if (GVAR(debug)) then {
        [format ["handleGetRecordServer: Rejected unauthorized get request '%1' from client %2 (unit: %3)", _requestId, _senderOwner, _clientUnit]] call FUNC(log);
    };
    [QGVAR(getRecordResponse), [_requestId, false, createHashMap], _senderOwner] call CBA_fnc_targetEvent;
};

private _record = [_tableName, _recordId] call FUNC(getRecordServer);
private _found = (count _record > 0);

if (GVAR(debug)) then {
    [format ["handleGetRecordServer: Request '%1' for ID '%2' (found: %3)", _requestId, _recordId, _found]] call FUNC(log);
};

[QGVAR(getRecordResponse), [_requestId, _found, _record], _senderOwner] call CBA_fnc_targetEvent;
