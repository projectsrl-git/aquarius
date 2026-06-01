**************************************************************************************************************
*																			 								 *
*																			 								 *
* 			 		TRASFERIMENTO IN CONTABILITA GENERALE DEGLI INCASSI AL FINE DEI CORRISPETTIVI            *
*																			 								 *
*																											 *
**************************************************************************************************************
*
* SOSPESI
* IMPOSTARE NEI COMMENTI ???????
*
*



** definizione delle variabili
RELEASE	_CDIVA   
RELEASE	_IMPONIB 
RELEASE	_IMPOSTA 

PUBLIC	_CDIVA   
PUBLIC	_IMPONIB 
PUBLIC	_IMPOSTA 

_CDIVA   = SPACE(03)
_IMPONIB = 0
_IMPOSTA = 0


RELEASE SAVE_CGE_CON,CICLA
RELEASE SAVE_CGE_DESCO
PUBLIC SAVE_CGE_CON,CICLA
PUBLIC SAVE_CGE_DESCO

SAVE_CGE_CON		= ""		&& CONTO INCASSI PUNTO DI VENDITA
SAVE_CGE_DESCO 		= ""		&& DESCRIZIONE CONTO CASSA
CICLA = 0

CT = 0
_CONTA_ANOMALIE  = 0
=DEF_AQUAREP()

*!*	accesso alla tabella delle elaborazioni : TESTATA


DT_SOLA = ribalta2(DTOC(DATE()))
x_data = "data_solar = '" + dt_sola +"'"
x_cond = x_data 


Csql1 = "select * from u_ela_an where " + x_cond + " order by data_solar"


IF !ExecCommand(cSql1,"u_ela_an")
*IF !ExecRW(Csql1,"u_ela_an","R")
    return(.f.)
ENDIF

SELECT u_ela_an
GO top

IF EOF()
	DO aggiorna_u_ela_an WITH "KO","NON ESISTE CALENDARIO ELABORAZIONI NOTTURNE ANNO : "+PUB_ANNO	
   return(.f.)
ENDIF

SELECT U_ELA_AN
GO TOP
REPLACE	DTINELA_01		WITH DT_SOLA
REPLACE ORAINEL_01		WITH TIME()
REPLACE TOTALEANOM		WITH 0


data_elab = dataela_01

*!*	accesso alla tabella delle elaborazioni : DETTAGLI


Csql1 = "select * from u_ela_er where " + x_cond + " order by data_solar"


IF !ExecCommand(cSql1,"u_ela_er")
*IF !ExecRW(Csql1,"u_ela_er","R")
    return(.f.)
ENDIF

SELECT U_ELA_ER
GO TOP
DELETE FOR ALLTRIM(PROCEDURA) = "TFCCORRI"				&& SVUOTA LA TABELLA CANCELLANDO LE VECCHIE ANOMALIE


*!*	ESTRAE tutti i RECORD 000 relativi alla chiusura di cassa INCASSSI


x_data = "pdv_datchi <= '" + data_elab + "'"
x_tipo = "pdv_tiprec = '000'"
x_cge  = "pdv_cgeinc = ' '"
x_cond = x_data + " and " + x_tipo + " and " + x_cge
Csql1 = "select * from u_pdv_cd where " + x_cond + " order by pdv_codpdv"

* select * from u_pdv_cd where pdv_datchi <= '2004/05/17' and pdv_tiprec = '000' and pdv_cgeinc = ' ' order by pdv_codpdv


IF !ExecCommand(cSql1,"u_pdv_cd")
*IF !ExecRW(Csql1,"U_PDV_CD","R")
	DO aggiorna_u_ela_an WITH "KO","ERRORE DURANTE LA LETTURA DELLA TABELLA U_PDV_CD"	
    return(.f.)
ENDIF

*!*	ELABORA tutti i RECORD 000 relativi alla chiusura di cassa INCASSI PER CORRISPETTIVI e crea la prima nota


SELECT U_PDV_CD
GO TOP


