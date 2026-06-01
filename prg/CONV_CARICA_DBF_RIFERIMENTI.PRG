*************************************************************************************************
*					         	    CARICAMENTO DBF RIFERIMENTI IMPIANTI   			            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Marzo 2022 : Assolo		 			 														*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA RIFERIMENTI (SCHEDETEST) IMPIANTI? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	
WAIT WINDOWS "SELEZIONA LA TABELLA : SCHEDETEST" 
**** CARICAMENTO DEL FILE DBF
TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(TABELLA_INPUT)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF
WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 



*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA AQ_SCHEDE SQL
*!*	WAIT WINDOWS "Cancellazione IMPIANTI_NO ...  -  Prego Attendere" NOWAIT
*!*	cSql = "delete from IMPIANTI_NO where 1=1"
*!*	IF !ExecCommand(cSql,"IMPIANTI_NO")
*!*	   return(.f.)
*!*	ENDIF

_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
IF !USED(TABELLA_INPUT)
   USE &TABELLA_INPUT IN 0 AGAIN
ENDIF

SET DEFAULT TO &PUB_DIR

*WAIT WINDOWS "Caricamento dati archivio CONTRATTI_SERVIZI attendere prego ....." NOWAIT
WAIT WINDOWS "Caricamento dati archivio CONTRATTI_SERVIZI attendere prego ....." NOWAIT  && ERASMO - 29/11/2023


SELECT &_NOME_TABELLA
GO TOP 

SCAN

	SCATTER MEMVAR MEMO
	
	M.ID_PMKEY = ALLTRIM(M.ID_PMKEY)
	
	*WAIT WINDOWS "Contratto caricato: " + M.ID_PMKEY NOWAIT
	WAIT WINDOWS "Riferimento caricato: " + M.ID_PMKEY NOWAIT  && ERASMO - 29/11/2023

*!*		**==> CREAZIONE TABELLA IMPIANTO
*!*			
*!*		IF !ExecRW("select * from IMPIANTI_NO where 0=1","IMPIANTI_NO","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT IMPIANTI_NO
*!*		APPEND BLANK
*!*		GATHER MEMVAR MEMO
*!*		REPLACE DT_REGIST	WITH RIBALTA2(DT_REGIST)           
*!*		REPLACE CDATAFATT	WITH RIBALTA2(CDATAFATT)              


*!*		
*!*		IF !ExecRW("select * from IMPIANTI_NO where 0=1","IMPIANTI_NO","W")
*!*		   return(.f.)
*!*		ENDIF

	**=> ERASMO - INIZIO 29/01/2024
	cSql = "select * from IMPIANTI_TT where ID_PMKEY = '" + M.ID_PMKEY + "'"
	IF !ExecRW(cSql,"IMPIANTI_TT","R")
	   return(.f.)
	ENDIF
	SELECT IMPIANTI_TT
	GO TOP
	IF !EOF()
		REPLACE COD_RIF_01	WITH M.COD_RIF_01
		REPLACE DEX_RIF_01	WITH M.DEX_RIF_01
		REPLACE COD_RIF_02	WITH M.COD_RIF_02
		REPLACE DEX_RIF_02	WITH M.DEX_RIF_02
		REPLACE COD_RIF_03	WITH M.COD_RIF_03
		REPLACE DEX_RIF_03	WITH M.DEX_RIF_03
		REPLACE COD_RIF_04	WITH M.COD_RIF_04
		REPLACE DEX_RIF_04	WITH M.DEX_RIF_04
		REPLACE COD_RIF_05	WITH M.COD_RIF_05
		REPLACE DEX_RIF_05	WITH M.DEX_RIF_05
		REPLACE COD_RIF_06	WITH M.COD_RIF_06
		REPLACE DEX_RIF_06	WITH M.DEX_RIF_06
		REPLACE COD_RIF_07	WITH M.COD_RIF_07
		REPLACE DEX_RIF_07	WITH M.DEX_RIF_07
		REPLACE COD_RIF_08	WITH M.COD_RIF_08
		REPLACE DEX_RIF_08	WITH M.DEX_RIF_08
		REPLACE COD_RIF_09	WITH M.COD_RIF_09
		REPLACE DEX_RIF_09	WITH M.DEX_RIF_09
		REPLACE MEMO_1		WITH M.MEMO_1
	ENDIF
	IF !ExecRW(cSql,"IMPIANTI_TT","W")
	   return(.f.)
	ENDIF
	**=> ERASMO - FINE 29/01/2024

	SELECT &_NOME_TABELLA
	
ENDSCAN


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

