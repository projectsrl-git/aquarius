
*************************************************************
**** PROCEDURA DI CREAZIONE LIQUIDAZIONE PERIODICA IVA ******
*************************************************************
*
* GESTIONE CONTI ERARIO IVA : 
*
* 					ERARIO IVA VENDITE
*					ERARIO IVA VENDITE IN SOSPENSIONE IVA INCASSATE (SERGIO 2015/07/14)
*					ERARIO IVA ACQUISTI


SET PROCEDURE TO PRG\LIQUIDA ADDITIVE


** SERGIO 2015/07/14 GESTIONE IVA IN SOSPENSIONE INCASSATA
RELEASE WWS_TOTIVA_SOSPESO 
PUBLIC WWS_TOTIVA_SOSPESO 
WWS_TOTIVA_SOSPESO = 0

RELEASE WWS_TOTIVA 
PUBLIC WWS_TOTIVA 
WWS_TOTIVA = 0
** SERGIO 2015/07/14 GESTIONE IVA IN SOSPENSIONE INCASSATA

               
PUBLIC V_TOTFAT,V_NUMPRO,V_DTULSC,WWC_TOTIVA,WWF_TOTIVA
V_TOTFAT   = 0
V_NUMPRO   = SPACE(13)
V_DTULSC   = SPACE(10)
WWC_TOTIVA = 0
WWF_TOTIVA = 0

** SERGIO 2015/07/14 GESTIONE IVA IN SOSPENSIONE INCASSATA
*!*	CREATE CURSOR LIQUIDA;
*!*	(W_CIVA C(3), ;
*!*	 W_DESIVA C(35), ;
*!*	 WC_TOTIMP N(17,3), ;
*!*	 WC_TOTIVA N(17,3), ;
*!*	 WE_TOTIMP N(17,3), ;
*!*	 WE_TOTIVA N(17,3), ;
*!*	 WF_NOTIMP N(17,3), ;
*!*	 WF_NOTIVA N(17,3), ;
*!*	 WF_TOTIMP N(17,3), ;
*!*	 WF_IMP100 N(17,3), ;
*!*	 WF_TOTIVA N(17,3))

CREATE CURSOR LIQUIDA;
(W_CIVA    C(3), ;
 W_DESIVA  C(70), ;
 WC_TOTIMP N(17,3), ;
 WC_TOTIVA N(17,3), ;
 WE_TOTIMP N(17,3), ;
 WE_TOTIVA N(17,3), ;
 WR_TOTIMP N(17,3), ;
 WR_TOTIVA N(17,3), ;
 WF_NOTIMP N(17,3), ;
 WF_NOTIVA N(17,3), ;
 WF_TOTIMP N(17,3), ;
 WF_IMP100 N(17,3), ;
 WS_TOTIMP_SOSPESO N(17,3), ;		&& IMPONIBILE IN SOSPENSIONE SOSPESO
 WS_TOTIVA_SOSPESO N(17,3), ;		&& IMPOSTA IN SOSPENSIONE SOSPESO
 WS_TOTIMP N(17,3), ;				&& IMPONIBILE IN SOSPENSIONE INCASSATO
 WS_TOTIVA N(17,3), ;				&& IMPOSTA IN SOSPENSIONE INCASSATO
 WF_TOTIVA N(17,3))

** SERGIO 2015/07/14 GESTIONE IVA IN SOSPENSIONE INCASSATA


RELEASE _TOP_CHIUSURA_IVA_MESE 
PUBLIC _TOP_CHIUSURA_IVA_MESE 
_TOP_CHIUSURA_IVA_MESE  = ""

x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"u_azi_an")
   return(.f.)
ENDIF
SELECT u_azi_an
GO TOP
IF !EOF()
   _TOP_CHIUSURA_IVA_MESE = AZI_TRAIVA
ELSE
   WAIT WINDOW "Per cortesia codifica nei parametri aziendali IL TOP PER IL TRASFERIMENTO/CHIUSURA IVA MENSILE"
   RETURN
ENDIF

IF EMPTY(_TOP_CHIUSURA_IVA_MESE)
   WAIT WINDOW "Per cortesia codifica nei parametri aziendali IL TOP PER IL TRASFERIMENTO/CHIUSURA IVA MENSILE"
   RETURN
ENDIF

