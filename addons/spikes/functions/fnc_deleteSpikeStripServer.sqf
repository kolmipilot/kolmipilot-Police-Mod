#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Unregisters and deletes a spike strip object on the server.
 *
 * Arguments:
 * 0: Spike strip object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_spike] call kolmip_spikes_fnc_deleteSpikeStripServer;
 *
 * Public: No
 */

params [["_spike", objNull, [objNull]]];

if (!isServer) exitWith {};
if (isNull _spike) exitWith {};

[_spike] call FUNC(unregisterSpikeStripServer);
deleteVehicle _spike;
