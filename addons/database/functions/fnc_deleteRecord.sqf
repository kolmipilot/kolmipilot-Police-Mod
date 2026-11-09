#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Deletes a record from a database table asynchronously.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Record ID <STRING|NUMBER>
 * 2: Callback code [recordId, customArgs, success] <CODE> (Default: {})
 * 3: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * Request ID or success boolean if local server call <ANY>
 *
 * Example:
 * ["persons", "P_1001", {
 *     params ["_recordId", "_args", "_success"];
 * }] call FUNC(deleteRecord);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_recordId", "", ["", 0]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

if (_tableName isEqualTo "" || {_recordId isEqualTo ""}) exitWith { "" };

if (isServer && !hasInterface) exitWith {
    private _success = [_tableName, _recordId] call FUNC(deleteRecordServer);
    if (_success) then {
        private _recordIdString = if (_recordId isEqualType 0) then { str _recordId } else { _recordId };
        [QGVAR(recordChanged), [_tableName, _recordIdString, "delete"]] call CBA_fnc_globalEvent;
    };
    if (_callback isNotEqualTo {}) then {
        [_recordId, _customArgs, _success] call _callback;
    };
    _success
};

if (isServer && hasInterface) exitWith {
    if (GVAR(requirePoliceAuth) && {!([player] call EFUNC(common,isPolice))}) exitWith {
        if (_callback isNotEqualTo {}) then {
            [{
                params ["_cb", "_id", "_args"];
                [_id, _args, false] call _cb;
            }, [_callback, _recordId, _customArgs]] call CBA_fnc_execNextFrame;
        };
        false
    };
    private _success = [_tableName, _recordId] call FUNC(deleteRecordServer);
    if (_success) then {
        private _recordIdString = if (_recordId isEqualType 0) then { str _recordId } else { _recordId };
        [QGVAR(recordChanged), [_tableName, _recordIdString, "delete"]] call CBA_fnc_globalEvent;
    };
    if (_callback isNotEqualTo {}) then {
        [{
            params ["_cb", "_id", "_args", "_s"];
            [_id, _args, _s] call _cb;
        }, [_callback, _recordId, _customArgs, _success]] call CBA_fnc_execNextFrame;
    };
    "LOCAL_SYNC"
};

private _requestId = [_callback, _customArgs] call FUNC(sendRequest);
[QGVAR(deleteRecordServer), [_requestId, clientOwner, player, _tableName, _recordId]] call CBA_fnc_serverEvent;

_requestId
