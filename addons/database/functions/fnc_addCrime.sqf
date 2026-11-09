#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Adds a crime record to a person in the police database.
 *
 * Arguments:
 * 0: Person ID <STRING>
 * 1: Crime title <STRING>
 * 2: Crime notes <STRING> (Default: "")
 * 3: Severity level (1-5) <NUMBER> (Default: 1)
 * 4: Callback code [[recordId, recordData], customArgs, success] <CODE> (Default: {})
 * 5: Custom arguments <ANY> (Default: [])
 *
 * Return Value:
 * None
 *
 * Example:
 * ["P_1001", "Speeding", "Caught at 120 km/h in 50 km/h zone", 1] call FUNC(addCrime);
 *
 * Public: Yes
 */

params [
    ["_personId", "", [""]],
    ["_crimeTitle", "", [""]],
    ["_notes", "", [""]],
    ["_severity", 1, [0]],
    ["_callback", {}, [{}]],
    ["_customArgs", []]
];

if (_personId isEqualTo "" || {_crimeTitle isEqualTo ""}) exitWith {};

[_personId, {
    params ["_record", "_args", "_found"];
    _args params ["_title", "_crimeNotes", "_sev", "_cb", "_userArgs"];

    if (!_found || {count _record == 0}) exitWith {
        if (_cb isNotEqualTo {}) then {
            [[], _userArgs, false] call _cb;
        };
    };

    private _crimes = _record getOrDefault ["criminalRecord", []];
    private _crimeId = format ["CR_%1_%2", round (diag_tickTime * 10), count _crimes + 1];
    private _date = date;
    private _dateStr = format ["%1-%2-%3 %4:%5", _date select 0, _date select 1, _date select 2, _date select 3, _date select 4];

    private _crimeEntry = createHashMapFromArray [
        ["id", _crimeId],
        ["title", _title],
        ["notes", _crimeNotes],
        ["severity", _sev],
        ["date", _dateStr]
    ];

    _crimes pushBack _crimeEntry;
    _record set ["criminalRecord", _crimes];

    [_record, _cb, _userArgs] call FUNC(savePerson);
}, [_crimeTitle, _notes, _severity, _callback, _customArgs]] call FUNC(getPerson);
