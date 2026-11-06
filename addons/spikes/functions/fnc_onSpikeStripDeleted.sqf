#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Called when a deployed spike strip object is deleted.
 *
 * Arguments:
 * 0: Spike strip object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_spike] call kolmip_spikes_fnc_onSpikeStripDeleted;
 *
 * Public: No
 */

params [["_spike", objNull, [objNull]]];

if (isServer) then {
    [_spike] call FUNC(unregisterSpikeStripServer);
};
