#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Checks if a unit can deploy a spike strip.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Whether unit can deploy <BOOL>
 *
 * Example:
 * [player] call kolmip_spikes_fnc_canDeploy;
 *
 * Public: No
 */

params [["_unit", player, [objNull]]];

if (isNull _unit || {!alive _unit}) exitWith { false };
if (!isNull objectParent _unit) exitWith { false };
if (!GVAR(enableSpikes)) exitWith { false };
if (_unit getVariable ["ace_isUnconscious", false]) exitWith { false };
if (_unit getVariable [QGVAR(isDeploying), false]) exitWith { false };

[_unit, QGVAR(spikeStrip)] call FUNC(hasItem)
