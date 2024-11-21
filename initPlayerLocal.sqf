player addAction ["Open Jet Spawn Menu", {
	
	[] call PIG_fnc_jetMenu;
	},	
	nil,
	1.5,
	true,
	true,
	"",
	toString {
		(isNull (objectParent _originalTarget))
		&& {markerPos "spawn_jet" distance _originalTarget < 30} 
	},
	20,
	false,
	"",
	""
];

// View distance
player addAction [["<t size='1.1' color='#E99B00'>", "Change View Distance", "</t>"] joinString "", {
	params ["_target", "_caller", "_actionId", "_arguments"];

	[] call PIG_fnc_setViewDistance;
	},
	nil,		// arguments
	-100,		// priority
	false,		// showWindow
	true,		// hideOnUse
	"User12",	// shortcut (You can put a shortcut in User 12 custom controls)
	"true",		// condition
	50,			// radius
	false,		// unconscious
	"",			// selection
	""			// memoryPoint
]
