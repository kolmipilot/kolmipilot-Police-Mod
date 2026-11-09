#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Toggles the warrant state within the wanted modal dialog.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_toggleModalWantedState;
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

GVAR(modalWantedState) = !GVAR(modalWantedState);

private _ctrlToggle = _display displayCtrl IDC_TABLET_MODAL_WANTED_CHECK;
if (GVAR(modalWantedState)) then {
    _ctrlToggle ctrlSetText "STATUS: WANTED (Click to clear warrant)";
    _ctrlToggle ctrlSetBackgroundColor [0.65, 0.15, 0.15, 1];
} else {
    _ctrlToggle ctrlSetText "STATUS: NOT WANTED (Click to issue warrant)";
    _ctrlToggle ctrlSetBackgroundColor [0.15, 0.45, 0.25, 1];
};
