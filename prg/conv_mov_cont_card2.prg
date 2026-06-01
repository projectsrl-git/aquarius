*************************************************************************************************
*							CONVERSIONE PRIMA NOTA		 										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Ottobre 2013 : Cardioline			 														*
*************************************************************************************************


		*SET DECIMAL TO 6  && GESTIONE EURO

		*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"della prima nota IN FORMATO TESTO ( da MOVCO SQL) di Cardioline  ?",292,"ATTENZIONE")
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

		WAIT WINDOWS "Attendere prego ..... cancellazione archivi contabili in corso" NOWAIT	


		****** DEFINIZIONE DEI CURSORI STP

		IF !ExecCommand("select * from MOV_CONT where 1=0","curs_MOV_CONT")
		   return
		ENDIF

		*!*			IF !ExecCommand("select * from CARD_MOVCO where 1=0","CARD_MOVCO_RAGGRUPPATA")
		*!*			   return
		*!*			ENDIF


		*** CANCELLAZIONE DEI RECORD CONTABILI 


		*!*			RIT = MESSAGEBOX("Desideri cancellare "+CHR(13)+"i MOVIMENTI CONTABILI XILOPAN ?",292,"ATTENZIONE")
		*!*			IF RIT = 7
		*!*			ELSE 
		*!*			
		*!*				WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE ARCHIVI CONTABILI" NOWAIT		
		*!*			


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


		*!*				
		*!*			ENDIF



			*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_VVA_CH SQL
			cSql = "delete from U_VVA_CH where 1=1"
			IF !ExecCommand(cSql,"U_VVA_CH")
			   return(.f.)
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
			CAMPO1   c(250))



***** #########################################################################  ELABORA IL FILE DI PRIMA NOTA 



	gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

	IF EMPTY(gcFile)
		MESSAGEBOX("Nessun file selezionato",64,"Informazione")
		SET DEFAULT TO &PUB_DIR  
		RETURN
	ENDIF

	CREATE CURSOR IMPORTATXT (CAMPO1  c(250))
	APPEND FROM (gcFile) TYPE SDF	



