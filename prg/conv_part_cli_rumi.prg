*************************************************************************************************
*							CONVERSIONE PARTITARI CLIENTI 										*
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

RIT = MESSAGEBOX("Conversione partitario clienti da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PART_CLI where 1=0","cursore_part_cli")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DEI PARTITARI SQL 



RIT = MESSAGEBOX("Desideri cancellare "+CHR(13)+"il partitario clienti RUMI ?",292,"ATTENZIONE")
IF RIT = 7
ELSE 
    WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE ARCHIVI PARTITARI CLIENTI" NOWAIT
	cSql = "delete from PART_CLI"
	IF !ExecCommand(cSql,"PART_CLI")
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



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = RIBALTA2(DTOC(DATE()))
_CTR = 0


RELEASE _TtDARE,_TtAVERE,_TtSALDO
PUBLIC _TtDARE,_TtAVERE,_TtSALDO
_TtDARE	 = 0
_TtAVERE = 0
_TtSALDO = 0

RELEASE    	__MANTIENE_PARTITA_CHIUSA
PUBLIC     	__MANTIENE_PARTITA_CHIUSA
__MANTIENE_PARTITA_CHIUSA = .F.


RELEASE M.PAR_NUMPRO   	
PUBLIC  M.PAR_NUMPRO 


RELEASE	M.PAR_CODICE 
RELEASE	M.PAR_CODCLI 
RELEASE	M.PAR_CODCLI 
RELEASE	M.PAR_RAGSOC 
RELEASE	M.PAR_TEL    
RELEASE	M.PAR_IVA    
RELEASE	M.PAR_CODPAG 
RELEASE M.PAR_VALUTA
RELEASE	___NAZION  


RELEASE	M.PAR_TIPFAT
RELEASE	M.TOP     			
RELEASE	CONIVAX   			
RELEASE	TCOD01    			
RELEASE	TCOD02    			
RELEASE	TCOD03    			
RELEASE	TCOD04    			
RELEASE	DES       			 
RELEASE	TP        			
RELEASE	FATTURA   			
RELEASE	VER_CONTO 			
RELEASE	NATURA    			
RELEASE	NO_AUT	  			
RELEASE	PR_NO	  			
RELEASE	PR_SI	  			
RELEASE	PR_TOP	  			
RELEASE	PR_ANA	  			
RELEASE	PR_LIS    			
RELEASE	PR_LAN    			
RELEASE	__CEE     			
RELEASE	IL_CCO    			
RELEASE	IN_CCO    			
RELEASE	TPROC     			
RELEASE	AGGANCIAPARTITARI 	
RELEASE	CANT    			
RELEASE	noquadra            
RELEASE	pincamulti 			
RELEASE	NOTACREDITO         
RELEASE	CREAPART           
RELEASE	CONTRCCO  			
RELEASE	NOCOMME             



PUBLIC	M.PAR_TIPFAT
PUBLIC	M.TOP     			
PUBLIC	CONIVAX   			
PUBLIC	TCOD01    			
PUBLIC	TCOD02    			
PUBLIC	TCOD03    			
PUBLIC	TCOD04    			
PUBLIC	DES       			 
PUBLIC	TP        			
PUBLIC	FATTURA   			
PUBLIC	VER_CONTO 			
PUBLIC	NATURA    			
PUBLIC	NO_AUT	  			
PUBLIC	PR_NO	  			
PUBLIC	PR_SI	  			
PUBLIC	PR_TOP	  			
PUBLIC	PR_ANA	  			
PUBLIC	PR_LIS    			
PUBLIC	PR_LAN    			
PUBLIC	__CEE     			
PUBLIC	IL_CCO    			
PUBLIC	IN_CCO    			
PUBLIC	TPROC     			
PUBLIC	AGGANCIAPARTITARI 	
PUBLIC	CANT    			
PUBLIC	noquadra            
PUBLIC	pincamulti 			
PUBLIC	NOTACREDITO         
PUBLIC	CREAPART           
PUBLIC	CONTRCCO  			
PUBLIC	NOCOMME             


PUBLIC  M.PAR_CODICE 
PUBLIC	M.PAR_CODCLI 
PUBLIC	M.PAR_CODCLI 
PUBLIC	M.PAR_RAGSOC 
PUBLIC	M.PAR_TEL    
PUBLIC	M.PAR_IVA    
PUBLIC	M.PAR_CODPAG 
PUBLIC  M.PAR_VALUTA
PUBLIC	___NAZION   


