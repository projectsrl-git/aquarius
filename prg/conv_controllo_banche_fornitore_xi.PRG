*************************************************************************************************
*							CONTROLLA BANCE DEL FORNITORE										*
*						 																	    *
*	Controllo codici banche fornitore 														    *
*						 																	    *
*						 																	    *
*						 																	    *
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2011 : Xilopan 			 														*
*************************************************************************************************

LOCAL _V_FULLPATH


RIT = MESSAGEBOX("Procedo con la conversione dei codici IBAN?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

 
V_PATH = ALLTRIM(PUB_DIR+"\file_da_convertire\xilopan\iban_fornitori")

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
	

CREATE CURSOR IBAN_FOR (PIVA C(16), IBAN C(27), COD_NAZIONE C(2),  CHK_DIGIT C(2), CIN C(1), ABI C(5), CAB C(5), CC C(12), DATA_AGG C(10), CODFOR C(10))
INDEX ON CODFOR TAG CODFOR 
SELECT IBAN_FOR 	
SET ORDER TO CODFOR 

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

SELECT IBAN_FOR 
GO TOP
BROWSE NORMAL
GO TOP

DO WHILE !EOF()

	_COD_NAZIONE=COD_NAZIONE
	_CHK_DIGIT=CHK_DIGIT
	_CIN=CIN
	_ABI=ABI
	_CAB=CAB
	_CC=CC
	_IBAN=IBAN
	_PIVA=PIVA


	cSql=""     
	cNomeCursorSql="_TEMP"

	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

		UPDATE U_FOR_AN SET for_ba2naz='<<_COD_NAZIONE>>', 
			for_ba2chk='<<_CHK_DIGIT>>',
			for_ba2cin='<<_CIN>>', 
			for_ba2abi='<<_ABI>>', 
			for_ba2cab='<<_CAB>>', 
			for_ba2cc='<<_CC>>', 
			for_ba2iba='<<_IBAN>>' 
		WHERE FOR_PARIVA='<<_PIVA>>' OR FOR_CODFIS='<<_PIVA>>' OR FOR_IVACEE='<<_PIVA>>'

	ENDTEXT					&& FINE SCRITTURA QUERY

	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF	
	

	SELECT IBAN_FOR 
	SKIP
ENDDO

DO CONTROLLO_BANCHE_FORNITORE

=MESSAGEBOX("OPERAZIONE TERMINATA",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

 
********************************************************
* CONVERSIONE IBAN 
********************************************************
PROCEDURE CONVERSIONE_IBAN

WAIT WINDOW "CONVERSIONE IBAN FORNITORI" NOWAIT

*!*			COALESCE(SUBSTRING(BAN.IBAN,1,2),'') AS COD_NAZIONE,
*!*			COALESCE(SUBSTRING(BAN.IBAN,3,2),'') AS CHK_DIGIT,
*!*			COALESCE(SUBSTRING(BAN.IBAN,5,1),'') AS CIN,
*!*			COALESCE(SUBSTRING(BAN.IBAN,6,5),'') AS ABI,
*!*			COALESCE(SUBSTRING(BAN.IBAN,11,5),'') AS CAB,
*!*			COALESCE(SUBSTRING(BAN.IBAN,16,12),'') AS CC,

SELECT INPUT_FILE 
GO TOP

_IBAN=""
_PIVA=""
_CODFOR=""
_DATA_AGG =""
_COD_NAZIONE=""
_CHK_DIGIT=""
_CIN=""
_ABI=""
_CAB=""
_CC=""
_IBAN=""
_PIVA=""


DO WHILE !EOF()

	
	IF "100000"=SUBSTR(RIGA,2,6)
		_IBAN=""
		_PIVA=""
		_CODFOR=""
		_DATA_BONIFICO =SUBSTR(RIGA,17,6)
		_DATA_AGG = "20"+SUBSTR(_DATA_BONIFICO,5,2)+"/"+SUBSTR(_DATA_BONIFICO,3,2)+"/"+SUBSTR(_DATA_BONIFICO,1,2)
		_COD_NAZIONE=""
		_CHK_DIGIT=""
		_CIN=""
		_ABI=""
		_CAB=""
		_CC=""
		_IBAN=""
		_PIVA=""
	ENDIF

	IF "170000"=SUBSTR(RIGA,2,6)
		_IBAN=SUBSTR(RIGA,11,27)
		_COD_NAZIONE=SUBSTR(_IBAN,1,2)
		_CHK_DIGIT=SUBSTR(_IBAN,3,2)
		_CIN=SUBSTR(_IBAN,5,1)
		_ABI=SUBSTR(_IBAN,6,5)
		_CAB=SUBSTR(_IBAN,11,5)
		_CC=SUBSTR(_IBAN,16,12)
	ENDIF
	
	IF "300000"=SUBSTR(RIGA,2,6)
	
		_PIVA=ALLTRIM(SUBSTR(RIGA,101,16))
		
		cSql="SELECT * FROM U_FOR_AN WHERE FOR_PARIVA='"+_PIVA+"' OR FOR_CODFIS='"+_PIVA+"'  OR FOR_IVACEE='"+_PIVA+"'"
	   	IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
		
		SELECT _TEMP

		IF RECCOUNT()=0
			MESSAGEBOX("NON TROVATO FORNITORE CON COD.FIS/P.IVA= "+_PIVA,48,"ATTENZIONE")
			SELECT INPUT_FILE
			SKIP
			LOOP
		ENDIF
		
		_CODFOR=ALLTRIM(FOR_CODCLI)

		SELECT IBAN_FOR 
		SET ORDER TO CODFOR 
		SEEK _CODFOR
		
		IF FOUND()
			IF _DATA_AGG >DATA_AGG 
				REPLACE DATA_AGG WITH _DATA_AGG 
				REPLACE IBAN WITH _IBAN
				REPLACE COD_NAZIONE WITH _COD_NAZIONE 
				REPLACE CHK_DIGIT WITH _CHK_DIGIT
				REPLACE CIN WITH _CIN
				REPLACE ABI WITH _ABI
				REPLACE CAB WITH _CAB
				REPLACE CC WITH _CC
				REPLACE CC WITH _CC
			ENDIF
		ELSE
			APPEND BLANK
			REPLACE CODFOR WITH _CODFOR			
			REPLACE PIVA WITH _PIVA			
			REPLACE DATA_AGG WITH _DATA_AGG 
			REPLACE IBAN WITH _IBAN
			REPLACE COD_NAZIONE WITH _COD_NAZIONE 
			REPLACE CHK_DIGIT WITH _CHK_DIGIT
			REPLACE CIN WITH _CIN
			REPLACE ABI WITH _ABI
			REPLACE CAB WITH _CAB
			REPLACE CC WITH _CC
			REPLACE CC WITH _CC		
		ENDIF
		
	ENDIF

	SELECT INPUT_FILE
	SKIP
ENDDO



*********************************************************************************
PROCEDURE CONTROLLO_BANCHE_FORNITORE
*********************************************************************************

*** conferma utente

RIT = MESSAGEBOX("Procedo con il controllo "+CHR(13)+"codici banche fornitore	 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


IF !ExecCommand("select * from U_FOR_AN where 1=0","cB_U_FOR_AN")
   return
ENDIF

__CONTA = 0

x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
local_codabi = ''
x_codabi = "for_ba2abi <> '" + ALLTRIM(local_codabi) + "'"
local_codcab = ''
x_codcab = "for_ba2cab <> '" + ALLTRIM(local_codcab) + "'"

x_cond = x_soci + " and " + x_codabi + " and " + x_codcab 
Csql   = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"
IF !ExecCommand(cSql,"U_FOR_AN")
   return(.f.)
ENDIF
SELECT U_FOR_AN
GO TOP
IF !EOF()

	DO WHILE .NOT.EOF()

		SCATTER MEMVAR MEMO

		IF !EMPTY(m.for_ba2abi) 
			IF !EMPTY(M.for_ba2cab)
		    	M.for_ba2 = ALLTRIM(M.for_ba2abi)+ALLTRIM(M.for_ba2cab)
		    	
				REPLACE for_ba2 WITH M.for_ba2								&& CONTROAGGIORNA IL CODICE BANCA
				
				SCATTER MEMVAR MEMO
				
				_BANCA_CLIENTE_ESISTENTE = .F.
				=CERCA_BANCA(M.for_ba2)
				IF 	!_BANCA_CLIENTE_ESISTENTE
					WAIT WINDOWS " ?????????? BANCA FORNITORE INESISTENTE SU U_BAN_AN"+ M.for_ba2 NOWAIT
					SELECT cB_U_FOR_AN
					APPEND BLANK
					GATHER MEMVAR MEMO
					__CONTA = __CONTA +1
				ENDIF
			ENDIF
		ENDIF
		
    
		SELECT U_FOR_AN
		SKIP +1
	ENDDO

	IF !ExecRW('','U_FOR_AN','I','','U_FOR_AN')
	  return(.f.)
	ENDIF
		
ENDIF 

WAIT WINDOWS "CODICI BANCA ERRATI : "+STR(__CONTA,7,0)

_TIPOLOGIA_DI_STAMPA = "Tutti i clienti"

SELECT cB_U_FOR_AN
GO TOP

IF !EOF()   
   DO PRG\MENUSTA WITH "cB_U_FOR_AN",.T.,.T.,"XXX","FORBANKO","FORBANKO.FRX"
ENDIF



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 