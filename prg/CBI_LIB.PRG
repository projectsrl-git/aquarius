************************************************
PROCEDURE LEGGI_DA_FILE_SUPPORTO_LOGICO_CBI
************************************************
LPARAMETERS NOME_FILE_CBI,TIPO_SUPPORTO

#DEFINE NUM_CHAR_IDENTIFICATIVI 3
#DEFINE NUM_CHAR_RECORD 120

LOCAL	riga,;
		gnFileHandle,;
		_STRINGA,;
		_STRINGA_RECORD,;
		_LUNGHEZZA_FILE,;
		_POSIZIONE_ATTUALE,;
		_TROVATO_RECORD,;
		_TIPORECORD,;
		_IDSUPPORTO,;
		_NUM_CHAR_SUPPORTO,;
		_RETURN

_RETURN=SPACE(0)		
		
IF !FILE(NOME_FILE_CBI) && Esiste il file? 
	LOG2FILE("Non trovato file "+NOME_FILE_CBI)
	_RETURN=SPACE(0)		
	RETURN(_RETURN)
ENDIF

gnFileHandle = FOPEN(NOME_FILE_CBI) && Se esiste, lo apre in lettura
IF gnFileHandle < 0 && Verifica errore in apertura del file
	&& Se non viene trovato alcun errore legge file
	LOG2FILE("Impossibile aprire file "+NOME_FILE_CBI)
	_RETURN=SPACE(0)		
	RETURN(_RETURN)
ENDIF

_LUNGHEZZA_FILE = FSEEK(gnFileHandle,0,2)

FSEEK(gnFileHandle,0,0)

_STRINGA=SPACE(0)
_TROVATO_RECORD=.F.
DO WHILE !FEOF(gnFileHandle)
	IF LEN(_STRINGA)=NUM_CHAR_IDENTIFICATIVI
		IF _STRINGA=SPACE(1)+TIPO_SUPPORTO
			_TROVATO_RECORD=.T.
			EXIT				
		ENDIF
		_STRINGA=SUBSTR(_STRINGA,2,NUM_CHAR_IDENTIFICATIVI-1)	
	ENDIF
	_STRINGA=_STRINGA+FREAD(gnFileHandle,1)
ENDDO

IF !_TROVATO_RECORD
	LOG2FILE("Non trovato record di testa del supporto logico "+TIPO_SUPPORTO)
	=FCLOSE(gnFileHandle) 
	_RETURN=SPACE(0)		
	RETURN(_RETURN)
ENDIF

_POSIZIONE_ATTUALE	= FSEEK(gnFileHandle,0,1)

*** query per sapere quanti record deve contenere il supporto logico
*** che moltiplicati per i caratteri di ciascun record mi da il numero di caratteri
*** totali che deve contenere il mio file (almeno quelli)

cSql=""     
cNomeCursorSql="CCBI_ORDINE"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    SELECT  SUP_LOGICO,
            TIPORECORD,
            ORDINE
    FROM CBI_ORDINE 
    WHERE SUP_LOGICO='<<TIPO_SUPPORTO>>'
    ORDER BY ORDINE

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	=FCLOSE(gnFileHandle) 
	return(.F.)
ENDIF


SELECT CCBI_ORDINE
_NUM_CHAR_SUPPORTO=RECCOUNT()*NUM_CHAR_RECORD

IF _LUNGHEZZA_FILE-_POSIZIONE_ATTUALE+NUM_CHAR_IDENTIFICATIVI<_NUM_CHAR_SUPPORTO
	LOG2FILE("Il file non contiene i "+ALLTRIM(STR(_NUM_CHAR_SUPPORTO))+" caratteri necessari per un supporto logico "+TIPO_SUPPORTO)
	LOG2FILE(NOME_FILE_CBI+" contiene solo "+ALLTRIM(STR(_LUNGHEZZA_FILE-_POSIZIONE_ATTUALE+NUM_CHAR_IDENTIFICATIVI))+" caratteri dall'inizio del record di testa del supporto logico "+TIPO_SUPPORTO)
	=FCLOSE(gnFileHandle) 
	_RETURN=SPACE(0)		
	RETURN(_RETURN)
ENDIF

=FCLOSE(gnFileHandle) 


*** ho letto un record del supporto logico
*** ora leggo leggo struttura cbi del supporto che mi interessa
*** selezionando solo il record che mi interessa

*** determino IDSUPPORTO per questo gruppo di record
_IDSUPPORTO=SYS(2015)

DEF_VAR_SUPPORTO(TIPO_SUPPORTO)

SELECT CCBI_ORDINE
GO TOP
DO WHILE !EOF()

	_TIPORECORD=CCBI_ORDINE.TIPORECORD
	IF !LEGGI_DA_FILE_RECORD_CBI(NOME_FILE_CBI,TIPO_SUPPORTO,_TIPORECORD,_IDSUPPORTO) 
		LOG2FILE("Il file "+NOME_FILE_CBI+" non contiene il record "+_TIPORECORD)
		_RETURN=SPACE(0)
		RETURN(_RETURN)
	ENDIF	
		
	SELECT CCBI_ORDINE
	SKIP
	LOOP
ENDDO

_IN_OUT="I"
_INVIATO_RICEVUTO=.T.  && L'HO RICEVUTO
LOG2DB(TIPO_SUPPORTO,_IDSUPPORTO,_IN_OUT,_INVIATO_RICEVUTO,NOME_FILE_CBI)

_RETURN=_IDSUPPORTO		
RETURN(_RETURN)

ENDPROC



************************************************
PROCEDURE LEGGI_DA_FILE_RECORD_CBI
************************************************
LPARAMETERS NOME_FILE_CBI,TIPO_SUPPORTO,_TIPORECORD,_IDSUPPORTO

#DEFINE NUM_CHAR_RECORD 120
#DEFINE NUM_CHAR_IDENTIFICATIVI 3

LOCAL	riga,;
		gnFileHandle,;
		_STRINGA,;
		_STRINGA_RECORD,;
		_LUNGHEZZA_FILE,;
		_POSIZIONE_ATTUALE,;
		_TROVATO_RECORD,;
		_TIPORECORD,;
		_VARIABILE,;
		_STRINGA_CAMPI_INSERT,;
		_STRINGA_VALORI_INSERT,;
		_POSIZ_INI,;
		_POSIZ_FIN,;
		_IDSUPPORTO,;
		_TIPO_VAR,;
		_NOME_TABELLA_QUESTO_TIPORECORD

_RETURN=SPACE(0)		

IF !FILE(NOME_FILE_CBI) && Esiste il file? 
	LOG2FILE("Non trovato file "+NOME_FILE_CBI)
	RETURN(.F.)
ENDIF

gnFileHandle = FOPEN(NOME_FILE_CBI) && Se esiste, lo apre in lettura
IF gnFileHandle < 0 && Verifica errore in apertura del file
	&& Se non viene trovato alcun errore legge file
	LOG2FILE("Impossibile aprire file "+NOME_FILE_CBI)
		
	RETURN(.F.)
ENDIF

*** controllo la lunghezza del file ASCII
_LUNGHEZZA_FILE = FSEEK(gnFileHandle,0,2)
*** per controllare la lunghezza con FSEEK sono andato alla fine del file
*** per continuare devo tornare all'inizio sempre con FSEEK
FSEEK(gnFileHandle,0,0)

_STRINGA=SPACE(0)
_TROVATO_RECORD=.F.
DO WHILE !FEOF(gnFileHandle)
	IF LEN(_STRINGA)=NUM_CHAR_IDENTIFICATIVI
		IF _STRINGA=SPACE(1)+_TIPORECORD
			_TROVATO_RECORD=.T.
			EXIT				
		ENDIF
		_STRINGA=SUBSTR(_STRINGA,2,NUM_CHAR_IDENTIFICATIVI-1)	
	ENDIF
	_STRINGA=_STRINGA+FREAD(gnFileHandle,1)
ENDDO

IF !_TROVATO_RECORD
	LOG2FILE("Non trovato record "+_TIPORECORD+" del supporto logico "+TIPO_SUPPORTO)
	=FCLOSE(gnFileHandle) 
	RETURN(.F.)
ENDIF

_POSIZIONE_ATTUALE	= FSEEK(gnFileHandle,0,1)


IF _LUNGHEZZA_FILE-_POSIZIONE_ATTUALE+NUM_CHAR_IDENTIFICATIVI<NUM_CHAR_RECORD
	LOG2FILE("Il file non contiene i "+ALLTRIM(STR(NUM_CHAR_RECORD))+" caratteri necessari per un record "+_TIPORECORD+" del supporto logico "+TIPO_SUPPORTO)
	LOG2FILE(NOME_FILE_CBI+" contiene solo "+ALLTRIM(STR(_LUNGHEZZA_FILE-_POSIZIONE_ATTUALE+NUM_CHAR_IDENTIFICATIVI))+" caratteri dall'inizio del record")
	=FCLOSE(gnFileHandle) 
	RETURN(.F.)
ENDIF
_STRINGA_RECORD=_STRINGA+FREAD(gnFileHandle,NUM_CHAR_RECORD-NUM_CHAR_IDENTIFICATIVI)

=FCLOSE(gnFileHandle) 

*** ho letto un record del supporto logico
*** ora leggo leggo struttura cbi del supporto che mi interessa
*** selezionando solo il record che mi interessa

cSql=""     
cNomeCursorSql="CCBI_STRU"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

	SELECT T1.* 
	FROM CBI_STRU AS T1
	INNER JOIN CBI_ORDINE AS T2
	ON  T1.SUP_LOGICO=T2.SUP_LOGICO 
        AND T1.TIPORECORD=T2.TIPORECORD
	WHERE T1.SUP_LOGICO='<<TIPO_SUPPORTO>>'
		AND T1.TIPORECORD='<<_TIPORECORD>>'
	ORDER BY T1.SUP_LOGICO,T2.ORDINE,T1.POSIZ_INI

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	RETURN(.F.)
ENDIF

_STRINGA_CAMPI_INSERT=SPACE(0)
_STRINGA_VALORI_INSERT=SPACE(0)

*** Inizializzo le string di supporto per l'inserimento (CAMPI e VALORI DEI CAMPI) 
*** con il valore dell'idetificativo univoco del supporto

_STRINGA_CAMPI_INSERT="IDSUPPORTO"
_STRINGA_VALORI_INSERT="'"+_IDSUPPORTO+"'"

LOG2FILE("----------------- INIZIO SET VARIABILI PUBBLICHE")

SELECT CCBI_STRU
GO TOP
DO WHILE !EOF()
	
	IF EMPTY(CCBI_STRU.VARIABILE)
		SELECT CCBI_STRU
		SKIP
		LOOP
	ENDIF

	_POSIZ_INI = CCBI_STRU.POSIZ_INI
	_POSIZ_FIN = CCBI_STRU.POSIZ_FIN
	_VARIABILE = ALLTRIM(CCBI_STRU.VARIABILE)
	_TIPO_VAR  = CCBI_STRU.TIPO_VAR
	
	IF !EMPTY(_STRINGA_CAMPI_INSERT) && ho gia' inserito dei campi percui metto le virgole di separazione
		_STRINGA_CAMPI_INSERT=_STRINGA_CAMPI_INSERT+","
		_STRINGA_VALORI_INSERT=_STRINGA_VALORI_INSERT+","
	ENDIF
	
	* preparo i campi per inserimento nella tabella del TIPORECORD corrente
	* il nome dei campi e' contenuto nel campo VARIABILE della tabella CBI_STRU
	_STRINGA_CAMPI_INSERT = _STRINGA_CAMPI_INSERT+_VARIABILE
	
	** FABIANO: MANCANO CONTROLLI FORMALI DA FARE
	
	* preparo i valori dei campi per inserimento nella tabella del TIPORECORD corrente
	* il valore dei campi e' contenuto nei caratteri della stringa letta dal file ASCII del CBI
	_VALORE_CAMPO=ALLTRIM(SUBSTR(_STRINGA_RECORD,POSIZ_INI,_POSIZ_FIN-_POSIZ_INI+1))
	DO CASE
		CASE _TIPO_VAR="I"
			IF EMPTY(_VALORE_CAMPO)
				_VALORE_CAMPO="0"
			ENDIF
			_STRINGA_VALORI_INSERT = _STRINGA_VALORI_INSERT+_VALORE_CAMPO
		CASE _TIPO_VAR="C"
			_STRINGA_VALORI_INSERT = _STRINGA_VALORI_INSERT+"'"+_VALORE_CAMPO+"'"
		CASE _TIPO_VAR="N"
			IF EMPTY(_VALORE_CAMPO)
				_VALORE_CAMPO="0"
			ENDIF
			_STRINGA_VALORI_INSERT = _STRINGA_VALORI_INSERT+_VALORE_CAMPO
		CASE _TIPO_VAR="D"
			_VALORE_CAMPO=RIBALTA2(SUBSTR(_VALORE_CAMPO,1,2)+"/"+SUBSTR(_VALORE_CAMPO,3,2)+"/20"+SUBSTR(_VALORE_CAMPO,5,2))
			_STRINGA_VALORI_INSERT = _STRINGA_VALORI_INSERT+"'"+_VALORE_CAMPO+"'"
	ENDCASE

	_NOME_VARIABILE_PUBLICA="PUB_"+_VARIABILE
	&_NOME_VARIABILE_PUBLICA=_VALORE_CAMPO
	LOG2FILE("----------------- "+_NOME_VARIABILE_PUBLICA+"='"+_VALORE_CAMPO+"'")
			
	SELECT CCBI_STRU
	SKIP
	LOOP
ENDDO
LOG2FILE("----------------- FINE SET VARIABILI PUBBLICHE")


** Inserimento vero e proprio in tabella del TIPORECORD corrente
_NOME_TABELLA_QUESTO_TIPORECORD="CBI"+TIPO_SUPPORTO+IIF(TIPO_SUPPORTO!=_TIPORECORD,_TIPORECORD,SPACE(0))

cSql=""     
cNomeCursorSql="C"+_NOME_TABELLA_QUESTO_TIPORECORD

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    INSERT INTO <<_NOME_TABELLA_QUESTO_TIPORECORD>>
    (<<_STRINGA_CAMPI_INSERT>>) 
    VALUES
    (<<_STRINGA_VALORI_INSERT>>)

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	RETURN(.F.)
ENDIF


ENDPROC
*** FINE PROCEDURE LEGGI_RECORD_CBI


************************************************ SCRITTURA DATI SU FILE ASCII CBI ***************************************


************************************************
PROCEDURE SCRIVI_SU_DB_SUPPORTO_LOGICO_CBI
************************************************
LPARAMETERS TIPO_SUPPORTO

SET STEP ON 

#DEFINE NUM_CHAR_IDENTIFICATIVI 3
#DEFINE NUM_CHAR_RECORD 120

LOCAL	_TIPORECORD,;
		_IDSUPPORTO,;
		cSql,;
		cNomeCursorSql

* DEVE ESSERE RICHIAMATA ESTERNAMENTE IMPOSTANDO LE VRIABILI		
*DEF_VAR_SUPPORTO(TIPO_SUPPORTO)
		
** query per sapere quanti record deve contenere il supporto logico

cSql=""     
cNomeCursorSql="CCBI_ORDINE"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    SELECT  SUP_LOGICO,
            TIPORECORD,
            ORDINE
    FROM CBI_ORDINE 
    WHERE SUP_LOGICO='<<TIPO_SUPPORTO>>'
    ORDER BY ORDINE

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	_RETURN=SPACE(0)		
	RETURN(_RETURN)
ENDIF


*** ora leggo leggo struttura cbi del supporto che mi interessa
*** selezionando solo il record che mi interessa

*** determino IDSUPPORTO per questo gruppo di record
_IDSUPPORTO=SYS(2015)

SELECT CCBI_ORDINE
GO TOP
DO WHILE !EOF()

	_TIPORECORD=CCBI_ORDINE.TIPORECORD
	SCRIVI_SU_DB_RECORD_CBI(TIPO_SUPPORTO,_TIPORECORD,_IDSUPPORTO) 

	SELECT CCBI_ORDINE
	SKIP
	LOOP
ENDDO

* rilascio le variabili per la creazione del file CBI
DEF_VAR_SUPPORTO(TIPO_SUPPORTO,.T.)

_IN_OUT="O"
_INVIATO_RICEVUTO=.F.  && NON L'HO ANCORA INVIATO
LOG2DB(TIPO_SUPPORTO,_IDSUPPORTO,_IN_OUT,_INVIATO_RICEVUTO,"")

_RETURN=_IDSUPPORTO		
RETURN(_RETURN)
ENDPROC
*** FINE PROCEDURE SCRIVI_SU_DB_SUPPORTO_CBI


************************************************
PROCEDURE SCRIVI_SU_DB_RECORD_CBI
************************************************
LPARAMETERS TIPO_SUPPORTO,_TIPORECORD,_IDSUPPORTO

