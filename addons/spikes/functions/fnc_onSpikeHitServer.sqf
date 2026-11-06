#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Handles a spike hit reported to the server.
 *
 * Arguments:
 * 0: Spike strip object <OBJECT>
 * 1: Vehicle that hit it <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_spike, _veh] call kolmip_spikes_fnc_onSpikeHitServer;
 *
 * Public: No
 */

params [
    ["_spike", objNull, [objNull]],
    ["_veh", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _spike || {isNull _veh}) exitWith {};

private _spikedVehicles = _spike getVariable [QGVAR(spikedVehicles), []];
if !(_veh in _spikedVehicles) then {
    _spikedVehicles pushBack _veh;
    _spike setVariable [QGVAR(spikedVehicles), _spikedVehicles];
};

if (!GVAR(reusableAfterHit)) then {
    _spike setDamage 1;
};
