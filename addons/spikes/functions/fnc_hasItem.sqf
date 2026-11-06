#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Checks if a unit carries a specific item in inventory or clothing.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item classname <STRING>
 *
 * Return Value:
 * Whether unit has the item <BOOL>
 *
 * Example:
 * [player, "kolmip_spikes_spikeStrip"] call kolmip_spikes_fnc_hasItem;
 *
 * Public: No
 */

params [
    ["_unit", objNull, [objNull]],
    ["_item", "", [""]]
];

if (isNull _unit || _item isEqualTo "") exitWith { false };

(_item in (items _unit + assignedItems _unit))
