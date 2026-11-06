#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Spawns and aligns the deployed spike strip object on the server.
 *
 * Arguments:
 * 0: Unit that deployed the strip <OBJECT>
 * 1: Target position ATL <ARRAY>
 * 2: Direction in degrees <NUMBER>
 *
 * Return Value:
 * Created object <OBJECT>
 *
 * Example:
 * [player, [100, 100, 0], 45] call kolmip_spikes_fnc_deploySpikeStripServer;
 *
 * Public: No
 */

params [
    ["_unit", objNull, [objNull]],
    ["_pos", [0, 0, 0], [[]]],
    ["_dir", 0, [0]]
];

if (!isServer) exitWith { objNull };

private _spike = createVehicle [QGVAR(spikeStripDeployed), _pos, [], 0, "CAN_COLLIDE"];
_spike setDir _dir;
_spike setPosATL _pos;
/*
// Align object flat against surface normal (roads, inclined terrain)
private _normal = surfaceNormal _pos;
_spike setVectorUp _normal;
*/
[_spike] call FUNC(registerSpikeStripServer);

_spike
