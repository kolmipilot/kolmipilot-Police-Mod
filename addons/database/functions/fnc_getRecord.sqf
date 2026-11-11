#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Retrieves a record by ID from a database table asynchronously.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Record ID <STRING|NUMBER>
 * 2: Callback code [record, customArgs, found] <CODE> (Default: {})
 * 3: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * Request ID or record if local server call <ANY>
 *
 * Example:
 * ["persons", "P_1001", {
 *     params ["_record", "_args", "_found"];
 * }] call FUNC(getRecord);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_recordId", "", ["", 0]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

if (_tableName isEqualTo "" || _recordId isEqualTo "") exitWith { "" };

if (isServer && !hasInterface) exitWith {
    private _record = [_tableName, _recordId] call FUNC(getRecordServer);
    private _found = (count _record > 0);
    if (_callback isNotEqualTo {}) then {
        [_record, _customArgs, _found] call _callback;
    };
    _record
};

if (isServer && hasInterface) exitWith {
    if (GVAR(requirePoliceAuth) && {!([player] call EFUNC(common,isPolice))}) exitWith {
        if (_callback isNotEqualTo {}) then {
            [{
                params ["_cb", "_args"];
                [createHashMap, _args, false] call _cb;
            }, [_callback, _customArgs]] call CBA_fnc_execNextFrame;
        };
        "UNAUTHORIZED"
    };
    private _record = [_tableName, _recordId] call FUNC(getRecordServer);
    private _found = (count _record > 0);
    if (_callback isNotEqualTo {}) then {
        [{
            params ["_cb", "_rec", "_args", "_f"];
            [_rec, _args, _f] call _cb;
        }, [_callback, _record, _customArgs, _found]] call CBA_fnc_execNextFrame;
    };
    "LOCAL_SYNC"
};

private _requestId = [_callback, _customArgs] call FUNC(sendRequest);
[QGVAR(getRecordServer), [_requestId, clientOwner, player, _tableName, _recordId]] call CBA_fnc_serverEvent;

_requestId
