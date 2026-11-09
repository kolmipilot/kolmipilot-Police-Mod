#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Submits the updated wanted warrant status to the database.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_submitWantedModal;
 *
 * Public: No
 */

if (GVAR(currentRecordId) isEqualTo "") exitWith {};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _ctrlReason = _display displayCtrl IDC_TABLET_MODAL_WANTED_REASON;
private _reason = ctrlText _ctrlReason;

call FUNC(closeWantedModal);

[LLSTRING(Status_Saving), "loading"] call FUNC(setStatus);

[GVAR(currentRecordId), GVAR(modalWantedState), _reason, {
    params ["_res", "_args", "_success"];
    _args params ["_wantedState", "_wantedReason"];

    if (!_success) exitWith {
        ["Failed to update warrant status on server.", "error"] call FUNC(setStatus);
    };

    // Update local record and view
    GVAR(currentRecord) set ["isWanted", _wantedState];
    GVAR(currentRecord) set ["wantedReason", _wantedReason];
    [GVAR(currentRecord)] call FUNC(updateRecordView);

    [LLSTRING(Status_Saved), "success"] call FUNC(setStatus);

    // Refresh search list to update wanted tags / filter
    call FUNC(searchPersons);
}, [GVAR(modalWantedState), _reason]] call EFUNC(database,setWantedStatus);
