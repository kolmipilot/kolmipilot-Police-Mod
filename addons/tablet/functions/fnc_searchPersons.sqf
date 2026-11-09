#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Searches persons asynchronously in the database based on UI criteria.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call kolmip_tablet_fnc_searchPersons;
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

if (GVAR(isSearching)) exitWith {};
GVAR(isSearching) = true;

private _ctrlInput = _display displayCtrl IDC_TABLET_SEARCH_INPUT;
private _queryText = ctrlText _ctrlInput;

private _criteria = createHashMap;

if (_queryText isNotEqualTo "") then {
    _criteria set ["search", _queryText];
};

if (GVAR(filterWantedOnly) || {GVAR(currentTab) == 1}) then {
    _criteria set ["isWanted", true];
};

[LLSTRING(Status_Searching), "loading"] call FUNC(setStatus);

private _btnSearch = _display displayCtrl IDC_TABLET_BTN_SEARCH;
_btnSearch ctrlEnable false;

[_criteria, {
    params ["_results", "_args", "_success"];
    _args params ["_prevId"];

    GVAR(isSearching) = false;

    private _display = uiNamespace getVariable [QGVAR(display), displayNull];
    if (isNull _display) exitWith {};

    private _btnSearch = _display displayCtrl IDC_TABLET_BTN_SEARCH;
    _btnSearch ctrlEnable true;

    if (!_success) exitWith {
        [LLSTRING(Status_Error), "error"] call FUNC(setStatus);
        private _ctrlCount = _display displayCtrl IDC_TABLET_RESULTS_COUNT;
        _ctrlCount ctrlSetText "Search failed";
        _ctrlCount ctrlSetTextColor [1, 0.3, 0.3, 1];
    };

    private _ctrlList = _display displayCtrl IDC_TABLET_LIST_PERSONS;
    lbClear _ctrlList;

    private _selectedIndex = -1;

    {
        private _rec = _x;
        private _id = _rec getOrDefault ["id", ""];
        private _fullName = _rec getOrDefault ["fullName", "Unknown"];
        private _isWanted = _rec getOrDefault ["isWanted", false];

        private _entryText = if (_isWanted) then {
            format ["[!] %1 (%2)", _fullName, _id]
        } else {
            format ["%1 (%2)", _fullName, _id]
        };

        private _idx = _ctrlList lbAdd _entryText;
        _ctrlList lbSetData [_idx, _id];

        if (_isWanted) then {
            _ctrlList lbSetColor [_idx, [1.0, 0.35, 0.35, 1]];
        } else {
            _ctrlList lbSetColor [_idx, [0.90, 0.90, 0.90, 1]];
        };

        if (_id isEqualTo _prevId) then {
            _selectedIndex = _idx;
        };
    } forEach _results;

    private _count = count _results;
    private _ctrlCount = _display displayCtrl IDC_TABLET_RESULTS_COUNT;
    _ctrlCount ctrlSetTextColor [0.7, 0.8, 0.9, 1];

    if (_count == 0) then {
        _ctrlCount ctrlSetText "0 records found";
        [LLSTRING(Status_Empty), "warning"] call FUNC(setStatus);
    } else {
        _ctrlCount ctrlSetText (format ["%1 records found", _count]);
        [format ["Query returned %1 records", _count], "success"] call FUNC(setStatus);
    };

    if (_selectedIndex != -1) then {
        _ctrlList lbSetCurSel _selectedIndex;
    };
}, [GVAR(currentRecordId)]] call EFUNC(database,searchPersons);
