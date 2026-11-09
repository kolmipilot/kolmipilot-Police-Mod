#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Retrieves a person record by ID from the police database.
 *
 * Arguments:
 * 0: Person ID <STRING|NUMBER>
 * 1: Callback code [record, customArgs, found] <CODE> (Default: {})
 * 2: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * Request ID or record if local server call <ANY>
 *
 * Example:
 * ["P_1001", {
 *     params ["_record", "_args", "_found"];
 * }] call FUNC(getPerson);
 *
 * Public: Yes
 */

params [
    ["_personId", "", ["", 0]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

["persons", _personId, _callback, _customArgs] call FUNC(getRecord)
