#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Server network handler for save record requests from clients.
 *
 * Arguments:
 * 0: Request ID <STRING>
 * 1: Sender client owner ID <NUMBER>
 * 2: Client unit object <OBJECT>
 * 3: Table name <STRING>
 * 4: Record data <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_requestId, _owner, _unit, _table, _data] call FUNC(handleSaveRecordServer);
 *
 * Public: No
 */

params [
    ["_requestId", "", [""]],
    ["_senderOwner", 2, [0]],
    ["_clientUnit", objNull, [objNull]],
    ["_tableName", "", [""]],
    ["_recordData", createHashMap, [createHashMap]]
];

if (!isServer || {_requestId isEqualTo ""} || {_tableName isEqualTo ""}) exitWith {};

// Enforce server-authoritative police authorization
if (GVAR(requirePoliceAuth) && {
    isNull _clientUnit
    || {owner _clientUnit != _senderOwner}
    || {!([_clientUnit] call EFUNC(common,isPolice))}
}) exitWith {
    if (GVAR(debug)) then {
        [format ["handleSaveRecordServer: Rejected unauthorized save request '%1' from client %2 (unit: %3)", _requestId, _senderOwner, _clientUnit]] call FUNC(log);
    };
    [QGVAR(saveRecordResponse), [_requestId, false, "", createHashMap], _senderOwner] call CBA_fnc_targetEvent;
};

private _saveResult = [_tableName, _recordData] call FUNC(setRecordServer);
_saveResult params ["_success", "_recordId"];
private _savedRecord = _recordData;

if (_success) then {
    if (_tableName isEqualTo "vehicles") then {
        _savedRecord = ["vehicles", _recordId] call FUNC(getRecordServer);
    };
    [QGVAR(recordChanged), [_tableName, _recordId, "save"]] call CBA_fnc_globalEvent;
};

if (GVAR(debug)) then {
    [format ["handleSaveRecordServer: Request '%1' saved '%2' (success: %3)", _requestId, _recordId, _success]] call FUNC(log);
};

[QGVAR(saveRecordResponse), [_requestId, _success, _recordId, _savedRecord], _senderOwner] call CBA_fnc_targetEvent;
