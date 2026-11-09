#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Registers an in-game unit into the police database and sets its personId variable.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Overrides <HASHMAP> (Default: empty HashMap)
 * 2: Callback code [[recordId, recordData], customArgs, success] <CODE> (Default: {})
 * 3: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * Assigned person ID <STRING>
 *
 * Example:
 * [_unit, createHashMapFromArray [["isWanted", true]], {
 *     params ["_res", "_args", "_success"];
 * }] call FUNC(registerUnit);
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]],
    ["_overrides", createHashMap, [createHashMap]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

if (isNull _unit || {!(_unit isKindOf "CAManBase")}) exitWith { "" };

private _personData = [_unit, _overrides] call FUNC(createPersonFromUnit);
private _personId = _personData get "id";

// Assign person ID to unit globally
_unit setVariable [QGVAR(personId), _personId, true];

["persons", _personData, _callback, _customArgs] call FUNC(saveRecord);

_personId
