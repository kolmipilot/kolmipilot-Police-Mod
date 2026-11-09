#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Searches explicitly registered vehicles.
 *
 * Arguments:
 * 0: Search criteria <HASHMAP>
 * 1: Callback code [records, customArgs, success] <CODE>
 * 2: Custom arguments <ANY>
 * 3: Maximum results <NUMBER>
 *
 * Return Value:
 * Request ID or results if local server call <ANY>
 *
 * Public: Yes
 */

params [
    ["_criteria", createHashMap, [createHashMap]],
    ["_callback", {}, [{}]],
    ["_customArgs", []],
    ["_maxResults", -1, [0]]
];

["vehicles", _criteria, _callback, _customArgs, _maxResults] call FUNC(query)
