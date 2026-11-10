#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Presents identity, license, or purpose information and triggers a wanted-person reaction.
 *
 * Arguments:
 * 0: Person <OBJECT>
 * 1: Interaction type <STRING>
 * 2: Person record <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [
    ["_target", objNull, [objNull]],
    ["_interaction", "", [""]],
    ["_record", createHashMap, [createHashMap]]
];
if (isNull _target || {count _record == 0}) exitWith {
    [format ["<t color='#ffcc66'>%1</t>", LLSTRING(Msg_PersonLoadFailed)], 3.3, player, 12] call ace_common_fnc_displayTextStructured;
};

private _name = _record getOrDefault ["fullName", name _target];
private _isWanted = _record getOrDefault ["isWanted", false];
private _wantedText = if (_isWanted) then {
    format ["<t color='#ff4040'>%1</t>", LLSTRING(Person_Wanted)]
} else {
    format ["<t color='#80d080'>%1</t>", LLSTRING(Person_NoWarrant)]
};

switch (_interaction) do {
    case "id": {
        [
            format ["<t size='1.1' color='#7fc8ff'>%1</t><br/>%2: %3<br/>%4: %5<br/>%6: %7", LLSTRING(Person_Identity), LLSTRING(Person_Name), _name, LLSTRING(Person_Record), _record getOrDefault ["id", "Unknown"], LLSTRING(Vehicle_Status), _wantedText],
            3.3,
            player,
            12
        ] call ace_common_fnc_displayTextStructured;
    };
    case "license": {
        private _hasLicense = _record getOrDefault ["drivingLicense", false];
        private _licenseText = if (_hasLicense) then {
            format ["<t color='#80d080'>%1</t>", LLSTRING(Person_Valid)]
        } else {
            format ["<t color='#ff4040'>%1</t>", LLSTRING(Person_NotValid)]
        };
        [
            format ["<t size='1.1' color='#7fc8ff'>%1</t><br/>%2: %3", LLSTRING(Person_DrivingLicense), _name, _licenseText],
            3.3,
            player,
            12
        ] call ace_common_fnc_displayTextStructured;
    };
    case "purpose": {
        private _response = if (_isWanted) then {
            format [LLSTRING(Person_WantedPurpose), _name]
        } else {
            format [LLSTRING(Person_InnocentPurpose), _name]
        };
        [_response, 3.3, player, 12] call ace_common_fnc_displayTextStructured;

        [
            QGVAR(encounterRequest),
            [clientOwner, player, _target, "wantedReaction"]
        ] call CBA_fnc_serverEvent;
    };
};
