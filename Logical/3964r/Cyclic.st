
PROGRAM _CYCLIC
	CASE step OF
		0:
			xopenconfig.rx_cnt := 1;
			xopenconfig.tx_cnt := 1;
			
			FRM_xopen_0.enable := TRUE;
			FRM_xopen_0.device := ADR('IF6.ST1.IF1');
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
			FRM_gbuf_0.enable := TRUE;
			FRM_gbuf_0.ident := FRM_xopen_0.ident;
			FRM_gbuf_0();
			
			IF FRM_gbuf_0.status = 0 THEN
				step := step + 1;
			END_IF
		
		4:
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
		
		5:
			FRM_read_0.enable := TRUE;
			FRM_read_0.ident := FRM_xopen_0.ident;
			FRM_read_0();
				
			IF FRM_read_0.status = 0 THEN
				step := step + 1;
			END_IF
		
		6:			
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
		
		7:
			IF dataReadLength > 1 THEN
				//compute checksum
				BCC := 0;
				FOR i:= 0 TO dataReadLength - 2 DO
					BCC := BCC XOR dataRead[i];
				END_FOR
				IF BCC = dataRead[dataReadLength - 1] THEN
					CASE dataRead[0] OF
						1:
							interface3964R.fromComau.ArcOn := dataRead[0].0;
							interface3964R.fromComau.RobotReady := dataRead[0].1;
							interface3964R.fromComau.Bit0_OperatingMode := dataRead[0].2;
							interface3964R.fromComau.Bit1_OperatingMode := dataRead[0].3;
							interface3964R.fromComau.Bit2_OperatingMode := dataRead[0].4;
							interface3964R.fromComau.JobNumber := dataRead[2] + 256*dataRead[3];
						4:

						5:
						
					END_CASE
					telegramType := dataRead[0];
					step := step + 1;
				END_IF
			END_IF
		8:
			FRM_gbuf_0.enable := TRUE;
			FRM_gbuf_0.ident := FRM_xopen_0.ident;
			FRM_gbuf_0();
			
			IF FRM_gbuf_0.status = 0 THEN
				step := step + 1;
			END_IF
		
		9:
			dataWrite[0] := 16#10;
			dataWrite[1] := 16#2;
			dataWriteLenght := 2;
			
			memcpy(FRM_gbuf_0.buffer, ADR(dataWrite), dataWriteLenght);
			
			FRM_write_0.enable := TRUE;
			FRM_write_0.ident := FRM_xopen_0.ident;
			FRM_write_0.buffer := FRM_gbuf_0.buffer;
			FRM_write_0.buflng := dataWriteLenght;
			FRM_write_0();
		
			IF FRM_write_0.status = 0 THEN
				step := step + 1;
			END_IF

		10:
			FRM_read_0.enable := TRUE;
			FRM_read_0.ident := FRM_xopen_0.ident;
			FRM_read_0();
				
			IF FRM_read_0.status = 0 THEN
				step := step + 1;
			END_IF
		
		11:			
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
		
		12:
			IF dataReadLength = 1 AND dataRead[0] = 16#10 THEN
				step := step + 1;
			END_IF
		
		13:
			FRM_gbuf_0.enable := TRUE;
			FRM_gbuf_0.ident := FRM_xopen_0.ident;
			FRM_gbuf_0();
			
			IF FRM_gbuf_0.status = 0 THEN
				step := step + 1;
			END_IF
		
		14:
			CASE telegramType OF
				1:
					dataWrite[0] := 16#06;
					dataWrite[1] := 16#00;
					dataWriteLenght := 2;
				4:
					dataWrite[0] := 16#04;
					dataWrite[1] := 16#40;
					dataWrite[2] := 16#26;
					dataWrite[3] := 16#00;
					dataWrite[4] := 16#0D;
					dataWriteLenght := 5;
				5:
					dataWrite[0].0 := interface3964R.fromFronius.arcPresent;
					dataWrite[0].2 := interface3964R.fromFronius.processActive;
					dataWrite[0].5 := interface3964R.fromFronius.powerSourceReady;
					dataWrite[1] := 16#55;
					dataWrite[2] := 16#2E;
					dataWrite[3] := 16#B4;
					dataWrite[4] := 16#08;
					dataWrite[5] := 16#00;
					dataWrite[6] := 16#C8;
					dataWrite[7] := 16#00;
					dataWriteLenght := 8;
			END_CASE
			
			//add 16#10, 16#03
			dataWrite[dataWriteLenght] := 16#10;
			dataWrite[dataWriteLenght+1] := 16#03;
			
			//add checksum
			BCC := 0;
			FOR i:= 0 TO dataWriteLenght + 1 DO
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
				step := step + 1;
			END_IF

		15:
			FRM_read_0.enable := TRUE;
			FRM_read_0.ident := FRM_xopen_0.ident;
			FRM_read_0();
				
			IF FRM_read_0.status = 0 THEN
				step := step + 1;
			END_IF
		
		16:			
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
		
		17:
			IF dataReadLength = 1 AND dataRead[0] = 16#10 THEN
				step := 1;
			END_IF

	END_CASE
	
			
END_PROGRAM
