#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Checks if a unit can pick up / retrieve a deployed spike strip.
 *
 * Arguments:
 * 0: Spike strip object <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Whether unit can pick up <BOOL>
 *
 * Example:
 * [_spike, player] call kolmip_spikes_fnc_canPickup;
 *
 * Public: No
 */

params [
    ["_spike", objNull, [objNull]],
    ["_unit", player, [objNull]]
];

if (isNull _spike || {!alive _spike}) exitWith { false };
if (isNull _unit || {!alive _unit}) exitWith { false };
if (!isNull objectParent _unit) exitWith { false };
if (_unit getVariable ["ace_isUnconscious", false]) exitWith { false };
if (_unit distance _spike > 3.5) exitWith { false };

true
