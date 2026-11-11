#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

TRACE_2("Radial functions prepared: open=%1 load=%2",!isNil QFUNC(openRadialMenu),!isNil QFUNC(onRadialMenuLoad));

if (!hasInterface) exitWith {
    TRACE_1("Skipping radial keybind registration without interface: %1",hasInterface);
};

GVAR(radialMenuKeybind) = [
    QUOTE(MOD_NAME),
    QGVAR(openRadialMenu),
    [LLSTRING(Key_OpenRadialMenu), LLSTRING(Key_OpenRadialMenu_Tooltip)],
    {
        TRACE_1("Radial keybind pressed: %1",_this);
        call FUNC(openRadialMenu)
    },
    "",
    [DIK_E, [true, true, false]]
] call CBA_fnc_addKeybind;

TRACE_2("Registered radial keybind %1 with CBA result %2",QGVAR(openRadialMenu),GVAR(radialMenuKeybind));