CREATE CURSOR LIQUIRIE;
 (W_CIVA   C(3), ;
 W_DESIVA  C(35), ;
 W_TOTIMP  N(17,3), ;
 W_TOTIVA  N(17,3))

SELECT LIQUIDA 
ZAP
SELECT LIQUIDA 
******** > INDICE PER STAMPA
INDEX ON W_CIVA TAG  LIQUIDA

SELECT LIQUIRIE
ZAP
SELECT LIQUIRIE
******** > INDICE PER STAMPA
INDEX ON W_CIVA TAG  LIQUIRIE

SELECT LIQUIDA


IF !EMPTY(__dtdal)
   R_DTDAL =RIBALTA2(__dtdal)
ENDIF
  
IF EMPTY(__dtal)
   =MSGBOX("Senza data non puoi avere nessuna liquidazione","******* DIMENTICANZA GRAVE *******",21)
   RETURN  
ELSE
   R_DTAL  =RIBALTA2(__dtal)
ENDIF  




WAIT window 'Elaborazione dati in corso .....Attendere...' nowait

***************************************************************************
***** ESTRAGGO DA U_IVA_TO IL TOTALE CLIENTI \ FORNITORI DEL PERIODO SCELTO
***************************************************************************

DO CREALIQ


SELECT LIQUIDA 
GO TOP


x_top  = "MOV_TOP = '" + _TOP_CHIUSURA_IVA_MESE + "'"
x_anno = "MOV_ANNO = '" + PUB_ANNO + "'"
x_desmov = "MOV_DESMOV like 'LIQ. IVA PERIODO: " + __dtdal + " al " + __dtal + "%'"
x_cond = x_top + " and " + x_anno + " and " + x_desmov 
__CSQL   = "SELECT * FROM MOV_CONT where " + x_cond 
IF !ExecCommand(__CSQL,"CTRL_IVA")
   RETURN (.f.)
ENDIF 
SELECT CTRL_IVA
GO TOP

IF !EOF()

	    DO PLAYWAV WITH "BLIP.WAV" 

 		    XDESCRI1="ATTENZIONE"
 		    XDESCRI2="ESISTONO GIA' MOVIMENTI IN CONTABILITA' PER IL PERIODO INDICATO"
	    SET CLASSLIB TO "proj_lib.vcx" additive
	    oForm=CreateObject("MsgErr") 
	    oform.edit1.Value=""+CHR(13)+XDESCRI1+;
				  ""+CHR(13)+;		  
				  XDESCRI2  +;
  				  ""+CHR(13)+;
  				  ALLTRIM("")	
	    oform.Show
 		RELEASE oForm 

ELSE

	DO crea_regi  && crea le registrazioni 
				  && la procedura è qui in fondo		

ENDIF


RETURN




**************************************************************************************************************
*																			 								 *
* 			 		TRASFERIMENTO IN CONTABILITA GENERALE DELLA LIQUIDAZIONE IVA PERIODICA					 *
*																											 *
**************************************************************************************************************
PROCEDURE crea_regi
   
CT = 0
_CONTA_ANOMALIE  = 0
=DEF_AQUAREP()


DATADAL= __dtdal 
DATAAL = __dtal
TTF_TOTIVA = 0
TTC_TOTIVA = 0
DATADAL = RIBALTA2(DATADAL)
DATAAL = RIBALTA2(DATAAL)


TC_TOTIVA =0
TF_TOTIVA =0
TS_TOTIVA =0
TE_TOTIVA =0
TR_TOTIVA =0

** 2015/07/14 FABIANO CALCOLO TOTALI DA LIQUIDAZIONE
SELECT LIQUIDA 
GO TOP

SCAN
	TC_TOTIVA = TC_TOTIVA + IIF(OK_ARR, OK_ARROTB(WC_TOTIVA-WR_TOTIVA,PUB_VALRIF) ,WC_TOTIVA-WR_TOTIVA) 
	TF_TOTIVA = TF_TOTIVA + IIF(OK_ARR, OK_ARROTB(WF_TOTIVA-WR_TOTIVA-WE_TOTIVA,PUB_VALRIF) ,WF_TOTIVA-WR_TOTIVA-WE_TOTIVA) 
	TS_TOTIVA = TS_TOTIVA + IIF(OK_ARR, OK_ARROTB(WS_TOTIVA,PUB_VALRIF) ,WS_TOTIVA)
	TE_TOTIVA = TE_TOTIVA + IIF(OK_ARR, OK_ARROTB(WE_TOTIVA,PUB_VALRIF) ,WE_TOTIVA)
	TR_TOTIVA = TR_TOTIVA + IIF(OK_ARR, OK_ARROTB(WR_TOTIVA,PUB_VALRIF) ,WR_TOTIVA)
	
	SELECT LIQUIDA 
