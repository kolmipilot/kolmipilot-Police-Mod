#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Handles database record changed events to refresh active tablet views.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Record ID <STRING>
 * 2: Action ("save"|"delete") <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["persons", "P_1001", "save"] call kolmip_tablet_fnc_onRecordChanged;
 *
 * Public: No
 */

params [
    ["_tableName", "", [""]],
    ["_recordId", "", [""]],
    ["_action", "save", [""]]
];

if (_tableName isNotEqualTo "persons") exitWith {};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

// If currently viewing the changed record, refresh it
if (_recordId isEqualTo GVAR(currentRecordId)) then {
    if (_action isEqualTo "delete") then {
        GVAR(currentRecord) = createHashMap;
        GVAR(currentRecordId) = "";
        (_display displayCtrl 78430) ctrlShow false;
        (_display displayCtrl 78431) ctrlShow true;
        ["Viewed record was deleted from database.", "warning"] call FUNC(setStatus);
    } else {
        call FUNC(refreshCurrentRecord);
    };
};