#DEFINE NUM_CHAR_RECORD 120
#DEFINE NUM_CHAR_IDENTIFICATIVI 3

LOCAL	_STRINGA_RECORD,;
		_POSIZIONE_ATTUALE,;
		_TIPORECORD,;
		_VARIABILE,;
		_STRINGA_CAMPI_INSERT,;
		_STRINGA_VALORI_INSERT,;
		_POSIZ_INI,;
		_POSIZ_FIN,;
		_DIMENSIONE,;
		_IDSUPPORTO,;
		_TIPO_VAR,;
		_NOME_TABELLA_QUESTO_TIPORECORD


*** ora leggo leggo struttura cbi del supporto che mi interessa
*** selezionando solo il record che mi interessa

cSql=""     
cNomeCursorSql="CCBI_STRU"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

	SELECT T1.* 
	FROM CBI_STRU AS T1
	INNER JOIN CBI_ORDINE AS T2
	ON  T1.SUP_LOGICO=T2.SUP_LOGICO 
        AND T1.TIPORECORD=T2.TIPORECORD
	WHERE T1.SUP_LOGICO='<<TIPO_SUPPORTO>>'
		AND T1.TIPORECORD='<<_TIPORECORD>>'
	ORDER BY T1.SUP_LOGICO,T2.ORDINE,T1.POSIZ_INI

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

_STRINGA_CAMPI_INSERT=SPACE(0)
_STRINGA_VALORI_INSERT=SPACE(0)

*** Inizializzo le string di supporto per l'inserimento (CAMPI e VALORI DEI CAMPI) 
*** con il valore dell'idetificativo univoco del supporto

_STRINGA_CAMPI_INSERT="IDSUPPORTO"
_STRINGA_VALORI_INSERT="'"+_IDSUPPORTO+"'"

SELECT CCBI_STRU
GO TOP
DO WHILE !EOF()
	
	IF EMPTY(CCBI_STRU.VARIABILE)
		SELECT CCBI_STRU
		SKIP
		LOOP
	ENDIF

	_POSIZ_INI = CCBI_STRU.POSIZ_INI
	_POSIZ_FIN = CCBI_STRU.POSIZ_FIN
	_DIMENSIONE= _POSIZ_FIN-_POSIZ_INI+1
	_VARIABILE = ALLTRIM(CCBI_STRU.VARIABILE)
	_VALORE    = ALLTRIM(CCBI_STRU.VALORE)
	_TIPO_VAR  = CCBI_STRU.TIPO_VAR
	
	IF !EMPTY(_STRINGA_CAMPI_INSERT) && ho gia' inserito dei campi percui metto le virgole di separazione
		_STRINGA_CAMPI_INSERT=_STRINGA_CAMPI_INSERT+","
		_STRINGA_VALORI_INSERT=_STRINGA_VALORI_INSERT+","
	ENDIF
	
	* preparo i campi per inserimento nella tabella del TIPORECORD corrente
	* il nome dei campi e' contenuto nel campo VARIABILE della tabella CBI_STRU
	_STRINGA_CAMPI_INSERT = _STRINGA_CAMPI_INSERT+_VARIABILE
	
	** FABIANO: MANCANO CONTROLLI FORMALI DA FARE

	* preparo i valori dei campi per inserimento nella tabella del TIPORECORD corrente
	* il valore dei campi e' contenuto nelle variabili pubbliche definite da DEF_VAR_RECORD()
	_NOME_VARIABILE_PUBLICA="PUB_"+_VARIABILE
	IF !EMPTY(_VALORE) AND _VARIABILE="TIPORECORD"
		_VALORE_CAMPO=_VALORE
	ELSE
		_VALORE_CAMPO=ALLTRIM(&_NOME_VARIABILE_PUBLICA)
	ENDIF
	
	DO CASE
		CASE _TIPO_VAR="I"
			IF EMPTY(_VALORE_CAMPO)
				_VALORE_CAMPO="0"
			ENDIF
			* il campo importo presenta gia' la virgola nella posizione corretta
			_STRINGA_VALORI_INSERT = _STRINGA_VALORI_INSERT+_VALORE_CAMPO
			_VALORE_CAMPO=SUBSTR(REPLICATE("0",_DIMENSIONE)+_VALORE_CAMPO,LEN(_VALORE_CAMPO)+1,_DIMENSIONE)
		CASE _TIPO_VAR="C"
			_STRINGA_VALORI_INSERT = _STRINGA_VALORI_INSERT+"'"+_VALORE_CAMPO+"'"
			_VALORE_CAMPO=_VALORE_CAMPO+SUBSTR(REPLICATE(SPACE(1),_DIMENSIONE),1,_DIMENSIONE)
		CASE _TIPO_VAR="N"
			IF EMPTY(_VALORE_CAMPO)
				_VALORE_CAMPO="0"
			ENDIF
			_STRINGA_VALORI_INSERT = _STRINGA_VALORI_INSERT+_VALORE_CAMPO
			_VALORE_CAMPO=SUBSTR(REPLICATE("0",_DIMENSIONE)+_VALORE_CAMPO,LEN(_VALORE_CAMPO)+1,_DIMENSIONE)
		CASE _TIPO_VAR="D"
			* mi aspetto la data in formato GG/MM/AAAA
			_STRINGA_VALORI_INSERT = _STRINGA_VALORI_INSERT+"'"+RIBALTA2(_VALORE_CAMPO)+"'"
			_VALORE_CAMPO=SUBSTR(_VALORE_CAMPO,1,2)+SUBSTR(_VALORE_CAMPO,4,2)+SUBSTR(_VALORE_CAMPO,7,4)
	ENDCASE
		
	SELECT CCBI_STRU
	SKIP
	LOOP
ENDDO

* Inserimento vero e proprio in tabella del TIPORECORD corrente
_NOME_TABELLA_QUESTO_TIPORECORD="CBI"+TIPO_SUPPORTO+IIF(TIPO_SUPPORTO!=_TIPORECORD,_TIPORECORD,SPACE(0))

cSql=""     
cNomeCursorSql="C"+_NOME_TABELLA_QUESTO_TIPORECORD

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    INSERT INTO <<_NOME_TABELLA_QUESTO_TIPORECORD>>
    (<<_STRINGA_CAMPI_INSERT>>) 
    VALUES
    (<<_STRINGA_VALORI_INSERT>>)

ENDTEXT					&& FINE SCRITTURA QUERY


IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF


ENDPROC
*** FINE PROCEDURE SCRIVI_SU_DB_RECORD_CBI


************************************************
PROCEDURE SCRIVI_SU_FILE_SUPPORTO_LOGICO_CBI
************************************************
LPARAMETERS _IDSUPPORTO,P_NOME_FILE_CBI

#DEFINE NUM_CHAR_IDENTIFICATIVI 3
#DEFINE NUM_CHAR_RECORD 120

LOCAL	_TIPORECORD,;
		_TIPO_SUPPORTO,;
		_NOME_FILE_CBI,;
		cSql,;
		cNomeCursorSql
		
		
*** query per ricavare il tipo supporto logico
*** del supporto _IDSUPPORTO

cSql=""     
cNomeCursorSql="CCBI_LOG"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    SELECT  TIPORECORD
    FROM CBI_LOG 
    WHERE IDSUPPORTO='<<_IDSUPPORTO>>'

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	_RETURN=SPACE(0)		
	RETURN(_RETURN)
ENDIF


SELECT CCBI_LOG
IF RECCOUNT()!=1
	LOG2FILE("Impossibile scrivere su file il supporto "+_IDSUPPORTO+" perche' non e' presente in CBI_LOG")
	_RETURN=SPACE(0)		
	RETURN(_RETURN)
ENDIF
_TIPO_SUPPORTO=CCBI_LOG.TIPORECORD

*** query per sapere quanti record deve contenere il supporto logico
cSql=""     
cNomeCursorSql="CCBI_ORDINE"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    SELECT  SUP_LOGICO,
            TIPORECORD,
            ORDINE
    FROM CBI_ORDINE 
    WHERE SUP_LOGICO='<<_TIPO_SUPPORTO>>'
    ORDER BY ORDINE

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	_RETURN=SPACE(0)		
	RETURN(_RETURN)
ENDIF


*** ora leggo leggo struttura cbi del supporto che mi interessa
*** selezionando solo il record che mi interessa

IF PCOUNT()=2 AND !EMPTY(P_NOME_FILE_CBI)
	_NOME_FILE_CBI=P_NOME_FILE_CBI
