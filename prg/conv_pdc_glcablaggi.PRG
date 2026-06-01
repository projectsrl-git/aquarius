*************************************************************************************************
*							CONVERSIONE PIANO DEI CONTI											*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2019 : GlCablaggi			 														*
*************************************************************************************************


 
** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "GLC"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'GLC' non configurato" + CHR(13) + CHR(13) + ;
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

RIT = MESSAGEBOX("Conversione piano dei conti da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



****** DEFINIZIONE DEI CURSORI STP


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE PIANO DEI CONTI ESERCIZIO " + PUB_ANNO NOWAIT

IF !ExecCommand("select * from CONTI where 1=0","curs_CONTI")
   return
ENDIF
SELECT curs_CONTI
INDEX ON CON_CONTO TAG I_CONTO



*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONTI SQL 


x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno 
Csql   = "delete from CONTI where " + x_cond 
IF !ExecCommand(cSql,"CONTI")
   return(.f.)
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CTR
PUBLIC _CTR
_CTR = 0

															


CREATE CURSOR IMPORTAXLS ( ;
	pat_eco		C(25), ;
	at_pa_co_ri	C(25), ;
	codice		C(15), ;
	descri		C(100))

APPEND FROM (gcFile) TYPE XLS




RELEASE MASTRO_CORRENTE,PE_CORRENTE  
PUBLIC MASTRO_CORRENTE,PE_CORRENTE  

MASTRO_CORRENTE = ""
PE_CORRENTE     = ""


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS
GO TOP 


DO WHILE !EOF()


    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF EMPTY(ALLTRIM(PAT_ECO))   && SCARTO RECORD 
       SELECT IMPORTAXLS  
       SKIP +1
       LOOP
    ENDIF 
 

  
    SCATTER MEMVAR MEMO 


	M.CON_CONTO  		= ALLTRIM(M.CODICE)
     
    MASTRO_CORRENTE  	= M.CON_CONTO
    LEN_MASTRO       	= LEN(MASTRO_CORRENTE)

    DO CASE 
    	CASE LEN_MASTRO   = (PUB_MASTRO -1)
  			=INTERCETTA_DATI_CONTO()  
    
    	CASE LEN_MASTRO   = (PUB_SOTTOG -1)
			=INTERCETTA_DATI_SOTTOCONTO()
		
		OTHERWISE         
    		 =INTERCETTA_DATI_CONTO_ELEMENTARE()  
   		  
    ENDCASE
    

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO


SELECT curs_CONTI
SET ORDER TO I_CONTO
GO TOP

    

SELECT curs_CONTI
SET ORDER TO I_CONTO
GO TOP


****** AGGIORNA TABELLA CONTI SQL
IF !ExecRW('','CONTI','I','','curs_CONTI')
   return(.f.)
ENDIF
	 
IF !ExecCommand("select * from CONTI where 1=0","curs_CONTI")
   return
ENDIF


*!*	############################################################################################################ 	CONTROLLO STRUTTURA PIANO CONTI


***  ARCHIVIO CONTENENTE LA STRUTTURA DEI CONTI ELABORATA DA CONTI ELEMENTARI :
***  CONTIENE SIA I CONTI DI DUE CARATTERI CHE I SOTTOCONTI DI 4 CARATTERI
CREATE CURSOR CONTI_STR ;
	(KCONTO C(5), KDESCR C(40), KDARE N(12), KAVERE N(12), KVOLTE N(8))
INDEX ON KCONTO TAG CONTI_STR 



****  ANALISI PIANO DEI CONTI CREA CONTI CON 2 CARATTERI
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"CUR_CONTI")
   RETURN .F.
ENDIF
SELECT CUR_CONTI
GO TOP   

V_ERRATI = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF LEN(ALLTRIM(CON_CONTO)) < PUB_MASTRO-1
      SKIP +1
      LOOP
   ENDIF

   XCONTO = SUBSTR(CON_CONTO,1,PUB_MASTRO-1)
   XDARE  = CON_IMP_D
   XAVERE = CON_IMP_A
   XDESCR = CON_DESCR
  
   SELECT CONTI_STR
   SEEK XCONTO

   IF !FOUND()
      APPEND BLANK
      REPLACE    KCONTO    WITH XCONTO
      REPLACE    KDESCR    WITH XDESCR
      REPLACE    KDARE     WITH XDARE
      REPLACE    KAVERE    WITH XAVERE
      REPLACE    KVOLTE    WITH 0
   ENDIF

   SELECT CUR_CONTI
   SKIP +1
  
ENDDO
		
****  ANALISI PIANO DEI CONTI CREA CONTI CON SOTTOGRUPPI XXXX OPPURE XXXXX CARATTERI
SELECT CUR_CONTI
GO TOP

