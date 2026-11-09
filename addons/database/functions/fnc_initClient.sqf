#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Initializes client-side request tracking and registers response handlers.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(initClient);
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

GVAR(pendingRequests) = createHashMap;
GVAR(requestCounter) = 0;

[QGVAR(queryResponse), {
    params ["_requestId", "_success", "_results"];
    [_requestId, _success, _results] call FUNC(handleResponse);
}] call CBA_fnc_addEventHandler;

[QGVAR(getRecordResponse), {
    params ["_requestId", "_found", "_record"];
    [_requestId, _found, _record] call FUNC(handleResponse);
}] call CBA_fnc_addEventHandler;

[QGVAR(saveRecordResponse), {
    params ["_requestId", "_success", "_recordId", "_recordData"];
    [_requestId, _success, [_recordId, _recordData]] call FUNC(handleResponse);
}] call CBA_fnc_addEventHandler;

[QGVAR(deleteRecordResponse), {
    params ["_requestId", "_success", "_recordId"];
    [_requestId, _success, _recordId] call FUNC(handleResponse);
}] call CBA_fnc_addEventHandler;
