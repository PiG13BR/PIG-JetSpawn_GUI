/*
	File: fn_jetMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 2024/31/10
	Last Update: 2024/14/11
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Manages the jet menu spawn

	Parameter(s):
		_unit - unit player [OBJECT]
	
	Returns:
		-
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// JET SPAWN & LOADOUT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
createDialog "PIG_RscJetMenu";

_aircrafts = call compile preprocessFileLineNumbers "aircraft_presets.sqf";

localNameSpace setVariable ["PIG_airCraftSelected", ""];
localNameSpace setVariable ["PIG_airCraftPylonLb", -1];

// Create placeholder object for camera at start
_placeholder = createVehicleLocal ["Sign_Arrow_Large_Blue_F", getMarkerPos "spawn_jet", [], 0, "CAN_COLLIDE"];
_placeholder setDir (markerDir "spawn_jet");
hideObject _placeholder;
uiNamespace setVariable ["PIG_JetMenu_placeholder", _placeholder];

// Get aircraft
{
	_name = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	lbAdd [1500, _name];
	lbSetData [1500, _forEachIndex, _x]
}forEach _aircrafts;

// Reload preset list box function
PIG_fnc_reloadPresetsLb = {
	params["_aircraftClass"];

	lbClear 1503; // Clear the list box

	_originalCount = count PIG_jetLoadout;
	
	PIG_jetLoadout = [];
	for "_i" from 1 to _originalCount do {
			PIG_jetLoadout pushBack ""; // Restore default pylon slots
	};

	// Get cfg preset for this aircraft
	private _presetCfgPaths = configProperties [configFile >> "CfgVehicles" >> _aircraftClass >> "Components" >> "TransportPylonsComponent" >> "Presets", "isClass _x"];
	if (isNil "PIG_JetMenu_cfgPresets") then {PIG_JetMenu_cfgPresets = createHashMap};
	{
		_presetName = (getText(_x >> "displayName"));
		lbAdd [1503, _presetName];
		// Put the attachaments in a hashmap
		_attachs = (getArray(_x >> "attachment"));
		PIG_JetMenu_cfgPresets set [_presetName, _attachs];
	}forEach _presetCfgPaths;

	// Get pylon profile preset for this aircraft
	private _profilePresets = (profileNamespace getVariable "PIG_JetMenu_profilePresets");

	{
		// Ignore preset from another aircraft class
		private _hashClass = (_y # 0);
		if (_hashClass == _aircraftClass) then {
			lbAdd [1503, _x];
		};
	}forEach _profilePresets;
};

// Spawn local jet function
PIG_fnc_spawnLocalJet = {
	params["_aircraftClass"];
	// Delete local vehicle if already exists
	if (!isNil {uiNamespace getVariable "PIG_JetMenu_vehicleLocal"}) then {deleteVehicle (uiNamespace getVariable "PIG_JetMenu_vehicleLocal")};

	_vehicle = createVehicleLocal [_aircraftClass, (getMarkerPos "spawn_jet"), [], 0, "CAN_COLLIDE"];
	_vehicle setDir (markerDir "spawn_jet");
	uiNamespace setVariable ["PIG_JetMenu_vehicleLocal", _vehicle];

	//_vehicle enableSimulation false;
	_vehicle setPhysicsCollisionFlag false;
	_vehicle allowDamage false;

	_vehicle
};

// Init camera and delete placeholder
[_placeholder] call PIG_fnc_cameraAngle;

// Create lightsoruce (lifted from arsenal.sqf)
_intensity = 20;
_light = "#lightpoint" createvehicleLocal (getPosATL _placeholder);
_light setlightbrightness _intensity;
_light setlightambient [1, 1, 1];
_light setlightcolor [0, 0, 0];
_light lightattachobject [_placeholder,[0, 0, -_intensity * 7]];
_light setLightDayLight false;

uiNamespace setvariable ["PIG_jetMenu_LightSource", _light];

// Aircraft listbox
(displayCtrl 1500) ctrlAddEventHandler ["LBSelChanged", {
	params ["_control", "_lbCurSel", "_lbSelection"];

	lbClear 1501;
	lbClear 1502;
	lbClear 1503;
	PIG_jetLoadout = [];
	
	// Get aircraft selected
	private _aircraftSel = lbData [1500, _lbCurSel];
	localNameSpace setVariable ["PIG_airCraftSelected", _aircraftSel];

	// Spawn local jet
	private _vehicleLocal = [_aircraftSel] call PIG_fnc_spawnLocalJet;
	private _lastAngle = uiNamespace getVariable "PIG_jetMenu_lastCamera"; // Maintain the same camera angle when changing the airplane
	[_vehicleLocal, _lastAngle] call PIG_fnc_cameraAngle;

	// Get pylons paths
	private _pylonPaths = configProperties [configFile >> "CfgVehicles" >> _aircraftSel >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];
	private _pylonCount = 0; // For couting real pylons

	// For pylon listbox
	{
		if (getArray (_x >> "hardpoints") isEqualTo []) then { continue }; // Ignore dummy pylons

		_pylonName = configName _x;
		lbAdd [1501, (_pylonName + " " + "-" + " " + "empty")];
		lbSetData [1501, _pylonCount, _pylonName]; // Save the default names
		lbSetColor [1501, _pylonCount, [1, 0, 0, 1]]; // RED COLOR

		_pylonCount = _pylonCount + 1; // Count real available pylons
	} forEach _pylonPaths;

	if (PIG_jetLoadout isEqualTo []) then {
		// Add empty strings for each pylon count. An empty string in this array means an empty pylon as default
		for "_i" from 1 to _pylonCount do {
			PIG_jetLoadout pushBack "";
			_vehicleLocal setPylonLoadout [_i, "", true]; // Set pylon empty
		};

	};

	// For presets listbox
	[_aircraftSel] call PIG_fnc_reloadPresetsLb;

}];

// Pylon listbox
(displayCtrl 1501) ctrlAddEventHandler ["LBSelChanged", {
	params ["_control", "_lbCurSel", "_lbSelection"];

	lbClear 1502;
	// Get pylon name
	private _pylonName = lbData [1501, _lbCurSel];
	// Get aircraft selected
	private _aircraftClass = localNameSpace getVariable "PIG_airCraftSelected";
	// Get compatible magazines for this aircraft class
	private _compatibleMagazines = (_aircraftClass getCompatiblePylonMagazines _pylonName);

	localNameSpace setVariable ["PIG_airCraftPylonLb", _lbCurSel]; // Save the index selection for the list box

	// For magazine listbox
	// Top option: "none"
	lbAdd [1502, "NONE"];
	lbSetTooltip [1502, 0, "Empty"];
	lbSetData [1502, 0, "NONE"];

	// Ammo options
	{
		_name = getText(configFile >> "cfgMagazines" >> _x >> "displayName");
		lbAdd [1502, _name];
		lbSetTooltip [1502, (_forEachIndex + 1), getText(configFile >> "CfgMagazines" >> _x >> "descriptionShort")];
		lbSetData [1502, (_forEachIndex + 1), _x]; // Store default list box data
	}forEach _compatibleMagazines;
}];

// Magazines listbox
(displayCtrl 1502) ctrlAddEventHandler ["LBSelChanged", {
	params ["_control", "_lbCurSel", "_lbSelection"];

	private _selectedAmmo = lbData [1502, _lbCurSel];
	private _vehicleLocal = uiNamespace getVariable "PIG_JetMenu_vehicleLocal";

	// Change text for pylon listbox
	private _pylonIndex = (localNameSpace getVariable "PIG_airCraftPylonLb");

	if (_lbCurSel == 0) then { 
		_defaultName = lbData [1501, _pylonIndex]; // Empty was selected
		lbSetText [1501, _pylonIndex, _defaultName + " " + "-" + " " + "empty"];
		lbSetColor [1501, _pylonIndex, [1, 0, 0, 1]]; // RED COLOR
		PIG_jetLoadout set [_pylonIndex, ""];
		private _realPylon = (_pylonIndex + 1);
		_vehicleLocal setPylonLoadout [_realPylon, "", true];
	} else {
		lbSetText [1501, _pylonIndex, _selectedAmmo];
		lbSetColor [1501, _pylonIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
		PIG_jetLoadout set [_pylonIndex, _selectedAmmo];
		private _realPylon = (_pylonIndex + 1);
		_vehicleLocal setPylonLoadout [_realPylon, _selectedAmmo, true];
	};
}];

// Spawn button
(displayCtrl 1600) ctrlAddEventHandler ["ButtonClick", {

	if ((localNameSpace getVariable "PIG_airCraftSelected") isEqualTo "") exitWith {systemChat "No Aircraft Selected"};

	// Spawning the jet
	private _vehicleClass = localNameSpace getVariable "PIG_airCraftSelected";
	private _vehicle = createVehicle [_vehicleClass, position player, [], 50, "NONE"];

	// Setting up the jet
	private _pylonsInfo = getAllPylonsInfo _vehicle select { (_x select 3) isNotEqualTo "" };
	private _pylonsIndices = _pylonsInfo apply { _x select 0 };

	{
    	_vehicle setPylonLoadout [_x, "", true]; // Remove all default pylon magazine
	}forEach _pylonsIndices;

	{
		_magazine = PIG_jetLoadout select (_forEachIndex);

		_bool = _vehicle setPylonLoadout [_x, _magazine, true];
		if (_magazine isEqualTo "") then {
			//systemChat format ["[MUNIÇÃO] Pylon %1 não carregado", _x];
		} else {
			//systemChat format ["[MUNIÇÃO] Pylon %1 está armado com %2", _x, _magazine];
		}
	}forEach _pylonsIndices;

	closeDialog 0; //cutText ['', 'BLACK IN'];

}];

// Change camera to a different angle
(displayCtrl 1606) ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	
	private _angle = ["Main", "Front"];
	private _lastAngle = uiNamespace getVariable "PIG_jetMenu_lastCamera";
	_angle = _angle - [_lastAngle];

	private _vehicleLocal = uiNamespace getVariable "PIG_JetMenu_vehicleLocal";
	[_vehicleLocal, (_angle # 0)] call PIG_fnc_cameraAngle;
}];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// SAVE/LOAD/EDIT PROFILE LOADOUT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Create variable in profilenamespace
if (isNil {(profileNamespace getVariable "PIG_JetMenu_profilePresets")}) then {(profileNamespace setVariable ["PIG_JetMenu_profilePresets", createHashMap])};

/*
	Hashmap order: 
	[
		key, <--- name of the preset [STRING]
		[
			aircraft class, <--- to check if preset matches the aircraft selected in the listbox [STRING]
			loadout <--- pylon values from PIG_jetLoadout [ARRAY]
		]
	]
*/