DO WHILE .NOT.EOF()

	
	SELECT U_PDV_CD
	SCATTER MEMVAR MEMO

    _ANOMALIE = .F.
	CT	= CT + 1

    WAIT WINDOWS "PUNTO DI VENDITA IN ELABORAZIONE : "+ALLTRIM(m.pdv_codpdv) NOWAIT
    	
    DO aggiorna_u_ela_an WITH "INFO","PUNTO DI VENDITA IN ELABORAZIONE : "+ALLTRIM(m.pdv_codpdv)

    DO valorizza_dare						&& CONTO CASSA **************************************************  1° movimento
   
    FOR  CICLA = 1 TO 4

       	_CDIVA     = "PDV_CDIVA"+STR(CICLA,1,0)
       	_IMPONIB   = "PDV_IMPON"+STR(CICLA,1,0)
       	_IMPOSTA   = "PDV_IMPOS"+STR(CICLA,1,0)
       	
    	IF !EMPTY(&_CDIVA)
		    DO valorizza_avere				&& CONTO INCASSI PDV*********************************************  2° movimento
		ENDIF

    NEXT 
     
    IF  !_ANOMALIE 
		SELECT U_PDV_CD
		REPLACE pdv_cgeinc    WITH  "S"		&& AGGIORNA IL FLAG DI TRASFERITO IN CONTABILITA' GENERALE
	ENDIF

	SELECT U_PDV_CD
	SKIP +1

ENDDO WHILE .NOT.EOF()


DO aggiorna_u_pdv_cd					&& AGGIORNA IL FLAG DI TRASFERITO IN CONTABILITA' GENERALE
DO aggiorna_u_ela_an WITH "OK",'Elaborati n. '+str(CT,5,0)+' Movimenti di chiusura cassa'	




RETURN

***************************************************************************
PROCEDURE valorizza_dare      && CONTO CASSA
***************************************************************************

    PUB_BLOCCA_SBLOCCA_PREVISIONALE=""  

    *!*	PRELEVA IL CONTO CASSA/INCASSI DA U_PDV_AN
    
	x_cond = "pdv_codice = '" + ALLTRIM(m.pdv_codpdv) +"'"
	Csql1 = "select * from u_pdv_an where " + x_cond + " order by pdv_codice"


	IF !ExecCommand(Csql1,"u_pdv_an")
	   DO aggiorna_u_ela_an WITH "KO","ERRORE DURANTE LA LETTURA DELLA TABELLA U_PDV_AN , CODICE :"+ALLTRIM(m.pdv_codpdv)	
	   _ANOMALIE = .T.
	   return(.f.)
	ENDIF

	SELECT u_pdv_an
	GO top

	IF EOF()
	   DO aggiorna_u_ela_an WITH "KO","MANCA L'ANAGRAFICA BUSINES UNIT IN TABELLA U_PDV_AN , CODICE :"+ALLTRIM(m.pdv_codpdv)
	   _ANOMALIE = .T.
	   return(.f.)
	ENDIF
  
    
    CGE_CON				= PDV_CODCON		&& CONTO CASSA
	CGE_DESCO  			= PDV_DESCON		&& DESCRIZIONE CONTO CASSA

    SAVE_CGE_CON		= PDV_CODCGE		&& CONTO INCASSI PUNTO DI VENDITA
	SAVE_CGE_DESCO 		= PDV_DESCGE		&& DESCRIZIONE CONTO CASSA
	


    SELECT U_PDV_CD 
	

	CGE_TOPX			= "COR"				&& GIRO CONTO FONDO SPESE
	_NPARF 				= ""   			   	&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
	_NUMPRO 			= "CARICA"      	&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_INDICE 			= "CARICA"      	&& CREA INDICE
	_NREG				= "CARICA"			&& RICERCA IL NUMERO DI REISTRAZIONE UTENE
    _NDOC				= "CARICANREG"		&& IMPOSTA IL NUMERO DI REGISTRAZIONE

	
	CGE_COMM 			= "CORRISPETTIVI CHIUSURA CASSA "+ M.PDV_DATCHI
	CGE_COM1 			= "CORRISPETTIVI"
	CGE_DA   			= M.PDV_TOTAL1+M.PDV_TOTAL2+M.PDV_TOTAL3+M.PDV_TOTAL4
	CGE_AV   			= 0
	CGE_IV   			= "NO"
	CGE_IMP  			= 0.00

	
	CGE_CECOS  			= SPACE(13)  
	CGE_WCCAGE 			= SPACE(3)
	CGE_KABBUO 			= 0
	CGE_XNOTE  			= SPACE(13)
	CGE_XCCLI  			= SPACE(10)
	CGE_XCFOR  			= SPACE(10)
	**CGE_DATAREG			= DTOC(DATE())
	CGE_DATAREG			= ribalta2(M.PDV_DATCHI)
	CGE_NPARF			= 0


	*CGE_DATADOC			= data_elab
	CGE_DATADOC			= ribalta2(M.PDV_DATCHI)
	CGE_NDOC			= CGE_NREG
	CGE_FR				= .F.
	CGE_PESO			= 0
	CGE_TISPE			= SPACE(03)
	CGE_PORTO			= SPACE(03)
	CGE_CLDOG			= SPACE(16)
	CGE_BANCA			= "001"
	CGE_DATASCAD		= data_elab
	CGE_CPA				= PUB_CPA
	CGE_BOLLATOIVA		= SPACE(01)

	CGE_COSATRATTA		= ""
	CGE_GRADOIMPORTANZA	= ""
	CGE_FORMAPAGAMENTO	= ""
	CGE_TIPOCONTRATTO	= ""
	CGE_CODACQ			= ""
	CGE_PRIPAGA			= ""



	CGE_XCAMBIO			= PUB_CAMBIO
	CGE_XVALUTA			= PUB_VALRIF
	CGE_XDATAVAL		= data_elab 
	CGE_XANOMAX			= SPACE(3) 
	CGE_CECO			= SPACE(10)
	CGE_SEQUEN			= 10				&& AD OGNI RIGA INSERITA SOMMARE 10 

	PUB_TIPOGE			= "PREVISIONALE"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE PREVISIONALE

    IF !_ANOMALIE
		=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)	
	ENDIF

