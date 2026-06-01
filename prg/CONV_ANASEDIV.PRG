*************************************************************************************************
*							DESTINAZIONI DIVERSE CLIENTI										*
*							 																	*
*	by MICHELA																	*
*	17/06/2004				 																	*
*************************************************************************************************

*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"delle destinazioni diverse clienti?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'DES'
IF FOUND()
ELSE
   RETURN
ENDIF
SELECT PERCORSO
V_PATH = ALLTRIM(PER_PATH)

*V_PATH = ""


****** DEFINIZIONE DEL CURSORE STP

IF !ExecCommand("select * from U_LOC_AN where 1=0","curs_loc_an")
   return
ENDIF

WAIT WINDOWS "Attendere prego, cancellazione vecchia anagrafica articoli" NOWAIT


*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL

cSql = "delete from U_LOC_AN where 1=1"
IF !ExecCommand(cSql,"u_loc_an")
   return(.f.)
ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

RELEASE Y_CAMPO,V_CAMPO,_CTR,_PROGRE,A
PUBLIC Y_CAMPO,V_CAMPO,_CTR,_PROGRE,A
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0
_PROGRE = ""
A       = 1
CREATE CURSOR TRANSITO (TRA_RECORD C(200),cod c(3))

SELECT TRANSITO
APPEND FROM &V_PATH SDF


**** CARICAMENTO DEL FILE IN FORMATO TESTO

*!*	SELECT TRANSITO  
*!*	gcTable = GETFILE('', 'Seleziona file articoli da convertire', 'Converti',0)
*!*	IF empty(gcTable) .or. gcTable = ""
*!*	   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
*!*	   RETURN
*!*	ENDIF
*!*	APPEND FROM &gcTable SDF
*!*	GO TOP


***** TOGLIE I RECORD SUPERFLUI

SELECT TRANSITO
		
DELETE FOR SUBSTR(TRA_RECORD,2,5) = "-----"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,5,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,2) = "=="  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,2) = "=="  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,4) = "Cod."  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,29,9) = "Indirizzo"  ALL
GO TOP
DELETE FOR empty(TRA_RECORD)   ALL
GO TOP

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
  	  EXIT
   ENDIF
	
   IF !EMPTY(ALLTRIM(SUBSTR(TRA_RECORD,4,3)))
  	  M.COD=ALLTRIM(SUBSTR(TRA_RECORD,4,3))
   ENDIF
					
   GATHER MEMVAR MEMO

   SELECT TRANSITO
   SKIP +1

ENDDO		

***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT TRANSITO
GO TOP
				
_CONTA = 0
P      = 0
	 
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   M.LOC_CODSOC = '01'	
   M.LOC_CF     = 'C'			
   IF !EMPTY(ALLTRIM(SUBSTR(TRA_RECORD,4,3)))   && SE CODCLI NON è VUOTO+
      M.LOC_CODCLI = TRC(PUB_LCL,ALLTRIM(SUBSTR(TRA_RECORD,4,3))) 
	  SKIP +2
   ENDIF
	         		
   IF !EMPTY(ALLTRIM(SUBSTR(TRA_RECORD,20,2)))
	  M.LOC_CODLOC = ALLTRIM(SUBSTR(TRA_RECORD,20,2))
	  IF LEN(ALLTRIM(M.LOC_CODLOC)) = 1
	     M.LOC_CODLOC = '0' + M.LOC_CODLOC
	  ENDIF
  	  M.LOC_RAGSOC = ALLTRIM(SUBSTR(TRA_RECORD,29,40))	
	  M.LOC_RAGSOC = UPPER(M.LOC_RAGSOC)
	  M.LOC_RAGSOC = APITOSPA(M.LOC_RAGSOC)
   ENDIF
	
   SKIP +1

   IF EMPTY(ALLTRIM(SUBSTR(TRA_RECORD,20,2)))
	  M.LOC_CAP = ALLTRIM(SUBSTR(TRA_RECORD,74,5))					
	  IF M.LOC_CAP = '00000'
		 M.LOC_CAP = SPACE(5)
	  ENDIF
  	  M.LOC_INDIRI = ALLTRIM(SUBSTR(TRA_RECORD,29,30))	
	  M.LOC_INDIRI = UPPER(M.LOC_INDIRI)
   	  M.LOC_INDIRI = APITOSPA(M.LOC_INDIRI)
	  M.LOC_PROVIN = ALLTRIM(SUBSTR(TRA_RECORD,114,2))
      M.LOC_PROVIN = UPPER(M.LOC_PROVIN)
	  M.LOC_PROVIN = APITOSPA(M.LOC_PROVIN)
  	  M.LOC_LOCALI = ALLTRIM(SUBSTR(TRA_RECORD,80,30))
	  M.LOC_LOCALI = UPPER(M.LOC_LOCALI)
	  M.LOC_LOCALI = APITOSPA(M.LOC_LOCALI)
   ENDIF	
				
   SELECT curs_loc_an				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 
          		
   && EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
												   
   _CONTA = _CONTA + 1
   _CTR   = _CTR + 1
   A      = A + 10

   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

   SELECT TRANSITO      
		  
ENDDO

SELECT curs_loc_an
GO TOP
IF !ExecCommand("select * from U_LOC_AN where 1=0","c_loc_an")
   return
ENDIF

SELECT C_LOC_AN
GO TOP 		

SELECT curs_loc_an
GO TOP 		

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF RECNO()%2<>0
	  SKIP +1
	  LOOP
   ENDIF
   
   SELECT CURS_LOC_AN
   SCATTER MEMVAR MEMO
   
   SELECT c_loc_an				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 
   
   SELECT CURS_LOC_AN
   SKIP +1

ENDDO

SELECT c_loc_an
GO TOP

****** AGGIORNA TABELLA PARA SQL

IF !ExecRW('','U_LOC_AN','I','','c_loc_an')
   return(.f.)
ENDIF
	 
=MESSAGEBOX("Operazione terminata correttamente ",62,"ATTENZIONE")

RETURN
