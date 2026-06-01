*!*	##############################################################################################################
  
					**********************************************************************************************
					***     PROJECT SRL - ELABORA DB SOCIETA' PER ESEGUIRE LO SCRIPT BATCH DI AGGIORNAMENTO    ***
					***     AL DATABASE SQL 																   ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################
  

CLEAR ALL
CLOSE ALL
SET MULTILOCKS ON 
SET CENTURY ON 
SET DATE TO GERMAN 
CLOSE DATABASES ALL


WAIT WINDOWS "Aggiornamento script sql batch in corso" TIMEOUT 1

RELEASE _path_da_eseguire,_path_log,_path_binn_sql,_path_aquarius,_path_sc_sql		&& VARIABILI USATE PER LA GESTIONE DEGLI SCRIPT
PUBLIC _path_da_eseguire,_path_log,_path_binn_sql,_path_aquarius,_path_sc_sql		&& VARIABILI USATE PER LA GESTIONE DEGLI SCRIPT




_path_aquarius=legge_config("build_config.cfg","PATH_AQUARIUS")						&& RICERCA VARIABILE
_path_sc_sql=legge_config("build_config.cfg","PATH_SC_SQL")							&& RICERCA VARIABILE
_path_da_eseguire=legge_config("build_config.cfg","PATH_DA_ESEGUIRE")				&& RICERCA VARIABILE
_path_log=legge_config("build_config.cfg","PATH_LOG")								&& RICERCA VARIABILE
_path_binn_sql=legge_config("build_config.cfg","PATH_BINN_SQL")						&& RICERCA VARIABILE


SET DEFA TO &_path_aquarius															&& DIRECTORY AMBIENTE AQUARIUS

IF !FILE("DBSOCIETA.DBF")															&& SE NON ESISTE LA DBSOCIETA NELLA DIRECTORY AMBIENTE NON DEVE FARE NESSUNA ELABORAZIONE
   RETURN
ENDIF


DO ricerca_database_ambiente														&& CARICA I DATABESE PREVISTI NELLA DBSOCIETA DI QUELLO SPECIFICO AMBIENTE
DO elabora_dbsocieta																&& ELABORA DBSOCIETA


CLOSE DATABASES ALL


QUIT



***********************************************************************
PROCEDURE ricerca_database_ambiente	
***********************************************************************

**  carico DBSOCIETA' NEL CURSORE 

SET DEFA TO &_path_aquarius															&& DIRECTORY AMBIENTE AQUARIUS


* -->> Creazione cursore vuoto 
* --------------------------------------------------------------
CREATE CURSOR ELA_DBSOCIETA_ ;
       (NOME_DATA_BASE C(40), CODICE C(10), Selezione C(05))
INDEX ON CODICE 	TAG I_CODICE 
SET ORDER TO I_CODICE 



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
  	

    SELECT DBSOCIETA
    SCATTER MEMVAR MEMO
    
    
    
	*!*	CERCA PAROLA : "DATABASE="
	__STRINGA__ 				= M.NOMEDB
	__STRINGA_DA_CERCARE__		= "DATABASE="
	__LUNGHEZZA_DA_CERCARE__	= 9
	__PARTENZA_STRINGA__=CERCA_CHR(__STRINGA__,__STRINGA_DA_CERCARE__,__LUNGHEZZA_DA_CERCARE__)

    SELECT DBSOCIETA
	*!*	CERCA PAROLA : "; "
	__STRINGA__ 				= M.NOMEDB
	__STRINGA_DA_CERCARE__		= "; "
	__LUNGHEZZA_DA_CERCARE2__	= 2
	__POSIZIONE_FINALE__		=CERCA_CHR(__STRINGA__,__STRINGA_DA_CERCARE__,__LUNGHEZZA_DA_CERCARE__)


	__LUNGHEZZA_PAROLA__ 	= __POSIZIONE_FINALE__ - __PARTENZA_STRINGA__ - __LUNGHEZZA_DA_CERCARE__
	__NOME_DBASE__			= SUBSTR(ALLTRIM(__STRINGA__),(__PARTENZA_STRINGA__+__LUNGHEZZA_DA_CERCARE__),(__LUNGHEZZA_PAROLA__))

    SELECT ELA_DBSOCIETA_ 
    APPEND BLANK
    REPLACE NOME_DATA_BASE 	WITH	__NOME_DBASE__
    REPLACE CODICE 			WITH	M.CODICE		
    REPLACE Selezione		WITH	'==>'
    

    SELECT DBSOCIETA 
  	SKIP
  	
  	
  ENDDO
  
