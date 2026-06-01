*************************************************************************************************
*							      CONVERSIONE CAUSALI DOCUMENTI 								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione delle Causali per documenti dalla tabella CARD_TIPODOCU?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

_risp = MESSAGEBOX("Cancellare prima tutte le causali documenti di Aquarius?",4+32+256,"Attenzione")
IF _risp = 6
	WAIT WINDOWS "Cancellazione vecchie Causali per documenti in corso..." NOWAIT

	cSql = "DELETE FROM PARA WHERE CODICE LIKE 'TOP%' AND DESIVA LIKE '%Tipo effettivo%'"
	IF !ExecCommand(cSql,"DEL_PARA_TOP")
	   return
	ENDIF
ENDIF

WAIT WINDOWS "Conversione Causali per documenti in corso..." NOWAIT

*** AGGIORNAMENTO TABELLA DELLE CAUSALI per documenti
_TOT_COUNT = 0
*cSql = "SELECT * FROM CARD_TIPODOCU ORDER BY CODICE"
cSql = "select * from CARD_TIPODOCU WHERE " + ;
       "('TOP'+CODICE NOT IN (SELECT CODICE FROM PARA WHERE CODICE LIKE 'TOP%' AND DESIVA LIKE '%Tipo effettivo%')) AND " + ;
       "('TOP'+SUBSTRING(CODICE,1,2)+'*' NOT IN (SELECT CODICE AS CODSOST FROM PARA WHERE CODICE LIKE 'TOP%' AND DESIVA LIKE '%Tipo effettivo%')) " + ;
       "ORDER BY CODICE"
IF !ExecCommand(cSql,"CX_CARD_TIPODOCU")
	RETURN .F.
ENDIF
SELECT CX_CARD_TIPODOCU
GO TOP
SCAN

	SCATTER MEMVAR

	x_codi = "CODICE = 'TOP" + ALLTRIM(M.CODICE) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	IF !EOF()
		M.DESCRIZION = ALLTRIM(M.DESCRIZION) + " (SOSTITUITO CODICE '" + ALLTRIM(M.CODICE) + "')"
		M.CODICE = SUBSTR(M.CODICE,1,2) + '*'  && A PARITA' DI CAUSALE ESISTENTE (PER ESEMPIO LE CAUSALI CONTABILI O DI MAGAZZINO) AGGIUNGO UN ASTERISCO NEL CODICE PER DIFFERENZIARLE
	ENDIF
	
	APPEND BLANK
	REPLACE CODICE WITH "TOP" + ALLTRIM(M.CODICE)
	REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	
	REPLACE DESCRI WITH ALLTRIM(M.DESCRIZION)
	IF !ISNULL(M.CAUSALEMAG)
		IF !EMPTY(M.CAUSALEMAG)
			REPLACE NOTE WITH "Causale di magazzino: " + ALLTRIM(M.CAUSALEMAG)
		ENDIF
	ENDIF	
	
	REPLACE DESIVA WITH ""

	_X_SEGNO = '+'
	_X_FAT = 'N'
	_X_BOLL	= 'N'
	_X_LIB = 'C'
	
	IF !ISNULL(M.TIPOEFFETT)
		DO CASE
			CASE M.TIPOEFFETT = 'B'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Bolla di carico)"
				_X_SEGNO = '+'
				_X_FAT = 'N'
				_X_LIB = 'F'

			CASE M.TIPOEFFETT = 'G'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Bolla di scarico)"
				_X_SEGNO = '-'
				_X_FAT = 'V'
				
			CASE M.TIPOEFFETT = 'F'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Fattura)"
				_X_SEGNO = '-'
				_X_FAT = 'S'
				_X_BOLL	= 'S'
				
			CASE M.TIPOEFFETT = 'R'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Fattura riepilogativa)"
				_X_SEGNO = '-'
				_X_FAT = 'S'
				
			CASE M.TIPOEFFETT = 'P'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Fattura proforma)"
				_X_SEGNO = '-'
				_X_FAT = 'N'
				
			CASE M.TIPOEFFETT = 'A'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Fattura accompagnatoria)"
				_X_SEGNO = '-'
				_X_FAT = 'N'
				
			CASE M.TIPOEFFETT = 'M'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Movimento magazzino)"
				_X_SEGNO = '-'
				_X_FAT = 'N'
				
			CASE M.TIPOEFFETT = 'N'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Nota di credito)"
				_X_SEGNO = '-'
				
			CASE M.TIPOEFFETT = 'O'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Ordine cliente)"
				_X_SEGNO = '-'
				_X_FAT = 'N'
				
			CASE M.TIPOEFFETT = 'T'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Ordine fornitore)"
				_X_SEGNO = '+'
				_X_FAT = 'N'
				_X_LIB = 'F'
				
			CASE M.TIPOEFFETT = 'V'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Preventivo)"
				_X_SEGNO = '-'
				_X_FAT = 'N'

			CASE M.TIPOEFFETT = 'U'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Ricevuta fiscale)"
				_X_SEGNO = '-'
				_X_FAT = 'N'
								
			CASE M.TIPOEFFETT = 'S'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Scontrino)"
				_X_SEGNO = '-'
				_X_FAT = 'N'
				
			CASE M.TIPOEFFETT = 'C'
				REPLACE DESIVA WITH "Tipo effettivo documento: " + M.TIPOEFFETT + " (Documento generico)"
				_X_SEGNO = '-'
				_X_FAT = 'N'
				
		ENDCASE
	ELSE
		M.TIPOEFFETT = ""
	ENDIF
	
	IF M.STATO = 'S'
	ELSE
		REPLACE DESIVA WITH ALLTRIM(DESIVA) + IIF(!EMPTY(DESIVA),'; ','') + "Stato: N (non utilizzata)"
	ENDIF
	
	IF _X_SEGNO = '-'
		M.NAT = 'D'
	ELSE
		M.NAT = 'A'
	ENDIF
	
*!*		*** FORZATURE SEGNO
*!*		IF UPPER(ALLTRIM(M.CODCAUMAG)) == 'PRE'
*!*			M.NAT = 'S'
*!*		ENDIF
	
	M.FAT = _X_FAT
	
	M.BOLL				= _X_BOLL
	M.RIC				= SPACE(1)
	M.NOTA				= SPACE(1)
	M.LIB				= _X_LIB
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
	M.FASCIACOMPETENZA  = 'C'
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

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Causali per documenti convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 