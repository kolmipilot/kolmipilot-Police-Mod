#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Updates wanted status and reason for a person in the police database.
 *
 * Arguments:
 * 0: Person ID <STRING>
 * 1: Is wanted <BOOL>
 * 2: Wanted reason <STRING> (Default: "")
 * 3: Callback code [[recordId, recordData], customArgs, success] <CODE> (Default: {})
 * 4: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * ["P_1001", true, "Armed robbery suspect"] call FUNC(setWantedStatus);
 *
 * Public: Yes
 */

params [
    ["_personId", "", [""]],
    ["_isWanted", true, [true]],
    ["_reason", "", [""]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

if (_personId isEqualTo "") exitWith {};

[_personId, {
    params ["_record", "_args", "_found"];
    _args params ["_wanted", "_wantedReason", "_cb", "_userArgs"];

    if (!_found || {count _record == 0}) exitWith {
        if (_cb isNotEqualTo {}) then {
            [[], _userArgs, false] call _cb;
        };
    };

    _record set ["isWanted", _wanted];
    _record set ["wantedReason", _wantedReason];

    // If unit is currently active in the world, update its local variable too
    private _netId = _record getOrDefault ["netId", ""];
    if (_netId isNotEqualTo "") then {
        private _unit = objectFromNetId _netId;
        if (!isNull _unit) then {
            _unit setVariable [QGVAR(isWanted), _wanted, true];
            _unit setVariable [QGVAR(wantedReason), _wantedReason, true];
        };
    };

    [_record, _cb, _userArgs] call FUNC(savePerson);
}, [_isWanted, _reason, _callback, _customArgs]] call FUNC(getPerson);
