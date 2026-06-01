*************************************************************************************************
*							CONVERSIONE ORDINI CLIENTI											*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2011 : Xilopan 				 													*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"del PORTAFOGLIO ORDINI CLIENTI da foglio Execl	 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH #################################################################################

=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO

SELECT PERCORSO
V_PATH = ALLTRIM(PER_PATH)

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH 

IF USED("XILOPAN_PO")
	SELECT XILOPAN_PO 
	USE
ENDIF

USE XILOPAN_PO EXCLUSIVE IN 0 AGAIN
SELECT XILOPAN_PO
ZAP
USE

=OPENDB("XILOPAN_PO")

SET DEFAULT TO &PUB_DIR

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_ORD_TT/DD SQL #########################################################
WAIT WINDOWS "Cancellazione vecchi Ordini clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_ORD_TT where 1=1"
IF !ExecCommand(cSql,"U_ORD_TT")
   return(.f.)
ENDIF
cSql = "delete from U_ORD_DD where 1=1"
IF !ExecCommand(cSql,"U_ORD_DD")
   return(.f.)
ENDIF
WAIT CLEAR

*** DEFINIZIONE CURSORI DI APPOGGIO #################################################################################
cSql = "Select * from U_ORD_TT where 1=0"
IF !ExecCommand(cSql,"CX_ORD_TT")
   return(.f.)
ENDIF
SELECT CX_ORD_TT
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK
HH=AFIELDS(TRANSITO)
CREATE CURSOR CU_ORD_TT FROM ARRAY TRANSITO
INDEX ON ORD_CODCLI+ORD_NUMORD+ORD_DATORD TAG O_KEY ADDITIVE


cSql = "Select * from U_ORD_DD where 1=0"
IF !ExecCommand(cSql,"CX_ORD_DD")
   return(.f.)
ENDIF
SELECT CX_ORD_DD
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK
HH=AFIELDS(TRANSITO)
CREATE CURSOR CU_ORD_DD FROM ARRAY TRANSITO
INDEX ON DAGGANCIO+ORD_CODART TAG I_KEYART ADDITIVE




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO ######################################################
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = RIBALTA2(DTOC(DATE()))
_CTR = 0

RELEASE  V_SEQUEN    
PUBLIC   V_SEQUEN 
V_SEQUEN     = 0   


RELEASE M.ORD_codcli,M.ORD_numord,M.ORD_datord,M.ORD_qtaord
PUBLIC M.ORD_codcli,M.ORD_numord,M.ORD_datord,M.ORD_qtaord
M.ORD_codcli = ''
M.ORD_numord = ''
M.ORD_datord = ''
M.ORD_qtaord = 0

RELEASE ARTICOLO_PARZIALE 
PUBLIC ARTICOLO_PARZIALE 
ARTICOLO_PARZIALE  = '' 


**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  	
	RETURN
ENDIF



WAIT WINDOWS "Selezionato file EXCEL '" + ALLTRIM(gcFile) + "'" TIMEOUT 3



CREATE CURSOR IMPORTAXLS (	CODCLI C(10),;
							RAGSOC C(50),;
							ANNO C(04),;
							NUMORD C(06),;
							DATAOR C(08),;
							DESART C(80),;
							COLFRO C(03),;
							COLRET C(03),;
							QTANUM N(10,0),;
							SPESSO N(5,0),;
							ALTEZZ N(5,0),;
							LUNGHE N(6,0),;
							FINITU C(03),;
							NOTEPRO C(100),;
							QTAMC N(17,3),;
							NOTESPE C(100),;
							NOTEVAR C(100))


APPEND FROM (gcFile) TYPE xls	

SELECT IMPORTAXLS
INDEX ON ALLTRIM(CODCLI)+ALLTRIM(NUMORD)+ALLTRIM(DATAOR)+ALLTRIM(COLFRO)+ALLTRIM(COLRET)+ALLTRIM(STR(SPESSO,5,0))+ALLTRIM(STR(ALTEZZ,5,0))+;
	ALLTRIM(STR(LUNGHE,5,0))+ALLTRIM(FINITU) TAG I_RICERCA


*!*	carica il secondo file di testo 

gcFile = GETFILE('txt', '', 'Browse', 1, 'Seleziona PO FORMATO TESTO')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF

CREATE CURSOR IMPORTATXT (CAMPO1  c(250))
SELECT IMPORTATXT
APPEND FROM (gcFile) TYPE sdf	

=CARICA_PO_IN_FORMATO_TESTO()

CREATE CURSOR CUR_ERRORI (CODCLI C(10), RAGSOC C(50), NUMORD C(06), DATORD C(10), CODART C(30), DESART C(200), ERRORE C(254))
INDEX ON CODCLI+NUMORD+RIBALTA2(DATORD)+CODART TAG I_ORDINA

_CONTATES = 0
_CONTADET = 0

_LAST_CODCLI = ""
_LAST_NUMORD = ""
_LAST_DATORD = ""
V_SEQUEN     = 10

