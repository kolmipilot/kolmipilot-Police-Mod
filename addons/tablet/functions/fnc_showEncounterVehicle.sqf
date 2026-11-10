#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Presents a checked vehicle's registration and wanted status.
 *
 * Arguments:
 * 0: Vehicle record <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_record", createHashMap, [createHashMap]]];
if (count _record == 0) exitWith {
    [format ["<t color='#ffcc66'>%1</t>", LLSTRING(Msg_VehicleLoadFailed)], 3.3, player, 12] call ace_common_fnc_displayTextStructured;
};

private _wantedText = if (_record getOrDefault ["isWanted", false]) then {
    format ["<t color='#ff4040'>%1</t>", LLSTRING(Vehicle_Wanted)]
} else {
    format ["<t color='#80d080'>%1</t>", LLSTRING(Person_NoWarrant)]
};
private _ownerName = _record getOrDefault ["ownerName", "Unknown"];
[
    format [
        "<t size='1.1' color='#7fc8ff'>%1</t><br/>%2: %3<br/>%4: %5<br/>%6: %7<br/>%8: %9",
        LLSTRING(Vehicle_Check),
        LLSTRING(Vehicle_Plate),
        _record getOrDefault ["plate", "Unknown"],
        LLSTRING(Vehicle_Class),
        _record getOrDefault ["displayName", _record getOrDefault ["className", "Unknown"]],
        LLSTRING(Vehicle_Owner),
        _ownerName,
        LLSTRING(Vehicle_Status),
        _wantedText
    ],
    3.3,
    player,
    12
] call ace_common_fnc_displayTextStructured;
