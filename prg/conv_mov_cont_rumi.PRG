*************************************************************************************************
*							CONVERSIONE PRIMA NOTA		 										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2013 : Rumi				 														*
*************************************************************************************************



** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "RUM"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'RUM' non configurato" + CHR(13) + CHR(13) + ;
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

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

RIT = MESSAGEBOX("Conversione movimenti contabili di prima nota da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from MOV_CONT where 1=0","curs_MOV_CONT")
   return
ENDIF






RIT = MESSAGEBOX("Vui cancellare gli archivi contabili ??",292,"ATTENZIONE")
	IF RIT <> 7

	WAIT WINDOWS "Attendere prego, cancellazione archivi contabili" NOWAIT		

	x_soci = "mov_soc = '" + PUB_CODSOC + "'"
	x_cond = x_soci 								&& + " and " + x_anno		
	cSql   = "delete from MOV_CONT WHERE " + x_cond 
	IF !ExecCommand(cSql,"MOV_CONT")
	   return(.f.)
	ENDIF
	cSql   = "delete from INDICE WHERE " + x_cond 
	IF !ExecCommand(cSql,"INDICE")
	   return(.f.)
	ENDIF

	*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_VVA_CH SQL
	cSql = "delete from U_VVA_CH where 1=1"
	IF !ExecCommand(cSql,"U_VVA_CH")
	   return(.f.)
	ENDIF

ENDIF






******** RECUPERO PARAMETRI SOTTOGRUPPO

x_cond = "codice = 'GEN" + PUB_CODSOC + "'"
cSql   = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF
SELECT PARA
IF reccount() > 0
   PUB_CC=SUBSTR(LIBERA,1,pub_sottog-1)
   PUB_FF=SUBSTR(LIBERA,18,pub_sottog-1)
ELSE
   =MESSAGEBOX("Parametro << GEN01 >> non trovato",16,"*** ATTENZIONE ***")
   RETURN
ENDIF

******** RECUPERO PARAMETRI NUMERO PROGRESSIVO
x_cond = "codice = 'NUMREG" + ALLTRIM(PUB_ANNO) + "01'"
cSql   = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF
SELECT PARA
IF reccount() > 0
   REGISTRAZIONE_NUMERO = VAL(ALLTRIM(LIBERA))
ELSE
   =MESSAGEBOX("Parametro << NUMREG"+ALLTRIM(PUB_ANNO)+"01 >> non trovato",16,"*** ATTENZIONE ***")
   RETURN
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = RIBALTA2(DTOC(DATE()))
_CTR = 0

RELEASE __RAGIONE_SOCIALE_CLIENTE_FORNITORE
PUBLIC __RAGIONE_SOCIALE_CLIENTE_FORNITORE
__RAGIONE_SOCIALE_CLIENTE_FORNITORE = ''

RELEASE TDARE,TAVERE,TSALDO,_NUMERO_REGISTRAZIONE_NON_TROVATO
PUBLIC TDARE,TAVERE,TSALDO,_NUMERO_REGISTRAZIONE_NON_TROVATO
  		
TDARE  = 0
TAVERE = 0
TSALDO = 0
_NUMERO_REGISTRAZIONE_NON_TROVATO	= SYS(2015)				&& NUMERO DI REGISTRAZIONE NON TROVATO	


CREATE CURSOR NONTROVATI (CLI_CODCLI  c(10),;
	CLI_RAGSOC   c(80),;
	FOR_CODCLI   c(10),;
	FOR_RAGSOC   c(80),;			
	MESSAGGIO    c(20))



