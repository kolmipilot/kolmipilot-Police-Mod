#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Saves a vehicle record only after an officer explicitly checks it, assigning the driver as owner.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Show registration result <BOOL> (Default: true)
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [
    ["_vehicle", objNull, [objNull]],
    ["_showResult", true, [true]]
];
if (isNull _vehicle || {!alive _vehicle}) exitWith {};
if !([player] call FUNC(canUsePoliceActions)) exitWith {};
if (!EGVAR(database,enableEncounterRegistration)) exitWith {
    if (_showResult) then {
        [format ["<t color='#ffcc66'>%1</t>", LLSTRING(Msg_VehicleNotRegistered)], 3.3, player, 12] call ace_common_fnc_displayTextStructured;
    };
};

private _saveVehicle = {
    params ["_vehicle", "_ownerId", "_showResult"];
    private _record = createHashMapFromArray [
        ["vehicleId", _vehicle getVariable [QEGVAR(database,vehicleId), ""]],
        ["netId", netId _vehicle],
        ["plate", [_vehicle] call FUNC(getVehiclePlate)],
        ["ownerId", _ownerId],
        ["className", typeOf _vehicle],
        ["displayName", getText (configOf _vehicle >> "displayName")],
        ["isWanted", false],
        ["wantedReason", ""],
        ["notes", ""]
    ];

    [
        "vehicles",
        _record,
        {
            params ["_result", "_args", "_success"];
            _args params ["_vehicle", "_showResult"];
            if (!_success || {count _result < 2}) exitWith {
                if (_showResult) then {
                    [format ["<t color='#ff6666'>%1</t>", LLSTRING(Msg_VehicleRegistrationFailed)], 3.3, player, 12] call ace_common_fnc_displayTextStructured;
                };
            };
            if (_showResult) then {
                [_result select 1] call FUNC(showEncounterVehicle);
            };
        },
        [_vehicle, _showResult]
    ] call EFUNC(database,saveRecord);
};

private _driver = driver _vehicle;
if (isNull _driver) exitWith {
    [_vehicle, "", _showResult] call _saveVehicle;
};

[
    _driver,
    {
        params ["_record", "_args", "_found"];
        _args params ["_vehicle", "_saveVehicle", "_showResult"];
        if (_found) exitWith {
            [_vehicle, _record getOrDefault ["id", ""], _showResult] call _saveVehicle;
        };

        [
            driver _vehicle,
            createHashMap,
            {
                params ["_result", "_args", "_success"];
                _args params ["_vehicle", "_saveVehicle", "_showResult"];
                if (!_success || {count _result < 2}) exitWith {
                    if (_showResult) then {
                        [format ["<t color='#ff6666'>%1</t>", LLSTRING(Msg_DriverRegistrationFailed)], 3.3, player, 12] call ace_common_fnc_displayTextStructured;
                    };
                };
                [_vehicle, _result select 0, _showResult] call _saveVehicle;
            },
            [_vehicle, _saveVehicle, _showResult]
        ] call EFUNC(database,registerUnit);
    },
    [_vehicle, _saveVehicle, _showResult]
] call EFUNC(database,getPersonByUnit);
