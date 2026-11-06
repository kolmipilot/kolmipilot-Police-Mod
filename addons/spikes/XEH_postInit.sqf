#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

// Register CBA events
if (isServer) then {
    GVAR(activeSpikes) = [];

    [QGVAR(deploySpikeStripServer), {
        call FUNC(deploySpikeStripServer);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(deleteSpikeStripServer), {
        call FUNC(deleteSpikeStripServer);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(spikeHitServer), {
        call FUNC(onSpikeHitServer);
    }] call CBA_fnc_addEventHandler;

    // Start server monitor PFH (runs every 0.05 seconds = 20 Hz)
    [FUNC(monitorSpikesPFH), 0.05, []] call CBA_fnc_addPerFrameHandler;
};

// Target/Global event to puncture wheels on vehicle owner machine
[QGVAR(punctureWheels), {
    call FUNC(punctureWheels);
}] call CBA_fnc_addEventHandler;

// Client UI & Actions
if (hasInterface) then {
    // Client driver PFH (instant tire pop for player drivers)
    [FUNC(clientDriverPFH), 0.05, []] call CBA_fnc_addPerFrameHandler;

    // ACE Self Action for deployment
    private _deployAction = [
        QGVAR(deploy),
        LLSTRING(Action_Deploy),
        "",
        {
            params ["_target", "_player"];
            [_player] call FUNC(deploy);
        },
        {
            params ["_target", "_player"];
            [_player] call FUNC(canDeploy);
        },
        {},
        [],
        [0, 0, 0],
        2
    ] call ace_interact_menu_fnc_createAction;

    ["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _deployAction, true] call ace_interact_menu_fnc_addActionToClass;

    // ACE Interaction for pickup
    private _pickupAction = [
        QGVAR(pickup),
        LLSTRING(Action_Pickup),
        "",
        {
            params ["_target", "_player"];
            [_target, _player] call FUNC(pickup);
        },
        {
            params ["_target", "_player"];
            [_target, _player] call FUNC(canPickup);
        },
        {},
        [],
        [0, 0, 0],
        3.5
    ] call ace_interact_menu_fnc_createAction;

    [QGVAR(spikeStripDeployed), 0, ["ACE_MainActions"], _pickupAction, true] call ace_interact_menu_fnc_addActionToClass;

    // Scroll Action Menu for deployment
    [
        [
            LLSTRING(Action_Deploy),
            {
                params ["_target", "_caller"];
                [_caller] call FUNC(deploy);
            },
            nil,
            1.5,
            false,
            true,
            "",
            "[player] call " + QFUNC(canDeploy)
        ]
    ] call CBA_fnc_addPlayerAction;

    // CBA Keybind (Default: Ctrl + K)
    [
        QUOTE(MOD_NAME),
        QGVAR(deployKey),
        [LLSTRING(Key_Deploy), LLSTRING(Key_Deploy_Tooltip)],
        {
            if ([player] call FUNC(canDeploy)) then {
                [player] call FUNC(deploy);
                true
            } else {
                false
            };
        },
        "",
        [DIK_K, [false, true, false]]
    ] call CBA_fnc_addKeybind;
};