CREATE CURSOR CARD_MOV_CONT (MOV_DTREG c(010),;
	MOV_NREGIS 	c(006),;
	MOV_SEQUEN	N(15,0),;				
	MOV_DTDOC  	c(010),;
	MOV_NDOC   	c(006),;
	MOV_CONTO  	c(013),;
	MOV_CONTOCF	c(013),;
	MOV_TMOV    c(001),;
	MOV_IMP		N(16,2),;							
	MOV_DATSCAD c(010),;
	MOV_SOC		c(002),;			
	MOV_ANNO	c(004),;			
	MOV_VALUTA	c(003),;			
	MOV_TOP		c(003),;	
	MOV_DESTOP	c(030),;								
	MOV_CAMBIO	N(20,10),;			
	MOV_IVA		c(002),;				
	MOV_DESMOV	c(070),;				
	MOV_NUMPRO	c(020),;				
	MOV_COSATRATTA	c(050),;				
	MOV_GRADOIMPORTANZA	c(050),;				
	MOV_FORMAPAGAMENTO	c(050),;				
	MOV_TIPOCONTRATTO	c(050),;				
	MOV_CODACQ	c(003),;				
	MOV_PRIPAGA	c(004),;				
	MOV_DTVAL	c(010),;				
	MOV_ANOMAX	c(030),;				
	MOV_CONTABILITA_PREVISIONALE	c(001),;				
	MOV_ANNODO	c(004),;				
	MOV_EXTRA_NUMDOC	c(006),;				
	MOV_EXTRA_DATDOC	c(010),;				
	MOV_EXTRA_SYSDOC	c(020),;				
	MOV_EXTRA_BOLLATOIVA	L,;	
	MOV_NOTE			M,;			
	CAMPO1   c(250))


___MESE_CONV="01"
___ANNO_CONV=PUB_ANNO

**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
		

CREATE CURSOR IMPORTAXLS ( ;
	pncodese	C(100), ;
	pncodute	C(100), ;
	pnnumrer	C(100), ;
	pndatreg	C(100), ;
	pncompet	C(100), ;
	pncodbun	C(100), ;
	pntipreg	C(100), ;
	pnflivdf	C(100), ;
	pnnumreg	C(100), ;
	pntipdoc	C(100), ;
	pnalfdoc	C(100), ;
	pnnumdoc	C(100), ;
	pndatdoc	C(100), ;
	pnalfpro	C(100), ;
	pnnumpro	C(100), ;
	pnvalnaz	C(100), ;
	pncodval	C(100), ;
	pnsimval	C(100), ;
	pntipclf	C(100), ;
	pncodclf	C(100), ;
	pncomiva	C(100), ;
	pnfllibg	C(100), ;
	pnflprov	C(100), ;
	pntipcon	C(100), ;
	pncodcon	C(100), ;
	pnimpave	C(100), ;
	pnflpart	C(100), ;
	pnflzero	C(100), ;
	pnflsald	C(100), ;
	pnflsali	C(100), ;
	pnflsalf	C(100), ;
	pnlibgio	C(100), ;
	padescri	C(100), ;
	ccdescri	C(100), ;
	ccdescri1	C(100), ;
	pnserial	C(100), ;
	pnimpdar	C(100), ;
	andescri	C(100), ;
	pncodcau	C(100), ;
	pncodpag	C(100), ;
	pncaurig	C(100), ;
	pndessup	C(100), ;
	cproword	C(100), ;
	pnscrass	C(100))

APPEND FROM (gcFile) TYPE XLS


**** CARICAMENTO TIPI OPERRAZIONE DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA

