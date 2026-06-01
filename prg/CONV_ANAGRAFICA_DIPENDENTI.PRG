*************************************************************************************************
* CONVERSIONE IBAN DIPENDENTI
*
*************************************************************************************************
LOCAL _V_FULLPATH


RIT = MESSAGEBOX("Procedo con la conversione ANAGRAFICA DIPENDENTI?",292,"ATTENZIONE")
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


IF ADIR(_FILEINPUT,"*.XLS")=0
	=MESSAGEBOX("Nessun file da convertire presente nel percorso "+ ALLTRIM(V_PATH)+"."+CHR(13)+"Operazione terminata senza conversione di dati",48,"ATTENZIONE")
	SET DEFAULT TO &PUB_DIR
	RETURN
ENDIF
	

_NUMFILE= ALEN(_FILEINPUT,1)

FOR XXX=1 TO _NUMFILE
		
	_NOMEFILE=ALLTRIM(_FILEINPUT(XXX,1))
	
	CREATE CURSOR INPUT_FILE (;
		Matricola C(100),;
		Nominativo C(100),;
		Qualifica C(100),;
		Livello	C(3),;
		CdC	C(3),;
		CentrodiCosto C(100),;
		Sesso C(1),;
		Assunzione C(10),;
		Licenziam C(10),;
		DataNascita	C(10),;
		LuogoNascita C(100),;
		CodFisc	C(100),;
		Cittadinanza C(100),;
		CAP C(5),;
		Residenza C(100),;
		PROVINCIA C(2),;
		INDIRIZZO C(100),;
		Telefono C(100),;
		Cellulare C(100),;
		EMail C(100),;
		Mansione C(100),;
		Titolodistudio C(100);
	)
	
	SELECT INPUT_FILE 
	_APPEND="APPEND FROM '"+V_PATH +"\"+_NOMEFILE+"' XLS"
	&_APPEND

	IF UPPER(_NOMEFILE)=UPPER("DIPENDENTI XILOPAN.xls")
		DO CONVERSIONE_ANAGRAFICA
	ENDIF

NEXT

