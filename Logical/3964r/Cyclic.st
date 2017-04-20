
PROGRAM _CYCLIC
	CASE step OF
		0:
			xopenconfig.rx_cnt := 3;
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
//			IF dataReadLength = 1 AND dataRead[0] = 16#2 THEN
				step := step + 1;
//			END_IF
//			IF dataReadLength = 1 AND dataRead[0] = 16#15 THEN
//				step := step + 1;
//			END_IF

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
				step := 1;
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
			IF dataReadLength = 1 THEN
				step := 1;
			END_IF
			
			IF dataReadLength > 1 THEN
				step := step + 1;
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
			dataWrite[0] := 16#2;
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

		11:
			FRM_read_0.enable := TRUE;
			FRM_read_0.ident := FRM_xopen_0.ident;
			FRM_read_0();
				
			IF FRM_read_0.status = 0 THEN
				step := step + 1;
			END_IF
		
		12:			
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
		
		13:
			IF dataReadLength = 1 AND dataRead[0] = 16#10 THEN
				step := step + 1;
			END_IF
		
		14:
			FRM_gbuf_0.enable := TRUE;
			FRM_gbuf_0.ident := FRM_xopen_0.ident;
			FRM_gbuf_0();
			
			IF FRM_gbuf_0.status = 0 THEN
				step := step + 1;
			END_IF
		
		15:
			dataWrite[0] := 16#1;
			dataWrite[0] := 16#2;
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


	END_CASE
	
			
END_PROGRAM