M.PAR_NUMPRO   	= ""

M.PAR_CODICE = SPACE(10)
M.PAR_CODCLI = SPACE(10)
M.PAR_CODCLI = SPACE(13)
M.PAR_RAGSOC = SPACE(50)
M.PAR_TEL    = SPACE(50)
M.PAR_IVA    = SPACE(50)
M.PAR_CODPAG = SPACE(03)
M.PAR_VALUTA = SPACE(03)
___NAZION    = SPACE(03)



M.PAR_TIPFAT		= " "
M.TOP     			= "   "
CONIVAX   			= " " 
TCOD01    			= " "
TCOD02    			= " "
TCOD03    			= " "
TCOD04    			= " "
DES       			= " "  
TP        			= " "
FATTURA   			= " "
VER_CONTO 			= " "
NATURA    			= " "
NO_AUT	  			= " "
PR_NO	  			= " "
PR_SI	  			= " "
PR_TOP	  			= " "
PR_ANA	  			= " "
PR_LIS    			= " "
PR_LAN    			= " "
__CEE     			= " "
IL_CCO    			= " "
IN_CCO    			= " "
TPROC     			= " "
AGGANCIAPARTITARI 	= " "
CANT    			= " "
noquadra            = " "
pincamulti 			= " "
NOTACREDITO         = " "
CREAPART            = " "
CONTRCCO  			= " "
NOCOMME             = " "



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




CREATE CURSOR IMPORTAXLS ( ;
			numpar	  c(50),;
			datsca	  c(50),;
			tipcon	  c(50),;
			codcon	  c(50),;
			timpdar	  c(50),;
			timpave	  c(50),;
			codval	  c(50),;
			modpag	  c(50),;
			banapp	  c(50),;
			bannos	  c(50),;
			numdoc	  c(50),;
			alfdoc	  c(50),;
			datdoc	  c(50),;
			flcrsa	  c(50),;
			ptserial  c(50),;
			ptroword  c(50),;
			ptorigsa  c(50),;
			cprownum  c(50),;
			datrag	  c(50),;
			flsosp	  c(50),;
			florig	  c(50),;
			numcon	  c(50),;
			decval	  c(50),;
			codbun	  c(50),;
			codage	  c(50),;
			descon	  c(50),;
			simval	  c(50),;
			ornumdoc  c(50),;
			oralfdoc  c(50),;
			ordatdoc  c(50),;
			ptdescri  c(50),;
			indiri	  c(50),;
			locali	  c(50),;
			capclf	  c(50),;
			provin	  c(50),;
			descon2	  c(50),;
			caoval	  c(50),;
			valclf	  c(50),;
			ordine	  c(50),;
			tipocol	  c(50),;
			pttotabb  c(50),;
			descau	  c(50),;
			esposiz	  c(50),;
			mpdescri  c(50),;
			saldo	  c(50),;
			insoluto  c(50),;
			tiprif	  c(50),;
			conrif	  c(50),;
			agente	  c(50),;
			zero	  c(50),;
			tippag	  c(50),;
			valuta	  c(50),;
			pagamento c(50),;
			scaduto	  c(50),;
			scad30	  c(50),;
			scad60	  c(50),;
			scad90	  c(50),;
			scadenze  c(50),;
			coserial  c(50),;
			numcont	  c(50),;
			dsserial  c(50),;
			numero	  c(50),;
			dsmezspe  c(50),;
			dsdatinv  c(50),;
			dsimpint  c(50),;
			dsimpspe  c(50),;
			tipo	  c(50),;
			sollsim	  c(50),;
			solldec	  c(50),;
			sollrif	  c(50),;
			sollcon	  c(50),;
			totespo	  c(50),;
			impdar	  c(50),;
			impave	  c(50))

SELECT IMPORTAXLS 
INDEX ON ALLTRIM(datsca) TAG i_dtsca ADDITIVE 


	
APPEND FROM (gcFile) TYPE XLS





***** #########################################################################  ELABORA IL CURSORE transito PER CREARE IL CURSORE STP DI SUPPORTO



=DEF_PART_CLI()

M.PAR_DTSCAD    = ""
M.PAR_CODCLI 	= ""
M.PAR_DESMOV    = ""
_VALUTA      	= "EURO"
_CTR1 			= 0
PRIMO_CLIENTE   = .T.	&& PRIMO CLIENTE