ENDIF FILE("DBSOCIETA.DBF")



SELECT ELA_DBSOCIETA_ 
GO TOP


RETURN



***********************************************************************
PROCEDURE elabora_dbsocieta	
***********************************************************************

   

RELEASE __NOME_DATA_BASE__ 
PUBLIC __NOME_DATA_BASE__ 
__NOME_DATA_BASE__  = ''

SELECT ELA_DBSOCIETA_ 
GO TOP



*!*	MD c:\aquarius\SC_SQL\LOG
SET DEFA TO &_path_aquarius
_run_md = "MD "+_path_log
RUN &_run_md 




SET DEFA TO &_path_aquarius															&& DIRECTORY AMBIENTE AQUARIUS


DO WHILE !EOF()

  	IF DELETED()
  	    SELECT ELA_DBSOCIETA_ 
        SKIP
        LOOP
  	ENDIF
  	
  	
    IF ALLTRIM(Selezione) <>	'==>'
  	    SELECT ELA_DBSOCIETA_ 
        SKIP
        LOOP
  	ENDIF    

    SELECT ELA_DBSOCIETA_ 
    __NOME_DATA_BASE__ = ALLTRIM(NOME_DATA_BASE)
	
    =ESEGUE_SCRIPT_BATCH(__NOME_DATA_BASE__)

    SET DEFA TO &_path_aquarius															&& DIRECTORY AMBIENTE AQUARIUS


    SELECT ELA_DBSOCIETA_ 
  	SKIP +1
  	
  	
ENDDO




*COPY c:\aquarius\SC_SQL\DA_ESEGUIRE\*.* c:\aquarius\SC_SQL\. /Y
SET DEFA TO &_path_aquarius															&& DIRECTORY AMBIENTE AQUARIUS
_run_copy = "COPY " + _path_da_eseguire + "\*.* " + _path_sc_sql + "\. /Y"
RUN &_run_copy

*DEL c:\aquarius\SC_SQL\DA_ESEGUIRE\*.* /Q
_run_del = "DEL " + _path_da_eseguire + "\*.* /Q"  
RUN &_run_del

CREA_FILE_LOG()

*COPY c:\aquarius\SC_SQL\LOG\*.log c:\aquarius\SC_SQL\LOG\log-%Date:~6,4%-%Date:~3,2%-%Date:~0,2%_%Time:~1,1%.%Time:~3,2%.txt
*!*	SET DEFA TO &_path_aquarius															&& DIRECTORY AMBIENTE AQUARIUS
*!*	_run_copy = "COPY " + _path_log + "\*.log " + _path_log + "\log-%Date:~6,4%-%Date:~3,2%-%Date:~0,2%_%Time:~1,1%.%Time:~3,2%.txt"
*!*	RUN &_run_copy


*DEL c:\aquarius\SC_SQL\LOG\*.log 
_run_del = "DEL " + _path_log + "\*.log"  
RUN &_run_del





SET DEFA TO &_path_aquarius															&& DIRECTORY AMBIENTE AQUARIUS


RETURN


***********************************************************************
PROCEDURE esegue_script_batch
***********************************************************************
PARAMETERS NOME_DATABASE_

IF EMPTY(ALLTRIM(NOME_DATABASE_))
  WAIT WINDOWS "NESSUN DATABASE TROVATO" 
  RETURN
ENDIF

**WAIT WINDOWS "DATABASE IN ELABORAZIONE "+ NOME_DATABASE_ NOWAIT


_db=NOME_DATABASE_