SELECT XILOPAN_PO
SET ORDER TO I_ORDINE
GO TOP
DO WHILE !EOF()
    IF DELETED()
       SELECT XILOPAN_PO
       SKIP +1
       LOOP
    ENDIF
    
	WAIT WINDOWS "Importazione record " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
	
    SCATTER MEMVAR MEMO
    
    M.ORD_CODSOC = PUB_CODSOC
    M.ORD_CODCLI = TRC(PUB_LCL,ALLTRIM(M.O_CODCLI))
   	M.ORD_RAGSOC = ALLTRIM(M.O_RAGSOC)
   	M.ORD_NUMORD = M.O_NUMORD
   	M.ORD_DATORD = M.O_DATORD
   	M.ORD_DTCONS = M.O_DTCONS
   	M.ORD_ANNO   = SUBSTR(M.ORD_DATORD,1,4)
   	M.TNUMERO    = M.ORD_NUMORD
   	M.ORD_MAGS   = PUB_CODM
   	   	
    x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "cli_codcli = '" + M.ORD_CODCLI + "'"
    x_cond = x_soci + " and " + x_codi
    cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"

	IF !ExecCommand(cSql,"cx_cli_an")
	  return(.f.)
	ENDIF
	SELECT cx_cli_an
	GO TOP
	IF !EOF()
		M.ORD_RAGSOC = CLI_RAGSOC
		M.ORD_INDIRI = CLI_INDIR
		M.ORD_CAP	 = CLI_CAP
		M.ORD_LOCALI = CLI_LOCALI
		M.ORD_PROVIN = CLI_PROVIN    
		M.ORD_PARIVA = CLI_PARIVA
		M.ORD_FAX    = CLI_FAX
		M.ORD_CDIMBA = CLI_CODIMB
		__DTCLOK     = CLI_DTCLOK
		M.ORD_EVATOT = CLI_EVATOT
		M.ORD_ORDDDT = CLI_ORDDDT
		RELEASE _FIDO
		PUBLIC _FIDO
		_fido=CLI_IMPFID

		M.ORD_CODLOC = CLI_LOCDOC
		M.ORD_CPA	 = CLI_CONPAG
		M.ORD_BANCA	 = CLI_BAE
		M.ORD_CODNAZ = CLI_NAZION
		IF EMPTY(M.ORD_CODNAZ)
		   M.ORD_CODNAZ	= "IT"
		ENDIF  
		M.ORD_CAUS	     = PUB_ORDIN
		M.ORD_FLGABP     = CLI_FLGABP
		M.ORD_VALUTA     = CLI_VALUTA
		IF EMPTY(M.ORD_VALUTA)  
		   M.ORD_VALUTA  = PUB_VALRIF
		ENDIF
		M.ORD_AGE        = CLI_AGE
		IVA_ESE          = CLI_ALRID
		IVA_CLI          = CLI_CODIVA
		M.ORD_PRORIT     = CLI_PROVVI
		M.ORD_SC1T       = CLI_SC1
		M.ORD_SC2T       = CLI_SC2
		M.ORD_SC3T       = CLI_SC3
		M.ORD_CLIFAT     = CLI_CODDIR
		M.ORD_RAGFAT     = CLI_RAGDIR
		M.ORD_SPBOLL	 = CLI_SPINCA
		M.ORD_SPTRAS	 = CLI_SPTRAS
	ELSE
   		_cErrore = "CLIENTE '" + M.ORD_CODCLI + "' NON TROVATO IN U_CLI_AN - RIGA ORDINE NON IMPORTATA"
   		DO MEMORIZZA_ERRORE_CONV_ORDINI WITH _cErrore
   		SELECT XILOPAN_PO
   		SKIP +1
   		LOOP
	ENDIF
   	
   	IF M.ORD_CODCLI == _LAST_CODCLI AND M.ORD_NUMORD == _LAST_NUMORD AND M.ORD_DATORD == _LAST_DATORD
   		V_SEQUEN = V_SEQUEN + 10
   	ELSE
   		*** CREO TESTATA NUOVO ORDINE IN CURSORE CU_ORD_TT
        V_SEQUEN = 10
        M.TAGGANCIO = STR(NEWPROG('NUMORD'),10)
        	        
        SELECT CU_ORD_TT
        APPEND BLANK 
        GATHER MEMVAR MEMO
        
        _CONTATES = _CONTATES + 1
        
        _LAST_CODCLI = M.ORD_CODCLI
        _LAST_NUMORD = M.ORD_NUMORD
        _LAST_DATORD = M.ORD_DATORD
	ENDIF
   	
   	*** VARIABILI PER INSERIMENTO RIGA DI DETTAGLIO
   	
   	M.ORD_CODART = ALLTRIM(M.O_CODART)
   	M.ORD_DESART = ALLTRIM(M.O_DESART)
   	M.ORD_DATCON = M.O_DTCONS
   	
   	*** VARIABILI PER IL PUNTAMENTO AL CONTENUTO DEL FILE EXCEL SORGENTE
   	_CODCLI = TRC(6,ALLTRIM(STR(VAL(M.ORD_CODCLI),10,0)))
   	_NUMORD = ALLTRIM(STR(VAL(M.ORD_NUMORD),6,0))
   	_DATAOR = ALLTRIM(STR(VAL(STRTRAN(RIBALTA2(M.ORD_DATORD),"/","")),8,0))
   	_COLFRO = ""
   	_COLRET = ""
   	_SPESSO = 0
   	_ALTEZZ = 0
   	_LUNGHE = 0
   	_FINITU = ""
   	
   	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   	x_codi = "art_codpri = '" + M.ORD_CODART + "'"
   	x_cond = x_soci + " and " + x_codi
   	cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   	IF !ExecCommand(cSql,"CUR_ARTICOLI")
   		RETURN .F.
   	ENDIF
   	SELECT CUR_ARTICOLI
   	GO TOP
   	IF EOF()
   		_cErrore = "ARTICOLO '" + M.ORD_CODART + "' NON TROVATO IN U_ART_PR - RIGA ORDINE NON IMPORTATA"
   		DO MEMORIZZA_ERRORE_CONV_ORDINI WITH _cErrore
   		SELECT XILOPAN_PO
   		SKIP +1
   		LOOP
   	ELSE
	   	_SPESSO = ART_SPESSO 
	   	_ALTEZZ = ART_ALTEZZ 
	   	_LUNGHE = ART_LUNGHE
	   	_COLFRO = IIF(EMPTY(ART_CODCOL) OR ALLTRIM(ART_CODCOL) = "000","",ART_CODCOL)
   	
		*M.ORD_CODART  = ART_CODPRI
		M.ORD_MAGA	  = ART_MAGA
		IF EMPTY(M.ORD_MAGS)
		ELSE
		   M.ORD_MAGA = M.ORD_MAGS
		ENDIF
		*M.ORD_DESART  = ART_DESCR
		M.ORD_DES2   = ART_DESEST
		M.ORD_UM	 = ART_UMMAGA
		M.ORD_IVA	 = ART_CODIVA
		M.ORD_PREZZO = ART_PRZVEN
		M.ORD_COORD  = ART_COORD 
		M.ORD_QTXCON = ART_QTACON 
		M.ORD_SCORMI = ART_SCORMI
		M.ORD_CODTAG = ART_CODTAG 
		M.ORD_DESTAG = ART_DESTAG 
		M.ORD_CODCOL = ART_CODCOL 
		M.ORD_DESCOL = ART_DESCOL 
		M.ORD_PUBBLI = ART_PUBBLI
		M.ORD_PESOUM = ART_PESOUM
		M.ORD_CODMAT = ART_CODMAT
		M.ORD_DESMAT = ART_DESMAT
		M.ORD_CODCOL = ART_CODCOL
		M.ORD_DESCOL = ART_DESCOL
		M.ORD_SPESSO = ART_SPESSO
		M.ORD_ALTEZZ = ART_ALTEZZ
		M.ORD_LUNGHE = ART_LUNGHE
		M.ORD_CODIMB = ART_CODIMB
		M.ORD_DESIMB = ART_DESIMB
		M.ORD_LOTMIN = ART_LOTMIN
		M.ORD_CDAPRD = M.ORD_CODART
		M.ORD_DSAPRD = M.ORD_DESART

		DO OK_LIST     && GESTISCE I LISTINI 

		DO OK_PROV     && GESTISCE LE PROVVIGIONI 
		
		IF EMPTY(ALLTRIM(M.ORD_DATCON))
		   m.ord_SETTPR = ""
		   M.ORD_SETTCC = ""
		   M.ORD_SETTCX = ""
		ELSE
		   IF SUBSTR(M.ORD_DATCON,3,1) = '/'
		   		x_cond = "cal_datamg = '" + ribalta2(M.ORD_DATCON) + "'"
		   ELSE
		   		x_cond = "cal_datamg = '" + M.ORD_DATCON + "'"
		   ENDIF
		   cSql   = "SELECT * FROM U_CAL_LA WHERE " + x_cond
		   IF !ExecCommand(cSql,"CUR_CAL_LA")
		      return(.f.)
		   ENDIF
		   SELECT CUR_CAL_LA
		   GO TOP
		   IF EOF()
		      M.ORD_SETTCC = ""
		      M.ORD_SETTCX = ""
		   ELSE
		      M.ORD_SETTCC = CAL_SETT
		      M.ORD_SETTCX = RIBALTASET(CAL_SETT)
		   ENDIF
		ENDIF
		
	   	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	   	x_codi = "art_codpri = '" + M.ORD_CODART + "'"
	   	x_cond = x_soci + " and " + x_codi
	   	cSql = "select * from u_art_an where " + x_cond + " order by art_codsoc,art_codpri"
	   	IF !ExecCommand(cSql,"CUR_ARTICOLI2")
	   		RETURN .F.
	   	ENDIF
	   	SELECT CUR_ARTICOLI2
	   	GO TOP
	   	IF EOF()
	   		_cErrore = "ARTICOLO '" + M.ORD_CODART + "' NON TROVATO IN U_ART_AN - RIGA ORDINE NON IMPORTATA"
	   		DO MEMORIZZA_ERRORE_CONV_ORDINI WITH _cErrore
	   		SELECT XILOPAN_PO
	   		SKIP +1
	   		LOOP
	   	ELSE
	   		_COLRET = IIF(EMPTY(ART_CODCOLRET) OR ALLTRIM(ART_CODCOLRET) = "000","",ART_CODCOLRET)
	   		_FINITU = ART_FINI
	   	ENDIF
   	ENDIF
   	
   	M.ORD_CODSYS = SYS(2015)
   	M.ORD_LEGSYS = SYS(2015)
   	
   	_SEEK = ALLTRIM(_CODCLI)+ALLTRIM(_NUMORD)+ALLTRIM(_DATAOR)+ALLTRIM(_COLFRO)+ALLTRIM(_COLRET)+ALLTRIM(STR(_SPESSO,5,0))+ALLTRIM(STR(_ALTEZZ,5,0))+;
		ALLTRIM(STR(_LUNGHE,5,0))+ALLTRIM(_FINITU)
   	
	SELECT IMPORTAXLS
	SET ORDER TO I_RICERCA
	GO TOP
	SEEK _SEEK
	IF FOUND()
		SCATTER MEMVAR MEMO
	ELSE
   		_cErrore = "NESSUNA CORRISPONDENZA IN FILE EXCEL SELEZIONATO - RIGA ORDINE NON IMPORTATA"
   		DO MEMORIZZA_ERRORE_CONV_ORDINI WITH _cErrore
   		SELECT XILOPAN_PO
   		SKIP +1
   		LOOP
	ENDIF
	
	M.ORD_NOTEPRO = M.NOTEPRO
	M.ORD_NOTESPE = M.NOTESPE
	M.ORD_NOTEVAR = M.NOTEVAR
	
	M.ORD_NUMBOB = M.QTANUM

	M.ORD_QTAMQ1 = TROVA_MQ_DA_AL_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,1) 
	M.ORD_QTAMQ  = TROVA_MQ_DA_AL_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,M.ORD_NUMBOB) 

	M.ORD_QTAML1 = TROVA_ML_DA_LU(M.ORD_LUNGHE,1)
	M.ORD_QTAML  = TROVA_ML_DA_LU(M.ORD_LUNGHE,M.ORD_NUMBOB)

	M.ORD_QTAMC1 = TROVA_MC_DA_AL_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,1,M.ORD_SPESSO) 
	M.ORD_QTAMC  = TROVA_MC_DA_AL_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,M.ORD_NUMBOB,M.ORD_SPESSO) 

	M.ORD_QTAKG1 = TROVA_KG_DA_MQ(M.ORD_CODART,M.ORD_SPESSO,M.ORD_QTAMQ1,1)
	M.ORD_QTAKG  = TROVA_KG_DA_MQ(M.ORD_CODART,M.ORD_SPESSO,M.ORD_QTAMQ1,M.ORD_NUMBOB)

	M.ORD_QTAORD = M.ORD_QTAMQ
	IF M.ORD_UM = 'KG'
	   M.ORD_QTAORD = M.ORD_QTAKG
	ENDIF
	IF M.ORD_UM = 'MQ'
	   M.ORD_QTAORD = M.ORD_QTAMQ
	ENDIF
	IF M.ORD_UM = 'ML'
	   M.ORD_QTAORD = M.ORD_QTAML
	ENDIF
	IF M.ORD_UM = 'MC'
	   M.ORD_QTAORD = M.ORD_QTAMC
	ENDIF

	VPRE         = M.ORD_PREZZO
	VPRE         = VPRE-ROUND((VPRE*M.ORD_SC1/100),6)
	VPRE         = VPRE-ROUND((VPRE*M.ORD_SC2/100),6)
	VPRE         = VPRE-ROUND((VPRE*M.ORD_SC3/100),6)
	VPRE         = VPRE-ROUND((VPRE*M.ORD_SC4/100),6)
	VPRE         = VPRE-ROUND((VPRE*M.ORD_SC5/100),6)
	M.ORD_PRZNET = VPRE
	M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
	*M.ORD_VALORE = ROUND((M.ORD_PRZNET*M.ORD_QTAORD),2)
	M.ORD_VALORE = CALCOLA_VALORE_RIGA_DOCUMENTO(M.ORD_PRZNET,M.ORD_QTAORD)  && ERASMO - 29/11/2011
	
	IF !CHECKNUM(M.ORD_VALORE,17,3)
   		_cErrore = "OVERFLOW PER IL VALORE CALCOLATO - RIGA ORDINE NON IMPORTATA"
   		DO MEMORIZZA_ERRORE_CONV_ORDINI WITH _cErrore
   		SELECT XILOPAN_PO
   		SKIP +1
   		LOOP
	ENDIF
	
	IF M.ORD_VALORE <= 0
   		_cErrore = "VALORE CALCOLATO UGUALE A ZERO - RIGA ORDINE NON IMPORTATA"
   		DO MEMORIZZA_ERRORE_CONV_ORDINI WITH _cErrore
   		SELECT XILOPAN_PO
   		SKIP +1
   		LOOP
	ENDIF
	
	IF ABS(M.o_importo - M.ORD_VALORE) > 1
   		_cErrore = "VALORE CALCOLATO (" + ALLTRIM(STR(M.ORD_VALORE,17,2)) + ") CON ECCESSIVA DIFFERENZA RISPETTO AL FILE SORGENTE (" + ;
   			ALLTRIM(STR(M.o_importo,17,2)) + ") - RIGA ORDINE IMPORTATA E DA VERIFICARE"
   		DO MEMORIZZA_ERRORE_CONV_ORDINI WITH _cErrore
	ENDIF
	
	SELECT CU_ORD_DD
	
	M.ORD_NOTEPRO = M.NOTEPRO
	M.ORD_NOTESPE = M.NOTESPE
	M.ORD_NOTEVAR = M.NOTEVAR
	M.ORD_SEQUEN = V_SEQUEN
	   
	M.DAGGANCIO  = M.TAGGANCIO
	M.ORS_NUMORD = M.ORD_NUMORD
	M.ORS_DATORD = M.ORD_DATORD
	M.ORS_CODCLI = M.ORD_CODCLI
	M.ORS_RAGSOC = M.ORD_RAGSOC
	M.ORS_CODEMI = ""
	M.ORS_RAGEMI = ""
	M.ORD_SALCON = ""
	M.ORD_CHIUSO = .F.
	
	SELECT CU_ORD_DD
	APPEND BLANK      
	GATHER MEMVAR MEMO
		
	_CONTADET = _CONTADET + 1
	
	SELECT XILOPAN_PO
	SKIP +1
