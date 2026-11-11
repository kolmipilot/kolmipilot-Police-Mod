#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Function to make unit a mele unit attacking with fists.
 *
 * Arguments:
 * Unit (OBJECT) - Unit to make a mele unit attacking with fists.
 *
 * Return Value:
 * None
 *
 * Example:
 * [civ1] call kolmip_interactions_fnc_attackMeleFists;
 *
 * Public: No
 */
params ["_unit"];

private _newGroup = createGroup east;
[_unit] joinSilent _newGroup;
if (local _unit) then {_unit call FUNC(aiMeleFists)};
