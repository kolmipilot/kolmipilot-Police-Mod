#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Initializes a deployed spike strip object (scroll actions, server registration).
 *
 * Arguments:
 * 0: Spike strip object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_spike] call kolmip_spikes_fnc_initSpikeStripObject;
 *
 * Public: No
 */

params [["_spike", objNull, [objNull]]];

if (isNull _spike) exitWith {};

// Client scroll action for pickup
if (hasInterface) then {
    _spike addAction [
        LLSTRING(Action_Pickup),
        {
            params ["_target", "_caller"];
            [_target, _caller] call FUNC(pickup);
        },
        nil,
        1.5,
        true,
        true,
        "",
        "[_target, _this] call " + QFUNC(canPickup),
        3.5
    ];
};

if (isServer) then {
    [_spike] call FUNC(registerSpikeStripServer);
};
