#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Updates the status bar in the police tablet interface.
 *
 * Arguments:
 * 0: Message text <STRING>
 * 1: Status level ("info"|"loading"|"success"|"error"|"warning") <STRING> (Default: "info")
 *
 * Return Value:
 * None
 *
 * Example:
 * ["Querying database...", "loading"] call kolmip_tablet_fnc_setStatus;
 *
 * Public: No
 */

params [
    ["_message", "", [""]],
    ["_type", "info", [""]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _ctrlStatus = _display displayCtrl IDC_TABLET_STATUS_BAR;
private _ctrlSpinner = _display displayCtrl IDC_TABLET_SPINNER;

private _color = switch (toLower _type) do {
    case "loading": { [1.0, 0.85, 0.2, 1] };
    case "success": { [0.3, 0.9, 0.4, 1] };
    case "error":   { [1.0, 0.3, 0.3, 1] };
    case "warning": { [1.0, 0.6, 0.2, 1] };
    default         { [0.7, 0.8, 0.9, 1] };
};

_ctrlStatus ctrlSetTextColor _color;
_ctrlStatus ctrlSetText _message;

if (_type isEqualTo "loading") then {
    _ctrlSpinner ctrlSetText "[...]";
    _ctrlSpinner ctrlSetTextColor [1.0, 0.85, 0.2, 1];
} else {
    _ctrlSpinner ctrlSetText "";
};
