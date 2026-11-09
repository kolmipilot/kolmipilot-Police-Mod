#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Initializes server-side database storage and registers network event handlers.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(initServer);
 *
 * Public: No
 */

if (!isServer) exitWith {};

// Initialize tables storage in missionNamespace
GVAR(tables) = createHashMap;

// Initialize core tables
["persons", "id"] call FUNC(createTableServer);
["vehicles", "vehicleId"] call FUNC(createTableServer);

// Register server-side CBA network events
[QGVAR(queryServer), {
    params ["_requestId", "_senderOwner", "_clientUnit", "_tableName", "_criteria", "_maxResults"];
    [_requestId, _senderOwner, _clientUnit, _tableName, _criteria, _maxResults] call FUNC(handleQueryServer);
}] call CBA_fnc_addEventHandler;

[QGVAR(getRecordServer), {
    params ["_requestId", "_senderOwner", "_clientUnit", "_tableName", "_recordId"];
    [_requestId, _senderOwner, _clientUnit, _tableName, _recordId] call FUNC(handleGetRecordServer);
}] call CBA_fnc_addEventHandler;

[QGVAR(saveRecordServer), {
    params ["_requestId", "_senderOwner", "_clientUnit", "_tableName", "_recordData"];
    [_requestId, _senderOwner, _clientUnit, _tableName, _recordData] call FUNC(handleSaveRecordServer);
}] call CBA_fnc_addEventHandler;

[QGVAR(deleteRecordServer), {
    params ["_requestId", "_senderOwner", "_clientUnit", "_tableName", "_recordId"];
    [_requestId, _senderOwner, _clientUnit, _tableName, _recordId] call FUNC(handleDeleteRecordServer);
}] call CBA_fnc_addEventHandler;

private _pendingPersons = missionNamespace getVariable [QGVAR(pendingPersonRegistrations), []];
missionNamespace setVariable [QGVAR(pendingPersonRegistrations), []];
{
    _x call FUNC(registerConfiguredPerson);
} forEach _pendingPersons;

private _pendingVehicles = missionNamespace getVariable [QGVAR(pendingVehicleRegistrations), []];
missionNamespace setVariable [QGVAR(pendingVehicleRegistrations), []];
{
    _x call FUNC(registerVehicleServer);
} forEach _pendingVehicles;

if (GVAR(debug)) then {
    ["Database server backend initialized successfully."] call FUNC(log);
};
