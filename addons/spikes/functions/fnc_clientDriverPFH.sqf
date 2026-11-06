#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Client check for player drivers to detect spike strips with zero latency.
 *
 * Arguments:
 * 0: Arguments <ARRAY>
 * 1: PFH Handle <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_args", "_handle"];

if (!GVAR(enableSpikes)) exitWith {};

private _veh = objectParent player;
if (isNull _veh || {driver _veh != player}) exitWith {};

private _vehPos = getPosATL _veh;
private _spikes = nearestObjects [_vehPos, [QGVAR(spikeStripDeployed)], 5];

{
    private _spike = _x;
    if (!isNull _spike && {alive _spike}) then {
        private _spikePos = getPosATL _spike;
        if (abs ((_vehPos select 2) - (_spikePos select 2)) < 1.8 && {_veh distance2D _spike < 3.2}) then {
            private _spikedVehicles = _spike getVariable [QGVAR(spikedVehicles), []];
            if !(_veh in _spikedVehicles) then {
                _spikedVehicles pushBack _veh;
                _spike setVariable [QGVAR(spikedVehicles), _spikedVehicles, true];

                // Puncture locally immediately on the player vehicle
                [_veh, _spike] call FUNC(punctureWheels);

                // Notify server of the hit
                [QGVAR(spikeHitServer), [_spike, _veh]] call CBA_fnc_serverEvent;
            };
        };
    };
} forEach _spikes;
