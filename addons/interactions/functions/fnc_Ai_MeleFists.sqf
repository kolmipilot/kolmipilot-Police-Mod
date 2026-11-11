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
 * [civ1] call kolmip_interactions_fnc_AI_MeleFists;
 *
 * Public: No
 */

private _unitWithSword = _this;
if (isPlayer _unitWithSword) exitWith {};
_unitWithSword setVariable ["IMS_ISAI",1, true];
_unitWithSword setVariable ["IMS_IsAnimPlayed",0, true];
_unitWithSword setVariable ["inBlock",0, true];
_unitWithSword setVariable ["dam_ignore_hit0",true,true];
_unitWithSword setVariable ["dam_ignore_effect0",true,true];
_unitWithSword setVariable ["canMakeAttack",0, true];
_unitWithSword setVariable ["AI_CanTurn",0, true];
_unitWithSword setVariable ["concentrationParam",0.7, true];
_unitWithSword setVariable ["disableUnitSFX",1, true];
_unitWithSword setVariable ["IMS_InFistsMode","YES",true];
_unitWithSword setSpeaker "NoVoice";
_unitWithSword setUnitFreefallHeight 6000;


deleteVehicleBlood = {
private _veh = _this select 0;
sleep 500;
deleteVehicle _veh;
};

WBK_AiDyingSimpleScriptFists = {
private _unit = _this select 0;
sleep 0.3;
private _excludedAnimations = [
    "Human_Execution_GenericTwoHanded_headSmash_1_victim",
    "Human_Execution_GenericTwoHanded_headSmash_victim",
    "SM_Execution_ChainSaw_victim",
    "SM_Fists_Execution_victim",
    "SM_Sword_Execution_Victim",
    "Star_Wars_executionOnHuman_1_victim",
    "Star_Wars_executionOnHuman_2_victim",
    "Human_Execution_GenericOnehanded_headSmash_1_victim",
    "Human_Execution_Shield_victim",
    "Human_Execution_Blunt_victim"
];

if (
    !(animationState _unit in _excludedAnimations) &&
    (lifeState _unit != "INCAPACITATED")
) then {
    if ((animationState _unit) in [
        "lightsaber_death_3",
        "lightsaber_death_1",
        "A_PlayerDeathAnim_22",
        "A_PlayerDeathAnim_15",
        "A_PlayerDeathAnim_17"
    ]) then {
        [_unit, selectRandom ["bloodCought_1", "bloodCought_2", "bloodCought_3"], 100, 15] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    } else {
        [_unit, selectRandom [
            "New_Death_1", "New_Death_2", "New_Death_3",
            "New_Death_4", "New_Death_5", "New_Death_6",
            "New_Death_7", "New_Death_8", "New_Death_9",
            "New_Death_10", "dobi_scream_1", "dobi_scream_2",
            "dobi_scream_3", "dobi_scream_4", "dobi_fall",
            "dobi_scream_5", "dobi_scream_6"
        ], 80, 15] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    };
};
private _deathPos = "Land_HelipadEmpty_F" createVehicle [0,0,0];
_deathPos attachTo [_unit, [0, 0, 0], "head"];
sleep 4;
waitUntil {(isTouchingGround _unit)};
private _rndBlood = selectRandom ["BloodPool_01_Medium_New_F","BloodSplatter_01_Medium_New_F","BloodSplatter_01_Small_New_F","BloodSpray_01_New_F"];
private _deathBlood = _rndBlood createVehicle getPosATL _unit;
_deathBlood setPosATL [(getPosATL _deathPos select 0), (getPosATL _deathPos select 1),0];
_deathBlood setDir (random 360);
[_deathBlood] spawn deleteVehicleBlood;
};

_unitWithSword addEventHandler ["Killed", {
_this spawn WBK_AiDyingSimpleScriptFists;
}];

animPush_FistsAI = {
private _unit = _this select 0;
private _anim = _this select 1;
private _myNearestEnemy = _unit findNearestEnemy _unit;
private _ifInter = lineIntersectsSurfaces [
		AGLToASL (_myNearestEnemy modelToWorld [0,0,0.1]),
		AGLToASL (_unit modelToWorld [0,0,0.1]),
		_unit,
		_myNearestEnemy,
		true,
		1,
		"GEOM",
		"NONE"
	];
private _excludedAnimations = [
    "starWars_lightsaber_block_1",
    "starWars_lightsaber_block_2",
    "starWars_lightsaber_block_3",
    "starWars_lightsaber_hit_1",
    "starWars_lightsaber_hit_2",
    "starWars_lightsaber_blockPursuit"
];

if (
    (_unit getVariable "IMS_IsAnimPlayed" == 0) &&
    (alive _unit) &&
    (_unit getVariable "canMakeAttack" == 0) &&
    (isTouchingGround _unit) &&
    (count _ifInter == 0) &&
    !(animationState _unit in _excludedAnimations)
) then {
    _unit setVariable ["IMS_IsAnimPlayed", 1, true];
    sleep 0.5;

    if (
        (_unit getVariable "canMakeAttack" == 0) &&
        (animationState _unit != "WBK_FISTS_ATTACK_Stunned")
    ) then {
        _unit playMoveNow _anim;
    };

    sleep 1;
    _unit setVariable ["IMS_IsAnimPlayed", 0, true];
};
};

