#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Sets the police officer status of a unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Is police officer <BOOL> (Default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true] call kolmip_common_fnc_setPolice;
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]],
    ["_isPolice", true, [true]]
];

if (!isServer || {isNull _unit}) exitWith {};

private _policeUnits = missionNamespace getVariable [QGVAR(policeUnits), []];
if (_isPolice) then {
    _policeUnits pushBackUnique _unit;
} else {
    _policeUnits = _policeUnits - [_unit];
};
missionNamespace setVariable [QGVAR(policeUnits), _policeUnits];
_unit setVariable [QGVAR(isPolice), _isPolice, true];
