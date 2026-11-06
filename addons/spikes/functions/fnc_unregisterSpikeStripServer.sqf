#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Unregisters a spike strip object from server tracking.
 *
 * Arguments:
 * 0: Spike strip object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_spike] call kolmip_spikes_fnc_unregisterSpikeStripServer;
 *
 * Public: No
 */

params [["_spike", objNull, [objNull]]];

if (!isServer) exitWith {};
if (isNil QGVAR(activeSpikes)) exitWith {};

GVAR(activeSpikes) = GVAR(activeSpikes) - [_spike, objNull];
