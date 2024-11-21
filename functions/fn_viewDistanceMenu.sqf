/*
	File: fn_viewDistanceMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 2024/31/10
	Last Update: 2024/04/10
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Manages the view distance slider bar and toggle it when moved by the player

	Parameter(s):
		-
	
	Returns:
		-
*/

createDialog "PIG_RscViewDistance";

// Get video setting values when open dialog
sliderSetRange [1900, 500, 10000];
sliderSetPosition [1900, (viewDistance)];
sliderSetRange [1901, 500, (viewDistance)];
sliderSetPosition [1901, (viewDistance)];
sliderSetSpeed [1900, 500, 500, 0]; 
sliderSetSpeed [1901, 500, 500, 0];

ctrlSetText [1400, str (viewDistance)];
ctrlSetText [1401, str ((getObjectViewDistance) # 0)];

// Add UI Event handlers
(displayCtrl 1900) ctrlAddEventHandler ["SliderPosChanged", {
	params ["_control", "_newValue"];

	setViewDistance _newValue;
	ctrlSetText [1400, str _newValue];

	// Change values from view object distance slider and edit box
	sliderSetRange [1901, 500, _newValue];
	sliderSetPosition [1901, (_newvalue/1.3)];
	ctrlSetText [1401, (str (_newValue/1.3))];
	// If reaches below minimal threshold
	if ((parseNumber (ctrlText 1401)) < 500) then {
		ctrlSetText [1401, str 500];
	};
}];

(displayCtrl 1400) ctrlAddEventHandler ["EditChanged", {
	params ["_control", "_newText"];
	
	_value = parseNumber _newText;
	
	setViewDistance _value;
	sliderSetPosition [1900, _value];
}];

(displayCtrl 1901) ctrlAddEventHandler ["SliderPosChanged", {
	params ["_control", "_newValue"];

	setObjectViewDistance _newValue;
	ctrlSetText [1401, str _newValue];
}];

(displayCtrl 1401) ctrlAddEventHandler ["EditChanged", {
	params ["_control", "_newText"];
	
	_value = parseNumber _newText;
	
	setObjectViewDistance _value;
	sliderSetPosition [1901, _value];
}];
