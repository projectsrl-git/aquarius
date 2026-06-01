*************************************************************************************************
*							CARICAMENTO ANAGRAFICA ARTICOLI										*
*							 																	*
*************************************************************************************************

RELEASE V_TROVDIBA
PUBLIC  V_TROVDIBA
V_TROVDIBA = .F.

*** conferma utente

RIT = MESSAGEBOX("Procedo con il caricamento "+CHR(13)+"dell'anagrafica articoli	 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

** ASSEGNAZIONE DELLA VARIABILE PATH **************************



*!*	=OPENDB("PERCORSO")
*!*	SELECT PERCORSO
*!*	SET ORDER TO I_TIPO
*!*	SEEK 'ART'
*!*	IF FOUND()
*!*	ELSE
*!*	   RETURN
*!*	ENDIF

*!*	SELECT PERCORSO
*!*	V_PATH = ALLTRIM(PER_PATH)
		
****** DEFINIZIONE DEL CURSORE STP

IF !ExecCommand("select * from U_ART_PR where 1=0","curs_u_art_pr")
   return
ENDIF
SELECT curs_u_art_pr
=DEFPUB(SELECT())

WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA ARTICOLI" NOWAIT


*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_ART_PR SQL

__SOC= "01"
__ART= "." 
x_soci = "art_codsoc = '" + __SOC + "'"
x_codi = "art_codpri <> '" + __ART + "'"
x_cond = x_soci + " and " + x_codi

cSql   = "delete from u_art_pr where " + x_cond 
IF !ExecCommand(cSql,"U_ART_PR")
   return(.f.)
ENDIF






*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL - COLORI

*!*	cSql = "delete from PARA where codice like 'COL%'"
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF
*!*	cSql = "select * from PARA where 1=0"
*!*	IF !ExecRW(cSql,"PARA","R")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT PARA
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLTRA'
*!*	REPLACE DESCRI WITH 'TRASPARENTE'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLB/N'
*!*	REPLACE DESCRI WITH 'BIANCO/NERO'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLV/N'
*!*	REPLACE DESCRI WITH 'VERDE/NERO'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLBLU'
*!*	REPLACE DESCRI WITH 'BLU'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLGIA'
*!*	REPLACE DESCRI WITH 'GIALLO'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLRSE'
*!*	REPLACE DESCRI WITH 'ROSè'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLVER'
*!*	REPLACE DESCRI WITH 'VERDE'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLRSA'
*!*	REPLACE DESCRI WITH 'ROSA'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLBIA'
*!*	REPLACE DESCRI WITH 'BIANCO'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLARA'
*!*	REPLACE DESCRI WITH 'ARANCIONE'
*!*	APPEND BLANK
*!*	REPLACE CODICE WITH 'COLVBN'
*!*	REPLACE DESCRI WITH 'VERDE/BIANCO/NERO'
*!*	IF !ExecRW(cSql,"PARA","W")
*!*	   return(.f.)
*!*	ENDIF

******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

RELEASE Y_CAMPO,V_CAMPO,_CTR,_PROGRE
PUBLIC Y_CAMPO,V_CAMPO,_CTR,_PROGRE
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0
_PROGRE = ""

CREATE CURSOR TRANSITO (TRA_RECORD C(200))

**** CARICAMENTO DEL FILE IN FORMATO TESTO SE NON SI USA LA GETFILE

*!*	SELECT TRANSITO
*!*	APPEND FROM &V_PATH SDF


gcTable = GETFILE('', 'Seleziona file articoli da caricare', 'Carica articoli',0)
IF empty(gcTable) .or. gcTable = ""
   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF
SELECT TRANSITO  
APPEND FROM &gcTable SDF
GO TOP

***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT TRANSITO
GO TOP

_CONTA = 0


DO WHILE .T.

   	IF EOF()
      EXIT
   	ENDIF

   	SELECT TRANSITO


*!*	    IF ALLTRIM(SUBSTR(TRA_RECORD,1,1)) = '*'  && SCARTA I RECORD ANNULLATI
*!*	      SELECT TRANSITO
*!*	      SKIP+1
*!*	      LOOP
*!*	    ENDIF
    
    
    
*!*	DEFINIZIONE VARIABILI DI DEFAULT

   	=DEFINISCE_VARIABILI_DI_DEFAULT()
   

*!*	CARICA LE VARIABILI DAL CURSORE DINAMICO DI INPUT


   	SELECT TRANSITO
   	
	DO CASE
	
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "BTI"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "DIS"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "ELV"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "FOS"
				=CARICA_ARTICOLI_BASE()	
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "FRA"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "GEW"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "GOC"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "IBO"
				=CARICA_ARTICOLI_BASE()	
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "ITC"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "OBO"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "OSR"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "PHL"
				=CARICA_ARTICOLI_BASE()	
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "RLC"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "SAT"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "VIW"
				=CARICA_ARTICOLI_BASE()
		CASE ALLTRIM(SUBSTR(TRA_RECORD,01,03))	= "VOR"
				=CARICA_ARTICOLI_BASE()	

		
		
		
		OTHERWISE	
	
		   SELECT TRANSITO 
		   SKIP +1     
		   LOOP	

	
	ENDCASE 
	 
 
          
 
 
   SELECT curs_u_art_pr				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

      												   
   _CONTA = _CONTA +1
   _CTR = _CTR +1


   SELECT TRANSITO 
   SKIP +1     
		  
ENDDO


SELECT curs_u_art_pr
GO TOP


****** AGGIORNA TABELLA U_ART_PR SQL

WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

IF !ExecRW('','U_ART_PR','I','','curs_u_art_pr')
   return(.f.)
ENDIF
	 
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN





*****************************
FUNCTION CARICA_ARTICOLI_BASE
*****************************

   WAIT WINDOWS "ARTICOLI FORNITORE : "+ALLTRIM(SUBSTR(TRA_RECORD,01,3))+" IN ELABORAZIONE " NOWAIT		
   
   
   M.ART_CODPRI = ALLTRIM(SUBSTR(TRA_RECORD,01,3))+ALLTRIM(SUBSTR(TRA_RECORD,13,13))
   IF SUBSTR(M.ART_CODPRI,4,1) = '*'
   	M.ART_CODPRI = SUBSTR(M.ART_CODPRI,5,16)
   ENDIF
   IF SUBSTR(M.ART_CODPRI,4,1) = '*'
   	M.ART_CODPRI = SUBSTR(M.ART_CODPRI,5,16)
   ENDIF
   
   M.ART_CODPRI = UPPER(M.ART_CODPRI)
   M.ART_CODPRI = APITOSPA(M.ART_CODPRI)
   M.ART_DESCR  = ALLTRIM(SUBSTR(TRA_RECORD,33,60))
   M.ART_DESCR  = UPPER(M.ART_DESCR)
   M.ART_DESCR  = APITOSPA(M.ART_DESCR)
   M.ART_DESEST = SPACE(40)
   M.ART_DESRID = SPACE(20)
   M.ART_UNIMIS  = 'NR'
   M.ART_UMMAGA  = 'NR'
   M.ART_CODF1 = SPACE(10)
   M.ART_NOTA1 = SPACE(10)
   M.ART_CODF2 = SPACE(10)
   M.ART_NOTA2 = SPACE(10)
   M.ART_CODF3 = SPACE(10)
   M.ART_NOTA3 = SPACE(10)

  
*!*	   prezzo per confezione
*!*	   INTERO=""
*!*	   INTERO=	ALLTRIM (SUBSTR(TRA_RECORD,104,10))
*!*	   DECIMALE=""
*!*	   DECIMALE=ALLTRIM (SUBSTR(TRA_RECORD,115,3))

*!*	   prezzo unitario
   INTERO=""
   INTERO=	ALLTRIM (SUBSTR(TRA_RECORD,125,10))
   DECIMALE=""
   DECIMALE=ALLTRIM (SUBSTR(TRA_RECORD,136,3))
   

   PREZZO_RICAVO = INTERO + '.' + DECIMALE
   M.ART_PRZVEN = VAL (PREZZO_RICAVO)
   
   
   M.ART_PRZVE2 = 0
   M.ART_PRZVE3 = 0
   M.ART_PRZVE4 = 0
   M.ART_PRZCOS = 0

 



RETURN





****************************************
FUNCTION DEFINISCE_VARIABILI_DI_DEFAULT
****************************************

   M.ID_UNIQUE = ''
   M.ART_CODSOC = PUB_CODSOC
   M.ART_CODPRI = ''
   M.ART_DESCR  = ''
   M.ART_DESEST = ''
   M.ART_UNIMIS = ''
   M.ART_LINEA  = PUB_LINEA
   M.ART_PRZVEN = 0
   M.ART_PRZVE2 = 0
   M.ART_PRZVE3 = 0
   M.ART_PRZVE4 = 0
   M.ART_PRZVE5 = 0
   M.ART_PRZCOS = 0
   M.ART_CODIVA = PUB_IVA
   M.ART_MAGA   = PUB_CODM
   M.ART_PESOUM = 0
   M.ART_CGE    = ''
   M.ART_CODF1  = ''
   M.ART_CODF2  = ''
   M.ART_CODF3  = ''
   M.ART_NOTA1  = ''
   M.ART_NOTA2  = ''
   M.ART_NOTA3  = ''
   M.ART_PRZCO1 = 0
   M.ART_PRZCO2 = 0
   M.ART_PRZCO3 = 0
   M.ART_DATINS = RIBALTA2(DTOC(DATE()))
   M.ART_CODVAL = PUB_VALU
   M.ART_ULDCAR = ''
   M.ART_ULPCAR = 0
   M.ART_CATMER = ''
   M.ART_DESMER = ''
   M.ART_CODMAT = ''
   M.ART_DESMAT = ''
   M.ART_CODIMB = ''
   M.ART_DESIMB = ''
   M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
   M.ART_CODMAT = ''
   M.ART_DESMAT = ''
   M.ART_TIPART = 'A'
   M.ART_DISBAS = 'S'
   M.ART_RIPCOM = 'S'
   M.ART_CODCOL = ''
   M.ART_DESCOL = ''
   M.ART_DESRID = ''
   M.ART_SPESSO = 0
   M.ART_ALTEZZ = 0
   M.ART_LUNGHE = 0
   M.ART_LOTMIN = 0
   M.ART_CDDIBA = ''
   M.ART_DSDIBA = ''
   M.ART_UMMAGA = ''
   

   	m.art_serie  = ''
	M.art_dserie = ''	
	m.art_catben = ''
	M.art_desben = ''
	m.art_deslin = ''
	m.art_obsol = ''
	M.art_coord1 = ''
	m.art_basade = ''
	m.art_codcat = ''
	M.art_descat = ''
	m.ART_CSTCAT = ''
	M.ART_DSTCAT = ''
	M.ART_GRUPRD = ''
	M.ART_FORMUL = ''
	m.art_notprd = ''
	m.art_tipopr = ''
	M.art_des_i = ''
	M.art_des_f = ''
	M.art_des_t = ''
	M.art_des_s = ''
	M.art_barfor = ''
	M.art_barcli = ''
	M.art_nultre = ''
	M.ART_CODF4 = ''
	M.ART_NOTA4 = ''
	M.ART_CODF5 = ''
	M.ART_NOTA5 = ''
	M.ART_ULNSCA = ''
	M.ART_ULNCAR = ''
	m.art_gruedi = ''
	m.art_editor = ''
	M.art_CDISBN = ''
	m.art_collan = ''
	m.art_CATAGO = ''
	m.art_autore = ''
	m.art_argome = ''
	m.art_codpac = ''
	M.ART_DESPAC = ''
	M.ART_TIPCOM = ''
	M.ART_DESCOM = ''
	M.ART_SERNUM = ''
	M.ART_NOTCOM = ''
	M.ART_CODOPE = ''
	M.ART_DESOPE = ''
	M.ART_CLITAG1 = ''
	M.ART_DSCLIT1 = ''
	M.ART_CODITG1 = ''
	M.ART_DESCTG1 = ''
	M.ART_CLITAG2 = ''
	M.ART_DSCLIT2 = ''
	M.ART_CODITG2 = ''
	M.ART_DESCTG2 = ''
	M.ART_CLITAG3 = ''
	M.ART_DSCLIT3 = ''
	M.ART_CODITG3 = ''
	M.ART_DESCTG3 = ''
	M.ART_CLITAG4 = ''
	M.ART_DSCLIT4 = ''
	M.ART_CODITG4 = ''
	M.ART_DESCTG4 = ''
	M.ART_CLITAG5 = ''
	M.ART_DSCLIT5 = ''
	M.ART_CODITG5 = ''
	M.ART_DESCTG5 = ''
	




	M.ART_TIPO   = SPACE(02)
	M.ART_LUNG   = SPACE(02)
	M.ART_LARG   = SPACE(02)
	M.ART_COLORE = SPACE(02)
	M.ART_LAVORA = SPACE(02)
	M.ART_QTACON = 0
	M.ART_SCORMI = 0
	M.ART_PESOKG = 0
	M.ART_MEDIA  = 0
	M.ART_MEDIA2 = 0
	M.ART_CLDOG  = SPACE(02)
	M.ART_GRUPPO = .F.
	M.ART_SCORMA = 0
	M.ART_CONTA  = 0
	M.ART_NOTE   = SPACE(02)
	M.ART_NOTE1  = SPACE(02)
	M.ART_PUBBLI = SPACE(01)
	M.ART_TRASME = SPACE(02)
	M.SELEZIONE  = SPACE(02)
	M.ART_VENMED = 0
	M.ART_DISEGN = SPACE(02)
	M.ART_CCO    = SPACE(02)
	M.ART_CODCTL = SPACE(02)
	M.ART_SINTE  = SPACE(02)
	M.ART_CGEAMM = SPACE(02)
	M.ART_CPCAMM = SPACE(02)
	M.ART_COORD  = SPACE(02)
	M.ART_ULDSCA = space(02)
	M.ART_ULQSCA = 0
	M.ART_ULPSCA = 0
	M.ART_ULQCAR = 0
	M.ART_TOTSCA = 0
	M.ART_TOTCAR = 0
	M.ART_PROVVI = 0
	M.ART_CSTMAT = 0
	M.ART_CSTLAV = 0
	M.ART_TMPLAV = 0
	M.ART_MDCPER = 0
	M.ART_MDCQF  = 0
	M.ART_LOTTO  = 0
	M.ART_INTERA = 0
	M.ART_NUMDEN = 0
	M.ART_MODULO = 0
	M.ART_CODDIS = SPACE(02)
	M.ART_REVDIS = SPACE(02)
	M.ART_DATVAR = space(02)
	M.ART_CODCLI = SPACE(02)
	M.ART_RAGSOC = SPACE(02)
	M.ART_MODELL = SPACE(02)
	M.ART_MATERI = SPACE(02)
	M.ART_MISURE = SPACE(02)
	M.ART_DESPES = SPACE(02)
	M.ART_NOTVAR = SPACE(02)
	M.ART_NUMCOM = SPACE(02)
	M.ART_DATCOM = space(02)
	M.ART_DATCON = space(02)
	M.ART_PEZZI  = 0
	M.ART_TPARTI = space(02)
	M.ART_CODUPL = space(02)
	M.ART_DSDUPL = space(02)
	M.ART_DTDUPL = space(02)
	M.ART_CICLO  = .F.
	M.ART_CSTMAN = 0
	M.ART_CSTMAC = 0
	M.ART_CODTAG = space(02)
	M.ART_DESTAG = space(02)
	M.ART_PRZETI = 0
	M.ART_PRZCOP = 0
	M.ART_SC1    = 0
	M.ART_SC2    = 0
	M.ART_SC3    = 0
	M.ART_PROSPE = .F.
	M.ART_QTASPE = 0
	M.ART_PRESPE = 0
	M.ART_FLGRES = .F.
	M.ART_NUMRES = 0
	M.ART_DATRES = space(02)
	M.ART_NONMOV = .F.
	M.ART_DESGRE = space(02)
	M.ART_DESEDI = space(02)
	M.ART_DESCOA = space(02)
	M.ART_PRZIVA = 0
	M.ART_FLGMOD = space(02)
	M.ART_LEGSYS = space(02)
	M.ART_FLGMIM = .F.
	M.ART_CODMAR = space(02)
	M.ART_DESMAR = space(02)
	M.ART_CODFOR = space(02)
	M.ART_DESFOR = space(02)
	M.ART_NUMDOC = space(02)
	M.ART_DATDOC = space(02)
	M.ART_FLGTRA = .F.
	M.ART_AMMORT = space(02)
	M.ART_VALORE = 0
	M.ART_DTUTIL = space(02)
	M.ART_DTCEBE = space(02)
	M.ART_CODPOL = space(02)
	M.ART_DESPOL = space(02)
	M.ART_NAZMER = space(02)
	M.ART_PEDLAR = 0
	M.ART_PEDLUN = 0
	M.ART_PEDALT = 0
	M.ART_PRZCO4 = 0
	M.ART_PRZCO5 = 0
	M.ART_TIPADE = space(02)
	M.ART_ADESIV = space(02)
	M.ART_ROTLNG = space(02)
	M.ART_ROTTRA = space(02)
	M.ART_ALNLNG = space(02)
	M.ART_ALNTRA = space(02)
	M.ART_COSLAI = 0
	M.ART_COSLAE = 0
	M.ART_COSMAT = 0
	M.ART_COSATR = 0
	M.ART_RICLAI = 0
	M.ART_RICLAE = 0
	M.ART_RICMAT = 0
	M.ART_RICATR = 0
	M.ART_TIPOPR = space(02)
	M.ART_ORELAV = space(02)
	M.ART_OREATT = space(02)
	M.ART_OREIMP = space(02)
	M.ART_SECIMP = 0
	M.ART_SECLAV = 0
	M.ART_SECATT = 0
	M.ART_PESOSP  = 0
	M.ART_BASADE  = space(02)
	M.ART_MICROF  = .F.
	M.ART_GRAMMA  = 0
	M.ART_TOLGRA  = 0
	M.ART_PERCOP  = 0
	M.ART_TIPDOC  = space(02) 
	M.ART_DSTDOC  = space(02) 
	M.ART_MICROL  = space(02) 
	M.ART_SCOFIS  = 0
	M.ART_PRVFIS  = 0
	M.ART_QPKMIN  = 0
	M.ART_QPKMAX  = 0
	M.ART_SCFIS2  = 0
	M.ART_SCFIS3  = 0	
	M.ART_BARCOD = SPACE(02)
	M.ART_CODCON = SPACE(02)


RETURN
   

