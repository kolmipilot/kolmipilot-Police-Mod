#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Registers a spike strip object in the active tracking list on the server.
 *
 * Arguments:
 * 0: Spike strip object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_spike] call kolmip_spikes_fnc_registerSpikeStripServer;
 *
 * Public: No
 */

params [["_spike", objNull, [objNull]]];

if (!isServer) exitWith {};
if (isNull _spike) exitWith {};

if (isNil QGVAR(activeSpikes)) then {
    GVAR(activeSpikes) = [];
};

GVAR(activeSpikes) pushBackUnique _spike;
