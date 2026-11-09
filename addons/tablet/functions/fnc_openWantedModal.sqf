#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Opens the modal dialog to update arrest warrant status.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_openWantedModal;
 *
 * Public: No
 */

if (GVAR(currentRecordId) isEqualTo "" || {count GVAR(currentRecord) == 0}) exitWith {};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _isWanted = GVAR(currentRecord) getOrDefault ["isWanted", false];
private _reason = GVAR(currentRecord) getOrDefault ["wantedReason", ""];

GVAR(modalWantedState) = _isWanted;

private _ctrlToggle = _display displayCtrl IDC_TABLET_MODAL_WANTED_CHECK;
if (_isWanted) then {
    _ctrlToggle ctrlSetText "STATUS: WANTED (Click to clear warrant)";
    _ctrlToggle ctrlSetBackgroundColor [0.65, 0.15, 0.15, 1];
} else {
    _ctrlToggle ctrlSetText "STATUS: NOT WANTED (Click to issue warrant)";
    _ctrlToggle ctrlSetBackgroundColor [0.15, 0.45, 0.25, 1];
};

private _ctrlReason = _display displayCtrl IDC_TABLET_MODAL_WANTED_REASON;
_ctrlReason ctrlSetText _reason;

(_display displayCtrl IDC_TABLET_MODAL_WANTED_BG) ctrlShow true;
(_display displayCtrl IDC_TABLET_MODAL_WANTED_GROUP) ctrlShow true;
