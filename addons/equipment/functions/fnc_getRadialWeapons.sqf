#include "..\script_component.hpp"

params [["_unit", player, [objNull]]];

if (isNull _unit) exitWith {[]};

private _weapons = [];
private _unitWeaponItems = weaponsItems _unit;
private _isSupportedWeapon = {
    params ["_weaponClass"];

    _weaponClass isNotEqualTo ""
    && {isClass (configFile >> "CfgWeapons" >> _weaponClass)}
    && {
        getNumber (configFile >> "CfgWeapons" >> _weaponClass >> "type")
            in [TYPE_WEAPON_PRIMARY, TYPE_WEAPON_HANDGUN]
    }
};

{
    private _container = _x;
    if (!isNull _container) then {
        {
            private _weaponClass = _x param [0, "", [""]];
            if ([_weaponClass] call _isSupportedWeapon) then {
                private _index = _weapons findIf {(_x select 0) isEqualTo _weaponClass};
                if (_index < 0) then {
                    _weapons pushBack [_weaponClass, _container, _x];
                };
            };
        } forEach weaponsItemsCargo _container;

        private _weaponCargo = getWeaponCargo _container;
        private _weaponClasses = _weaponCargo param [0, []];
        private _weaponCounts = _weaponCargo param [1, []];

        {
            private _weaponClass = _x;
            if (
                [_weaponClass] call _isSupportedWeapon
                && {_weapons findIf {(_x select 0) isEqualTo _weaponClass} < 0}
            ) then {
                private _count = _weaponCounts param [_forEachIndex, 0];
                if (_count > 0) then {
                    _weapons pushBack [
                        _weaponClass,
                        _container,
                        [_weaponClass, "", "", "", [], [], ""]
                    ];
                };
            };
        } forEach _weaponClasses;
    };
} forEach [
    uniformContainer _unit,
    vestContainer _unit,
    backpackContainer _unit
];

{
    private _weaponClass = _x param [0, "", [""]];
    if ([_weaponClass] call _isSupportedWeapon) then {
        private _index = _weapons findIf {(_x select 0) isEqualTo _weaponClass};
        if (_index < 0) then {
            _weapons pushBack [_weaponClass, objNull, _x];
        };
    };
} forEach _unitWeaponItems;

TRACE_2("Available radial weapons for %1: %2",_unit,_weapons);
_weapons
