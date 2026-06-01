*************************************************************************************************
*							CONVERSIONE PIANO DEI CONTI											*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2013 : Cardioline			 														*
*************************************************************************************************


RELEASE _ANNO_CONTABILE
PUBLIC _ANNO_CONTABILE
_ANNO_CONTABILE = ""



*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"del piano dei conti in FORMATO EXCEL ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


_ANNO_CONTABILE = PJ_INPUTBOX("Digitare l'esercizio contabile","",ALLTRIM(PUB_ANNO))
IF EMPTY(_ANNO_CONTABILE)
	MESSAGEBOX("Operazione annullata",48,"Attenzione")
	RETURN .F.
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
SELECT curs_CONTI
INDEX ON CON_CONTO TAG I_CONTO



*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONTI SQL 


x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + _ANNO_CONTABILE + "'"
x_cond = x_soci + " and " + x_anno		
cSql   = "delete from CONTI WHERE " + x_cond 
IF !ExecCommand(cSql,"CONTI")
   return(.f.)
ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CTR
PUBLIC _CTR
_CTR = 0




gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF


WAIT WINDOWS "Selezionato file >>>>>>>>>>> "+gcFile 		


CREATE CURSOR IMPORTAXLS (CAMPO_00   c(80),;
	CAMPO_01   c(80),;
	CAMPO_02   c(80),;
	CAMPO_03   c(80),;
	CAMPO_04   c(80),;
	CAMPO_05   c(80),;
	CAMPO_06   c(80),;			
	CAMPO_07   c(80))
	


APPEND FROM (gcFile) TYPE xls	

RELEASE MASTRO_CORRENTE,PE_CORRENTE  
PUBLIC MASTRO_CORRENTE,PE_CORRENTE  

MASTRO_CORRENTE = ""
PE_CORRENTE     = ""

   

***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS
GO TOP 


DO WHILE !EOF()




    IF DELETED()
       SELECT IMPORTAXLS   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    



    IF SUBSTR(CAMPO_01,01,05) = "00002"						&& RECORD SOCIETA'
       SELECT IMPORTAXLS    
       SKIP +1
       LOOP	   
    ENDIF 


    IF SUBSTR(CAMPO_01,01,01) = "0"							&& DATI CONTO
	   =INTERCETTA_DATI_CONTO()
       SELECT IMPORTAXLS    
       SKIP +1
       LOOP	   
    ENDIF 

    IF SUBSTR(CAMPO_02,01,01) = "0"							&& DATI SOTTOCONTO
	   =INTERCETTA_DATI_SOTTOCONTO()
       SELECT IMPORTAXLS    
       SKIP +1
       LOOP	   
    ENDIF 


    IF !EMPTY(ALLTRIM(SUBSTR(CAMPO_05,01,01))) 				&& DATI CONTO ELEMENTARE
	   =INTERCETTA_DATI_CONTO_ELEMENTARE()
       SELECT IMPORTAXLS    
       SKIP +1
       LOOP	   
    ENDIF 

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO


SELECT curs_CONTI
SET ORDER TO I_CONTO
GO TOP

** CREA I GRUPPI/SOTTOGRUPPI CLIENTI /FORNITORI
SCATTER MEMVAR MEMO

APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CON_CONTO WITH "07"
REPLACE CON_DESCR WITH "CLIENTI"

APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CON_CONTO WITH "0701"
REPLACE CON_DESCR WITH "CLIENTI ITALIANI"

APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CON_CONTO WITH "0702"
REPLACE CON_DESCR WITH "CLIENTI CEE"

APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CON_CONTO WITH "0703"
REPLACE CON_DESCR WITH "CLIENTI EXTRA CEE"



APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CON_CONTO WITH "08"
REPLACE CON_DESCR WITH "FORNITORI"

APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CON_CONTO WITH "0801"
REPLACE CON_DESCR WITH "FORNITORI ITALIANI"
  
APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CON_CONTO WITH "0802"
REPLACE CON_DESCR WITH "FORNITORI COMUNITARI"

APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CON_CONTO WITH "0803"
REPLACE CON_DESCR WITH "FORNITORI EXTRA CEE"
    

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
x_anno = "con_anno = '" + _ANNO_CONTABILE + "'"
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
	    IF VAL(SUBSTR(M.CON_CONTO,1,2)) < 60
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

	   M.CON_CONTO  = SUBSTR(CAMPO_01,02,15)
	   M.CON_CONTO  = ALLTRIM(CON_CONTO)
	   M.CON_CONTO  = STRTRAN(M.CON_CONTO," ","")
	   MASTRO_CORRENTE  = M.CON_CONTO

	   IF VAL(M.CON_CONTO) < 30
	      PE_CORRENTE = 'P'
	   ELSE
	      PE_CORRENTE = 'E'
	   ENDIF	   
	   
	   M.CON_DESCR  = SUBSTR(CAMPO_02,01,60)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN


****************************************************************
FUNCTION INTERCETTA_DATI_SOTTOCONTO 
****************************************************************


	   M.CON_CONTO  = MASTRO_CORRENTE  + SUBSTR(CAMPO_02,02,15)
	   M.CON_CONTO  = ALLTRIM(CON_CONTO)
	   M.CON_CONTO  = STRTRAN(M.CON_CONTO," ","")
	   
	   M.CON_DESCR  = SUBSTR(CAMPO_03,01,60)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN



****************************************************************
FUNCTION INTERCETTA_DATI_CONTO_ELEMENTARE 
****************************************************************

	   M.CON_CONTO  = SUBSTR(CAMPO_05,01,15)
	   M.CON_CONTO  = ALLTRIM(CON_CONTO)
	   M.CON_CONTO  = STRTRAN(M.CON_CONTO," ","")
	   
	   M.CON_DESCR  = SUBSTR(CAMPO_06,01,60)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   
   
       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN

****************************************************************
FUNCTION COMPILA_ALTRI_DATI_PIANO_DEI_CONTI
****************************************************************

   m.id_unique = "" 				
   M.CON_SOC   = '01'
   M.CON_ANNO  = _ANNO_CONTABILE
   M.CON_POSBIL = PE_CORRENTE
   M.CON_TIPOCO = 'X'
  
   

   
   IF SUBSTR(ALLTRIM(M.CON_CONTO),1,4) = "1204" OR SUBSTR(ALLTRIM(M.CON_CONTO),1,4) = "4401"
      M.CON_TIPOCO = 'I'
   ENDIF

   IF ALLTRIM(M.CON_CONTO) = "1204" OR ALLTRIM(M.CON_CONTO) = "4401"
      M.CON_TIPOCO = 'X'
   ENDIF 


*!*	#####################################################

   SELECT curs_CONTI					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

							   
   _CTR = _CTR +1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   




RETURN