RIT = MESSAGEBOX("Caricamento delle causali contabili da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


CREATE CURSOR TIPI_OPERAZIONE ( ;
			cctop	  	  c(50),;
			cccodice	  c(50),;	
			ccdescri	  c(50),;	
			ccflpart	  c(50),;	
			ccflsali	  c(50),;	
			ccflsalf	  c(50),;	
			ccflcomp	  c(50),;	
			ccflrife	  c(50),;	
			cctipdoc	  c(50),;	
			cctipreg	  c(50),;	
			ccnumreg	  c(50),;	
			ccnumdoc	  c(50),;	
			ccflivdf	  c(50),;	
			ccflstda	  c(50),;	
			cccaldoc	  c(50),;	
			cctesdoc	  c(50),;	
			ccdtobso	  c(50),;	
			ccserdoc	  c(50),;	
			ccserpro	  c(50),;	
			cccfdave	  c(50),;	
			aicodiva	  c(50),;	
			aitipcon	  c(50),;	
			aicondet	  c(50),;	
			aiconind	  c(50),;	
			aitipreg	  c(50),;	
			ainumreg	  c(50),;	
			apflpart	  c(50),;
			tipo   		  c(50),;	
			ccflanal	  c(50),;	
			apfldave	  c(50),;	
			ccconiva	  c(50),;	
			ccflrite	  c(50),;	
			ccflpdoc	  c(50),;	
			ccflppro	  c(50),;	
			ccflstat	  c(50),;	
			ccflasse	  c(50),;	
			ccgesrit	  c(50),;	
			ccflauto	  c(50))
	
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR
SELECT TIPI_OPERAZIONE 
INDEX ON ALLTRIM(cccodice) TAG i_cccod ADDITIVE 

APPEND FROM (gcFile) TYPE XLS



*** ################################################### INIZIO ELABORAZIONE ############################################################
__NUMERO_REGISTRAZIONE_OLD = ""	
__NUMERO_REGISTRAZIONE     = "OK-PARTI"
		
SELECT IMPORTAXLS
GO TOP 

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(PNCODESE)) = "PNCODESE"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
  
*!*	#####################################################


	M.NUMERO  					= CONV_CLEAR(APITOSPA(ALLTRIM(M.pnnumrer))) 
	__NUMERO_REGISTRAZIONE   	= M.NUMERO
    __RAGIONE_SOCIALE_CLIENTE_FORNITORE =CONV_CLEAR(APITOSPA(ALLTRIM(M.ANDESCRI))) 

	IF __NUMERO_REGISTRAZIONE_OLD <> __NUMERO_REGISTRAZIONE 		&& DETERMINA IL NUMERO DI REGISTRAZIOE ED IL NUMERO INTERNO DI PRIMA NOTA A ROTTURA DI REGISTRAZIONE RUMI    
		__NUMERO_REGISTRAZIONE_OLD  = M.NUMERO
		__NUMPRO 					= SYS(2015)
	ENDIF 
	
	WAIT WINDOWS    "Registrazione n : >> " + __NUMERO_REGISTRAZIONE +" <<" NOWAIT

	M.SEGNO = 'D'
	M.EIMPORTO = 0
	IF VAL(M.pnimpdar) <> 0
		M.SEGNO = 'D'
		M.EIMPORTO = VAL(M.pnimpdar)
	ENDIF  
	IF VAL(M.pnimpave) <> 0
		M.SEGNO = 'A'
		M.EIMPORTO = VAL(M.pnimpave)		
	ENDIF
	
 
	 
	IF ALLTRIM(M.pnnumdoc) = '0' OR EMPTY(ALLTRIM(M.pnnumdoc)) 
		M.NUMDOCUM = ALLTRIM(M.pnnumrer)	&& FORZO IL NUMERO DI REGISTRAZIONE
	ELSE 
		M.NUMDOCUM = ALLTRIM(M.pnnumdoc)	 
	ENDIF  

	
	__RIGAN = VAL(ALLTRIM(M.cproword))
	__RIGA  = STR(__RIGAN,4,0)	
	
	__AA	= SUBSTR(M.pndatreg,7,4)
	__MM	= SUBSTR(M.pndatreg,4,2)
	__GG	= SUBSTR(M.pndatreg,1,2)
	

	

	M.ECAMBIO = 1

	IF !EMPTY(ALLTRIM(M.pncodval))
		M.CODVALUTA = ALLTRIM(M.pncodval)
	ELSE
		M.CODVALUTA = "EUR"
	ENDIF  


	M.MOV_DTREG  					= RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))      
	M.MOV_NREGIS 					= SUBSTR(M.NUMERO,2,6)
	M.MOV_NUMPRO 					= __NUMPRO
	M.MOV_SEQUEN 					= __RIGA  
	M.MOV_TMOV 						= M.SEGNO

	IF M.CODVALUTA <> 'EUR'			
		M.MOV_IMP 					= ROUND(M.EIMPORTO*M.ECAMBIO,2)
	ELSE
		M.MOV_IMP 					= ROUND(M.EIMPORTO,2)
	ENDIF
	
	M.MOV_NDOC  					= SUBSTR(M.NUMDOCUM,04,06)


	__AAD	= SUBSTR(M.pndatdoc,7,4)
	__MMD	= SUBSTR(M.pndatdoc,4,2)
	__GGD	= SUBSTR(M.pndatdoc,1,2)

	IF EMPTY(ALLTRIM(M.pndatdoc))
		M.MOV_DTDOC = M.MOV_DTREG	&& FORZO DATA REGISTRAZIONE
	ELSE
		M.MOV_DTDOC = RIBALTA2(OK_DATA(__GGD+"/"+__MMD+"/"+__AAD+"/"))   
	ENDIF  
	
			
	M.MOV_DATSCAD					= M.MOV_DTDOC
	M.MOV_SOC    					= "01"
	M.MOV_ANNO   					= ALLTRIM(pncodese) 	&& PUB_ANNO


	M.MOV_VALUTA 					= M.CODVALUTA

    __codicecf = ""
    IF LEN(ALLTRIM(M.pncodcon)) = 15
    	__codicecf = SUBSTR(M.pncodcon,8,8)
    ELSE
    	__codicecf = ALLTRIM(M.pncodcon)
    ENDIF
    __codicecf = TRC(PUB_LCL,ALLTRIM(__codicecf)) 


