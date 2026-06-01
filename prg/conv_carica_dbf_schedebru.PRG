*************************************************************************************************
*					         	    CARICAMENTO DBF SCHEDE BRUCIATORI  				            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Marzo 2022 : Assolo		 			 									  				    *
*************************************************************************************************

SET DEFAULT TO &PUB_DIR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA SCHEDE BRUCIATORI ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	

**** CARICAMENTO DEL FILE DBF
TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(TABELLA_INPUT)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF

WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 


*** CANCELLAZIONE DEI RECORD DELLA TABELLA AQ_SCHEDEBRU SQL
WAIT WINDOWS "Cancellazione AQ_SCHEDEBRU ...  -  Prego Attendere" NOWAIT
cSql = "delete from AQ_SCHEDEBRU where 1=1"
IF !ExecCommand(cSql,"AQ_SCHEDEBRU")
   return(.f.)
ENDIF
	

_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
*=OPENDB(TABELLA_INPUT)
IF !USED(TABELLA_INPUT)
   USE &TABELLA_INPUT IN 0 AGAIN
ENDIF
SET DEFAULT TO &PUB_DIR
SELECT &_NOME_TABELLA
GO TOP 

SCAN

	SCATTER MEMVAR MEMO
	
	M.ID_PMKEY = ALLTRIM(M.ID_PMKEY)
	
	WAIT WINDOWS "Impianto caricato: " + M.ID_PMKEY NOWAIT
		
	IF !ExecRW("select * from AQ_SCHEDEBRU where 0=1","AQ_SCHEDEBRU","R")
	   return(.f.)
	ENDIF
	SELECT AQ_SCHEDEBRU
	APPEND BLANK
	GATHER MEMVAR MEMO

	REPLACE DT_INSTALL     	WITH RIBALTA2(DT_INSTALL)              
	REPLACE CDAINGARNZ     	WITH RIBALTA2(CDAINGARNZ)             
	REPLACE CDAFIGARNZ     	WITH RIBALTA2(CDAFIGARNZ)       
	

	IF !ExecRW("select * from AQ_SCHEDEBRU where 0=1","AQ_SCHEDEBRU","W")
	   return(.f.)
	ENDIF
	
ENDSCAN


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

