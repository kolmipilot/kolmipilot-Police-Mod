#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Punctures wheels on a vehicle. Executed locally on the vehicle's machine.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_car] call kolmip_spikes_fnc_punctureWheels;
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle || {!alive _vehicle}) exitWith {};
if !(_vehicle isKindOf "Car") exitWith {};

private _hitPointsData = getAllHitPointsDamage _vehicle;
if (_hitPointsData isEqualTo []) exitWith {};

private _hitPoints = _hitPointsData select 0;
private _punctureAll = GVAR(punctureAllWheels);
private _puncturedAny = false;

{
    private _lower = toLowerANSI _x;
    if ("wheel" in _lower || "kol" in _lower) then {
        if (_punctureAll || {"lf" in _lower || "rf" in _lower || "front" in _lower || random 1 > 0.4}) then {
            _vehicle setHitPointDamage [_x, 1, true];
            _vehicle setHitIndex [_forEachIndex, 1, true];
            _puncturedAny = true;
        };
    };
} forEach _hitPoints;

// Fallback for uncommon class configurations
if (!_puncturedAny) then {
    {
        _vehicle setHitPointDamage [_x, 1, true];
    } forEach [
        "HitLFWheel", "HitRFWheel",
        "HitLF2Wheel", "HitRF2Wheel",
        "HitLMWheel", "HitRMWheel",
        "HitLBWheel", "HitRBWheel"
    ];
};