RETURN



***************************************************************************
PROCEDURE valorizza_avere      && CONTO INCASSI DEL PUNTO DI VENDITA
***************************************************************************


    PUB_BLOCCA_SBLOCCA_PREVISIONALE=""  
  
    CGE_CON				= ALLTRIM(SAVE_CGE_CON)             
	CGE_DESCO  			= SAVE_CGE_DESCO


    SELECT U_PDV_CD 
	
	CGE_TOPX			= "COR"				&& GIRO CONTO FONDO SPESE
	_NPARF 				= ""      			&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
	_NUMPRO 			= ""      			&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_INDICE 			= ""      			&& CREA INDICE
	_NREG				= ""				&& MANTIENE IL NUMERO DI REGISTRAZIONE PRELEVATO IL PRECEDENZA
    _NDOC				= "CARICANREG"		&& MANTIENE IL NUMERO DI REGISTRAZIONE PRECEDENTE

	
	CGE_COMM 			= "CORRISPETTIVI CHIUSURA CASSA "+ M.PDV_DATCHI
	CGE_COM1 			= "CORRISPETTIVI"
	CGE_DA   			= 0
	CGE_AV   			= &_IMPONIB
	CGE_IV   			= ALLTRIM(&_CDIVA)
	CGE_IMP  			= &_IMPOSTA			&& GENERA IL RECORD IVA

	
	CGE_CECOS  			= SPACE(13)  
	CGE_WCCAGE 			= SPACE(3)
	CGE_KABBUO 			= 0
	CGE_XNOTE  			= SPACE(13)
	CGE_XCCLI  			= SPACE(10)
	CGE_XCFOR  			= SPACE(10)
	**CGE_DATAREG			= DTOC(DATE())
	CGE_DATAREG			= ribalta2(M.PDV_DATCHI)
	CGE_NPARF			= 0
			
	**CGE_DATADOC			= data_elab
	CGE_DATADOC			= ribalta2(M.PDV_DATCHI)
	CGE_NDOC			= CGE_NREG				
	CGE_FR				= .F.
	CGE_PESO			= 0
	CGE_TISPE			= SPACE(03)
	CGE_PORTO			= SPACE(03)
	CGE_CLDOG			= SPACE(16)
	CGE_BANCA			= "001"
	CGE_DATASCAD		= data_elab
	CGE_CPA				= PUB_CPA
	CGE_BOLLATOIVA		= SPACE(01)

	CGE_COSATRATTA		= ""
	CGE_GRADOIMPORTANZA	= ""
	CGE_FORMAPAGAMENTO	= ""
	CGE_TIPOCONTRATTO	= ""
	CGE_CODACQ			= ""
	CGE_PRIPAGA			= ""



	CGE_XCAMBIO			= PUB_CAMBIO
	CGE_XVALUTA			= PUB_VALRIF
	CGE_XDATAVAL		= data_elab 
	CGE_XANOMAX			= SPACE(3) 
	CGE_CECO			= SPACE(10)
	CGE_SEQUEN			= 20				&& AD OGNI RIGA INSERITA SOMMARE 10 

	PUB_TIPOGE			= "PREVISIONALE"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE PREVISIONALE


    IF !_ANOMALIE
		=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)	
	ENDIF


