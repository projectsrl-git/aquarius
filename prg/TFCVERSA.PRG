**************************************************************************************************************
*																			 								 *
*																			 								 *
* 			 		TRASFERIMENTO IN CONTABILITA GENERALE DELLE OPERAZIONI DI CASSA   						 *
*																			 								 *
*																											 *
**************************************************************************************************************
*
* SOSPESI 
* IMPOSTARE NEI COMMENTI IL NUMERO DEGLI SCONTRINI
*
*  VERIFICA 	CGE_BANCA			= "001"
*				CGE_DATASCAD		= data_elab
*				CGE_CPA				= PUB_CPA

*
** definizione delle variabili

CT = 0
_CONTA_ANOMALIE  = 0
=DEF_AQUAREP()

*!*	accesso alla tabella delle elaborazioni : TESTATA


DT_SOLA = ribalta2(DTOC(DATE()))
x_data = "data_solar = '" + dt_sola +"'"
x_cond = x_data 


Csql1 = "select * from u_ela_an where " + x_cond + " order by data_solar"

IF !ExecCommand(cSql1,"u_ela_an")
*!*	IF !ExecRW(Csql1,"u_ela_an","R")
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
*!*	IF !ExecRW(Csql1,"u_ela_er","R")
    return(.f.)
ENDIF

SELECT U_ELA_ER
GO TOP
DELETE FOR ALLTRIM(PROCEDURA) = "TFCVERSA"				&& SVUOTA LA TABELLA CANCELLANDO LE VECCHIE ANOMALIE


*!*	ESTRAE tutti i RECORD 100 relativi alla chiusura di cassa CONTANTI definitiva di U_PDV_CD

x_data = "pdv_datchi <= '" + data_elab + "'"
x_tipo = "pdv_tiprec = '100'"
x_cpa  = "pdv_cdpa01 = 'CO'"			&& CONTANTI 
x_cge  = "pdv_cge = ' '"
x_cond = x_data + " and " + x_tipo + " and " + x_cpa + " and " + x_cge
Csql1 = "select * from u_pdv_cd where " + x_cond + " order by pdv_codpdv"


IF !ExecCommand(cSql1,"U_PDV_CD")
*!*	IF !ExecRW(Csql1,"U_PDV_CD","R")
	DO aggiorna_u_ela_an WITH "KO","ERRORE DURANTE LA LETTURA DELLA TABELLA U_PDV_CD"	
    return(.f.)
ENDIF

*!*	ELABORA tutti i RECORD 100 relativi alla chiusura di cassa CONTANTI definitiva di U_PDV_CD e crea la prima nota

SELECT U_PDV_CD
GO TOP


DO WHILE .NOT.EOF()

	
	SELECT U_PDV_CD
	SCATTER MEMVAR MEMO

    _ANOMALIE = .F.
	CT	= CT + 1

    WAIT WINDOWS "PUNTO DI VENDITA IN ELABORAZIONE : "+ALLTRIM(m.pdv_codpdv) NOWAIT

    DO aggiorna_u_ela_an WITH "INFO","PUNTO DI VENDITA IN ELABORAZIONE : "+ALLTRIM(m.pdv_codpdv)

    DO valorizza_dare		&& CONTO BANCA CONTO VERSAMENTO *********************************  1° movimento
    DO valorizza_avere		&& CONTO CASSA **************************************************  2° movimento

    IF  !_ANOMALIE 
		SELECT U_PDV_CD
		REPLACE PDV_CGE    WITH  "S"		&& AGGIORNA IL FLAG DI TRASFERITO IN CONTABILITA' GENERALE
	ENDIF

	SELECT U_PDV_CD
	SKIP +1

ENDDO WHILE .NOT.EOF()


DO aggiorna_u_pdv_cd					&& AGGIORNA IL FLAG DI TRASFERITO IN CONTABILITA' GENERALE
DO aggiorna_u_ela_an WITH "OK",'Elaborati n. '+str(CT,5,0)+' Movimenti di chiusura cassa'	




