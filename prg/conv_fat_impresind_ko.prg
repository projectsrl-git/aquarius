*************************************************************************************************
*									CONVERSIONE ORDINI CLIENTI									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2017: Impresind				 														*
*************************************************************************************************


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "IMP"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'IMP' non configurato" + CHR(13) + CHR(13) + ;
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

RIT = MESSAGEBOX("Conversione fatture clienti da .DBF: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF




SET DEFAULT TO &V_PATH

**** CARICAMENTO DEL FILE IN FORMATO DBF
gcFile = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0
__ORD_NPROT = SPACE(06)
																							
				

CREATE CURSOR IMPORTADBF ( ;
	mvtipdoc	C(100), ;
	catego		C(100), ;
	mvdatdoc	C(100), ;
	mvnumdoc	C(10), ;
	mvalfdoc	C(100), ;
	mvtcamag	C(100), ;
	mvtcomag	C(100), ;
	mvtcomat	C(100), ;
	mvtipcon	C(100), ;
	mvcodcon	C(100), ;
	mvcodage	C(100), ;
	mvcodpag	C(100), ;
	mvcodval	C(100), ;
	mvunimis	C(100), ;
	mvqtamov	C(100), ;
	mvprezzo	C(100), ;
	mvscont1	C(100), ;
	mvscont2	C(100), ;
	mvscont3	C(100), ;
	mvscont4	C(100), ;
	mvflomag	C(100), ;
	mvvalmag	C(100), ;
	vadecuni	C(100), ;
	vadectot	C(100), ;
	vasimval	C(100), ;
	mvserial	C(100), ;
	mvcodiva	C(100), ;
	mvspeinc	C(100), ;
	mvspetra	C(100), ;
	mvspeimb	C(100), ;
	mvspebol	C(100), ;
	mvaimps1	C(100), ;
	mvaimps2	C(100), ;
	mvaimps3	C(100), ;
	mvaimps4	C(100), ;
	mvaimps5	C(100), ;
	mvaimps6	C(100), ;
	mvvalrig	C(100), ;
	mvflrinc	C(100), ;
	mvflrtra	C(100), ;
	mvflrimb	C(100), ;
	mvsconti	C(100), ;
	cmdescri	C(100), ;
	mvaccont	C(100), ;
	mvaimpn1	C(100), ;
	mvaimpn2	C(100), ;
	mvaimpn3	C(100), ;
	mvaimpn4	C(100), ;
	mvaimpn5	C(100), ;
	mvaimpn6	C(100), ;
	mvimparr	C(100), ;
	mvaflom1	C(100), ;
	mvaflom2	C(100), ;
	mvaflom3	C(100), ;
	mvaflom4	C(100), ;
	mvaflom5	C(100), ;
	mvaflom6	C(100), ;
	mvdatreg	C(100), ;
	mvrifkit	C(100), ;
	tddesdoc	C(100), ;
	andescri	C(100), ;
	mvcodice	C(100), ;
	mvdesart	C(100), ;
	mvtiprig	C(100), ;
	ordine		C(100), ;
	valuta		C(100), ;
	simbolo		C(100), ;
	totale		C(100), ;
	mvcodart	C(100), ;
	cproword	C(10), ;
	mvscocl1	C(100), ;
	mvscocl2	C(100), ;
	mvscopag	C(100), ;
	cmdescri1	C(100))




_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "'"
&_COMMAND



INDEX ON SUBSTR(mvdatdoc,7,4) + ALLTRIM(mvnumdoc) + ALLTRIM(cproword)  TAG SEQUEN ADDITIVE  



_answer__ = messagebox("Procedo con la cancellazione delle fatture clienti esistenti dal 01/07/2017 in poi ?",292,"Attenzione")
if _answer__  <> 7

	cSql = "DELETE FROM U_FAT_TT WHERE ORD_DATORD > '2017/06/30'"
	IF !ExecCommand(cSql,"DEL_FAT_TT")
	   return
	ENDIF

	cSql = "DELETE FROM U_FAT_DD WHERE ORS_DATORD > '2017/06/30'"
	IF !ExecCommand(cSql,"DEL_FAT_DD")
	   return
	ENDIF

endif

__sto_caricando_note_accredito = .f.
_answer__ = messagebox("Stai caricando le note di accredito ?",292,"Attenzione")
if _answer__  <> 7
	__sto_caricando_note_accredito = .t.
endif

_TOT_COUNT = 0
_ULT_NUMORD = 0

WAIT WINDOWS "Conversione Fatture clienti in corso..." NOWAIT


_NEW_AGGA = SYS(2015)



SELECT IMPORTADBF
GO TOP

SCAN


    IF DELETED()
       SELECT IMPORTADBF  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(MVTIPDOC)) = "MVTIPDOC"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTADBF  
       SKIP +1
       LOOP
    ENDIF 

    IF EMPTY(ALLTRIM(MVTIPDOC)) 
       SELECT IMPORTADBF  && SCARTO I RECORD VUOTI
       SKIP +1
       LOOP
    ENDIF 
	
	WAIT WINDOWS "Conversione fattura " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 

	
	SCATTER MEMVAR memo
	
	** ########################################################## TESTATA ORDINE ####################################################



	__ORD_ANNO = SUBSTR(M.mvdatdoc,7,4)
	__ORD_NUMORD = ALLTRIM(M.mvnumdoc)
	
	__ORD_DATORD__ = SUBSTR(M.mvdatdoc,7,4) + '/' + SUBSTR(M.mvdatdoc,4,2) + '/' + SUBSTR(M.mvdatdoc,1,2)	&& E' IN QUESTO FORMATO 26/07/2007  00.00.00	
	
	IF __ORD_DATORD__  < '2017/07/01'	
       SELECT IMPORTADBF  && SCARTO LE FATTURE GIA' INSERITE AL 30/06/2017
       SKIP +1
       LOOP
    ENDIF 	