RETURN






****************************************************************************************
PROCEDURE aggiorna_u_pdv_cd      && AGGIORNA FLAG DI TRASFERITO IN CONTABILITA GENERALE
****************************************************************************************

SELECT U_PDV_CD
GO TOP

IF !ExecRW('','U_PDV_CD','I','','U_PDV_CD')
   DO aggiorna_u_ela_an WITH "KO","ERRORE DURANTE L'AGGIORNAMENTO FINALE DELLA TABELLA U_PDV_CD"
   return(.f.)
ENDIF


RETURN


*************************************************************************************************
PROCEDURE aggiorna_u_ela_an      && AGGIORNA ORA FINE ELABORAZIONE SUL LOG ELABORAZIONI NOTTURNE
*************************************************************************************************
PARAMETERS _OK_KO,_MESSAGGIO


IF _OK_KO = "KO"
	SELECT U_ELA_ER
	APPEND BLANK
	REPLACE	DATA_SOLAR		WITH DT_SOLA
	REPLACE DATAERRORE		WITH ribalta2(DTOC(DATE()))
	REPLACE ORAERRORE		WITH TIME()
	REPLACE PROCEDURA		WITH "TFCCORRI"
	REPLACE ANOMALIA		WITH "PDV : "+ALLTRIM(m.pdv_codpdv)+ " - "+ALLTRIM(_MESSAGGIO)
    _CONTA_ANOMALIE 		= _CONTA_ANOMALIE  + 1
ENDIF


SELECT U_ELA_AN
GO TOP

REPLACE PROC_01  		WITH "TFCCORRI"
REPLACE DTFIELA_01		WITH ribalta2(DTOC(DATE()))
REPLACE ORAFIEL_01		WITH TIME()
REPLACE ESITO_01		WITH _MESSAGGIO
REPLACE NUMANOM_01		WITH _CONTA_ANOMALIE



IF _OK_KO = "OK"
	IF _CONTA_ANOMALIE  > 0
	    SELECT U_ELA_AN
		REPLACE TOTALEANOM		WITH TOTALEANOM + _CONTA_ANOMALIE 
		REPLACE ESITO_01		WITH "ANOMALIE RISCONTRATE VERIFICA LOG ERRORI : "+ALLTRIM(_MESSAGGIO)
	ENDIF
	IF !ExecRW('','U_ELA_AN','I','','U_ELA_AN')
	   return(.f.)
	ENDIF
	IF !ExecRW('','U_ELA_ER','I','','U_ELA_ER')
	   return(.f.)
	ENDIF
ENDIF

RETURN