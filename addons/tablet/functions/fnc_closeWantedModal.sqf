#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Closes the wanted warrant modal dialog.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_closeWantedModal;
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

(_display displayCtrl IDC_TABLET_MODAL_WANTED_BG) ctrlShow false;
(_display displayCtrl IDC_TABLET_MODAL_WANTED_GROUP) ctrlShow false;
