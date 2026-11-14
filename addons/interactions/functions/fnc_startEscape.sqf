#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Function handles escape of a unit in a loop until police is lost or unit decides to fight back.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Dangerous (Aggression multiplier 0-10) <NUMBER> (default: 0)
 *
 * Return Value:
 * None
 *
 * Example:
 * [civ1, 5] call kolmip_interactions_fnc_startEscape;
 *
 * Public: No
 */
params ["_unit", ["_dangerous", 0]];

TRACE_2("startEscape called",_unit,_dangerous);

if (!alive _unit || {!local _unit}) exitWith {
    TRACE_3("startEscape exit - unit dead or not local",_unit,alive _unit,local _unit);
};

_dangerous = (_dangerous max 0) min 10;
_unit setVariable [QGVAR(escapeDangerous), _dangerous];
_unit setVariable [QGVAR(escapeCount), 0];

private _fnc_findNearestPolice = {
    params ["_unit", ["_searchRadius", 250]];

    private _nearUnits = ((allUnits - [_unit]) inAreaArray [getPosATL _unit, _searchRadius, _searchRadius, 0, false]) select {
        alive _x && {_x getVariable [QEGVAR(common,isPolice), false]}
    };

    TRACE_3("findNearestPolice scanning",_unit,count _nearUnits,QEGVAR(common,isPolice));

    if (_nearUnits isEqualTo []) exitWith {
        TRACE_1("findNearestPolice - no police found",_unit);
        objNull
    };

    private _sorted = _nearUnits apply {[_unit distanceSqr _x, _x]};
    _sorted sort true;
    private _police = (_sorted # 0) # 1;

    TRACE_3("findNearestPolice - found police",_unit,_police,objectParent _police);
    _police
};

private _fnc_triggerAttack = {
    params ["_unit", ["_dangerous", 1], ["_escapeCount", 0]];
    TRACE_3("triggerAttack called",_unit,_dangerous,_escapeCount);
    if (!alive _unit) exitWith {};
    private _inVeh = !isNull objectParent _unit;
    if (_inVeh) then {
        moveOut _unit;
        unassignVehicle _unit;
    };

    private _group = group _unit;
    for "_i" from (count waypoints _group - 1) to 0 step -1 do {
        deleteWaypoint [_group, _i];
    };

    _unit setVariable [QGVAR(escapeCount), nil];
    _unit setVariable [QGVAR(escapeDangerous), nil];

    private _pistolChance = ((_dangerous - 2) * 10) + (_escapeCount * 12);
    private _roll = random 100;
    TRACE_3("triggerAttack weapon roll",_unit,_pistolChance,_roll);

    if (_roll < _pistolChance) then {
        TRACE_1("triggerAttack -> FUNC(attackPistol)",_unit);
        [_unit] call FUNC(attackPistol);
    } else {
        TRACE_1("triggerAttack -> FUNC(attackMeleFists)",_unit);
        [_unit] call FUNC(attackMeleFists);
    };
};

private _fnc_runWaypoint = {
    params ["_unit", ["_distance", 150], ["_searchRadius", 250]];

    TRACE_3("runWaypoint called",_unit,_distance,_searchRadius);

    if (!alive _unit || {!local _unit}) exitWith {
        TRACE_1("runWaypoint exit - dead or not local",_unit);
    };

    private _nearestPolice = [_unit, _searchRadius] call _fnc_findNearestPolice;

    if (isNull _nearestPolice) exitWith {
        TRACE_1("runWaypoint - police lost, calming down",_unit);
        _unit setBehaviour "SAFE";
        _unit setSpeedMode "LIMITED";
        _unit setVariable [QGVAR(escapeCount), nil];
        _unit setVariable [QGVAR(escapeDangerous), nil];
    };

    private _dangerous = _unit getVariable [QGVAR(escapeDangerous), 0];
    private _escapeCount = _unit getVariable [QGVAR(escapeCount), 0];
    private _shouldAttack = false;

    if (_dangerous > 0) then {
        private _corneredBonus = [0, 25] select ((_unit distance _nearestPolice) < 15);
        private _attackChance = (_dangerous * (3 + (_escapeCount * 2.5))) + _corneredBonus;
        private _roll = random 100;

        TRACE_4("runWaypoint aggression check",_unit,_escapeCount,_attackChance,_roll);

        if (_roll < _attackChance) then {
            _shouldAttack = true;
        };
    };

    if (_shouldAttack) exitWith {
        [_unit, _dangerous, _escapeCount] call _fnc_triggerAttack;
    };

    _unit setVariable [QGVAR(escapeCount), _escapeCount + 1];

    private _dirAway = _nearestPolice getDir _unit;
    private _escapePos = _unit getPos [_distance, _dirAway];

    if (surfaceIsWater _escapePos) then {
        private _safePos = [_escapePos, 0, 50, 1, 0, 0, 0] call BIS_fnc_findSafePos;
        if (_safePos isNotEqualTo []) then {
            _escapePos = _safePos;
        };
    };

    TRACE_3("runWaypoint creating waypoint",_unit,_dirAway,_escapePos);

    private _group = group _unit;
    for "_i" from (count waypoints _group - 1) to 0 step -1 do {
        deleteWaypoint [_group, _i];
    };

    _unit enableAI "PATH";
    _unit enableAI "MOVE";

    private _wp = _group addWaypoint [_escapePos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointSpeed "FULL";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "BLUE";
    _wp setWaypointCompletionRadius 8;

    _unit setVariable [QGVAR(escapeStepFnc), _fnc_runWaypoint];
    _unit setVariable [QGVAR(escapeHelpers), [_fnc_findNearestPolice, _fnc_triggerAttack]];

    _wp setWaypointStatements [
        "true",
        format [
            "if (!isNil 'this' && {alive this}) then { private _helpers = this getVariable ['%1', [{objNull}, {}]]; private _fnc_findNearestPolice = _helpers # 0; private _fnc_triggerAttack = _helpers # 1; private _fnc_runWaypoint = this getVariable ['%2', {}]; private _dist = [150, 300] select (!isNull objectParent this); [this, _dist, 250] call _fnc_runWaypoint; };",
            QGVAR(escapeHelpers),
            QGVAR(escapeStepFnc)
        ]
    ];

    _group setCurrentWaypoint _wp;
    TRACE_2("runWaypoint waypoint assigned",_unit,waypoints _group);
};

private _inVeh = !isNull objectParent _unit;
TRACE_2("startEscape vehicle check",_unit,_inVeh);

if (_inVeh) then {
    if (random 100 > 80) then {
        TRACE_1("startEscape ejecting from vehicle",_unit);
        moveOut _unit;
        unassignVehicle _unit;
        [
            {
                params ["_unit", "_fnc_runWaypoint", "_fnc_findNearestPolice", "_fnc_triggerAttack"];
                [_unit, 150, 250] call _fnc_runWaypoint;
            },
            [_unit, _fnc_runWaypoint, _fnc_findNearestPolice, _fnc_triggerAttack],
            0.5
        ] call CBA_fnc_waitAndExecute;
    } else {
        [_unit, 300, 250] call _fnc_runWaypoint;
    };
} else {
    [_unit, 150, 250] call _fnc_runWaypoint;
};
