#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Returns the vehicle's recorded or optional Ivory plate.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Plate, or empty string to request a server-generated plate <STRING>
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];
if (isNull _vehicle) exitWith { "" };

private _plate = _vehicle getVariable [QEGVAR(database,plate), ""];
if (_plate isNotEqualTo "") exitWith { _plate };

if (isClass (configFile >> "CfgPatches" >> "ivory_data")) then {
    _plate = [_vehicle] call compile "getPlateNumber (_this select 0)";
    if !(_plate isEqualType "") then {
        _plate = "";
    };
};

_plate
