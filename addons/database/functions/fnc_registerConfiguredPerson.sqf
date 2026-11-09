#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Registers a unit explicitly marked innocent or wanted in Eden or Zeus.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Status (0: preserve existing status or default innocent, 1: innocent, 2: wanted) <NUMBER>
 * 2: Wanted reason <STRING>
 *
 * Return Value:
 * Registered <BOOL>
 *
 * Public: No
 */

params [
    ["_unit", objNull, [objNull]],
    ["_status", 0, [0]],
    ["_wantedReason", "", [""]]
];
if (!isServer || {isNull _unit} || {!(_unit isKindOf "CAManBase")} || {!(_status in [0, 1, 2])}) exitWith { false };

private _personId = _unit getVariable [QGVAR(personId), ""];
if (_personId isEqualTo "") then {
    private _uid = if (isPlayer _unit) then { getPlayerUID _unit } else { "" };
    _personId = if (_uid isNotEqualTo "") then {
        format ["P_UID_%1", _uid]
    } else {
        format ["P_AI_%1_%2", round (diag_tickTime * 10), round (random 99999)]
    };
    _unit setVariable [QGVAR(personId), _personId, true];
};

if (_status in [1, 2]) then {
    private _isWanted = _status == 2;
    _unit setVariable [QGVAR(personStatus), ["", "innocent", "wanted"] select _status, true];
    _unit setVariable [QGVAR(isWanted), _isWanted, true];
    if (_isWanted && {_wantedReason isNotEqualTo ""}) then {
        _unit setVariable [QGVAR(wantedReason), _wantedReason, true];
    };
};

if (isNil QGVAR(tables)) exitWith {
    private _pending = missionNamespace getVariable [QGVAR(pendingPersonRegistrations), []];
    _pending pushBack [_unit, _status, _wantedReason];
    missionNamespace setVariable [QGVAR(pendingPersonRegistrations), _pending];
    true
};

private _person = ["persons", _personId] call FUNC(getRecordServer);
private _isWanted = if (_status == 2) then {
    true
} else {
    if (_status == 1) then {
        false
    } else {
        _person getOrDefault ["isWanted", _unit getVariable [QGVAR(isWanted), false]]
    }
};
if (count _person == 0) then {
    _person = [_unit] call FUNC(createPersonFromUnit);
} else {
    private _identity = [_unit] call FUNC(createPersonFromUnit);
    {
        _person set [_x, _identity get _x];
    } forEach ["firstName", "lastName", "fullName", "isPlayer", "uid", "face", "speaker", "isPolice", "netId"];
};
_person set ["id", _personId];
_person set ["isWanted", _isWanted];
_unit setVariable [QGVAR(personStatus), ["innocent", "wanted"] select _isWanted, true];
_unit setVariable [QGVAR(isWanted), _isWanted, true];
if (_status in [1, 2]) then {
    _person set ["wantedReason", _wantedReason];
    _unit setVariable [QGVAR(wantedReason), _wantedReason, true];
} else {
    if (!_isWanted) then {
        _person set ["wantedReason", ""];
        _unit setVariable [QGVAR(wantedReason), "", true];
    };
};

private _saveResult = ["persons", _person] call FUNC(setRecordServer);
_saveResult params ["_success", "_recordId"];
if (_success) then {
    [QGVAR(recordChanged), ["persons", _recordId, "save"]] call CBA_fnc_globalEvent;
};
_success
