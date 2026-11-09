#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Cleans up UI state when the police tablet is closed.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_onDialogUnload;
 *
 * Public: No
 */

uiNamespace setVariable [QGVAR(display), displayNull];
GVAR(currentRecord) = createHashMap;
GVAR(currentRecordId) = "";
GVAR(isSearching) = false;
GVAR(isSaving) = false;