*!*	__NUMERO_PARTITA_OLD = 0	
*!*	__NUMERO_PARTITA     = 1111

__NUMERO_PARTITA_OLD = ""	
__NUMERO_PARTITA     = ""
M.NPART              = 0	
prima_volta 		 = .t.

SELECT IMPORTAXLS
SET ORDER TO i_dtsca  
GO TOP 


DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(NUMPAR)) = "NUMPAR"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  
       SKIP +1
       LOOP
    ENDIF 
    

    IF UPPER(ALLTRIM(CONRIF)) = "ZZZZZZZZZZZZZZZ"  && SCARTO RECORD 
       SELECT IMPORTAXLS  
       SKIP +1
       LOOP
    ENDIF 
      

    SCATTER MEMVAR MEMO

    *M.numpar
	*M.NPART  					= M.NPART + 1 

	__NUMERO_PARTITA     		= SUBSTR(M.numpar,1,4)+SUBSTR(M.numpar,6,6) 



	IF __NUMERO_PARTITA_OLD <> __NUMERO_PARTITA     		&& DETERMINA IL NUMERO DI PARTITA INTERNO A ROTTURA DI PARTITA RUMI    
		
		IF prima_volta
		    prima_volta = .f.
		ELSE  
			=CREA_PARTITARIO()
		ENDIF 
		__NUMERO_PARTITA_OLD    = __NUMERO_PARTITA

	ENDIF 

 
	_DESCRI_TOP	= ALLTRIM(M.DESCAU)
	M.PAR_TIPFAT = "GEN"
	=DECODIFICA_TOP_PER_DESCRIZIONE(_DESCRI_TOP)
    SELECT IMPORTAXLS	 

   
    IF LEN(ALLTRIM(M.codcon)) = 15
    	M.PAR_CODCLI = SUBSTR(M.codcon,8,8)
    ELSE
    	M.PAR_CODCLI = ALLTRIM(M.codcon)
    ENDIF
    =DECODIFICA_CLIENTE(M.PAR_CODCLI)
    SELECT IMPORTAXLS	 


	M.PAR_CODSOC = PUB_CODSOC
	M.PAR_NUMFAT = ALLTRIM(m.numdoc)		
	M.PAR_NPROT  = ALLTRIM(CONV_CLEAR(M.PAR_NUMFAT))

	__AA	= SUBSTR(M.datdoc,7,4)
	__MM	= SUBSTR(M.datdoc,4,2)
	__GG	= SUBSTR(M.datdoc,1,2)

	M.PAR_DTFAT  = RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))
    M.PAR_DTFAT  = ALLTRIM(CONV_CLEAR(M.PAR_DTFAT))

	
	M.PAR_NPART = VAL(__NUMERO_PARTITA)	
	
	__AA	= SUBSTR(M.datsca,7,4)
	__MM	= SUBSTR(M.datsca,4,2)
	__GG	= SUBSTR(M.datsca,1,2)

	M.PAR_DTSCAD = RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))

	IF EMPTY(ALLTRIM(M.PAR_DTSCAD))
		M.PAR_DTSCAD = M.PAR_DTFAT
	ENDIF

	M.PAR_ANNO   = SUBSTR(M.PAR_DTFAT,01,04)

	M.PAR_TIPODO = "PAG"
	M.PAR_NPROG  = 900 
	
	IF FATTURA = "S"
		M.PAR_TIPODO = "FAT"
		M.PAR_NPROG  = 100 
	ENDIF
	
	IF FATTURA = "P"
		M.PAR_TIPODO = "PAG"
		M.PAR_NPROG  = 900 
	ENDIF

	M.PAR_DTREG    	= M.PAR_DTFAT
	M.PAR_NREG     	= ""


    _DARE    = 0
    _AVERE   = 0

	M.PAR_CAMBIO = 1


	_VALUTA  = "EURO"
	_DARE 	= VAL(m.timpdar)
	_AVERE 	= VAL(m.timpave)

    M.PAR_DESMOV    = ALLTRIM(m.mpdescri)

    M.PAR_TMOV = ""
    M.PAR_TOTIM = 0  
    M.PAR_FATT  = 0  


	IF _DARE   >  0
	    M.PAR_TMOV = "D"
	    M.PAR_TOTIM = ROUND((_DARE),2)  
	    M.PAR_FATT  = ROUND((_DARE),2)  	    
	ENDIF
	 
	IF _AVERE   >  0
		M.PAR_TMOV = "A"
	    M.PAR_TOTIM = ROUND((_AVERE),2) 
	    M.PAR_FATT  = ROUND((_AVERE),2) 		
	ENDIF

    M.PAR_CIVA1 	= "NO"
    M.PAR_NUMPRO   	= SYS(2015)


	*!*		CAMPI RECUPERO CREDITI
	M.PAR_TIPOPA = "" 
	M.PAR_DTUSOL = ""  
	M.PAR_STORIA = "" 
	M.PAR_NUMSOL = 0
	M.PAR_NOPART = .F.
	M.PAR_DTNEWS = ""   
	M.PAR_ALLE01 = ""  
	M.PAR_ALLE02 = ""  
	M.PAR_ALLE03 = ""  
	M.PAR_ALLE04 = ""  
	M.PAR_ALLE05 = ""  
	*!*		CAMPI RECUPERO CREDITI


		

 	SELECT PARTITARIO_CLIENTI						&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 								&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

	IF FATTURA = "S"
		M.PAR_NPROG  = M.PAR_NPROG + 100 
	 	SELECT PARTITARIO_CLIENTI					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
	   	APPEND BLANK	
	   	GATHER MEMVAR MEMO 							&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
	ENDIF


    _CTR = _CTR +1

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO



=CREA_PARTITARIO()		&& ultimi movimenti

	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR


RETURN

	

************************
FUNCTION CREA_PARTITARIO
************************




_TtDARE	 = 0
_TtAVERE = 0
_Ttsaldo = 0
__MANTIENE_PARTITA_CHIUSA = .F.

=VERIFICA_QUADRATURA_PARTITA()

_Ttsaldo = _TtDARE - _TtAVERE 


SELECT PARTITARIO_CLIENTI
GO TOP 


DO WHILE !EOF()

    IF DELETED()
       SELECT PARTITARIO_CLIENTI   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    SCATTER MEMVAR MEMO


	**=CERCA_MOV_CONT(M.PAR_CODCLI,M.PAR_DTFAT,M.PAR_NUMFAT)


	SELECT cursore_part_cli
	APPEND BLANK
	GATHER MEMVAR MEMO


    _CTR1 = _CTR1 +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR1,10,0) NOWAIT

    	
    SELECT PARTITARIO_CLIENTI
	SKIP +1

ENDDO



****** AGGIORNA TABELLA PART_CLI
IF !ExecRW('','PART_CLI','I','','cursore_part_cli')
   return(.f.)
ENDIF


IF !ExecCommand("select * from PART_CLI where 1=0","cursore_part_cli")
   return
ENDIF

=DEF_PART_CLI()
	 	 

RETURN


***********************************
FUNCTION DECODIFICA_CONTO_CONTABILE
***********************************
PARAMETERS __CONTO


   M.MOV_CONTO  = ALLTRIM(__CONTO)
   M.MOV_CONTO  = STRTRAN(M.MOV_CONTO," ","")


   IF SUBSTR(M.MOV_CONTO,1,1) = "A"
      M.MOV_CONTO = SUBSTR(M.MOV_CONTO,2,15)
   ENDIF

   IF LEN(ALLTRIM(M.MOV_CONTO)) > 7									&& TOGLIE IL PRIMO 0 NON SIGNIFICATIVO AI CONTI ELEMENTARI
	   IF SUBSTR(M.MOV_CONTO,1,1) = "0"
	      M.MOV_CONTO = SUBSTR(M.MOV_CONTO,2,15)
	   ENDIF
   ENDIF 

   IF ALLTRIM(M.MOV_CONTO) = "10"									
	  M.MOV_CONTO = "8"
   ENDIF 


   IF ALLTRIM(M.MOV_CONTO) = "101010"
	  M.MOV_CONTO = "80808"
   ENDIF 


   IF ALLTRIM(M.MOV_CONTO) = "10101001"
	  M.MOV_CONTO = "8080801"
   ENDIF 


    IF ALLTRIM(M.MOV_CONTO) = "9999"
	  M.MOV_CONTO = "99999"
    ENDIF 


   IF LEN(ALLTRIM(M.MOV_CONTO)) = 1
      M.MOV_CONTO = M.MOV_CONTO+"0"
   ELSE
       IF ALLTRIM(M.MOV_CONTO) <> "99"
		   IF LEN(ALLTRIM(M.MOV_CONTO)) = 2
		      M.MOV_CONTO = M.MOV_CONTO+"0"
		   ENDIF
	   ENDIF
   ENDIF


   M.MOV_CONTO = ALLTRIM(M.MOV_CONTO)


