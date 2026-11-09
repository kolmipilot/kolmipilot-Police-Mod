#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Opens the police tablet user interface.
 *
 * Arguments:
 * 0: Unit opening tablet <OBJECT> (Default: player)
 *
 * Return Value:
 * Whether dialog was opened <BOOL>
 *
 * Example:
 * [player] call kolmip_tablet_fnc_openTablet;
 *
 * Public: Yes
 */

params [["_unit", player, [objNull]]];

if (!hasInterface) exitWith { false };

// Verify eligibility
if (!([_unit] call FUNC(canOpenTablet))) exitWith {
    if (EGVAR(database,requirePoliceAuth) && {!([_unit] call EFUNC(common,isPolice))}) then {
        [LLSTRING(Msg_UnauthorizedOfficer), 2.5] call ace_common_fnc_displayTextStructured;
    } else {
        [LLSTRING(Msg_TabletMissing), 2.5] call ace_common_fnc_displayTextStructured;
    };
    false
};

// Close existing tablet if open
if (dialog) then {
    closeDialog 0;
};

// Create dialog
createDialog QGVAR(dialog)
