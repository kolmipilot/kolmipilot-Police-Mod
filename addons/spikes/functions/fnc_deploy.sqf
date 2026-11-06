#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Deploys a spike strip on the ground in front of the unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call kolmip_spikes_fnc_deploy;
 *
 * Public: Yes
 */

params [["_unit", player, [objNull]]];

if !([_unit] call FUNC(canDeploy)) exitWith {};

_unit setVariable [QGVAR(isDeploying), true];

// Play placement gesture
_unit playActionNow "PutDown";

// Remove one item from player inventory
_unit removeItem QGVAR(spikeStrip);

// Calculate position 4m in front of unit
private _pos = _unit getRelPos [4, 0];
_pos set [2, 0];
private _dir = getDir _unit + 90;

// Tell server to spawn and register the deployed spike strip
[QGVAR(deploySpikeStripServer), [_unit, _pos, _dir]] call CBA_fnc_serverEvent;

// Clear deploying cooldown flag after a brief animation pause
[
    {
        params ["_unit"];
        if (!isNull _unit) then {
            _unit setVariable [QGVAR(isDeploying), false];
        };
    },
    [_unit],
    1.5
] call CBA_fnc_waitAndExecute;