RETURN M.MOV_CONTO 


***************************
FUNCTION DECODIFICA_CLIENTE
***************************
PARAMETERS __CODCLI

M.PAR_CODICE = SPACE(10)
M.PAR_CODCLI = SPACE(10)
M.PAR_CODCLI = SPACE(13)
M.PAR_RAGSOC = SPACE(50)
M.PAR_TEL    = SPACE(50)
M.PAR_IVA    = SPACE(50)
M.PAR_CODPAG = SPACE(03)
M.PAR_VALUTA = SPACE(03)
___NAZION    = SPACE(03)


	M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(__CODCLI))
    M.cli_nazion = "" 
    
    
    x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "cli_codcli = '" + __CODCLI + "'"
    x_cond = x_soci + " and " + x_codi
    cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"

	IF !ExecCommand(cSql,"cu_cli_an")
	  return(.f.)
	ENDIF
	
	SELECT cu_cli_an	
	IF RECCOUNT() <> 0
      M.PAR_RAGSOC = CLI_RAGSOC
      M.PAR_CODPAG = CLI_CONPAG
      M.PAR_TEL    = CLI_TELEFO
      M.PAR_IVA    = CLI_PARIVA
	  M.PAR_BANCA  = CLI_BAE
	  ___NAZION    = CLI_NAZION
	  M.PAR_VALUTA = CLI_VALUTA
	ENDIF

    CC = ""
	V_ER = SOTTOGEN(___NAZION)
	IF !V_ER
	   CC = PUB_CC
	ENDIF 

	M.PAR_CODCLI = CC + __CODCLI		
			
	M.PAR_CODCLI = ALLTRIM(M.PAR_CODCLI)	
	

	

RETURN

**************************
FUNCTION DECODIFICA_VALUTA
**************************

    IF SUBSTR(CAMPO1,01,07) = " Divisa"
       _VALUTA = SUBSTR(CAMPO1,12,04) 
    ENDIF      


RETURN

**********************************
FUNCTION DECODIFICA_TOP_PER_CODICE
**********************************
PARAMETERS __CODTOP

	__DESTOP			= CERCA_TOP(__CODTOP)
	SELECT CUR_PARA
	M.TOP     			= UPPER(M.TOP)
	CONIVAX   			= CONIVA  
	TCOD01    			= CONTO1
	TCOD02    			= CONTO2
	TCOD03    			= CONTO3
	TCOD04    			= CONTO4
	DES       			= DESCRI     
	TP        			= SUBSTR(LIBERA,1,1)
	FATTURA   			= SUBSTR(LIBERA,2,1)
	VER_CONTO 			= SUBSTR(LIBERA,12,1)
	NATURA    			= TP
	NO_AUT	  			= SUBSTR(LIBERA,16,1)
	PR_NO	  			= SUBSTR(LIBERA,17,1)
	PR_SI	  			= SUBSTR(LIBERA,18,1)
	PR_TOP	  			= SUBSTR(LIBERA,19,1)
	PR_ANA	  			= SUBSTR(LIBERA,20,1)
	PR_LIS    			= SUBSTR(LIBERA,21,1)
	PR_LAN    			= SUBSTR(LIBERA,22,1)
	__CEE     			= SUBSTR(LIBERA,23,1)
	IL_CCO    			= SUBSTR(LIBERA,31,1)
	IN_CCO    			= SUBSTR(LIBERA,32,1)
	TPROC     			= SUBSTR(LIBERA,38,3)
	AGGANCIAPARTITARI 	= SUBSTR(LIBERA,44,1)
	CANT    			= SUBSTR(LIBERA,45,1)     		&& PAGAMENTO IN CONTO ANTICIPO A=AGENTE;F=FORNITORE;C=CLIENTE
	noquadra            = SUBSTR(LIBERA,46,1)
	pincamulti 			= SUBSTR(LIBERA,48,1)
	NOTACREDITO         = SUBSTR(LIBERA,11,1)
	CREAPART            = SUBSTR(LIBERA,41,1)
	CONTRCCO  			= SUBSTR(LIBERA,49,1)
	NOCOMME             = SUBSTR(LIBERA,54,1)


