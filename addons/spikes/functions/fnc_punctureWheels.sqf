#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Punctures wheels on a vehicle based on proximity to the spike strip.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Spike Strip <OBJECT>
 *
 * Return Value:
 * None
 */

params [["_vehicle", objNull, [objNull]], ["_spike", objNull, [objNull]]];

if (isNull _vehicle || {!alive _vehicle}) exitWith { TRACE_1("Vehicle invalid or dead",_vehicle); };
if (_vehicle isKindOf "Car" isEqualTo false) exitWith { TRACE_1("Vehicle is not a car",_vehicle); };

private _hitPointsData = getAllHitPointsDamage _vehicle;
if (_hitPointsData isEqualTo []) exitWith { TRACE_1("Vehicle has no hitpoints",_vehicle); };

private _hitPoints = _hitPointsData select 0;
private _hitSelections = _hitPointsData select 1;

TRACE_2("Processing puncture",_vehicle,_spike);

{
    private _hitPoint = _x;
    private _selection = _hitSelections select _forEachIndex;
    private _lower = toLowerANSI _hitPoint;

    if ("wheel" in _lower || "kol" in _lower) then {
        // Sprawdzamy czy koło jest już zniszczone (damage < 1 oznacza, że jest sprawne)
        if (_vehicle getHitPointDamage _hitPoint < 0.9) then {
            private _modelPos = _vehicle selectionPosition _selection;

            if (_modelPos isEqualTo [0,0,0]) then {
                _vehicle setHitPointDamage [_hitPoint, 1, true];
            } else {
                private _wheelPos = _vehicle modelToWorld _modelPos;
                private _dist = _wheelPos distance2D _spike;

                if (_dist < 2.5) then {
                    _vehicle setHitPointDamage [_hitPoint, 1, true];
                };
            };
        };
    };
} forEach _hitPoints;
