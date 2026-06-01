*************************************************************************************************
*							CONVERSIONE CARTE ANAGRAFICA ARTICOLI								*
*							 																	*
*	Febbraio 2012 : Xilopan 				 													*
*************************************************************************************************

_dir_file_da_convertire = SYS(5) + SYS(2003) + "\file_da_convertire\xilopan\anagrafica articoli"
IF DIRECTORY(_dir_file_da_convertire)
	_cSetPath = "SET DEFAULT TO '" + SYS(5) + SYS(2003) + "\file_da_convertire\xilopan\anagrafica articoli'"
	&_cSetPath 
ENDIF

*** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0
gcFile = GETFILE('XLS', '', 'Seleziona', 0, 'Seleziona il file da importare')

SET DEFAULT TO &PUB_DIR  

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

gnErrFile = FOPEN(gcFile,12)
IF gnErrFile < 0  && Check for error opening file
   MESSAGEBOX("File già aperto da un altro programma." + CHR(13) + CHR(13) + ;
              "Chiudere il file prima di proseguire",16,"Attenzione")
   RETURN .F.
ENDIF
=FCLOSE(gnErrFile)

RIT = MESSAGEBOX("Procedo con la conversione delle carte per l'anagrafica ARTICOLI XILOPAN in formato EXCEL?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

_COMMAND = "IMPORT FROM '" + gcFile + "' TYPE XLS"
&_COMMAND
_cTabSource = ALLTRIM(ALIAS())

IF !ExecCommand("select * from U_ART_PR where 1=0","TMP_ART_PR")
   return
ENDIF

IF !ExecCommand("select * from U_ART_AN where 1=0","TMP_ART_AN")
   return
ENDIF

_CONTAIMPORT = 0

*** INSERIMENTO ARTICOLI IN ANAGRAFICA
SELECT &_cTabSource
DELETE FOR EMPTY(A)
GO TOP
DO WHILE !EOF()
	IF DELETED()
		SKIP +1
		LOOP
	ENDIF
	
	WAIT WINDOWS "Elaborazione record " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " ..." NOWAIT
	
	IF EMPTY(A)
		SKIP +1
		LOOP
	ENDIF
	IF ALLTRIM(A) == "Codifica Carte"
		SKIP +1
		LOOP
	ENDIF
	IF ALLTRIM(A) == "Cod."
		SKIP +1
		LOOP
	ENDIF
	
	SCATTER MEMVAR
	
	SELECT TMP_ART_PR
	SCATTER MEMVAR MEMO BLANK
	
	SELECT TMP_ART_AN
	SCATTER MEMVAR MEMO BLANK

	M.ART_CODSOC = PUB_CODSOC
	M.ART_CODPRI = ALLTRIM(M.J)
	M.ART_DESCR  = UPPER(ALLTRIM(M.F) + ' ' + ALLTRIM(M.G) + 'x' + ALLTRIM(M.H) + ' - ' + ALLTRIM(M.A))
	M.ART_DESEST = ""
	M.ART_PRZCOS = VAL(ALLTRIM(M.M))
	M.ART_SCORMI = VAL(ALLTRIM(M.O))
	M.ART_SPESSO = 0
	
	M.ART_NOTE = "Tipo: " + ALLTRIM(M.L)
	
	_cFORNITORI = ALLTRIM(M.D)
	_nCONTA_FORN = 0
	DO WHILE OCCURS('/',_cFORNITORI) + 1 > 0 AND !EMPTY(_cFORNITORI)
		_cFORNITORE_I_ESIMO = ""
		_nCONTA_FORN = _nCONTA_FORN + 1
		IF OCCURS('/',_cFORNITORI) > 0
			_cFORNITORE_I_ESIMO = SUBSTR(_cFORNITORI,1,AT('/',_cFORNITORI)-1)
			_cFORNITORI = SUBSTR(_cFORNITORI,AT('/',_cFORNITORI)+1)
		ELSE
			_cFORNITORE_I_ESIMO = ALLTRIM(_cFORNITORI)
			_cFORNITORI = ""
		ENDIF
		IF !EMPTY(_cFORNITORE_I_ESIMO)
			_cFORNITORE_I_ESIMO = TRC(PUB_LCL,_cFORNITORE_I_ESIMO)
			_cNomeCampoFornitoreIesimo = "M.ART_CODF" + ALLTRIM(STR(_nCONTA_FORN,1,0))
			_cNomeCampoPrezzoIesimo = "M.ART_PRZCO" + ALLTRIM(STR(_nCONTA_FORN,1,0))
			_cNomeCampoArtFornIesimo = "M.ART_NOTA" + ALLTRIM(STR(_nCONTA_FORN,1,0))
			&_cNomeCampoFornitoreIesimo = _cFORNITORE_I_ESIMO
			&_cNomeCampoPrezzoIesimo = 0
			&_cNomeCampoArtFornIesimo = UPPER(ALLTRIM(M.E))
			DO CASE
				CASE _nCONTA_FORN = 1
					&_cNomeCampoPrezzoIesimo = VAL(ALLTRIM(M.M))
				CASE _nCONTA_FORN = 2
					&_cNomeCampoPrezzoIesimo = VAL(ALLTRIM(M.N))
			ENDCASE
		ENDIF
	ENDDO
	
	IF SUBSTR(M.ART_CODPRI,8,1) == 'G'	&& CARTE GREZZE
		M.ART_UNIMIS = 'KG'
		M.ART_UMMAGA = 'KG'
		M.ART_CODMAT = "010"
		M.ART_CODCAT = 'CG'
		M.ART_DESCAT = 'CARTA GREZZA'
		M.ART_ALTEZZ = VAL(ALLTRIM(M.H))
		M.ART_LUNGHE = 0
	ELSE								&& CARTE IMPREGNATE
		M.ART_UNIMIS = 'MQ'
		M.ART_UMMAGA = 'NR'
		M.ART_CODMAT = "011"
		M.ART_CODCAT = 'CI'
		M.ART_DESCAT = 'CARTA IMPREGNATA'
		M.ART_ALTEZZ = VAL(ALLTRIM(M.G))
		M.ART_LUNGHE = VAL(ALLTRIM(M.H))
	ENDIF
	M.ART_LINEA  = PUB_LINEA
	M.ART_CODIVA = PUB_IVA
	M.ART_MAGA   = PUB_CODM
	M.ART_CGE    = '6010101'
	M.ART_DATINS = RIBALTA2(DTOC(DATE()))
	M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
	M.ART_CODVAL = PUB_VALU
	M.ART_TIPART = 'A'
	M.ART_DISBAS = 'S'
	M.ART_RIPCOM = 'S'
	
	M.ART_DESMAT = ""
	x_cond = "codice = 'MAT" + M.ART_CODMAT + "'"
	cSql = "select * from PARA where " + x_cond
	IF !ExecCommand(cSql,"CX_PARA")
		RETURN .F.
	ENDIF
	SELECT CX_PARA
	GO TOP
	IF !EOF()
		M.ART_DESMAT = ALLTRIM(DESCRI)
	ENDIF
	
	M.ART_CODCOL = ALLTRIM(M.A)
	M.ART_DESCOL = ""
	x_cond = "codice = 'COL" + M.ART_CODCOL + "'"
	cSql = "select * from PARA where " + x_cond
	IF !ExecCommand(cSql,"CX_PARA")
		RETURN .F.
	ENDIF
	SELECT CX_PARA
	GO TOP
	IF EOF()
		*** INSERIMENTO NUOVO PARAMETRO COLORE
		cSql = "select * from PARA where " + x_cond
		IF !ExecRW(cSql,"PARA","R")
			RETURN .F.
		ENDIF
		SELECT PARA
		APPEND BLANK
		REPLACE CODICE WITH "COL" + M.ART_CODCOL
		REPLACE DESCRI WITH UPPER(ALLTRIM(M.ART_CODCOL))  && ############################  DESCRIZIONE COLORE NON CONTENUTA NEL FILE
		REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
		IF !ExecRW(cSql,"PARA","W")
			RETURN .F.
		ENDIF
	ELSE
		M.ART_DESCOL = ALLTRIM(DESCRI)
	ENDIF
	
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"
	IF !ExecRW(cSql,"U_ART_PR","R")
		RETURN .F.
	ENDIF
	SELECT U_ART_PR
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_ART_PR
	IF !ExecRW(cSql,"U_ART_PR","W")
		RETURN .F.
	ENDIF

	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_ART_AN where " + x_cond + " order by art_codsoc,art_codpri"
	IF !ExecRW(cSql,"U_ART_AN","R")
		RETURN .F.
	ENDIF
	SELECT U_ART_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_ART_AN
	IF !ExecRW(cSql,"U_ART_AN","W")
		RETURN .F.
	ENDIF
	
	_CONTAIMPORT = _CONTAIMPORT + 1
	
	SELECT &_cTabSource
	SKIP +1
ENDDO


WAIT WINDOWS "Ricerca Articoli per creazione automatica Distinta base..." NOWAIT

*** INSERIMENTO DISTINTE BASE PER CARTE IMPREGNATE
_CONTADIBA = 0
x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_cmat = "ART_CODMAT = '011'"
x_ccat = "ART_CODCAT = 'CI'"
x_tipo = "ART_TIPART = 'A'"
x_cond = x_soci + " and " + x_cmat + " and " + x_ccat + " and " + x_tipo 
cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"CX_ART_PR")
	RETURN .F.