RETURN


***************************************
FUNCTION DECODIFICA_TOP_PER_DESCRIZIONE
***************************************
PARAMETERS __DESTOP


	M.PAR_TIPFAT 		= CERCA_TOP_PER_DESCRIZIONE(__DESTOP)
	M.TOP     			= UPPER(M.TOP)
	CONIVAX   			= CONIVA  
	TCOD01    			= CONTO1
	TCOD02    			= CONTO2
	TCOD03    			= CONTO3
	TCOD04    			= CONTO4
	DES       			= DESCRI     
	TP        			= SUBSTR(LIBERA,1,1)
	FATTURA   			= SUBSTR(LIBERA,2,1)
	VER_CONTO 			= SUBSTR(LIBERA,12,1)
	NATURA    			= TP
	NO_AUT	  			= SUBSTR(LIBERA,16,1)
	PR_NO	  			= SUBSTR(LIBERA,17,1)
	PR_SI	  			= SUBSTR(LIBERA,18,1)
	PR_TOP	  			= SUBSTR(LIBERA,19,1)
	PR_ANA	  			= SUBSTR(LIBERA,20,1)
	PR_LIS    			= SUBSTR(LIBERA,21,1)
	PR_LAN    			= SUBSTR(LIBERA,22,1)
	__CEE     			= SUBSTR(LIBERA,23,1)
	IL_CCO    			= SUBSTR(LIBERA,31,1)
	IN_CCO    			= SUBSTR(LIBERA,32,1)
	TPROC     			= SUBSTR(LIBERA,38,3)
	AGGANCIAPARTITARI 	= SUBSTR(LIBERA,44,1)
	CANT    			= SUBSTR(LIBERA,45,1)     		&& PAGAMENTO IN CONTO ANTICIPO A=AGENTE;F=FORNITORE;C=CLIENTE
	noquadra            = SUBSTR(LIBERA,46,1)
	pincamulti 			= SUBSTR(LIBERA,48,1)
	NOTACREDITO         = SUBSTR(LIBERA,11,1)
	CREAPART            = SUBSTR(LIBERA,41,1)
	CONTRCCO  			= SUBSTR(LIBERA,49,1)
	NOCOMME             = SUBSTR(LIBERA,54,1)


RETURN


*********************
FUNCTION DEF_PART_CLI
*********************

