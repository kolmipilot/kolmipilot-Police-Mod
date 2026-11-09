#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Toggles the "Wanted Only" filter in the persons registry list.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_toggleWantedFilter;
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

GVAR(filterWantedOnly) = !GVAR(filterWantedOnly);

private _btnFilter = _display displayCtrl IDC_TABLET_FILTER_WANTED;
if (GVAR(filterWantedOnly)) then {
    _btnFilter ctrlSetText LLSTRING(Filter_ShowWanted);
    _btnFilter ctrlSetBackgroundColor [0.45, 0.15, 0.15, 1];
} else {
    _btnFilter ctrlSetText LLSTRING(Filter_ShowAll);
    _btnFilter ctrlSetBackgroundColor [0.12, 0.15, 0.20, 1];
};

call FUNC(searchPersons);