ENDSCAN


*!*	** 2015/07/14 SERGIO GESTIONE IVA IN SOSPENSIONE
*!*	*SELECT IIF(OK_ARR, OK_ARROTB(SUM(WC_TOTIVA),PUB_VALRIF) ,SUM(WC_TOTIVA)) AS TC_TOTIVA,IIF(OK_ARR, OK_ARROTB(SUM(WF_TOTIVA),PUB_VALRIF) ,SUM(WF_TOTIVA)) AS TF_TOTIVA FROM LIQUIDA INTO CURSOR TRASFE READWRITE
*!*	SELECT IIF(OK_ARR, OK_ARROTB(SUM(WC_TOTIVA),PUB_VALRIF) ,SUM(WC_TOTIVA)) AS TC_TOTIVA,IIF(OK_ARR, OK_ARROTB(SUM(WS_TOTIVA),PUB_VALRIF) ,SUM(WS_TOTIVA)) AS TS_TOTIVA,IIF(OK_ARR, OK_ARROTB(SUM(WF_TOTIVA),PUB_VALRIF) ,SUM(WF_TOTIVA)) AS TF_TOTIVA FROM LIQUIDA INTO CURSOR TRASFE READWRITE
*!*	** 2015/07/14 SERGIO GESTIONE IVA IN SOSPENSIONE


*!*	SELECT TRASFE
*!*	GO TOP
*!*	SCATTER MEMVAR MEMO


v_SEEK = "TFC"+"\ER"			&& CERCO IL CONTO ERARIO C/IVA NEI PARAMETRI
IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
  SELECT CPA_PARA
  ERARIO = ALLTRIM(LIBERA)
ELSE
   =MESSAGEB("Manca il conto erario nei parametri. CODICE = \ER",64,"*** ATTENZIONE ***")
   RETURN .F.
ENDIF

v_SEEK = "TFC"+"\VE"			&& CERCO IL CONTO IVA C/TO VENDITE NEI PARAMETRI
IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
  SELECT CPA_PARA
  VENDITE = ALLTRIM(LIBERA)
ELSE
   =MESSAGEB("Manca il conto iva c/to vendite nei parametri. CODICE = \VE",64,"*** ATTENZIONE ***")
   RETURN .F.
ENDIF

** 2015/07/14 SERGIO GESTIONE IVA IN SOSPENSIONE
v_SEEK = "TFC"+"\SO"			&& CERCO IL CONTO IVA C/TO VENDITE IN SOSPENSIONE IVA INCASSATE NEI PARAMETRI
IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
  SELECT CPA_PARA
  VENDITE_SOSPENSIONE_INCASSATE = ALLTRIM(LIBERA)
ELSE
   =MESSAGEB("Manca il conto iva c/to vendite in sospensione iva incassate nei parametri. CODICE = \SO",64,"*** ATTENZIONE ***")
   RETURN .F.
ENDIF
** 2015/07/14 SERGIO GESTIONE IVA IN SOSPENSIONE

v_SEEK = "TFC"+"\AQ"			&& CERCO IL CONTO IVA C/TO ACQUISTI NEI PARAMETRI
IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
  SELECT CPA_PARA
  ACQUISTI = ALLTRIM(LIBERA)
ELSE
   =MESSAGEB("Manca il conto iva c/to acquisti nei parametri. CODICE = \AQ",64,"*** ATTENZIONE ***")
   RETURN .F.
ENDIF


*!*	** 2015/07/14 FABIANO GESTIONE IVA CEE

v_SEEK = "TFC"+"\CE"			&& CERCO IL CONTO IVA CEE NEI PARAMETRI
IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
  SELECT CPA_PARA
  ACQUISTI_CEE = ALLTRIM(LIBERA)
ELSE
   =MESSAGEB("Manca il conto iva c/to acquisti CEE nei parametri. CODICE = \CE",64,"*** ATTENZIONE ***")
   RETURN .F.
ENDIF