RETURN



***************************************************************************
PROCEDURE valorizza_dare      && BANCA CONTO VERSAMENTO
***************************************************************************
	

    PUB_BLOCCA_SBLOCCA_PREVISIONALE=""  
  
    CGE_CON				= ALLTRIM(M.PDV_DSIVA4)

    *!*	PRELEVA LA DESCRIZIONE DEL CONTO CONTABILE
    
	x_soci = "con_soc = '" + PUB_CODSOC + "'"
	x_anno = "con_anno = '" + PUB_ANNO + "'"
	x_cont = "con_conto = '" + ALLTRIM(CGE_CON) + "'"
	x_cond = x_soci + " and " + x_anno + " and " + x_cont
	Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	IF !ExecCommand(cSql,"conti")
	   DO aggiorna_u_ela_an WITH "KO","ERRORE DURANTE LA LETTURA DELLA TABELLA CONTI , CODICE :"+ALLTRIM(CGE_CON)	
	   _ANOMALIE = .T.
	   return(.f.)
	ENDIF
	SELECT conti
	GO TOP
	IF EOF()
	   DO aggiorna_u_ela_an WITH "KO","MANCA IL CONTO CONTABILE , CODICE :"+ALLTRIM(CGE_CON)	
	   _ANOMALIE = .T.
	   return(.f.)
	ENDIF
  
    
	CGE_DESCO  			= CON_DESCR


    SELECT U_PDV_CD 
	
	CGE_TOPX			= "VER"				&& VERSAMENTO
	_NPARF 				= ""   			   	&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
	_NUMPRO 			= "CARICA"      	&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_INDICE 			= "CARICA"      	&& CREA INDICE
	_NREG				= "CARICA"			&& RICERCA IL NUMERO DI REISTRAZIONE UTENE
    _NDOC				= "CARICANREG"		&& IMPOSTA IL NUMERO DI REGISTRAZIONE

	
	CGE_COMM 			= "VERSAMENTO x CHIUSURA CASSA "+ M.PDV_DATCHI
	CGE_COM1 			= "CONTANTI"
	CGE_DA   			= M.PDV_PAGA01
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
	CGE_SEQUEN			= 10				&& AD OGNI RIGA INSERITA SOMMARE 10 

	PUB_TIPOGE			= "PREVISIONALE"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE PREVISIONALE


	=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)	



RETURN



***************************************************************************
PROCEDURE valorizza_avere      && CONTO CASSA
***************************************************************************

    PUB_BLOCCA_SBLOCCA_PREVISIONALE=""  

    *!*	PRELEVA IL CONTO CASSA DA U_PDV_AN
    
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
  
    
    CGE_CON				= PDV_CODCON
	CGE_DESCO  			= PDV_DESCON


    SELECT U_PDV_CD 
	
	CGE_TOPX			= "VER"				&& VERSAMENTO
	_NPARF 				= ""      			&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
	_NUMPRO 			= ""      			&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_INDICE 			= ""      			&& CREA INDICE
	_NREG				= ""				&& MANTIENE IL NUMERO DI REGISTRAZIONE PRELEVATO IL PRECEDENZA
    _NDOC				= "CARICANREG"		&& MANTIENE IL NUMERO DI REGISTRAZIONE PRECEDENTE

	
	CGE_COMM 			= "VERSAMENTO x CHIUSURA CASSA "+ M.PDV_DATCHI
	CGE_COM1 			= "CONTANTI"
	CGE_DA   			= 0
	CGE_AV   			= M.PDV_PAGA01
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
	REPLACE PROCEDURA		WITH "TFCVERSA"
	REPLACE ANOMALIA		WITH "PDV : "+ALLTRIM(m.pdv_codpdv)+ " - "+ALLTRIM(_MESSAGGIO)
    _CONTA_ANOMALIE 		= _CONTA_ANOMALIE  + 1
ENDIF


SELECT U_ELA_AN
GO TOP

REPLACE PROC_01  		WITH "TFCVERSA"
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