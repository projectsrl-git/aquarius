*************************************************************************************************
*							CONVERSIONE PARTITARI FORNITORI 									*
*							 																	*
*	sistema il numero di dodument del partitario fornitori										*
*	by Sergio Piaggi per Project S.r.l.															*
*	gennaio 2012 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la sistemazione "+CHR(13)+"dei numeri di fattura del partitario FORNITORI XILOPAN	 ?",292,"ATTENZIONE")
		IF RIT = 7
		   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
		   RETURN
		ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
		
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


****** DEFINIZIONE DEI CURSORI STP

		IF !ExecCommand("select * from PART_FOR where 1=0","CURSORE_PART_FOR")
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
PUBLIC	___NAZION   


M.PAR_NUMPRO   	= ""

M.PAR_CODICE = SPACE(10)
M.PAR_CODCLI = SPACE(10)
M.PAR_CODCLI = SPACE(13)
M.PAR_RAGSOC = SPACE(50)
M.PAR_TEL    = SPACE(50)
M.PAR_IVA    = SPACE(50)
M.PAR_CODPAG = SPACE(03)
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







**** CARICAMENTO DEL FILE IN FORMATO TXT




		gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file .TXT >>>>>>>>>>> "+gcFile 		


		=DEF_PART_FOR()


		CREATE CURSOR IMPORTATXT (CAMPO1  c(250))

		
		APPEND FROM (gcFile) TYPE sdf	



***** #########################################################################  ELABORA IL CURSORE transito PER CREARE IL CURSORE STP DI SUPPORTO


M.PAR_DTSCAD    = ""
M.PAR_CODCLI 	= ""
_VALUTA      	= "EURO"
_CTR1 			= 0

SELECT IMPORTATXT
GO TOP 


DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTATXT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    
    IF SUBSTR(CAMPO1,01,07) = "XILOPAN"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 
    
    

    IF SUBSTR(CAMPO1,01,07) = "Tutte l"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


    IF SUBSTR(CAMPO1,01,07) = "St Scad"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,07) = "-------"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


    IF SUBSTR(CAMPO1,01,19) = "             Totale"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,07) = "======="
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,80) = SPACE(80)
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,01)  = CHR(26)
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF      



    
*!*	#####################################################

    SCATTER MEMVAR MEMO


	IF SUBSTR(CAMPO1,01,09) = "Fornitore"
	   __codcf= SUBSTR(CAMPO1,13,06)
	   M.PAR_CODCLI = TRC(PUB_LCL,ALLTRIM(__codcf))
	   =DECODIFICA_FORNITORE(M.PAR_CODCLI)
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
	ENDIF


	IF SUBSTR(CAMPO1,06,01) = "/" AND SUBSTR(CAMPO1,09,01) = "/" 
    ELSE  
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


    M.PAR_DTSCAD = RIBALTA2(OK_DATA(SUBSTR(CAMPO1,04,08)))
    __NUMERO_PARTITA 	= ALLTRIM(SUBSTR(CAMPO1,13,11)) 	   
    M.PAR_NPART		 	= VAL(STRTRAN(__NUMERO_PARTITA ,"/",""))

	M.PAR_CODSOC = PUB_CODSOC
	M.PAR_NUMFAT = ALLTRIM(SUBSTR(CAMPO1,41,06))
	M.PAR_NPROT  = ALLTRIM(SUBSTR(CAMPO1,41,06))

	M.PAR_DTFAT  = RIBALTA2(OK_DATA(SUBSTR(CAMPO1,25,02)+'/'+SUBSTR(CAMPO1,27,02)+'/'+SUBSTR(CAMPO1,29,02)))
	M.PAR_ANNO   = SUBSTR(M.PAR_DTFAT,01,04)


	_IMPORTO1 	= ALLTRIM(SUBSTR(CAMPO1,53,14))
	_SEGNO1=SUBSTR(CAMPO1,67,01)
	IF _SEGNO1='-'
		_IMPORTO1 		= STRTRAN(_IMPORTO1 ,".","")	
	    _IMPORTO1 		= VAL(_IMPORTO1)*-1		
	ELSE
		_IMPORTO1 		= STRTRAN(_IMPORTO1 ,".","")	
	    _IMPORTO1 		= VAL(_IMPORTO1)	
	ENDIF
	
	_IMPORTO2 	= ALLTRIM(SUBSTR(CAMPO1,70,14))
	_SEGNO2=SUBSTR(CAMPO1,84,01)
	IF _SEGNO2='-'
		_IMPORTO2  		= STRTRAN(_IMPORTO2,".","")	
	    _IMPORTO2  		= VAL(_IMPORTO2)*-1		
	ELSE
		_IMPORTO2  		= STRTRAN(_IMPORTO2,".","")	
	    _IMPORTO2  		= VAL(_IMPORTO2)	
	ENDIF
	
	_IMPORTO3 	= ALLTRIM(SUBSTR(CAMPO1,86,14))
	_SEGNO3=SUBSTR(CAMPO1,100,01)
	IF _SEGNO3='-'
		_IMPORTO3 		= STRTRAN(_IMPORTO3,".","")	
	    _IMPORTO3 		= VAL(_IMPORTO3)*-1		
	ELSE
		_IMPORTO3 		= STRTRAN(_IMPORTO3,".","")	
	    _IMPORTO3 		= VAL(_IMPORTO3)	
	ENDIF
	
	
	_VALUTA  = "EURO"
	_IMPORTO 		= _IMPORTO1 + _IMPORTO2  + _IMPORTO3 

    M.PAR_TOTIM 	= _IMPORTO  
    M.PAR_FATT  	= _IMPORTO  
    M.PAR_TIMPOS  	= 0
    



	SELECT PAR_DETTAGLIO					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
	APPEND BLANK
	GATHER MEMVAR MEMO 						&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1

    	
    SELECT IMPORTATXT
	SKIP

