#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Populates the tablet record view with person data.
 *
 * Arguments:
 * 0: Person record HashMap <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_record] call kolmip_tablet_fnc_updateRecordView;
 *
 * Public: No
 */

params [["_record", createHashMap, [createHashMap]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display || {count _record == 0}) exitWith {};

// Hide empty notice, show record group
(_display displayCtrl IDC_TABLET_RECORD_EMPTY_NOTICE) ctrlShow false;
private _group = _display displayCtrl IDC_TABLET_RECORD_GROUP;
_group ctrlShow true;

private _id = _record getOrDefault ["id", ""];
private _fullName = _record getOrDefault ["fullName", "Unknown"];
private _isPlayer = _record getOrDefault ["isPlayer", false];
private _uid = _record getOrDefault ["uid", ""];
private _netId = _record getOrDefault ["netId", ""];
private _isWanted = _record getOrDefault ["isWanted", false];
private _wantedReason = _record getOrDefault ["wantedReason", ""];
private _drivingLic = _record getOrDefault ["drivingLicense", true];
private _gunLic = _record getOrDefault ["gunLicense", false];
private _vehicles = _record getOrDefault ["vehicles", []];
private _notes = _record getOrDefault ["notes", ""];
private _crimes = _record getOrDefault ["criminalRecord", []];

// Name Header
(_group controlsGroupCtrl IDC_TABLET_RECORD_NAME) ctrlSetText _fullName;

// Subtitle
private _typeStr = if (_isPlayer) then { format ["Player (UID: %1)", _uid] } else { "Civilian AI" };
private _netIdStr = if (_netId isNotEqualTo "") then { format [" | NetID: %1", _netId] } else { "" };
(_group controlsGroupCtrl IDC_TABLET_RECORD_SUBTITLE) ctrlSetText (format ["ID: %1 | %2%3", _id, _typeStr, _netIdStr]);

// Wanted Status Banner
private _ctrlBadge = _group controlsGroupCtrl IDC_TABLET_RECORD_WANTED_BADGE;
if (_isWanted) then {
    private _reasonText = ["Unspecified Warrant", _wantedReason] select (_wantedReason isNotEqualTo "");
    _ctrlBadge ctrlSetStructuredText parseText (format [
        "<t size='1.1' font='RobotoCondensedBold' color='#ffffff' shadow='1'><t bgcolor='#b02020'> [!] ACTIVE ARREST WARRANT </t></t><br/><t size='0.85' color='#ff9999'>Warrant Reason: %1</t>",
        _reasonText
    ]);
} else {
    _ctrlBadge ctrlSetStructuredText parseText "<t size='1.1' font='RobotoCondensedBold' color='#ffffff' shadow='1'><t bgcolor='#1e6b2c'> [OK] NO ACTIVE WARRANTS </t></t><br/><t size='0.85' color='#99e6aa'>Subject has no outstanding warrants on file.</t>";
};

// Driving License
private _ctrlLicDrive = _group controlsGroupCtrl IDC_TABLET_RECORD_LIC_DRIVE;
if (_drivingLic) then {
    _ctrlLicDrive ctrlSetText "Driver's License: VALID";
    _ctrlLicDrive ctrlSetTextColor [0.3, 0.9, 0.4, 1];
} else {
    _ctrlLicDrive ctrlSetText "Driver's License: SUSPENDED";
    _ctrlLicDrive ctrlSetTextColor [1.0, 0.35, 0.35, 1];
};

// Firearms License
private _ctrlLicGun = _group controlsGroupCtrl IDC_TABLET_RECORD_LIC_GUN;
if (_gunLic) then {
    _ctrlLicGun ctrlSetText "Firearms Permit: VALID";
    _ctrlLicGun ctrlSetTextColor [0.3, 0.9, 0.4, 1];
} else {
    _ctrlLicGun ctrlSetText "Firearms Permit: REVOKED/NONE";
    _ctrlLicGun ctrlSetTextColor [0.75, 0.75, 0.75, 1];
};

// Vehicles
private _vehiclesText = if (_vehicles isNotEqualTo []) then {
    format ["Registered Vehicles: %1", _vehicles joinString ", "]
} else {
    "Registered Vehicles: None on file"
};
(_group controlsGroupCtrl IDC_TABLET_RECORD_VEHICLES) ctrlSetText _vehiclesText;

// Notes
(_group controlsGroupCtrl IDC_TABLET_RECORD_NOTES) ctrlSetText _notes;

// Criminal History List
private _ctrlCrimes = _group controlsGroupCtrl IDC_TABLET_RECORD_CRIMES_LIST;
lbClear _ctrlCrimes;

if (count _crimes == 0) then {
    private _idx = _ctrlCrimes lbAdd "No criminal offenses or violations on record.";
    _ctrlCrimes lbSetColor [_idx, [0.4, 0.8, 0.4, 1]];
} else {
    {
        private _crime = _x;
        private _title = _crime getOrDefault ["title", "Unknown Offense"];
        private _sev = _crime getOrDefault ["severity", 1];
        private _date = _crime getOrDefault ["date", "N/A"];
        private _cNotes = _crime getOrDefault ["notes", ""];

        private _crimeStr = if (_cNotes isNotEqualTo "") then {
            format ["[%1] (Lvl %2) %3 — %4", _date, _sev, _title, _cNotes]
        } else {
            format ["[%1] (Lvl %2) %3", _date, _sev, _title]
        };

        private _idx = _ctrlCrimes lbAdd _crimeStr;

        // Color based on severity level
        private _color = switch (_sev) do {
            case 1: { [0.95, 0.95, 0.60, 1] }; // Minor: light yellow
            case 2: { [1.00, 0.80, 0.30, 1] }; // Misdemeanor: amber
            case 3: { [1.00, 0.55, 0.20, 1] }; // Moderate: orange
            case 4: { [1.00, 0.30, 0.30, 1] }; // Major: red
            case 5: { [0.85, 0.20, 0.85, 1] }; // Capital: purple
            default { [0.90, 0.90, 0.90, 1] };
        };
        _ctrlCrimes lbSetColor [_idx, _color];
    } forEach _crimes;
};
