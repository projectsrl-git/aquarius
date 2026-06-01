*************************************************************************************************
*									    CONVERSIONE LISTINI 									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione dei listini dalle tabelle CARD_TABTELIS/CARD_TABRILIS?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchi Listini in corso..." NOWAIT

cSql = "DELETE FROM U_LIS_TT"
IF !ExecCommand(cSql,"DEL_LIS_TT")
   return
ENDIF

cSql = "DELETE FROM U_LIS_LG"
IF !ExecCommand(cSql,"DEL_LIS_LG")
   return
ENDIF

WAIT WINDOWS "Conversione Listini SIGLA in corso..." NOWAIT

_TOT_COUNT = 0

cSql = 	"SELECT * FROM CARD_TABTELIS WHERE CODICE IN (SELECT CODICE FROM CARD_TABRILIS) ORDER BY CODICE"
IF !ExecCommand(cSql,"CX_CARD_TABTELIS")
   return
ENDIF
SELECT CX_CARD_TABTELIS
GO TOP
SCAN
	
	WAIT WINDOWS "Conversione Listino " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
	
	SCATTER MEMVAR
	
	__LIS_CODSOC = PUB_CODSOC
	__LIS_CODCLI = "" 
	__LIS_RAGSOC = ""
	__LIS_CODART = ""
	__LIS_DESART = ""
	__LIS_DATLIS = SUBSTR(M.DATAINVALI,1,4) + '/' + SUBSTR(M.DATAINVALI,5,2) + '/' + SUBSTR(M.DATAINVALI,7,2)
	__LIS_ALLIST = SUBSTR(M.DATAFIVALI,1,4) + '/' + SUBSTR(M.DATAFIVALI,5,2) + '/' + SUBSTR(M.DATAFIVALI,7,2)
	__LIS_PREZZO = 0
	
	x_codi = "CODICE = '" + M.CODICE + "'"
	x_cond = x_codi 
	cSql = 	"SELECT * FROM CARD_TABRILIS WHERE " + x_cond + " ORDER BY ARTICOLO"
	IF !ExecCommand(cSql,"CX_CARD_TABRILIS")
	   return
	ENDIF
	SELECT CX_CARD_TABRILIS
	GO TOP
	SCAN
		SCATTER MEMVAR
		
		__LIS_CODART = ALLTRIM(M.ARTICOLO)
		__LIS_DESART = ""
		__LIS_PREZZO = M.PREZZO
		
		x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
		x_codi = "ART_CODPRI = '" + __LIS_CODART + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "SELECT ART_CODPRI,ART_DESCR FROM U_ART_PR WHERE " + x_cond
		IF !ExecCommand(cSql,"CX_ART_PR")
			RETURN .F.
		ENDIF
		SELECT CX_ART_PR
		GO TOP
		IF !EOF()
			__LIS_DESART = ALLTRIM(ART_DESCR)
		ENDIF
		
		cSql = "SELECT * FROM U_LIS_TT WHERE 1=0"
		IF !ExecRW(cSql,"U_LIS_TT","R")
		   return
		ENDIF
		SELECT U_LIS_TT
		APPEND BLANK
		
		REPLACE LIS_CODSOC WITH __LIS_CODSOC 
		REPLACE LIS_CODCLI WITH __LIS_CODCLI 
		REPLACE LIS_RAGSOC WITH __LIS_RAGSOC 
		REPLACE LIS_CODART WITH __LIS_CODART 
		REPLACE LIS_DESART WITH __LIS_DESART 
		REPLACE LIS_DATLIS WITH __LIS_DATLIS 
		REPLACE LIS_ALLIST WITH __LIS_ALLIST 
		REPLACE LIS_PREZZO WITH __LIS_PREZZO 
		
		SCATTER MEMVAR
		
		IF !ExecRW(cSql,"U_LIS_TT","W")
		   return
		ENDIF
		
		=LIS_LOGA("XXX",M.LIS_DATLIS,M.LIS_ALLIST,"CLIENTE","XXX","XXX",M.LIS_CODCLI)	&& AGGIORNA LOG LISTINO
		
		_TOT_COUNT = _TOT_COUNT + 1
	ENDSCAN
	
ENDSCAN


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale righe Listini convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 