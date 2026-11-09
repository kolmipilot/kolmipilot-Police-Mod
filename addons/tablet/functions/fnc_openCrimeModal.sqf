#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Opens the modal dialog to file a criminal charge.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_openCrimeModal;
 *
 * Public: No
 */

if (GVAR(currentRecordId) isEqualTo "" || {count GVAR(currentRecord) == 0}) exitWith {};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

(_display displayCtrl IDC_TABLET_MODAL_CRIME_TITLE) ctrlSetText "";
(_display displayCtrl IDC_TABLET_MODAL_CRIME_SEV) lbSetCurSel 0;
(_display displayCtrl IDC_TABLET_MODAL_CRIME_NOTES) ctrlSetText "";

(_display displayCtrl IDC_TABLET_MODAL_CRIME_BG) ctrlShow true;
(_display displayCtrl IDC_TABLET_MODAL_CRIME_GROUP) ctrlShow true;
