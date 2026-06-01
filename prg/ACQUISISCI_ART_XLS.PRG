
*** PROCEDURA DI ACQUISIZIONE ARTICOLI DI ACQUISTO DA FILE EXCEL CON CARICAMENTO SIMULTANEO GIACENZA DI MAGAZZINO

PUB_PJPWD=.F.
PUB_MESS="Manutenzione archivi Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 

IF !PUB_PJPWD
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN .F.
ENDIF


_V_NOMEXLS = GETFILE("Foglio di lavoro Microsoft Excel:XLS","File:","Apri",0,"Selezionare il file Excel da importare")


*** CONTROLLO I DATI INSERITI DALL'UTENTE
IF EMPTY(ALLTRIM(_V_NOMEXLS))
	MESSAGEBOX("File da importare obbligatorio",16,"Attenzione")
	RETURN .F.
ENDIF

IF FILE(ALLTRIM(_V_NOMEXLS))
ELSE
	MESSAGEBOX("File non trovato",16,"Attenzione")
	RETURN .F.
ENDIF

IF UPPER(RIGHT(_V_NOMEXLS,4)) = ".XLS"
ELSE
	MESSAGEBOX("File non valido" + CHR(13) + CHR(13) + ;
				  "Selezionare esclusivamente un file con formato excel '97/2003",16,"Attenzione")
	RETURN .F.
ENDIF

gnErrFile = FOPEN(_V_NOMEXLS,12)
IF gnErrFile < 0  && Check for error opening file
	MESSAGEBOX("File già aperto da un altro programma." + CHR(13) + CHR(13) + ;
				  "Chiudere il file prima di eseguire l'Utility",16,"Attenzione")
	RETURN .F.
ENDIF
=FCLOSE(gnErrFile)

_V_RISP = MESSAGEBOX("Confermare l'acquisizione articoli di acquisto materiale elettrico con caricamento simultaneo giacenza di magazzino dal file:" + CHR(13) + CHR(13) + ALLTRIM(_V_NOMEXLS) + " ?",33,"Attenzione")
IF _V_RISP = 1
ELSE
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.		
ENDIF

_COMMAND = "IMPORT FROM '" + _V_NOMEXLS + "' TYPE XL5"
&_COMMAND
_cTabSource = ALLTRIM(ALIAS())

IF USED("CU_BFO_DD")
	SELECT CU_BFO_DD
	USE
ENDIF
IF !ExecCommand("select * from u_bfo_dd where 0=1","CU_BFO_DD")
   return(.f.)
ENDIF
SELECT CU_BFO_DD
INDEX ON ORD_SEQUEN TAG SEQUEN ADDITIVE

CREATE CURSOR CU_ERRORI (DES_ARTICOLO C(80), ERRORE C(254))

_V_ERRORI = 0

SELECT &_cTabSource
GO TOP
IF EOF()
	MESSAGEBOX("Nessuna riga da importare",16,"Attenzione")
	RETURN .F.
ENDIF

SELECT CU_ERRORI
ZAP

WAIT WINDOWS "Verifica in corso..." NOWAIT

SELECT &_cTabSource
GO TOP
SKIP +1  && INTESTAZIONI
DO WHILE !EOF()

	SCATTER MEMVAR
	
	_DESCR = UPPER(ALLTRIM(M.C)) + ;
		IIF(!EMPTY(M.D)," " + UPPER(ALLTRIM(M.D)),"") + ;
		IIF(!EMPTY(M.E)," " + UPPER(ALLTRIM(M.E)),"") + ;
		IIF(!EMPTY(M.F)," " + UPPER(ALLTRIM(M.F)),"")
	_DESCR = APITOSPA(_DESCR)
	_DESCR = STRTRAN(_DESCR,SPACE(4),SPACE(1))
	_DESCR = STRTRAN(_DESCR,SPACE(3),SPACE(1))
	_DESCR = STRTRAN(_DESCR,SPACE(2),SPACE(1))
	
	IF EMPTY(M.C)  && DESCRIZIONE ARTICOLO
		SELECT CU_ERRORI
		APPEND BLANK
		REPLACE DES_ARTICOLO WITH _DESCR
		REPLACE ERRORE WITH "Descrizione articolo non inserita"
		_V_ERRORI = _V_ERRORI + 1
	ENDIF
	
	IF EMPTY(M.A)  && QUANTITA' RILEVATA
		SELECT CU_ERRORI
		APPEND BLANK
		REPLACE DES_ARTICOLO WITH _DESCR
		REPLACE ERRORE WITH "Quantità non inserita"
		_V_ERRORI = _V_ERRORI + 1
	ENDIF
	
	IF EMPTY(M.I)  && CATEGORIA MERCEOLOGICA
		SELECT CU_ERRORI
		APPEND BLANK
		REPLACE DES_ARTICOLO WITH _DESCR
		REPLACE ERRORE WITH "Categoria merceologica non inserita"
		_V_ERRORI = _V_ERRORI + 1
	ENDIF
			
