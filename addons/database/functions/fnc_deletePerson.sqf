#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Deletes a person record from the police database.
 *
 * Arguments:
 * 0: Person ID <STRING|NUMBER>
 * 1: Callback code [recordId, customArgs, success] <CODE> (Default: {})
 * 2: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * Request ID or success boolean if local server call <ANY>
 *
 * Example:
 * ["P_1001", {
 *     params ["_recordId", "_args", "_success"];
 * }] call FUNC(deletePerson);
 *
 * Public: Yes
 */

params [
    ["_personId", "", ["", 0]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

["persons", _personId, _callback, _customArgs] call FUNC(deleteRecord)