// List box with presets
(displayCtrl 1503) ctrlAddEventHandler ["LBSelChanged", {
	params ["_control", "_lbCurSel", "_lbSelection"];

	if (_lbCurSel == -1) exitWith {};

	// Get the actual text in the listbox
	_getText = lbText [1503, _lbCurSel];

	// Get aircraft classname selected
	_aircraftSel = localNameSpace getVariable "PIG_airCraftSelected";

	// Check if it's a cfg preset
	_presets = configProperties [configFile >> "CfgVehicles" >> _aircraftSel >> "Components" >> "TransportPylonsComponent" >> "Presets", "isClass _x"];
	private _is_preset = false;
	
	{
		if (getText(_x >> "displayName") == _getText) exitWith {_is_preset = true};
	}forEach _presets;

	// If it's a cfg preset, disable save/delete/rename button
	if (_is_preset) then {
		ctrlEnable [1601, false];
		(displayCtrl 1601) ctrlSetTooltip "You can't modify cfg preset";
		ctrlEnable [1603, false];
		(displayCtrl 1603) ctrlSetTooltip "You can't modify cfg preset";
		ctrlEnable [1604, false];
		(displayCtrl 1604) ctrlSetTooltip "You can't modify cfg preset";
	} else {
		ctrlEnable [1601, true];
		(displayCtrl 1601) ctrlSetTooltip "";
		ctrlEnable [1603, true];
		(displayCtrl 1603) ctrlSetTooltip "";
		ctrlEnable [1604, true];
		(displayCtrl 1604) ctrlSetTooltip "";
		
	};
	ctrlSetText [1400, _getText];
}];

