PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	CASE step OF
		0:
			S39SOpen_0.enable := TRUE;
			S39SOpen_0.pDevice := ADR('IF6.ST1.IF1');
			S39SOpen_0.pMode := ADR('/PHY=RS422 /BD=38400 /PA=E /DB=8 /SB=1');
			S39SOpen_0.rk512 := FALSE;
			S39SOpen_0.buflen := 280;
			S39SOpen_0.timeout := 0;
			S39SOpen_0.retry := 0;

			S39SOpen_0();
		
			IF S39SOpen_0.status = 0 THEN
				step := 1;
			END_IF
		
		1:
			rxBuffer ACCESS S39SOpen_0.rx_buf;
			txBuffer ACCESS S39SOpen_0.tx_buf;
			
			S39Slave_0.enable := TRUE;
			S39Slave_0.ident := S39SOpen_0.ident;
			S39Slave_0.mode := s39MODE_SEND_ONLY;//s39MODE_RECV_ONLY;//s39MODE_SEND_RECV;
			S39Slave_0();
			
	END_CASE
	 
END_PROGRAM
