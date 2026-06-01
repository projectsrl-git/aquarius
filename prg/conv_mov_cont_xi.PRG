*************************************************************************************************
*							CONVERSIONE PRIMA NOTA		 										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"della prima nota IN FORMATO TESTO	 ?",292,"ATTENZIONE")
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

		IF !ExecCommand("select * from MOV_CONT where 1=0","curs_MOV_CONT")
		   return
		ENDIF


		IF !ExecCommand("select * from INDICE where 1=0","curs_INDICE")
		   return
		ENDIF

*** CANCELLAZIONE DEI RECORD CONTABILI 


*!*			RIT = MESSAGEBOX("Desideri cancellare "+CHR(13)+"i MOVIMENTI CONTABILI XILOPAN ?",292,"ATTENZIONE")
*!*			IF RIT = 7
*!*			ELSE 
*!*			
*!*				WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE ARCHIVI CONTABILI" NOWAIT		
*!*			

		    _anno = "2011"
			x_soci = "mov_soc = '" + PUB_CODSOC + "'"
			x_anno = "mov_anno = '" + _anno + "'"
			x_cond = x_soci + " and " + x_anno		
			cSql   = "delete from MOV_CONT WHERE " + x_cond 
			IF !ExecCommand(cSql,"MOV_CONT")
			   return(.f.)
			ENDIF
			cSql   = "delete from INDICE WHERE " + x_cond 
			IF !ExecCommand(cSql,"INDICE")
			   return(.f.)
			ENDIF


*!*				
*!*			ENDIF










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

**** CARICAMENTO DEL FILE IN FORMATO TESTO  !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




		gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file TESTO >>>>>>>>>>> "+gcFile 		

		CREATE CURSOR NONTROVATI (CLI_CODCLI  c(10),;
			CLI_RAGSOC   c(80),;
			FOR_CODCLI   c(10),;
			FOR_RAGSOC   c(80),;			
			MESSAGGIO    c(20))



		CREATE CURSOR IMPORTATXT2 (MOV_DTREG c(010),;
			MOV_NREGIS 	c(006),;
			MOV_SEQUEN	N(15,0),;				
			MOV_DTDOC  	c(010),;
			MOV_NDOC   	c(006),;
			MOV_CONTO  	c(013),;
			MOV_CONTOCF	c(013),;
			MOV_TMOV    c(001),;
			MOV_IMP		N(16,3),;							
			MOV_DATSCAD c(010),;
			MOV_SOC		c(002),;			
			MOV_ANNO	c(004),;			
			MOV_VALUTA	c(003),;			
			MOV_TOP		c(003),;	
			MOV_DESTOP	c(030),;								
			MOV_CAMBIO	N(16,3),;			
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
			CAMPO1   c(250))


		CREATE CURSOR IMPORTATXT (CAMPO1  c(250))

		
		APPEND FROM (gcFile) TYPE SDF	



***** #########################################################################  ELABORA IL CURSORE transito PER CREARE IL CURSORE STP DI SUPPORTO


M.MOV_DTREG  = __DATINS
M.MOV_NREGIS = "999999"
M.MOV_SEQUEN = 0


