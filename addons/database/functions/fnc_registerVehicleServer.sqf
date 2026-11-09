#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Creates or updates an explicitly registered vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Plate <STRING>
 * 2: Owner person ID or UID <STRING>
 * 3: Wanted <BOOL>
 * 4: Wanted reason <STRING>
 * 5: Notes <STRING>
 *
 * Return Value:
 * [Success, Vehicle ID] <ARRAY>
 *
 * Public: No
 */

params [
    ["_vehicle", objNull, [objNull]],
    ["_plate", "", [""]],
    ["_ownerIdentifier", "", [""]],
    ["_isWanted", false, [false]],
    ["_wantedReason", "", [""]],
    ["_notes", "", [""]]
];
if (!isServer || {isNull _vehicle} || {_vehicle isKindOf "CAManBase"}) exitWith { [false, ""] };

if (isNil QGVAR(tables)) exitWith {
    private _pending = missionNamespace getVariable [QGVAR(pendingVehicleRegistrations), []];
    _pending pushBack [_vehicle, _plate, _ownerIdentifier, _isWanted, _wantedReason, _notes];
    missionNamespace setVariable [QGVAR(pendingVehicleRegistrations), _pending];
    [true, "PENDING"]
};

private _vehicleId = _vehicle getVariable [QGVAR(vehicleId), ""];
private _record = createHashMapFromArray [
    ["vehicleId", _vehicleId],
    ["plate", _plate],
    ["ownerId", _ownerIdentifier],
    ["className", typeOf _vehicle],
    ["displayName", getText (configOf _vehicle >> "displayName")],
    ["isWanted", _isWanted],
    ["wantedReason", _wantedReason],
    ["notes", _notes],
    ["netId", netId _vehicle]
];

private _result = [_record] call FUNC(saveVehicleRecordServer);
if (_result select 0) then {
    [QGVAR(recordChanged), ["vehicles", _result select 1, "save"]] call CBA_fnc_globalEvent;
};
_result