ENDIF
SELECT CX_ART_PR
GO TOP
DO WHILE !EOF()
	IF DELETED()
		SKIP +1
		LOOP
	ENDIF
	
	WAIT WINDOWS "Distinte base - elaborazione record " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " ..." NOWAIT
	
	SCATTER MEMVAR
	
	*** POSIZIONEMANENTO SU COMPONENTE (carta grezza) DA FILE SORGENTE
	_X_CODICE_COMPONENTE = ""
	_X_GRAMMATURA_COMPONENTE = 1
	SELECT &_cTabSource
	GO TOP
	SCAN
		
		IF SUBSTR(J,8,1) == 'G'  && CARTE GREZZE
		ELSE
			LOOP
		ENDIF
		IF ALLTRIM(A) == ALLTRIM(M.ART_CODCOL)  && STESSO COLORE
		ELSE
			LOOP
		ENDIF
		IF (VAL(H) + 10) = M.ART_LUNGHE  && ALTEZZA BOBINA COMPATIBILE
		ELSE
			LOOP
		ENDIF
		
		_X_CODICE_COMPONENTE = ALLTRIM(J)
		IF !EMPTY(P)
			_X_GRAMMATURA_COMPONENTE = VAL(P) / 1000
		ENDIF
		
		EXIT
		
	ENDSCAN
	
	IF EMPTY(_X_CODICE_COMPONENTE)
		*MESSAGEBOX("Componente per gruppo " + ALLTRIM(M.ART_CODPRI) + " non trovata in file sorgente",16,"Attenzione")
		SELECT CX_ART_PR
		SKIP +1
		LOOP
	ENDIF
	
	*** CANCELLAZIONE EVENTUALE DISTINTA BASE PREESISTENTE
	x_codi = "DIT_GRUPPO = '" + M.ART_CODPRI + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM U_DIS_TT WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_DIS_TT")
	   return(.f.)
	ENDIF
	SELECT CX_DIS_TT
	GO TOP
	IF !EOF()
		_Y_DB_AGGA = TAGGANCIO
		x_codi = "TAGGANCIO = '" + _Y_DB_AGGA + "'"
		x_cond = x_codi
		cSql = "DELETE FROM U_DIS_TT WHERE " + x_cond
		IF !ExecCommand(cSql,"DEL_DIS_TT")
		   return(.f.)
		ENDIF
		x_codi = "DAGGANCIO = '" + _Y_DB_AGGA + "'"
		x_cond = x_codi
		cSql = "DELETE FROM U_DIS_DD WHERE " + x_cond
		IF !ExecCommand(cSql,"DEL_DIS_DD")
		   return(.f.)
		ENDIF
	ENDIF
	
	cSql = "SELECT * FROM U_DIS_TT WHERE 1=0"
	IF !ExecCommand(cSql,"CU_DIS_TT")
	   return(.f.)
	ENDIF
	SELECT CU_DIS_TT
	APPEND BLANK
	SCATTER MEMVAR MEMO
	M.TAGGANCIO=STR(NEWPROG('NUMDIS'),10)
	X_TAGG = M.TAGGANCIO
	M.DIT_SYSTT	= SYS(2015)
	M.DIT_CODSOC = PUB_CODSOC
	M.DIT_GRUPPO = M.ART_CODPRI
	X_GRUP = M.DIT_GRUPPO
	M.DIT_MAGA = M.ART_MAGA	
	M.DIT_DESCRI = M.ART_DESCR
	M.DIT_UM = M.ART_UNIMIS
	M.DIT_PREZZO = M.ART_PRZVEN
	M.DIT_COSTO = M.ART_PRZCOS
	M.DIT_CODIVA = M.ART_CODIVA
	M.DIT_LINEA = M.ART_LINEA
	M.DIT_TIPOPR = M.ART_TIPOPR 
	M.DIT_ORELAV = "00:00:00"
	M.DIT_OREATT = "00:00:00"
	M.DIT_OREIMP = "00:00:00"
	SELECT CU_DIS_TT
	DO U_DIS_TT
	
	cSql = "SELECT * FROM U_DIS_DD WHERE 1=0"
	IF !ExecCommand(cSql,"CU_DIS_DD")
	   return(.f.)
	ENDIF
	SELECT CU_DIS_DD
	APPEND BLANK
	SCATTER MEMVAR MEMO
	M.DIS_CODART = _X_CODICE_COMPONENTE
	M.DAGGANCIO = X_TAGG
	M.DIS_SYSDD	= SYS(2015) 
	M.DIS_SEQUEN = 10
	M.DIS_GRUPPO = X_GRUP
	M.DIS_PERC = 100
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "ART_CODPRI = '" + M.DIS_CODART + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"
	IF !ExecCommand(cSql,"CUR_ARTICOLO")
		RETURN .F.
	ENDIF
	SELECT CUR_ARTICOLO
	GO TOP
	IF EOF()
		MESSAGEBOX("Articolo " + ALLTRIM(M.DIS_CODART) + " non trovato in anagrafica",16,"Attenzione")
		SELECT CX_ART_PR
		SKIP +1
		LOOP
	ENDIF
	M.DIS_CODART = ART_CODPRI
	M.DIS_QTA = _X_GRAMMATURA_COMPONENTE
	M.DIS_MAGA	 = ART_MAGA 
	M.DIS_DESCRI = ART_DESCR
	M.DIS_UM	 = ART_UNIMIS
	M.DIS_PREZZO = ART_PRZVEN
	M.DIS_COSTO	 = ART_PRZCOS
	M.DIS_TIPOPR = ART_TIPOPR
	M.DIS_COSLAI = ART_COSLAI
	M.DIS_COSLAE = ART_COSLAE	
	M.DIS_COSMAT = ART_COSMAT	
	M.DIS_COSATR = ART_COSATR	
	M.DIS_RICLAI = ART_RICLAI	
	M.DIS_RICLAE = ART_RICLAE	
	M.DIS_RICMAT = ART_RICMAT	
	M.DIS_RICATR = ART_RICATR
	M.DIS_ORELAV = ART_ORELAV	
	M.DIS_OREATT = ART_OREATT	
	M.DIS_OREIMP = ART_OREIMP	
	M.DIS_SECIMP = ART_SECIMP	
	M.DIS_SECLAV = ART_SECLAV	
	M.DIS_SECATT = ART_SECATT	
	M.DIS_ORELAV = "00:00:00"
	M.DIS_OREATT = "00:00:00"
	M.DIS_OREIMP = "00:00:00"
	M.DIS_SECIMP = 0 
	M.DIS_SECLAV = 0 
	M.DIS_SECATT = 0 
	M.DIS_DSNOCQ = M.DIS_DESCRI
	M.DIS_TIPO = "A"
	SELECT CU_DIS_DD
	DO U_DIS_DD
	
	*** MEMORIZZAZIONE DISTINTA BASE SU DATABASE
	IF !ExecRW('','U_DIS_TT','I','','CU_DIS_TT')
	   return(.f.)
	ENDIF
	IF !ExecRW('','U_DIS_DD','I','','CU_DIS_DD')
	   return(.f.)
	ENDIF
	
	_CONTADIBA = _CONTADIBA + 1
	
	SELECT CX_ART_PR
	SKIP +1
ENDDO

SELECT &_cTabSource
USE

MESSAGEBOX("Acquisizione Carte in Anagrafica articoli terminata" + CHR(13) + CHR(13) + ;
	"Totale Articoli Carte importati: " + ALLTRIM(STR(_CONTAIMPORT,10,0)) + CHR(13) + ;
	"Totale Gruppi Di.Ba. creati: " + ALLTRIM(STR(_CONTADIBA,10,0)),64,"Informazione")
	 
SET DEFAULT TO &PUB_DIR

RETURN
