#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Applies the Eden wanted-reason attribute and refreshes configured records.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Wanted reason <STRING>
 *
 * Return Value:
 * Applied <BOOL>
 *
 * Public: No
 */

params [
    ["_unit", objNull, [objNull]],
    ["_wantedReason", "", [""]]
];
if (!isServer || {isNull _unit} || {!(_unit isKindOf "CAManBase")}) exitWith { false };

_unit setVariable [QGVAR(wantedReason), _wantedReason, true];
[_unit] call FUNC(registerConfiguredPersonEden)
