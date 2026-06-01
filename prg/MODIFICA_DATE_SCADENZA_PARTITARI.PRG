SELECT CUR_PIANOP_DD
GO TOP

DO WHILE !EOF()

	IF EMPTY(DTSCADOLD) OR DTSCAD=DTSCADOLD
	    SELECT CUR_PIANOP_DD
		SKIP
		LOOP
	ENDIF

	_CODFOR=ALLTRIM(CODFOR)
	_DTSCAD=DTSCAD
	_DTSCADOLD=DTSCADOLD
	_NPART=NPART

	x_soci = "con_soc = '" + PUB_CODSOC + "'"
	x_anno = "con_anno = '" + PUB_ANNO + "'"
	x_annp = "con_anno = '" + PUB_ANNOP + "'"
	x_cont = "con_conto = '" + _CODFOR + "'"
	x_cond = x_soci + " and " + x_anno + " and " + x_cont
    
    Csql   = "select * from conti where " + x_cond 
	
	IF !ExecCommand(cSql,"_cur_conti")
	   return(.f.)
	ENDIF
	SELECT _cur_conti
	GO TOP
	IF EOF()
	   PUB_ERRORE=MESSAGEBOX('Conto inesistente durante'+CHR(13)+"l'aggiornamento partitario",64,'*** ATTENZIONE ***')
	   RETURN
	ENDIF
	
	
	CLI_FOR = SUBSTR(CON_TIPOCO,1,1)

	IF CLI_FOR='C'
	****** PARTITARIO CLIENTI
		x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "par_codcli = '" + ALLTRIM(_CODFOR) + "'"
		x_data = "par_dtSCAD = '" + _DTSCADOLD+ "' "
		x_npart= "par_npart = " + ALLTRIM(STR(_NPART,10,0)) 
		
	    cSql="SELECT * FROM PART_CLI WHERE " + x_soci + " and " + x_codi + ;
	                                      " and " + x_npart + " and " + x_data
	                                      

		IF !ExecRW(cSql,"CUSS_PARTCLI","R")
		   return(.f.)
		ENDIF
					    
	    SELECT CUSS_PARTCLI
	    REPLACE PAR_DTSCAD WITH _DTSCAD ALL
	    GO TOP

		IF !ExecRW('','PART_CLI','I','','CUSS_PARTCLI')
		   return(.f.)
		ENDIF	
	
		*!*		RICREA I SALDI DELLA PARTITA 

		=CREA_SALDI_CF(CLI_FOR,_CODFOR,_npart,"XXXXXXXXXX","CREA")	
	
	
	ENDIF


	IF CLI_FOR='F'
	******** PARTITARIO FORNITORE
	
		x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "par_codcli = '" + ALLTRIM(_CODFOR) + "'"
		x_data = "par_dtSCAD = '" + _DTSCADOLD+ "' "
		x_npart= "par_npart = " + ALLTRIM(STR(_NPART,10,0)) 
		
	    cSql="SELECT * FROM PART_FOR WHERE " + x_soci + " and " + x_codi + ;
	                                      " and " + x_npart + " and " + x_data
	                                      

		IF !ExecRW(cSql,"CUSS_partfor","R")
		   return(.f.)
		ENDIF
					    
	    SELECT CUSS_PARTFOR
	    REPLACE PAR_DTSCAD WITH _DTSCAD ALL
	    GO TOP

		IF !ExecRW('','part_for','I','','CUSS_PARTFOR')
		   return(.f.)
		ENDIF	
	
		*!*		RICREA I SALDI DELLA PARTITA 

		=CREA_SALDI_CF(CLI_FOR,_CODFOR,_npart,"XXXXXXXXXX","CREA")	
	
	
	ENDIF
	

	SELECT CUR_PIANOP_DD
	SKIP

ENDDO

