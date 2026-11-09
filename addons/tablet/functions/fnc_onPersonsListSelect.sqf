#include "..\script_component.hpp"
#include "..\UI\defineRes.hpp"
/*
 * Author: kolmipilot
 * Description: Handles selection change in the persons registry list.
 *
 * Arguments:
 * 0: Listbox control <CONTROL>
 * 1: Selected index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control, _index] call kolmip_tablet_fnc_onPersonsListSelect;
 *
 * Public: No
 */

params ["_control", "_selectedIndex"];

if (_selectedIndex < 0) exitWith {};

private _personId = _control lbData _selectedIndex;
if (_personId isEqualTo "") exitWith {};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

[format ["Loading record %1...", _personId], "loading"] call FUNC(setStatus);

[_personId, {
    params ["_record", "_args", "_found"];
    _args params ["_expectedId"];

    private _display = uiNamespace getVariable [QGVAR(display), displayNull];
    if (isNull _display) exitWith {};

    if (!_found || {count _record == 0}) exitWith {
        [format ["Error: Record '%1' not found or inaccessible.", _expectedId], "error"] call FUNC(setStatus);
        (_display displayCtrl IDC_TABLET_RECORD_GROUP) ctrlShow false;
        private _emptyNotice = _display displayCtrl IDC_TABLET_RECORD_EMPTY_NOTICE;
        _emptyNotice ctrlShow true;
        _emptyNotice ctrlSetStructuredText parseText (format ["<t align='center' size='1.2' color='#d04040'>Record '%1' not found.</t>", _expectedId]);
    };

    GVAR(currentRecord) = _record;
    GVAR(currentRecordId) = _expectedId;

    [_record] call FUNC(updateRecordView);
    [format ["Record %1 loaded.", _expectedId], "info"] call FUNC(setStatus);
}, [_personId]] call EFUNC(database,getPerson);