ENDDO

WAIT WINDOWS "Finalizzazione importazione ordini clienti..." NOWAIT

*** VERIFICA TESTATE ORDINI ZOPPE IN CURSORE CU_ORD_TT E RICALCOLO VALORE TOTALE DOCUMENTO PRIMA DELLA MEMORIZZAZIONE IN DB SQL
SELECT CU_ORD_TT
SCAN
	_TAGGANCIO = TAGGANCIO
	SELECT CU_ORD_DD
	SET FILTER TO ALLTRIM(DAGGANCIO) == ALLTRIM(_TAGGANCIO)
	SET ORDER TO
	GO TOP
	IF EOF()
		SELECT CU_ORD_TT
		DELETE
		_CONTATES = _CONTATES - 1
	ENDIF
	
	DO CALCORD
	SELECT CU_ORD_TT
	REPLACE ORD_VALORE WITH M.ORD_VALORE
ENDSCAN
SELECT CU_ORD_DD
SET FILTER TO
SET ORDER TO
GO TOP

*** SCRITTURA ORDINI IN TABELLE SQL
IF !ExecRW('','u_ord_tt','I','','CU_ORD_TT')		&& INSERIMENTO RIGHE DI TESTATA
   return(.f.)
ENDIF

IF !ExecRW('','u_ord_dd','I','','CU_ORD_DD')		&& INSERIMENTO RIGHE DI DETTAGLIO		
   return(.f.)
