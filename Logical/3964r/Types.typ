
TYPE
	FromFronius : 	STRUCT 
		arcStable : BOOL;
		processActive : BOOL;
		mainCurrentSignal : BOOL;
		torchCollisionProtection : BOOL;
		powerSourceReady : BOOL;
		communicationReady : BOOL;
		powerOutsideRange : BOOL;
		weldingVoltageActual : UINT;
		weldingCurrentActual : UINT;
		wireFeedSpeed : UINT;
	END_STRUCT;
	FromComau : 	STRUCT 
		weldingStart : BOOL;
		robotReady : BOOL;
		modesBit0 : BOOL;
		modesBit1 : BOOL;
		modesBit2 : BOOL;
		gasTest : BOOL;
		wireInching : BOOL;
		wireRetract : BOOL;
		touchSensing : BOOL;
		torchBlowOut : BOOL;
		jobNumber : USINT;
		weldingSimulation : BOOL;
		powerCommand : UINT;
		arcLengthCorrection : UINT;
		pulseCorrection : USINT;
		burnBackCommand : USINT;
		synchroPulseDisable : BOOL;
		temp : ARRAY[0..19]OF USINT;
	END_STRUCT;
	Interface3964R : 	STRUCT 
		fromComau : FromComau;
		fromFronius : FromFronius;
	END_STRUCT;
END_TYPE