*!*	** 2015/07/14 FABIANO GESTIONE IVA ACQUISTI REVERSE CHARGE 

v_SEEK = "TFC"+"\RC"			&& CERCO IL CONTO IVA REVERSE CHARGE NEI PARAMETRI
IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
  SELECT CPA_PARA
  ACQUISTI_REVERSE_CHARGE = ALLTRIM(LIBERA)
ELSE
   =MESSAGEB("Manca il conto iva c/to acquisti REVERSE CHARGE nei parametri. CODICE = \RC",64,"*** ATTENZIONE ***")
   RETURN .F.
ENDIF

*!*	** 2015/07/14 FABIANO GESTIONE IVA VENDITE (COMPENSAZIONE) REVERSE CHARGE 

v_SEEK = "TFC"+"\RV"			&& CERCO IL CONTO IVA VENDITE (COMPENSAZIONE) CHARGE NEI PARAMETRI
IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
  SELECT CPA_PARA
  COMPENSAZIONE_REVERSE_CHARGE = ALLTRIM(LIBERA)
ELSE
   =MESSAGEB("Manca il conto iva c/to VENDITE (COMPENSAZIONE) REVERSE CHARGE nei parametri. CODICE = \RV",64,"*** ATTENZIONE ***")
   RETURN .F.
ENDIF



RIT = MESSAGEBOX("Procedo con la creazione delle registrazioni automatiche della liquidazione IVA?"+CHR(13)+"Periodo dal "+__dtdal+" al "+__dtal,292,"ATTENZIONE")
IF RIT = 7
   RETURN
ENDIF

*!*	SOMMA     =  TRASFE.TC_TOTIVA
SOMMA     =  TC_TOTIVA
X_CONTO   =  VENDITE
X_CONTROP =  ERARIO

IF SOMMA <> 0
 DO valorizza_dare		&& IVA C/TO VENDITE ********************************  1° movimento
 DO valorizza_avere		&& ERARIO C/TO IVA  ********************************  2° movimento
ENDIF 	


*!*	SOMMA     =  TRASFE.TF_TOTIVA
SOMMA     =  TF_TOTIVA
X_CONTO   =  ERARIO
X_CONTROP =  ACQUISTI

IF SOMMA <> 0
 DO valorizza_dare		&& IVA C/TO ACQUISTI *******************************  1° movimento
 DO valorizza_avere		&& ERARIO C/TO IVA   *******************************  2° movimento
ENDIF 	




** 2015/07/14 SERGIO GESTIONE IVA IN SOSPENSIONE
*!*	SOMMA     =  TRASFE.TS_TOTIVA
SOMMA     =  TS_TOTIVA
X_CONTO   =  VENDITE_SOSPENSIONE_INCASSATE 
X_CONTROP =  ERARIO

IF SOMMA <> 0
 DO valorizza_dare		&& IVA C/TO VENDITE SOSPENSIONE INCASSATE ********************************  1° movimento
 DO valorizza_avere		&& ERARIO C/TO IVA  ******************************************************  2° movimento
ENDIF 	
** 2015/07/14 SERGIO GESTIONE IVA IN SOSPENSIONE


** 2015/07/14 FABIANO IVA CEE
SOMMA     =  TE_TOTIVA
X_CONTO   =  ERARIO
X_CONTROP =  ACQUISTI_CEE

IF SOMMA <> 0
 DO valorizza_dare		&& IVA C/TO ACQUISTI CEE *******************************  1° movimento
 DO valorizza_avere		&& ERARIO C/TO IVA   *******************************  2° movimento
ENDIF 	

** 2015/07/14 FABIANO IVA REVERSE CHARGE
SOMMA     =  TR_TOTIVA
X_CONTO   =  ERARIO
X_CONTROP =  ACQUISTI_REVERSE_CHARGE 

IF SOMMA <> 0
 DO valorizza_dare		&& IVA C/TO ACQUISTI REVERSE CHARGE *******************************  1° movimento
 DO valorizza_avere		&& ERARIO C/TO IVA   *******************************  2° movimento
ENDIF 	

** 2015/07/14 FABIANO IVA VENDITE (COMPENSAZIONE) REVERSE CHARGE 
SOMMA     =  TR_TOTIVA+TE_TOTIVA
X_CONTO   =  COMPENSAZIONE_REVERSE_CHARGE 
X_CONTROP =  ERARIO