ENDIF

WAIT CLEAR

MESSAGEBOX("OPERAZIONE TERMINATA: " + CHR(13) + CHR(13) + ;
	"Totale testate ordini: " + ALLTRIM(STR(_CONTATES)) + CHR(13) + ;
	"Totale dettagli ordini: " + ALLTRIM(STR(_CONTADET)),64,"Informazione")

SET DEFAULT TO &PUB_DIR

SELECT CUR_ERRORI
SET ORDER TO I_ORDINA
GO TOP
IF !EOF()
	_RISP = MESSAGEBOX("Rilevati alcuni errori durante l'importazione ordini" + CHR(13) + CHR(13) + ;
		"Estrarre un foglio excel con il dettaglio degli errori riscontrati?",48+4,"Attenzione")
	DO ESTRXLS WITH "CUR_ERRORI","Dettaglio errori importazione ordini del " + DTOC(DATE()),"",""
ENDIF

RETURN


*!*	**********************************
*!*	FUNCTION CREA_RIGA_DETTAGLIO
*!*	**********************************
*!*	PARA  _DAGGANCIO

*!*	      V_SEQUEN     = V_SEQUEN + 10


*!*	      M.ORD_DESART = M.DESART   
*!*		  M.ORD_QTAORD = M.QTAMC