// Double click list box == load
(displayCtrl 1503) ctrlAddEventHandler ["LBDblClick", {
	params ["_control", "_lbCurSel", "_lbSelection"];

	// Load the text
	private _key = lbText [1503, (lbCurSel 1503)];
	if (_key isEqualTo "") exitWith {systemChat "No preset selected to load"};

	private _aircraftSel = localNameSpace getVariable "PIG_airCraftSelected";
	private _vehicleLocal = uiNamespace getVariable "PIG_JetMenu_vehicleLocal";

	// Check if it's a engine preset
	if (_key in PIG_JetMenu_cfgPresets) then {
		private _pylonsCfg = PIG_JetMenu_cfgPresets get _key;
		if (_pylonsCfg isEqualTo []) then {
			// Reset to default
			lbClear 1501;
			_pylonPaths = configProperties [configFile >> "CfgVehicles" >> _aircraftSel >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];

			{
				_pylonName = configName _x;
				lbAdd [1501, (_pylonName + " " + "-" + " " + "empty")];
				lbSetData [1501, _forEachIndex, _pylonName]; // Save the default names
				lbSetColor [1501, _forEachIndex, [1, 0, 0, 1]]; // RED COLOR
				PIG_jetLoadout set [_forEachIndex, ""];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, "", true];
			} forEach _pylonPaths;
		};

		{
			if (_x isEqualTo "") then {
				_defaultName = lbData [1501, _forEachIndex];
				lbSetText [1501, _forEachIndex, _defaultName + " " + "-" + " " + "empty"];
				lbSetColor [1501, _forEachIndex, [1, 0, 0, 1]]; // RED COLOR
				PIG_jetLoadout set [_forEachIndex, ""];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, "", true];
			} else {
				lbSetText [1501, _forEachIndex, _x];
				lbSetColor [1501, _forEachIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
				PIG_jetLoadout set [_forEachIndex, _x];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, _x, true];
			}
		}forEach _pylonsCfg;
	};

	// Profile presets
	private _profilePresets = (profileNamespace getVariable "PIG_JetMenu_profilePresets");
	if (_key in _profilePresets) then {
		hint str _profilePresets;
		private _pylonsProfile = ((_profilePresets get _key) # 1); // # 1 = array that cointains the magazines in order
		{
			if (_x isEqualTo "") then {
				_defaultName = lbData [1501, _forEachIndex];
				lbSetText [1501, _forEachIndex, _defaultName + " " + "-" + " " + "empty"];
				lbSetColor [1501, _forEachIndex, [1, 0, 0, 1]]; // RED COLOR
				PIG_jetLoadout set [_forEachIndex, ""];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, "", true];
			} else {
				lbSetText [1501, _forEachIndex, _x];
				lbSetColor [1501, _forEachIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
				PIG_jetLoadout set [_forEachIndex, _x];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, _x, true];
			}
		}forEach _pylonsProfile;
	};

}];

