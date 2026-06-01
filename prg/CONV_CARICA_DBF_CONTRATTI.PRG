*************************************************************************************************
*					         	    CARICAMENTO DBF CONTRATTI IMPIANTI   			            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2023 : Assolo	 			 														*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA CONTRATTI_SERVIZI IMPIANTI ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	


WAIT WINDOWS "SELEZIONA LA TABELLA : CONTRATTI_SERVIZI" 
**** CARICAMENTO DEL FILE DBF
TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(TABELLA_INPUT)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF
WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 



*** CANCELLAZIONE DEI RECORD DELLA TABELLA IMPIANTI_CO SQL
WAIT WINDOWS "Cancellazione IMPIANTI_CO ...  -  Prego Attendere" NOWAIT
cSql   = "truncate table IMPIANTI_CO" 
IF !ExecCommand(cSql,"IMPIANTI_CO")
   return(.f.)
ENDIF



_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
IF !USED(TABELLA_INPUT)
   USE &TABELLA_INPUT IN 0 AGAIN
ENDIF

SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio IMPIANTI_CO attendere prego ....." NOWAIT


SELECT &_NOME_TABELLA
GO TOP 

SCAN

	SCATTER MEMVAR MEMO
	
	M.ID_PMKEY = ALLTRIM(M.ID_PMKEY)
	M.ID_PMCONTR = ALLTRIM(M.ID_PMCONTR)
	
		
	WAIT WINDOWS "Contratto caricato: " + M.ID_PMKEY NOWAIT


	**==> CREAZIONE TABELLA IMPIANTO
		
	IF !ExecRW("select * from IMPIANTI_CO where 0=1","IMPIANTI_CO","R")
	   return(.f.)
	ENDIF
	SELECT IMPIANTI_CO
	APPEND BLANK
	GATHER MEMVAR MEMO


	REPLACE CSCAD_A     	WITH RIBALTA2(CSCAD_A)           
	REPLACE CSCAD_B     	WITH RIBALTA2(CSCAD_B)              
	REPLACE CSCAD_C     	WITH RIBALTA2(CSCAD_C)                
	REPLACE CSCAD_D1     	WITH RIBALTA2(CSCAD_D1)             
	REPLACE CSCAD_D2     	WITH RIBALTA2(CSCAD_D2)               
	REPLACE CSCAD_E1     	WITH RIBALTA2(CSCAD_E1)               
	REPLACE CSCAD_E2     	WITH RIBALTA2(CSCAD_E1)               
	REPLACE CSCAD_F1     	WITH RIBALTA2(CSCAD_F1)               
	REPLACE CSCAD_F2     	WITH RIBALTA2(CSCAD_F2)   
	M.TIPO_COMPONENTE = "001"  && CALDAIA          
	REPLACE TIPO_COMPONENTE	WITH M.TIPO_COMPONENTE 	
	*REPLACE CRINNOVARE		WITH .F.

	
	x_pmkey  = "id_pmkey = '" + ALLTRIM(M.ID_PMKEY) + "'"
	x_tipoco = "tipo_componente = '" + ALLTRIM(M.TIPO_COMPONENTE) + "'"
	x_rigo   = "ID_RIGO = '" + ALLTRIM(M.ID_RIGO) + "'"
	x_cond   = x_pmkey + " and " + x_tipoco + " and " + x_rigo
    cSql   = "SELECT * FROM IMPIANTI_DD WHERE " + x_cond
    IF !ExecCommand(cSql,"CUR_IMPIANTI_DD")
       return(.f.)
    ENDIF
	
	IF !EOF()
*!*			__DT_INSTALL = DT_INSTALL
*!*			__DT_CINIZCONTR = CINIZCONTR
*!*			__DT_CSCADCONTR = CSCADCONTR

		__CDITTACAL = CDITTACAL
		__CMODCAL = CMODCAL
		__CMATCAL = CMATCAL
		__GRUPPO  = GRUPPO
	ELSE
*!*			__DT_INSTALL = ""
*!*			__DT_CSCADCONTR = ""
		__CDITTACAL = ""
		__CMODCAL = ""
		__CMATCAL = ""
		__GRUPPO  = ""
	ENDIF
	
*!*		__ANNO_CONTR = SUBSTR(__DT_INSTALL,1,4)


	SELECT IMPIANTI_CO

*!*		REPLACE ANNO_CONTR	WITH __ANNO_CONTR
*!*		=CAMBIADT(__DT_INSTALL,"DT_REGIST")
*!*		=CAMBIADT(__DT_CINIZCONTR,"CINIZCONTR")
*!*		=CAMBIADT(__DT_CSCADCONTR,"CSCADCONTR")
*!*		=CAMBIADT(__DT_INSTALL,"DT_CONFERM")
*!*		=CAMBIADT(__DT_INSTALL,"DT_INIZIO")
	
	REPLACE CDITTACAL   WITH __CDITTACAL 
	REPLACE CMODCAL		WITH __CMODCAL 
	REPLACE CMATCAL		WITH __CMATCAL 
	REPLACE GRUPPO		WITH __GRUPPO  
	

	
	IF !ExecRW("select * from IMPIANTI_CO where 0=1","IMPIANTI_CO","W")
	   return(.f.)
	ENDIF
	

	SELECT &_NOME_TABELLA
	
ENDSCAN


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

