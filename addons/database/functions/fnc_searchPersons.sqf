#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Searches for persons in the police database matching criteria.
 *
 * Arguments:
 * 0: Search criteria <HASHMAP> (Default: empty HashMap)
 * 1: Callback code [results, customArgs, success] <CODE> (Default: {})
 * 2: Custom arguments <ANY> (Default: [])
 * 3: Max results <NUMBER> (Default: -1 for setting value)
 *
 * Return Value:
 * Request ID or results if local server call <ANY>
 *
 * Example:
 * [createHashMapFromArray [["search", "Smith"], ["isWanted", true]], {
 *     params ["_results", "_args", "_success"];
 *     diag_log format ["Matching persons: %1", count _results];
 * }] call FUNC(searchPersons);
 *
 * Public: Yes
 */

params [
    ["_criteria", createHashMap, [createHashMap]],
    ["_callback", {}, [{}]],
    ["_customArgs", []],
    ["_maxResults", -1, [0]]
];

["persons", _criteria, _callback, _customArgs, _maxResults] call FUNC(query)
