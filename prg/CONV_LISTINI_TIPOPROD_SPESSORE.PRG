*************************************************************************************************
* CONVERSIONE LISTINI XILOPAN
*
* - CLIENTE
* - TIPO-PRODOTTOep 
* - SPESSORE
* - GRUPPO-COLORE
*************************************************************************************************
LOCAL _V_FULLPATH


RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei LISTINI?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

 
V_PATH = ALLTRIM(PUB_DIR+"\file_da_convertire\xilopan_listini")

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" ,48,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH 


IF ADIR(_FILEINPUT,"*.TXT")=0
	=MESSAGEBOX("Nessun file da convertire presente nel percorso "+ ALLTRIM(V_PATH)+"."+CHR(13)+"Operazione terminata senza conversione di dati",48,"ATTENZIONE")
	SET DEFAULT TO &PUB_DIR
	RETURN
ENDIF
	

_NUMFILE= ALEN(_FILEINPUT,1)

FOR XXX=1 TO _NUMFILE
		
	_NOMEFILE=ALLTRIM(_FILEINPUT(XXX,1))
	
	CREATE CURSOR INPUT_FILE (RIGA C(254))
	SELECT INPUT_FILE 
	_APPEND="APPEND FROM '"+V_PATH +"\"+_NOMEFILE+"' SDF"
	&_APPEND


	*** INDIVIDUO IL TIPO DI FILE	
	_TIPO_FILE=""
	
	SELECT INPUT_FILE 
	GO TOP
	
	DO WHILE !EOF()
	
		IF "Colonna listino" $ RIGA 
			_TIPO_FILE="COLORI"
			EXIT
		ENDIF
		
		IF "Tipo (per Grezzo)" $ RIGA 
			_TIPO_FILE="TIPO_LISTINO_GREZZO"
			EXIT
		ENDIF

		IF "Tipo (per Nobilitato)" $ RIGA 
			_TIPO_FILE="TIPO_LISTINO_NOBILITATO"
			EXIT
		ENDIF

		IF "S T A M P A    L I S T I N I" $ RIGA 
			_TIPO_FILE="LISTINO"
			EXIT
		ENDIF
		
		SELECT INPUT_FILE
		SKIP
	ENDDO
	
	
	DO CASE
		CASE _TIPO_FILE="COLORI"
			DO CONVERSIONE_GRUPPI_COLORE
		CASE _TIPO_FILE="TIPO_LISTINO_GREZZO"
			DO CONVERSIONE_TIPO_LISTINO_GREZZO
		CASE _TIPO_FILE="TIPO_LISTINO_NOBILITATO"
			DO CONVERSIONE_TIPO_LISTINO_NOBILITATO
		CASE _TIPO_FILE="LISTINO"
			DO CONVERSIONE_LISTINO
	ENDCASE	
		
NEXT

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 
 
********************************************************
* CONVERSIONE GRUPPI COLORI 
********************************************************
* FORMATO DEL FILE
*|Cd el.  A/S  Descrizione                                Mar/Colonna listino 
*|  A27        A27 ACERO C.                                03 F               
********************************************************
PROCEDURE CONVERSIONE_GRUPPI_COLORE

WAIT WINDOW "CONVERSIONE ABBINAMENTO GRUPPI-COLORE A COLORI" NOWAIT

SELECT INPUT_FILE 
GO TOP

DO WHILE !EOF()

	IF "Colonna listino" $ RIGA 
		SELECT INPUT_FILE
		SKIP
	ENDIF

	IF EMPTY(RIGA)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF

	IF LEN(RTRIM(RIGA))<61
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	
	_CODICE_COLORE=SUBSTR(RIGA,3,3)
	_DESCRIZIONE_COLORE=STRTRAN(ALLTRIM(SUBSTR(RIGA,14,44)),"'",SPACE(0))
	_GRUPPO_COLORE=SUBSTR(RIGA,61,1)
	
	IF EMPTY(_CODICE_COLORE)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	cSql="SELECT * FROM PARA WHERE CODICE ='COL"+_CODICE_COLORE+"'"
   	IF !ExecCommand(cSql,"_COLORI")
		return(.f.)
	ENDIF

	SELECT _COLORI
	GO TOP
	IF !EOF()
		cSql="UPDATE PARA SET LIBERA = '"+_GRUPPO_COLORE+"' WHERE CODICE ='COL"+_CODICE_COLORE+"'"
	   	IF !ExecCommand(cSql,"_COLORI")
			return(.f.)
		ENDIF
	ELSE
		cSql="INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('COL"+_CODICE_COLORE+"','"+_DESCRIZIONE_COLORE+"','"+_GRUPPO_COLORE+"')"
	   	IF !ExecCommand(cSql,"_COLORI")
			return(.f.)
		ENDIF
	ENDIF
	
	SELECT INPUT_FILE
	SKIP