=MESSAGEBOX("OPERAZIONE TERMINATA",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 
 
********************************************************
* CONVERSIONE ANAGRAFICA
********************************************************
PROCEDURE CONVERSIONE_ANAGRAFICA

WAIT WINDOW "CONVERSIONE ANAGRAFICA DIPENDENTI" NOWAIT

cSql="SELECT * FROM RISURAPP"
   	IF !ExecCommand(cSql,"_TEMP")
	return(.f.)
ENDIF

SELECT _TEMP
IF RECCOUNT()=0
	MESSAGEBOX("NESSUN RAPPORTO INSERITO PER LE RISORSE UMANE AZIENDALI."+CHR(13)+"CARICARE GLI STIPENDI DI UN MESE PER INIZIALIZZARE LE RISORSE.",48,"ATTENZIONE")
	RETURN
ENDIF


cSql="DELETE FROM PARA WHERE CODICE ='STAAL'"
   	IF !ExecCommand(cSql,"_TEMP")
	return(.f.)
ENDIF

cSql="INSERT INTO PARA (CODICE,DESCRI) VALUES ('STAAL','ALBANIA')"
   	IF !ExecCommand(cSql,"_TEMP")
	return(.f.)
ENDIF


SELECT INPUT_FILE 
GO TOP

_IBAN=""
_DIPENDENTE=""

DO WHILE !EOF()

	IF RECNO()=1
		SKIP
		LOOP
	ENDIF
	
	_NOMINATIVO=ALLTRIM(Nominativo)
	_MATRICOLA=ALLTRIM(MATRICOLA)
	
	_SESSO=ALLTRIM(Sesso)
	_CodFiscale=ALLTRIM(CodFisc)
	_LocNascita=APITOSPA(ALLTRIM(LuogoNascita))
	_D_Nascita=RIBALTA2(ALLTRIM(DataNascita))
	_LocResidenz=APITOSPA(ALLTRIM(Residenza))
	_IndResidenz=APITOSPA(ALLTRIM(INDIRIZZO))
	_CapResidenz=ALLTRIM(CAP)
	_TelFisso=ALLTRIM(TELEFONO)
	_TelMobile=ALLTRIM(Cellulare)
	_EMail=ALLTRIM(EMAIL)
	_D_INIZIO=RIBALTA2(ALLTRIM(ASSUNZIONE))
	_Mansione=ALLTRIM(Mansione)

	
	DO CASE
		CASE UPPER(ALLTRIM(Cittadinanza))='ITALIANA'
			_NAZIONE='IT'
		CASE UPPER(ALLTRIM(Cittadinanza))='ALBANESE'
			_NAZIONE='AL'
	ENDCASE	
	
	IF EMPTY(_MATRICOLA)
		MESSAGEBOX("MATRICOLA NON VALORIZZATA PER DIPENDENTE "+_NOMINATIVO,48,"ATTENZIONE")
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF

	
	cSql=""     
	cNomeCursorSql="_TEMP"

	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

		SELECT 
			ANA.TAGGANCIO,
			ANA.COGNOME,
			ANA.NOME,
			RAP.MATRICOLA
		FROM RISUMANA AS ANA
		LEFT OUTER JOIN RISURAPP AS RAP
		ON ANA.TAGGANCIO=RAP.DAGGANCIO AND B_INCORSO='S'
		WHERE RAP.MATRICOLA='<<_MATRICOLA>>'

	ENDTEXT					&& FINE SCRITTURA QUERY

	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF	
	
	
	SELECT _TEMP

	IF RECCOUNT()=0
		***MESSAGEBOX("NON TROVATO DIPENDENTE "+_NOMINATIVO,48,"ATTENZIONE")
		SELECT INPUT_FILE
		SKIP
		LOOP
	ENDIF
	
	_TAGGANCIO=ALLTRIM(TAGGANCIO)
	_COGNOME=ALLTRIM(COGNOME)
	_NOME=ALLTRIM(NOME)
	_MATRICOLA=ALLTRIM(MATRICOLA)
	
	
*!*		IF _COGNOME+" "+_NOME != _NOMINATIVO
*!*			MESSAGEBOX("INCONGRUENZA MATRICOLA-NOMINATIVO"+CHR(13)+"FOGLIO EXCEL: DIPENDENTE "+_NOMINATIVO+" MATR."+_MATRICOLA+CHR(13)+;
*!*						"FOGLIO EXCEL: DIPENDENTE "+_COGNOME+" "+_NOME+" MATR."+_MATRICOLA,48,"ATTENZIONE")
*!*			SELECT INPUT_FILE
*!*			SKIP
*!*			LOOP
*!*		ENDIF

	cSql=""     
	cNomeCursorSql="_TEMP"
	

	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

		UPDATE RISUMANA	SET 
			SESSO='<<_Sesso>>',
			CodFiscale='<<_CodFiscale>>',
		    PartitaIva='',
			LocNascita='<<_LocNascita>>',
			D_Nascita='<<_D_Nascita>>',
			LocResidenz='<<_LocResidenz>>',
			IndResidenz='<<_IndResidenz>>',
		    CapResidenz='<<_CapResidenz>>',
			LocDomicil='<<_LocResidenz>>',
		    IndDomicil='<<_IndResidenz>>',
		    CapDomicil='<<_CapResidenz>>',
		    TelDomicil='',
		    FaxDom='',
			FaxRes='',
			TelFisso='',
			TelMobile='',
			EMail='',
		    Annotazioni='',
		    B_RisSociet=1,
		    B_RisGruppo=0,
			B_RisEstern=0,
			UtenteIns='<<PUB_CODOPE>>',
			D_DataIns='',
			UtenteMod='',
			D_DataMod='',
			ModPag='',
			TermPagCli='',
			TermPagFor='',
			TIPO_RISORSA='',
			IDTITOLO='',
			TELRESIDENZ='',
			IDSTATORIS='',
			NAZIONE='<<_NAZIONE>>',
			IDSTATOCIV='',
			IDPOSMILIT='',
			PAGCLI='',
			PAGFOR='',
			PASSWORD='',
			USERID='',
			RUOLO='',
			EMAIL1='',
			EMAIL2=''
		WHERE TAGGANCIO='<<_TAGGANCIO>>'


	ENDTEXT					&& FINE SCRITTURA QUERY

	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF	
	

	cSql=""     
	cNomeCursorSql="_TEMP"
	

	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

		UPDATE RISURAPP	SET 
			D_DATA='<<_D_INIZIO>>',
			D_INIZIO='<<_D_INIZIO>>',
			TIPO_ATTIVITA='<<_Mansione>>'
		WHERE DAGGANCIO='<<_TAGGANCIO>>'


	ENDTEXT					&& FINE SCRITTURA QUERY

	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF	
	


	SELECT INPUT_FILE
	SKIP
ENDDO


