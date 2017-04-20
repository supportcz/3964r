
TYPE
	FromFronius : 	STRUCT 
		arcPresent : BOOL;
		processActive : BOOL;
		powerSourceReady : BOOL;
	END_STRUCT;
	FromComau : 	STRUCT 
		ArcOn : BOOL;
		RobotReady : BOOL;
		Bit0_OperatingMode : BOOL;
		Bit1_OperatingMode : BOOL;
		Bit2_OperatingMode : BOOL;
		JobNumber : UINT;
	END_STRUCT;
	Interface3964R : 	STRUCT 
		fromComau : FromComau;
		fromFronius : FromFronius;
	END_STRUCT;
END_TYPE
