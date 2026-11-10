#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Retrieves or registers a person record after an officer initiates an interaction.
 *
 * Arguments:
 * 0: Person <OBJECT>
 * 1: Interaction type ("id"|"license"|"purpose") <STRING>
 * 2: Show interaction result <BOOL> (Default: true)
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [
    ["_target", objNull, [objNull]],
    ["_interaction", "", [""]],
    ["_showResult", true, [true]]
];
if (isNull _target || {!alive _target} || {!(_target isKindOf "CAManBase")} || {_target isEqualTo player}) exitWith {};
if !([player] call FUNC(canUsePoliceActions)) exitWith {};

private _showMissing = {
    params ["_showResult"];
    if (_showResult) then {
        [format ["<t color='#ffcc66'>%1</t>", LLSTRING(Msg_NoPersonRecord)], 3.3, player, 12] call ace_common_fnc_displayTextStructured;
    };
};
private _showRecord = {
    params ["_record", "_args"];
    _args params ["_target", "_interaction", "_showResult"];
    if (_showResult) then {
        [_target, _interaction, _record] call FUNC(showEncounterPerson);
    };
};
private _registerPerson = {
    params ["_target", "_interaction", "_showResult", "_missingCallback"];
    if (!EGVAR(database,enableEncounterRegistration)) exitWith {
        [_showResult] call _missingCallback;
    };

    [
        _target,
        createHashMap,
        {
            params ["_result", "_args", "_success"];
            _args params ["_target", "_interaction", "_showResult", "_missingCallback"];
            if (!_success || {count _result < 2}) exitWith {
                [_showResult] call _missingCallback;
            };
            if (_showResult) then {
                [_target, _interaction, _result select 1] call FUNC(showEncounterPerson);
            };
        },
        [_target, _interaction, _showResult, _missingCallback]
    ] call EFUNC(database,registerUnit);
};

[
    _target,
    {
        params ["_record", "_args", "_found"];
        _args params ["_target", "_interaction", "_showResult", "_registerPerson", "_showRecord", "_showMissing"];
        if (_found) exitWith {
            [_record, [_target, _interaction, _showResult]] call _showRecord;
        };
        [_target, _interaction, _showResult, _showMissing] call _registerPerson;
    },
    [_target, _interaction, _showResult, _registerPerson, _showRecord, _showMissing]
] call EFUNC(database,getPersonByUnit);
