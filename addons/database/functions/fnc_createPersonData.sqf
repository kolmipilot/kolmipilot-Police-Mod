#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Creates a standard person record structure with default fields.
 *
 * Arguments:
 * 0: Person ID <STRING> (Default: "")
 * 1: First name <STRING> (Default: "")
 * 2: Last name <STRING> (Default: "")
 *
 * Return Value:
 * Person HashMap <HASHMAP>
 *
 * Example:
 * private _person = ["P_1001", "John", "Doe"] call FUNC(createPersonData);
 *
 * Public: Yes
 */

params [
    ["_id", "", [""]],
    ["_firstName", "", [""]],
    ["_lastName", "", [""]]
];

private _fullName = switch (true) do {
    case (_firstName isNotEqualTo "" && {_lastName isNotEqualTo ""}): {
        format ["%1 %2", _firstName, _lastName]
    };
    case (_firstName isNotEqualTo ""): { _firstName };
    case (_lastName isNotEqualTo ""): { _lastName };
    default { "" };
};

createHashMapFromArray [
    ["id", _id],
    ["firstName", _firstName],
    ["lastName", _lastName],
    ["fullName", _fullName],
    ["isPlayer", false],
    ["uid", ""],
    ["face", ""],
    ["speaker", ""],
    ["isPolice", false],
    ["isWanted", false],
    ["wantedReason", ""],
    ["drivingLicense", true],
    ["gunLicense", false],
    ["criminalRecord", []],
    ["vehicles", []],
    ["notes", ""],
    ["netId", ""]
]
