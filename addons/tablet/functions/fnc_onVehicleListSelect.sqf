#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Loads a selected vehicle registration record.
 *
 * Arguments:
 * 0: List control <CONTROL>
 * 1: Selected index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_control", "_selectedIndex"];
if (_selectedIndex < 0) exitWith {};
private _vehicleId = _control lbData _selectedIndex;
if (_vehicleId isEqualTo "") exitWith {};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};
[format ["Loading vehicle %1...", _vehicleId], "loading"] call FUNC(setStatus);

["vehicles", _vehicleId, {
    params ["_record", "_args", "_found"];
    _args params ["_expectedId"];
    private _display = uiNamespace getVariable [QGVAR(display), displayNull];
    if (isNull _display) exitWith {};
    if (!_found || {count _record == 0}) exitWith {
        [format ["Vehicle record '%1' not found.", _expectedId], "error"] call FUNC(setStatus);
        GVAR(currentVehicleId) = "";
        (_display displayCtrl IDC_TABLET_VEHICLE_EMPTY_NOTICE) ctrlShow true;
        (_display displayCtrl IDC_TABLET_VEHICLE_NAME) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_PLATE) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_OWNER) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_CLASS) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_STATUS) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_WANTED_REASON) ctrlSetStructuredText parseText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_NOTES) ctrlSetStructuredText parseText "";
    };

    GVAR(currentVehicleId) = _expectedId;
    [_record] call FUNC(updateVehicleRecordView);
    [format ["Vehicle %1 loaded.", _expectedId], "info"] call FUNC(setStatus);
}, [_vehicleId]] call EFUNC(database,getRecord);
