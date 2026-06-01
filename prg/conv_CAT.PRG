*************************************************************************************************
*							CONVERSIONE CATEGORIE MERCEOLOGICHE									*
*							 																	*
*	by Michela per Project S.r.l.															*
*	21 Giugno 2004				 																*
*************************************************************************************************

*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"delle categorie merceologiche?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'MER'
IF FOUND()
ELSE
   RETURN
ENDIF
SELECT PERCORSO
V_PATH = ALLTRIM(PER_PATH)
*V_PATH = ""


****** DEFINIZIONE DEL CURSORE STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF

WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CATEGORIE" NOWAIT


*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL

cSql = "delete from PARA where CODICE LIKE 'MER%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

RELEASE Y_CAMPO,V_CAMPO,_CTR,_PROGRE,A
PUBLIC Y_CAMPO,V_CAMPO,_CTR,_PROGRE,A
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0
_PROGRE = ""
A=1

CREATE CURSOR TRANSITO (TRA_RECORD C(200))

SELECT TRANSITO
APPEND FROM &V_PATH SDF


**** CARICAMENTO DEL FILE IN FORMATO TESTO

*!*	SELECT TRANSITO  
*!*	gcTable = GETFILE('', 'Seleziona file categorie da convertire', 'Converti',0)
*!*	IF empty(gcTable) .or. gcTable = ""
*!*	   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
*!*	   RETURN
*!*	ENDIF
*!*	APPEND FROM &gcTable SDF
*!*	GO TOP

***** TOGLIE I RECORD SUPERFLUI

SELECT TRANSITO
GO TOP

DELETE FOR SUBSTR(TRA_RECORD,2,5) = "-----"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,5,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,2) = "=="  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,2) = "=="  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,3,4) = "Zona"  ALL
GO TOP
DELETE FOR !EMPTY(SUBSTR(TRA_RECORD,5,1))  ALL
GO TOP
DELETE FOR empty(TRA_RECORD)   ALL
GO TOP


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT TRANSITO
GO TOP

_CONTA = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   ******** ASSEGNAZIONE VARIABILI DEL FILE DI TESTO CHE E' CONTENUTO NEL CURSORE TRANSITO

   SELECT TRANSITO
				
   M.CODICE = 'MER'+TRC(3,ALLTRIM(SUBSTR(TRA_RECORD,3,2)))
   M.DESCRI = ALLTRIM (SUBSTR(TRA_RECORD,9,39))
   M.DESCRI = UPPER(M.DESCRI)
   M.DESCRI = APITOSPA(M.DESCRI)
   M.LIBERA = ALLTRIM(SUBSTR(TRA_RECORD,54,7))+"   "+ALLTRIM(SUBSTR(TRA_RECORD,72,4))
 				
   SELECT curs_PARA				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
												   
   _CONTA = _CONTA + 1
   _CTR   = _CTR + 1
   A      = A + 10
   
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

   SELECT TRANSITO      
   SKIP +1
		  
ENDDO

SELECT curs_PARA
GO TOP


****** AGGIORNA TABELLA PARA SQL

IF !ExecRW('','PARA','I','','curs_para')
   return(.f.)
ENDIF
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN

