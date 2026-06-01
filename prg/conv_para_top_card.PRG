*************************************************************************************************
*							      CONVERSIONE CAUSALI DI MAGAZZINO								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione delle Causali di magazzino dalla tabella CARD_CAUSMAGA?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

_risp = MESSAGEBOX("Cancellare prima tutte le causali di magazzino di Aquarius?",4+32+256,"Attenzione")
IF _risp = 6
	WAIT WINDOWS "Cancellazione vecchie Causali di magazzino in corso..." NOWAIT

	cSql = "DELETE FROM PARA WHERE CODICE LIKE 'TOP%' AND SUBSTRING(LIBERA,42,1) = 'M'"
	IF !ExecCommand(cSql,"DEL_PARA_TOP")
	   return
	ENDIF
ENDIF

WAIT WINDOWS "Conversione Causali di magazzino in corso..." NOWAIT

*** AGGIORNAMENTO TABELLA DELLE CAUSALI DI MAGAZZINO
_TOT_COUNT = 0
cSql = "SELECT * FROM CARD_CAUSMAGA ORDER BY CODCAUMAG"
IF !ExecCommand(cSql,"CX_CARD_CAUSMAGA")
	RETURN .F.
ENDIF
SELECT CX_CARD_CAUSMAGA
GO TOP
SCAN

	SCATTER MEMVAR

	x_codi = "CODICE = 'TOP" + ALLTRIM(M.CODCAUMAG) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	IF !EOF()
		M.DESCAUMAG = ALLTRIM(M.DESCAUMAG) + " (SOSTITUITO CODICE '" + ALLTRIM(M.CODCAUMAG) + "')"
		M.CODCAUMAG = SUBSTR(M.CODCAUMAG,1,2) + '*'  && A PARITA' DI CAUSALE ESISTENTE (PER ESEMPIO LE CAUSALI CONTABILI) AGGIUNGO UN ASTERISCO NEL CODICE PER DIFFERENZIARLE
	ENDIF
	
	APPEND BLANK
	REPLACE CODICE WITH "TOP" + ALLTRIM(M.CODCAUMAG)
	REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	
	REPLACE DESCRI WITH ALLTRIM(M.DESCAUMAG)
	IF !ISNULL(M.CODMAGAZZ)
		IF !EMPTY(M.CODMAGAZZ)
			REPLACE NOTE WITH "Magazzino: " + ALLTRIM(M.CODMAGAZZ)
		ENDIF
	ENDIF	
	
	REPLACE DESIVA WITH ""
	
	_X_SEGNO = '+'
	IF M.MOVINVENT = '+' OR M.MOVINVENT = '-'
		_X_SEGNO = M.MOVINVENT
	ELSE
		IF M.MOVCADAAQ = '+' OR M.MOVCADAAQ = '-'
			_X_SEGNO = M.MOVCADAAQ 
		ELSE
			IF M.MOVALTRIC = '+' OR M.MOVALTRIC = '-'
				_X_SEGNO = M.MOVALTRIC 
			ELSE
				IF M.SCAPERVEN = '+' OR M.SCAPERVEN = '-'
					_X_SEGNO = M.SCAPERVEN 
				ELSE
					IF M.ALTRISCAR = '+' OR M.ALTRISCAR = '-'
						_X_SEGNO = M.ALTRISCAR
					ELSE
						IF M.ORDCLIENT = '+' OR M.ORDCLIENT = '-'
							_X_SEGNO = M.ORDCLIENT 
						ELSE
							IF M.ORDFORNIT = '+' OR M.ORDFORNIT = '-'
								_X_SEGNO = M.ORDFORNIT 
							ELSE
								IF M.IMPEGNATO = '+' OR M.IMPEGNATO = '-'
									_X_SEGNO = M.IMPEGNATO 
								ELSE
									_X_SEGNO = '-'
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	
	IF !ISNULL(M.TIPOEFFETT)
		DO CASE
			CASE M.TIPOEFFETT = 'B'
				REPLACE DESIVA WITH "Tipo effettivo: " + M.TIPOEFFETT + " (Bolla di carico)"
				_X_SEGNO = '+'
				
			CASE M.TIPOEFFETT = 'F'
				REPLACE DESIVA WITH "Tipo effettivo: " + M.TIPOEFFETT + " (Fattura)"
				_X_SEGNO = '-'
				
			CASE M.TIPOEFFETT = 'G'
				REPLACE DESIVA WITH "Tipo effettivo: " + M.TIPOEFFETT + " (Bolla di scarico)"
				_X_SEGNO = '-'
				
			CASE M.TIPOEFFETT = 'M'
				REPLACE DESIVA WITH "Tipo effettivo: " + M.TIPOEFFETT + " (Movimento magazzino)"
				
			CASE M.TIPOEFFETT = 'N'
				REPLACE DESIVA WITH "Tipo effettivo: " + M.TIPOEFFETT + " (Nota credito)"
				_X_SEGNO = '-'
				
			CASE M.TIPOEFFETT = 'O'
				REPLACE DESIVA WITH "Tipo effettivo: " + M.TIPOEFFETT + " (Ordine cliente)"
				
			CASE M.TIPOEFFETT = 'T'
				REPLACE DESIVA WITH "Tipo effettivo: " + M.TIPOEFFETT + " (Ordine fornitore)"
				
			CASE M.TIPOEFFETT = 'V'
				REPLACE DESIVA WITH "Tipo effettivo: " + M.TIPOEFFETT + " (Preventivo)"
				
		ENDCASE
	ELSE
		M.TIPOEFFETT = ""
	ENDIF
	
	IF M.STATO = 'S'
	ELSE
		REPLACE DESIVA WITH ALLTRIM(DESIVA) + IIF(!EMPTY(DESIVA),'; ','') + "Stato: N (non utilizzata)"
	ENDIF
	
	IF '+' $ UPPER(ALLTRIM(M.CODCAUMAG))
		_X_SEGNO = '+'
	ENDIF
	IF '-' $ UPPER(ALLTRIM(M.CODCAUMAG))
		_X_SEGNO = '-'
	ENDIF
	
	IF 'CARIC' $ UPPER(ALLTRIM(M.DESCAUMAG)) AND !('SCARIC' $ UPPER(ALLTRIM(M.DESCAUMAG)))
		_X_SEGNO = '+'
	ENDIF
	IF 'SCARIC' $ UPPER(ALLTRIM(M.DESCAUMAG))
		_X_SEGNO = '-'
	ENDIF
	
	IF _X_SEGNO = '+'
		M.NAT = 'C'
	ELSE
		M.NAT = 'S'
	ENDIF
	
	*** FORZATURE SEGNO
	IF UPPER(ALLTRIM(M.CODCAUMAG)) == 'PRE'
		M.NAT = 'S'
	ENDIF
	
	
	_X_FAT = 'N'
	IF !EMPTY(M.TIPOEFFETT)
		IF M.TIPOEFFETT = 'F' OR M.TIPOEFFETT = 'G'
			_X_FAT = 'V'
		ENDIF
	ENDIF
	M.FAT = _X_FAT
	
	M.BOLL				= 'N'
	M.RIC				= SPACE(1)
	M.NOTA				= SPACE(1)
	M.LIB				= SPACE(1)
	M.TOP_COL			= SPACE(3)
	M.NO_AUT			= SPACE(1)
	M.PR_NO				= SPACE(1)
	M.PR_SI				= SPACE(1)
	M.PR_TOP			= SPACE(1)
	M.PR_ANA			= SPACE(1)
	M.PR_LIS			= SPACE(1)
	M.PR_LAN			= SPACE(1)
	M.CEE				= SPACE(1)
	M.INTRA				= SPACE(1)
	M.CSC				= SPACE(1)
	M.IMPE				= SPACE(1)
	M.RFOR				= SPACE(1)
	M.RCLI				= SPACE(1)
	M.CLAV				= SPACE(1)
	M.CDEP				= SPACE(1)
	M.IL_CCO			= SPACE(1)
	M.IN_CCO			= SPACE(1)
	M.TMOV				= SPACE(2)
	M.CONCAU			= SPACE(3)
	M.TPROC				= SPACE(3)
	M.CREAPART			= SPACE(1)
	M.FASCIACOMPETENZA  = 'M'
	M.RPRO				= SPACE(1)
	M.TIPOMOV			= ""
	M.DTIPOMOV			= ""
	M.AGGANCIAPARTITARI = SPACE(1)
	M.CANT				= SPACE(1)
	m.noquadra			= SPACE(1)
	M.calcimpos			= SPACE(1)
	m.pincamulti		= SPACE(1)
	m.contrcco			= SPACE(1)
	m.sitfin			= SPACE(1)
	M.VENACQ			= SPACE(2)
	m.sitcpa			= SPACE(1)
	m.nocommessa		= SPACE(1)
	m.LIBFIS			= SPACE(1)
	M.TRATTA			= SPACE(1)
	m.noivapercassa		= SPACE(1)
	m.nomagaordcli		= SPACE(1)
	m.livmaxdibascp		= SPACE(1)
	m.numemultiaz		= SPACE(1)
	M.LIBERA = M.NAT+;
		M.FAT+;
		'      '+;
		M.BOLL+;
		M.RIC+;
		M.NOTA+;
		M.LIB+;
		M.TOP_COL+;
		M.NO_AUT+;
		M.PR_NO+;
		M.PR_SI+;
		M.PR_TOP+;
		M.PR_ANA+;
		M.PR_LIS+;
		M.PR_LAN+;
		M.CEE+;
		M.INTRA+;
		M.CSC+;
		M.IMPE+;
		M.RFOR+;
		M.RCLI+;
		M.CLAV+;
		M.CDEP+;
		M.IL_CCO+;
		M.IN_CCO+;
		M.TMOV+;
		M.CONCAU+;
		M.TPROC+;
		M.CREAPART+;
		M.FASCIACOMPETENZA+;
		M.RPRO+;
		M.AGGANCIAPARTITARI+;
		M.CANT+;
		m.noquadra+;
		M.calcimpos+;
		m.pincamulti+;
		m.contrcco+;
		m.sitfin+;
		M.VENACQ+;
		m.sitcpa+;
		m.nocommessa+;
		m.LIBFIS+;
		M.TRATTA+;
		m.noivapercassa+;
		m.nomagaordcli+;
		m.livmaxdibascp+;
		m.numemultiaz
	
	REPLACE LIBERA WITH ALLTRIM(M.LIBERA)
	
	IF !ExecRW(cSql,"PARA","W")
		RETURN .F.
	ENDIF
		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN

*** INSERIMENTO PARAMETRI DI RICARICO AUTOMATICO MAGAZZINO
cSql=""     
cNomeCursorSql="INS_PARA_TOP"
TEXT TO cSql NOSHOW

	DECLARE @DATA_OGGI_ISO_cAAAAMMGG VARCHAR(8)
	DECLARE @DATA_OGGI_TXT_cAAAAMMGG VARCHAR(10)

	SET @DATA_OGGI_ISO_cAAAAMMGG = CONVERT(VARCHAR(8), Getdate(), 112)
	SET @DATA_OGGI_TXT_cAAAAMMGG = Substring(@DATA_OGGI_ISO_cAAAAMMGG, 1, 4) + '/' +
								   Substring(@DATA_OGGI_ISO_cAAAAMMGG, 5, 2) + '/' +
								   Substring(@DATA_OGGI_ISO_cAAAAMMGG, 7, 2)

	DELETE FROM PARA WHERE CODICE = 'TOPM++'
	INSERT INTO PARA
	            (CODICE,
	             DESCRI,
				 LIBERA,
				 PAR_DATINS)
	VALUES		('TOPM++',
				 'Ricarico automatico magazzino durante la modifica del documento',
				 'CN      NNNN                    MOM--   NM',
				 @DATA_OGGI_TXT_cAAAAMMGG)

	DELETE FROM PARA WHERE CODICE = 'TOPM--'
	INSERT INTO PARA
	            (CODICE,
	             DESCRI,
				 LIBERA,
				 PAR_DATINS)
	VALUES		('TOPM--',
				 'Scarico automatico magazzino durante la modifica del documento',
				 'SN      NNNN                    MOM++   NM',
				 @DATA_OGGI_TXT_cAAAAMMGG)

ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	

_TOT_COUNT = _TOT_COUNT + 2

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Causali di magazzino convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 