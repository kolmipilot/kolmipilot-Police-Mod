#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Retrieves a person record from the database for an in-game unit if registered.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Callback code [record, customArgs, found] <CODE> (Default: {})
 * 2: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * Request ID or record if local server call <ANY>
 *
 * Example:
 * [_unit, {
 *     params ["_record", "_args", "_found"];
 *     if (_found) then { diag_log (_record get "fullName"); };
 * }] call FUNC(getPersonByUnit);
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

if (isNull _unit) exitWith {
    if (_callback isNotEqualTo {}) then {
        [createHashMap, _customArgs, false] call _callback;
    };
    ""
};

private _personId = _unit getVariable [QGVAR(personId), ""];
if (_personId isEqualTo "") exitWith {
    if (_callback isNotEqualTo {}) then {
        [createHashMap, _customArgs, false] call _callback;
    };
    ""
};

["persons", _personId, _callback, _customArgs] call FUNC(getRecord)