IF SOMMA <> 0
 DO valorizza_dare		&& IVA C/TO VENDITE (COMPENSAZIONE) REVERSE CHARGE  ********************************  1° movimento
 DO valorizza_avere		&& ERARIO C/TO IVA  ******************************************************  2° movimento
ENDIF 	



RELEASE WINDOW DISPLAY


WAIT WINDOWS 'Elaborazione completata ...' NOWAIT

=MESSAGEBOX("Trasferimento liquidazione iva periodica terminato correttamente",62,"ATTENZIONE")

RELEASE WINDOW DISPLAY

RETURN


***************************************************************************
PROCEDURE valorizza_dare      && CONTO CATEGORIA
***************************************************************************


    PUB_BLOCCA_SBLOCCA_PREVISIONALE=""  

    CGE_CON				= ALLTRIM(X_CONTO)             

    *!*	PRELEVA LA DESCRIZIONE DEL CONTO CONTABILE
    
	x_soci = "con_soc = '" + PUB_CODSOC + "'"
	x_anno = "con_anno = '" + PUB_ANNO + "'"
	x_cont = "con_conto = '" + ALLTRIM(CGE_CON) + "'"
	x_cond = x_soci + " and " + x_anno + " and " + x_cont
	Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	IF !ExecCommand(cSql,"conti")
       WAIT WINDOW "Errore durante la lettura della tabella conti, codice = " + CGE_CON
	ENDIF
	SELECT conti
	GO TOP
	IF EOF()
       WAIT WINDOW "Errore manca il conto contabile = " + CGE_CON
	ENDIF
  
    
	CGE_DESCO  			= CON_DESCR



	x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
	x_cond = x_soci
	Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
	IF !ExecCommand(cSql,"u_azi_an")
	   return(.f.)
	ENDIF
	SELECT u_azi_an
	GO TOP
	IF !EOF()
	   CGE_TOPX = AZI_TRAIVA
	ELSE
	   WAIT WINDOW "Per cortesia codifica i parametri aziendali"
	   RETURN
	ENDIF
	
	
    
	_NPARF 				= ""   			   	&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
	_NUMPRO 			= "CARICA"      	&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_INDICE 			= "CARICA"      	&& CREA INDICE
	_NREG				= "CARICA"			&& RICERCA IL NUMERO DI REISTRAZIONE UTENE
    _NDOC				= "CARICANREG"		&& IMPOSTA IL NUMERO DI REGISTRAZIONE

	
	CGE_COMM 			= "LIQ. IVA PERIODO: " +  __dtdal+" al " + __dtal
	CGE_COM1 			= ""
	CGE_IV   			= "NO"
	CGE_IMP  			= 0.00
	CGE_DA    			= SOMMA
	CGE_AV    			= 0
	
	CGE_CECOS  			= SPACE(13)  
	CGE_WCCAGE 			= SPACE(3)
	CGE_KABBUO 			= 0
	CGE_XNOTE  			= SPACE(13)
	CGE_XCCLI  			= SPACE(10)
	CGE_XCFOR  			= SPACE(10)
	**CGE_DATAREG			= DTOC(DATE())
	CGE_DATAREG			= XDATA
	CGE_NPARF			= 0
			
	**CGE_DATADOC			= data_elab
	CGE_DATADOC			= XDATA
	CGE_NDOC			= CGE_NREG				
	CGE_FR				= .F.
	CGE_PESO			= 0
	CGE_TISPE			= SPACE(03)
	CGE_PORTO			= SPACE(03)
	CGE_CLDOG			= SPACE(16)
	CGE_BANCA			= "001"
*	CGE_DATASCAD		= data_elab
	CGE_DATASCAD		= ""
	CGE_CPA				= PUB_CPA
	CGE_BOLLATOIVA		= SPACE(01)

	CGE_COSATRATTA		= ""
	CGE_GRADOIMPORTANZA	= ""
	CGE_FORMAPAGAMENTO	= ""
	CGE_TIPOCONTRATTO	= ""
	CGE_CODACQ			= ""
	CGE_PRIPAGA			= ""



	*CGE_XCAMBIO			= PUB_CAMBIO
	CGE_XCAMBIO			= 1  && ERASMO/FABIANO - 27/04/2015 - il cambio nella valuta di riferimento e' sempore 1
	CGE_XVALUTA			= PUB_VALRIF
	CGE_XDATAVAL		= DTOC(DATE())
	CGE_XANOMAX			= SPACE(3) 
	CGE_CECO			= SPACE(10)
	CGE_SEQUEN			= 10				&& AD OGNI RIGA INSERITA SOMMARE 10 

	PUB_TIPOGE			= "EFFETTIVA"	&& CONSIDERA LA REGISTRAZIONE COME EFFETTIVE


	** ------- GESTIONE EFFETTI --------**
	M.EFF_NUMATRI = 0
	M.EFF_EFFETDA = ""
	M.EFF_INTEPER = "" 
	M.EFF_NOTEFF  = "" 
	** ------- GESTIONE EFFETTI --------**   


	=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)	



