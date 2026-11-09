#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Queries a server table with criteria filters and limits result count.
 *
 * Arguments:
 * 0: Table name <STRING>
 * 1: Criteria <HASHMAP> (Default: empty HashMap)
 * 2: Max results <NUMBER> (Default: 50)
 *
 * Return Value:
 * Array of matching records <ARRAY>
 *
 * Example:
 * private _wanted = ["persons", createHashMapFromArray [["isWanted", true]], 50] call FUNC(queryServer);
 *
 * Public: Yes
 */

params [
    ["_tableName", "", [""]],
    ["_criteria", createHashMap, [createHashMap]],
    ["_maxResults", 50, [0]]
];

if (!isServer || {_tableName isEqualTo ""}) exitWith { [] };

private _table = [_tableName] call FUNC(getTableServer);
if (isNil "_table") exitWith { [] };

private _records = _table get "records";
private _results = [];

if (count _criteria == 0) then {
    {
        _results pushBack (+_y);
        if (count _results >= _maxResults) exitWith {};
    } forEach _records;
} else {
    private _searchStr = toLower (_criteria getOrDefault ["search", _criteria getOrDefault ["name", ""]]);

    {
        private _rec = _y;
        private _match = true;

        // Text search across relevant identity and registration fields.
        if (_searchStr isNotEqualTo "") then {
            private _searchFields = switch (_tableName) do {
                case "persons": { ["fullName", "firstName", "lastName", "uid"] };
                case "vehicles": { ["plate", "ownerId", "ownerName", "className", "displayName", "vehicleId"] };
                default { ["id", "name"] };
            };
            private _fieldMatches = false;
            {
                private _fieldValue = toLower str (_rec getOrDefault [_x, ""]);
                if (_fieldValue find _searchStr != -1) exitWith {
                    _fieldMatches = true;
                };
            } forEach _searchFields;
            if (!_fieldMatches) then {
                _match = false;
            };
        };

        if (_match) then {
            {
                private _critKey = _x;
                private _critVal = _y;

                if (_critKey isNotEqualTo "search" && {_critKey isNotEqualTo "name"}) then {
                    private _recVal = _rec getOrDefault [_critKey, nil];
                    if (isNil "_recVal") then {
                        _match = false;
                    } else {
                        if (_critVal isEqualType true) then {
                            if (_recVal isNotEqualTo _critVal) then { _match = false; };
                        } else {
                            if (_critVal isEqualType "") then {
                                if ((toLower str _recVal) find (toLower _critVal) == -1) then {
                                    _match = false;
                                };
                            } else {
                                if (_recVal isNotEqualTo _critVal) then { _match = false; };
                            };
                        };
                    };
                };

                if (!_match) exitWith {};
            } forEach _criteria;
        };

        if (_match) then {
            _results pushBack (+_rec);
            if (count _results >= _maxResults) exitWith {};
        };
    } forEach _records;
};

_results
