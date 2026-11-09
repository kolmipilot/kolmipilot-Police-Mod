#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Logs a message to the RPT log with component prefix.
 *
 * Arguments:
 * 0: Message <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["Database initialized"] call FUNC(log);
 *
 * Public: No
 */

params [["_message", "", [""]]];

diag_log format ["[KOLMIP-DATABASE] %1", _message];
