*************************************************************************************************
*							      CONVERSIONE FASI DI LAVORAZIONE								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione delle Fasi di lavorazione dalla tabella CARD_TABFASE?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchie Fasi di lavorazione in corso..." NOWAIT

cSql = "DELETE FROM PARA WHERE CODICE LIKE 'FAL%'"
IF !ExecCommand(cSql,"DEL_PARA_FAL")
   return
ENDIF


WAIT WINDOWS "Conversione Fasi di lavorazione in corso..." NOWAIT


*** AGGIORNAMENTO TABELLA DELLE FASI DI LAVORAZIONE
_TOT_COUNT = 0
cSql = "SELECT * FROM CARD_TABFASE ORDER BY COD"
IF !ExecCommand(cSql,"CX_CARD_TABFASE")
	RETURN .F.
ENDIF
SELECT CX_CARD_TABFASE
GO TOP
SCAN

	SCATTER MEMVAR
	
	M.COD = SUBSTR(M.COD,2,3)

	x_codi = "CODICE = 'FAL" + ALLTRIM(M.COD) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
		APPEND BLANK
		REPLACE CODICE WITH "FAL" + ALLTRIM(M.COD)
		REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	ENDIF
	
	REPLACE DESCRI WITH ALLTRIM(M.DESCR)
	REPLACE DESIVA WITH 'PDM'
	REPLACE LIBERA WITH IIF(VAL(M.COD) = 1 OR VAL(M.COD) = 2,ALLTRIM(STR(VAL(M.COD))),"")
	
	IF !ExecRW(cSql,"PARA","W")
		RETURN .F.
	ENDIF

	*** INSERIMENTO ARTICOLO FITTIZIO FASE DI LAVORAZIONE IN ANAGRAFICA ARTICOLI (PER CODIFICA DI.BA.)
	x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "ART_CODPRI = '" + M.COD + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT * FROM U_ART_PR WHERE " + x_cond
	IF !ExecRW(cSql,"U_ART_PR","R")
		RETURN .F.
	ENDIF
	SELECT U_ART_PR
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF	
	REPLACE ART_CODSOC WITH PUB_CODSOC
	REPLACE ART_CODPRI WITH ALLTRIM(M.COD)
	REPLACE ART_DESCR WITH ALLTRIM(M.DESCR)
	REPLACE ART_MAGA WITH PUB_CODM
	REPLACE ART_CODMAT WITH '001'
	REPLACE ART_TIPART WITH 'P'
	REPLACE ART_UNIMIS WITH 'NR'
	REPLACE ART_UMMAGA WITH 'NR'
	REPLACE ART_DATVAR WITH RIBALTA2(DTOC(DATE()))
	REPLACE ART_DATINS WITH RIBALTA2(DTOC(DATE()))
	REPLACE ART_CODIVA WITH PUB_IVA
*!*			REPLACE ART_PRZCOS WITH 0.006195  && COSTO FISSO AL SECONDO (CIRCA 22,3 €/ORA)
*!*			REPLACE ART_COSMAT WITH 0.006195  && COSTO FISSO AL SECONDO (CIRCA 22,3 €/ORA)
	REPLACE ART_PRZCOS WITH 0
	REPLACE ART_COSMAT WITH 0
	IF !ExecRW(cSql,"U_ART_PR","W")
		RETURN .F.
	ENDIF
	
	x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "ART_CODPRI = '" + M.COD + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT * FROM U_ART_AN WHERE " + x_cond
	IF !ExecRW(cSql,"U_ART_AN","R")
		RETURN .F.
	ENDIF
	SELECT U_ART_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	REPLACE ART_CODSOC WITH PUB_CODSOC
	REPLACE ART_CODPRI WITH ALLTRIM(M.COD)
	IF !ExecRW(cSql,"U_ART_AN","W")
		RETURN .F.
	ENDIF
		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Fasi di lavorazione convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 