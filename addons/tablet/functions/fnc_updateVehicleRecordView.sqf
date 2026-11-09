#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Displays a vehicle's registration, owner and wanted status.
 *
 * Arguments:
 * 0: Vehicle record <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_record", createHashMap, [createHashMap]]];
private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display || {count _record == 0}) exitWith {};

(_display displayCtrl IDC_TABLET_VEHICLE_EMPTY_NOTICE) ctrlShow false;
(_display displayCtrl IDC_TABLET_VEHICLE_NAME) ctrlSetText (_record getOrDefault ["displayName", _record getOrDefault ["className", "Vehicle"]]);
(_display displayCtrl IDC_TABLET_VEHICLE_PLATE) ctrlSetText format ["%1: %2", LLSTRING(Vehicle_Plate), _record getOrDefault ["plate", ""]];
private _ownerName = _record getOrDefault ["ownerName", ""];
if (_ownerName isEqualTo "") then {
    _ownerName = LLSTRING(Vehicle_NoOwner);
};
(_display displayCtrl IDC_TABLET_VEHICLE_OWNER) ctrlSetText format ["%1: %2", LLSTRING(Vehicle_Owner), _ownerName];
(_display displayCtrl IDC_TABLET_VEHICLE_CLASS) ctrlSetText format ["%1: %2", LLSTRING(Vehicle_Class), _record getOrDefault ["className", ""]];

private _isWanted = _record getOrDefault ["isWanted", false];
private _status = if (_isWanted) then { LLSTRING(Vehicle_Wanted) } else { LLSTRING(Vehicle_Registered) };
private _statusControl = _display displayCtrl IDC_TABLET_VEHICLE_STATUS;
_statusControl ctrlSetText format ["%1: %2", LLSTRING(Vehicle_Status), _status];
_statusControl ctrlSetTextColor (if (_isWanted) then {[1, 0.35, 0.35, 1]} else {[0.45, 0.85, 0.55, 1]});

private _reason = _record getOrDefault ["wantedReason", ""];
(_display displayCtrl IDC_TABLET_VEHICLE_WANTED_REASON) ctrlSetStructuredText parseText (
    if (_reason isEqualTo "") then { "" } else { format ["<t color='#e07070'>%1: %2</t>", LLSTRING(Vehicle_WantedReason), _reason] }
);
private _notes = _record getOrDefault ["notes", ""];
(_display displayCtrl IDC_TABLET_VEHICLE_NOTES) ctrlSetStructuredText parseText (
    if (_notes isEqualTo "") then { "" } else { format ["<t color='#a0b0c0'>%1: %2</t>", LLSTRING(Vehicle_Notes), _notes] }
);