* -->> Creazione cursore vuoto 
* --------------------------------------------------------------
CREATE CURSOR CURS_SCRIPT_SQL_SINGOLI ;
       (NOME_SCRIPT_SQL C(200),DATA_AGGIORNAMENTO C(10),ORA_AGGIORNAMENTO C(8))
INDEX ON DATA_AGGIORNAMENTO+ORA_AGGIORNAMENTO 	TAG I_DATA_ORA 
SET ORDER TO I_DATA_ORA

NUMFILE = ADIR(MATFILE,_path_da_eseguire+'\*.sql')

IF NUMFILE = 0
   WAIT WINDOW "Nessun SCRIPT SQL presente nella directory "+_path_da_eseguire nowait
   RETURN
ENDIF

FOR FF = 1 TO NUMFILE							&& ELABORAZIONE MULTIPLIPA DEI FILE SCRIPT SQL CONTENUTI NELLA DIRECTORY

  	NOME_FILE = MATFILE[FF,1]
  	DATA_FILE = MATFILE[FF,3]
  	ORA_FILE  = MATFILE[FF,4]

	SELECT CURS_SCRIPT_SQL_SINGOLI 
	APPEND BLANK
	REPLACE NOME_SCRIPT_SQL  	WITH ALLTRIM(NOME_FILE)
    REPLACE DATA_AGGIORNAMENTO	WITH RIBALTA2(DTOC(DATA_FILE))
    REPLACE ORA_AGGIORNAMENTO	WITH ORA_FILE  

ENDFOR

SET DEFAULT TO &_path_binn_sql

SELECT CURS_SCRIPT_SQL_SINGOLI 
GO TOP

***_run_for ="FOR /F %%f IN ('dir /d /b /OD "+_path_da_eseguire+"\*.sql') DO ( sqlcmd -Slocalhost -d"+_db+" -i"+_path_da_eseguire+"\%%f -o"+_path_log+"\"+_db+"-%%f.log)"

DO WHILE !EOF()

	_run_for = "sqlcmd -Slocalhost -d"+_db+" -i"+_path_da_eseguire+"\"+ALLTRIM(NOME_SCRIPT_SQL)+" -o"+_path_log+"\"+_db+"#"+ALLTRIM(NOME_SCRIPT_SQL)+".log"

	RUN &_run_for 

	SKIP

ENDDO

SET DEFA TO &_path_aquarius												&& DIRECTORY AMBIENTE AQUARIUS


RETURN




*************************
PROCEDURE CREA_FILE_LOG
*************************

LOCAL _NUMFILE,_FF,_LOG_FILENAME


* -->> Creazione cursore vuoto 
* --------------------------------------------------------------
CREATE CURSOR CURS_LOG_SQL ;
       (NOME_FILE_LOG C(200),NOME_DB C(100),NOME_SCRIPT C(200),DATA_AGGIORNAMENTO C(10),ORA_AGGIORNAMENTO C(8))
INDEX ON ALLTRIM(NOME_DB)+DATA_AGGIORNAMENTO+ORA_AGGIORNAMENTO 	TAG I_DATA_ORA 
SET ORDER TO I_DATA_ORA

_NUMFILE= ADIR(MATFILE_LOG,_path_log +'\*.LOG')

IF _NUMFILE= 0
   WAIT WINDOW "Nessun log presente nella directory "+_path_log nowait
   _ERRORE = .F.
   _LOG_FILENAME = ''
   DO PRG\INVIA_MAIL_NOTIFICA WITH _ERRORE,_LOG_FILENAME
   RETURN
ENDIF

