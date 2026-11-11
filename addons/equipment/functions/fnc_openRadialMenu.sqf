#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
// [] call kolmip_equipment_fnc_openRadialMenu;
TRACE_3("Opening radial menu requested: hasInterface=%1 player=%2 dialog=%3",hasInterface,player,dialog);

if (!hasInterface || {isNull player}) exitWith {
    TRACE_2("Cannot open radial menu: interface=%1 player=%2",hasInterface,player);
    false
};

private _display = findDisplay IDD_RADIAL_MENU;
if (!isNull _display) exitWith {
    TRACE_1("Refreshing existing radial display: %1",_display);
    [_display] call FUNC(onRadialMenuLoad);
    true
};

if (dialog) exitWith {
    TRACE_1("Cannot open radial menu because another dialog is open: %1",dialog);
    false
};

private _opened = createDialog QGVAR(radialMenu);
TRACE_1("createDialog result for radial menu: %1",_opened);

if (_opened) then {
    private _radialDisplay = findDisplay IDD_RADIAL_MENU;
    if (!isNull _radialDisplay) then {
        TRACE_1("Refreshing newly created radial display: %1",_radialDisplay);
        [_radialDisplay] call FUNC(onRadialMenuLoad);
    } else {
        TRACE_1("Radial display not found immediately after createDialog, idd=%1",IDD_RADIAL_MENU);
    };
};

_opened
