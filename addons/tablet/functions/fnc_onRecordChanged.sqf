#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
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

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

if (_tableName isEqualTo "vehicles") exitWith {
    if (GVAR(currentTab) != 2) exitWith {};
    if (_recordId isEqualTo GVAR(currentVehicleId)) then {
        if (_action isEqualTo "delete") then {
            GVAR(currentVehicleId) = "";
            (_display displayCtrl IDC_TABLET_VEHICLE_EMPTY_NOTICE) ctrlShow true;
        } else {
            ["vehicles", _recordId, {
                params ["_record", "_args", "_found"];
                if (_found) then {
                    [_record] call FUNC(updateVehicleRecordView);
                };
            }] call EFUNC(database,getRecord);
        };
    };
    call FUNC(searchVehicles);
};

if (_tableName isNotEqualTo "persons") exitWith {};

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
