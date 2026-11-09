#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Closes the crime modal dialog.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_closeCrimeModal;
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

(_display displayCtrl IDC_TABLET_MODAL_CRIME_BG) ctrlShow false;
(_display displayCtrl IDC_TABLET_MODAL_CRIME_GROUP) ctrlShow false;
