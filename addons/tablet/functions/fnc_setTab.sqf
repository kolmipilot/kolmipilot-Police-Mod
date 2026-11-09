#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Switches tabs in the police tablet interface.
 *
 * Arguments:
 * 0: Tab index (0: Persons, 1: Wanted, 2: Vehicles) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1] call kolmip_tablet_fnc_setTab;
 *
 * Public: No
 */

params [["_tabIndex", 0, [0]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

GVAR(currentTab) = _tabIndex;

private _tabPersons = _display displayCtrl IDC_TABLET_TAB_PERSONS;
private _tabWanted = _display displayCtrl IDC_TABLET_TAB_WANTED;
private _tabVehicles = _display displayCtrl IDC_TABLET_TAB_VEHICLES;

private _activeColor = [0.15, 0.35, 0.60, 1];
private _inactiveColor = [0.10, 0.18, 0.28, 1];

_tabPersons ctrlSetBackgroundColor ([_inactiveColor, _activeColor] select (_tabIndex == 0));
_tabWanted ctrlSetBackgroundColor ([_inactiveColor, _activeColor] select (_tabIndex == 1));
_tabVehicles ctrlSetBackgroundColor ([_inactiveColor, _activeColor] select (_tabIndex == 2));

(_display displayCtrl IDC_TABLET_SEARCH_INPUT) ctrlShow true;
(_display displayCtrl IDC_TABLET_BTN_SEARCH) ctrlShow true;
(_display displayCtrl IDC_TABLET_BTN_CLEAR) ctrlShow true;
(_display displayCtrl IDC_TABLET_FILTER_WANTED) ctrlShow (_tabIndex != 2);
(_display displayCtrl IDC_TABLET_LIST_PERSONS) ctrlShow true;
(_display displayCtrl IDC_TABLET_RESULTS_COUNT) ctrlShow true;

private _vehiclesGroup = _display displayCtrl IDC_TABLET_VEHICLES_GROUP;
_vehiclesGroup ctrlShow (_tabIndex == 2);

if (_tabIndex == 2) then {
    (_display displayCtrl IDC_TABLET_RECORD_GROUP) ctrlShow false;
    (_display displayCtrl IDC_TABLET_RECORD_EMPTY_NOTICE) ctrlShow false;
    if (GVAR(currentVehicleId) isEqualTo "") then {
        (_display displayCtrl IDC_TABLET_VEHICLE_EMPTY_NOTICE) ctrlShow true;
    };
} else {
    if (_tabIndex == 1) then {
        GVAR(filterWantedOnly) = true;
        (_display displayCtrl IDC_TABLET_FILTER_WANTED) ctrlSetText LLSTRING(Filter_ShowWanted);
    } else {
        GVAR(filterWantedOnly) = false;
        (_display displayCtrl IDC_TABLET_FILTER_WANTED) ctrlSetText LLSTRING(Filter_ShowAll);
    };

    // If currently showing a record, keep it; else show empty notice
    if (GVAR(currentRecordId) isNotEqualTo "") then {
        (_display displayCtrl IDC_TABLET_RECORD_GROUP) ctrlShow true;
        (_display displayCtrl IDC_TABLET_RECORD_EMPTY_NOTICE) ctrlShow false;
    } else {
        (_display displayCtrl IDC_TABLET_RECORD_GROUP) ctrlShow false;
        (_display displayCtrl IDC_TABLET_RECORD_EMPTY_NOTICE) ctrlShow true;
    };

    call FUNC(searchPersons);
};
