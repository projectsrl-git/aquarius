*************************************************************************************************
*									    CONVERSIONE LISTINI 									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Maggio 2014: Cardioline				 														*
*************************************************************************************************

** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "CAR"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'CAR' non configurato" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	USE
	RETURN .F.
ENDIF

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2003 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

_V_DATADA = PJ_INPUTBOX("Digitare la data di inizio validità da considerare","Validità dal", DTOC(DATE()))
IF EMPTY(_V_DATADA) OR _V_DATADA = '  /  /    '
	MESSAGEBOX("Operazione annullata",48,"Attenzione")
	RETURN .F.
ENDIF
IF VALID_DATA(_V_DATADA)
ELSE
	MESSAGEBOX("Data non valida",16,"Attenzione")
   	MESSAGEBOX("Operazione annullata",48,"Attenzione")
	RETURN .F.
ENDIF
_V_DATADA=OK_DATA(_V_DATADA)

_V_CODGLI = "?"
_V_DESGLI = ""
_V_CODGLI = seek_para('GLI',ALLTRIM(_V_CODGLI),'CODICE','CODICE',"4,3")
IF EMPTY(_V_CODGLI)
	_RISP = MESSAGEBOX("Continuare senza attribuire la tipologia?",4+48+256,"Attenzione")
	IF _RISP = 6
	ELSE
		MESSAGEBOX("Operazione annullata",48,"Attenzione")
		RETURN .F.
	ENDIF
ELSE
	SELECT _pj_para
	_V_DESGLI = ALLTRIM(DESCRI)
	_RISP = MESSAGEBOX("Continuare attribuendo la tipologia " + ALLTRIM(_V_CODGLI) + " (" + ALLTRIM(_V_DESGLI) + ") ?",4+48+256,"Attenzione")
	IF _RISP = 6
	ELSE
		MESSAGEBOX("Operazione annullata",48,"Attenzione")
		RETURN .F.
	ENDIF
ENDIF


