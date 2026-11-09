#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Registers a pending request with a callback and returns a unique request ID.
 *
 * Arguments:
 * 0: Callback code <CODE>
 * 1: Custom arguments passed to callback <ANY>
 *
 * Return Value:
 * Request ID <STRING>
 *
 * Example:
 * private _reqId = [_callback, _args] call FUNC(sendRequest);
 *
 * Public: No
 */

params [
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

if (isNil QGVAR(pendingRequests)) then {
    GVAR(pendingRequests) = createHashMap;
    GVAR(requestCounter) = 0;
};

GVAR(requestCounter) = GVAR(requestCounter) + 1;
private _requestId = format ["REQ_%1_%2_%3", clientOwner, round (diag_tickTime * 100), GVAR(requestCounter)];

GVAR(pendingRequests) set [_requestId, [_callback, _customArgs, diag_tickTime]];

_requestId
