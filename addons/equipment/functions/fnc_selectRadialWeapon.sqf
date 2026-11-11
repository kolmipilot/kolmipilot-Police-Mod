#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"

params [["_control", controlNull, [controlNull]]];

if (isNull _control || {isNull player}) exitWith {false};

private _slotIds = [
    IDC_RADIAL_SLOT_01,
    IDC_RADIAL_SLOT_02,
    IDC_RADIAL_SLOT_03,
    IDC_RADIAL_SLOT_04,
    IDC_RADIAL_SLOT_05,
    IDC_RADIAL_SLOT_06,
    IDC_RADIAL_SLOT_07,
    IDC_RADIAL_SLOT_08
];
private _slotIndex = _slotIds find (ctrlIDC _control);
private _displayWeapons = uiNamespace getVariable [QGVAR(displayWeapons), []];

if (_slotIndex < 0 || {_slotIndex >= count _displayWeapons}) exitWith {false};

private _weaponClass = _displayWeapons select _slotIndex;
private _availableWeapons = [player] call FUNC(getRadialWeapons);
private _weaponIndex = _availableWeapons findIf {(_x select 0) isEqualTo _weaponClass};

if (_weaponIndex < 0) exitWith {
    TRACE_1("Selected weapon is no longer carried: %1",_weaponClass);
    [findDisplay IDD_RADIAL_MENU] call FUNC(onRadialMenuLoad);
    false
};

private _weaponData = _availableWeapons select _weaponIndex;
private _sourceContainer = _weaponData select 1;
private _weaponState = _weaponData select 2;
private _unit = player;
private _isHandgun = getNumber (configFile >> "CfgWeapons" >> _weaponClass >> "type")
    isEqualTo TYPE_WEAPON_HANDGUN;
private _currentWeapon = if (_isHandgun) then {
    handgunWeapon _unit
} else {
    primaryWeapon _unit
};
private _selectWeapon = {
    params ["_unit", "_weaponClass"];

    private _muzzles = getArray (configFile >> "CfgWeapons" >> _weaponClass >> "muzzles");
    private _muzzle = _weaponClass;
    if (count _muzzles > 1) then {
        _muzzle = _muzzles select 0;
    };

    _unit selectWeapon _muzzle;
};

if (isNull _sourceContainer) exitWith {
    TRACE_1("Selecting already-carried weapon: %1",_weaponClass);
    [_unit, _weaponClass] call _selectWeapon;
    closeDialog 0;
    true
};

private _currentState = [];
if (_currentWeapon isNotEqualTo "") then {
    private _currentWeaponIndex = (weaponsItems _unit) findIf {(_x param [0, ""]) isEqualTo _currentWeapon};
    if (_currentWeaponIndex >= 0) then {
        _currentState = (weaponsItems _unit) select _currentWeaponIndex;
    };
};

if (_currentWeapon isNotEqualTo "" && {_currentState isEqualTo []}) exitWith {
    TRACE_1("Cannot preserve current weapon state: %1",_currentWeapon);
    false
};

TRACE_3("Attempting weapon swap: current=%1 selected=%2 container=%3",_currentWeapon,_weaponClass,_sourceContainer);

private _addWeaponState = {
    params ["_targetUnit", "_state"];
    _state params ["_class", "_muzzle", "_pointer", "_optic", "_magazine", "_secondaryMagazine", "_bipod"];

    _targetUnit addWeapon _class;
    if !(_class in weapons _targetUnit) exitWith {false};

    {
        if (_x isEqualType "" && _x isNotEqualTo "") then {
            _targetUnit addWeaponItem [_class, _x, true];
        };
    } forEach [_muzzle, _pointer, _optic, _bipod];

    {
        if (
            _x isEqualType []
            && {count _x >= 2}
            && {(_x select 0) isEqualType ""}
            && {(_x select 0) isNotEqualTo ""}
        ) then {
            _targetUnit addWeaponItem [_class, [_x select 0, _x select 1], true];
        };
    } forEach [_magazine, _secondaryMagazine];

    (weaponsItems _targetUnit) findIf {_x isEqualTo _state} >= 0
};

if !([_unit, _weaponState] call _addWeaponState) exitWith {
    _unit removeWeapon _weaponClass;
    TRACE_1("Failed to add selected weapon to unit: %1",_weaponClass);
    false
};

private _removedSelected = [_sourceContainer, _weaponClass, 1, false] call CBA_fnc_removeWeaponCargo;
if (!_removedSelected) exitWith {
    _unit removeWeapon _weaponClass;
    TRACE_1("Failed to remove selected weapon from cargo: %1",_weaponClass);
    false
};

private _swapCompleted = true;
if (_currentWeapon isNotEqualTo "") then {
    _sourceContainer addWeaponWithAttachmentsCargoGlobal [_currentState, 1];
    private _storedCurrent = (weaponsItemsCargo _sourceContainer) findIf {
        _x isEqualTo _currentState
    };

    if (_storedCurrent < 0) then {
        _sourceContainer addWeaponWithAttachmentsCargoGlobal [_weaponState, 1];
        private _restoredSelected = (weaponsItemsCargo _sourceContainer) findIf {
            _x isEqualTo _weaponState
        };
        if (_restoredSelected < 0) then {
            TRACE_2("Cannot store current weapon or restore selected cargo weapon; selected weapon remains on unit. current=%1 selected=%2",_currentWeapon,_weaponClass);
        } else {
            _unit removeWeapon _weaponClass;
            TRACE_2("Cannot store current weapon; restored selected cargo weapon. current=%1 selected=%2",_currentWeapon,_weaponClass);
        };
        [findDisplay IDD_RADIAL_MENU] call FUNC(onRadialMenuLoad);
        _swapCompleted = false;
    } else {
        _unit removeWeapon _currentWeapon;
        private _equippedWeapon = if (_isHandgun) then {
            handgunWeapon _unit
        } else {
            primaryWeapon _unit
        };
        if (_equippedWeapon isEqualTo _currentWeapon) then {
            [_sourceContainer, _currentWeapon, 1, false] call CBA_fnc_removeWeaponCargo;
            _sourceContainer addWeaponWithAttachmentsCargoGlobal [_weaponState, 1];
            _unit removeWeapon _weaponClass;
            TRACE_1("Failed to remove replaced weapon from unit: %1",_currentWeapon);
            _swapCompleted = false;
        };
    };
};

if (!_swapCompleted) exitWith {false};

[_unit, _weaponClass] call _selectWeapon;
TRACE_2("Weapon swap completed: old=%1 new=%2",_currentWeapon,_weaponClass);
closeDialog 0;
true
