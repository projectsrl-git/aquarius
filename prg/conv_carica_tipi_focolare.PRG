*************************************************************************************************
*				      	   	   CARICAMENTO DBF TIPI FOCOLARE							        *
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Novembre 2023 : Aster/Trevicalor	 														*
*************************************************************************************************


__connectString = PUB_NOMEDB
__connectString_DATABASE = SUBSTR(__connectString,AT("DATABASE=",__connectString),AT(';',SUBSTR(__connectString,AT("DATABASE=",__connectString)))-1)
_V_DBAL = STRTRAN(__connectString_DATABASE,"DATABASE=","")
__config_name = "conversioni_" + _V_DBAL + ".cfg"
PERCORSO_TREVICALOR=legge_config(__config_name,"PERCORSO_ASTERDAT")						&& RICERCA VARIABILE
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR




RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA (TIPI_FOCOL) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	

*** CANCELLAZIONE DEI RECORD DELLA TABELLA TIPI_FOCOL
WAIT WINDOWS "Cancellazione TIPI FOCOLARE TREVICALOR ...  -  Prego Attendere" NOWAIT

cSql = "delete from PARA where CODICE LIKE 'FOC%'"   
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


_V_PERCORSO= PERCORSO_TREVICALOR

SET EXCLUSIVE ON

V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("TIPI_FOCOL")
SELECT TIPI_FOCOL

SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio TIPI_FOCOL attendere prego ....." NOWAIT



_CONTA_REC = 0
SELECT TIPI_FOCOL
GO TOP 


DO WHILE !EOF()


    IF DELETED()
       SELECT TIPI_FOCOL  
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
 
 	_ID_TIPOFOC = ALLTRIM(CONV_CLEAR(M.ID_TIPOFOC))
 	_DEX        = ALLTRIM(CONV_CLEAR(M.DEX))

	IF ISNULL(M.ID_TIPOFOC) 
		M.CODICE   = ""
	ELSE
		M.CODICE   = ALLTRIM(CONV_CLEAR(M.ID_TIPOFOC))
    ENDIF 	


		
	M.CODICE    ="FOC"+M.CODICE
	M.DESCRI    =ALLTRIM(CONV_CLEAR(M.DEX))


 	SELECT curs_PARA							&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 							&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 


    REPLACE LIBERA    WITH ""
 
   	
    _CONTA_REC  = _CONTA_REC  + 1
    	
    SELECT TIPI_FOCOL   && &_NOME_TABELLA
	SKIP

ENDDO


   

SELECT curs_PARA
GO TOP


****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 	 

WAIT WINDOWS "MOVIMENTI INSERITI: "+ STR(_CONTA_REC,5,0)



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

