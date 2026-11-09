#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Initializes the police tablet interface on dialog load.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * _display call kolmip_tablet_fnc_onDialogLoad;
 *
 * Public: No
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

uiNamespace setVariable [QGVAR(display), _display];

// State variables
GVAR(currentTab) = 0;
GVAR(filterWantedOnly) = false;
GVAR(currentRecord) = createHashMap;
GVAR(currentRecordId) = "";
GVAR(currentVehicleId) = "";
GVAR(modalWantedState) = false;
GVAR(isSearching) = false;
GVAR(isSaving) = false;

// Set officer info in header
private _officerName = name player;
private _officerRank = rank player;
private _officerText = if (_officerRank isNotEqualTo "") then {
    format ["%1 %2 | SECURE LINK", _officerRank, _officerName]
} else {
    format ["%1 | SECURE LINK", _officerName]
};
(_display displayCtrl IDC_TABLET_HEADER_OFFICER) ctrlSetText _officerText;

// Hide modals initially
(_display displayCtrl IDC_TABLET_MODAL_CRIME_BG) ctrlShow false;
(_display displayCtrl IDC_TABLET_MODAL_CRIME_GROUP) ctrlShow false;
(_display displayCtrl IDC_TABLET_MODAL_WANTED_BG) ctrlShow false;
(_display displayCtrl IDC_TABLET_MODAL_WANTED_GROUP) ctrlShow false;

// Hide Vehicles Tab group until selected.
(_display displayCtrl IDC_TABLET_VEHICLES_GROUP) ctrlShow false;
(_display displayCtrl IDC_TABLET_VEHICLE_EMPTY_NOTICE) ctrlShow true;

// Show Empty Notice initially, hide record group
(_display displayCtrl IDC_TABLET_RECORD_GROUP) ctrlShow false;
private _emptyNotice = _display displayCtrl IDC_TABLET_RECORD_EMPTY_NOTICE;
_emptyNotice ctrlShow true;
_emptyNotice ctrlSetStructuredText parseText "<t align='center' size='1.2' color='#657585'>Select a person from the registry list or enter a search query to view their police record.</t>";

// Populate Severity Combo in Crime Modal
private _comboSev = _display displayCtrl IDC_TABLET_MODAL_CRIME_SEV;
lbClear _comboSev;
_comboSev lbAdd "Level 1 - Minor Infraction (Speeding, Noise, Parking)";
_comboSev lbSetValue [0, 1];
_comboSev lbAdd "Level 2 - Misdemeanor (Trespassing, Disorderly Conduct)";
_comboSev lbSetValue [1, 2];
_comboSev lbAdd "Level 3 - Offense (Resisting Arrest, Possession)";
_comboSev lbSetValue [2, 3];
_comboSev lbAdd "Level 4 - Major Felony (Armed Robbery, Assault, Theft)";
_comboSev lbSetValue [3, 4];
_comboSev lbAdd "Level 5 - Capital Offense (Murder, Kidnapping, Terrorism)";
_comboSev lbSetValue [4, 5];
_comboSev lbSetCurSel 0;

// Set initial ready status
[LLSTRING(Status_Ready), "info"] call FUNC(setStatus);

// Initial query to populate registry
call FUNC(searchPersons);