ENDDO

SELECT PAR_DETTAGLIO
GO TOP 




SELECT PAR_CODCLI,PAR_NPART,PAR_DTFAT,PAR_NUMFAT FROM PAR_DETTAGLIO GROUP BY PAR_CODCLI,PAR_NPART,PAR_DTFAT,PAR_NUMFAT INTO CURSOR _TMP_PAR_SALDO
SELECT _TMP_PAR_SALDO
GO TOP



DO WHILE !EOF()
			     	
*!*	IF PAR_CODCLI = '2110100001942'
*!*	BROWSE NORMAL
*!*	SET STEP ON 
*!*	ENDIF	
*!*		
	__PAR_NUMFAT = PAR_NUMFAT
    __PAR_CODCLI = PAR_CODCLI
    __PAR_NPART  = STR(PAR_NPART,10,0)
    __PAR_DTFAT  = PAR_DTFAT
 
	
	x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "par_codcli = '" + __PAR_CODCLI + "'"
	x_npar = "par_npart = '" + __PAR_NPART  + "'"	
	x_dtfa = "par_dtfat = '" + __PAR_DTFAT  + "'"	
	
	x_cond = x_soci + " and " + x_codi + " and " + x_npar + " and " + x_dtfa 
	cSql = "select * from PART_FOR where " + x_cond + " order by PAR_CODCLI,PAR_NPART,PAR_DTFAT,PAR_NUMFAT"


	IF !ExecCommand(cSql,"PART_FOR")
	   RETURN .F.
	ENDIF

	SELECT PART_FOR
	GO TOP
	IF !EOF()
	    
	    DO WHILE .NOT.EOF()
			REPLACE PAR_NUMFAT WITH __PAR_NUMFAT 
		    SKIP +1
		ENDDO
		
		IF !ExecRW('','PART_FOR','I','','PART_FOR')
		  return(.f.)
		ENDIF	
		
		WAIT WINDOW "AGGIORNAMENTO EFFETTUATO FORNITORE:"+ALLTRIM(__PAR_CODCLI)+" - PART.:"+ALLTRIM(__PAR_NPART) NOWAIT		
		
	ENDIF





	SELECT _TMP_PAR_SALDO	
	SKIP


ENDDO


	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR


RETURN

	



*****************************
FUNCTION DECODIFICA_FORNITORE
*****************************
PARAMETERS __CODCLI

M.PAR_CODICE = SPACE(10)
M.PAR_CODCLI = SPACE(10)
M.PAR_CODCLI = SPACE(13)
M.PAR_RAGSOC = SPACE(50)
M.PAR_TEL    = SPACE(50)
M.PAR_IVA    = SPACE(50)
M.PAR_CODPAG = SPACE(03)
___NAZION    = SPACE(03)


	M.FOR_CODCLI = TRC(PUB_LCL,ALLTRIM(__CODCLI))
    M.FOR_nazion = "" 
    
    
    x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "FOR_codcli = '" + __CODCLI + "'"
    x_cond = x_soci + " and " + x_codi
    cSql = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"

	IF !ExecCommand(cSql,"cU_FOR_AN")
	  return(.f.)
	ENDIF
	
	SELECT cU_FOR_AN	
	IF RECCOUNT() <> 0
      M.PAR_RAGSOC = FOR_RAGSOC
      M.PAR_CODPAG = FOR_CONPAG
      M.PAR_TEL    = FOR_TELEFO
      M.PAR_IVA    = FOR_PARIVA
	  M.PAR_BANCA  = FOR_BAE
	  ___NAZION    = FOR_NAZION
	ENDIF

    FF = ""
	V_ER = SOTTOGEN(___NAZION)
	IF !V_ER
	   FF = PUB_FF
	ENDIF 

	M.PAR_CODCLI = FF + __CODCLI		
			
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
FUNCTION DEF_PART_FOR
*********************

CREATE CURSOR PAR_DETTAGLIO (PAR_CODSOC C(2),;
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


SELECT PAR_DETTAGLIO
GO TOP 

_TDARE = 0
_TAVERE = 0

DO WHILE !EOF()

    IF DELETED()
       SELECT PAR_DETTAGLIO   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF PAR_NPROG = 100
       SELECT PAR_DETTAGLIO   && scarto i record 100
       SKIP +1
       LOOP
    ENDIF 
     	
 	IF PAR_TMOV = "D"
 	
 	   _TDARE = _TDARE + PAR_FATT 
 	
 	ENDIF
 	
 	
  	IF PAR_TMOV = "A"
 	
 	   _TAVERE = _TAVERE + PAR_FATT 
 	
 	ENDIF
	
 	 	
    IF VAL(SUBSTR(PAR_DTFAT,1,4)) > 2009
    	__MANTIENE_PARTITA_CHIUSA = .T.
    ELSE
    	__MANTIENE_PARTITA_CHIUSA = .F.
	ENDIF    	
     	
     	
    SELECT PAR_DETTAGLIO
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


SELECT PAR_DETTAGLIO
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


