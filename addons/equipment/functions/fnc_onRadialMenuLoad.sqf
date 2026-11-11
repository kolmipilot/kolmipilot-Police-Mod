#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"

params [["_display", displayNull, [displayNull]]];

if (isNull _display || {isNull player}) exitWith {};

TRACE_2("Refreshing radial inventory for display=%1 player=%2",_display,player);

private _radialWeapons = [player] call FUNC(getRadialWeapons);
private _weaponClasses = _radialWeapons apply {_x select 0};
private _currentWeaponIndex = _weaponClasses find (currentWeapon player);
uiNamespace setVariable [QGVAR(displayWeapons), _weaponClasses];

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
private _fallbackIds = [
    IDC_RADIAL_FALLBACK_01,
    IDC_RADIAL_FALLBACK_02,
    IDC_RADIAL_FALLBACK_03,
    IDC_RADIAL_FALLBACK_04,
    IDC_RADIAL_FALLBACK_05,
    IDC_RADIAL_FALLBACK_06,
    IDC_RADIAL_FALLBACK_07,
    IDC_RADIAL_FALLBACK_08
];
private _slotCount = count _slotIds;
private _weaponCount = count _weaponClasses;

{
    private _control = _display displayCtrl _x;
    TRACE_2("Radial slot idc=%1 missing=%2",_x,isNull _control);
    _control ctrlShow false;
    _control ctrlEnable false;
    (_display displayCtrl (_fallbackIds select _forEachIndex)) ctrlSetText "";
} forEach _slotIds;

private _center = _display displayCtrl IDC_RADIAL_CENTER;
TRACE_1("Radial center control missing=%1",isNull _center);
_center ctrlSetText format ["%1\n%2",_weaponCount,LLSTRING(Radial_Carried)];
TRACE_2("Radial controls=%1 carried handgun count=%2",_slotIds,_weaponCount);

private _emptyNotice = _display displayCtrl IDC_RADIAL_EMPTY;
private _overflowNotice = _display displayCtrl IDC_RADIAL_OVERFLOW;
_emptyNotice ctrlShow false;
_overflowNotice ctrlShow false;

if (_weaponCount isEqualTo 0) exitWith {
    private _emptyControl = _display displayCtrl (_slotIds select 0);
    _emptyControl ctrlShow false;
    _emptyNotice ctrlSetText LLSTRING(Radial_Empty);
    _emptyNotice ctrlShow true;
};

private _displayCount = _weaponCount min _slotCount;
if (_weaponCount > _slotCount) then {
    _displayCount = _slotCount - 1;
};

for "_index" from 0 to (_displayCount - 1) do {
    private _weaponClass = _weaponClasses select _index;
    private _displayName = getText (configFile >> "CfgWeapons" >> _weaponClass >> "displayName");

    if (_displayName isEqualTo "") then {
        _displayName = _weaponClass;
    };

    private _picture = getText (configFile >> "CfgWeapons" >> _weaponClass >> "picture");
    private _control = _display displayCtrl (_slotIds select _index);
    private _fallbackControl = _display displayCtrl (_fallbackIds select _index);
    _control ctrlSetText _picture;
    if (_picture isEqualTo "") then {
        _fallbackControl ctrlSetText _displayName;
    };
    _control ctrlSetTooltip _displayName;
    _control ctrlShow true;
    _control ctrlEnable true;
    TRACE_4("Showing equipment slot %1 class=%2 displayName=%3 picture=%4",_index,_weaponClass,_displayName,_picture);
};

if (_currentWeaponIndex >= 0 && {_currentWeaponIndex < _displayCount}) then {
    private _currentWeaponControl = _display displayCtrl (_slotIds select _currentWeaponIndex);
    ctrlSetFocus _currentWeaponControl;
};

if (_weaponCount > _slotCount) then {
    private _overflowControl = _display displayCtrl (_slotIds select (_slotCount - 1));
    _overflowControl ctrlSetText "";
    _overflowControl ctrlShow true;
    _overflowControl ctrlEnable false;
    _overflowNotice ctrlSetText format [LLSTRING(Radial_More),_weaponCount - _displayCount];
    _overflowNotice ctrlShow true;
};
