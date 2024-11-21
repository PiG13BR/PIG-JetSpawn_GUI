player addAction [format ["<img size='2' image='a3\air_f_jets\plane_fighter_01\data\ui\fighter01_icon_ca.paa'/><t size='1.3' color='#EFF700'>Open Jet Menu Spawn</t>"], {
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
player addAction [format ["<t size='1.1' color='#E99B00'>"Change View Distance</t>"], {
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