*!*		*** VERIFICA ESISTENZA PARAMETRO CATEGORIA MERCEOLOGICA
*!*		x_codi = "codice like 'MER%'"
*!*		x_desc = "descri = '" + ALLTRIM(M.I) + "'"
*!*		x_cond = x_codi + " and " + x_desc
*!*		cSql = "Select * from PARA where " + x_cond
*!*		IF !ExecCommand(cSql,"CU_PARA")
*!*			return(.f.)
*!*		ENDIF
*!*		SELECT CU_PARA
*!*		GO TOP
*!*		IF EOF()
*!*			SELECT CU_ERRORI
*!*			APPEND BLANK
*!*			REPLACE DES_ARTICOLO WITH _DESCR
*!*			REPLACE ERRORE WITH "Descrizione categoria merceologica '" + ALLTRIM(M.I) + "' inesistente in Aquarius"
*!*			_V_ERRORI = _V_ERRORI + 1
*!*		ENDIF
	
	SELECT &_cTabSource
	SKIP +1
ENDDO

WAIT CLEAR

IF _V_ERRORI > 0
	_V_RISP = MESSAGEBOX("Sono stati rilevati articoli con informazioni erronee." + CHR(13) + ;
				"Visualizzare una lista dettagliata?",52,"Attenzione")	
	SELECT CU_ERRORI
	GO TOP
	IF !EOF()
		DO prg\browseview WITH "CU_ERRORI","Errori rilevati in file excel" , ;
			"DES_ARTICOLO:Descrizione articolo,W:35;ERRORE:Tipo errore,W:100;",600,800
	ENDIF
	
	_RISP = MESSAGEBOX("Continuare ugualmente l'acquisizione ignorando gli errori rilevati?",32+4+256,"Attenzione")
	IF _RISP = 6
	ELSE
		MESSAGEBOX("Operazione abbandonata",64,"Informazione")
		RETURN .F.
	ENDIF
ENDIF

*** SCELTA DATA REGISTRAZIONE MOVIMENTI/GIACENZE INVENTARIALI
_V_DTREGI = DTOC(DATE())
_V_DTREGI = PJ_INPUTBOX("Inserire la Data Registrazione","Data Registrazione Movimenti con cui verranno generati movimenti e giacenze inventariali",_V_DTREGI)
IF EMPTY(ALLTRIM(_V_DTREGI))
	MESSAGEBOX("Data Registrazione obbligatoria",16,"Attenzione")
	RETURN .F.
ENDIF
IF EMPTY(_V_DTREGI) .OR. _V_DTREGI = '  /  /    '
	MESSAGEBOX("Data Registrazione Movimenti obbligatoria",16,"Attenzione")
	_V_DTREGI = ""
	RETURN .T.
ENDIF
IF VALID_DATA(_V_DTREGI)
ELSE
	MESSAGEBOX("Data Registrazione Movimenti non valida",16,"Attenzione")
	RETURN .F.
ENDIF
_V_DTREGI = OK_DATA(_V_DTREGI)

_V_INSERT = 0
_V_GIACEN = 0

