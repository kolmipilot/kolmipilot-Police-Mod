#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if (isServer) then {
    [QGVAR(encounterRequest), {
        call FUNC(handleEncounterRequestServer);
    }] call CBA_fnc_addEventHandler;
};

[QGVAR(applyEncounterAction), {
    call FUNC(applyEncounterAction);
}] call CBA_fnc_addEventHandler;

if (hasInterface) then {
    // Listen for database changes to update tablet in real-time
    [QEGVAR(database,recordChanged), {
        params ["_tableName", "_recordId", "_action"];
        [_tableName, _recordId, _action] call FUNC(onRecordChanged);
    }] call CBA_fnc_addEventHandler;

    // ACE Self Action to open police tablet
    private _openTabletAction = [
        QGVAR(openTabletAction),
        LLSTRING(Action_Open),
        "\z\kolmip\addons\tablet\data\tablet_icon_ca.paa",
        {
            [player] call FUNC(openTablet);
        },
        {
            [player] call FUNC(canOpenTablet);
        },
        {},
        [],
        [0, 0, 0],
        2
    ] call ace_interact_menu_fnc_createAction;

    ["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _openTabletAction, true] call ace_interact_menu_fnc_addActionToClass;

    private _personIdAction = [
        QGVAR(personIdAction),
        LLSTRING(Action_CheckId),
        "",
        {
            params ["_target"];
            [_target, "id"] call FUNC(interactWithPerson);
        },
        {
            params ["_target", "_player"];
            (_target isKindOf "CAManBase") && _target isNotEqualTo _player && {[_player] call FUNC(canUsePoliceActions)}
        }
    ] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"], _personIdAction, true] call ace_interact_menu_fnc_addActionToClass;

    private _personLicenseAction = [
        QGVAR(personLicenseAction),
        LLSTRING(Action_CheckLicense),
        "",
        {
            params ["_target"];
            [_target, "license"] call FUNC(interactWithPerson);
        },
        {
            params ["_target", "_player"];
            (_target isKindOf "CAManBase") && _target isNotEqualTo _player && {[_player] call FUNC(canUsePoliceActions)}
        }
    ] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"], _personLicenseAction, true] call ace_interact_menu_fnc_addActionToClass;

    private _personPurposeAction = [
        QGVAR(personPurposeAction),
        LLSTRING(Action_AskPurpose),
        "",
        {
            params ["_target"];
            [_target, "purpose"] call FUNC(interactWithPerson);
        },
        {
            params ["_target", "_player"];
            (_target isKindOf "CAManBase") && _target isNotEqualTo _player && {[_player] call FUNC(canUsePoliceActions)}
        }
    ] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"], _personPurposeAction, true] call ace_interact_menu_fnc_addActionToClass;

    private _personReleaseAction = [
        QGVAR(personReleaseAction),
        LLSTRING(Action_ReleasePerson),
        "",
        {
            params ["_target", "_player"];
            [QGVAR(encounterRequest), [clientOwner, _player, _target, "release"]] call CBA_fnc_serverEvent;
        },
        {
            params ["_target", "_player"];
            (_target isKindOf "CAManBase")
                && {!isPlayer _target}
                && {_target getVariable [QGVAR(stoppedForPolice), false]}
                && {[_player] call FUNC(canUsePoliceActions)}
        }
    ] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"], _personReleaseAction, true] call ace_interact_menu_fnc_addActionToClass;

    private _vehicleCheckAction = [
        QGVAR(vehicleCheckAction),
        LLSTRING(Action_CheckVehicle),
        "",
        {
            params ["_target"];
            [_target] call FUNC(checkVehicle);
        },
        {
            params ["_target", "_player"];
            (_target isKindOf "AllVehicles") && {!(_target isKindOf "CAManBase")} && {[_player] call FUNC(canUsePoliceActions)}
        }
    ] call ace_interact_menu_fnc_createAction;
    {
        [_x, 0, ["ACE_MainActions"], _vehicleCheckAction, true] call ace_interact_menu_fnc_addActionToClass;
    } forEach ["LandVehicle", "Air", "Ship"];

    private _vehicleReleaseAction = [
        QGVAR(vehicleReleaseAction),
        LLSTRING(Action_ReleaseVehicle),
        "",
        {
            params ["_target", "_player"];
            [QGVAR(encounterRequest), [clientOwner, _player, _target, "release"]] call CBA_fnc_serverEvent;
        },
        {
            params ["_target", "_player"];
            (_target isKindOf "AllVehicles")
                && {!(_target isKindOf "CAManBase")}
                && {_target getVariable [QGVAR(stoppedForPolice), false]}
                && {[_player] call FUNC(canUsePoliceActions)}
        }
    ] call ace_interact_menu_fnc_createAction;
    {
        [_x, 0, ["ACE_MainActions"], _vehicleReleaseAction, true] call ace_interact_menu_fnc_addActionToClass;
    } forEach ["LandVehicle", "Air", "Ship"];

    [
        LLSTRING(Action_Open),
        {
            [player] call FUNC(openTablet);
        },
        nil,
        1.5,
        false,
        true,
        "",
        "[player] call " + QFUNC(canOpenTablet)
    ] call CBA_fnc_addPlayerAction;

    [player, player] call FUNC(attachTakedownAction);
    player addEventHandler ["GetInMan", {
        params ["_unit", "_role", "_vehicle"];
        [_unit, _vehicle] call FUNC(attachTakedownAction);
    }];
    player addEventHandler ["GetOutMan", {
        params ["_unit"];
        [_unit, _unit] call FUNC(attachTakedownAction);
    }];
    addMissionEventHandler ["EntityRespawned", {
        params ["_newUnit", "_oldUnit"];
        if (!local _newUnit || {!isPlayer _newUnit}) exitWith {};
        private _oldHost = _oldUnit getVariable [QGVAR(takedownActionHost), objNull];
        private _oldActionId = _oldUnit getVariable [QGVAR(takedownActionId), -1];
        if (!isNull _oldHost && _oldActionId >= 0) then {
            _oldHost removeAction _oldActionId;
        };
        [_newUnit, _newUnit] call FUNC(attachTakedownAction);
    }];

    // CBA Keybinding (Default: Ctrl + T)
    [
        QUOTE(MOD_NAME),
        QGVAR(openKey),
        [LLSTRING(Key_Open), LLSTRING(Key_Open_Tooltip)],
        {
            if ([player] call FUNC(canOpenTablet)) then {
                [player] call FUNC(openTablet);
                true
            } else {
                false
            };
        },
        "",
        [DIK_T, [false, true, false]]
    ] call CBA_fnc_addKeybind;

    [
        QUOTE(MOD_NAME),
        QGVAR(stopTargetKey),
        [LLSTRING(Key_StopTarget), LLSTRING(Key_StopTarget_Tooltip)],
        {
            if ([player] call FUNC(canUsePoliceActions)) then {
                [player] call FUNC(stopClosestTarget);
                true
            } else {
                false
            };
        },
        "",
        [DIK_S, [true, true, false]]
    ] call CBA_fnc_addKeybind;
};