// Edit box
(displayCtrl 1400) ctrlAddEventHandler ["EditChanged", {
	params ["_control", "_newText"];

	private _profilePresets = (profileNamespace getVariable "PIG_JetMenu_profilePresets");
	if ((_newText in _profilePresets) || {_newText in PIG_JetMenu_cfgPresets}) then {
		// Disable save new preset
		ctrlEnable [1605, false];
		(displayCtrl 1605) ctrlSetTooltip "Invalid Name/Already Exists";
		// Disable rename preset
		ctrlEnable [1604, false];
		(displayCtrl 1604) ctrlSetTooltip "Invalid Name/Already Exists";
	} else {
		ctrlEnable [1605, true];
		(displayCtrl 1605) ctrlSetTooltip "";
		ctrlEnable [1604, true];
		(displayCtrl 1604) ctrlSetTooltip "";
	};
}];

// Save new preset
(displayCtrl 1605) ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	
	if (lbCurSel 1500 == -1) exitWith {systemChat "[ERROR] No aircraft selected"};
	if ((ctrlText 1400) isEqualTo "") exitWith {systemChat "Enter a name for you preset"};
	
	// Get new key name
	private _key = (ctrlText 1400);
	// Get profile hashmap
	private _profilePresets = (profileNamespace getVariable "PIG_JetMenu_profilePresets");
	hint str _profilePresets;
	// Check for similar names/key in presets
	if ((_key in _profilePresets) || {_key in PIG_JetMenu_cfgPresets}) exitWith {systemChat format ["[ERROR] This name %1 already exist in the preset", str _key]};

	_aircraftSel = localNameSpace getVariable "PIG_airCraftSelected";
	private _loadout = PIG_jetLoadout;
	
	_profilePresets set [_key, [_aircraftSel, _loadout], true]; // Set a new key
 
	// Add to the list box
	//lbAdd [1503, (ctrlText 1400)];

	[_aircraftSel] call PIG_fnc_reloadPresetsLb;
	//_lastIndex = (count (profileNamespace getVariable "PIG_JetMenu_profilePresets") - 1); // last index added
	//lbSetData [1503, _lastIndex, (ctrlText 1400)];
}];

