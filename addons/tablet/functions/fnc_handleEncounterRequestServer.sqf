#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Validates police encounter requests and dispatches server-authoritative AI behavior.
 *
 * Arguments:
 * 0: Sender owner ID <NUMBER>
 * 1: Requesting officer <OBJECT>
 * 2: Target <OBJECT>
 * 3: Request type ("stop"|"release"|"wantedReaction") <STRING>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [
    ["_senderOwner", -1, [0]],
    ["_officer", objNull, [objNull]],
    ["_target", objNull, [objNull]],
    ["_requestType", "", [""]]
];
if (!isServer || {isNull _officer} || {isNull _target} || {!alive _officer} || {!alive _target}) exitWith {};
if (owner _officer != _senderOwner) exitWith {};
if (EGVAR(database,requirePoliceAuth) && {!([_officer] call EFUNC(common,isPolice))}) exitWith {};
private _observer = vehicle _officer;
private _maxDistance = [GVAR(maxStopDistanceInVehicle), GVAR(maxStopDistanceOnFoot)] select (_observer isEqualTo _officer);
if ((_observer distance _target) > _maxDistance) exitWith {};

switch (_requestType) do {
    case "stop": {
        private _isPersonOnFoot = _target isKindOf "CAManBase"
            && {!(_target isKindOf "Animal")}
            && {vehicle _target isEqualTo _target};
        private _hasPersonDriver = _target isKindOf "AllVehicles"
            && {!(_target isKindOf "CAManBase")}
            && {!((driver _target) isKindOf "Animal")}
            && {(driver _target) isKindOf "CAManBase"}
            && {alive (driver _target)};
        if !(_isPersonOnFoot || {_hasPersonDriver}) exitWith {};
        _target setVariable [QGVAR(stoppedForPolice), true, true];
        [QGVAR(applyEncounterAction), ["stop", _target, _officer]] call CBA_fnc_globalEvent;
    };
    case "release": {
        if !(_target getVariable [QGVAR(stoppedForPolice), false]) exitWith {};
        _target setVariable [QGVAR(stoppedForPolice), false, true];
        [QGVAR(applyEncounterAction), ["release", _target, _officer]] call CBA_fnc_globalEvent;
    };
    case "wantedReaction": {
        if (_officer distance _target > 40) exitWith {};
        if (!(_target isKindOf "CAManBase") || {isPlayer _target}) exitWith {};
        private _personId = _target getVariable [QEGVAR(database,personId), ""];
        private _person = createHashMap;
        if (_personId isNotEqualTo "") then {
            _person = ["persons", _personId] call EFUNC(database,getRecordServer);
        } else {
            private _personsTable = ["persons"] call EFUNC(database,getTableServer);
            if (isNil "_personsTable") exitWith {};
            {
                if ((_y getOrDefault ["netId", ""]) isEqualTo (netId _target)) exitWith {
                    _person = _y;
                };
            } forEach (_personsTable get "records");
        };
        if !(_person getOrDefault ["isWanted", false]) exitWith {};
        private _reaction = selectRandom ["ignore", "flee", "hostile"];
        [QGVAR(applyEncounterAction), [_reaction, _target, _officer]] call CBA_fnc_globalEvent;
    };
};
