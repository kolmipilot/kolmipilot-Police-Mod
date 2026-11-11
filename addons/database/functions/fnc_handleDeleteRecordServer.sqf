#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Server network handler for delete record requests from clients.
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
 * [_requestId, _owner, _unit, _table, _id] call FUNC(handleDeleteRecordServer);
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

if (!isServer || _requestId isEqualTo "" || _tableName isEqualTo "") exitWith {};

// Enforce server-authoritative police authorization
if (GVAR(requirePoliceAuth) && {
    isNull _clientUnit
    || {owner _clientUnit != _senderOwner}
    || {!([_clientUnit] call EFUNC(common,isPolice))}
}) exitWith {
    if (GVAR(debug)) then {
        [format ["handleDeleteRecordServer: Rejected unauthorized delete request '%1' from client %2 (unit: %3)", _requestId, _senderOwner, _clientUnit]] call FUNC(log);
    };
    [QGVAR(deleteRecordResponse), [_requestId, false, ""], _senderOwner] call CBA_fnc_targetEvent;
};

private _success = [_tableName, _recordId] call FUNC(deleteRecordServer);

if (_success) then {
    private _recordIdString = if (_recordId isEqualType 0) then { str _recordId } else { _recordId };
    [QGVAR(recordChanged), [_tableName, _recordIdString, "delete"]] call CBA_fnc_globalEvent;
};

if (GVAR(debug)) then {
    [format ["handleDeleteRecordServer: Request '%1' deleted '%2' (success: %3)", _requestId, _recordId, _success]] call FUNC(log);
};

[QGVAR(deleteRecordResponse), [_requestId, _success, _recordId], _senderOwner] call CBA_fnc_targetEvent;
