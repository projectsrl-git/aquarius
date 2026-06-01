*************************************************************************************************
*				       	    CARICAMENTO DBF RIFERIMENTI ANAGRAFICA CURIT  			            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2023 : Assolo	 			 														*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA ANAGR_RIFERIM ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	


WAIT WINDOWS "SELEZIONA LA TABELLA : ANAGR_RIFERIM" 
**** CARICAMENTO DEL FILE DBF
TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(TABELLA_INPUT)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF
WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 



*** CANCELLAZIONE DEI RECORD DELLA TABELLA IMPIANTI_AR SQL
WAIT WINDOWS "Cancellazione IMPIANTI_AR ...  -  Prego Attendere" NOWAIT
cSql   = "truncate table IMPIANTI_AR" 
IF !ExecCommand(cSql,"IMPIANTI_AR")
   return(.f.)
ENDIF



_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
IF !USED(TABELLA_INPUT)
   USE &TABELLA_INPUT IN 0 AGAIN
ENDIF

SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio IMPIANTI_AR attendere prego ....." NOWAIT


SELECT &_NOME_TABELLA
GO TOP 

SCAN

	SCATTER MEMVAR MEMO
	
	
	WAIT WINDOWS "Riferimenti Anagrafica CURIT caricata: " + M.CODICE NOWAIT


	**==> CREAZIONE TABELLA IMPIANTO
		
	IF !ExecRW("select * from IMPIANTI_AR where 0=1","IMPIANTI_AR","R")
	   return(.f.)
	ENDIF
	SELECT IMPIANTI_AR
	APPEND BLANK
	GATHER MEMVAR MEMO

	REPLACE CODICE WITH "000" + M.CODICE
	
	IF !ExecRW("select * from IMPIANTI_AR where 0=1","IMPIANTI_AR","W")
	   return(.f.)
	ENDIF
	

	SELECT &_NOME_TABELLA
	
ENDSCAN


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

