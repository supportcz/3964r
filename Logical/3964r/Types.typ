
TYPE
	FromFronius : 	STRUCT 
		arcPresent : BOOL;
		limitSigal : BOOL;
		processActive : BOOL;
		mainCurrentSignal : BOOL;
		torchCollisionProtection : BOOL;
		powerSourceReady : BOOL;
		communicationReady : BOOL;
		errorNumber : USINT;
		wireStickControl : BOOL;
		robotAccess : BOOL;
		wireAvailable : BOOL;
		timeoutShortCircuit : BOOL;
		dataDocumentationReady : BOOL;
		actualWeldingVoltage : UINT;
		actualWeldingCurrent : UINT;
		actualMotorCurrent : USINT;
		actualWireFeed : UINT;
	END_STRUCT;
	FromComau : 	STRUCT 
		arcOn : BOOL;
		robotReady : BOOL;
		bit0_OperatingModes : BOOL;
		bit1_OperatingModes : BOOL;
		bit2_OperatingModes : BOOL;
		twinMasterIdentifier : BOOL;
		gasTest : BOOL;
		wireFeed : BOOL;
		wireRetract : BOOL;
		sourceErrorReset : BOOL;
		touchSensing : BOOL;
		torchBlowThrough : BOOL;
		programNumber : USINT;
		weldingSimulation : BOOL;
		temp : ARRAY[0..19]OF USINT;
	END_STRUCT;
	Interface3964R : 	STRUCT 
		fromComau : FromComau;
		fromFronius : FromFronius;
	END_STRUCT;
END_TYPE