_unitWithSword addEventHandler ["HandleDamage", {
    params ["_objHit", "", "", "_hitter"];

    if (!isNull _hitter && _objHit isNotEqualTo _hitter) then {
        _objHit removeAllEventHandlers "HandleDamage";
        _objHit setDamage 1;

        private _rndAnim = selectRandom [
            "lightsaber_death_1",
            "lightsaber_death_2",
            "lightsaber_death_3",
            "lightsaber_death_4",
            "lightsaber_death_5",
            "lightsaber_death_6",
            "lightsaber_death_7",
            "flamethrower_burning_6",
            "flamethrower_burning_7"
        ];

        [_objHit, _rndAnim] remoteExec ["switchMove", 0];
    };
}];




[_unitWithSword, "AM_Kulak_Idle"] remoteExec ["switchMove", 0, true];



private _actFr = [{
	private _array = _this select 0;
	private _mutant = _array select 0;
	if (
	(lifeState _mutant == "INCAPACITATED") or
	(captive _mutant) or
	(animationState _mutant == "WBK_FISTS_ATTACK_Stunned") or
	(animationState _mutant == "WBK_FISTS_GRAB_5_VICTIM") or
	(animationState _mutant == "WBK_FISTS_GRAB_4_VICTIM") or
	(animationState _mutant == "WBK_FISTS_GRAB_3_VICTIM") or
	(animationState _mutant == "WBK_FISTS_GRAB_2_VICTIM") or
	(animationState _mutant == "WBK_FISTS_GRAB_1_VICTIM")
	) exitWith {};
	_mutant action ["SwitchWeapon", _mutant, _mutant, 100];
	_mutant allowDamage false;
	_mutant disableAI "MINEDETECTION";
	_mutant disableAI "WEAPONAIM";
	_mutant disableAI "SUPPRESSION";
	_mutant disableAI "COVER";
	_mutant disableAI "AIMINGERROR";
	_mutant disableAI "TARGET";
	_mutant disableAI "AUTOCOMBAT";
	_mutant disableAI "FSM";
	_mutant setBehaviour "CARELESS";
	{
	 private _ifInter = lineIntersects [ getPosASL _mutant, eyePos _x, _mutant, _x];
		if (!(_ifInter)) then {
			 _mutant reveal [_x, 4];
		};
	} forEach nearestObjects [_mutant, ["Man"], 40];
	private _myNearestEnemy = _mutant findNearestEnemy _mutant;

	if (_mutant getVariable "canMakeAttack" == 0) then {
		private _prm = _mutant getVariable "concentrationParam";
		private _newprm = _prm + 0.01;
	if (_newprm >= 1) then {
	_mutant setVariable ["concentrationParam",1];
	}else{
	_mutant setVariable ["concentrationParam",_newprm];
	};
	};

	if ((_mutant getVariable "canMakeAttack" == 0) and ((_myNearestEnemy distance _mutant) <= 3) and (alive _mutant)) then {
	if (_mutant getVariable "concentrationParam" > 0.08) then {
		_mutant spawn WBK_Fists_Punch;
	};
	};
}, 0.3, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;




private _loopPathfind = [{
	private _array = _this select 0;
	private _unit = _array select 0;
	if (
	(lifeState _unit == "INCAPACITATED") or
	(captive _unit) or
	(animationState _unit == "WBK_FISTS_ATTACK_Stunned") or
	(animationState _unit == "WBK_FISTS_GRAB_5_VICTIM") or
	(animationState _unit == "WBK_FISTS_GRAB_4_VICTIM") or
	(animationState _unit == "WBK_FISTS_GRAB_3_VICTIM") or
	(animationState _unit == "WBK_FISTS_GRAB_2_VICTIM") or
	(animationState _unit == "WBK_FISTS_GRAB_1_VICTIM")
	) exitWith {};
	private _nearEnemy = _unit findNearestEnemy _unit;
	if (!(isNull _nearEnemy) and (alive _nearEnemy) and (alive _unit)) then {
		private _ifInter = lineIntersectsSurfaces [
		AGLToASL (_nearEnemy modelToWorld [0,0,0.9]),
		AGLToASL (_unit modelToWorld [0,0,0.9]),
		_unit,
		_nearEnemy,
		true,
		1,
		"GEOM",
		"NONE"
	];
	 private _pos1 = (getPosATL _unit select 2);
	 private _pos2 = (getPosATL _nearEnemy select 2);
	 private _result1 = _pos1 - _pos2;
	  if (
    (_unit getVariable "AI_CanTurn" == 0) &&
    (isTouchingGround _unit) &&
    (count _ifInter == 0) &&
    (_unit distance _nearEnemy < 15) &&
    (_result1 < 1.45) &&
    (_result1 > -1.45) &&
    (animationState _unit != "starWars_force_podniati_victim_anim") &&
    (lifeState _unit != "INCAPACITATED")
    ) exitWith {
		_unit disableAI "PATH";
		_unit disableAI "ANIM";
		doStop _unit;
		if ((_unit getVariable "concentrationParam" < 0.15)) then {
			[_unit, selectRandom ["AM_Kulak_runB","AM_Kulak_runBL","AM_Kulak_runBR","AM_Kulak_walkB","AM_Kulak_walkBR","AM_Kulak_walkBL"]] spawn animPush_FistsAI;
		}else{
			[_unit, selectRandom ["AM_Kulak_runF","AM_Kulak_runFL","AM_Kulak_runFR","AM_Kulak_runL","AM_Kulak_runR","AM_Kulak_SprintF","AM_Kulak_walkF","AM_Kulak_walkFl","AM_Kulak_walkFr","AM_Kulak_walkL","AM_Kulak_walkR"]] spawn animPush_FistsAI;
		};
		private _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
		_unit setVelocityTransformation [
		  getPosASL _unit,
		  getPosASL _unit,
		  [0,0,(velocity _unit select 2) - 1],
		  [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1],
		  vectorDir _unit,
		  _dir,
		  vectorUp _unit,
		  vectorUp _unit,
		  0.1
		];
	  };
	};
}, 0.01, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;


private _loopPathfindDoMove = [{
	private _array = _this select 0;
	private _unit = _array select 0;
	if ((lifeState _unit == "INCAPACITATED") or (captive _unit)) exitWith {};
	private _nearEnemy = _unit findNearestEnemy _unit;
	if (!(isNull _nearEnemy) and (alive _nearEnemy) and (alive _unit)) then {
		private _ifInter = lineIntersectsSurfaces [
			AGLToASL (_nearEnemy modelToWorld [0,0,0.9]),
			AGLToASL (_unit modelToWorld [0,0,0.9]),
			_unit,
			_nearEnemy,
			true,
		1,
		"GEOM",
		"NONE"
	];
	 private _pos1 = (getPosATL _unit select 2);
	 private _pos2 = (getPosATL _nearEnemy select 2);
	 private _result1 = _pos1 - _pos2;
	 if ((_result1 < -1.45) || (_result1 > 1.45) || (_unit distance _nearEnemy > 15) || (count _ifInter != 0)) exitWith {
		_unit enableAI "ALL";
		_unit enableAI "PATH";
		_unit enableAI "ANIM";
		_unit enableAI "MOVE";
		_unit enableAI "ANIM";
		_unit doMove [getPos _nearEnemy select 0, getPos _nearEnemy select 1, 0];
		_unit setVariable ["IMS_IsAnimPlayed",0];
		_unit setVariable ["canMakeAttack",0];
		_unit setVariable ["actualSwordBlock",0];
		_unit playActionNow "Disable_Gesture";
	 };
	}else{
	   if (!(alive _unit)) exitWith {_unit playActionNow "Disable_Gesture";};
		_unit enableAI "ALL";
		_unit enableAI "PATH";
		_unit enableAI "ANIM";
		_unit enableAI "MOVE";
		_unit setVariable ["IMS_IsAnimPlayed",0];
		_unit setVariable ["canMakeAttack",0];
		_unit setVariable ["actualSwordBlock",0];
		_unit playActionNow "Disable_Gesture";
	};
}, 1.2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;



waitUntil {sleep 0.5; !(alive _unitWithSword)};
[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfind] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
[_unitWithSword, {
_this removeAllEventHandlers "HitPart";
}] remoteExec ["spawn", [0,-2] select isDedicated,true];
