// Put the classnames of airplanes and helicopters that you want to spawn in the array below

_aircrafts = [
	// NATO Planes (Vanilla)
	"B_Plane_CAS_01_dynamicLoadout_F", 
	"B_Plane_Fighter_01_F", 
	// OPFOR Planes (Vanilla)
	"O_Plane_CAS_02_dynamicLoadout_F",
	"O_Plane_Fighter_02_F",
	// POOK Soviet Pack
	"pook_MIG21_OPFOR",
	"pook_Mig23_OPFOR",
	"pook_MIG29_OPFOR",
	"pook_MIG31_OPFOR",
	"pook_MIG35_OPFOR",
	"pook_Su22_OPFOR",
	"pook_SU27_OPFOR",
	"pook_SU30_OPFOR",
	"pook_YAK38_OPFOR",
	// FIR
	"FIR_A10C",
	"FIR_EA6B",
	"FIR_F14D",
	"FIR_F15D",
	"FIR_F16D",
	"FIR_F18D",
	"FIR_AV8B_NA_Blank",
	"FIR_F22",
	"FIR_Su25SM3"
];

_aircrafts = _aircrafts select {isClass (configFile >> "CfgVehicles" >> _x)};

_aircrafts
