*************************************************************************************************
*						CONVERSIONE TABELLA DESCRIZIONE PORTI IN LINGUA							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Novembre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione dei porti in Lingua dalla tabella CARD_DESPORTI?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF
 

WAIT WINDOWS "Cancellazione vecchie Descrizione dei porti in Lingua in corso..." NOWAIT

cSql = "DELETE FROM DESLINGUE WHERE TIPODES = 'CODI.PORTO'"
IF !ExecCommand(cSql,"DEL_DESCPGLI")
   return
ENDIF

_TOT_COUNT = 0


WAIT WINDOWS "Conversione Descrizione dei porti in Lingua in corso..." NOWAIT

cSql = 	"SELECT * FROM CARD_DESPORTI ORDER BY LINGUA, CODICE"
IF !ExecCommand(cSql,"CX_CARD_DESPORTI")
   return
ENDIF
SELECT CX_CARD_DESPORTI
GO TOP
SCAN

	WAIT WINDOWS "Conversione Descrizione dei porti in Lingua " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
	
	SCATTER MEMVAR
	
	x_codi = "CODICE = '" + M.LINGUA + "'"
	x_cond = x_codi
	cSql   = "SELECT * FROM CARD_LINGUE WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_CARD_LINGUE")
	   return
	ENDIF
	SELECT CX_CARD_LINGUE
	GO TOP
	IF EOF()
		LOOP
	ENDIF
	
	_COD_LINGUA_SIGLA = ALLTRIM(CODICE)
	_DES_LINGUA_SIGLA = ALLTRIM(DESCRIZION)
	
	_COD_LINGUA_AQUARIUS = ""
	_DES_LINGUA_AQUARIUS = ""
	
	x_codi = "CODICE LIKE 'LNG%'"
	x_desc = "DESCRI LIKE '" + _DES_LINGUA_SIGLA + "'"
	x_cond = x_codi + " and " + x_desc 
	cSql   = "SELECT * FROM PARA WHERE " + x_cond + " ORDER BY CODICE"
	IF !ExecCommand(cSql,"CX_PARA")
	   return
	ENDIF
	SELECT CX_PARA
	GO TOP
	IF EOF()
		_ULTIMO_CODICE_AQUARIUS = ""
		x_codi = "CODICE LIKE 'LNG%'"
		x_cond = x_codi
		cSql   = "SELECT TOP 1 CODICE FROM PARA WHERE " + x_cond + " ORDER BY CODICE DESC"
		IF !ExecCommand(cSql,"TMP_PARA")
		   return
		ENDIF
		SELECT TMP_PARA
		GO TOP
		IF !EOF()
			_ULTIMO_CODICE_AQUARIUS = SUBSTR(CODICE,4,3)
		ELSE
			_ULTIMO_CODICE_AQUARIUS = "000"
		ENDIF
		
		_NUOVO_CODICE_AQUARIUS = PADL(ALLTRIM(STR(VAL(_ULTIMO_CODICE_AQUARIUS) + 1,3,0)),3,'0')
		
		cSql = "SELECT * FROM PARA WHERE 1=0"
		IF !ExecRW(cSql,"PARA","R")
			RETURN .F.
		ENDIF
		SELECT PARA
		GO TOP
		APPEND BLANK
		REPLACE CODICE WITH "LNG" + _NUOVO_CODICE_AQUARIUS
		REPLACE DESCRI WITH _DES_LINGUA_SIGLA
		REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
		IF !ExecRW(cSql,"PARA","W")
			RETURN .F.
		ENDIF
		
		_COD_LINGUA_AQUARIUS = _NUOVO_CODICE_AQUARIUS
		_DES_LINGUA_AQUARIUS = ALLTRIM(DESCRI)
		
	ELSE
		_COD_LINGUA_AQUARIUS = SUBSTR(CODICE,4,3)
		_DES_LINGUA_AQUARIUS = ALLTRIM(DESCRI)
	ENDIF
	
	__IDDESLING = SYS(2015)
	__TIPODES   = "CODI.PORTO"
	__LINGUA    = _COD_LINGUA_AQUARIUS
	__CODICE    = ALLTRIM(M.CODICE)

	
	__DESCRI    = IIF(!ISNULL(M.DESCRIZION),ALLTRIM(M.DESCRIZION),"")
	__DESEST    = ''					
	
	cSql = "SELECT * FROM DESLINGUE WHERE 1=0"
	IF !ExecRW(cSql,"DESLINGUE","R")
	   return
	ENDIF
	SELECT DESLINGUE
	APPEND BLANK
	REPLACE IDDESLING WITH __IDDESLING
	REPLACE TIPODES   WITH __TIPODES  
	REPLACE LINGUA    WITH __LINGUA   
	REPLACE CODICE    WITH __CODICE   
	REPLACE DESCRI    WITH __DESCRI   
	REPLACE DESEST    WITH __DESEST   
	IF !ExecRW(cSql,"DESLINGUE","W")
	   return
	ENDIF
	
	_TOT_COUNT = _TOT_COUNT + 1
	
ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Descrizione dei porti in Lingua convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 