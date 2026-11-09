#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Handles an incoming response from the server for a pending request.
 *
 * Arguments:
 * 0: Request ID <STRING>
 * 1: Success flag <BOOL>
 * 2: Response payload <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_requestId, _success, _data] call FUNC(handleResponse);
 *
 * Public: No
 */

params [
    ["_requestId", "", [""]],
    ["_success", false, [false]],
    "_data"
];

if (_requestId isEqualTo "" || {isNil QGVAR(pendingRequests)}) exitWith {};

private _reqData = GVAR(pendingRequests) getOrDefault [_requestId, []];
if (_reqData isEqualTo []) exitWith {};

GVAR(pendingRequests) deleteAt _requestId;

_reqData params ["_callback", "_customArgs"];

if (!isNil "_callback" && {_callback isNotEqualTo {}}) then {
    [_data, _customArgs, _success] call _callback;
};
