*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CLIENTI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"del piano dei conti in FORMATO TESTO ?",292,"ATTENZIONE")
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


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIO PIANO DEI CONTI" NOWAIT

		IF !ExecCommand("select * from CONTI where 1=0","curs_CONTI")
		   return
		ENDIF




*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONTI SQL 


		cSql   = "delete from CONTI " 
		IF !ExecCommand(cSql,"CONTI")
		   return(.f.)
		ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
		RELEASE _CTR
		PUBLIC _CTR
		_CTR = 0




		gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF


		WAIT WINDOWS "Selezionato file TESTO >>>>>>>>>>> "+gcFile 		

		CREATE CURSOR IMPORTATXT (CAMPO1  c(140))
		APPEND FROM (gcFile) TYPE sdf	



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTATXT
GO TOP 


DO WHILE !EOF()




    IF DELETED()
       SELECT IMPORTATXT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF SUBSTR(CAMPO1,01,07) = "-------"
       SELECT IMPORTATXT   && scarto  record
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,07) = "XILOPAN"
       SELECT IMPORTATXT   && scarto  record
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,69,09) = "Dettaglio"
       SELECT IMPORTATXT   && scarto  record
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,01,07) = "Stato C"
       SELECT IMPORTATXT   && scarto  record
       SKIP +1
       LOOP
    ENDIF 


   M.CON_CONTO  = SUBSTR(CAMPO1,07,13)
   M.CON_CONTO  = ALLTRIM(CON_CONTO)
   M.CON_CONTO  = STRTRAN(M.CON_CONTO," ","")



*!*	   IF LEN(ALLTRIM(M.CON_CONTO)) > 7									
   IF SUBSTR(M.CON_CONTO,1,1) = "0"				&& TOGLIE IL PRIMO 0 NON SIGNIFICATIVO AI CONTI ELEMENTARI
      M.CON_CONTO = SUBSTR(M.CON_CONTO,2,15)
   ENDIF
*!*	   ENDIF 


   m.id_unique = "" 				
   M.CON_SOC   = '01'
   M.CON_ANNO  = '2011'


   IF SUBSTR(CAMPO1,47,12) = 'Patrimoniale'
      M.CON_POSBIL = 'P'
   ELSE
      M.CON_POSBIL = 'E'
   ENDIF


   IF ALLTRIM(M.CON_CONTO) = "10"									
	  M.CON_CONTO = "8"
   ENDIF 


   IF ALLTRIM(M.CON_CONTO) = "101010"
	  M.CON_CONTO = "80808"
   ENDIF 


   IF ALLTRIM(M.CON_CONTO) = "10101001"
	  M.CON_CONTO = "8080801"
   ENDIF 


    IF ALLTRIM(M.CON_CONTO) = "9999"
	  M.CON_CONTO = "99999"
    ENDIF 

  *!*	ISTRUZIONI DI DECODIFICA DI CONTI PARTICOLARI


   IF LEN(ALLTRIM(M.CON_CONTO)) = 1
      M.CON_CONTO = M.CON_CONTO+"0"
   ELSE
       IF ALLTRIM(M.CON_CONTO) <> "99"
		   IF LEN(ALLTRIM(M.CON_CONTO)) = 2
		      M.CON_CONTO = M.CON_CONTO+"0"
		   ENDIF
	   ENDIF
   ENDIF

   M.CON_DESCR  = SUBSTR(CAMPO1,21,26)
   M.CON_DESCR  = UPPER(M.CON_DESCR)
   M.CON_DESCR  = APITOSPA(M.CON_DESCR)
   
   M.CON_TIPOCO = 'X'
  
  
   IF LEN(ALLTRIM(M.CON_CONTO)) > 5
	   IF SUBSTR(ALLTRIM(M.CON_CONTO),1,5) = "10111" OR SUBSTR(ALLTRIM(M.CON_CONTO),1,5) = "20922"
	      M.CON_TIPOCO = 'I'
	   ENDIF
   ENDIF
 

 


*!*	#####################################################

   	SELECT curs_CONTI				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   


    	
    SELECT IMPORTATXT
	SKIP

ENDDO


SELECT curs_CONTI
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
	    IF VAL(SUBSTR(M.CON_CONTO,1,2)) < 30
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


 