***** #########################################################################  ELABORA IL CURSORE transito PER CREARE IL CURSORE STP DI SUPPORTO

		

	**==> Cursore per memorizzare i riferimenti dei documenti extra contabili
	CREATE CURSOR CARD_MOVCO_RAGGRUPPATA (;
	  NUMERO  		C(07)	, ;
	  DATAREG	  	C(10)	, ;
	  DATADOCUM	  	C(10)	, ;
	  SOTTOCONTO    C(10)	, ;
	  DARE    		N(16,3)	, ;
	  AVERE   		N(16,3)	, ;
	  SALDO   		N(16,3))
	INDEX ON NUMERO  TAG I_NUMERO


 	*SET DECIMAL TO 10  && GESTIONE EURO	
	SELECT IMPORTATXT 
	GO TOP

	
	DO WHILE .NOT.EOF()
	
	    IF DELETED()
	       SELECT IMPORTATXT   && scarto i record cancellati
	       SKIP +1
	       LOOP
	    ENDIF 

	    IF EMPTY(ALLTRIM(SUBSTR(CAMPO1,01,10))) 				 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    IF SUBSTR(CAMPO1,01,10) = "CARDIOLINE"							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    IF SUBSTR(CAMPO1,01,10) = "VIA DE ZIN"							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    IF SUBSTR(CAMPO1,01,10) = "40126     "							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    IF SUBSTR(CAMPO1,01,10) = "Partita IV"							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    IF SUBSTR(CAMPO1,01,10) = "Codice Fis"							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    IF SUBSTR(CAMPO1,01,10) = "Data Regis"							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    IF SUBSTR(CAMPO1,01,10) = "Iva       "							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    	    
	    IF SUBSTR(CAMPO1,01,10) = "00002     "							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    
	    IF SUBSTR(CAMPO1,01,10) = "Iva       "							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 

	    IF SUBSTR(CAMPO1,01,10) = "TOTALI STA"							 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF 
	    
	    IF !EMPTY(ALLTRIM(SUBSTR(CAMPO1,19,03))) 					&& CAUSALE				 
	       SELECT IMPORTATXT    
	       SKIP +1
	       LOOP	   
	    ENDIF	    
     
	    
		_NUMERO		= ""											&& NUMERO DI REGISTRAZIONE
		
		__AA		= CONV_CLEAR(SUBSTR(CAMPO1,07,04)) 				&& DATA REGISTRAZIONE
		__MM		= CONV_CLEAR(SUBSTR(CAMPO1,04,02))
		__GG		= CONV_CLEAR(SUBSTR(CAMPO1,01,02))
		_DATAREG    = __AA+__MM+__GG     

		__AA		= CONV_CLEAR(SUBSTR(CAMPO1,85,04)) 				&& DATA DOCUMENTO
		__MM		= CONV_CLEAR(SUBSTR(CAMPO1,82,02))
		__GG		= CONV_CLEAR(SUBSTR(CAMPO1,79,02))
		_DATADOCUM	= __AA+__MM+__GG

		_SOTTOCONTO	= ALLTRIM(CONV_CLEAR(SUBSTR(CAMPO1,90,10)))		&& SOTTOCONTO


		*!*	 IF _DATAREG = '20130131'  and _SOTTOCONTO = '06010005' && and eimporto = '631002.64'
		*!*	 SET STEP ON 
		*!*	 ENDIF

 
		_IMPORTO_D 	= ALLTRIM(SUBSTR(CAMPO1,173,20))
		_IMPORTO_D 	= STRTRAN(_IMPORTO_D,".","")	
		_IMPORTO_D 	= ALLTRIM(CONV_CLEAR(_IMPORTO_D))

		_IMPORTO_A	= ALLTRIM(SUBSTR(CAMPO1,190,23))
		_IMPORTO_A	= STRTRAN(_IMPORTO_A,".","")					
		_IMPORTO_A	= ALLTRIM(CONV_CLEAR(_IMPORTO_A))
		
	    _IMPORTO_Dn = VAL(_IMPORTO_D)								&& IMPORTO DARE
	    _IMPORTO_An = VAL(_IMPORTO_A)   							&& IMPORTO AVERE

		_IMPORTO    = 0
		
		IF _IMPORTO_Dn > 0
			_IMPORTO = _IMPORTO_Dn 
		ENDIF 

		IF _IMPORTO_An > 0
			_IMPORTO = _IMPORTO_An 
		ENDIF 
		 
		_IMPORTOx = ALLTRIM(STR(_IMPORTO,17,2))
		_IMPORTOx = STRTRAN(_IMPORTOx,",",".")			

		** RICERCA LA PRIMA NOTA SULLA TABELLA CARD_MOVCO PER DATA REGISTRAZIONE+DATA DOCUMENTO+SOTTOCONTO+IMPORTO

		cSql=""     
		cNomeCursorSql="CARD_MOVCO_VERY"
		TEXT TO cSql NOSHOW
			SELECT * FROM card_movco
			WHERE datareg = '<<_DATAREG>>' and datadocum = '<<_DATADOCUM>>' and sottoconto = '<<_SOTTOCONTO>>' and eimporto = '<<_IMPORTOx>>'
		ENDTEXT
		IF !ExecPreparedCommand(cSql,cNomeCursorSql)
			return(.F.)
		ENDIF	
		SELECT CARD_MOVCO_VERY		
		IF !EOF()
			_NUMERO 	= NUMERO				&& NUMERO REGISTRAZIONE PRIMA NOTA
		ELSE
			
		
		    ** SECONDO ACCESSO PER DATA REGISTRAZIONE+SOTTOCONTO+IMPORTO
			cSql=""     
			cNomeCursorSql="CARD_MOVCO_VERY"
			TEXT TO cSql NOSHOW
				SELECT * FROM card_movco
				WHERE datareg = '<<_DATAREG>>' and sottoconto = '<<_SOTTOCONTO>>' and eimporto = '<<_IMPORTOx>>'
			ENDTEXT
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF	
			SELECT CARD_MOVCO_VERY		
			IF !EOF()
				_NUMERO 	= NUMERO				&& NUMERO REGISTRAZIONE PRIMA NOTA
			ELSE
				_NUMERO 	= _NUMERO_REGISTRAZIONE_NON_TROVATO
				WAIT WINDOWS "************************** REGISTRAZIONE NON TROVATA :"+ _NUMERO NOWAIT
			ENDIF		
			
		
		ENDIF 




        WAIT WINDOWS "REGISTRAZIONE IN ELABORAZIONE :"+ _NUMERO NOWAIT
	
		TDARE  = TDARE  + _IMPORTO_Dn 
		TAVERE = TAVERE + _IMPORTO_An 
		TSALDO = TSALDO + (_IMPORTO_Dn - _IMPORTO_An) 
		
		SELECT CARD_MOVCO_RAGGRUPPATA
		SET ORDER TO I_NUMERO
		SEEK _NUMERO
		IF !FOUND()
			APPEND BLANK
			REPLACE NUMERO    	WITH _NUMERO	
			REPLACE DATAREG    	WITH _DATAREG	
			REPLACE DATADOCUM 	WITH _DATADOCUM	
			REPLACE SOTTOCONTO 	WITH _SOTTOCONTO	
			
			REPLACE DARE   		WITH _IMPORTO_Dn 
			REPLACE AVERE  		WITH _IMPORTO_An 
			REPLACE SALDO  		WITH _IMPORTO_Dn - _IMPORTO_An 					
		ENDIF
		
		SELECT IMPORTATXT 
		SKIP +1
		
	ENDDO

	TSALDO = TDARE - TAVERE
	WAIT WINDOWS "TOTALE DARE : " +STR(TDARE,13,2)	+ " AVERE : " + STR(TAVERE,13,2) + " SALDO : " + STR(TSALDO,13,2)


	M.MOV_DTREG  = __DATINS
	M.MOV_NREGIS = "999999"
	M.MOV_SEQUEN = 0


	** RIELABORAZIONE DEL CURSORE CARD_MOVCO_RAGGRUPPATA AL FINE DI ELABORARE LA VERA PRIMA NOTA PER RIPORTARLA SU MOV_CONT DI AQUARIUS
	SELECT CARD_MOVCO_RAGGRUPPATA
	SET ORDER TO I_NUMERO
	GO TOP 

	DO WHILE !EOF()

	    IF DELETED()
	       SELECT CARD_MOVCO_RAGGRUPPATA   && scarto i record cancellati
	       SKIP +1
	       LOOP
	    ENDIF 
	    
	*!*	#####################################################

	    SCATTER MEMVAR MEMO
		
		__NUMERO_REGISTRAZIONE 	= M.NUMERO
		__NUMPRO 				= SYS(2015)
		
		WAIT WINDOWS    "Registrazione n : >> " + __NUMERO_REGISTRAZIONE +" <<" NOWAIT

		** ACCESSO A CARD_MOVCO : ELABORA LA PRIMA NOTA DALLA TABELLA ORIGINALE
		cSql=""     
		cNomeCursorSql="CARD_MOVCO"

		TEXT TO cSql NOSHOW
		
			SELECT * FROM CARD_MOVCO
			WHERE SUBSTRING(DATAREG,1,4) = '<<PUB_ANNO>>' AND NUMERO = '<<__NUMERO_REGISTRAZIONE>>'
			and SOSPESO_SN <> 'S'
			and SIMULAZ_SN <> 'S'
			and TEMPORA_SN <> 'S'					
			ORDER BY DATAREG,NUMERO
			
		ENDTEXT

		IF !ExecPreparedCommand(cSql,cNomeCursorSql)
			return(.F.)
		ENDIF		
		

		SELECT CARD_MOVCO
		GO TOP 
		DO WHILE .NOT. EOF()


			SCATTER MEMVAR MEMO

			IF ISNULL(M.SEGNO)
				M.SEGNO = 'D'
			ENDIF  
			IF M.SEGNO = 'D' OR M.SEGNO = 'A'
			ELSE
				M.SEGNO = 'D'
			ENDIF
			
			IF ISNULL(M.EIMPORTO)
				M.EIMPORTO = 0
			ENDIF 
			 
			IF ISNULL(M.NUMDOCUM)
				M.NUMDOCUM = SUBSTR(M.NUMERO,2,6)	&& FORZO IL NUMERO DI REGISTRAZIONE
			ENDIF  
		
			
			__RIGAN = VAL(SUBSTR(M.RIGA,3,3))
			__RIGAN = __RIGAN +1	
			__RIGA  = STR(__RIGAN,3,0)	
			__AA	= SUBSTR(M.DATAREG,1,4)
			__MM	= SUBSTR(M.DATAREG,5,2)
			__GG	= SUBSTR(M.DATAREG,7,2)
			
			IF ISNULL(M.ECAMBIO)
				M.ECAMBIO = 1
			ENDIF  

			IF M.ECAMBIO = 0
				M.ECAMBIO = 1
			ENDIF  

			IF ISNULL(M.CODVALUTA)
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

			IF ISNULL(M.DATADOCUM)
				M.DATADOCUM = M.DATAREG		&& FORZO DATA REGISTRAZIONE
			ENDIF  
			__AA	= SUBSTR(M.DATADOCUM,1,4)
			__MM	= SUBSTR(M.DATADOCUM,5,2)
			__GG	= SUBSTR(M.DATADOCUM,7,2)
					
			M.MOV_DTDOC 					= RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))   
			M.MOV_DATSCAD					= M.MOV_DTDOC
			M.MOV_SOC    					= "01"
			M.MOV_ANNO   					= PUB_ANNO


			M.MOV_VALUTA 					= M.CODVALUTA
			M.MOV_CONTO  					= ALLTRIM(CONV_CLEAR(M.SOTTOCONTO))
			
			IF M.C_F = "C"
				M.CLI_CODCLI = TRC(PUB_LCL,M.MOV_CONTO)
				=DECODIFICA_CLIENTE(M.CLI_CODCLI)
			ENDIF

			IF M.C_F = "F"
				M.FOR_CODCLI = TRC(PUB_LCL,M.MOV_CONTO)
				=DECODIFICA_FORNITORE(M.FOR_CODCLI)
			ENDIF


			=AGGIORNA_CONTI(M.C_F,M.MOV_CONTO)


			M.MOV_TOP	 					= CONV_CLEAR(M.CAUSALE)
			*M.MOV_CAMBIO 					= 1/M.ECAMBIO

			M.MOV_CAMBIO 					= ROUND(1/M.ECAMBIO,10)
			
			M.MOV_IVA    					= "NO"
			M.MOV_DESMOV 					= CONV_CLEAR(M.DESCRAGG)
			M.MOV_COSATRATTA 				= "GENER"
			M.MOV_GRADOIMPORTANZA 			= "PRIMA"
			M.MOV_FORMAPAGAMENTO 			= "RIMES"
			M.MOV_TIPOCONTRATTO 			= "SCADE"
			M.MOV_CODACQ 					= "001"
			M.MOV_PRIPAGA 					= "0500"
			
			IF ISNULL(M.DATACAMBIO)
				M.DATACAMBIO= ""
			ENDIF  
			
			IF EMPTY(M.DATACAMBIO)
				M.MOV_DTVAL 				= M.MOV_DTREG			
			ELSE
				__AA	= SUBSTR(M.DATACAMBIO,1,4)
				__MM	= SUBSTR(M.DATACAMBIO,5,2)
				__GG	= SUBSTR(M.DATACAMBIO,7,2)
				M.MOV_DTVAL					= RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))  
			ENDIF  
			

			IF M.MOV_VALUTA <> "EUR"
				=CREA_U_VVA_CH_CARD(M.MOV_VALUTA,M.MOV_DTVAL,M.MOV_CAMBIO)
			ENDIF  

			

			M.MOV_ANOMAX 					= ""
			M.MOV_CONTABILITA_PREVISIONALE 	= ""
			M.MOV_ANNODO 					= PUB_ANNO
			M.MOV_EXTRA_NUMDOC 				= ""
			M.MOV_EXTRA_DATDOC 				= ""
			M.MOV_EXTRA_SYSDOC 				= ""
			M.MOV_BOLLATOIVA 				= .F.
			

		 	SELECT CARD_MOV_CONT				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
		   	APPEND BLANK
		   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

			SELECT CARD_MOVCO
			SKIP +1
			
		ENDDO WHILE .NOT. EOF()


	    	
	    SELECT CARD_MOVCO_RAGGRUPPATA
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

	SELECT curs_MOV_CONT
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




IF __TIPO_CONTO__ = "A"		&& SOLO PER ALTRI CONTI ACCEDE A PIACON
	x_cont = "SOTTOCONTO = '" + ALLTRIM(__CONTO__) + "'"
	x_cond = x_cont
	Csql   = "select * from CARD_PIACON where " + x_cond + " order by SOTTOCONTO"
	IF !ExecCommand(cSql,"CARD_PIACON")
	   RETURN .F.
	ENDIF
	SELECT CARD_PIACON 
	GO TOP
	IF !EOF()
		__DESCRIZIONE_CONTO = DESCRIZION
	ENDIF
ENDIF 



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

IF VAL(SUBSTR(__CONTO__,1,2)) > 59
	REPLACE CON_POSBIL WITH "E"	
ENDIF


REPLACE CON_VALUTA WITH "EUR"




IF !ExecRW('','CONTI','I','','CONTI')
  return(.f.)
ENDIF	

SELECT &SS

RETURN