CREATE CURSOR PARTITARIO_CLIENTI (PAR_CODSOC C(2),;
	PAR_ANNO C(4),;
	PAR_TIPODO C(3),;
	PAR_NUMPRO C(13),;
	PAR_NREG C(10),;
	PAR_NPART N(10,0),;
	PAR_NPROG N(5,0),; 
	PAR_CODCLI C(13),; 
	PAR_RAGSOC C(40),; 
	PAR_TEL C(15),; 
	PAR_IVA C(11),; 
	PAR_DTREG C(10),; 
	PAR_DTFAT C(10),; 
	PAR_NUMFAT C(6),; 
	PAR_TMOV C(1),;
	PAR_TIPFAT 	C(3),; 
	PAR_TOTIM	N(17,3),; 
	PAR_TIMPOS	N(17,3),;
	PAR_FATT 	N(17,3),; 
	PAR_IMPO1 	N(17,3),; 
	PAR_IMPOS1	N(17,3),;
	PAR_TOT1 	N(17,3),; 
	PAR_CIVA1 	C(3),;
	PAR_IMPO2 	N(17,3),; 
	PAR_IMPOS2	N(17,3),;
	PAR_TOT2 	N(17,3),; 
	PAR_CIVA2 	C(3),; 
	PAR_IMPO3	N(17,3),; 
	PAR_IMPOS3	N(17,3),;
	PAR_TOT3	N(17,3),; 
	PAR_CIVA3 	C(3),; 
	PAR_IMPO4 	N(17,3),;
	PAR_IMPOS4	N(17,3),; 
	PAR_TOT4	N(17,3),;
	PAR_CIVA4	C(3),;
	PAR_IMPO5	N(17,3),;
	PAR_IMPOS5 	N(17,3),;
	PAR_TOT5 	N(17,3),; 
	PAR_CIVA5 	C(3),;
	PAR_CODPAG	C(3),; 
	PAR_DTSCAD 	C(10),;
	PAR_UTPPAR	N(5,0),; 
	PAR_DAPAG 	N(17,3),;
	PAR_GIAPAG 	N(17,3),; 
	PAR_DATPAG 	C(10),; 
	PAR_PAGATO 	N(17,3),; 
	PAR_FATRI 	L,; 
	PAR_NPROT	C(6),; 
	PAR_CLOSE 	L,;
	PAR_DESMOV 	C(45),;
	PAR_DESMO1 	C(45),; 
	PAR_CAMBIO 	N(15,10),; 
	PAR_IMPVAL 	N(18,4),; 
	PAR_VALUTA 	C(3),; 
	PAR_DTVAL 	C(10),; 
	PAR_SYS	 	C(10),; 
	PAR_BANCA	C(5),;
	PAR_CONTABILITA_PREVISIONALE 	C(1),; 
	PAR_NPARTO 	N(10,0),; 
	PAR_CODACQ 	C(3),; 
	PAR_TIPOCONTRATTO 	C(5),; 
	PAR_FORMAPAGAMENTO 	C(5),; 
	PAR_GRADOIMPORTANZA C(5),; 
	PAR_COSATRATTA 	C(5),; 
	PAR_PRIPAGA C(4),; 
	PAR_FATTD 	N(17,3),; 
	PAR_FATTA	N(17,3),; 
	PAR_ANOMAX 	C(3),; 
	PAR_NPORI 	C(10),; 
	PAR_NUCOM 	C(30),; 
	PAR_RIFASC 	L,;
	SYS_PARTI 	C(10),; 
	PAR_TIPOPA  C(3),; 
	PAR_DTUSOL  C(10),; 
	PAR_STORIA  M,;
	PAR_NUMSOL  N(6,0),; 
	PAR_NOPART  L,; 
	PAR_DTNEWS  C(10),; 
	PAR_ALLE01  C(240),;   
	PAR_ALLE02  C(240),;  
	PAR_ALLE03  C(240),; 
	PAR_ALLE04  C(240),; 
	PAR_ALLE05  C(240),; 
	CAMPO1   c(250))

RETURN



***********************
FUNCTION CERCA_SCADENZE
***********************
PARAMETERS __CONTO__,__NUMDOC__,__IMPDOC__

IF EMPTY(__NUMDOC__)
	RETURN
ENDIF

IF __IMPDOC__ = 0
	RETURN
ENDIF



_IMPORTO = ALLTRIM(STR(__IMPDOC__,13,2))
_IMPORTO = STRTRAN(_IMPORTO,",",".")
_C_F = 'C'


x_conto = "SOTTOCONTO = '" + ALLTRIM(SUBSTR(__CONTO__,5,13)) + "'"
x_c_f   = "C_F = '" + _C_F + "'"
x_nudoc = "NUMDOCUM   = " + __NUMDOC__ + ""
x_imdoc = "EIMPFATTUR  = " + _IMPORTO + ""

x_cond = x_conto + " and " + x_c_f + " and " + x_nudoc + " and " + x_imdoc

cSql="SELECT * FROM CARD_SCADENZE WHERE " + x_cond + " order by SOTTOCONTO,NUMDOCUM,EIMPFATTUR"
IF !ExecCommand(cSql,"CARD_SCADENZE")
   return(.f.)
ENDIF
SELECT CARD_SCADENZE
GO TOP
IF !EOF()
    *WAIT WINDOWS "SCADENZA TROVATA !!!!!!!!!!! : CONTO "+ __CONTO__ + " NUMFAT " + __NUMDOC__ + " IMPORTO " + _IMPORTO NOWAIT
	
	_CODPAGAM = ALLTRIM(CONV_CLEAR(CODPAGAM))
	IF ISNULL(_CODPAGAM)
	ELSE 
		M.PAR_CODPAG  =CARDIOLINE_DECODIFICA_CODICE_CPA(_CODPAGAM)
	ENDIF 
	
	_DATASCAD = ALLTRIM(CONV_CLEAR(DATASCAD))
	IF ISNULL(_DATASCAD)
	ELSE 
		M.PAR_DTSCAD  =SUBSTR(_DATASCAD,1,4) + "/" + SUBSTR(_DATASCAD,5,2) + "/" + SUBSTR(_DATASCAD,7,2) 
	ENDIF 	
	
	_DESCRAGG = ALLTRIM(CONV_CLEAR(DESCRAGG))
	IF ISNULL(_DESCRAGG )
	ELSE 
		M.PAR_DESMOV  =ALLTRIM(_DESCRAGG)
	ENDIF 
	

	*M.PAR_ANNO    = ESEREGISTR

