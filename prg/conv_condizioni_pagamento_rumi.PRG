*************************************************************************************************
*						    CONVERSIONE CODICI CONDIZIONI DI PAGAMENTO    						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2013 : Rumi		 			 													*
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

RIT = MESSAGEBOX("Conversione parametro condizioni di pagamento da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF




****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONDIZIONI DI PAGAMENTO SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA CONDIZIONI DI PAGAMENTO" NOWAIT
cSql = "delete from PARA where CODICE LIKE 'CPA%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



CREATE CURSOR IMPORTAXLS ( ;
	pacodice	C(15), ;
	padescri	C(100), ;
	paspeinc	C(100), ;	
	pasconto	C(100), ;
	p2numrat	C(100), ;
	p2giosca	C(15), ;
	p2scaden	C(100), ;
	p2giofis	C(100), ;
	p2flnett	C(100), ;	
	p2fl_iva	C(100), ;
	p2flspes	C(100), ;
	paspeina	C(15), ;
	pavalin2	C(100), ;
	paspein2	C(100), ;
	paspeia2	C(100), ;
	pavalinc	C(100), ;	
	p2flprov	C(100), ;
	p2tipsca	C(100))

SELECT IMPORTAXLS 
INDEX ON ALLTRIM(pacodice) TAG I_INDICE
GO TOP

APPEND FROM (gcFile) TYPE XLS

***** RAGRUPPA PER CODICE DI PAGAMENTO


SELECT pacodice;
   FROM IMPORTAXLS;
   GROUP BY pacodice;
   INTO CURSOR IMPORTAXLS_TT


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS_TT
GO TOP 


DO WHILE !EOF()

 
     IF DELETED()
       SELECT IMPORTAXLS_TT  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(PACODICE)) = "PACODICE"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS_TT  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 
    
    SCATTER MEMVAR MEMO
 
	=ELABORA_RECORD_TESTATA()   
  	
    SELECT IMPORTAXLS_TT
	SKIP

ENDDO

	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

********************************
FUNCTION ELABORA_RECORD_TESTATA
********************************


	M.CODICE0 	=alltrim(m.pacodice)	
	M.CODICE1   =CONV_CLEAR(APITOSPA(ALLTRIM(M.CODICE0))) 
	M.CODICE2   =CONVERTE_CODICE_CPA_ZUCCHETTI(M.CODICE1)
	M.CODICE    ="CPA"+M.CODICE2
  

	cSql = "select * from PARA where CODICE ='CPA"+ALLTRIM(M.CODICE2)+"'"
	IF !ExecCommand(cSql,"___temp_cpa")
	   RETURN .F.
	ENDIF
	SELECT ___temp_cpa
	GO TOP
	IF EOF()
	ELSE
		RETURN
    ENDIF       



	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

	=ELABORA_RECORD_DETTAGLIO()			&& ELABORA I RECORD DI DETTAGLIO DELLA SPECIFICA CPA CONTENENTI INFORMAZIONI RELATIVE AI GIORNI ED ALLE PERCENTUALI DI RIPARTIZIONE IMPORTI


    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT



RETURN

*********************************
FUNCTION ELABORA_RECORD_DETTAGLIO
*********************************

S_CARD_S=STR(SELECT())

SELECT IMPORTAXLS_TT
__SONO_SU_QUESTO_RECORD = RECNO()
__PACODICE = PACODICE

*!*	ELABORA I RECORD DI DETTAGLIO CONTNENTI I GIORNI E LA PERCENTUALE DI RIPARTIZIONE IMPORTO

SELECT IMPORTAXLS 
SET FILTER TO ALLTRIM(PACODICE) = __PACODICE	&& TRATTA SOLO LA CONDIZIONE DI PAGAMENTO IN FASE DI ELABORAZIONE

SET ORDER TO I_INDICE
GO TOP 


M.SCADEN      						= ""
M.PERCENTUALI 						= ""
HO_TROVATO_ALMENO_UNA_PERCENTUALE 	= .F.

DO WHILE .NOT.EOF()

	SCATTER MEMVAR MEMO
	
	M.DESCRI 	=ALLTRIM(APITOSPA(ALLTRIM(M.padescri)))	
	M.DESCRI    =CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 
	M.LIBERA	=""



	** VERIFICA SE E' UNA RICEVUTA BANCARIA
	CAMPO1			= ALLTRIM(M.padescri)
	_RIBA 			= " "
	_POSIZIONE_RIBA = AT("RB",ALLTRIM(APITOSPA(ALLTRIM(CAMPO1))))			&& CERCO RB
	IF _POSIZIONE_RIBA = 0													&& NON TROVATO CERCO RI.BA
		_POSIZIONE_RIBA = AT("RI.BA",ALLTRIM(APITOSPA(ALLTRIM(CAMPO1))))	&& NON TROVATO CERCO RIBA
		IF _POSIZIONE_RIBA = 0												&& NON TROVATO
			_POSIZIONE_RIBA = AT("RIBA",ALLTRIM(APITOSPA(ALLTRIM(CAMPO1))))	
			IF _POSIZIONE_RIBA = 0											&& NON TROVATO
			ELSE
				_RIBA 	= "X"												&& E' UNA RI.BA	
			ENDIF	
		ELSE
			_RIBA 	= "X"													&& E' UNA RI.BA	
		ENDIF
	ELSE
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF
	  
	  
	TIPOLOGIA_PAGAMEN = ALLTRIM(M.p2scaden)									&& DA DATA FATTURA/DA FINE MESE
	_FINE_MESE = "DF"
	IF TIPOLOGIA_PAGAMEN = "DF"
		_FINE_MESE = "DF"
	ENDIF
	IF TIPOLOGIA_PAGAMEN = "FF"
		_FINE_MESE = "FM"			
	ENDIF


	INTERVALLO_GIORNI = ALLTRIM(M.P2GIOSCA)

	M.SCADEN        = M.SCADEN + INTERVALLO_GIORNI + " "						&& SI COMPONE I GIORNI DI INTERVALLO



    SELECT IMPORTAXLS
	SKIP
	
ENDDO


*!*	DF BON    90 120                                                                                                                                                                                        
*!*	FM       X30 60 90                                                                                                                                                                                      
IF _RIBA  = "X"                                                                                                                                                                                      
	M.LIBERA = _FINE_MESE + SPACE(07) + _RIBA + M.SCADEN 
ELSE
	M.LIBERA = _FINE_MESE + SPACE(01) + "BON" + SPACE(03) + _RIBA + M.SCADEN 
ENDIF

SELECT curs_PARA							&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
REPLACE DESCRI   	WITH M.DESCRI
REPLACE LIBERA		WITH M.LIBERA
REPLACE PERCENTUALI	WITH M.PERCENTUALI


SELECT IMPORTAXLS_TT
GO __SONO_SU_QUESTO_RECORD 	&& MI RIPOSIZIONO SUL RECORD DI TESTATA DELLA CONDIZIONE DI PAGAMENTO



SELECT &S_CARD_S

RETURN
