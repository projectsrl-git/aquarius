*************************************************************************************************
*							SISTEMA CODICI IVA SULLE FATTURE DI MOV_CONT						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Gennaio 2014 : Rumi					 														*
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

RIT = MESSAGEBOX("Sistemazine movimenti contabili di prima nota (CODICE IVA) da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from MOV_CONT where 1=0","curs_MOV_CONT")
   return
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



___MESE_CONV="01"
___ANNO_CONV=pub_anno

											

CREATE CURSOR IMPORTAXLS ( ;
	pncompet	C(100), ;
	pnnumrer	C(100), ;
	pndatreg	C(100), ;
	pnnumdoc	C(100), ;
	pnalfdoc	C(100), ;
	pndatdoc	C(100), ;
	pnnumpro	C(100), ;
	pnalfpro	C(100), ;
	pncodcau	C(100), ;
	ccdescri1	C(100), ;
	pntipdoc	C(100), ;
	pncodval	C(100), ;
	pncodute	C(100), ;
	pnflprov	C(100), ;
	pnserial	C(100), ;
	pndessup	C(100), ;
	ivcodiva	C(100), ;
	ivimponi	C(100), ;
	ivimpiva	C(100), ;
	ivtipreg	C(100), ;
	ivperind	C(100), ;
	ivnumreg	C(100), ;
	ivflomag	C(100), ;
	pncodese	C(100), ;
	cprownum	C(100), ;
	ivdesiva	C(100), ;
	pnvalnaz	C(100), ;
	pncomiva	C(100), ;
	pndatpla	C(100))

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
    
    IF UPPER(ALLTRIM(PNCOMPET)) = "PNCOMPET"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
  


	 M.NUMERO  					= CONV_CLEAR(APITOSPA(ALLTRIM(M.pnnumrer))) 
	 __NUMERO_REGISTRAZIONE   	= M.NUMERO
     _KEY_pnserial 				= CONV_CLEAR(APITOSPA(ALLTRIM(M.pnserial))) 

	__pnnumdoc = CONV_CLEAR(APITOSPA(ALLTRIM(M.pnnumdoc))) 	
	__pndatdo1 = CONV_CLEAR(APITOSPA(ALLTRIM(M.pndatdoc))) 
	__pndatdoc = SUBSTR(__pndatdo1,7,4)+'/'+SUBSTR(__pndatdo1,4,2)+'/'+SUBSTR(__pndatdo1,1,2)
	__pnnumreg = CONV_CLEAR(APITOSPA(ALLTRIM(M.pnnumrer))) 	

	IF _KEY_pnserial = '0000027725'
		SET STEP ON 
	ENDIF 

	WAIT WINDOWS    "Registrazione n : >> " + __NUMERO_REGISTRAZIONE +" <<" NOWAIT

	_desiva 		= CONV_CLEAR(APITOSPA(ALLTRIM(M.ivdesiva))) 
	_imposta_iva 	= VAL(M.ivimpiva)

