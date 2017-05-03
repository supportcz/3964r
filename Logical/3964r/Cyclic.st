
PROGRAM _CYCLIC
	
	(* read data from new Fronius *)
	interface3964R.fromFronius.powerSourceReady := profinetInputByte[0].1;
	interface3964R.fromFronius.processActive := profinetInputByte[0].3;
	interface3964R.fromFronius.arcPresent := profinetInputByte[0].4;
	interface3964R.fromFronius.mainCurrentSignal := profinetInputByte[0].6;

	interface3964R.fromFronius.actualWeldingVoltage := profinetInputWord[0];
	interface3964R.fromFronius.actualWeldingCurrent := profinetInputWord[1];
	interface3964R.fromFronius.actualWireFeed := profinetInputWord[2];

	
	(* communication with old Fronius *)
	REPEAT
		stepOld := step;
		
		CASE step OF
			0:
				xopenconfig.rx_cnt := 1;
				xopenconfig.tx_cnt := 1;
			
				FRM_xopen_0.enable := TRUE;
				FRM_xopen_0.device := ADR('SS1.IF1');
				//			FRM_xopen_0.device := ADR('IF6.ST1.IF1');
				FRM_xopen_0.mode := ADR('/PHY=RS422 /BD=38400 /PA=E /DB=8 /SB=1');
				FRM_xopen_0.config := ADR(xopenconfig);
			
				FRM_xopen_0();
	 
				IF FRM_xopen_0.status = 0 THEN
					step := 1;
				END_IF
		
			1:
				FRM_read_0.enable := TRUE;
				FRM_read_0.ident := FRM_xopen_0.ident;
				FRM_read_0();
				
				IF FRM_read_0.status = 0 THEN				
					step := step + 1;
				END_IF
		
			2:			
				dataReadLength := MIN(FRM_read_0.buflng, SIZEOF(dataRead));
				memcpy(ADR(dataRead), FRM_read_0.buffer, dataReadLength);
			
				FRM_rbuf_0.enable := TRUE;
				FRM_rbuf_0.ident := FRM_xopen_0.ident;
				FRM_rbuf_0.buffer := FRM_read_0.buffer;
				FRM_rbuf_0.buflng := dataReadLength;
				FRM_rbuf_0();
			
				IF FRM_rbuf_0.status = 0 THEN
					step := step + 1;
				END_IF
		
			3:
				IF dataReadLength = 1 AND dataRead[0] = 16#02 THEN
					step := step + 1;
				ELSE
					step := 1;
				END_IF
		
			4:
				FRM_gbuf_0.enable := TRUE;
				FRM_gbuf_0.ident := FRM_xopen_0.ident;
				FRM_gbuf_0();
			
				IF FRM_gbuf_0.status = 0 THEN
					step := step + 1;
				END_IF
		
			5:
				dataWrite[0] := 16#10;
				dataWriteLenght := 1;
			
				memcpy(FRM_gbuf_0.buffer, ADR(dataWrite), dataWriteLenght);
			
				FRM_write_0.enable := TRUE;
				FRM_write_0.ident := FRM_xopen_0.ident;
				FRM_write_0.buffer := FRM_gbuf_0.buffer;
				FRM_write_0.buflng := dataWriteLenght;
				FRM_write_0();
		
				IF FRM_write_0.status = 0 THEN
					step := step + 1;
				END_IF
		
			6:
				FRM_read_0.enable := TRUE;
				FRM_read_0.ident := FRM_xopen_0.ident;
				FRM_read_0();
				
				IF FRM_read_0.status = 0 THEN
					step := step + 1;
				END_IF
		
			7:			
				dataReadLength := MIN(FRM_read_0.buflng, SIZEOF(dataRead));
				memcpy(ADR(dataRead), FRM_read_0.buffer, dataReadLength);
			
				FRM_rbuf_0.enable := TRUE;
				FRM_rbuf_0.ident := FRM_xopen_0.ident;
				FRM_rbuf_0.buffer := FRM_read_0.buffer;
				FRM_rbuf_0.buflng := dataReadLength;
				FRM_rbuf_0();
			
				IF FRM_rbuf_0.status = 0 THEN
					step := step + 1;
				END_IF
		
			8:
				IF dataReadLength > 1 THEN
					//compute checksum
					BCC := 0;
					FOR i:= 0 TO dataReadLength - 2 DO
						BCC := BCC XOR dataRead[i];
					END_FOR
					IF BCC = dataRead[dataReadLength - 1] THEN
						CASE dataRead[0] OF
							1:
								interface3964R.fromComau.temp := dataRead;
							
								interface3964R.fromComau.arcOn := dataRead[1].0;
								interface3964R.fromComau.robotReady := dataRead[1].1;
								interface3964R.fromComau.bit0_OperatingModes := dataRead[1].2;
								interface3964R.fromComau.bit1_OperatingModes := dataRead[1].3;
								interface3964R.fromComau.bit2_OperatingModes := dataRead[1].4;
								interface3964R.fromComau.twinMasterIdentifier := dataRead[1].5;
								interface3964R.fromComau.gasTest := dataRead[2].0;
								interface3964R.fromComau.wireFeed := dataRead[2].1;
								interface3964R.fromComau.wireRetract := dataRead[2].2;
								interface3964R.fromComau.sourceErrorReset := dataRead[2].3;
								interface3964R.fromComau.touchSensing := dataRead[2].4;
								interface3964R.fromComau.torchBlowThrough := dataRead[2].5;
								interface3964R.fromComau.programNumber := dataRead[4] AND 16#7F;
								interface3964R.fromComau.weldingSimulation := dataRead[4].7;

							ELSE
						
						END_CASE
						telegramType := dataRead[0];
						step := step + 1;
					ELSE
						step := 1;
					END_IF
				ELSE
					step := 1;
				END_IF
		
			9:
				FRM_gbuf_0.enable := TRUE;
				FRM_gbuf_0.ident := FRM_xopen_0.ident;
				FRM_gbuf_0();
			
				IF FRM_gbuf_0.status = 0 THEN
					step := step + 1;
				END_IF
		
			10:
				dataWrite[0] := 16#10;
				dataWrite[1] := 16#2;
				dataWriteLenght := 2;
			
				CASE telegramType OF
					4:
						dataWrite[2] := 16#04;
						dataWrite[3].0 := interface3964R.fromFronius.arcPresent;//16#40;
						dataWrite[3].1 := interface3964R.fromFronius.limitSigal;
						dataWrite[3].2 := interface3964R.fromFronius.processActive;
						dataWrite[3].3 := interface3964R.fromFronius.mainCurrentSignal;
						dataWrite[3].4 := interface3964R.fromFronius.torchCollisionProtection;
						dataWrite[3].5 := interface3964R.fromFronius.powerSourceReady;
						dataWrite[3].6 := interface3964R.fromFronius.communicationReady;
						dataWrite[4] := interface3964R.fromFronius.errorNumber;//16#26;
						dataWrite[6].0 := interface3964R.fromFronius.wireStickControl;//16#0D;
						dataWrite[6].2 := interface3964R.fromFronius.robotAccess;
						dataWrite[6].3 := interface3964R.fromFronius.wireAvailable;
						dataWrite[6].4 := interface3964R.fromFronius.timeoutShortCircuit;
						dataWrite[6].5 := interface3964R.fromFronius.dataDocumentationReady;
						dataWriteLenght := 7;
					5:
						dataWrite[2] := 16#05;
						dataWrite[3] := UINT_TO_USINT(interface3964R.fromFronius.actualWeldingVoltage AND 16#FF);//16#55;
						dataWrite[4] := UINT_TO_USINT(SHR(interface3964R.fromFronius.actualWeldingVoltage,8));//16#2E;
						dataWrite[5] := UINT_TO_USINT(interface3964R.fromFronius.actualWeldingCurrent AND 16#FF);//16#B4;
						dataWrite[6] := UINT_TO_USINT(SHR(interface3964R.fromFronius.actualWeldingCurrent,8));//16#08;
						dataWrite[7] := interface3964R.fromFronius.actualMotorCurrent;
						dataWrite[8] := UINT_TO_USINT(interface3964R.fromFronius.actualWireFeed AND 16#FF);
						dataWrite[9] := UINT_TO_USINT(SHR(interface3964R.fromFronius.actualWireFeed,8));
						dataWriteLenght := 10;
					ELSE
						dataWrite[2] := 16#06;
						dataWrite[3] := 16#00;
						dataWriteLenght := 4;
				END_CASE
			
				//add 16#10, 16#03
				dataWrite[dataWriteLenght] := 16#10;
				dataWrite[dataWriteLenght+1] := 16#03;
			
				//add checksum
				BCC := 0;
				FOR i:= 2 TO dataWriteLenght + 1 DO
					BCC := BCC XOR dataWrite[i];
				END_FOR
				dataWrite[dataWriteLenght+2] := BCC;
				dataWriteLenght := dataWriteLenght + 3;
			
				memcpy(FRM_gbuf_0.buffer, ADR(dataWrite), dataWriteLenght);
			
				FRM_write_0.enable := TRUE;
				FRM_write_0.ident := FRM_xopen_0.ident;
				FRM_write_0.buffer := FRM_gbuf_0.buffer;
				FRM_write_0.buflng := dataWriteLenght;
				FRM_write_0();
		
				IF FRM_write_0.status = 0 THEN
					step := 1;
				END_IF

		END_CASE
	
		UNTIL step = stepOld
		
	END_REPEAT
	
	(* write data to new Fronius *)
	profinetOutputByte[7];
	profinetOutputWord[14];
	profinetOutputByte[0].0 := interface3964R.fromComau.arcOn;
	profinetOutputByte[0].1 := interface3964R.fromComau.robotReady;
	profinetOutputByte[0].2 := interface3964R.fromComau.bit0_OperatingModes;
	profinetOutputByte[0].3 := interface3964R.fromComau.bit1_OperatingModes;
	profinetOutputByte[0].4 := interface3964R.fromComau.bit2_OperatingModes;
	profinetOutputByte[1].0 := interface3964R.fromComau.gasTest;
	profinetOutputByte[1].1 := interface3964R.fromComau.wireFeed;
	profinetOutputByte[1].2 := interface3964R.fromComau.wireRetract;
	profinetOutputByte[1].4 := interface3964R.fromComau.touchSensing;
	profinetOutputByte[1].5 := interface3964R.fromComau.torchBlowThrough;
	profinetOutputByte[2].0 := interface3964R.fromComau.weldingSimulation;
	
	profinetOutputWord[0] := interface3964R.fromComau.programNumber;
	profinetOutputWord[1] := interface3964R.fromComau.powerCommandValue;
	profinetOutputWord[2] := interface3964R.fromComau.arcLengthCorrection;
	profinetOutputWord[3] := interface3964R.fromComau.pulseCorrection;
	profinetOutputWord[4] := interface3964R.fromComau.stubBurnOffCorrection;

	
END_PROGRAM
