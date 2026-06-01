*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - GESTIONE DI DBSOCIETA : CONNESSINE AL DB DESIDERATO              ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################

PARAMETERS _EXE_OPERATORE,_EXE_DATABASE

IF PARAMETERS() < 1
   MESSAGEBOX("Parametro Codice Operatore obbligatorio!" + CHR(13) + CHR(13) + "L'applicazione verrà chiusa",16,"Attenzione")
   RETURN
ENDIF

IF PARAMETERS() >= 2
ELSE
   _EXE_DATABASE = ""
ENDIF

SET SYSMENU OFF



*SET PROCEDURE TO SQLLIB 	ADDITIVE

PUB_DISTRI = "Commercializzato da Project Srl - Cava Manara (PV)"

PUBLIC PUB_SEQUEN 
PUB_SEQUEN =  0


ON READERROR DO ZErrore

=OPENDB("VERSIONE")
SELECT versione
GO top
IF EOF()
   XXX_VERSIONE    = "MANCA LA TABELLA DELLE VERSIONI"
   XXX_NOME_SERVER = ""
ELSE
   XXX_VERSIONE    = VER_VERSIO
   XXX_NOME_SERVER = VER_SERVER
ENDIF

IF EMPTY(XXX_NOME_SERVER)
ELSE
   XXX_MANDA = "NET TIME \\" + ALLTRIM(XXX_NOME_SERVER) + " /SET /Y"
   RUN &XXX_MANDA
ENDIF

XXX_DATA = DTOC(DATE())
XXX_TIME = TIME()

*******************************************************************************************************
*** EMULAZIONE FORM PASS ******************************************************************************
*******************************************************************************************************

*** VARIABILI PUBBLICHE DEL FORM
***
RELEASE _LOGIN_SOCIETA
PUBLIC  _LOGIN_SOCIETA

*** VARIABILI PUBBLICHE DEL PROGETTO
*** NON RILASCIARE IN USCITA DAL FORM
***
RELEASE PUB_NOMEDB,PUB_NOMEDB_ALT1,PUB_NOMEDB_ALT2,PUB_NOMEDB_ALT3
PUBLIC  PUB_NOMEDB,PUB_NOMEDB_ALT1,PUB_NOMEDB_ALT2,PUB_NOMEDB_ALT3

_LOGIN_SOCIETA=""

PUB_NOMEDB=""
PUB_NOMEDB_ALT1=""
PUB_NOMEDB_ALT2=""
PUB_NOMEDB_ALT3=""

V_CODOPE=_EXE_OPERATORE
V_PASS=SPACE(20)
V_EXIT=.T.
V_ANNO=ALLTRIM(STR(YEAR(DATE( ))))
V_DATAOGGI=DATE()

RELEASE _LOGO_TIPDBASE
PUBLIC _LOGO_TIPDBASE
_LOGO_TIPDBASE = ""




=OPENDB("VERSIONE")
SELECT versione
GO top
IF EOF()
   XXX_VERSIONE = "MANCA LA TABELLA DELLE VERSIONI"
ELSE
   XXX_VERSIONE = VER_VERSIO
ENDIF

V_DATAOGGI=DATE()





PRIVATE V_CONTARECORD
V_CONTARECORD=0

IF FILE("DBSOCIETA.DBF")
	IF !USED("DBSOCIETA")
		USE DBSOCIETA IN 0 AGAIN SHARED
	ENDIF
	SELECT DBSOCIETA
	GO TOP
	V_CONTARECORD=0

	DO WHILE !EOF()

		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		V_CONTARECORD=V_CONTARECORD+1

		SKIP
	ENDDO
	
	
ELSE 
ENDIF 


IF V_CONTARECORD=0
   MESSAGEBOX("Nessun DataBase configurato nel DBSOCIETA.DBF",16,"Attenzione")
   RETURN 
ENDIF


IF EMPTY(ALLTRIM(_EXE_DATABASE))
	*## Se il parametro è vuoto, prendo il primo record del DBSOCIETA
	SELECT * FROM DBSOCIETA ORDER BY CODICE INTO CURSOR CURDBSOC
	SELECT CURDBSOC
	GO TOP
	_LOGIN_SOCIETA=CURDBSOC.SOCIETA
ELSE
	*## Se il parametro è valorizzato, devo distinguere due casi :
	*## Caso 1 = Il DBSOCIETA è configurato alla nuova maniera (tutta la stringa di connessione nel campo NOMEDB)	
	*## Caso 2 = Il DBSOCIETA è ancora configurato alla vecchia maniera (solo il nome del DB nel campo NOMEDB)
	SELECT * FROM DBSOCIETA ORDER BY CODICE INTO CURSOR CURDBSOC
	SELECT CURDBSOC
	GO TOP
	SCAN
		IF "DATABASE=" $ UPPER(ALLTRIM(NOMEDB))
			*## Caso 1 = Il DBSOCIETA è configurato alla nuova maniera (tutta la stringa di connessione nel campo NOMEDB)			
			_strconn =UPPER(ALLTRIM(NOMEDB))
			_strstart=AT("DATABASE=",_strconn)
			_strtmp  =ALLTRIM(SUBSTR(_strconn,_strstart+9))
			_nomedb  =ALLTRIM(SUBSTR(_strtmp,1,LEN(_strtmp)-1))
			IF UPPER(ALLTRIM(_EXE_DATABASE)) == UPPER(ALLTRIM(_nomedb))
				_LOGIN_SOCIETA=CURDBSOC.SOCIETA
				EXIT
			ENDIF
		ELSE
			*## Caso 2 = Il DBSOCIETA è ancora configurato alla vecchia maniera (solo il nome del DB nel campo NOMEDB)
			IF UPPER(ALLTRIM(_EXE_DATABASE)) == UPPER(ALLTRIM(NOMEDB))
				_LOGIN_SOCIETA=CURDBSOC.SOCIETA
				EXIT
			ENDIF
		ENDIF
	ENDSCAN