*!*	      M.ORD_CODART = ""
*!*	      M.ORD_CODART = CERCA_ARTICOLO_IN_PO(M.ORD_codcli,M.ORD_numord,M.ORD_datord,ARTICOLO_PARZIALE)

*!*		  M.ORD_NOTEPRO = M.NOTEPRO
*!*		  M.ORD_NOTESPE = M.NOTESPE
*!*		  M.ORD_NOTEVAR = M.NOTEVAR   
*!*	      

*!*	      M.ORD_SEQUEN = V_SEQUEN
*!*	         
*!*	      M.DAGGANCIO  = M.TAGGANCIO         
*!*	      M.ORD_PESOUM = 0
*!*	      M.ORD_CODIMB = SPACE(3)
*!*	      M.ORD_IMBNET = 0
*!*	      M.ORD_IMBLOR = 0
*!*	      M.ORD_FLGCOM = .F.
*!*	      M.ORD_PADRE  = SPACE(16)
*!*	      M.ORS_VALUTA = SPACE(3)
*!*	      M.ORD_NUMBOL = SPACE(6)
*!*	      M.ORD_DATBOL = SPACE(10)
*!*	      M.ORD_QTABOL = 0
*!*	      M.ORD_QTADAC = 0
*!*	      M.ORD_FLFATD = .F.
*!*	      M.ORD_CODTAG = SPACE(3)
*!*	      M.ORD_DESTAG = SPACE(30)
*!*	      M.ORD_CODCOL = SPACE(3)
*!*	      M.ORD_DESCOL = SPACE(30)
*!*	      M.ORD_TRASMD = .F.
*!*	      M.ORD_QTAACC = 0
*!*	      M.ORD_LEGSYS = SPACE(10)
*!*	      M.ORD_FLGMOD = SPACE(1)
*!*	      M.ORD_CODMAT = SPACE(3)
*!*	      M.ORD_DESMAT = SPACE(30)
*!*	      M.ORD_SPESSO = 0
*!*	      M.ORD_ALTEZZ = 0
*!*	      M.ORD_LUNGHE = 0
*!*	      M.ORD_NUMBOB = 0
*!*	      M.ORD_NUMBOE = 0
*!*	      M.ORD_NUMBOD = 0
*!*	      M.ORD_QTAKG  = 0
*!*	      M.ORD_QTAMQ  = 0
*!*	      M.ORD_QTAML  = 0
*!*	      M.ORD_QTAKG1 = 0
*!*	      M.ORD_QTAMQ1 = 0
*!*	      M.ORD_QTAML1 = 0
*!*	      M.ORD_QTAKGE = 0
*!*	      M.ORD_QTAMQE = 0
*!*	      M.ORD_QTAMLE = 0
*!*	      M.ORD_QTAKGD = 0
*!*	      M.ORD_QTAMQD = 0
*!*	      M.ORD_QTAMLD = 0
*!*	      M.ORD_CONFER = SPACE(1)
*!*	      M.ORD_SALCON = SPACE(1)
*!*	      M.ORD_NOTEBO = ""
*!*	      M.ORD_DESIMB = SPACE(30)
*!*	      M.ORD_LOTMIN = 0
*!*	      M.ORD_DTINPR = SPACE(10)
*!*	      M.ORD_DTFIPR = SPACE(10)
*!*	      M.ORD_FLGPRG = 0
*!*	      M.ORD_FLGAVA = 0
*!*	      M.ORD_NUMPRG = SPACE(6)
*!*	      M.ORD_DATPRG = SPACE(10)
*!*	      M.ORD_SEIPRG = SPACE(7)
*!*	      M.ORD_SEFPRG = SPACE(7)
*!*	      M.ORD_DAIPRG = SPACE(10)
*!*	      M.ORD_DAFPRG = SPACE(10)
*!*	      M.ORD_NRBOBP = 0
*!*	      M.ORD_QUANTP = 0
*!*	      M.ORD_NRBOBF = 0
*!*	      M.ORD_QUANTF = 0
*!*	      M.ORD_NRBOBD = 0
*!*	      M.ORD_QUANTD = 0
*!*	      M.ORD_SETTPR = SPACE(7)
*!*	      M.ORD_SETTCC = SPACE(7)
*!*	      M.ORD_NRBOBX = 0
*!*	      M.ORD_QUANTX = 0
*!*	      M.ORD_SETTCX = SPACE(7)
*!*	      M.ORD_NRBOBO = 0
*!*	      M.ORD_QUANTO = 0
*!*	      M.ORD_NRBOBY = 0
*!*	      M.ORD_QUANTY = 0
*!*	      M.ORD_NRBSPD = 0
*!*	      M.ORD_QTASPD = 0
*!*	      M.ORD_NRBSPP = 0
*!*	      M.ORD_QTASPP = 0
*!*	      M.ORD_NRBRID = 0
*!*	      M.ORD_QTARID = 0
*!*	      M.ORD_NRBRIP = 0
*!*	      M.ORD_QTARIP = 0
*!*	      M.ORD_NRBTGO = 0
*!*	      M.ORD_QTATGO = 0
*!*	      M.ORD_NRBTGD = 0
*!*	      M.ORD_QTATGD = 0
*!*	      M.ORD_NRBTGP = 0
*!*	      M.ORD_QTATGP = 0
*!*	      M.ORD_CDAPRD = SPACE(16)
*!*	      M.ORD_DSAPRD = SPACE(50)
*!*	      M.ORS_FLGABP = .F.
*!*	      M.ORD_FLGCEL = .F.
*!*	      M.ORD_SERBOL = SPACE(3)
*!*	      M.ORD_AAPROD = 0
*!*	      M.ORD_SERNUM = SPACE(3)
*!*	      M.ORD_NUMEDA = 0
*!*	      M.ORD_NUMEAL = 0
*!*	      M.ORD_CBFISC = SPACE(50)
*!*	      M.ORD_PKLOK  = SPACE(1)
*!*	      M.ORD_QTAPCK = 0
*!*	      M.ORD_PUBBLI = SPACE(1)

