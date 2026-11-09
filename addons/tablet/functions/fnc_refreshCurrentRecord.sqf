#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Refreshes the currently displayed person record from the database.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_refreshCurrentRecord;
 *
 * Public: No
 */

if (GVAR(currentRecordId) isEqualTo "") exitWith {};

[format ["Refreshing record %1...", GVAR(currentRecordId)], "loading"] call FUNC(setStatus);

[GVAR(currentRecordId), {
    params ["_record", "_args", "_found"];

    private _display = uiNamespace getVariable [QGVAR(display), displayNull];
    if (isNull _display) exitWith {};

    if (!_found || {count _record == 0}) exitWith {
        ["Failed to refresh record.", "error"] call FUNC(setStatus);
    };

    GVAR(currentRecord) = _record;
    [_record] call FUNC(updateRecordView);
    ["Record refreshed from server.", "success"] call FUNC(setStatus);
}] call EFUNC(database,getPerson);
