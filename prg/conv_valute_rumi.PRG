*************************************************************************************************
*							    CONVERSIONE CODICI VALUTA     		  							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2013 : Rumi	 				 													*
*************************************************************************************************



** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "RUM"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'RUM' non configurato" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	USE
	RETURN .F.
ENDIF

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

RIT = MESSAGEBOX("Conversione parametro valute da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA VALUTE SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA VALUTE" NOWAIT
cSql = "delete from PARA where CODICE LIKE 'VVA%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


														


CREATE CURSOR IMPORTAXLS ( ;
	vacodval  C(15), ;
	vadesval  C(100), ;
	vasimval  C(100), ;
	vacaoval  C(100), ;
	valinval  C(100), ;
	vadecuni  C(100), ;
	vadectot  C(100), ;
	vabolsup  C(100), ;
	vabolcam  C(100), ;
	vabolarr  C(100), ;
	vabolmim  C(100), ;
	vadateur  C(100), ;		
	vadtobso  C(100), ;			
	vacoduic  C(100))


APPEND FROM (gcFile) TYPE XLS






***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS 
GO TOP 


DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(VACODVAL)) = "VACODVAL"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
  
    
	M.CODICE1 	=ALLTRIM(M.vacodval)	
	M.CODICE2   =CONV_CLEAR(APITOSPA(ALLTRIM(M.CODICE1))) 
	M.CODICE    ="VVA"+M.CODICE2
    M.DESCRI 	=ALLTRIM(APITOSPA(ALLTRIM(M.vadesval)))	
	M.DESCRI    =CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 
   	M.LIBERA	=""


	cSql = "select * from PARA where CODICE ='VVA"+ALLTRIM(M.CODICE2)+"'"
	IF !ExecCommand(cSql,"___temp_valuta")
	   RETURN .F.
	ENDIF
	SELECT ___temp_valuta
	GO TOP
	IF EOF()
	ELSE
       SELECT IMPORTAXLS  && scarto il record 
       SKIP +1
       LOOP
    ENDIF       



	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTAXLS  
	SKIP

ENDDO

    
M.CODICE    ="VVA"+'ITL'
M.DESCRI 	="LIRE ITALIANE"	
M.LIBERA	=""
SELECT curs_PARA					 
APPEND BLANK
GATHER MEMVAR MEMO



	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 