*!*	      *** VALORI DI DEFAULT
*!*	      M.ORD_CODSYS = SYS(2015)
*!*	      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
*!*	      x_codi = "art_codpri = '" + M.ORD_CODART + "'"
*!*	      x_cond = x_soci + " and " + x_codi
*!*	      cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
*!*	      IF !ExecCommand(cSql,"CUR_ARTICOLI")
*!*	         RETURN .F.
*!*	      ENDIF
*!*	      SELECT CUR_ARTICOLI
*!*	      GO TOP
*!*	      IF !EOF()
*!*	         M.ORD_CODMAT = ART_CODMAT
*!*	         M.ORD_DESMAT = ART_DESMAT
*!*	         M.ORD_CODCOL = ART_CODCOL
*!*	         M.ORD_DESCOL = ART_DESCOL
*!*	         M.ORD_SPESSO = ART_SPESSO
*!*	         M.ORD_ALTEZZ = ART_ALTEZZ
*!*	         M.ORD_LUNGHE = ART_LUNGHE
*!*	         M.ORD_CODIMB = ART_CODIMB
*!*	         M.ORD_DESIMB = ART_DESIMB
*!*	         M.ORD_LOTMIN = ART_LOTMIN
*!*	      ENDIF
*!*	      
*!*	      M.ORS_NUMORD = M.ORD_NUMORD
*!*	      M.ORS_DATORD = M.ORD_DATORD
*!*	      M.ORD_MAGA   = "SEDE"
*!*	      M.ORS_MAGA   = "SEDE"
*!*	      M.ORS_MAGS   = "SEDE"      
*!*	      M.ORS_MAGD   = ""
*!*	      M.ORS_CODCLI = M.ORD_CODCLI
*!*	      M.ORS_RAGSOC = M.ORD_RAGSOC
*!*	      M.ORS_CODEMI = ''
*!*	      M.ORS_RAGEMI = ''
*!*	*!*	      M.ORS_TIPORD = X_TIPORD
*!*	*!*	      M.ORS_DESTIN = ''
*!*	*!*	      M.ORS_FLGABP = X_FLGABP
*!*	      M.ORD_CDAPRD = M.ORD_CODART
*!*	      M.ORD_DSAPRD = M.ORD_DESART      
*!*	      
*!*	*!*	      IF _X_CHIUSOTT
*!*	*!*	         M.ORD_SALCON = 'S'
*!*	*!*	      ELSE
*!*	*!*	         IF _X_CHIUSODD
*!*	*!*	            M.ORD_SALCON = 'S'
*!*	*!*	         ELSE
*!*	*!*	            IF M.ORD_QTAEV >= M.ORD_QTAORD
*!*	*!*	               M.ORD_SALCON = 'S'
*!*	*!*	            ENDIF
*!*	*!*	         ENDIF
*!*	*!*	      ENDIF
*!*	      
*!*	      
*!*	      
*!*	      
*!*	      SELECT CU_ORD_DD
*!*	      APPEND BLANK      
*!*	      GATHER MEMVAR MEMO
*!*	      

