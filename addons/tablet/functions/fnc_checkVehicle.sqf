#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Checks an existing vehicle record or dynamically registers the vehicle during an explicit check.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];
if (isNull _vehicle || {!alive _vehicle} || {_vehicle isKindOf "CAManBase"}) exitWith {};
if !([player] call FUNC(canUsePoliceActions)) exitWith {};

private _vehicleId = _vehicle getVariable [QEGVAR(database,vehicleId), ""];
if (_vehicleId isEqualTo "") exitWith {
    [_vehicle] call FUNC(registerEncounterVehicle);
};

[
    "vehicles",
    _vehicleId,
    {
        params ["_record", "_args", "_found"];
        _args params ["_vehicle"];
        if (_found) exitWith {
            [_record] call FUNC(showEncounterVehicle);
        };
        [_vehicle] call FUNC(registerEncounterVehicle);
    },
    [_vehicle]
] call EFUNC(database,getRecord);