*!*	IF VAL(__codicecf) = 7
*!*	SET STEP ON 
*!*	ENDIF


	M.MOV_CONTO  					= ALLTRIM(CONV_CLEAR(M.pncodcon))
	
	M.CLI_CODCLI = ""
	M.FOR_CODCLI = ""
	
	IF ALLTRIM(m.pntipcon) = "C"
		M.CLI_CODCLI = __codicecf 
		=DECODIFICA_CLIENTE(M.CLI_CODCLI)
	ENDIF

	IF ALLTRIM(m.pntipcon) = "F"
		M.FOR_CODCLI = __codicecf 
		=DECODIFICA_FORNITORE(M.FOR_CODCLI)
	ENDIF


	=AGGIORNA_CONTI(ALLTRIM(M.pntipcon),M.MOV_CONTO)


	SELECT TIPI_OPERAZIONE 
	SET ORDER TO I_CCCOD 
	__seek = alltrim(M.pncodcau)
	SEEK __seek 
	IF FOUND()
		M.MOV_TOP = alltrim(cctop)		&& top aquarius
	ELSE
		M.MOV_TOP = SUBSTR(alltrim(M.pncodcau),1,3)
	ENDIF 

	M.MOV_CAMBIO 					= ROUND(1/M.ECAMBIO,10)
	
	M.MOV_IVA    					= "NO"
	M.MOV_DESMOV 					= CONV_CLEAR(ALLTRIM(M.ccdescri))
	M.MOV_COSATRATTA 				= "GENER"
	M.MOV_GRADOIMPORTANZA 			= "PRIMA"
	M.MOV_FORMAPAGAMENTO 			= "RIMES"
	M.MOV_TIPOCONTRATTO 			= "SCADE"
	M.MOV_CODACQ 					= "001"
	M.MOV_PRIPAGA 					= "0500"
	
	M.MOV_DTVAL 				= M.MOV_DTREG			

