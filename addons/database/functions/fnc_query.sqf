#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Queries a database table asynchronously.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Search criteria <HASHMAP> (Default: empty HashMap)
 * 2: Callback code [results, customArgs, success] <CODE> (Default: {})
 * 3: Custom arguments <ANY> (Default: [])
 * 4: Max results <NUMBER> (Default: -1 for setting value)
 *
 * Return Value:
 * Request ID or results if local server call <ANY>
 *
 * Example:
 * ["persons", createHashMapFromArray [["isWanted", true]], {
 *     params ["_results", "_args", "_success"];
 *     diag_log format ["Found: %1", count _results];
 * }] call FUNC(query);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_criteria", createHashMap, [createHashMap]],
    ["_callback", {}, [{}]],
    ["_customArgs", []],
    ["_maxResults", -1, [0]]
];

if (_tableName isEqualTo "") exitWith { "" };

if (_maxResults <= 0) then {
    _maxResults = GVAR(maxSearchResults);
};

if (isServer && !hasInterface) exitWith {
    private _results = [_tableName, _criteria, _maxResults] call FUNC(queryServer);
    if (_callback isNotEqualTo {}) then {
        [_results, _customArgs, true] call _callback;
    };
    _results
};

if (isServer && hasInterface) exitWith {
    if (GVAR(requirePoliceAuth) && {!([player] call EFUNC(common,isPolice))}) exitWith {
        if (_callback isNotEqualTo {}) then {
            [{
                params ["_cb", "_args"];
                [[], _args, false] call _cb;
            }, [_callback, _customArgs]] call CBA_fnc_execNextFrame;
        };
        "UNAUTHORIZED"
    };
    private _results = [_tableName, _criteria, _maxResults] call FUNC(queryServer);
    if (_callback isNotEqualTo {}) then {
        [{
            params ["_cb", "_res", "_args"];
            [_res, _args, true] call _cb;
        }, [_callback, _results, _customArgs]] call CBA_fnc_execNextFrame;
    };
    "LOCAL_SYNC"
};

private _requestId = [_callback, _customArgs] call FUNC(sendRequest);
[QGVAR(queryServer), [_requestId, clientOwner, player, _tableName, _criteria, _maxResults]] call CBA_fnc_serverEvent;

_requestId
