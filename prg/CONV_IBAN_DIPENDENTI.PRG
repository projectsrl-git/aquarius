*************************************************************************************************
* CONVERSIONE IBAN DIPENDENTI
*
*************************************************************************************************
LOCAL _V_FULLPATH


RIT = MESSAGEBOX("Procedo con la conversione dei codici IBAN?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

 
V_PATH = ALLTRIM(PUB_DIR+"\file_da_convertire\xilopan_personale")

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
	
		IF " PC78K80" $ RIGA 
			_TIPO_FILE="IBAN"
			EXIT
		ENDIF
		
		SELECT INPUT_FILE
		SKIP
	ENDDO
	
	
	DO CASE
		CASE _TIPO_FILE="IBAN"
			DO CONVERSIONE_IBAN
	ENDCASE	
		
NEXT

=MESSAGEBOX("OPERAZIONE TERMINATA",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 
 
********************************************************
* CONVERSIONE IBAN 
********************************************************
PROCEDURE CONVERSIONE_IBAN

WAIT WINDOW "CONVERSIONE IBAN DIPENDENTI" NOWAIT

cSql="SELECT * FROM RISURAPP"
   	IF !ExecCommand(cSql,"_TEMP")
	return(.f.)
ENDIF

SELECT _TEMP
IF RECCOUNT()=0
	MESSAGEBOX("NESSUN RAPPORTO INSERITO PER LE RISORSE UMANE AZIENDALI."+CHR(13)+"CARICARE GLI STIPENDI DI UN MESE PER INIZIALIZZARE LE RISORSE.",48,"ATTENZIONE")
	RETURN
ENDIF

SELECT INPUT_FILE 
GO TOP

_IBAN=""
_DIPENDENTE=""

DO WHILE !EOF()

	
	IF "100000"=SUBSTR(RIGA,2,6)
		_IBAN=""
		_DIPENDENTE=""
	ENDIF

	IF "170000"=SUBSTR(RIGA,2,6)
		_IBAN=SUBSTR(RIGA,11,27)
	ENDIF
	
	IF "300000"=SUBSTR(RIGA,2,6)
	
		_DIPENDENTE=APITOSPA(ALLTRIM(SUBSTR(RIGA,11,27)))
		cSql="SELECT TAGGANCIO FROM RISUMANA WHERE RTRIM(COGNOME)+' '+RTRIM(NOME)='"+_DIPENDENTE+"'"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
		
		SELECT _TEMP

		IF RECCOUNT()=0
			MESSAGEBOX("NON TROVATO DIPENDENTE "+_DIPENDENTE,48,"ATTENZIONE")
			SELECT INPUT_FILE
			SKIP
			LOOP
		ENDIF
		
		_TAGGANCIO=TAGGANCIO

		cSql="DELETE FROM RISUBANC WHERE DAGGANCIO IN (SELECT TAGGANCIO FROM RISUMANA WHERE RTRIM(COGNOME)+' '+RTRIM(NOME)='"+_DIPENDENTE+"')"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF

		cSql="INSERT INTO RISUBANC (DAGGANCIO,B_RIFER,ORDINE,IBAN) VALUES('"+_TAGGANCIO+"','S',1,'"+_IBAN+"')"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
		
	ENDIF

	SELECT INPUT_FILE
	SKIP
ENDDO


