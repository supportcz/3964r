
PROGRAM _CYCLIC
	
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
							
								interface3964R.fromComau.weldingStart := dataRead[1].0;
								interface3964R.fromComau.robotReady := dataRead[1].1;
								interface3964R.fromComau.operatingMode0 := dataRead[1].2;
								interface3964R.fromComau.operatingMode1 := dataRead[1].3;
								interface3964R.fromComau.operatingMode2 := dataRead[1].4;
								interface3964R.fromComau.masterSelectionTwinBit1 := dataRead[1].5;
								interface3964R.fromComau.gasOpen := dataRead[2].0;
								interface3964R.fromComau.wireInching := dataRead[2].1;
								interface3964R.fromComau.wireRetract := dataRead[2].2;
								interface3964R.fromComau.sourceErrorReset := dataRead[2].3;
								interface3964R.fromComau.touchSensing := dataRead[2].4;
								interface3964R.fromComau.torchBlowOut := dataRead[2].5;
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
						dataWrite[3].0 := interface3964R.fromFronius.arcEstablished;//16#40;
						dataWrite[3].1 := interface3964R.fromFronius.limitSigal;
						dataWrite[3].2 := interface3964R.fromFronius.processActive;
						dataWrite[3].5 := interface3964R.fromFronius.powerSourceReady;
						dataWrite[3].6 := interface3964R.fromFronius.communicationReady;
						dataWrite[4] := interface3964R.fromFronius.errorNumber;//16#26;
						dataWrite[6].0 := interface3964R.fromFronius.wireStickControl;//16#0D;
						dataWrite[6].2 := interface3964R.fromFronius.robotAccess;
						dataWrite[6].3 := interface3964R.fromFronius.wireDetect;
						dataWrite[6].4 := interface3964R.fromFronius.shortCircuitTimeout;
						dataWrite[6].5 := interface3964R.fromFronius.dataDocumentationReady;
						dataWriteLenght := 7;
					5:
						dataWrite[2] := 16#05;
						dataWrite[3] := UINT_TO_USINT(interface3964R.fromFronius.weldingVoltage AND 16#FF);//16#55;
						dataWrite[4] := UINT_TO_USINT(SHR(interface3964R.fromFronius.weldingVoltage,8));//16#2E;
						dataWrite[5] := UINT_TO_USINT(interface3964R.fromFronius.weldingCurrent AND 16#FF);//16#B4;
						dataWrite[6] := UINT_TO_USINT(SHR(interface3964R.fromFronius.weldingCurrent,8));//16#08;
						dataWrite[7] := interface3964R.fromFronius.motorCurrent;
						dataWrite[8] := UINT_TO_USINT(interface3964R.fromFronius.wireFeedSpeed AND 16#FF);
						dataWrite[9] := UINT_TO_USINT(SHR(interface3964R.fromFronius.wireFeedSpeed,8));
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
			
END_PROGRAM
