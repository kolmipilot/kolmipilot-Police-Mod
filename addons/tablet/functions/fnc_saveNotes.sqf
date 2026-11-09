#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Saves roleplay notes for the currently selected person.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_saveNotes;
 *
 * Public: No
 */

if (GVAR(currentRecordId) isEqualTo "" || {count GVAR(currentRecord) == 0}) exitWith {};
if (GVAR(isSaving)) exitWith {};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _group = _display displayCtrl IDC_TABLET_RECORD_GROUP;
private _notesCtrl = _group controlsGroupCtrl IDC_TABLET_RECORD_NOTES;
private _newNotes = ctrlText _notesCtrl;

GVAR(currentRecord) set ["notes", _newNotes];

GVAR(isSaving) = true;
[LLSTRING(Status_Saving), "loading"] call FUNC(setStatus);

[GVAR(currentRecord), {
    params ["_res", "_args", "_success"];

    GVAR(isSaving) = false;

    if (!_success) exitWith {
        ["Failed to save notes on server.", "error"] call FUNC(setStatus);
    };

    [LLSTRING(Status_Saved), "success"] call FUNC(setStatus);
}] call EFUNC(database,savePerson);