ENDDO


********************************************************
* CONVERSIONE TIPO LISTINO GREZZO
********************************************************
* FORMATO DEL FILE
*|Cd el.  A/S  Descrizione	    GMe/List.  Gr.Stat.
*|*        CARTA	*
*|#        Bordo	#
*|A        TRUCIOLARE EPF-S A	    11 02       05
********************************************************
PROCEDURE CONVERSIONE_TIPO_LISTINO_GREZZO

WAIT WINDOW "CONVERSIONE TIPO LISTINO GREZZO" NOWAIT

SELECT INPUT_FILE 
GO TOP

DO WHILE !EOF()

	IF "Cd el." $ RIGA 
		SELECT INPUT_FILE
		SKIP
	ENDIF

	IF EMPTY(RIGA)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF

	IF LEN(RTRIM(RIGA))<37
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	
	_CODICE_TIPO_PRODOTTO=SUBSTR(RIGA,1,1)
	_DESCRIZIONE_TIPO_PRODOTTO=STRTRAN(ALLTRIM(SUBSTR(RIGA,10,23)),"'",SPACE(0))
	_TIPO_LISTINO=SUBSTR(RIGA,36,2)
	
	IF EMPTY(_CODICE_TIPO_PRODOTTO)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	IF EMPTY(_TIPO_LISTINO)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	cSql="SELECT * FROM PARA WHERE CODICE ='TIG"+_CODICE_TIPO_PRODOTTO+"'"
   	IF !ExecCommand(cSql,"_TEMP")
		return(.f.)
	ENDIF

	SELECT _TEMP
	GO TOP
	IF !EOF()
		cSql="UPDATE PARA SET LIBERA = '"+_TIPO_LISTINO+"' WHERE CODICE ='TIG"+_CODICE_TIPO_PRODOTTO+"'"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
	ELSE
		cSql="INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('TIG"+_CODICE_TIPO_PRODOTTO+"','"+_DESCRIZIONE_TIPO_PRODOTTO+"','"+_TIPO_LISTINO+"')"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
	ENDIF
	
	SELECT INPUT_FILE
	SKIP
ENDDO



********************************************************
* CONVERSIONE TIPO LISTINO NOBILITATO
********************************************************
* FORMATO DEL FILE
*|Tipo (per Nobilitato)
*|Cd el.  A/S  Descrizione                                GMe/List.  Gr.Stat.	
*|#        BORDO ABS                                   #  99	
*|A        TR.EPF-S A NOB.                             00 03	
********************************************************
PROCEDURE CONVERSIONE_TIPO_LISTINO_NOBILITATO

WAIT WINDOW "CONVERSIONE TIPO LISTINO NOBILITATO" NOWAIT


SELECT INPUT_FILE 
GO TOP

DO WHILE !EOF()

	IF "Cd el." $ RIGA 
		SELECT INPUT_FILE
		SKIP
	ENDIF

	IF EMPTY(RIGA)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF

	IF LEN(RTRIM(RIGA))<37
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	
	_CODICE_TIPO_PRODOTTO=SUBSTR(RIGA,1,1)
	_DESCRIZIONE_TIPO_PRODOTTO=STRTRAN(ALLTRIM(SUBSTR(RIGA,10,44)),"'",SPACE(0))
	_TIPO_LISTINO=SUBSTR(RIGA,57,2)
	
	IF EMPTY(_CODICE_TIPO_PRODOTTO)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	IF EMPTY(_TIPO_LISTINO)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	cSql="SELECT * FROM PARA WHERE CODICE ='TNO"+_CODICE_TIPO_PRODOTTO+"'"
   	IF !ExecCommand(cSql,"_TEMP")
		return(.f.)
	ENDIF

	SELECT _TEMP
	GO TOP
	IF !EOF()
		cSql="UPDATE PARA SET LIBERA = '"+_TIPO_LISTINO+"' WHERE CODICE ='TNO"+_CODICE_TIPO_PRODOTTO+"'"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
	ELSE
		cSql="INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('TNO"+_CODICE_TIPO_PRODOTTO+"','"+_DESCRIZIONE_TIPO_PRODOTTO+"','"+_TIPO_LISTINO+"')"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
	ENDIF
	
	SELECT INPUT_FILE
	SKIP
ENDDO


********************************************************
* CONVERSIONE LISTINO
********************************************************
* FORMATO DEL FILE
*|                                                                            02 LISTINO TRUCIOLARE GREZZO
*|-----------------------------------------------------------------------------------------------------------------------------------------------------------------===== VARIAZIONI SU PREZZO BASE =====
*|Gruppo Descrizione                                                             UM  Val.            Prezzo  ---- Sconti  % ----             Validit…               +/-     Quantit… - % -       Importo
*|-----------------------------------------------------------------------------------------------------------------------------------------------------------------=====================================
*|  X04  X mm 4                                                                      EURO           410,00000                               31/12/2099
********************************************************