V_ERRATI = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF LEN(ALLTRIM(CON_CONTO)) < PUB_SOTTOG-1
      SKIP +1
      LOOP
   ENDIF

   XCONTO = SUBSTR(CON_CONTO,1,PUB_SOTTOG-1)
   XDARE  = CON_IMP_D
   XAVERE = CON_IMP_A
   XDESCR = CON_DESCR
  
   SELECT CONTI_STR
   SEEK XCONTO
   
   IF !FOUND()
      APPEND BLANK
      REPLACE    KCONTO    WITH XCONTO
      REPLACE    KDESCR    WITH XDESCR
      REPLACE    KDARE     WITH XDARE
      REPLACE    KAVERE    WITH XAVERE
      REPLACE    KVOLTE    WITH 0
   ENDIF

   SELECT CUR_CONTI
   SKIP +1
  
ENDDO

**** VERIFICA L'ESISTENZA DEI CONTI MASTRO : XX OPPURE XXX , SOTTOGRUPPO XXXX OPPURE XXXXX CHR OTTENUTI SU PIANO DEI CONTI
SELECT CUR_CONTI
GO TOP

V_ERRATI = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF LEN(ALLTRIM(CON_CONTO)) > PUB_SOTTOG-1
      SKIP +1
      LOOP
   ENDIF

   XCONTO = SUBSTR(CON_CONTO,1,PUB_SOTTOG-1)
   XDARE  = CON_IMP_D
   XAVERE = CON_IMP_A
   XDESCR = CON_DESCR
  
   SELECT CONTI_STR 
   SEEK XCONTO
   
   IF FOUND()
      REPLACE    KVOLTE    WITH KVOLTE + 1
      V_ERRATI = V_ERRATI + 1   
   ENDIF

   SELECT CUR_CONTI
   SKIP +1
  
ENDDO



SELECT CONTI_STR
GO TOP
REPLACE    KDESCR    WITH "GRUPPO MANCANTE: DA INSERIRE" FOR KVOLTE = 0

SET FILTER TO KVOLTE = 0
GO TOP

IF V_ERRATI > 0

	SELECT CONTI_STR
	GO TOP 
	DO WHILE .NOT.EOF()
	
		M.CON_CONTO  = KCONTO
        M.CON_DESCR  = "DESCRIZIONE CONTO DA AGGIORNARE ****************"
  		M.CON_TIPOCO = 'X'
	    IF VAL(SUBSTR(M.CON_CONTO,1,2)) < 36
	      M.CON_POSBIL = 'P'
	    ELSE
	      M.CON_POSBIL = 'E'
	    ENDIF

		SELECT curs_CONTI
	    APPEND BLANK
	    GATHER MEMVAR MEMO
	
	
	    SELECT CONTI_STR
		SKIP +1
		
	ENDDO

	SELECT curs_CONTI
	GO TOP


	****** AGGIORNA TABELLA CONTI SQL
	IF !ExecRW('','CONTI','I','','curs_CONTI')
	   return(.f.)
	ENDIF
		 

	SELECT CONTI_STR
	GO TOP 
	BROWSE NORMAL
	
ENDIF




=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


****************************************************************
FUNCTION INTERCETTA_DATI_CONTO 
****************************************************************
  
	   
	   M.CON_DESCR  = ALLTRIM(M.DESCRI)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN


****************************************************************
FUNCTION INTERCETTA_DATI_SOTTOCONTO 
****************************************************************


	   
	   M.CON_DESCR  = ALLTRIM(M.DESCRI)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN



****************************************************************
FUNCTION INTERCETTA_DATI_CONTO_ELEMENTARE 
****************************************************************
	   
	   M.CON_DESCR  = ALLTRIM(M.DESCRI)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   
   
       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN

****************************************************************
FUNCTION COMPILA_ALTRI_DATI_PIANO_DEI_CONTI
****************************************************************

   m.id_unique = "" 				
   M.CON_SOC   = '01'
   M.CON_ANNO  = PUB_ANNO
   M.CON_TIPOCO = 'X'
  

   IF VAL(SUBSTR(M.CON_CONTO,1,(PUB_MASTRO -1)))  < 71		&& PATRIMONIALI SINO AL 70
      PE_CORRENTE = 'P'
   ELSE
      PE_CORRENTE = 'E'
   ENDIF	 
	     
   M.CON_POSBIL = PE_CORRENTE

  
   IF SUBSTR(ALLTRIM(M.CON_CONTO),1,4) = "2020" 			&& MASTRO IVA
	    IF LEN(ALLTRIM(M.CON_CONTO)) > 4 
       		M.CON_TIPOCO = 'I'								&& CONTO IVA
   		ENDIF
   ENDIF


*!*	#####################################################

   SELECT curs_CONTI					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

							   
   _CTR = _CTR +1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   




RETURN