ENDIF

*** SIMONE - 15/09/2009 - FINE



PUB_ANNO =  ALLTRIM(V_ANNO)
PUB_ANNOX = VAL(PUB_ANNO) - 1
PUB_ANNOP = STR(PUB_ANNOX,4,0)
PUB_ANNOY = VAL(PUB_ANNO) + 1
PUB_ANNOS = STR(PUB_ANNOY,4,0)


*************************************************


* VARIABILI DI SISTEMA
PUB_PASSWORD=ALLTRIM(V_PASS)
PUB_CODOPE=ALLTRIM(V_CODOPE)
PUB_NOMOPE=""
PUB_CODSOC=SOCIETA
*PUB_UFILE =FILE_UNICO
PUB_CODSYS= SYS(2015)






PRIVATE V_NOMEDB,V_PREFIX,V_SUFFIX

V_NOMEDB=""
V_PREFIX=""
V_SUFFIX=""

PUBLIC PUB_LOGO1,PUB_LOGO2


SELECT DBSOCIETA 
GO TOP
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF

	IF ALLTRIM(SOCIETA)!=ALLTRIM(_LOGIN_SOCIETA)
		SKIP
		LOOP
	ELSE 
	  *** SIMONE - 15/09/2009 - INIZIO
		IF "DATABASE=" $ UPPER(ALLTRIM(NOMEDB))
			*## Caso 1 = Il DBSOCIETA è configurato alla nuova maniera (tutta la stringa di connessione nel campo NOMEDB)			
			_strconn =UPPER(ALLTRIM(NOMEDB))
			_strstart=AT("DATABASE=",_strconn)
			_strtmp  =ALLTRIM(SUBSTR(_strconn,_strstart+9))
			_nomedb  =ALLTRIM(SUBSTR(_strtmp,1,LEN(_strtmp)-1))
			
			V_NOMEDB=ALLTRIM(_nomedb)
			PUB_NOMEDB=ALLTRIM(_nomedb)
			PUB_NOMEDB_ALT1=ALLTRIM(ALTERN_DB1)
			PUB_NOMEDB_ALT2=ALLTRIM(ALTERN_DB2)
			PUB_NOMEDB_ALT3=ALLTRIM(ALTERN_DB3)
			PUB_LOGO1 = ALLTRIM(LOGO1)
			PUB_LOGO2 = ALLTRIM(LOGO2)
		ELSE
			*## Caso 2 = Il DBSOCIETA è ancora configurato alla vecchia maniera (solo il nome del DB nel campo NOMEDB)
			V_NOMEDB=ALLTRIM(NOMEDB)
			PUB_NOMEDB=ALLTRIM(NOMEDB)
			PUB_NOMEDB_ALT1=ALLTRIM(ALTERN_DB1)
			PUB_NOMEDB_ALT2=ALLTRIM(ALTERN_DB2)
			PUB_NOMEDB_ALT3=ALLTRIM(ALTERN_DB3)
			PUB_LOGO1 = ALLTRIM(LOGO1)
			PUB_LOGO2 = ALLTRIM(LOGO2)
		ENDIF
	  *** SIMONE - 15/09/2009 - FINE
	  
		EXIT	
	ENDIF

	SELECT DBSOCIETA 
	SKIP
ENDDO


IF EMPTY(V_NOMEDB)
	=MESSAGEBOX("Errore connessione SQL. Non trovato in TABELLA DBSOCIETA.DBF un db a cui connettersi associato alla societa "+_LOGIN_SOCIETA,16,"*** ATTENZIONE ***")
	RETURN .F.
ENDIF

IF !FILE("STRINGSQL.DBF")
  	=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
	RETURN .F.
ELSE
  SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP
  IF _TALLY = 0
		=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
		RETURN(.f.)
  ELSE
		SELECT _TMP
		
		V_PREFIX=SUBSTR(cString,1,AT("DATABASE=",cString)-1)
		V_SUFFIX=SUBSTR(cString,AT("DATABASE=",cString))
		V_SUFFIX=SUBSTR(V_SUFFIX,AT(";",V_SUFFIX))
		
		
		cString=ALLTRIM(V_PREFIX+"DATABASE="+V_NOMEDB+V_SUFFIX)
		
		UPDATE STRINGSQL SET STRINGA=cString WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED()
		SQLDISCONNECT(pub_sqlhd)
		pub_sqlhd =0
  ENDIF
ENDIF





RELEASE _LOGIN_SOCIETA