// Save existing preset
// Only possible for profile presets
(displayCtrl 1601) ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];

	if (lbCurSel 1503 == -1) exitWith {systemChat "[ERROR] No preset selected to save"};
	
	private _profilePresets = (profileNamespace getVariable "PIG_JetMenu_profilePresets");
	private _key = lbText [1503, (lbCurSel 1503)];
	private _aircraftSel = localNameSpace getVariable "PIG_airCraftSelected";
	
	private _loadout = PIG_jetLoadout;
	_profilePresets set [_key, [_aircraftSel, _loadout]];
	[_aircraftSel] call PIG_fnc_reloadPresetsLb;
}];

// Load
(displayCtrl 1602) ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	
	// Load the text
	private _key = lbText [1503, (lbCurSel 1503)];
	
	if (_key isEqualTo "") exitWith {systemChat "[ERROR] No preset selected to load"};

	private _aircraftSel = localNameSpace getVariable "PIG_airCraftSelected";
	private _vehicleLocal = uiNamespace getVariable "PIG_JetMenu_vehicleLocal";

	// Cfg Preset
	if (_key in PIG_JetMenu_cfgPresets) then {
		private _pylonsCfg = PIG_JetMenu_cfgPresets get _key;
		if (_pylonsCfg isEqualTo []) then {
			// Reset to default
			lbClear 1501;
			_pylonPaths = configProperties [configFile >> "CfgVehicles" >> _aircraftSel >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];

			{
				_pylonName = configName _x;
				lbAdd [1501, (_pylonName + " " + "-" + " " + "empty")];
				lbSetData [1501, _forEachIndex, _pylonName]; // Save the default names
				lbSetColor [1501, _forEachIndex, [1, 0, 0, 1]]; // RED COLOR
				PIG_jetLoadout set [_forEachIndex, ""];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, "", true];
			} forEach _pylonPaths;
		};

		{
			if (_x isEqualTo "") then {
				_defaultName = lbData [1501, _forEachIndex];
				lbSetText [1501, _forEachIndex, _defaultName + " " + "-" + " " + "empty"];
				lbSetColor [1501, _forEachIndex, [1, 0, 0, 1]]; // RED COLOR
				PIG_jetLoadout set [_forEachIndex, ""];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, "", true];
			} else {
				lbSetText [1501, _forEachIndex, _x];
				lbSetColor [1501, _forEachIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
				PIG_jetLoadout set [_forEachIndex, _x];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, _x, true];
			}
		}forEach _pylonsCfg;
	};

	// Profile presets
	private _profilePresets = (profileNamespace getVariable "PIG_JetMenu_profilePresets");
	if (_key in _profilePresets) then {
		private _pylonsProfile = ((_profilePresets get _key) # 1); // # 1 = array that cointains the magazines and pylons in order

		{
			if (_x isEqualTo "") then {
				_defaultName = lbData [1501, _forEachIndex];
				lbSetText [1501, _forEachIndex, _defaultName + " " + "-" + " " + "empty"];
				lbSetColor [1501, _forEachIndex, [1, 0, 0, 1]]; // RED COLOR
				PIG_jetLoadout set [_forEachIndex, ""];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, "", true];
			} else {
				lbSetText [1501, _forEachIndex, _x];
				lbSetColor [1501, _forEachIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
				PIG_jetLoadout set [_forEachIndex, _x];
				private _realPylon = (_forEachIndex + 1);
				_vehicleLocal setPylonLoadout [_realPylon, _x, true];
			}
		}forEach _pylonsProfile;
	};

}];