*!*		IF _imposta_iva  = 0 		&& SCARTA I RECORD DELLE ESENZIONI : MI SPUTTANA L'AGGIORNAMENTO DELLA PRIMA NOTA IN UN MOMENTO SUCCESSIVO
*!*	       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
*!*	       SKIP +1
*!*	       LOOP	
*!*		ENDIF

	  x_tipt  = "SUBSTRING(CODICE,1,3) = 'IVA'" 
	  x_desc  = "DESCRI LIKE '%" + ALLTRIM(_desiva) + "%'"	
	  x_cond  = x_tipt + " and " + x_desc
	  Csql    = "SELECT * FROM PARA WHERE " + x_cond
	  IF !ExecCommand(cSql,"cu_para_iva")
	     return(.f.)
	  ENDIF

	  SELECT cu_para_iva				&& PRELEVA IL CODICE IVA
	  GO TOP
	  IF EOF()
	   	___CODICE_IVA = "???"
	  ELSE
	   	___CODICE_IVA  = SUBSTR(CODICE,4,3)
	  ENDIF        



 	x_codi = "MOV_NOTE LIKE '%" + ALLTRIM(_KEY_pnserial) + "%'"						&& ACCESSO ALLA PRIMA NOTA CON CHIAVEPRIMA NOTA ZUCCHETTI SALVATA IN MOV_NOTE
	
	cSql="SELECT * FROM mov_cont WHERE " + x_codi + " order by mov_soc,mov_anno"
	IF !ExecRW(cSql,"MOV_CONT","R")
	   RETURN .F.
	ENDIF

    _PRIMA_VOLTA = .T.
    
	SELECT MOV_CONT
	GO top
	DO WHILE .not. EOF()
	
	
	
	    SELECT MOV_CONT
	    IF SUBSTR(MOV_NOTE,1,9)='ELABORATO'
	    	SELECT MOV_CONT
	    	SKIP +1
	    	LOOP
	    ENDIF
	
		REPLACE MOV_NDOC WITH __pnnumdoc 
		REPLACE MOV_NPROT WITH __pnnumdoc 
		REPLACE MOV_NREGIS WITH __pnnumreg
		REPLACE MOV_NOTE WITH "ELABORATO"+ALLTRIM(MOV_NOTE)
		*REPLACE MOV_DTDOC WITH  __pndatdoc 	
	
	

		x_soci = "con_soc = '" + PUB_CODSOC + "'"
		x_anno = "con_anno = '" + PUB_ANNO + "'"
		x_cont = "con_conto = '" + ALLTRIM(MOV_CONTO) + "'"
		x_cond = x_soci + " and " + x_anno + " and " + x_cont
		Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
		IF !ExecCommand(cSql,"conti")
		   return(.f.)
		ENDIF
		SELECT conti
		GO TOP
		IF EOF()
		   CLI_FOR='X'
		ELSE
		   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
		ENDIF


		SELECT MOV_CONT
	
		IF CLI_FOR = 'C' OR CLI_FOR = 'F'				&& SCARTA I CLIENTI/FORNITORI
			SELECT MOV_CONT
			SKIP +1
			LOOP
		ENDIF	

		IF CLI_FOR = 'I'								&& PER I RECORD AGGIORNA SOLO IL CODICE IVA
		  
		    IF M.pntipdoc = 'NC'			&& TRATTA NOTE CREDITO CLI/FOR
				IF M.ivtipreg = "V"	AND MOV_TMOV = 'D'	  
				   	SELECT MOV_CONT
				   	REPLACE MOV_IVA    	WITH ___CODICE_IVA      
				ENDIF 

				IF M.ivtipreg = "A"	AND MOV_TMOV = 'A'	  
				   	SELECT MOV_CONT
				   	REPLACE MOV_IVA    	WITH ___CODICE_IVA      
				ENDIF 
			ELSE 							&& TRATTA FATTURE CLI/FOR
				IF M.ivtipreg = "V"	AND MOV_TMOV = 'A'	  
				   	SELECT MOV_CONT
				   	REPLACE MOV_IVA    	WITH ___CODICE_IVA      
				ENDIF 

				IF M.ivtipreg = "A"	AND MOV_TMOV = 'D'	  
				   	SELECT MOV_CONT
				   	REPLACE MOV_IVA    	WITH ___CODICE_IVA      
				ENDIF 
			ENDIF

			SKIP + 1
			LOOP
		ENDIF

        SELECT MOV_CONT
		IF _PRIMA_VOLTA 
			_PRIMA_VOLTA = .F.
			REPLACE MOV_IMPOST WITH _imposta_iva  		&& SALVA IL TOTALE IMPOSTA SULLA PRIMA CONTROPARTITA
		ENDIF
					

	   	REPLACE MOV_IVA    	WITH ___CODICE_IVA      
		SELECT MOV_CONT
		SKIP + 1


	ENDDO 

	IF !ExecRW('','mov_cont','W','','mov_cont')
	   return(.f.)
	ENDIF




    	
    SELECT IMPORTAXLS
	SKIP

ENDDO

	
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