RIT = MESSAGEBOX("Conversione listini di vendita da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF

_RISP = MESSAGEBOX("Eliminare prima i vecchi listini?",4+48+256,"Attenzione")
IF _RISP = 6
	WAIT WINDOWS "Cancellazione vecchi Listini in corso..." NOWAIT

	cSql = "DELETE FROM U_LIS_TT"
	IF !ExecCommand(cSql,"DEL_LIS_TT")
	   return
	ENDIF

	cSql = "DELETE FROM U_LIS_LG"
	IF !ExecCommand(cSql,"DEL_LIS_LG")
	   return
	ENDIF
ENDIF


CREATE CURSOR IMPORTAXLS ( ;
	A C(200), ;
	B C(200), ;
	C C(200), ;
	D C(200), ;
	E C(200), ;
	F C(200))

_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "' TYPE xls"
&_COMMAND


_TOT_COUNT = 0

SELECT IMPORTAXLS
GO TOP
DO WHILE .T.
	IF EOF()
		EXIT
	ENDIF
	
	WAIT WINDOWS "Conversione Listini di vendita in corso... (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
    IF EMPTY(D) OR EMPTY(F)  && SOLO RIGHE CON CODICE E PREZZO SIGNIFICATIVI
    	SKIP +1
		LOOP
    ENDIF
    
    IF ALLTRIM(D) = "ARTICOLO" OR ALLTRIM(F) = "EUR ARTICOLO"  && BY-PASSO INTESTAZIONI DI COLONNE
    	SKIP +1
		LOOP
    ENDIF
    
    SCATTER MEMVAR MEMO
    
	_X_PRODOT = ALLTRIM(M.A)  && COLONNA "PRODOTTO" (CODICE PRODOTTO DI VENDITA)
	_X_DESPRO = ALLTRIM(M.B)  && COLONNA "DES PRODOTTO" (DESCRIZIONE PRODOTTO DI VENDITA)
	_X_TIPO   = ALLTRIM(M.C)  && COLONNA "TIPO"
	_X_CODART = ALLTRIM(M.D)  && COLONNA "ARTICOLO"
	_X_DESART = ALLTRIM(M.E)  && COLONNA "DES ARTICOLO"
	_X_PRZVEN = ALLTRIM(M.F)  && COLONNA "EUR ARTICOLO" (PREZZO IN EUR)
	
	__LIS_CODSOC = PUB_CODSOC
	__LIS_CODCLI = "" 
	__LIS_RAGSOC = ""
	__LIS_CODART = _X_CODART
	__LIS_DESART = _X_DESART
	__LIS_DATLIS = RIBALTA2(_V_DATADA)
	__LIS_ALLIST = "2099/12/31"
	__LIS_PREZZO = _X_PRZVEN
	__LIS_CODGLI = _V_CODGLI
	
	x_soci = "LIS_CODSOC = '" + __LIS_CODSOC + "'"
	x_codi = "LIS_CODCLI = '" + __LIS_CODCLI + "'"
	x_arti = "LIS_CODART = '" + __LIS_CODART + "'"
	x_data = "LIS_DATLIS = '" + __LIS_DATLIS + "'"
	x_cond = x_soci + " and " + x_codi + " and " + x_arti + " and " + x_data 
	cSql = "SELECT * FROM U_LIS_TT WHERE " + x_cond
	IF !ExecRW(cSql,"U_LIS_TT","R")
	   return
	ENDIF
	SELECT U_LIS_TT
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	
	REPLACE LIS_CODSOC WITH __LIS_CODSOC 
	REPLACE LIS_CODCLI WITH __LIS_CODCLI 
	REPLACE LIS_RAGSOC WITH __LIS_RAGSOC 
	REPLACE LIS_CODART WITH __LIS_CODART 
	REPLACE LIS_DESART WITH __LIS_DESART 
	REPLACE LIS_DATLIS WITH __LIS_DATLIS 
	REPLACE LIS_ALLIST WITH __LIS_ALLIST 
	REPLACE LIS_PREZZO WITH VAL(__LIS_PREZZO)
	REPLACE LIS_CODGLI WITH __LIS_CODGLI
	REPLACE LIS_CODVAL WITH PUB_VALU
	REPLACE LIS_VALUTA WITH PUB_VALU

	SCATTER MEMVAR
	
	IF !ExecRW(cSql,"U_LIS_TT","W")
	   return
	ENDIF
	
	=LIS_LOGA("XXX",M.LIS_DATLIS,M.LIS_ALLIST,"CLIENTE","XXX","XXX",M.LIS_CODCLI)	&& AGGIORNA LOG LISTINO
	
	_TOT_COUNT = _TOT_COUNT + 1
	
*!*		**=> ERASMO - INIZIO 26/11/2014
*!*		*** SE IL PRODOTTO E' UN GRUPPO DI.BA., ALLORA NE RIVALUTO IL COSTO E LO APPLICO IN ANAGRAFICA COME PREZZO DI ULTIMO CARICO
*!*		*** QUESTO PERCHE' NON AVENDO MAI GESTITO A MAGAZZINO I KIT, SI TROVEREBBERO SPROVVISTI DI TALE PREZZO (CHE VIENE SETTATO ALL'IMPORT DELLE GIACENZE)
*!*		x_codi = "DIT_GRUPPO = '" + __LIS_CODART + "'"
*!*		x_cond = x_codi
*!*		cSql = "SELECT * FROM U_DIS_TT WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"TMP_DIS_TT")
*!*		   return
*!*		ENDIF
*!*		SELECT TMP_DIS_TT
*!*		GO TOP
*!*		IF !EOF()
*!*			DO RIVALUTA_CAMPI_U_DIS_TT WITH "TMP_DIS_TT"
*!*			SELECT TMP_DIS_TT
*!*			GO TOP
*!*			XCOSTO = DIT_COSTO
*!*			x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
*!*			x_arti = "ART_CODPRI = '" + __LIS_CODART + "'"
*!*			x_cond = x_soci + " and " + x_arti
*!*			cSql = "SELECT * FROM U_ART_PR WHERE " + x_cond
*!*			IF !ExecRW(cSql,"U_ART_PR","R")
*!*			   return
*!*			ENDIF
*!*			SELECT U_ART_PR
*!*			GO TOP
*!*			IF !EOF()
*!*				REPLACE ART_ULPCAR WITH XCOSTO
*!*			ENDIF
*!*			IF !ExecRW(cSql,"U_ART_PR","W")
*!*			   return
*!*			ENDIF
*!*		ENDIF
*!*		**=> ERASMO - FINE 26/11/2014
		
	SELECT IMPORTAXLS
	SKIP +1
	
ENDDO


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale righe Listini convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 