FOR _FF= 1 TO _NUMFILE							&& ELABORAZIONE MULTIPLIPA DEI FILE SCRIPT SQL CONTENUTI NELLA DIRECTORY

  	NOME_FILE = MATFILE_LOG[_FF,1]
  	DATA_FILE = MATFILE_LOG[_FF,3]
  	ORA_FILE  = MATFILE_LOG[_FF,4]

	SELECT CURS_LOG_SQL 
	APPEND BLANK
	
	*!*	CERCA CARATTERE : "#"
	__STRINGA__ 				= ALLTRIM(NOME_FILE)
	__STRINGA_DA_CERCARE__		= "#"
	__LUNGHEZZA_DA_CERCARE__	= 1
	__PARTENZA_STRINGA__=CERCA_CHR(__STRINGA__,__STRINGA_DA_CERCARE__,__LUNGHEZZA_DA_CERCARE__)
	
	REPLACE NOME_DB 			WITH SUBSTR(ALLTRIM(NOME_FILE),1,__PARTENZA_STRINGA__-1)
	REPLACE NOME_SCRIPT 		WITH SUBSTR(ALLTRIM(NOME_FILE),__PARTENZA_STRINGA__+1)
	REPLACE NOME_FILE_LOG 		WITH ALLTRIM(NOME_FILE)
    REPLACE DATA_AGGIORNAMENTO	WITH RIBALTA2(DTOC(DATA_FILE))
    REPLACE ORA_AGGIORNAMENTO	WITH ORA_FILE  

ENDFOR

SELECT CURS_LOG_SQL 
GO TOP

_LOG_FILENAME=_path_log +"\LOGSQL_"+CREA_NOME_FILE_CON_DATA_ORA()+".TXT"

_ERRORE=.f.