*!*		IF M.MOV_VALUTA <> "EUR"
*!*			=CREA_U_VVA_CH_CARD(M.MOV_VALUTA,M.MOV_DTVAL,M.MOV_CAMBIO)
*!*		ENDIF  

	

	M.MOV_ANOMAX 					= ""
	M.MOV_CONTABILITA_PREVISIONALE 	= ""
	M.MOV_ANNODO 					= PUB_ANNO
	M.MOV_EXTRA_NUMDOC 				= ""
	M.MOV_EXTRA_DATDOC 				= ""
	M.MOV_EXTRA_SYSDOC 				= ""
	M.MOV_BOLLATOIVA 				= ""
	M.MOV_NOTE       				= ALLTRIM(M.pnserial)	&& NUMERO SERIALE PER AGGANCIO PRIMA NOTA DI ZUCCHETTI

 	SELECT CARD_MOV_CONT				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 




    	
    SELECT IMPORTAXLS
	SKIP

ENDDO

	

***** #########################################################################  ELABORA IL CURSORE DI SUPPORTO


SELECT CARD_MOV_CONT
GO TOP 


_CTR = 0

DO WHILE !EOF()

    IF DELETED()
       SELECT CARD_MOV_CONT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
   
    
*!*	#####################################################

    SCATTER MEMVAR MEMO

	SELECT CURS_MOV_CONT
	APPEND BLANK
	GATHER MEMVAR MEMO

    =CREA_INDICE()

    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS MOV_CONT SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CARD_MOV_CONT
	SKIP

ENDDO
 	 


****** AGGIORNA TABELLA MOV_CONT
IF !ExecRW('','MOV_CONT','I','','curs_MOV_CONT')
   return(.f.)
ENDIF
	 	 

SELECT NONTROVATI 
GO TOP
BROWSE NORMAL

*SET DECIMAL TO 6  && GESTIONE EURO
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN



***************************
FUNCTION DECODIFICA_CLIENTE
***************************
PARAMETERS __CODCLI


	M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(__CODCLI))
    M.cli_nazion = "" 
    
    
    x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
    x_cond = x_soci + " and " + x_codi
    cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"

	IF !ExecCommand(cSql,"cu_cli_an")
	  return(.f.)
	ENDIF
	
	SELECT cu_cli_an	
	IF RECCOUNT() <> 0
		M.cli_nazion = cli_nazion
	ENDIF

    CC = ""
	V_ER = SOTTOGEN(M.cli_nazion)
	IF !V_ER
	   CC = PUB_CC
	ELSE
	   CC = '1012'
	ENDIF 

  

	M.MOV_CONTO = CC + ALLTRIM(M.CLI_CODCLI)		
			
	M.MOV_CONTO = ALLTRIM(M.MOV_CONTO)	


	IF RECCOUNT() = 0
		SELECT NONTROVATI 
		APPEND BLANK
		REPLACE CLI_CODCLI   WITH 	M.MOV_CONTO
		REPLACE CLI_RAGSOC   WITH 	__RAGIONE_SOCIALE_CLIENTE_FORNITORE
	ENDIF	

	SELECT cu_cli_an	




RETURN M.MOV_CONTO


*****************************
FUNCTION DECODIFICA_FORNITORE
*****************************
PARAMETERS __CODFOR



	M.FOR_CODCLI  = TRC(PUB_LCL,ALLTRIM(__CODFOR))



    M.for_nazion  = ""

    x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "FOR_CODCLI  = '" + M.FOR_CODCLI + "'"
    x_cond = x_soci + " and " + x_codi
    cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"

	IF !ExecCommand(cSql,"cu_for_an")
	  return(.f.)
	ENDIF
	
	SELECT cu_for_an	
	IF RECCOUNT() <> 0
		M.for_nazion = for_nazion
	ENDIF



    FF = ""
	V_ER = SOTTOGEN(M.for_nazion)
	IF !V_ER
	   FF = PUB_FF
	ELSE
	   FF = '3012'
	ENDIF 

	M.MOV_CONTO = FF + ALLTRIM(M.FOR_CODCLI)		
			
	M.MOV_CONTO = ALLTRIM(M.MOV_CONTO)	


	IF RECCOUNT() = 0
		SELECT NONTROVATI 
		APPEND BLANK
		REPLACE FOR_CODCLI   WITH 	M.MOV_CONTO
		REPLACE FOR_RAGSOC   WITH 	__RAGIONE_SOCIALE_CLIENTE_FORNITORE
	ENDIF	

	SELECT cu_for_an	


