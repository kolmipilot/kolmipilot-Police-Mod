#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Checks whether the unit may use police encounter interactions.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Can use police actions <BOOL>
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];
if (isNull _unit || {!alive _unit}) exitWith { false };
if (!EGVAR(database,requirePoliceAuth)) exitWith { true };
[_unit] call EFUNC(common,isPolice)
