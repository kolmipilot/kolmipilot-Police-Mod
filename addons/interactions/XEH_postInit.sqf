#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if (isServer) then { };


if (hasInterface) then {
    if (GVAR(hideWeaponOnDismount)) then {
        player addEventHandler ["GetOutMan", {
            params ["_unit", "_role", "_vehicle", "_turret"];

            [{
                params ["_unit"];
                isNull objectParent _unit && { (animationState _unit) find "getout" == -1 }
            },
            {
                params ["_unit"];
                [{
                    params ["_unit"];
                    if (currentWeapon _unit != "") then {
                        if (!isNil "ace_weaponselect_fnc_putWeaponAway") then {
                            [_unit] call ace_weaponselect_fnc_putWeaponAway;
                        } else {
                            _unit action ["SwitchWeapon", _unit, _unit, 299];
                        };
                    };
                },
                [_unit],
                0.2
                ] call CBA_fnc_waitAndExecute;
            },
            [_unit],
            5 // Timeout 5 sekund na wypadek zablokowania animacji
            ] call CBA_fnc_waitUntilAndExecute;
        }];
    };
};
