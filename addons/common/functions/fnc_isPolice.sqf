#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Checks whether a unit is an authorized police officer.
 *
 * Arguments:
 * 0: Unit to check <OBJECT>
 *
 * Return Value:
 * Whether unit is police officer <BOOL>
 *
 * Example:
 * private _isOfficer = [player] call kolmip_common_fnc_isPolice;
 *
 * Public: Yes
 */

params [["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith { false };

if (isServer) exitWith {
    _unit in (missionNamespace getVariable [QGVAR(policeUnits), []])
};

_unit getVariable [QGVAR(isPolice), false]