SELECT IMPORTATXT
GO TOP 

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTATXT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF ALLTRIM(CAMPO1) = "*** FINE STAMPA **"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF   

    IF EMPTY(ALLTRIM(SUBSTR(CAMPO1,01,10))) 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 
    
    IF SUBSTR(CAMPO1,01,10) = "----------"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 
    

    IF SUBSTR(CAMPO1,01,11) = "Richiedente"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,04) = "Data"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,03) = "Ora"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,04) = "Note"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,09) = "Parametri"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,08) = "Iniziale"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,18) = "Data registrazione"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,20) = "Numero registrazione"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,09) = "Contabili"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,01) = "N"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,13) = "Corrispettivi"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 
    
    IF SUBSTR(CAMPO1,01,08) = "Pura IVA"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 
        
    IF SUBSTR(CAMPO1,01,11) = "Descrizioni"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF     
    
    IF SUBSTR(CAMPO1,01,04) = "Rate"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF     
    
    IF SUBSTR(CAMPO1,01,14) = "Profilo utente"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF        
    
    IF SUBSTR(CAMPO1,01,18) = "Tipo registrazioni"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF        
        

    IF SUBSTR(CAMPO1,01,19) = "Stato registrazioni"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF        

    IF SUBSTR(CAMPO1,01,12) = "Controvalore"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF

    IF SUBSTR(CAMPO1,01,07) = "XILOPAN"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF
    
    IF SUBSTR(CAMPO1,01,21) = "Causale registrazione"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF    
    
    
    IF SUBSTR(CAMPO1,01,17) = "Totali del giorno"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF     
  
    IF SUBSTR(CAMPO1,01,14) = "Totali globali"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF        

    IF SUBSTR(CAMPO1,01,14) = "- - - - - - - "
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF      
   
    IF SUBSTR(CAMPO1,01,14) = "=============="
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


    IF SUBSTR(CAMPO1,01,15) = "Registrazione n"
    
	 	__GG = SUBSTR(CAMPO1,32,02)
		IF LEN(ALLTRIM(__GG)) = 1
		   __GG = "0"+ALLTRIM(__GG)
		ENDIF
		
		__MM = SUBSTR(CAMPO1,35,02)
		__AA = SUBSTR(CAMPO1,38,02)	
		
		M.MOV_DTREG  	= RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))      

		M.MOV_NREGIS = SUBSTR(CAMPO1,21,06)
		M.MOV_NUMPRO = SYS(2015)
		M.MOV_SEQUEN = 0
    ENDIF      
   
   
WAIT WINDOWS    "Registrazione n : >> " + M.MOV_NREGIS +" <<" NOWAIT
   
*!*	IF M.MOV_NREGIS = "277081"
*!*	SET STEP ON 
*!*	ENDIF 
   
     *!*714026,25 A EURO 
     *!*EURO INIZIA ALLA 13 
     *!*A/D INIZIA ALLA 11
     *!*IMPORTO PARTE DA 1 A 10 (DEVE ESSERE TUTTO DINAMICO           
            
    
	IF SUBSTR(CAMPO1,89,04)<> "EURO"
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
	ENDIF
    
     
	IF SUBSTR(CAMPO1,87,01) = "D" OR SUBSTR(CAMPO1,87,01) = "A"
	ELSE
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
	ENDIF
	

	SELECT IMPORTATXT
	SKIP +1
	__RAGIONE_SOCIALE_CLIENTE_FORNITORE	 	= SUBSTR(CAMPO1,31,23)
	SKIP -1
	
	M.MOV_TMOV = SUBSTR(CAMPO1,87,01)    

    
	_IMPORTO   = SUBSTR(CAMPO1,73,13)
*!*		_IMPORTO   = REPLACEALLCHR(_IMPORTO,",", ".")	
			
	M.MOV_IMP = VAL(_IMPORTO)

  
    *!*263 31/01/11  
    *!*263 31/01/11
	*!*	DATA DOCUMENTO DALLA POSIZIONE 5
	*!*	NUMERO DOCUMENTO DALLA 1 ALL1 3 : TUTTO DINAMICO  
    
    

	M.MOV_NDOC  	= SUBSTR(CAMPO1,56,06)
	__GG = SUBSTR(CAMPO1,62,02)
	IF LEN(ALLTRIM(__GG)) = 1
	   __GG = "0"+ALLTRIM(__GG)
	ENDIF
	
	__MM = SUBSTR(CAMPO1,65,02)
	__AA = SUBSTR(CAMPO1,68,02)	
	
	M.MOV_DTDOC 	= RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))   
	M.MOV_DATSCAD	= M.MOV_DTDOC
	
	
	M.MOV_SOC    	= "01"
	M.MOV_ANNO   	= PUB_ANNO
	M.MOV_VALUTA 	= "EUR"
	
	M.MOV_CONTO  	= SUBSTR(CAMPO1,31,08)

    IF EMPTY(ALLTRIM(M.MOV_CONTO))
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF      


    M.MOV_CONTO     =DECODIFICA_CONTO_CONTABILE(M.MOV_CONTO)	
	M.MOV_CONTOCF 	= SUBSTR(CAMPO1,45,08)
	
	
	IF SUBSTR(M.MOV_CONTOCF,1,1) = "C"
		M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(SUBSTR(M.MOV_CONTOCF,3,10)))
		=DECODIFICA_CLIENTE(M.CLI_CODCLI)
	ENDIF

	IF SUBSTR(M.MOV_CONTOCF,1,1) = "F"
		M.FOR_CODCLI = TRC(PUB_LCL,ALLTRIM(SUBSTR(M.MOV_CONTOCF,3,10)))
		=DECODIFICA_FORNITORE(M.FOR_CODCLI)
	ENDIF


   =AGGIORNA_CONTI(M.MOV_CONTO)

	
	M.MOV_SEQUEN    = M.MOV_SEQUEN + 1	
	
	M.MOV_TOP	 	= SUBSTR(CAMPO1,01,03)
	M.MOV_DESTOP 	= SUBSTR(CAMPO1,05,25)
	
	M.MOV_CAMBIO 	= 1
	M.MOV_IVA    	= "NO"
	
	
