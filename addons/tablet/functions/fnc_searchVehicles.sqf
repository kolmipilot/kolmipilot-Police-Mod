#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Searches registered vehicles and populates the shared result list.
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
if (isNull _display || GVAR(isSearching)) exitWith {};
GVAR(isSearching) = true;
private _searchTab = GVAR(currentTab);

private _criteria = createHashMap;
private _searchText = ctrlText (_display displayCtrl IDC_TABLET_SEARCH_INPUT);
if (_searchText isNotEqualTo "") then {
    _criteria set ["search", _searchText];
};

[LLSTRING(Status_Searching), "loading"] call FUNC(setStatus);
(_display displayCtrl IDC_TABLET_BTN_SEARCH) ctrlEnable false;

[_criteria, {
    params ["_records", "_args", "_success"];
    _args params ["_previousId", "_requestTab"];
    GVAR(isSearching) = false;

    private _display = uiNamespace getVariable [QGVAR(display), displayNull];
    if (isNull _display) exitWith {};
    if (_requestTab != GVAR(currentTab)) exitWith {
        call FUNC(searchPersons);
    };

    (_display displayCtrl IDC_TABLET_BTN_SEARCH) ctrlEnable true;
    private _list = _display displayCtrl IDC_TABLET_LIST_PERSONS;
    private _countControl = _display displayCtrl IDC_TABLET_RESULTS_COUNT;
    lbClear _list;

    if (!_success) exitWith {
        [LLSTRING(Status_Error), "error"] call FUNC(setStatus);
        _countControl ctrlSetText "Search failed";
        _countControl ctrlSetTextColor [1, 0.3, 0.3, 1];
    };

    private _selectedIndex = -1;
    {
        private _vehicle = _x;
        private _vehicleId = _vehicle getOrDefault ["vehicleId", ""];
        private _plate = _vehicle getOrDefault ["plate", "Unknown plate"];
        private _name = _vehicle getOrDefault ["displayName", _vehicle getOrDefault ["className", "Vehicle"]];
        private _owner = _vehicle getOrDefault ["ownerName", ""];
        private _isWanted = _vehicle getOrDefault ["isWanted", false];
        private _entry = if (_isWanted) then {
            format ["[WANTED] %1 | %2", _plate, _name]
        } else {
            format ["%1 | %2", _plate, _name]
        };
        if (_owner isNotEqualTo "") then {
            _entry = format ["%1 (%2)", _entry, _owner];
        };

        private _index = _list lbAdd _entry;
        _list lbSetData [_index, _vehicleId];
        _list lbSetColor [_index, if (_isWanted) then {[1, 0.35, 0.35, 1]} else {[0.9, 0.9, 0.9, 1]}];
        if (_vehicleId isEqualTo _previousId) then {
            _selectedIndex = _index;
        };
    } forEach _records;

    _countControl ctrlSetTextColor [0.7, 0.8, 0.9, 1];
    _countControl ctrlSetText format ["%1 records found", count _records];
    if (count _records == 0) then {
        [LLSTRING(Status_Empty), "warning"] call FUNC(setStatus);
        GVAR(currentVehicleId) = "";
        (_display displayCtrl IDC_TABLET_VEHICLE_EMPTY_NOTICE) ctrlShow true;
        (_display displayCtrl IDC_TABLET_VEHICLE_NAME) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_PLATE) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_OWNER) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_CLASS) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_STATUS) ctrlSetText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_WANTED_REASON) ctrlSetStructuredText parseText "";
        (_display displayCtrl IDC_TABLET_VEHICLE_NOTES) ctrlSetStructuredText parseText "";
    } else {
        [format ["Query returned %1 records", count _records], "success"] call FUNC(setStatus);
        if (_selectedIndex < 0) then {
            _selectedIndex = 0;
        };
        _list lbSetCurSel _selectedIndex;
    };
}, [GVAR(currentVehicleId), _searchTab]] call EFUNC(database,searchVehicles);