ELSE
	_NOME_FILE_CBI="CBI\"+_TIPO_SUPPORTO+GetTimestamp()+".CBI"
ENDIF

SELECT CCBI_ORDINE
GO TOP

DO WHILE !EOF()

	_TIPORECORD=CCBI_ORDINE.TIPORECORD
	
	SCRIVI_SU_FILE_RECORD_CBI(_NOME_FILE_CBI,_TIPO_SUPPORTO,_TIPORECORD,_IDSUPPORTO) 

	SELECT CCBI_ORDINE
	SKIP
	LOOP
ENDDO

_IN_OUT="O"
_INVIATO_RICEVUTO=.F.  && NON L'HO ANCORA INVIATO
LOG2DB(_TIPORECORD,_IDSUPPORTO,_IN_OUT,_INVIATO_RICEVUTO,_NOME_FILE_CBI)

RETURN(_NOME_FILE_CBI)

ENDPROC
*** FINE PROCEDURE SCRIVI_SUPPORTO_CBI


************************************************
PROCEDURE SCRIVI_SU_FILE_RECORD_CBI
************************************************
LPARAMETERS _NOME_FILE_CBI,TIPO_SUPPORTO,_TIPORECORD,_IDSUPPORTO

#DEFINE NUM_CHAR_RECORD 120
#DEFINE NUM_CHAR_IDENTIFICATIVI 3

LOCAL	_STRINGA_RECORD,;
		_POSIZIONE_ATTUALE,;
		_TIPORECORD,;
		_VARIABILE,;
		_STRINGA_CAMPI_INSERT,;
		_STRINGA_VALORI_INSERT,;
		_POSIZ_INI,;
		_POSIZ_FIN,;
		_DIMENSIONE,;
		_IDSUPPORTO,;
		_TIPO_VAR,;
		_NOME_TABELLA_QUESTO_TIPORECORD,;
		_CURSOR_RECORD


*** ora leggo leggo struttura cbi del supporto che mi interessa
*** selezionando solo il record che mi interessa

cSql=""     
cNomeCursorSql="CCBI_STRU"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

	SELECT T1.* 
	FROM CBI_STRU AS T1
	INNER JOIN CBI_ORDINE AS T2
	ON  T1.SUP_LOGICO=T2.SUP_LOGICO 
        AND T1.TIPORECORD=T2.TIPORECORD
	WHERE T1.SUP_LOGICO='<<TIPO_SUPPORTO>>'
		AND T1.TIPORECORD='<<_TIPORECORD>>'
	ORDER BY T1.SUP_LOGICO,T2.ORDINE,T1.POSIZ_INI

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF


*** leggo il record del supporto che voglio scrivere su file
*** identificato da IDSUPPORTO
_NOME_TABELLA_QUESTO_TIPORECORD="CBI"+TIPO_SUPPORTO+IIF(TIPO_SUPPORTO!=_TIPORECORD,_TIPORECORD,SPACE(0))

cSql=""     
_CURSOR_RECORD="C"+_NOME_TABELLA_QUESTO_TIPORECORD

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    SELECT *
    FROM <<_NOME_TABELLA_QUESTO_TIPORECORD>> 
    WHERE IDSUPPORTO='<<_IDSUPPORTO>>'

ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,_CURSOR_RECORD)
	return(.F.)
ENDIF


_STRINGA=SPACE(0)

*** Inizializzo le string di supporto per l'inserimento (CAMPI e VALORI DEI CAMPI) 
*** con il valore dell'idetificativo univoco del supporto

SELECT CCBI_STRU
GO TOP
DO WHILE !EOF()
	

	_POSIZ_INI = CCBI_STRU.POSIZ_INI
	_POSIZ_FIN = CCBI_STRU.POSIZ_FIN
	_DIMENSIONE= _POSIZ_FIN-_POSIZ_INI+1
	_VARIABILE = ALLTRIM(CCBI_STRU.VARIABILE)
	_TIPO_VAR  = CCBI_STRU.TIPO_VAR
	
	** FABIANO: MANCANO CONTROLLI FORMALI DA FARE
	
	IF EMPTY(CCBI_STRU.VARIABILE)
		_VALORE_CAMPO=REPLICATE(" ",_DIMENSIONE)
	ELSE
		SELECT &_CURSOR_RECORD
		DO CASE
			CASE _TIPO_VAR="I"
				* il campo importo presenta gia' la virgola nella posizione corretta
				_VALORE_CAMPO=SUBSTR(REPLICATE("0",_DIMENSIONE)+ALLTRIM(STR(&_VARIABILE,_DIMENSIONE,2)),LEN(ALLTRIM(STR(&_VARIABILE,_DIMENSIONE,2)))+1,_DIMENSIONE)
			CASE _TIPO_VAR="C"
				_VALORE_CAMPO=SUBSTR(ALLTRIM(&_VARIABILE)+REPLICATE(SPACE(1),_DIMENSIONE),1,_DIMENSIONE)
			CASE _TIPO_VAR="N"
				_VALORE_CAMPO=SUBSTR(REPLICATE("0",_DIMENSIONE)+ALLTRIM(STR(&_VARIABILE)),LEN(ALLTRIM(STR(&_VARIABILE)))+1,_DIMENSIONE)
			CASE _TIPO_VAR="D"
				* mi aspetto la data in formato AAAA/MM/GG
				_VALORE_CAMPO=SUBSTR(ALLTRIM(&_VARIABILE),9,2)+SUBSTR(ALLTRIM(&_VARIABILE),6,2)+SUBSTR(ALLTRIM(&_VARIABILE),3,2)
		ENDCASE
	ENDIF

	_STRINGA=_STRINGA+_VALORE_CAMPO		
	
	SELECT CCBI_STRU
	SKIP
	LOOP
	
ENDDO

STRTOFILE(_STRINGA,_NOME_FILE_CBI,.T.)

ENDPROC
*** FINE PROCEDURE SCRIVI_SU_FILE_RECORD_CBI

************************************************
PROCEDURE DEF_VAR_SUPPORTO
************************************************
LPARAMETERS _TIPO_SUPPORTO,P_RELEASE
LOCAL	_RELEASE

_RELEASE=.F.
IF PCOUNT()=2
	_RELEASE=P_RELEASE
ENDIF

*** query per sapere quanti record deve contenere il supporto logico

cSql=""     
cNomeCursorSql="CCBI_ORDINE"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    SELECT  SUP_LOGICO,
            TIPORECORD,
            ORDINE
    FROM CBI_ORDINE 
    WHERE SUP_LOGICO='<<_TIPO_SUPPORTO>>'
    ORDER BY ORDINE

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF


*** ora leggo leggo struttura cbi del supporto che mi interessa
*** selezionando solo il record che mi interessa

SELECT CCBI_ORDINE
GO TOP
DO WHILE !EOF()

	_TIPORECORD=CCBI_ORDINE.TIPORECORD
	DEF_VAR_RECORD(_TIPO_SUPPORTO,_TIPORECORD,_RELEASE) 

	SELECT CCBI_ORDINE
	SKIP
ENDDO

ENDPROC
*** FINE PROCEDURE DEF_VAR_SUPPORTO

************************************************
PROCEDURE DEF_VAR_RECORD
************************************************
LPARAMETERS _TIPO_SUPPORTO,_TIPO_RECORD,P_RELEASE
LOCAL	_RELEASE

_RELEASE=.F.
IF PCOUNT()=2
	_RELEASE=P_RELEASE
ENDIF

*** ora leggo leggo struttura cbi del supporto che mi interessa
*** selezionando solo il record che mi interessa

cSql=""     
cNomeCursorSql="CCBI_STRU"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

	SELECT T1.* 
	FROM CBI_STRU AS T1
	INNER JOIN CBI_ORDINE AS T2
	ON  T1.SUP_LOGICO=T2.SUP_LOGICO 
        AND T1.TIPORECORD=T2.TIPORECORD
	WHERE T1.SUP_LOGICO='<<_TIPO_SUPPORTO>>'
		AND T1.TIPORECORD='<<_TIPORECORD>>'
	ORDER BY T1.SUP_LOGICO,T2.ORDINE,T1.POSIZ_INI

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT CCBI_STRU
GO TOP
DO WHILE !EOF()
    
    _VARIABILE=ALLTRIM(CCBI_STRU.VARIABILE)
    IF EMPTY(_VARIABILE)
        SELECT CCBI_STRU
        SKIP
        LOOP
    ENDIF
	
	_DORELEASE="RELEASE PUB_"+_VARIABILE
    &_DORELEASE

	IF !_RELEASE
		_DOPUBLIC="PUBLIC PUB_"+_VARIABILE
		&_DOPUBLIC
        _DOINITIALIZE="PUB_"+_VARIABILE+"=SPACE(0)"
        &_DOINITIALIZE
	ENDIF
		
	SKIP
