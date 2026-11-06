#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Retrieves / packs up a deployed spike strip object.
 *
 * Arguments:
 * 0: Spike strip object <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_spike, player] call kolmip_spikes_fnc_pickup;
 *
 * Public: Yes
 */

params [
    ["_spike", objNull, [objNull]],
    ["_unit", player, [objNull]]
];

if !([_spike, _unit] call FUNC(canPickup)) exitWith {};

_unit playActionNow "PutDown";

// Return item to player inventory or ground holder if inventory is full
if (_unit canAdd QGVAR(spikeStrip)) then {
    _unit addItem QGVAR(spikeStrip);
} else {
    private _holder = createVehicle ["GroundWeaponHolder", getPosATL _unit, [], 0, "CAN_COLLIDE"];
    _holder addItemCargoGlobal [QGVAR(spikeStrip), 1];
};

// Request server to remove and clean up the world object
[QGVAR(deleteSpikeStripServer), [_spike]] call CBA_fnc_serverEvent;
