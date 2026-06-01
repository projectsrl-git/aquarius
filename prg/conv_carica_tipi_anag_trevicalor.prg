*************************************************************************************************
*					         	    CARICAMENTO DBF TIPI_ANAG TREVICALOR		  			    *
*************************************************************************************************

PERCORSO_TREVICALOR= "D:\Trevicalor\asterdat"
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA (TIPI_ANAG) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	
	
*!*	**** CARICAMENTO DEL FILE DBF
*!*	TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

*!*	IF EMPTY(TABELLA_INPUT)
*!*		MESSAGEBOX("Nessun file selezionato",64,"Informazione")
*!*		SET DEFAULT TO &PUB_DIR  
*!*		RETURN
*!*	ENDIF
*!*	WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 
*!*	_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
*!*	IF !USED(TABELLA_INPUT)
*!*	   USE &TABELLA_INPUT IN 0 AGAIN
*!*	ENDIF
*!*	SET DEFAULT TO &PUB_DIR

*** CANCELLAZIONE DEI RECORD DELLA TABELLA TIPI_ANAG
WAIT WINDOWS "Cancellazione TIPI_ANAG TREVICALOR ...  -  Prego Attendere" NOWAIT

cSql = "delete from PARA where CODICE LIKE 'TAN%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF

_V_PERCORSO= "D:\Trevicalor\asterdat"
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("TIPI_ANAG")
SELECT TIPI_ANAG

SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio TIPI_ANAG attendere prego ....." NOWAIT

_CONTA_REC = 0
SELECT TIPI_ANAG
GO TOP
DO WHILE !EOF()

    IF DELETED()
       SELECT TIPI_ANAG  && &_NOME_TABELLA  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF
    
    SCATTER MEMVAR MEMO 
	IF ISNULL(M.ID_TIPOANG) 
       SELECT TIPI_ANAG  && &_NOME_TABELLA  && scarto i record cancellati
       SKIP +1
       LOOP
	ELSE
		M.CODICE = ALLTRIM(CONV_CLEAR(M.ID_TIPOANG))
    ENDIF
    	
	M.CODICE = "TAN"+M.CODICE
	M.DESCRI = ALLTRIM(CONV_CLEAR(M.DEX))
	M.LIBERA = ALLTRIM(CONV_CLEAR(M.FLAG_RESP))

 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
   	
    _CONTA_REC  = _CONTA_REC  + 1
    	
    SELECT TIPI_ANAG   && &_NOME_TABELLA
	SKIP

ENDDO
   

SELECT curs_PARA
GO TOP

****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF

WAIT WINDOWS "NR. RECORDS INSERITI: "+ STR(_CONTA_REC,5,0)

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