*!*		M.MOV_DESMOV = "Apertura 01/01/" + PUB_ANNO

	M.MOV_COSATRATTA 		= "GENER"
	M.MOV_GRADOIMPORTANZA 	= "PRIMA"
	M.MOV_FORMAPAGAMENTO 	= "RIMES"
	M.MOV_TIPOCONTRATTO 	= "SCADE"
	M.MOV_CODACQ 			= "001"
	M.MOV_PRIPAGA 			= "0500"
	M.MOV_DTVAL 			= M.MOV_DTREG
	M.MOV_ANOMAX 			= ""
	M.MOV_CONTABILITA_PREVISIONALE = ""
	M.MOV_ANNODO 			= PUB_ANNO
	M.MOV_EXTRA_NUMDOC 		= ""
	M.MOV_EXTRA_DATDOC 		= ""
	M.MOV_EXTRA_SYSDOC 		= ""
	M.MOV_BOLLATOIVA 		= .F.
	
	
	
	
	
		

 	SELECT IMPORTATXT2					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
   * WAIT WINDOWS "RECORDS ELABORATI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTATXT
	SKIP

ENDDO

	

***** #########################################################################  ELABORA IL CURSORE DI SUPPORTO


SELECT IMPORTATXT2
GO TOP 


_CTR = 0

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTATXT2   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    
    
*!*	    IF MOV_DTREG <> "2011/05/02"
*!*	       WAIT WINDOWS "Record scartato ............" nowait
*!*	       SELECT IMPORTATXT2   && scarto i record cancellati
*!*	       SKIP +1
*!*	       LOOP
*!*	    ENDIF 
*!*	     
*!*	   
    
*!*	#####################################################

    SCATTER MEMVAR MEMO

	SELECT curs_MOV_CONT
	APPEND BLANK
	GATHER MEMVAR MEMO

    =CREA_INDICE()

    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTATXT2
	SKIP

ENDDO

	 
	 
	 	 


****** AGGIORNA TABELLA MOV_CONT
IF !ExecRW('','MOV_CONT','I','','curs_MOV_CONT')
   return(.f.)
ENDIF
	 	 

SELECT NONTROVATI 
GO TOP
BROWSE NORMAL


	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

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


*!*	IF ALLTRIM(M.FOR_CODCLI) = "00002252"

*!*	  SET STEP ON 
*!*	  
*!*	ENDIF



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
*!*		IF !ExecRW(cSql,"INDICE","R")
*!*		   return(.f.)
*!*		ENDIF
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

*!*		  IF !ExecRW(cSql,"INDICE","W")
*!*			  return(.f.)
*!*		  ENDIF
 
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
PARAMETERS __CONTO__

SS=STR(SELECT())


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
REPLACE CON_ANNO   WITH "2011"
REPLACE CON_CONTO  WITH ALLTRIM(__CONTO__)
REPLACE CON_DESCR  WITH __RAGIONE_SOCIALE_CLIENTE_FORNITORE


REPLACE CON_TIPOCO WITH "A"
REPLACE CON_POSBIL WITH "P"	

IF VAL(SUBSTR(__CONTO__,1,2)) > 29
	REPLACE CON_POSBIL WITH "E"	
ENDIF


IF SUBSTR(__CONTO__,1,2) = "21"
	REPLACE CON_TIPOCO WITH "F"
	REPLACE CON_POSBIL WITH "P"	
ENDIF


REPLACE CON_VALUTA WITH "EUR"




IF !ExecRW('','CONTI','I','','CONTI')
  return(.f.)
ENDIF	

SELECT &SS

RETURN

