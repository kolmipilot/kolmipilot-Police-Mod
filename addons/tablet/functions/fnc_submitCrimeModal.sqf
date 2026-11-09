#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Submits a new criminal charge for the current person.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_submitCrimeModal;
 *
 * Public: No
 */

if (GVAR(currentRecordId) isEqualTo "") exitWith {};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _title = ctrlText (_display displayCtrl IDC_TABLET_MODAL_CRIME_TITLE);
if (_title isEqualTo "") exitWith {
    ["Crime charge title cannot be empty.", "warning"] call FUNC(setStatus);
};

private _comboSev = _display displayCtrl IDC_TABLET_MODAL_CRIME_SEV;
private _curSel = lbCurSel _comboSev;
private _sev = if (_curSel >= 0) then { _comboSev lbValue _curSel } else { 1 };
if (_sev < 1 || {_sev > 5}) then { _sev = 1; };

private _notes = ctrlText (_display displayCtrl IDC_TABLET_MODAL_CRIME_NOTES);

call FUNC(closeCrimeModal);

[LLSTRING(Status_Saving), "loading"] call FUNC(setStatus);

[GVAR(currentRecordId), _title, _notes, _sev, {
    params ["_res", "_args", "_success"];

    if (!_success) exitWith {
        ["Failed to file criminal charge on server.", "error"] call FUNC(setStatus);
    };

    [LLSTRING(Status_CrimeAdded), "success"] call FUNC(setStatus);
    call FUNC(refreshCurrentRecord);
}] call EFUNC(database,addCrime);