DO WHILE !EOF()

	_CONTENUTO_FILE=FILETOSTR(ALLTRIM(_path_log +"\"+NOME_FILE_LOG ))

	IF "Messaggio" $ _CONTENUTO_FILE 
		_ERRORE=.t.
	ENDIF
	
	IF "Msg" $ _CONTENUTO_FILE 
		_ERRORE=.t.
	ENDIF
	
	STRTOFILE(chr(13) + chr(10)+"-----------------------------------------", _LOG_FILENAME,.t.) 
	STRTOFILE(chr(13) + chr(10)+"DATABASE: "+ALLTRIM(NOME_DB), _LOG_FILENAME,.t.) 
	STRTOFILE(chr(13) + chr(10)+"-----------------------------------------", _LOG_FILENAME,.t.) 
	STRTOFILE(chr(13) + chr(10)+"SCRIPT ESEGUITO: "+ALLTRIM(NOME_SCRIPT), _LOG_FILENAME,.t.) 
	STRTOFILE(chr(13) + chr(10)+"-----------------------------------------"+chr(13) + chr(10), _LOG_FILENAME,.t.) 
	STRTOFILE(_CONTENUTO_FILE, _LOG_FILENAME,.t.) 

	SKIP

ENDDO
	
	

DO PRG\INVIA_MAIL_NOTIFICA WITH _ERRORE,_LOG_FILENAME
	
RETURN





******************************************************
FUNCTION CREA_NOME_FILE_CON_DATA_ORA
******************************************************

LPARAMETERS pFormato
  
LOCAL DATA,;
		ORA,;
  		TIMESTAMP,;
  		AAAA,;
  		MM,;
  		GG,;
  		HH,;
  		PP,;
  		SS,;
		MMM,;
		NNUMEROPARAMETRI

NNUMEROPARAMETRI=PARAMETERS()

DATA=DTOC(DATE())
ORA=TIMEMILLISEC()

AAAA=SUBSTR(DATA,7,4)
MM=SUBSTR(DATA,4,2)
GG=SUBSTR(DATA,1,2)
  
HH=SUBSTR(ORA,1,2)
PP=SUBSTR(ORA,4,2)
SS=SUBSTR(ORA,7,2)
MMM=SUBSTR(ORA,10,3)

TIMESTAMP=""

IF NNUMEROPARAMETRI>=1
	TIMESTAMP=TIMESTAMP+&PFORMATO
ELSE
	TIMESTAMP=TIMESTAMP;
			+AAAA;
  			+MM;
  			+GG;		&& DATA IN FORMATO AAAAMMGG
  			+HH;
  			+PP;
  			+SS;
  			+MMM		&& ORA IN FORMATO HHMMSSMMM
ENDIF
  
RETURN TIMESTAMP


***************************
FUNCTION TIMEMILLISEC
***************************
LOCAL DATA,;
		ORA,;
  		TIMESTAMP,;
  		SECONDIDAMEZZANOTTE,;
  		MILLISECONDI,;
  		STR_MILLISECONDI

SECONDIDAMEZZANOTTE=SECONDS()
ORA=SUBSTR(TIME(SECONDIDAMEZZANOTTE),1,8)
  
MILLISECONDI=(SECONDIDAMEZZANOTTE-INT(SECONDIDAMEZZANOTTE))*1000
STR_MILLISECONDI="000"+ALLTRIM(STR(MILLISECONDI,3,0))
STR_MILLISECONDI=SUBSTR(STR_MILLISECONDI,LEN(STR_MILLISECONDI)-2)
  
RETURN ORA+":"+STR_MILLISECONDI




*************************
FUNCTION CERCA_CHR
*************************
* RESTITUISCE LA POSIZIONE DEL PUNTATORE DELLA STRINGA DA CERCARE

PARA _STRINGA,_STRINGA_DA_CERCARE,_LUNGHEZZA_DA_CERCARE

_LA_STRINGA_PARTE_DA_QUI = 0
IST = 0

DO WHILE .T.

   IST=IST + 1
   CARATT = SUBSTR(_STRINGA,IST,1)
   IF CARATT = SUBSTR(_STRINGA_DA_CERCARE,1,1)
   
      IF SUBSTR(_STRINGA,IST,_LUNGHEZZA_DA_CERCARE) = SUBSTR(_STRINGA_DA_CERCARE,1,_LUNGHEZZA_DA_CERCARE)
	      
	      _LA_STRINGA_PARTE_DA_QUI = LEN(SUBSTR(_STRINGA,1,IST))
          EXIT
      
      ENDIF
   
   ENDIF

   IF IST = 300
     EXIT
   ENDIF

ENDDO

RETURN(_LA_STRINGA_PARTE_DA_QUI)



*****************************
procedure legge_config
*****************************
parameters _configfile,_proprieta

LOCAL _valore

_valore=""

IF FILE(_configfile)	  && Esiste il file? 

	gnConfigFile = FOPEN(_configfile)	  	&& Se esiste, lo apre in lettura
	IF gnConfigFile >= 0  					&& Verifica errore in apertura del file
											&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=FGETS(gnConfigFile)
			
			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=allt(substr(riga,at("=",riga)+1))

				if	chiave=_proprieta
					_valore=valore
				endif
			endif
		enddo
	ENDIF
	=FCLOSE(gnConfigFile)	

ENDIF

return _valore

ENDPROC




***********************************************************************
* Funzione - RIBALTA2     Data: 15.11.95   Autore: Project
***********************************************************************
*
*  Consente di convertire il formato data
*  AAAA.MM.GG in GG.MM.AAAA e viceversa
*  Sintassi: RIBALTA(Stringa da convertire)
*  Parametro: Carattere
*  Ritorna:   Carattere
*  Se il contenuto di GG,MM,AA è nullo ritorna SPACE(10)
*
***********************************************************************
FUNCTION RIBALTA2
*****************

PARAMETER _VALCAMPO

_SEPARA="/.-"

DO CASE
   CASE SUBSTR(_VALCAMPO,3,1) $ _SEPARA   && GG.MM.AAAA
        _SEPARA=SUBSTR(_VALCAMPO,3,1)
        _GIORNO=SUBSTR(_VALCAMPO,1,2)
        _MESE  =SUBSTR(_VALCAMPO,4,2)
        _ANNO  =SUBSTR(_VALCAMPO,7,4)
        _TUTTO =_ANNO+_SEPARA+_MESE+_SEPARA+_GIORNO
   CASE SUBSTR(_VALCAMPO,5,1) $ _SEPARA   && AAAA.MM.GG
        _SEPARA=SUBSTR(_VALCAMPO,5,1)
        _GIORNO=SUBSTR(_VALCAMPO,9,2)
        _MESE  =SUBSTR(_VALCAMPO,6,2)
        _ANNO  =SUBSTR(_VALCAMPO,1,4)
        _TUTTO =_GIORNO+_SEPARA+_MESE+_SEPARA+_ANNO
   OTHERWISE                              && NON VALIDO !
        _TUTTO=SPACE(10)
ENDCASE

RETURN(_TUTTO)



