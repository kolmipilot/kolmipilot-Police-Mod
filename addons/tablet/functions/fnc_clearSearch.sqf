#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Clears the person search field and refreshes the results.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

(_display displayCtrl IDC_TABLET_SEARCH_INPUT) ctrlSetText "";
call FUNC(searchPersons);
