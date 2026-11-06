#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Periodic server check that monitors vehicles driving over active spike strips.
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
if (isNil QGVAR(activeSpikes) || {GVAR(activeSpikes) isEqualTo []}) exitWith {};

// Clean dead or deleted spikes
GVAR(activeSpikes) = GVAR(activeSpikes) select {!isNull _x};

{
    private _spike = _x;
    if (alive _spike) then {
        private _spikePos = getPosATL _spike;
        private _nearbyVehicles = _spikePos nearEntities [["Car", "Motorcycle"], 8];

        {
            private _veh = _x;
            if (alive _veh && {abs (speed _veh) > 0.5}) then {
                private _vehPos = getPosATL _veh;
                if (abs ((_vehPos select 2) - (_spikePos select 2)) < 1.8 && {_veh distance2D _spike < 3.2}) then {
                    private _spikedVehicles = _spike getVariable [QGVAR(spikedVehicles), []];
                    if !(_veh in _spikedVehicles) then {
                        _spikedVehicles pushBack _veh;
                        _spike setVariable [QGVAR(spikedVehicles), _spikedVehicles];

                        // Target the vehicle's machine directly to puncture wheels locally
                        [QGVAR(punctureWheels), [_veh], _veh] call CBA_fnc_targetEvent;

                        if (!GVAR(reusableAfterHit)) then {
                            _spike setDamage 1;
                        };
                    };
                };
            };
        } forEach _nearbyVehicles;
    };
} forEach GVAR(activeSpikes);