// Rename
// Only possible for profile presets
(displayCtrl 1604) ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];

	private _aircraftSel = localNameSpace getVariable "PIG_airCraftSelected";

	if ((lbCurSel 1503) isEqualTo -1) exitWith {systemChat "[ERROR] No preset selected to rename"};
	private _key = lbText [1503, (lbCurSel 1503)]; // The text that shows in the lb is the key name in the hashmaps
	if (_key in PIG_JetMenu_cfgPresets) exitWith {systemChat format ["[ERROR] Can't rename the cfg presets", str _key]};

	private _profilePresets = (profileNamespace getVariable "PIG_JetMenu_profilePresets");
	
	if ((ctrlText 1400) isEqualTo "") exitWith {systemChat "Enter a name for you preset"};
	
	// The renamed key
	_renamedText = (ctrlText 1400);
	if (_renamedText in _profilePresets) exitWith {systemChat format ["[ERROR] This name %1 already exist in your saved presets", str _renamedText]};

	// Save original value
	private _value = _profilePresets get _key; 
	 // Delete key
	_deleted = _profilePresets deleteAt _key;
	// Save new key and get original value from the deleted key
	_profilePresets set [_renamedText, _value]; 
	// Update lb text
	lbSetText [1503, (lbCurSel 1503), _renamedText];
	[_aircraftSel] call PIG_fnc_reloadPresetsLb; 
}];

// Delete
// Only possible for profile presets
(displayCtrl 1603) ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	
	if (lbCurSel 1503 isEqualTo -1) exitWith {systemChat "[ERROR] No preset selected to delete"};
	private _key = lbText [1503, (lbCurSel 1503)];
	private _profilePresets = (profileNamespace getVariable "PIG_JetMenu_profilePresets");
	if (_key in _profilePresets) then {
		_profilePresets deleteAt _key;
		lbDelete [1503, (lbCurSel 1503)];
	};
	
	// Select last cursel
	(displayCtrl 1503) lbSetCurSel (lbCurSel 1503);
	private _aircraftSel = localNameSpace getVariable "PIG_airCraftSelected";
	[_aircraftSel] call PIG_fnc_reloadPresetsLb;
}];

// Closing display
(findDisplay 8888) displayAddEventHandler ["Unload", {

	// Clear variables
	PIG_jetLoadout = nil; 
	PIG_fnc_reloadPresetsLb = nil; 
	PIG_fnc_spawnLocalJet = nil;
	(uiNamespace getVariable 'PiG_jetMenu_camera') cameraEffect ['terminate','back']; 
	camDestroy (uiNamespace getVariable 'PiG_jetMenu_camera'); 
	uiNamespace setVariable ['PiG_jetMenu_camera', nil]; 
	deleteVehicle (uiNamespace getVariable 'PIG_JetMenu_vehicleLocal');
	uiNamespace setVariable ['PIG_JetMenu_vehicleLocal', nil];
	deleteVehicle (uiNamespace getVariable 'PIG_JetMenu_placeholder');
	uiNamespace setVariable ['PIG_JetMenu_placeholder', nil];
	deleteVehicle (uiNamespace getVariable 'PIG_jetMenu_LightSource');
	uiNamespace setvariable ["PIG_jetMenu_LightSource", nil];
}];
