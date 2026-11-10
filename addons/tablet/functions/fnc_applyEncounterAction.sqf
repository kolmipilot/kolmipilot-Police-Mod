#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Applies a server-approved stop or wanted-person reaction on the AI's local machine.
 *
 * Arguments:
 * 0: Action <STRING>
 * 1: Target <OBJECT>
 * 2: Officer <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [
    ["_action", "", [""]],
    ["_target", objNull, [objNull]],
    ["_officer", objNull, [objNull]]
];
if (isNull _target || {!local _target} || {!alive _target}) exitWith {};

switch (_action) do {
    case "stop": {
        if (_target isKindOf "CAManBase") then {
            if (!isPlayer _target) then {
                doStop _target;
            };
        } else {
            private _driver = driver _target;
            if (!isNull _driver && {!isPlayer _driver} && {local _driver}) then {
                doStop _driver;
            };
        };
    };
    case "release": {
        if (_target isKindOf "CAManBase") then {
            if (!isPlayer _target) then {
                _target doFollow (leader group _target);
                _target doMove (_target getPos [15, getDir _target]);
            };
        } else {
            private _driver = driver _target;
            if (!isNull _driver && {!isPlayer _driver} && {local _driver}) then {
                _driver doFollow (leader group _driver);
                _driver doMove (_target getPos [50, getDir _target]);
            };
        };
    };
    case "flee": {
        if (_target isKindOf "CAManBase" && {!isPlayer _target}) then {
            private _awayDirection = (_target getDir _officer) + 180;
            private _destination = _target getPos [35, _awayDirection];
            _target doMove _destination;
        };
    };
    case "hostile": {
        if (_target isKindOf "CAManBase" && {!isPlayer _target} && {!isNull _officer}) then {
            private _group = createGroup east;
            [_target] joinSilent _group;
            _group setBehaviour "COMBAT";
            _group setCombatMode "RED";
            _target setCaptive false;

            private _weapon = primaryWeapon _target;
            if (_weapon isEqualTo "") then {
                _weapon = handgunWeapon _target;
            };
            if (_weapon isNotEqualTo "") then {
                _target selectWeapon _weapon;
                _target reveal [_officer, 4];
                _target doTarget _officer;
                _target doFire _officer;
            };
        };
    };
};
