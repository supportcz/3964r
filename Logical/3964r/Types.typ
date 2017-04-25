
TYPE
	FromFronius : 	STRUCT 
		arcEstablished : BOOL;
		limitSigal : BOOL;
		processActive : BOOL;
		powerSourceReady : BOOL;
		communicationReady : BOOL;
		errorNumber : USINT;
		wireStickControl : BOOL;
		robotAccess : BOOL;
		wireDetect : BOOL;
		shortCircuitTimeout : BOOL;
		dataDocumentationReady : BOOL;
		weldingVoltage : UINT;
		weldingCurrent : UINT;
		motorCurrent : USINT;
		wireFeedSpeed : UINT;
	END_STRUCT;
	FromComau : 	STRUCT 
		weldingStart : BOOL;
		robotReady : BOOL;
		operatingMode0 : BOOL;
		operatingMode1 : BOOL;
		operatingMode2 : BOOL;
		masterSelectionTwinBit1 : BOOL;
		gasOpen : BOOL;
		wireInching : BOOL;
		wireRetract : BOOL;
		sourceErrorReset : BOOL;
		touchSensing : BOOL;
		torchBlowOut : BOOL;
		programNumber : USINT;
		weldingSimulation : BOOL;
		temp : ARRAY[0..19]OF USINT;
	END_STRUCT;
	Interface3964R : 	STRUCT 
		fromComau : FromComau;
		fromFronius : FromFronius;
	END_STRUCT;
END_TYPE
