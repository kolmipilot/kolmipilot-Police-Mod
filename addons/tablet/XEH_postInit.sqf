#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

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

    // Scroll Action Menu fallback
    [
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
        ]
    ] call CBA_fnc_addPlayerAction;

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
};