*!*	 

*!*	RETURN 




************************************
FUNCTION CARICA_PO_IN_FORMATO_TESTO
************************************

*=OPENDB("XILOPAN_PO")
SELECT XILOPAN_PO
SET ORDER TO I_ORDINE
GO TOP

SELECT IMPORTATXT 
GO top
DO WHILE .NOT.EOF()

    IF DELETED()
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 
    
    
    
    IF SUBSTR(CAMPO1,1,09) = "     Data" 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,1,09) = "** Sono e" 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


    IF SUBSTR(CAMPO1,1,09) = "---------" 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


    IF SUBSTR(CAMPO1,1,09) = "Codice Ra" 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(ALLTRIM(CAMPO1),1,09) = "---------" 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,1,09) = "=========" 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(ALLTRIM(CAMPO1),1,09) = "TOTALE CL" 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


    IF SUBSTR(ALLTRIM(CAMPO1),1,09) = "TOTALE PO" 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


    IF !EMPTY(ALLTRIM(SUBSTR(CAMPO1,01,06)))
    	M.o_codcli = TRC(PUB_LCL,ALLTRIM(SUBSTR(CAMPO1,01,06)))
    	M.o_ragsoc = ALLTRIM(SUBSTR(CAMPO1,08,35))  
    ENDIF 
 
    M.o_anno   = "20"+ALLTRIM(SUBSTR(CAMPO1,44,02))

	PUB_LNO      = 6
	M.o_numord = TRC(PUB_LNO,ALLTRIM(SUBSTR(CAMPO1,47,06)))
    

    M.o_datord = ALLTRIM(SUBSTR(CAMPO1,54,10))
    IF LEN(M.o_datord) = 9
    	M.o_datord = "0"+M.o_datord
    ENDIF 
    M.o_datord  = ribalta2(M.o_datord)    

    M.o_dtcons = ALLTRIM(SUBSTR(CAMPO1,65,10))
    IF LEN(M.o_dtcons) = 9
    	M.o_dtcons= "0"+M.o_dtcons
    ENDIF 
    M.o_dtcons = ribalta2(M.o_dtcons)    
  
    M.o_codart = ALLTRIM(SUBSTR(CAMPO1,76,15))    
    M.o_desart = ALLTRIM(SUBSTR(CAMPO1,92,42))
    
    M.o_qtaord = ALLTRIM(SUBSTR(CAMPO1,135,12))   
	M.o_qtaord = STRTRAN(M.o_qtaord,".","")   
	*M.o_qtaord = STRTRAN(M.o_qtaord,",",".")
	M.o_qtaord = VAL(M.o_qtaord)   
	
    M.o_qtacons= ALLTRIM(SUBSTR(CAMPO1,151,12))   
	M.o_qtacons= STRTRAN(M.o_qtacons,".","")   
	*M.o_qtacons= STRTRAN(M.o_qtacons,",",".")
	M.o_qtacons= VAL(M.o_qtacons)   

    M.o_rimanen= ALLTRIM(SUBSTR(CAMPO1,167,12))   
	M.o_rimanen= STRTRAN(M.o_rimanen,".","")   
	*M.o_rimanen= STRTRAN(M.o_rimanen,",",".")
	M.o_rimanen= VAL(M.o_rimanen)   
	
    M.o_importo= ALLTRIM(SUBSTR(CAMPO1,185,12))   
	M.o_importo= STRTRAN(M.o_importo,".","")   
	*M.o_importo= STRTRAN(M.o_importo,",",".")
	M.o_importo= VAL(M.o_importo)   
				

 
    
	SELECT XILOPAN_PO	
	APPEND BLANK
	GATHER MEMVAR memo
	


	SELECT IMPORTATXT 
	SKIP +1
	
