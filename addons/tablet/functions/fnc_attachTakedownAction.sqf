#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Attaches the native scroll-menu takedown action to the player's current action host.
 *
 * Arguments:
 * 0: Player unit <OBJECT>
 * 1: Action host (player or occupied vehicle) <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [
    ["_unit", objNull, [objNull]],
    ["_actionHost", objNull, [objNull]]
];
if (isNull _unit || {isNull _actionHost}) exitWith {};

private _oldHost = _unit getVariable [QGVAR(takedownActionHost), objNull];
private _oldActionId = _unit getVariable [QGVAR(takedownActionId), -1];
if (!isNull _oldHost && _oldActionId >= 0) then {
    _oldHost removeAction _oldActionId;
};

private _actionId = _actionHost addAction [
    LLSTRING(Action_Takedown),
    {
        params ["_target", "_caller"];
        [_caller] call FUNC(stopClosestTarget);
    },
    [],
    1.5,
    false,
    true,
    "",
    "[player] call " + QFUNC(canUsePoliceActions)
];
_unit setVariable [QGVAR(takedownActionId), _actionId];
_unit setVariable [QGVAR(takedownActionHost), _actionHost];
