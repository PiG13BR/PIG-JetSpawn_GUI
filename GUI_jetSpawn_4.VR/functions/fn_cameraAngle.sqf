/*
	File: fn_jetMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 2024/13/11
	Last Update: 2024/15/11
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Creates and manages the jet camera menu angles

	Parameter(s):
		_center - an object to attach camera [OBJECT]
		_angleType - camera angles "Main" or "Front" [STRING, Defaults to "Main"]
		
	Returns:
		-
*/

params[
	["_center", objNull, [ObjNull]], 
	["_angleType", "Main", [""]]
];

if (isNull _center) exitWith {["Center is null. Provide an object for the first param."] call bis_fnc_error};

private _angle = [0,0,0];
switch _angleType do {
	case "Main" : {
		_angle = [-20,20,20];
	};
	case "Front" : {
		_angle = [0,30,0];
	}
};

uiNamespace setVariable ["PIG_jetMenu_lastCamera", _angleType];

// Camera init
if (isNil {uiNamespace getVariable "PiG_jetMenu_camera"}) then {
	_cam = "camera" camcreate (getPos _center); 
	uiNamespace setVariable ["PiG_jetMenu_camera", _cam];
	_cam cameraeffect ["internal","back"];
	_cam campreparefocus [-1,-1];
	_cam campreparefov 0.35;
	_cam camcommitprepared 0;
	showcinemaborder false;
};

// Camera set pos
_cam = uiNamespace getVariable "PiG_jetMenu_camera";
_cam camSetTarget _center;
_cam camSetPos (_center modelToWorld _angle);
_cam camcommit 0;