RETURN



***************************************************************************
PROCEDURE valorizza_avere      && CONTO F.DO AMM.TO
***************************************************************************

    PUB_BLOCCA_SBLOCCA_PREVISIONALE=""  

   
    CGE_CON				= X_CONTROP

	x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
	x_cond = x_soci
	Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
	IF !ExecCommand(cSql,"u_azi_an")
	   return(.f.)
	ENDIF
	SELECT u_azi_an
	GO TOP
	IF !EOF()
	   CGE_TOPX = AZI_TRAIVA
	ELSE
	   WAIT WINDOW "Per cortesia codifica i parametri aziendali"
	   RETURN
	ENDIF
	


	_NPARF 				= ""      			&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
	_NUMPRO 			= ""      			&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_INDICE 			= ""      			&& CREA INDICE
	_NREG				= ""				&& MANTIENE IL NUMERO DI REGISTRAZIONE PRELEVATO IL PRECEDENZA
    _NDOC				= "CARICANREG"		&& MANTIENE IL NUMERO DI REGISTRAZIONE PRECEDENTE

	
	CGE_COMM 			= "LIQ. IVA PERIODO: " +  __dtdal+" al " + __dtal
	CGE_COM1 			= ""
	CGE_DA   			= 0
	CGE_AV   			= SOMMA
	CGE_IV   			= "NO"
	CGE_IMP  			= 0.00

	
	CGE_CECOS  			= SPACE(13)  
	CGE_WCCAGE 			= SPACE(3)
	CGE_KABBUO 			= 0
	CGE_XNOTE  			= SPACE(13)
	CGE_XCCLI  			= SPACE(10)
	CGE_XCFOR  			= SPACE(10)
	**CGE_DATAREG			= DTOC(DATE())
	CGE_DATAREG			= XDATA
	CGE_NPARF			= 0


	*CGE_DATADOC			= data_elab
*	CGE_DATADOC			= ribalta2(XDATA)
	CGE_DATADOC			= XDATA
	CGE_NDOC			= CGE_NREG
	CGE_FR				= .F.
	CGE_PESO			= 0
	CGE_TISPE			= SPACE(03)
	CGE_PORTO			= SPACE(03)
	CGE_CLDOG			= SPACE(16)
	CGE_BANCA			= "001"
*	CGE_DATASCAD		= data_elab
	CGE_DATASCAD		= ""
	CGE_CPA				= PUB_CPA
	CGE_BOLLATOIVA		= SPACE(01)

	CGE_COSATRATTA		= ""
	CGE_GRADOIMPORTANZA	= ""
	CGE_FORMAPAGAMENTO	= ""
	CGE_TIPOCONTRATTO	= ""
	CGE_CODACQ			= ""
	CGE_PRIPAGA			= ""



	*CGE_XCAMBIO			= PUB_CAMBIO
	CGE_XCAMBIO			= 1  && ERASMO/FABIANO - 27/04/2015 - il cambio nella valuta di riferimento e' sempore 1
	CGE_XVALUTA			= PUB_VALRIF
	CGE_XDATAVAL		= XDATA
	CGE_XANOMAX			= SPACE(3) 
	CGE_CECO			= SPACE(10)
	CGE_SEQUEN			= 20				&& AD OGNI RIGA INSERITA SOMMARE 10 

	PUB_TIPOGE			= "EFFETTIVA"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE PREVISIONALE


	** ------- GESTIONE EFFETTI --------**
	M.EFF_NUMATRI = 0
	M.EFF_EFFETDA = ""
	M.EFF_INTEPER = "" 
	M.EFF_NOTEFF  = "" 
	** ------- GESTIONE EFFETTI --------**   


	=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)	

RETURN