SELECT &_cTabSource
GO TOP
SKIP +1  && INTESTAZIONI
DO WHILE !EOF()

	SCATTER MEMVAR
	
	IF EMPTY(M.C)  && DESCRIZIONE ARTICOLO
		SELECT &_cTabSource
		SKIP +1
	ENDIF
	
	_DESCR = UPPER(ALLTRIM(M.C)) + ;
		IIF(!EMPTY(M.D)," " + UPPER(ALLTRIM(M.D)),"") + ;
		IIF(!EMPTY(M.E)," " + UPPER(ALLTRIM(M.E)),"") + ;
		IIF(!EMPTY(M.F)," " + UPPER(ALLTRIM(M.F)),"")
	_DESCR = APITOSPA(_DESCR)
	_DESCR = STRTRAN(_DESCR,SPACE(4),SPACE(1))
	_DESCR = STRTRAN(_DESCR,SPACE(3),SPACE(1))
	_DESCR = STRTRAN(_DESCR,SPACE(2),SPACE(1))
	
	WAIT WINDOWS "Elaborazione articolo " + _DESCR + " in corso..." NOWAIT
	
	*** VERIFICA ESISTENZA ARTICOLO PER DESCRIZIONE
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_desc = "art_descr = '" + ALLTRIM(_DESCR) + "'"
	x_cond = x_soci + " and " + x_desc
	cSql = "Select * from U_ART_PR where " + x_cond
	IF !ExecCommand(cSql,"CX_ART_PR")
		return(.f.)
	ENDIF
	SELECT CX_ART_PR
	GO TOP
	IF EOF()
		SCATTER MEMVAR MEMO BLANK
		_X_FAMIGLIA = "02"
		_X_TIPO = "001"
		_X_PROGRE = ""
		x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		x_cod1 = "SUBSTRING(ART_CODPRI,1,2) = '" + _X_FAMIGLIA + "'"
		x_cod2 = "SUBSTRING(ART_CODPRI,4,3) = '" + _X_TIPO + "'"
		x_cond = x_soci + " and " + x_cod1 + " and " + x_cod2
		cSql = "select SUBSTRING(ART_CODPRI,8,4) AS CODES from u_art_pr where " + x_cond + " order by art_codpri DESC"
		IF !ExecCommand(cSql,"CUR_ARTICOLI")
			RETURN .F.
		ENDIF
		SELECT CUR_ARTICOLI
		GO TOP
		IF EOF()
			_X_PROGRE = "0001"
		ELSE
			SELECT MAX(VAL(CODES)) AS N_MAXCODE FROM CUR_ARTICOLI INTO CURSOR CX_MAXCODE
			SELECT CX_MAXCODE
			GO TOP
			IF !ISNULL(N_MAXCODE)
				_nLastCode = N_MAXCODE
				IF _nLastCode > 0
					IF _nLastCode + 1 > 9999
						MESSAGEBOX("Raggiunto limite progessivo per questa Famiglia/Tipologia" + CHR(13) + CHR(13) + ;
							"Impossibile aggiungere il nuovo codice",48,"Attenzione")
						RETURN .F.
					ELSE
						_X_PROGRE = TRC(4,ALLTRIM(STR(_nLastCode + 1,4,0)))
					ENDIF
				ELSE
					_X_PROGRE = "0001"
				ENDIF
			ELSE
				_X_PROGRE = "0001"
			ENDIF
		ENDIF
		
		M.ART_CODPRI = _X_FAMIGLIA + '.' + _X_TIPO + '.' + _X_PROGRE
		IF VAL(M.B) > 0
			M.ART_PRZCOS = VAL(M.B)
		ENDIF
				
		M.ART_CODSOC = PUB_CODSOC
		M.ART_SPESSO = 0
		M.ART_ALTEZZ = 0
		M.ART_LUNGHE = 0
		M.ART_CODMAT = "001"
		M.ART_CODCAT = ""
		M.ART_DESCAT = ""
		M.ART_TIPON	 = ""
		M.ART_UNIMIS = "NR"
		M.ART_UMMAGA = "NR"
		M.ART_LINEA  = "05"
		M.ART_CODIVA = PUB_IVA
		M.ART_TIPART = "A" 
		M.ART_DISBAS = ""
		M.ART_CODCOL = "" 
		M.ART_DESCOL = ""
		M.ART_DATVAR = RIBALTA2(_V_DTREGI)
		M.ART_DATINS = RIBALTA2(_V_DTREGI)

		M.ART_CODCAT = ""
		M.ART_DESCAT = ""
		
		M.ART_MAGA   = "RIC"

		M.ART_DESCR = _DESCR
			
		*** CREO U_ART_PR
		cSql = "SELECT * FROM U_ART_PR WHERE 1=0"
		IF !ExecRW(cSql,"U_ART_PR","R")
			RETURN(.F.)
		ENDIF
		SELECT U_ART_PR
		APPEND BLANK
		REPLACE ART_CODSOC WITH M.ART_CODSOC
		REPLACE ART_SPESSO WITH M.ART_SPESSO 
		REPLACE ART_CODMAT WITH M.ART_CODMAT 
		REPLACE ART_CODCAT WITH M.ART_CODCAT 
		REPLACE ART_DESCAT WITH M.ART_DESCAT 
		REPLACE ART_UNIMIS WITH M.ART_UNIMIS 
		REPLACE ART_UMMAGA WITH M.ART_UMMAGA 
		REPLACE ART_LINEA  WITH M.ART_LINEA  
		REPLACE ART_CODIVA WITH M.ART_CODIVA 
		REPLACE ART_TIPART WITH M.ART_TIPART 
		REPLACE ART_DISBAS WITH M.ART_DISBAS 
		REPLACE ART_CODCOL WITH M.ART_CODCOL 
		REPLACE ART_DESCOL WITH M.ART_DESCOL 
		REPLACE ART_DATVAR WITH M.ART_DATVAR
		REPLACE ART_DATINS WITH M.ART_DATINS
		REPLACE ART_ALTEZZ WITH M.ART_ALTEZZ
		REPLACE ART_LUNGHE WITH M.ART_LUNGHE
		REPLACE ART_MAGA   WITH M.ART_MAGA  
		REPLACE ART_CODPRI WITH M.ART_CODPRI 
		REPLACE ART_DESCR  WITH M.ART_DESCR
		
		SCATTER MEMVAR MEMO
		
		IF !ExecRW(cSql,"U_ART_PR","W")
			RETURN(.F.)
		ENDIF		

		*** CREO U_ART_AN
		cSql = "SELECT * FROM U_ART_AN  WHERE 1=0"
		IF !ExecRW(cSql,"U_ART_AN","R")
			RETURN(.F.)
		ENDIF
		SELECT U_ART_AN
		APPEND BLANK
		REPLACE ART_CODSOC WITH M.ART_CODSOC
		REPLACE ART_CODPRI WITH M.ART_CODPRI
		IF !ExecRW(cSql,"U_ART_AN","W")
			RETURN(.F.)
		ENDIF
		
		_V_INSERT = _V_INSERT + 1
		
		SELECT CU_BFO_DD
		SET ORDER TO
		ZAP
		
		IF VAL(M.A) > 0
			_D_CODMAG = "RIC"
			_D_DESMAG = ""
			x_cond = "codice = 'MAG" + ALLTRIM(_D_CODMAG) + "'"
			cSql   = "select * from para where " + x_cond
			IF !ExecCommand(cSql,'PARA')
			   return(.f.)
			ENDIF
			SELECT PARA
			GO TOP
			IF EOF()
			   _D_DESMAG = ""
			ELSE
			   _D_DESMAG = DESCRI
			ENDIF

			*PUB_TIPOBOB = "TAG"

			SELECT CU_BFO_DD
			SET ORDER TO
			ZAP
			
			SELECT CU_BFO_DD
			APPEND BLANK
			REPLACE DAGGANCIO  WITH '1111111111'
			REPLACE ORD_CODART WITH M.ART_CODPRI
			REPLACE ORD_NUMBOB WITH 0
			REPLACE ORD_UM     WITH M.ART_UMMAGA
			REPLACE ORD_IVA    WITH ""
			REPLACE ORD_DESART WITH M.ART_DESCR
			REPLACE ORD_MAGA   WITH _D_CODMAG			
			REPLACE ORD_QTAORD WITH VAL(M.A)
			REPLACE ORD_PRZNET WITH M.ART_PRZCOS
			REPLACE ORD_SC1    WITH 0
			REPLACE ORD_SC2    WITH 0
			REPLACE ORD_SC3    WITH 0
			REPLACE ORD_DATCON WITH RIBALTA2(_V_DTREGI)
			REPLACE ORD_CODSYS WITH SYS(2015)
			REPLACE ORS_CODCLI WITH PUB_CLISOC
			REPLACE ORS_RAGSOC WITH PUB_RAGSOC  
			*REPLACE ORS_NUMORD WITH _V_NUMPRG
			REPLACE ORS_NUMORD WITH "INV-MAT-ELETTR"
			REPLACE ORS_DATORD WITH RIBALTA2(_V_DTREGI)
			REPLACE ORS_VALUTA WITH PUB_VALU
			REPLACE ORD_SEQUEN WITH 0
			REPLACE ORD_LEGAME WITH '1111111111'
			REPLACE ORD_LEGSYS WITH SYS(2015)
			REPLACE ORD_FLGMOD WITH 'I'
			REPLACE ORS_NUMIDE WITH ""
			REPLACE ORS_ANNO   WITH SUBSTR(RIBALTA2(_V_DTREGI),1,4)
			REPLACE ORD_LEGASY WITH SYS(2015)
			REPLACE ORD_SALCON WITH 'S'
			REPLACE ORD_DTASCA WITH RIBALTA2(_V_DTREGI)
			REPLACE ORD_QTAML  WITH 0
			REPLACE ORD_QTAMQ  WITH 0
			REPLACE ORD_QTAKG  WITH 0
			REPLACE ORD_QTAMC  WITH 0 
			REPLACE ORD_QTAML1 WITH 0
			REPLACE ORD_QTAMQ1 WITH 0
			REPLACE ORD_QTAKG1 WITH 0
			REPLACE ORD_ALTEZZ WITH M.ART_ALTEZZ
			REPLACE ORD_LUNGHE WITH M.ART_LUNGHE
			REPLACE ORD_SPESSO WITH M.ART_SPESSO
			REPLACE ORD_CODMAT WITH M.ART_CODMAT 
			REPLACE ORD_CODCOL WITH "" 
			REPLACE ORD_DESMAT WITH ""
			REPLACE ORD_FILA_X WITH "" 
			REPLACE ORD_PIAN_X WITH ""
			REPLACE ORD_UBIC_X WITH ""
			REPLACE ORD_FILA_N WITH 0
			REPLACE ORD_PIAN_N WITH 0
			REPLACE ORD_UBIC_N WITH 0
			REPLACE ORD_SYSMAG WITH SYS(2015)
			*REPLACE ORD_TIPBOB WITH PUB_TIPOBOB
			REPLACE ORD_QUAPRO WITH ""
			REPLACE ORD_CLIENT WITH ""

			SCATTER MEMVAR MEMO

			M.ORD_CAUS = "RM+"
			M.ORD_NUMORD = M.ORS_NUMORD
			M.ORD_DATORD = M.ORS_DATORD
			M.ORD_CODCLI = M.ORS_CODCLI
			M.ORD_RAGSOC = M.ORS_RAGSOC
			M.ORD_CODACQ = M.ORS_CODACQ
			M.ORD_VALUTA = M.ORS_VALUTA
			M.ORD_NUMIDE = AQM_NEW_NUMIDE()
			M.ORD_CODBUN = ""

			SELECT CU_BFO_DD
			GO TOP
			
			XXY_CODINT = ""
			XXY_NRLINT = 0
			XXY_UNIQUE = ""
			=AQM_GESTIONE_CARICHI_BFO()
			*_W_CODINT = XXY_CODINT
			*_W_MAG_UNIQUE = XXY_UNIQUE 
			
			_V_GIACEN = _V_GIACEN + 1	
		ENDIF
	ENDIF

	SELECT &_cTabSource
	SKIP +1
ENDDO

SELECT &_cTabSource
USE

WAIT CLEAR

IF _V_INSERT > 0 OR _V_GIACEN > 0
MESSAGEBOX("Operazione effettuata:" + CHR(13) + ;
	CHR(13) + "   Totale nuovi articoli inseriti: " + ALLTRIM(STR(_V_INSERT)) + ;
	CHR(13) + "   Totale giacenze rilevate: " + ALLTRIM(STR(_V_GIACEN)),64,"Informazione")
ELSE
	MESSAGEBOX("Nessuna operazione effettuata",64,"Attenzione")
ENDIF

RETURN .T.
