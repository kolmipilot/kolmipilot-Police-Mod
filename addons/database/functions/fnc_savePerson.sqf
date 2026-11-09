#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Saves (inserts or updates) a person record in the police database.
 *
 * Arguments:
 * 0: Person data <HASHMAP>
 * 1: Callback code [[recordId, recordData], customArgs, success] <CODE> (Default: {})
 * 2: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * Request ID or [success, recordId] if local server call <ANY>
 *
 * Example:
 * [_personData, {
 *     params ["_res", "_args", "_success"];
 * }] call FUNC(savePerson);
 *
 * Public: Yes
 */

params [
    ["_personData", createHashMap, [createHashMap]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

["persons", _personData, _callback, _customArgs] call FUNC(saveRecord)
