#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Checks whether a unit can open the police tablet.
 *
 * Arguments:
 * 0: Unit to check <OBJECT> (Default: player)
 *
 * Return Value:
 * Whether unit can open tablet <BOOL>
 *
 * Example:
 * private _canOpen = [player] call kolmip_tablet_fnc_canOpenTablet;
 *
 * Public: Yes
 */

params [["_unit", player, [objNull]]];

if (isNull _unit || {!alive _unit}) exitWith { false };

// Must possess the police tablet in inventory or assigned items
private _hasTablet = (QGVAR(policeTablet) in (items _unit + assignedItems _unit));
if (!_hasTablet) exitWith { false };

// Must be authorized police officer (if authorization requirement is enabled)
if (EGVAR(database,requirePoliceAuth) && {!([_unit] call EFUNC(common,isPolice))}) exitWith { false };

true