ENDDO

RETURN 



*!*	*****************************
*!*	FUNCTION CERCA_ARTICOLO_IN_PO
*!*	*****************************
*!*	PARA _O_codcli,_O_numord,_O_datord,_ARTICOLO_PARZIALE 


*!*	M.ORD_CODART = ""

*!*	SET NEAR ON

*!*	_SEEK = ALLTRIM(_O_codcli)+ALLTRIM(_O_numord)+_O_datord		 
*!*	SELECT XILOPAN_PO
*!*	SET ORDER TO I_ORDINE

*!*	SEEK _SEEK
*!*	DO WHILE !EOF()
*!*		
*!*		IF _O_codcli <> O_codcli
*!*			EXIT
*!*		ENDIF
*!*			
*!*		IF _O_numord <> O_numord
*!*			EXIT
*!*		ENDIF

*!*		IF _O_datord<> O_datord
*!*			EXIT
*!*		ENDIF


*!*	    LEN_O_CODART = LEN(o_codart)
*!*	    _o_codart1 = ALLTRIM(SUBSTR(o_codart,2,LEN_O_CODART))
*!*	    LEN_O_CODART1 = LEN(_o_codart1)
*!*	    LEN_O_CODART1X = LEN_O_CODART1  - 1
*!*	    _o_codart2 = ALLTRIM(SUBSTR(_o_codart1,1,LEN_O_CODART1X))
*!*	    


*!*		IF 	_ARTICOLO_PARZIALE = _o_codart2
*!*			M.ORD_CODART = o_codart
*!*			EXIT
*!*		ENDIF  
*!*			


*!*		SELECT XILOPAN_PO
*!*		SKIP +1

*!*	ENDDO



*!*	SET NEAR OFF

*!*	RETURN(M.ORD_CODART)


**************************************
PROCEDURE MEMORIZZA_ERRORE_CONV_ORDINI
**************************************
LPARAMETERS _par_errore

SELECT CUR_ERRORI
APPEND BLANK
REPLACE CODCLI WITH M.ORD_CODCLI 
REPLACE RAGSOC WITH M.ORD_RAGSOC 
REPLACE NUMORD WITH M.ORD_NUMORD 
REPLACE DATORD WITH RIBALTA2(M.ORD_DATORD)
REPLACE CODART WITH M.ORD_CODART
REPLACE DESART WITH M.ORD_DESART
REPLACE ERRORE WITH ALLTRIM(_par_errore)

ENDPROC