*!*		IF VAL(__ORD_NUMORD)  <> 315
*!*	       SELECT IMPORTADBF  && SCARTO LE FATTURE GIA' INSERITE AL 30/06/2017
*!*	       SKIP +1
*!*	       LOOP
*!*	    ENDIF 	


	__PUB_LCL    = 6
	__ORD_NUMORD = TRC(__PUB_LCL,ALLTRIM(__ORD_NUMORD))   
	__TNUMERO	 = __ORD_NUMORD

	x_numo = "ORD_NUMORD = '" + ALLTRIM(__ORD_NUMORD)+ "'"
	x_dato = "ORD_ANNO = '" + SUBSTR(M.mvdatdoc,7,4) + "'"
	
	x_cond = x_dato + " and " + x_numo 	
	cSql = "SELECT * FROM U_FAT_TT WHERE "+ x_cond
	IF !ExecCommand(cSql,"U_FAT_TT_CU")
	   return
	ENDIF
	SELECT U_FAT_TT_CU
	GO TOP
	IF EOF()
		_NEW_AGGA = SYS(2015)		&& IDENTIFICA LA TESTATA DELLA FATTURA CLIENTE
	ENDIF
	
	SELECT IMPORTADBF	
		
	__TAGGANCIO  = _NEW_AGGA 
	__ORD_CODSOC = PUB_CODSOC


    IF LEN(ALLTRIM(M.mvcodcon)) = 15
    	M.ORD_CODCLI = SUBSTR(M.mvcodcon,8,8)
    ELSE
    	M.ORD_CODCLI = ALLTRIM(M.mvcodcon)
    ENDIF
    
    M.ORD_CODCLI = TRC(PUB_LCL,ALLTRIM(M.ORD_CODCLI))   	
	__ORD_CODCLI = M.ORD_CODCLI

	
	x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "CLI_CODCLI = '" + __ORD_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT * FROM U_CLI_AN WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_CLI_AN")
		RETURN .F.
	ENDIF
	SELECT CX_CLI_AN
	GO TOP
	IF !EOF()
		__ORD_RAGSOC = CLI_RAGSOC
		__ORD_INDIRI = CLI_INDIR
		__ORD_CAP	 = CLI_CAP
		__ORD_LOCALI = CLI_LOCALI
		__ORD_PROVIN = CLI_PROVIN
		__ORD_PARIVA = CLI_PARIVA
		__ORD_FAX    = CLI_FAX
		__ORD_CDIMBA = CLI_CODIMB
		__ORD_CPA	 = CLI_CONPAG
		__ORD_BANCA	 = CLI_BAE
		__ORD_CODNAZ = CLI_NAZION
		__ORD_VALUTA = CLI_VALUTA
		__ORD_AGE    = CLI_AGE
		__ORD_IVA    = CLI_CODIVA
	ELSE
		__ORD_RAGSOC = ""
		__ORD_INDIRI = ""
		__ORD_CAP	 = ""
		__ORD_LOCALI = ""
		__ORD_PROVIN = ""
		__ORD_PARIVA = ""
		__ORD_FAX    = ""
		__ORD_CDIMBA = ""
		__ORD_CPA	 = ""
		__ORD_BANCA	 = ""
		__ORD_CODNAZ = ""
		__ORD_VALUTA = ""
		__ORD_AGE    = "000"
		__ORD_IVA    = ""
	ENDIF
	
	__ORD_VALUTA = ALLTRIM(M.mvcodval)
	__ORD_CAMBIO = 1
	

	__ORD_DATORD = SUBSTR(M.mvdatdoc,7,4) + '/' + SUBSTR(M.mvdatdoc,4,2) + '/' + SUBSTR(M.mvdatdoc,1,2)	&& E' IN QUESTO FORMATO 26/07/2007  00.00.00	
	IF !__sto_caricando_note_accredito
		__ORD_CAUS = "VEN"
	ELSE
		__ORD_CAUS = "699"
	ENDIF 	
		
	__ORD_RIFERI = ALLTRIM(IIF(!ISNULL(M.mvnumdoc),ALLTRIM(M.mvnumdoc),'') + ' ' + IIF(!ISNULL(M.mvdatdoc),SUBSTR(M.mvdatdoc,1,2) + '/' + SUBSTR(M.mvdatdoc,4,2) + '/' + SUBSTR(M.mvdatdoc,7,4),''))
	IF EMPTY(__ORD_AGE)
		__ORD_AGE = '000'
	ENDIF
	
	
	*__ORD_PROVVI = IIF(!ISNULL(M.PROVAGENTE),M.PROVAGENTE,'')
	__ORD_DTCONS = IIF(!ISNULL(M.mvdatdoc),SUBSTR(M.mvdatdoc,7,4) + '/' + SUBSTR(M.mvdatdoc,4,2) + '/' + SUBSTR(M.mvdatdoc,1,2),__ORD_DATORD)
	__ORD_CODOPE = PUB_CODOPE
	__ORD_CODEMI = PUB_CLISOC
	__ORD_RAGEMI = PUB_RAGSOC
	__ORD_MAGS = PUB_CODM
	__ORD_TIPORD = "FA"
	
	__REG_CODOPE = 'SON' 		&& ALLTRIM(PUB_CODOPE)
	__REG_NOMOPE = 'SONIA RIVA' && ALLTRIM(PUB_NOMOPE)
	__REG_DATREG = RIBALTA2(__DATINS)
	__REG_ORAREG = "00:00:00"
	
	__ORD_CHIUSO_TT = .T.
	
	__ORD_SPBOLL = VAL(ALLTRIM(M.MVSPEINC))
	__ORD_SPTRAS = VAL(ALLTRIM(M.MVSPETRA))
	
	
	__ORD_PESO = 0
	__ORD_IMBALL = ""
	__ORD_RAGC = ""
	__ORD_INDC = ""
	__ORD_LOCC = ""
	__ORD_PROC = ""
	__ORD_CAPC = ""
	__ORD_CODLOC = ""
	__ORD_ALTDES = 0
	


	x_cond = "TAGGANCIO = '" + __TAGGANCIO + "'"
	cSql = "SELECT * FROM U_FAT_TT WHERE "+ x_cond
	IF !ExecRW(cSql,"U_FAT_TT","R")
	   return
	ENDIF
	
	SELECT U_FAT_TT
	IF EOF()

	    __ORD_NPROT = SPACE(06)
	    v_seek  = 'NUMPRC'+PUB_CODSOC
	    v_chiave= "codice"
	    cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
	    IF !ExecRW(cSql,"PARA","R")
	       return(.f.)
	    ENDIF
	    SELECT PARA
	    IF RECCOUNT() <> 0
		   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
		   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
	       __ORD_NPROT = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
	    ELSE
	       RIT = MSGBOX('Parametro numero protocollo non trovato','ATTENZIONE',31)
	 	   RETURN
	    ENDIF
	    IF !ExecRW(cSql,"PARA","W")
	       return(.f.)
	    ENDIF	    
	
	
	    SELECT U_FAT_TT
		APPEND BLANK
	
	ENDIF
	
	REPLACE TAGGANCIO  WITH __TAGGANCIO
	REPLACE ORD_CODSOC WITH __ORD_CODSOC
	REPLACE TNUMERO    WITH __TNUMERO
	REPLACE ORD_CODCLI WITH __ORD_CODCLI
	REPLACE ORD_RAGSOC WITH __ORD_RAGSOC
	REPLACE ORD_INDIRI WITH __ORD_INDIRI
	REPLACE ORD_CAP    WITH __ORD_CAP
	REPLACE ORD_LOCALI WITH __ORD_LOCALI
	REPLACE ORD_PROVIN WITH __ORD_PROVIN
	REPLACE ORD_PARIVA WITH __ORD_PARIVA
	*REPLACE ORD_FAX    WITH __ORD_FAX
	*REPLACE ORD_CDIMBA WITH __ORD_CDIMBA
	REPLACE ORD_CPA    WITH __ORD_CPA
	REPLACE ORD_BANCA  WITH __ORD_BANCA
	REPLACE ORD_CODNAZ WITH __ORD_CODNAZ
	REPLACE ORD_VALUTA WITH __ORD_VALUTA
	REPLACE ORD_AGE    WITH __ORD_AGE
	REPLACE ORD_CAMBIO WITH __ORD_CAMBIO
	REPLACE ORD_ANNO   WITH __ORD_ANNO
	REPLACE ORD_NUMORD WITH __ORD_NUMORD
	REPLACE ORD_DATORD WITH __ORD_DATORD
	REPLACE ORD_CAUS   WITH __ORD_CAUS
	REPLACE ORD_RIFERI WITH __ORD_RIFERI
	REPLACE ORD_AGE    WITH __ORD_AGE
	REPLACE ORD_DTCONS WITH __ORD_DTCONS
	
	REPLACE ORD_PESO   WITH __ORD_PESO
	*REPLACE ORD_IMBALL WITH __ORD_IMBALL
	REPLACE ORD_RAGC   WITH __ORD_RAGC
	REPLACE ORD_INDC   WITH __ORD_INDC
	REPLACE ORD_LOCC   WITH __ORD_LOCC
	REPLACE ORD_PROC   WITH __ORD_PROC
	REPLACE ORD_CAPC   WITH __ORD_CAPC
	REPLACE ORD_CODLOC WITH __ORD_CODLOC
	REPLACE ORD_ALTDES WITH __ORD_ALTDES
	
	*REPLACE ORD_CODOPE WITH __ORD_CODOPE
	REPLACE ORD_CODEMI WITH __ORD_CODEMI
	REPLACE ORD_RAGEMI WITH __ORD_RAGEMI
	*REPLACE ORD_MAGS   WITH __ORD_MAGS
	REPLACE ORD_TIPORD WITH __ORD_TIPORD
	REPLACE REG_CODOPE WITH __REG_CODOPE
	REPLACE REG_NOMOPE WITH __REG_NOMOPE
	REPLACE REG_DATREG WITH __REG_DATREG
	REPLACE REG_ORAREG WITH __REG_ORAREG
    REPLACE ORD_ACURA  WITH ""
    
    REPLACE ORD_SPBOLL WITH __ORD_SPBOLL 
    REPLACE ORD_SPTRAS WITH __ORD_SPTRAS 
    
    REPLACE ORD_NPROT  WITH __ORD_NPROT 
            
 
	IF !ExecRW(cSql,"U_FAT_TT","W")
	   return
	ENDIF
		
	_ULT_NUMORD = VAL(__ORD_NUMORD)
	
	__ORD_SEQUEN = 0
	
	** ########################################################## RIGHE DI DETTAGLIO FATTURA ####################################################	


	__ORD_SEQUEN = 	VAL(ALLTRIM(M.CPROWORD))			&&__ORD_SEQUEN + 10
	__DAGGANCIO = _NEW_AGGA 
	__ORD_CODART = ALLTRIM(M.mvcodice)
	
	*__ORD_DES2	  = ART_DESEST
	*__ORD_PREZZO  = 0
	__ORD_COORD   = "" 
	__ORD_QTXCON  = 0 
	__ORD_SCORMI  = 0
	__ORD_CODTAG  = ""
	__ORD_DESTAG  = ""
	__ORD_CODCOL  = ""
	__ORD_DESCOL  = ""
	__ORD_PESOUM  = 0
	__ORD_CODMAT  = ""
	__ORD_DESMAT  = ""
	__ORD_CODCOL  = ""
	__ORD_DESCOL  = ""
	__ORD_SPESSO  = 0
	__ORD_ALTEZZ  = 0
	__ORD_LUNGHE  = 0
	__ORD_CODIMB  = ""
	__ORD_DESIMB  = ""
	__ORD_LOTMIN  = 0
	__ORD_UM      = "NR"
	***__ORD_IVA     = "22"


	__ORD_DESART = IIF(ISNULL(M.mvdesart),"",ALLTRIM(M.mvdesart))
	IF SUBSTR(__ORD_DESART,1,3) = "***"
		__ORD_DESART = ALLTRIM(SUBSTR(__ORD_DESART,4))
	ENDIF
	__NOTE  	 = ""


	IF ALLTRIM(M.mvtiprig) = 'R'	&& RIGA ARTICOLO (ALTRIMENTI E' UN COMMENTO)
		x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
		x_codi = "ART_CODPRI = '" + __ORD_CODART + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "SELECT * FROM U_ART_PR WHERE " + x_cond
		IF !ExecCommand(cSql,"CX_ART_PR")
			RETURN .F.
		ENDIF
		SELECT CX_ART_PR
		GO TOP
		IF !EOF()
			__ORD_COORD   = ART_COORD 
			__ORD_QTXCON  = ART_QTACON 
			__ORD_SCORMI  = ART_SCORMI
			__ORD_CODTAG  = ART_CODTAG 
			__ORD_DESTAG  = ART_DESTAG 
			__ORD_CODCOL  = ART_CODCOL 
			__ORD_DESCOL  = ART_DESCOL 
			__ORD_PUBBLI  = ART_PUBBLI
			__ORD_PESOUM  = ART_PESOUM
			__ORD_CODMAT  = ART_CODMAT
			__ORD_DESMAT  = ART_DESMAT
			__ORD_CODCOL  = ART_CODCOL
			__ORD_DESCOL  = ART_DESCOL
			__ORD_SPESSO  = ART_SPESSO
			__ORD_ALTEZZ  = ART_ALTEZZ
			__ORD_LUNGHE  = ART_LUNGHE
			__ORD_CODIMB  = ART_CODIMB
			__ORD_DESIMB  = ART_DESIMB
			__ORD_LOTMIN  = ART_LOTMIN
			__ORD_UM      = ART_UMMAGA
			*__ORD_IVA     = ART_CODIVA
			*__ORD_IVA    = ALLTRIM(M.mvcodiva)
		ENDIF

	ELSE 	&& RIGA COMMENTO

			__ORD_DESART 	= "*** COMMENTO ***"
		    __NOTE  		= IIF(!ISNULL(M.MVDESART),ALLTRIM(M.MVDESART),"")
			__CODICE 		= ''
			__ORD_IVA       = ''
	
	ENDIF 
	
	
	__ORD_MAGA   = "SEDE"
	__ORD_QTAORD = VAL(M.mvqtamov)
	__ORD_QTAEV  = 0
	__ORD_PREZZO = VAL(M.mvprezzo)
	__ORD_SC1    = ABS(VAL(M.mvscont1))
	__ORD_SC2    = ABS(VAL(M.mvscont2))
	__ORD_SC3    = ABS(VAL(M.mvscont3))
	__ORD_SC4    = ABS(VAL(M.mvscont4))
	__ORD_SC5    = 0
	
	
			
	VPRE         = __ORD_PREZZO
	VPRE         = VPRE-ROUND((VPRE*__ORD_SC1/100),6)
	VPRE         = VPRE-ROUND((VPRE*__ORD_SC2/100),6)
	VPRE         = VPRE-ROUND((VPRE*__ORD_SC3/100),6)
	VPRE         = VPRE-ROUND((VPRE*__ORD_SC4/100),6)
	VPRE         = VPRE-ROUND((VPRE*__ORD_SC5/100),6)
	__ORD_PRZNET = VPRE
	__ORD_PRZNET = ROUND(__ORD_PRZNET,6)
	__ORD_VALORE = CALCOLA_VALORE_RIGA_DOCUMENTO(__ORD_PRZNET,__ORD_QTAORD)
	
	__ORD_DATCON = IIF(!ISNULL(M.mvdatdoc),SUBSTR(M.mvdatdoc,7,4) + '/' + SUBSTR(M.mvdatdoc,4,2) + '/' + SUBSTR(M.mvdatdoc,1,2),__ORD_DATORD)
	
	__ORD_PUBBLI = ''

	
	__ORD_PRORIG = 0
	__ORD_CODSYS = SYS(2015)
	__ORD_LEGSYS = SYS(2015)
	
	__ORD_CDAPRD = __ORD_CODART
	__ORD_DSAPRD = __ORD_DESART
	
	__ORD_CHIUSO = .F.
	
	IF !__ORD_CHIUSO
		__ORD_CHIUSO_TT = .F.
	ENDIF
			
	
	cSql = "SELECT * FROM U_FAT_DD WHERE 1=0"
	IF !ExecRW(cSql,"U_FAT_DD","R")
	   return
	ENDIF
	SELECT U_FAT_DD
	APPEND BLANK

	REPLACE ORD_SEQUEN WITH __ORD_SEQUEN
	REPLACE DAGGANCIO  WITH __DAGGANCIO 
	REPLACE ORD_CODART WITH __ORD_CODART
	REPLACE ORD_COORD  WITH __ORD_COORD 
	REPLACE ORD_QTXCON WITH __ORD_QTXCON
	REPLACE ORD_SCORMI WITH __ORD_SCORMI
	REPLACE ORD_CODTAG WITH __ORD_CODTAG
	REPLACE ORD_DESTAG WITH __ORD_DESTAG
	REPLACE ORD_CODCOL WITH __ORD_CODCOL
	REPLACE ORD_DESCOL WITH __ORD_DESCOL
	REPLACE ORD_PESOUM WITH __ORD_PESOUM
	REPLACE ORD_CODMAT WITH __ORD_CODMAT
	REPLACE ORD_DESMAT WITH __ORD_DESMAT
	REPLACE ORD_CODCOL WITH __ORD_CODCOL
	REPLACE ORD_DESCOL WITH __ORD_DESCOL
	REPLACE ORD_SPESSO WITH __ORD_SPESSO
	REPLACE ORD_ALTEZZ WITH __ORD_ALTEZZ
	REPLACE ORD_LUNGHE WITH __ORD_LUNGHE
	REPLACE ORD_CODIMB WITH __ORD_CODIMB
	REPLACE ORD_DESIMB WITH __ORD_DESIMB
	REPLACE ORD_LOTMIN WITH __ORD_LOTMIN
	REPLACE ORD_CDAPRD WITH __ORD_CDAPRD
	REPLACE ORD_DSAPRD WITH __ORD_DSAPRD
	REPLACE ORD_DESART WITH IIF(ISNULL(__ORD_DESART),"",ALLTRIM(__ORD_DESART)) && ESEGUENDO LA SITUAZIONE DEGLI Fatture MI HA TROVATO UN NULL SULLA DESCRIZIONE
	REPLACE ORD_NOTE   WITH __NOTE
	REPLACE ORD_MAGA   WITH __ORD_MAGA
	REPLACE ORD_UM     WITH __ORD_UM
	REPLACE ORD_IVA    WITH __ORD_IVA
	REPLACE ORD_QTAORD WITH __ORD_QTAORD
	REPLACE ORD_QTAEV  WITH __ORD_QTAEV 
	REPLACE ORD_PREZZO WITH __ORD_PREZZO
	REPLACE ORD_SC1    WITH __ORD_SC1
	REPLACE ORD_SC2    WITH __ORD_SC2
	REPLACE ORD_SC3    WITH __ORD_SC3
	REPLACE ORD_SC4    WITH __ORD_SC4
	REPLACE ORD_SC5    WITH __ORD_SC5
	REPLACE ORD_PRZNET WITH __ORD_PRZNET
	REPLACE ORD_VALORE WITH __ORD_VALORE
	REPLACE ORD_DATCON WITH __ORD_DATCON
	REPLACE ORD_PUBBLI WITH __ORD_PUBBLI
	REPLACE ORD_PRORIG WITH __ORD_PRORIG
	REPLACE ORD_CODSYS WITH __ORD_CODSYS
	REPLACE ORD_LEGSYS WITH __ORD_LEGSYS
	REPLACE ORD_CHIUSO WITH __ORD_CHIUSO
	
	*REPLACE ORS_MAGS   WITH __ORD_MAGS
	*REPLACE ORS_MAGD   WITH ""
	REPLACE ORS_CODCLI WITH __ORD_CODCLI
	REPLACE ORS_RAGSOC WITH __ORD_RAGSOC
	REPLACE ORS_NUMORD WITH __ORD_NUMORD
	REPLACE ORS_DATORD WITH __ORD_DATORD
	REPLACE ORS_CODEMI WITH __ORD_CODEMI
	REPLACE ORS_RAGEMI WITH __ORD_RAGEMI
	REPLACE ORS_TIPORD WITH __ORD_TIPORD
	*REPLACE ORS_DESTIN WITH 
	REPLACE ORS_VALUTA WITH __ORD_VALUTA
	*REPLACE ORS_FLGABP WITH
	
	IF !ExecRW(cSql,"U_FAT_DD","W")
	   return
	ENDIF


	
	*** CONTRAGGIORNAMENTO CAMPI DI TESTATA
	x_agga = "TAGGANCIO = '" + _NEW_AGGA + "'"
	x_cond = x_agga
	cSql = "SELECT * FROM U_FAT_TT WHERE " + x_cond
	IF !ExecCommand(cSql,"CU_FAT_TT")
	   return
	ENDIF
	SELECT CU_FAT_TT
	GO TOP
	SCATTER MEMVAR MEMO
	
	x_agga = "DAGGANCIO = '" + _NEW_AGGA + "'"
	x_cond = x_agga
	cSql = "SELECT * FROM U_FAT_DD WHERE " + x_cond
	IF !ExecCommand(cSql,"CU_FAT_DD")
	   return
	ENDIF
	SELECT CU_FAT_DD
	GO TOP
	
	DO CALCFAT
	
	_nVALORE = M.ORD_VALORE
	_cVALORE = ALLTRIM(STR(_nVALORE,17,3))
	_cVALORE = STRTRAN(_cVALORE,",",".")
	
	__cORD_CHIUSO_TT_SQL = IIF(__ORD_CHIUSO_TT,'1','0')
		
	y_cond = "TAGGANCIO = '" + _NEW_AGGA + "'"
	Csql = "UPDATE U_FAT_TT SET ORD_VALORE = &_cVALORE , ORD_CHIUSO = &__cORD_CHIUSO_TT_SQL WHERE " + y_cond
	IF !ExecCommand(cSql,"UPD_TABELLA_TT")
		return(.f.)
	ENDIF
	
	_TOT_COUNT = _TOT_COUNT + 1
	
ENDSCAN

*** AGGIORNAMENTO CONTATORE NUMERO ORDINE
IF PUB_MULTIA
	x_codi = "CODICE = 'NUMFAT" + PUB_ANNO+PUB_CODSOC + "'"
ELSE 
	x_codi = "CODICE = 'NUMFAT" + PUB_CODSOC + "'"
ENDIF


x_cond = x_codi
cSql = "SELECT * FROM PARA WHERE " + x_cond
IF !ExecRW(cSql,"PARA","R")
	RETURN .F.
ENDIF
SELECT PARA
GO TOP
IF EOF()
	APPEND BLANK
	IF PUB_MULTIA
		REPLACE CODICE WITH 'NUMORD'+PUB_ANNO+PUB_CODSOC
	ELSE
		REPLACE CODICE WITH 'NUMORD'+PUB_CODSOC
	ENDIF 
	REPLACE DESCRI WITH 'NUMERO PROGR. DOCUMENTO - NUMORD'
ENDIF
REPLACE LIBERA WITH STR(_ULT_NUMORD,7,0)
IF !ExecRW(cSql,"PARA","W")
	RETURN .F.
ENDIF


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale fatture clienti convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 