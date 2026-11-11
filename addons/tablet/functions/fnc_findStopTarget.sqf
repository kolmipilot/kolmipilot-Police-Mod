#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Finds the nearest person or vehicle in front of the officer.
 *
 * Arguments:
 * 0: Officer <OBJECT>
 *
 * Return Value:
 * Target <OBJECT>
 *
 * Public: No
 */

params [["_officer", objNull, [objNull]]];
if (isNull _officer) exitWith { objNull };

private _observer = vehicle _officer;
private _observerPosition = getPosWorld _observer;
private _forward = vectorDir _observer;
private _maxDistance = [GVAR(maxStopDistanceInVehicle), GVAR(maxStopDistanceOnFoot)] select (_observer isEqualTo _officer);
private _candidates = nearestObjects [_observer, ["CAManBase", "AllVehicles"], _maxDistance, true];
private _closestTarget = objNull;
private _closestDistance = _maxDistance;

{
    private _candidate = _x;
    private _isPersonOnFoot = _candidate isKindOf "CAManBase"
        && {!(_candidate isKindOf "Animal")}
        && {alive _candidate}
        && {vehicle _candidate isEqualTo _candidate}
        && _candidate isNotEqualTo _officer;
    private _hasPersonDriver = _candidate isKindOf "AllVehicles"
        && {!(_candidate isKindOf "CAManBase")}
        && {alive _candidate}
        && {!((driver _candidate) isKindOf "Animal")}
        && {(driver _candidate) isKindOf "CAManBase"}
        && {alive (driver _candidate)};

    if (_candidate isNotEqualTo _observer && {_isPersonOnFoot || _hasPersonDriver}) then {
        private _offset = (getPosWorld _candidate) vectorDiff _observerPosition;
        private _distance = _observerPosition distance (getPosWorld _candidate);
        if ((_forward vectorDotProduct _offset) > 0 && _distance < _closestDistance) then {
            _closestTarget = _candidate;
            _closestDistance = _distance;
        };
    };
} forEach _candidates;

_closestTarget