ENDDO

ENDPROC
*** FINE PROCEDURE DEF_VAR_RECORD


************************************************ CREAZIONE DATABASE CBI *************************************************
************************************************
PROCEDURE CREA_DATABASE
************************************************
LOCAL 	_SUP_LOGICO,;
		_SUP_LOGICO,;
		_VARIABILE,;
		_POSIZ_INI,;
		_POSIZ_FIN,;
		_TIPO_CAMPO,;
		_TIPORECORD,;
		_NOME_TABELLA,;
		_DIMENSIONE
		
CREA_TABELLE()
		
USE CBI_STRU IN 0 AGAIN 

SELECT * FROM CBI_STRU ORDER BY SUP_LOGICO,TIPORECORD,POSIZ_INI INTO CURSOR CSTRU

SELECT CSTRU
GO TOP 

*** CREO PRIMA TABELLA 
*** CREAZIONE TABELLE CONTENENTI I DATI DEI SUPPORTI LOGICI
*** Si consideri per semplicita' il <nome supporto logico> = codice che identifica il record di testa
*** del supporto stesso (ad esempio i saldi hanno come record di testa il record di tipo RH percui
*** il supporto logico dei saldi sara' identificato col codice RH)
*** Il nome della tabella e' definito dal prefisso CBI + <nome supporto logico> + <tipo record>
*** se <nome supporto logico> = <tipo record>
*** allora significa che stiamo trattando il record di testa e la tabella si chiamera' con il 
*** solo nome del <nome supporto logico>
*** Esempio: per i saldi iniziali della banca si ricevono i supporti con record di testa RH e composti da
*** Record di testa RH --> tabella CBIRH
*** Record 61          --> tabella CBIRH61
*** Record 62          --> tabella CBIRH62
*** Record 63          --> tabella CBIRH63
*** Record 64          --> tabella CBIRH64
*** Record 65          --> tabella CBIRH65
*** Record di coda EF  --> tabella CBIRHEF


_SUP_LOGICO=CSTRU.SUP_LOGICO
_TIPORECORD=CSTRU.TIPORECORD

_NOME_TABELLA="CBI"+_SUP_LOGICO+IIF(_SUP_LOGICO!=_TIPORECORD,_TIPORECORD,SPACE(0))

CREATE TABLE &_NOME_TABELLA ( IDSUPPORTO C(10))
SELECT &_NOME_TABELLA 
USE
USE &_NOME_TABELLA EXCL IN 0 AGAIN

SELECT CSTRU

DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF
	
	IF EMPTY(CSTRU.SUP_LOGICO)
		LOG2FILE(" - RECORD N."+ALLTRIM(STR(RECNO()))+" non corretto: manca CSTRU.SUP_LOGICO")
		SKIP
		LOOP
	ENDIF

	IF EMPTY(CSTRU.TIPORECORD)
		LOG2FILE(" - RECORD N."+ALLTRIM(STR(RECNO()))+" non corretto: manca CSTRU.TIPORECORD")
		SKIP
		LOOP
	ENDIF

	IF EMPTY(CSTRU.VARIABILE)
		IF ALLTRIM(CSTRU.NOME_CAMPO)!="FILLER"
			LOG2FILE(" - RECORD N."+ALLTRIM(STR(RECNO()))+" "+CSTRU.SUP_LOGICO+" "+CSTRU.TIPORECORD+" non corretto: manca CSTRU.VARIABILE")
		ENDIF
		SKIP
		LOOP
	ENDIF

	IF EMPTY(CSTRU.TIPO_CAMPO)
		LOG2FILE(" - RECORD N."+ALLTRIM(STR(RECNO()))+" "+CSTRU.SUP_LOGICO+" "+CSTRU.TIPORECORD+" non corretto: manca CSTRU.TIPO_CAMPO")
		SKIP
		LOOP
	ENDIF
		
	IF EMPTY(CSTRU.TIPO_VAR)
		LOG2FILE(" - RECORD N."+ALLTRIM(STR(RECNO()))+" "+CSTRU.SUP_LOGICO+" "+CSTRU.TIPORECORD+" non corretto: manca CSTRU.TIPO_VAR")
		SKIP
		LOOP
	ENDIF

	IF CSTRU.POSIZ_FIN-CSTRU.POSIZ_INI<0
		LOG2FILE(" - RECORD N."+ALLTRIM(STR(RECNO()))+" "+CSTRU.SUP_LOGICO+" "+CSTRU.TIPORECORD+" non corretto: CSTRU.POSIZ_FIN minore di CSTRU.POSIZ_INI")
		SKIP
		LOOP
	ENDIF
			
	IF CSTRU.TIPORECORD!=_TIPORECORD
		_SUP_LOGICO=CSTRU.SUP_LOGICO
		_TIPORECORD=CSTRU.TIPORECORD
		_NOME_TABELLA="CBI"+_SUP_LOGICO+IIF(_SUP_LOGICO!=_TIPORECORD,_TIPORECORD,SPACE(0))
		CREATE TABLE &_NOME_TABELLA ( IDSUPPORTO C(10))
		SELECT &_NOME_TABELLA 
		USE
		USE &_NOME_TABELLA EXCL IN 0 AGAIN
	ENDIF
	
	_SUP_LOGICO	=CSTRU.SUP_LOGICO
	_VARIABILE	=CSTRU.VARIABILE
	_POSIZ_INI	=CSTRU.POSIZ_INI
	_POSIZ_FIN	=CSTRU.POSIZ_FIN
	_TIPO_CAMPO =CSTRU.TIPO_CAMPO
	_TIPO_VAR	=CSTRU.TIPO_VAR
	_DIMENSIONE	=_POSIZ_FIN-_POSIZ_INI+1

	SELECT &_NOME_TABELLA

	DO CASE
		CASE _TIPO_VAR="I"
			=MODTBL(ALIAS(SELECT()),_VARIABILE,"N("+ALLTRIM(STR(_DIMENSIONE))+",2)")
		CASE _TIPO_VAR="C"
			=MODTBL(ALIAS(SELECT()),_VARIABILE,"C("+ALLTRIM(STR(_DIMENSIONE))+")")
		CASE _TIPO_VAR="N"
			=MODTBL(ALIAS(SELECT()),_VARIABILE,"N("+ALLTRIM(STR(_DIMENSIONE))+")")
		CASE _TIPO_VAR="D"
			=MODTBL(ALIAS(SELECT()),_VARIABILE,"C(10)")
	ENDCASE
			
	SELECT CSTRU
	SKIP
	LOOP

ENDDO

ENDPROC

***************************
* Procedure TimeMillisec
***************************
PROCEDURE TimeMillisec
  LOCAL data,;
  		ora,;
  		timestamp,;
  		secondiDaMezzanotte,;
  		millisecondi,;
  		str_millisecondi

  secondiDaMezzanotte=seconds()
  ora=substr(TIME(secondiDaMezzanotte),1,8)
  
  millisecondi=(secondiDaMezzanotte-int(secondiDaMezzanotte))*1000
  str_millisecondi="000"+alltrim(str(millisecondi,3,0))
  str_millisecondi=substr(str_millisecondi,len(str_millisecondi)-2)
  
  return ora+":"+str_millisecondi

ENDPROC



***************************
* Procedure GetTimestamp
***************************
PROCEDURE GetTimestamp

  LPARAMETERS pFormato
  
  LOCAL data,;
  		ora,;
  		timestamp,;
  		AAAA,;
  		MM,;
  		GG,;
  		hh,;
  		pp,;
  		ss,;
		mmm,;
		nNumeroParametri
		
  nNumeroParametri=PARAMETERS()
		
  data=dtoc(date())
  ora=TimeMillisec()

  AAAA=substr(data,7,4)
  MM=substr(data,4,2)
  GG=substr(data,1,2)
  
  hh=substr(ora,1,2)
  pp=substr(ora,4,2)
  ss=substr(ora,7,2)
  mmm=substr(ora,10,3)
    
  timestamp=""

  IF nNumeroParametri>=1
	  timestamp=timestamp+&pFormato
  ELSE
	  timestamp=timestamp;
  				+AAAA;
  				+MM;
  				+GG;		&& data in formato AAAAMMGG
  				+hh;
  				+pp;
  				+ss;
  				+mmm		&& ora in formato HHMMssmmm
  ENDIF
  
  return timestamp
  
ENDPROC



*****************************
PROCEDURE LOG2FILE
*****************************
PARAMETERS _TESTO_DA_LOGGARE
LOCAL 	_FILE_LOG_CREAZIONE,;
		_CRLF

		
_FILE_LOG_CREAZIONE="CBI\CBI.LOG"		
_CRLF = CHR(13)+CHR(10)

STRTOFILE(DTOC(DATE())+" - "+TimeMillisec()+": "+_TESTO_DA_LOGGARE+_CRLF,_FILE_LOG_CREAZIONE,.t.)

ENDPROC  	



************************************************
PROCEDURE CREA_TABELLE
************************************************
CREATE TABLE CBI_ORDINE(;
	SUP_LOGICO C(2),;
	TIPORECORD C(2),;
	ORDINE N(2);
)

SELECT CBI_ORDINE

INSERT INTO CBI_ORDINE (SUP_LOGICO,TIPORECORD,ORDINE) VALUES ("RH","RH",1)
INSERT INTO CBI_ORDINE (SUP_LOGICO,TIPORECORD,ORDINE) VALUES ("RH","61",2)
* INSERT INTO CBI_ORDINE (SUP_LOGICO,TIPORECORD,ORDINE) VALUES ("RH","62",3)
* INSERT INTO CBI_ORDINE (SUP_LOGICO,TIPORECORD,ORDINE) VALUES ("RH","63",4)
* INSERT INTO CBI_ORDINE (SUP_LOGICO,TIPORECORD,ORDINE) VALUES ("RH","64",5)
* INSERT INTO CBI_ORDINE (SUP_LOGICO,TIPORECORD,ORDINE) VALUES ("RH","65",6)
INSERT INTO CBI_ORDINE (SUP_LOGICO,TIPORECORD,ORDINE) VALUES ("RH","EF",7)



CREATE TABLE CBI_LOG(;
	TIPORECORD C(2),;
	IDSUPPORTO C(10),;
	IN_OUT C(1), ;
	INVIATO L,;
	RICEVUTO L,;
	DTCREA C(10),;
	ORACREA C(12),;
	DTULT C(10),;
	ORAULT C(12),;
	NOMEFILE C(100);
)

ENDPROC


*****************************
PROCEDURE LOG2DB
*****************************
PARAMETERS _TIPORECORD,_IDSUPPORTO,_IN_OUT,_INVIATO_RICEVUTO,_NOMEFILE,_P_DISTINTA,_P_BANCA
LOCAL _NOME_TABELLA,;
		_DTCREA,;
		_ORACREA,;
		_DTULT,;
		_ORAULT,;
		_INVIATO,;
		_RICEVUTO,;
		_TIPO_FILE,;
		_NR_DISTINTA,;
		_BANCA
		

_DTULT=RIBALTA2(DTOC(DATE()))
_ORAULT=TIMEMILLISEC()

_DTCREA=_DTULT
_ORACREA=_ORAULT

IF _IN_OUT='I'
	_INVIATO=0
	_RICEVUTO=IIF(_INVIATO_RICEVUTO,1,0)
ELSE
	_INVIATO=IIF(_INVIATO_RICEVUTO,1,0)
	_RICEVUTO=0
ENDIF

_NR_DISTINTA=""
IF PCOUNT()>=6
	IF !EMPTY(_P_DISTINTA)
		_NR_DISTINTA=ALLTRIM(_P_DISTINTA)
	ENDIF
ENDIF

_BANCA=""
IF PCOUNT()>=7
	IF !EMPTY(_P_BANCA)
		_BANCA=ALLTRIM(_P_BANCA)
	ENDIF
ENDIF


cSql=""     
cNomeCursorSql="CCBI_LOG"

*** controllo se gia' loggato il supporto

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

    SELECT * 
    FROM CBI_LOG
    WHERE IDSUPPORTO='<<_IDSUPPORTO>>'

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

_TIPO_FILE=""

DO CASE

	CASE _TIPORECORD="IB"
		_TIPO_FILE="RIBA"
		
	CASE _TIPORECORD="PC"
		*IF "STI" $ UPPER(_NOMEFILE)
		IF "STI" $ UPPER(_NOMEFILE) AND SUBSTR(UPPER(_NOMEFILE),1,11) <> "DISTINTAXML"  && ERASMO - 09/02/2016
			_TIPO_FILE="STIPENDIO"
		ELSE
			_TIPO_FILE="BONIFICO"
		ENDIF
		
	CASE _TIPORECORD="F4"
		_TIPO_FILE="F24"
		
	OTHERWISE
		_TIPO_FILE=""

		
ENDCASE

SELECT CCBI_LOG
_NUMREC=RECCOUNT()
IF _NUMREC=0
	* non esiste il supporto nel log
	
	TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY
	
	    INSERT INTO CBI_LOG
	    (DTCREA,ORACREA,DTULT,ORAULT,IDSUPPORTO,TIPORECORD,IN_OUT,INVIATO,RICEVUTO,NOMEFILE,TIPO_FILE,CBI_NUMDIS,CBI_BAPRES) 
	    VALUES
	    ('<<_DTCREA>>','<<_ORACREA>>','<<_DTULT>>','<<_ORAULT>>','<<_IDSUPPORTO>>','<<_TIPORECORD>>','<<_IN_OUT>>',<<_INVIATO>>,<<_RICEVUTO>>,'<<_NOMEFILE>>','<<_TIPO_FILE>>','<<_NR_DISTINTA>>','<<_BANCA>>')
	
	ENDTEXT					&& FINE SCRITTURA QUERY
			
	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF
ELSE
	* esiste il supporto nel log
	
	TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY
	
	    UPDATE CBI_LOG
	    SET DTULT='<<_DTULT>>',ORAULT='<<_ORAULT>>',INVIATO=<<_INVIATO>>,RICEVUTO=<<_RICEVUTO>> ,NOMEFILE='<<_NOMEFILE>>',TIPO_FILE=<<_TIPO_FILE>>'
	    WHERE IDSUPPORTO='<<_IDSUPPORTO>>'
	
	ENDTEXT					&& FINE SCRITTURA QUERY
			
	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF

ENDIF
	
	
ENDPROC  	




**********************************************************
* Classe CasellaViewASCII
**********************************************************
DEFINE CLASS CasellaViewASCII AS TestoPerGriglia

	ReadOnly=.T.

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	ENDPROC
	*- FINE Metodo: Click
    ***************************	
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
      xdescri = CHR(13)+CHR(13)+"NESSUNA ANOMALIA DA EVIDENZIARE"

	  SET CLASSLIB TO "proj_lib.vcx" additive
	  oForm=CreateObject("MsgErr") 
	  oform.edit1.Value=ALLTRIM(XDESCRI)+CHR(13)
	  oform.Show
	  RELEASE oForm 
	  
	ENDPROC
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaAnomalia
**********************************************************





*****************************
PROCEDURE DEF_VAR_PAGAMENTO
*****************************
PARAMETERS _FILE_UNICO


* CREATE CURSOR CSALDI_PARTITE (			;
* 	 SELEZIONE			C(3),			;
* 	 LEGA_SPLIT			C(30),			;
* 	 ID_PARTITA  		C(30),          ;
* 	 tipologia			C(20),			;
* 	 ragsoc 			C(30),          ;
* 	 contabilit 		C(1),  	      	;
* 	 npart 				N(10,0),  	    ;
* 	 dtscad 			C(10),			;
* 	 nsaldo 			N(17,3),		;
* 	 ndare 				N(17,3),		;
* 	 navere 			N(17,3),		;
* 	 codfor 			C(13),			;
* 	 dtscade 			D(8),			;
* 	 tipopagam 			C(10),			;
* 	 cosatratta 		C(5),			;
* 	 gradoimpor 		C(5),			;
* 	 formapagam 		C(5),			;
* 	 tipocontra 		C(5),			;
* 	 codacq 			C(3),			;
* 	 pripaga 			C(4),			;
* 	 c1sepago 			L,				;
* 	 c1sesposto 		L	,			;
* 	 c1quantpag 		N(17,3),		;
* 	 c1quandpag 		C(10),			;
* 	 c1pripag 			C(4),			;
* 	 c1achescad 		C(10),			;
* 	 c1motivo	 		C(50),			;
* 	 c1nomope	 		C(20),			;
* 	 c2sepago 			L 	,			;
* 	 c2sesposto 		L  ,			;
* 	 c2quantpag 		N(17,3),		;
* 	 c2quandpag 		C(10),			;
* 	 c2pripag 			C(4),			;
* 	 c2achescad 		C(10),			;
* 	 c2motivo	 		C(50),			;
* 	 c2nomope	 		C(20),			;
* 	 c3sepago 			L 	,			;
* 	 c3sesposto 		L 	 ,			;
* 	 c3quantpag 		N(17,3),		;
* 	 c3quandpag 		C(10),			;
* 	 c3pripag 			C(4),			;
* 	 c3achescad 		C(10),			;
* 	 c3motivo	 		C(50),			;
* 	 c3nomope	 		C(20),			;
* 	 c4sepago 			L 	,			;
* 	 c4sesposto 		L 	 ,			;
* 	 c4quantpag 		N(17,3),		;
* 	 c4quandpag 		C(10),			;
* 	 c4pripag 			C(4),			;
* 	 c4achescad 		C(10),			;
* 	 c4motivo	 		C(50),			;
* 	 c4nomope	 		C(20),			;
* 	 c5sepago 			L 		,		;
* 	 c5sesposto 		L 	 		,	;
* 	 c5quantpag 		N(17,3)	,		;
* 	 c5quandpag 		C(10)		,	;
* 	 c5pripag 			C(4)		,	;
* 	 c5achescad 		C(10)		,	;
* 	 c5motivo	 		C(50),			;
* 	 c5nomope	 		C(20),			;
* 	 banca 				C(10),			;
* 	 contocorr 			C(20),			;
* 	 contocont 			C(13),			;
* 	 quantavalu 		N(17,3), 		;
* 	 quandovalu 		C(10),;
* 	 ANOMALIA			C(3))

SELECT TESORERIA_PAGATI

_CENTROAPPL_CBI	="1222"
_MITTENTE_CBI	="14125"
_IMPORTO		=ALLTRIM(STR(QUANTAVALU))
_CAUSALE  		="48000"
_IMPORTO		=ALLTRIM(STR(QUANTAVALU))

_NRECORD    = ALLTRIM(STR(RECCOUNT()))			
_NRENDICONT = ALLTRIM(STR(RECCOUNT()))			
_NUMPROFLUS = GETTIMESTAMP("+MM+GG+hh+pp+ss")		
_RICEVENTE  = SUBSTR(BANCA,1,5)					&& RICEVENTE 
_SEGNO      = "A"								&& SEGNO     
_TIPOFLU    = ""					
_TOTIMPNEGA = ALLTRIM(STR(RECCOUNT()))			&& TOT. IMPORTI NEGATIVI 
_TOTIMPPOSI = ALLTRIM(STR(RECCOUNT()))			&& TOT. IMPORTI POSITIVI 

* CAUSALI 
* 27000: emolumenti generici;
* 27010: emolumenti - pensione;
* 27020: emolumenti - stipendi;
* 34000: giroconto; 
* 48000: bonifici generici;
* 48015: bonifici per previdenza complementare ;
* 79000: girofondi. 

*** CAMPI FACOLTATIVI
PUB_ABIDESTI   = SUBSTR(BANCA,1,5)		&& CODICE BANCA DESTINATARIA      C
PUB_BANCABENEF = "" 					&& BANCA/SPORTELLO BENEFICIARIO   C
PUB_BUFFER     = "" 					&& CAMPO A DISPOSIZIONE           C
PUB_CABDESTI   = SUBSTR(BANCA,1,5)		&& CAB BANCA DESTINATARIA         C
PUB_CAPBENEF   = "" 					&& CAP  BENEFICIARIO              C
PUB_CCDESTI    = "" 					&& CONTO DESTINATARIO             C
PUB_CFISCCREDI = "" 					&& CODICE FISCALE CLIENTE CREDITO C
PUB_CHIAVICTRL = "" 					&& CHIAVI DI CONTROLLO            C
PUB_CINBENEF   = "" 					&& CIN COORDINATE BANCARIE        C
PUB_CITTABENEF = "" 					&& COMUNE E SIGLA PROVINCIA  BENE C
PUB_CODAZIORD  = "" 					&& CODICE AZIENDA ORDINANTE       C
PUB_CODBENEF   = "" 					&& CODICE CLIENTE BENEFICIARIO    C
PUB_DATADISPO  = "" 					&& DATA ESECUZIONE DISPOSIZIONE   D
PUB_DATAVALUTA = "" 					&& DATA VALUTA BENEFICIARIO       D
PUB_DESCBENEF2 = "" 					&& 2Ø SEGMENTO DESCRIZIONE CLIENT C
PUB_DESCBENEF3 = "" 					&& 3Ø SEGMENTO DESCRIZIONE CLIENT C
PUB_DESCROPER2 = "" 					&& 2Ø SEGMENTO                    C
PUB_DESCROPER3 = "" 					&& 3Ø SEGMENTO                    C
PUB_FLAGRICHIE = "" 					&& FLAG RICHIESTA                 C
PUB_IDDISPOSIZ = "" 					&& CODICE UNIVOCO                 C
PUB_INDIRBENEF = "" 					&& INDIRIZZO BENEFICIARIO         C
PUB_INDIRIAZI  = "" 					&& INDIRIZZO                      C
PUB_LOCALIAZI  = "" 					&& LOCALIT…                       C
PUB_MODPAG     = "" 					&& MODALIT… DI PAGAMENTO          C
PUB_NUMPROFLUS = "" 					&& NUMERO PROGRESSIVO             C
PUB_TIPOBENEF  = "" 					&& TIPO CODICE BENEFICIARIO       C

*** CAMPI OBBLIGATORI
PUB_ABIGATEWAY = "" 					&& BANCA GATEWAY                  C
PUB_ABIORDINA  = SUBSTR(BANCA,1,5)		&& CODICE BANCA ORDINANTE         C
PUB_CABORDINA  = ""						&& CAB BANCA ORDINANTE            C
PUB_CAUSALE    = _CAUSALE				&& CAUSALE                        C
PUB_CCORDINA   = contocorr				&& CONTO ORDINANTE                C
PUB_CENTROAPPL = _CENTROAPPL_CBI		&& CENTRO APPLICATIVO             C
PUB_CIFRACTRL  = ""						&& CIFRA DI CONTROLLO             C
PUB_CODFISCAZI = ""						&& CODICE FISCALE                 C
PUB_DESCBENEF1 = ""						&& 1Ø SEGMENTO DESCRIZIONE CLIENT C
PUB_DESCRIAZI  = ""						&& DENOMINAZIONE AZIENDA          C
PUB_DESCROPER1 = ""						&& 1Ø SEGMENTO                    C
PUB_DIVISA     = ""						&& CODICE DIVISA                  C
PUB_DTCREA     = RIBALTA2(DTOC(DATE()))	&& DATA CREAZIONE                 D
PUB_DTGGAPPL   = ""						&& GIORNATA APPLICATIVA           D
PUB_IMPORTO    = _IMPORTO				&& IMPORTO                        N
PUB_MITTENTE   = _MITTENTE_CBI			&& MITTENTE                       C
PUB_NOMESUPP   = SUBSTR(_FILE_UNICO,5,20)	&& NOME SUPPORTO                  C
PUB_NRECORD    = _NRECORD				&& NUMERO RECORD                  N
PUB_NRENDICONT = _NRENDICONT			&& NUMERO DISPOSIZIONI            N
PUB_NUMPROFLUS = _NUMPROFLUS			&& NUMERO PROGRESSIVO             C
PUB_QUALIFLU   = ""						&& QUALIFICATORE FLUSSO           C
PUB_RICEVENTE  = SUBSTR(BANCA,1,5)		&& RICEVENTE                      C
PUB_SEGNO      = _SEGNO					&& SEGNO                          C
PUB_TIPOFLU    = _TIPOFLU				&& TIPO FLUSSO                    C
PUB_TIPORECORD = ""						&& TIPO RECORD                    C
PUB_TOTIMPNEGA = _TOTIMPNEGA			&& TOT. IMPORTI NEGATIVI          N
PUB_TOTIMPPOSI = _TOTIMPPOSI			&& TOT. IMPORTI POSITIVI          N
   

RETURN



*********************************************
PROCEDURE GENERA_NOME_FILE_CBI	
*********************************************
PARAMETERS _TIPO_SUPPORTO

LOCAL _NOME_FILE_CBI

_NOME_FILE_CBI="CBI\"+_TIPO_SUPPORTO+GetTimestamp()+".CBI"

RETURN _NOME_FILE_CBI

ENDPROC


*********************************************
PROCEDURE AGGIORNAPE
*********************************************

cSql=""     
cNomeCursorSql="CMOV_CONT"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

   	SELECT T1.ID_UNIQUE , T1.MOV_NUMPRO FROM MOV_CONT AS T1
	INNER JOIN INDICE AS T2
	ON T1.MOV_NUMPRO=T2.MOV_NUMPRO  
	WHERE T2.MOV_DATES='DA-TES'  
	AND T1.MOV_CONTABILITA_PREVISIONALE='P'

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT CMOV_CONT
GO TOP
DO WHILE !EOF()
	_NUMPRO_						= CMOV_CONT.MOV_NUMPRO
	_TIPO_REGISTRAZIONE_			= 'EFFETTIVA'
	_TIPO_CONTO_					= 'FORNITORE'		
	_IDUNIQUE						= CMOV_CONT.id_unique
	_CERTIFICA_REGISTRAZIONE_ 		= "SI"
	
	=PASSA_DA_PREVISIONALE_A_EFFETTIVA_O_IL_CONTRARIO(_NUMPRO_,_IDUNIQUE,_TIPO_REGISTRAZIONE_,_TIPO_CONTO_,_CERTIFICA_REGISTRAZIONE_)

	
	SELECT CMOV_CONT
	SKIP
ENDDO


IF reccount()>0
	SELECT DISTINCT MOV_NUMPRO ;
		FROM CMOV_CONT ;
		INTO CURSOR CCONTA_MOVIMENTI
	
	SELECT CCONTA_MOVIMENTI
	_NUMERO_MOVIMENTI=alltrim(str(reccount()))
		
	messagebox("Passati in contabilità effettiva "+_NUMERO_MOVIMENTI+" movimenti",64,"Contabilizzazione terminata")
ENDIF
	
ENDPROC


*********************************************
PROCEDURE CREARIBACBI
*********************************************

cSql=""     
cNomeCursorSql="CRIBA"

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

   	SELECT T1.ID_UNIQUE , T1.MOV_NUMPRO FROM MOV_CONT AS T1
	INNER JOIN INDICE AS T2
	ON T1.MOV_NUMPRO=T2.MOV_NUMPRO  
	WHERE T2.MOV_DATES='DA-TES'  
	AND T1.MOV_CONTABILITA_PREVISIONALE='P'

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT CRIBA
GO TOP
DO WHILE !EOF()
	_NUMPRO_						= CMOV_CONT.MOV_NUMPRO
	_TIPO_REGISTRAZIONE_			= 'EFFETTIVA'
	_TIPO_CONTO_					= 'FORNITORE'		
	_IDUNIQUE						= CMOV_CONT.id_unique
	_CERTIFICA_REGISTRAZIONE_ 		= "SI"
	
	=PASSA_DA_PREVISIONALE_A_EFFETTIVA_O_IL_CONTRARIO(_NUMPRO_,_IDUNIQUE,_TIPO_REGISTRAZIONE_,_TIPO_CONTO_,_CERTIFICA_REGISTRAZIONE_)

	
	SELECT CMOV_CONT
	SKIP
ENDDO


IF reccount()>0
	SELECT DISTINCT MOV_NUMPRO ;
		FROM CMOV_CONT ;
		INTO CURSOR CCONTA_MOVIMENTI
	
	SELECT CCONTA_MOVIMENTI
	_NUMERO_MOVIMENTI=alltrim(str(reccount()))
		
	messagebox("Passati in contabilità effettiva "+_NUMERO_MOVIMENTI+" movimenti",64,"Contabilizzazione terminata")
ENDIF
	
ENDPROC


*********************************************
PROCEDURE CLEARLOG
*********************************************

ENDPROC


*********************************************
PROCEDURE CBIINVIARICEVI
*********************************************

LOCAL   _DIRECTORY_TRANSITO,;
        _DIRECTORY_CBI,;
        _DIRECTORY_CBI_IN,;
        _DIRECTORY_CBI_OUT,;
        _NUMFILE,;
        _XXX,;
        _NOMEFILE


*************************************************
* -->> scrivo la query da eseguire in sql
*************************************************
TEXT TO cSql NOSHOW
    SELECT *
    FROM PARA
    WHERE CODICE='CBI<<PUB_CODSOC>>'
ENDTEXT

IF !ExecCommand(cSql,"CPara")
   return
ENDIF

*************************************************
SELECT CPara
_DIRECTORY_TRANSITO=ALLTRIM(CPara.LIBERA)

_DIRECTORY_CBI=SYS(2003)+"\CBI\"
_DIRECTORY_CBI_IN=SYS(2003)+"\CBI\IN\"
_DIRECTORY_CBI_OUT=SYS(2003)+"\CBI\OUT\"


*** VERIFICA FILE INFORMAZIONI DA BANCA

CREATE CURSOR FILE_CBI (NOMEFILE C(50))
SELECT FILE_CBI 
INDEX ON NOMEFILE TAG NOMEFILE 

CREATE CURSOR FILE_CBI_IN (NOMEFILE C(50))
SELECT FILE_CBI_IN 
INDEX ON NOMEFILE TAG NOMEFILE 

CREATE CURSOR FILE_CBI_OUT (NOMEFILE C(50),INVIATO L)
SELECT FILE_CBI_OUT 
INDEX ON NOMEFILE TAG NOMEFILE 

CREATE CURSOR FILE_TRANSITO (NOMEFILE C(50))
SELECT FILE_TRANSITO 
INDEX ON NOMEFILE TAG NOMEFILE 


*** CONTROLLA FILE IN TRANSITO
IF ADIR(_ARRAY_FILE,_DIRECTORY_TRANSITO+"*.CB*")!=0
    
    _NUMFILE= ALEN(_ARRAY_FILE,1)
    
    FOR _XXX=1 TO _NUMFILE
        _NOMEFILE=ALLTRIM(_ARRAY_FILE(_XXX,1))
        SELECT FILE_TRANSITO 
        APPEND BLANK
        REPLACE NOMEFILE WITH _NOMEFILE 
    NEXT
    

ENDIF


*** CONTROLLA FILE IN CBI
IF ADIR(_ARRAY_FILE,_DIRECTORY_CBI+"*.CB*")!=0
    
    _NUMFILE= ALEN(_ARRAY_FILE,1)
    
    FOR _XXX=1 TO _NUMFILE
        _NOMEFILE=ALLTRIM(_ARRAY_FILE(_XXX,1))
        SELECT FILE_CBI 
        APPEND BLANK
        REPLACE NOMEFILE WITH _NOMEFILE 
    NEXT
    

ENDIF


*** CONTROLLA FILE IN CBI_IN
IF ADIR(_ARRAY_FILE,_DIRECTORY_CBI_IN+"*.CB*")!=0
    
    _NUMFILE= ALEN(_ARRAY_FILE,1)
    
    FOR _XXX=1 TO _NUMFILE
        _NOMEFILE=ALLTRIM(_ARRAY_FILE(_XXX,1))
        SELECT FILE_CBI_IN
        APPEND BLANK
        REPLACE NOMEFILE WITH _NOMEFILE 
    NEXT
    

ENDIF



*** CONTROLLA FILE IN CBI_OUT
IF ADIR(_ARRAY_FILE,_DIRECTORY_CBI_OUT+"*.CB*")!=0
    
    _NUMFILE= ALEN(_ARRAY_FILE,1)
    
    FOR _XXX=1 TO _NUMFILE
        _NOMEFILE=ALLTRIM(_ARRAY_FILE(_XXX,1))
        SELECT FILE_CBI_OUT
        APPEND BLANK
        REPLACE NOMEFILE WITH _NOMEFILE 
    NEXT
    

ENDIF

SELECT FILE_CBI_OUT
GO TOP 
DO WHILE !EOF()
    IF !("PC" $ FILE_CBI_OUT.NOMEFILE)
        SKIP
        LOOP
    ENDIF
    
    _NOMEFILE=FILE_CBI_OUT.NOMEFILE
    
    SELECT FILE_TRANSITO
    SET ORDER TO NOMEFILE
    
    SEEK _NOMEFILE
    
    IF FOUND()
        SELECT FILE_CBI_OUT
        SKIP
        LOOP
    ENDIF
    
    ****WAIT WINDOW _NOMEFILE NOWAIT
    SELECT FILE_CBI_OUT
    REPLACE INVIATO WITH .T.
    SKIP 
    
ENDDO