RETURN M.MOV_CONTO

********************
FUNCTION CREA_INDICE
********************


   
   
   
   	x_soci = "mov_soc = '" + M.MOV_SOC + "'"
   	x_anno = "mov_anno = '" + M.MOV_ANNO + "'"
   	x_nume = "mov_numpro = '" + M.MOV_NUMPRO + "'"   
   	x_cond = x_soci + " and " + x_anno + " and " + x_nume
   	cSql = "select * from indice where " + x_cond
	IF !ExecCommand(cSql,"INDICE")
	   RETURN .F.
	ENDIF



   SELECT INDICE
   GO TOP
   IF EOF()
  	  APPEND BLANK
	  GATHER MEMVAR MEMO
	  REPLACE id_unique WITH ""
	  IF !ExecRW('','INDICE','I','','INDICE')
	     return(.f.)
	  ENDIF

   ENDIF
 

	 	 


RETURN

***********************
FUNCTION CERCA_MOV_CONT
***********************
PARAMETERS __CONTO__,__DTDOC__,__NDOC__


SELECT MOV_NUMPRO,MOV_SEQUEN,MOV_CONTO,MOV_DTDOC,MOV_NDOC,MOV_IMP,* FROM MOV_CONT WHERE MOV_CONTO = '1010200000001'  AND MOV_DTDOC = '2011/04/04' AND MOV_NDOC = '1003'     ORDER BY MOV_NUMPRO

x_conto = "MOV_CONTO = '" + __CONTO__ + "'"
x_dtdoc = "MOV_DTDOC = '" + __DTDOC__+ "'"
x_ndoc = "MOV_NDOC = '" + __NDOC__ + "'"
x_cond = x_conto + " and " + x_dtdoc + " and " + x_ndoc 
cSql="SELECT * FROM MOV_CONT WHERE " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(cSql,"MOV_CONT")
   return(.f.)
ENDIF
SELECT MOV_CONT
GO TOP




RETURN

***********************
FUNCTION AGGIORNA_CONTI
***********************
PARAMETERS __TIPO_CONTO__,__CONTO__

SS=STR(SELECT())


__DESCRIZIONE_CONTO = __RAGIONE_SOCIALE_CLIENTE_FORNITORE
__TIPOCO = __TIPO_CONTO__



x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(__CONTO__) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"


IF !ExecCommand(cSql,"CONTI")
   RETURN .F.
ENDIF

SELECT CONTI
GO TOP

IF !EOF()
	SELECT &SS
	RETURN
ENDIF

APPEND BLANK

REPLACE CON_SOC    WITH PUB_CODSOC
REPLACE CON_ANNO   WITH PUB_ANNO
REPLACE CON_CONTO  WITH ALLTRIM(__CONTO__)
REPLACE CON_DESCR  WITH __DESCRIZIONE_CONTO


REPLACE CON_TIPOCO WITH __TIPOCO
REPLACE CON_POSBIL WITH "P"	

IF VAL(SUBSTR(__CONTO__,1,2)) > 35
	REPLACE CON_POSBIL WITH "E"	
ENDIF


REPLACE CON_VALUTA WITH "EUR"


IF !ExecRW('','CONTI','I','','CONTI')
  return(.f.)
ENDIF	

SELECT &SS

RETURN

