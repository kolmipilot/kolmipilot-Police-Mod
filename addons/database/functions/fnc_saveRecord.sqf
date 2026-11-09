#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Saves (inserts or updates) a record in a database table asynchronously.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Record data <HASHMAP>
 * 2: Callback code [[recordId, recordData], customArgs, success] <CODE> (Default: {})
 * 3: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * Request ID or [success, recordId] if local server call <ANY>
 *
 * Example:
 * ["persons", _personData, {
 *     params ["_result", "_args", "_success"];
 * }] call FUNC(saveRecord);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_recordData", createHashMap, [createHashMap]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

if (_tableName isEqualTo "" || {count _recordData == 0}) exitWith { "" };

if (isServer && !hasInterface) exitWith {
    private _saveResult = [_tableName, _recordData] call FUNC(setRecordServer);
    _saveResult params ["_success", "_id"];
    if (_success) then {
        [QGVAR(recordChanged), [_tableName, _id, "save"]] call CBA_fnc_globalEvent;
    };
    if (_callback isNotEqualTo {}) then {
        [[_id, _recordData], _customArgs, _success] call _callback;
    };
    _saveResult
};

if (isServer && hasInterface) exitWith {
    if (GVAR(requirePoliceAuth) && {!([player] call EFUNC(common,isPolice))}) exitWith {
        if (_callback isNotEqualTo {}) then {
            [{
                params ["_cb", "_args"];
                [["", createHashMap], _args, false] call _cb;
            }, [_callback, _customArgs]] call CBA_fnc_execNextFrame;
        };
        [false, ""]
    };
    private _saveResult = [_tableName, _recordData] call FUNC(setRecordServer);
    _saveResult params ["_success", "_id"];
    if (_success) then {
        [QGVAR(recordChanged), [_tableName, _id, "save"]] call CBA_fnc_globalEvent;
    };
    if (_callback isNotEqualTo {}) then {
        [{
            params ["_cb", "_res", "_rec", "_args", "_s"];
            [[_res, _rec], _args, _s] call _cb;
        }, [_callback, _id, _recordData, _customArgs, _success]] call CBA_fnc_execNextFrame;
    };
    "LOCAL_SYNC"
};

private _requestId = [_callback, _customArgs] call FUNC(sendRequest);
[QGVAR(saveRecordServer), [_requestId, clientOwner, player, _tableName, _recordData]] call CBA_fnc_serverEvent;

_requestId