PROCEDURE CONVERSIONE_LISTINO

WAIT WINDOW "CONVERSIONE LISTINO" NOWAIT


SELECT INPUT_FILE 
GO TOP

_LIS_FLAGGN=""
_LIS_DESCGN=""
_LIS_TIPOPR=""
_LIS_DESTIP=""
_LIS_GRCOLF=""
_LIS_GRCOLR=""
_LIS_SPESSO=0
_LIS_UMVEND=""
_LIS_PREZZO=0
_LIS_DATADA="01/01/1990"
_LIS_DATAAL="31/12/2099"
_TIPO_LISTINO=""



DO WHILE !EOF()

	IF "S T A M P A " $ RIGA 
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF

	IF "Gruppo Descrizione" $ RIGA 
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF

	IF "---------------------------------" $ RIGA 
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF


	IF EMPTY(RIGA)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF

	IF EMPTY(SUBSTR(RIGA,1,76)) AND !EMPTY(SUBSTR(RIGA,77,2))
		_TIPO_LISTINO=SUBSTR(RIGA,77,2)
		
		IF "GREZZO" $ RIGA
			_LIS_FLAGGN="G"
			_LIS_DESCGN="GREZZO"
			_LIS_UMVEND="MC"
		ELSE
			_LIS_FLAGGN="N"
			_LIS_DESCGN="NOBILITATO"
			_LIS_UMVEND="MQ"
		ENDIF
		
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	IF LEN(RTRIM(RIGA))<148
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	_LIS_GRCOLF=SUBSTR(RIGA,3,1)
	_LIS_SPESSO=VAL(SUBSTR(RIGA,4,2))
	___STR_PREZZO=STRTRAN(SUBSTR(RIGA,99,9),",",".")
	_LIS_PREZZO=VAL(___STR_PREZZO)
	_LIS_DATADA=RIBALTA2("01/01/1990")
	_LIS_DATAAL=RIBALTA2(SUBSTR(RIGA,139,10))

	
	IF EMPTY(_LIS_GRCOLF)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	IF _LIS_SPESSO=0
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	IF _LIS_PREZZO=0
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	IF EMPTY(_TIPO_LISTINO)
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	
	*** TROVO I TIPI PRODOTTO ABBINATI AL TIPO LISTINO
	IF _LIS_FLAGGN='G'
		cSql="SELECT * FROM PARA WHERE CODICE LIKE 'TIG%' AND LIBERA='"+_TIPO_LISTINO+"'"
	ELSE
		cSql="SELECT * FROM PARA WHERE CODICE LIKE 'TNO%' AND LIBERA='"+_TIPO_LISTINO+"'"
	ENDIF
		
   	IF !ExecCommand(cSql,"CTIPI_PROD")
		return(.f.)
	ENDIF
	
	*** PER TUTTI I TIPI PRODOTTO ABBINATI AL LISTINO FACCIO UNA INSERT (PRIMA CANCELLO L'EVENTUALE RECORD PRESENTE)
	
	SELECT CTIPI_PROD	
	GO TOP
	DO WHILE !EOF()
	
		_LIS_TIPOPR=SUBSTR(CODICE,4,1)
		_LIS_DESTIP=DESCRI
		
		cSql="DELETE FROM U_LIS_TS WHERE LIS_CODSOC='"+PUB_CODSOC+"' AND LIS_CODCLI='' AND LIS_FLAGGN='"+_LIS_FLAGGN+"' AND LIS_TIPOPR='"+_LIS_TIPOPR+"' AND LIS_GRCOLF='"+_LIS_GRCOLF+"' AND LIS_GRCOLR='' AND LIS_SPESSO="+STR(_LIS_SPESSO)
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
				
		cSql="INSERT INTO U_LIS_TS (LIS_CODSOC,LIS_CODCLI,LIS_FLAGGN,LIS_DESCGN,LIS_TIPOPR,LIS_DESTIP,LIS_GRCOLF,LIS_GRCOLR,LIS_UMVEND,LIS_SPESSO,LIS_PREZZO,LIS_DATADA,LIS_DATAAL) VALUES ('"+PUB_CODSOC+"','','"+_LIS_FLAGGN+"','"+_LIS_DESCGN+"','"+_LIS_TIPOPR+"','"+_LIS_DESTIP+"','"+_LIS_GRCOLF+"','','"+_LIS_UMVEND+"',"+STR(_LIS_SPESSO)+","+___STR_PREZZO+",'"+_LIS_DATADA+"','"+_LIS_DATAAL+"')"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
		
		SELECT CTIPI_PROD
		SKIP
		LOOP
	ENDDO

	
	SELECT INPUT_FILE
	SKIP
ENDDO
