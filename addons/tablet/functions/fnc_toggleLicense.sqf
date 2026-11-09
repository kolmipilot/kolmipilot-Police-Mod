#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Toggles license status (driving or gun) for the currently selected person.
 *
 * Arguments:
 * 0: License toggle control ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [IDC_TABLET_BTN_TOGGLE_DRIVE] call kolmip_tablet_fnc_toggleLicense;
 *
 * Public: No
 */

params [["_controlIdc", -1, [0]]];

private _licKey = switch (_controlIdc) do {
    case IDC_TABLET_BTN_TOGGLE_DRIVE: { "drivingLicense" };
    case IDC_TABLET_BTN_TOGGLE_GUN: { "gunLicense" };
    default { "" };
};
if (_licKey isEqualTo "") exitWith {};

if (GVAR(currentRecordId) isEqualTo "" || {count GVAR(currentRecord) == 0}) exitWith {};
if (GVAR(isSaving)) exitWith {};

private _currentVal = GVAR(currentRecord) getOrDefault [_licKey, false];
private _newVal = !_currentVal;
GVAR(currentRecord) set [_licKey, _newVal];

// If person has an active unit in the world, update its local variable too
private _netId = GVAR(currentRecord) getOrDefault ["netId", ""];
if (_netId isNotEqualTo "") then {
    private _unit = objectFromNetId _netId;
    if (!isNull _unit) then {
        _unit setVariable [format ["kolmip_database_%1", _licKey], _newVal, true];
    };
};

GVAR(isSaving) = true;
[LLSTRING(Status_Saving), "loading"] call FUNC(setStatus);

// Update view optimistically
[GVAR(currentRecord)] call FUNC(updateRecordView);

[GVAR(currentRecord), {
    params ["_res", "_args", "_success"];
    _args params ["_key"];

    GVAR(isSaving) = false;

    if (!_success) exitWith {
        ["Failed to update license on server.", "error"] call FUNC(setStatus);
        call FUNC(refreshCurrentRecord);
    };

    [LLSTRING(Status_Saved), "success"] call FUNC(setStatus);
}, [_licKey]] call EFUNC(database,savePerson);