ENDIF



RETURN


***********************
FUNCTION CERCA_MOV_CONT
***********************
PARAMETERS __CONTO__,__DTDOC__,__NDOC__

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
IF EOF()
	M.PAR_NUMPRO   	= SYS(2015)
ELSE 
	M.PAR_NUMPRO   	= MOV_NUMPRO
ENDIF 




RETURN


************************************
FUNCTION VERIFICA_QUADRATURA_PARTITA
************************************



SELECT PARTITARIO_CLIENTI
GO TOP 

_TDARE = 0
_TAVERE = 0

DO WHILE !EOF()

    IF DELETED()
       SELECT PARTITARIO_CLIENTI   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF PAR_NPROG = 100
       SELECT PARTITARIO_CLIENTI   && scarto i record 100
       SKIP +1
       LOOP
    ENDIF 
     	
 	IF PAR_TMOV = "D"
 	
 	   _TDARE = _TDARE + PAR_FATT 
 	
 	ENDIF
 	
 	
  	IF PAR_TMOV = "A"
 	
 	   _TAVERE = _TAVERE + PAR_FATT 
 	
 	ENDIF
	
 	 	
   	
     	
    SELECT PARTITARIO_CLIENTI
	SKIP +1

ENDDO

RELEASE _TSALDO 
PUBLIC _TSALDO 
_TSALDO = _TDARE - _TAVERE

__TMOV  = ''
__TFATT = 0

IF _TSALDO <> 0

	IF BETW(ABS(_TSALDO ),-0.02,0.02)
		=CREA_COMPENSAZIONI()
	ENDIF


ENDIF


_TtDARE	 = _TDARE 
_TtAVERE = _TAVERE

IF __TMOV  = 'D'
	_TtDARE = _TtDARE + __TFATT 
ENDIF

IF __TMOV  = 'A'
	_TtAVERE = _TtAVERE + __TFATT 
ENDIF


RETURN

***************************
FUNCTION CREA_COMPENSAZIONI
***************************


SELECT PARTITARIO_CLIENTI
GO TOP 
SCATTER MEMVAR MEMO

APPEND BLANK
GATHER MEMVAR MEMO


REPLACE PAR_TIPODO  WITH "PAG"
REPLACE PAR_NPROG   WITH 990

REPLACE PAR_TIPFAT  WITH "AR$"
REPLACE PAR_TMOV    WITH IIF(_TSALDO < 0,"D","A")

__TMOV  = PAR_TMOV

REPLACE PAR_TOTIM   WITH ABS(_TSALDO)
REPLACE PAR_TIMPOS  WITH 0
REPLACE PAR_FATT    WITH ABS(_TSALDO)

__TFATT = PAR_FATT    

REPLACE PAR_CIVA1   WITH "NO"
REPLACE PAR_IMPO1   WITH 0
REPLACE PAR_IMPOS1  WITH 0
REPLACE PAR_TOT1    WITH 0
REPLACE PAR_CIVA2   WITH "NO"
REPLACE PAR_IMPO2   WITH 0
REPLACE PAR_IMPOS2  WITH 0
REPLACE PAR_TOT2    WITH 0
REPLACE PAR_CIVA3   WITH "NO"
REPLACE PAR_IMPO3   WITH 0
REPLACE PAR_IMPOS3  WITH 0
REPLACE PAR_TOT3    WITH 0
REPLACE PAR_CIVA4   WITH "NO"
REPLACE PAR_IMPO4   WITH 0
REPLACE PAR_IMPOS4  WITH 0
REPLACE PAR_TOT4    WITH 0
REPLACE PAR_CIVA5   WITH "NO"
REPLACE PAR_IMPO5   WITH 0
REPLACE PAR_IMPOS5  WITH 0
REPLACE PAR_TOT5    WITH 0
REPLACE PAR_VALUTA  WITH "EUR"
REPLACE PAR_IMPVAL  WITH 0




RETURN


