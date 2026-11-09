#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Extracts identity information from an in-game unit and creates a person record.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Overrides <HASHMAP> (Default: empty HashMap)
 *
 * Return Value:
 * Person HashMap <HASHMAP>
 *
 * Example:
 * private _person = [_unit] call FUNC(createPersonFromUnit);
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]],
    ["_overrides", createHashMap, [createHashMap]]
];

if (isNull _unit) exitWith { createHashMap };

private _fullName = name _unit;
private _parts = _fullName splitString " ";
private _firstName = if (_parts isNotEqualTo []) then { _parts select 0 } else { _fullName };
private _lastName = if (count _parts > 1) then { (_parts select [1, count _parts]) joinString " " } else { "" };

private _isPlayer = isPlayer _unit;
private _uid = if (_isPlayer) then { getPlayerUID _unit } else { "" };

private _existingId = _unit getVariable [QGVAR(personId), ""];
private _id = if (_existingId isNotEqualTo "") then {
    _existingId
} else {
    if (_isPlayer) then {
        format ["P_UID_%1", _uid]
    } else {
        format ["P_AI_%1_%2", round (diag_tickTime * 10), round (random 99999)]
    };
};

private _person = [_id, _firstName, _lastName] call FUNC(createPersonData);

_person set ["isPlayer", _isPlayer];
_person set ["uid", _uid];
_person set ["face", face _unit];
_person set ["speaker", speaker _unit];
_person set ["isPolice", _unit getVariable [QEGVAR(common,isPolice), false]];
_person set ["isWanted", _unit getVariable [QGVAR(isWanted), false]];
_person set ["wantedReason", _unit getVariable [QGVAR(wantedReason), ""]];
_person set ["drivingLicense", _unit getVariable [QGVAR(drivingLicense), true]];
_person set ["gunLicense", _unit getVariable [QGVAR(gunLicense), false]];
_person set ["netId", netId _unit];

// Apply any overrides provided by caller
{
    _person set [_x, _y];
} forEach _overrides;

_person
