********************************************************************************************************
*  				     CARICAMENTO BOLLATI IVA CLIENTI / FORNITORI / CORRISPETTIVI   				       *
********************************************************************************************************
*
*!*	VERSIONE CON :
*   1) GESTIONE DEL BOLLATO IVA CLIENTI VENDITE IN SOSPENSIONE IVA
*   2) SCORPORA IL BOLLATO DELLE FATTURE ELETTRONICHE PA DALLE ALTRE FATTURE IN SOSPENSIONE IVA  
*      IN FUNZIONE DEL NUMERO DI FATTURA IN SOSPENSIONE
*   3) RAGGRUPPAMENTO FATTURE FORNITORI PER CHIAVE/CODICE IVA
*
*


RELEASE FATTURE_ELETTRONICHE_PA
PUBLIC FATTURE_ELETTRONICHE_PA
FATTURE_ELETTRONICHE_PA = ""

RELEASE __DEDUCIBILE
PUBLIC __DEDUCIBILE
__DEDUCIBILE = .F.


RELEASE DES_IVA
PUBLIC DES_IVA
DES_IVA = ''

RELEASE ___CTF_FVS_CLI_INC
PUBLIC ___CTF_FVS_CLI_INC
___CTF_FVS_CLI_INC= 0

RELEASE ___CTF_CLI_FVS  	&& FATTURE CLIENTI IN SOSPENSIONE IVA
PUBLIC ___CTF_CLI_FVS
___CTF_CLI_FVS = 0

RELEASE ___CTF_FVS_NC_CLI 	&& NOTE ACCREDITO CLIENTI IN SOSPENSIONE IVA
PUBLIC ___CTF_FVS_NC_CLI 
___CTF_FVS_NC_CLI = 0

RELEASE ___CTF_FVS_CLI 		&& NOTE ACCREDITO CLIENTI IN SOSPENSIONE IVA
PUBLIC ___CTF_FVS_CLI 
___CTF_FVS_CLI = 0



RELEASE XXX_FATNOT,WBOLLATOIVA
PUBLIC  XXX_FATNOT,WBOLLATOIVA     
XXX_FATNOT  = ''
WBOLLATOIVA = SPACE(01) 


** GESTIONE ERRORI DI NON CODIFICA CORRETTA PER FORNITORI CEE SENZA CODICE CLIENTE CEE IN ANAGRAFICA FORNITORI
CREATE CURSOR STAMPAERR (MOV_CONTO_ C(13),MOV_RAGSOC_ C(40),MOV_DTREG_ C(10), MOV_NREGIS_ C(10), MOV_NPROT_ C(10), MOV_NDOC_ C(10), MOV_DTDOC_ C(10))
INDEX ON ALLTRIM(MOV_RAGSOC_)+ MOV_DTDOC_ +ALLTRIM(MOV_NDOC_) TAG ORDERR ADDITIVE

RELEASE CONTAERR 
PUBLIC CONTAERR
CONTAERR = 0

RELEASE DATA_CARI,MESE_CARI
RELEASE ___CTF_CLI,___CTF_CLI_AUTO,___CTF_FOR,___CTF_FOR_CEE,___CTC_CORRISP,___CTF_NC_CLI
PUBLIC ___CTF_CLI,___CTF_CLI_AUTO,___CTF_FOR,___CTF_FOR_CEE,___CTC_CORRISP,___CTF_NC_CLI
RELEASE ___CTF_NC_FOR,OK_CONTA
PUBLIC  ___CTF_NC_FOR,OK_CONTA
PUBLIC DATA_CARI,MESE_CARI


___CTF_CLI				= 0
___CTF_CLI_AUTO 		= 0
___CTF_FOR				= 0
___CTF_FOR_CEE			= 0
___CTC_CORRISP			= 0
___CTF_NC_CLI			= 0
___CTF_NC_FOR			= 0
OK_CONTA				= .F.

ANNODAL   = SUBSTR(DATADAL,7,4)
MESEDAL   = SUBSTR(DATADAL,4,2)
V_ANNO	  = ANNODAL
V_MESE	  = MESEDAL
CONTA_REC = 0

DATA_CARI = RIBALTA2(DATA_CARICAMENTO_BOLLATO)
MESE_CARI = MESEDAL

PUBLIC OK_PROTCL 
OK_PROTCL = 0

IF (EMPTY(MESEDAL)) .OR.  (EMPTY(ANNODAL))  
   RETURN
ENDIF  


* VERIFICA SE MESE CONTABILE CHIUSO
MMCLO    = MESEDAL   
v_seek	= 'MES'+PUB_ANNO+MMCLO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(LIBERA,1,1) = "S"
 	 =MSGBOX("Mese contabile "+PUB_ANNO+"/"+MMCLO+" già chiuso"+CHR(13)+"caricamento bollato impossibile",'ATTENZIONE',31)
     RETURN
   ENDIF	
ENDIF




RIT = MESSAGEBOX('Sei sicuro di voler caricare il mese iva da : '+DATADAL+CHR(13)+" a :"+DATAAL+CHR(13),292,"ATTENZIONE")
IF RIT = 7
   DO CLEAR_VAR
   RETURN
ENDIF

*** DEFINISCE UN CURSORE DI SUPPORTO USATO PER LA GESTIONE DELLE VENDITE AL BANCO PER CORRISPETTIVI (VB)
CREATE CURSOR cur_regis ;
	(____NUMPRO C(13))
INDEX ON ____NUMPRO				TAG NUMPRO___


*** CERCA SU U_AZI_AN SE E' NECESSARIO GESTIRE LE ESENZIONI SUL CLIENTE NEL CASO DI ARTICOLO PUBBLICITARIO
IF !ExecCommand("select * from u_azi_an","u_azi_an")
  return(.f.)
ENDIF
SELECT U_AZI_AN
GO TOP
IF !EOF()
   OK_ESECLI = AZI_ARTPUB  && ARTICOLO PUBBLICITARIO
   OK_PROTCL = AZI_PROTCL
ELSE
   OK_ESECLI = .F.  && ARTICOLO PUBBLICITARIO
   OK_PROTCL = -1
   WAIT WINDOW "Per cortesia codifica il parametro bollati iva"
ENDIF



***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE/FORNITORE
v_seek	 = 'GEN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   RIT=MSGBOX("Errore manca parametro GEN 4 caratteri conti clienti",'ATTENZIONE',31)
   RETURN(3)
ENDIF
CCC=SUBSTR(LIBERA,01,PUB_SOTTOG-1)
FFF=SUBSTR(LIBERA,18,PUB_SOTTOG-1)

IF !ExecCommand("select * from u_iva_cs where 0=1","cu_iva_cs") 		&& bollato iva clienti in sospensione iva
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_iva_cl where 0=1","cu_iva_cl")			&& bollato iva clienti
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_ivf_cl where 0=1","cu_ivf_cl")			&& bollato iva fornitori
   return(.f.)
ENDIF

DO IVAVENDI      &&  CARICAMENTO BOLLATO IVA VENDITE GENERICHE
DO IVAVENSO      &&  CARICAMENTO BOLLATO IVA VENDITE IN SOSPENSIONE IVA
DO IVAVENLI		 &&  CARICAMENTI BOLLATO IVA FATTURE INCASSATE NEL PERIODO
DO IVAACQUI      &&  CARICAMENTO BOLLATO IVA ACQUISTI

DO RAGGRUPPA_FATTURE


IF !ExecRW('','u_iva_cl','I','','CU_IVA_CL')
   return(.f.)
ENDIF
IF !ExecRW('','u_ivf_cl','I','','CU_IVF_CL')
   return(.f.)
ENDIF

SELECT cur_regis
GO TOP
COUNT TO ___TOT_REC

 

RELEASE _msg01,_msg02,_msg03,_msg04,_msg05,_msg06,_msg07,_msg08,_msg09,_msg10,_msg11
PUBLIC _msg01,_msg02,_msg03,_msg04,_msg05,_msg06,_msg07,_msg08,_msg09,_msg10,_msg11
RELEASE _msg01v,_msg02v,_msg03v,_msg04v,_msg05v,_msg06v,_msg07v,_msg08v,_msg09v,_msg10v,_msg11v
PUBLIC _msg01v,_msg02v,_msg03v,_msg04v,_msg05v,_msg06v,_msg07v,_msg08v,_msg09v,_msg10v,_msg11v

*!*	SERGIO INIZIO 05/08/2017
RELEASE _TITOLO
PUBLIC _TITOLO
_TITOLO = ''

DO CASE

	CASE MESEDAL = '01'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI GENNAIO '+ PUB_ANNO

	CASE MESEDAL = '02'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI FEBBRAIO '+ PUB_ANNO

	CASE MESEDAL = '03'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI MARZO '+ PUB_ANNO

	CASE MESEDAL = '04'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI APRILE '+ PUB_ANNO

	CASE MESEDAL = '05'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI MAGGIO '+ PUB_ANNO

	CASE MESEDAL = '06'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI GIUGNO '+ PUB_ANNO

	CASE MESEDAL = '07'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI LUGLIO '+ PUB_ANNO

	CASE MESEDAL = '08'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI AGOSTO '+ PUB_ANNO

	CASE MESEDAL = '09'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI SETTEMBRE '+ PUB_ANNO

	CASE MESEDAL = '10'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI OTTOBRE '+ PUB_ANNO

	CASE MESEDAL = '11'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI NOVEMBRE '+ PUB_ANNO

	CASE MESEDAL = '12'
		_TITOLO = 'CARICAMENTO BOLLATO IVA DEL MESE DI DICEMBRE '+ PUB_ANNO




ENDCASE


*!*	SERGIO FINE 05/08/2017

IF ___TOT_REC <> 0		&& VERIFICA SE DOPPIA GESTIONE CORRISPETTIVI E CORRISPETTIVI PER VENDITA AL BANCO

	_msg01= 'Fatture clienti manuali'
	_msg02= 'Fatture clienti automatiche'
	_msg03= 'Fatture clienti in sospensione iva'
	_msg04= 'Fatture clienti in sospensione iva incassate'
	_msg05= 'Note credito clienti in sospensione iva'
	_msg06= 'Fatture fornitori'
	_msg07= 'Corrispettivi clienti'
	_msg08= 'Corrispettivi clienti vendite al banco'
	_msg09= 'Fatture cee reverse charge'
	_msg10= 'Note credito clienti'
	_msg11= 'Note credito fornitori'

	_msg01v= ___CTF_CLI
	_msg02v= ___CTF_CLI_AUTO
	_msg03v= ___CTF_FVS_CLI 
	_msg04v= ___CTF_FVS_CLI_INC
	_msg05v= ___CTF_FVS_NC_CLI 
	_msg06v= ___CTF_FOR
	_msg07v= ___CTC_CORRISP
	_msg08v= ___TOT_REC
	_msg09v= ___CTF_FOR_CEE
	_msg10v= ___CTF_NC_CLI
	_msg11v= ___CTF_NC_FOR
	
	DO form form\send_msg linked

ELSE

	_msg01= 'Fatture clienti manuali'
	_msg02= 'Fatture clienti automatiche'
	_msg03= 'Fatture clienti in sospensione iva'
	_msg04= 'Fatture clienti in sospensione iva incassate'
	_msg05= 'Note credito clienti in sospensione iva'
	_msg06= 'Fatture fornitori'
	_msg07= 'Corrispettivi clienti'
	_msg08= 'Fatture cee reverse charge'
	_msg09= 'Note credito clienti'
	_msg10= 'Note credito fornitori'
	_msg11= ''
	
	_msg01v= ___CTF_CLI
	_msg02v= ___CTF_CLI_AUTO
	_msg03v= ___CTF_FVS_CLI 
	_msg04v= ___CTF_FVS_CLI_INC
	_msg05v= ___CTF_FVS_NC_CLI 	
	_msg06v= ___CTF_FOR
	_msg07v= ___CTC_CORRISP
	_msg08v= ___CTF_FOR_CEE
	_msg09v= ___CTF_NC_CLI
	_msg10v= ___CTF_NC_FOR
	_msg11v= 0
	
	DO form form\send_msg linked

ENDIF 



IF CONTAERR > 0
   =MESSAGEBOX("Alcuni fornitori CEE sono stati codificati"+CHR(13)+;
               "senza il codice CLIENTE CEE per la gestione del bollato compensativo"+CHR(13)+;
               "provvedere alla codifica altrimenti non è possibile gestire il bollato compensativo!!",62,"ATTENZIONE")
   SELECT STAMPAERR
   SET ORDER TO ORDERR
   GO TOP
   RIT = MESSAGEBOX("Desideri anteprima di stampa ?",292,"ATTENZIONE")            
   IF RIT = 6
      REPORT FORM REPORT\BOLERR.FRX NOCONSOLE PREVIEW
   ENDIF
   REPORT FORM REPORT\BOLERR.FRX NOCONSOLE TO PRINTER PROMPT
   TRONCATUTTO = .T.
ENDIF


DO AGGIORNA_DATA_ORA_CARICAMENTO_BOLLATO_IVA


RELEASE WINDOW DISPLAY
RETURN

************************
PROCEDURE CLEAR_VAR
************************
MESEDAL   = SPACE(2)
ANNODAL   = SPACE(4)
SHOW GETS


***********************************************************************************************
PROCEDURE IVAVENDI    
***********************************************************************************************
* GESTIONE IMPOSTE ESENTI
* CREAZIONE AUTOMATICA RECORD DI ESENZIONE NEL CASO IN CUI ESISTE ARTICOLO PUBBLICITARIO
* CREAZIONE AUTOMATICA RECORD ESENZ. SE ARTICOLO PUBBLICITARIO MISTO AD ARTICOLI DI VENDITA NORMALE

*==>>> ANNULLO DEL BOLLATO PRECEDENTE 

x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = '" + ANNODAL + "'"
x_mese = "iva_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese
CSQL   = "delete from u_iva_cl where " + x_cond
IF !ExecCommand(CSQL,"U_IVA_CL")
   RETURN (.f.)
ENDIF 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNODAL + "'"
x_mese = "ito_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese 
CSQL   = "delete from u_iva_to where " + x_cond
IF !ExecCommand(CSQL,"U_IVA_TO")
   RETURN (.f.)
ENDIF 

IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
   return(.f.)
ENDIF
SELECT MOV_CONT
HH=AFIELDS(TRANSIVC)
CREATE CURSOR IVA FROM ARRAY TRANSIVC

DATA_DA = RIBALTA2(DATADAL)
DATA_A  = RIBALTA2(DATAAL)

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + ANNODAL + "'"
x_data = "mov_dtreg >= '" + DATA_DA + "'"
x_datad = "mov_dtreg >= '" + DATA_DA + "'"
x_dataa = "mov_dtreg <= '" + DATA_A + "'"

x_cond = x_soci + " and " + x_anno + " and " + x_datad + " and " + x_dataa


cSql   = "SELECT * FROM mov_cont WHERE " + x_cond + " order by mov_soc,mov_anno,mov_dtreg,mov_numpro,mov_sequen"
IF !ExecCommand(cSql,"MOV_CONT")
   return(.f.)
ENDIF
SELECT MOV_CONT
GO TOP


RELEASE _STO_TRATTANDO_UN_CLIENTE 
PUBLIC  _STO_TRATTANDO_UN_CLIENTE 
_STO_TRATTANDO_UN_CLIENTE = .F.

**=> ERASMO/SERGIO INIZIO - 01/08/2017
RELEASE __MOV_NUMPRO__
PUBLIC __MOV_NUMPRO__
__MOV_NUMPRO__ = ""
**=> ERASMO/SERGIO FINE - 01/08/2017

CTRELAB = 0

DO WHILE .T.       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
*!*	.......................................................................................... FINE ELABORAZIONE

   IF MOV_DTREG > DATA_A
      EXIT
   ENDIF

*!*	.......................................................................................... VERIFICA SE BOLLE DOGANALI
   
   IF ALLTRIM(MOV_TOP)="BD"    && CASO BOLLE DOGANALI 
      IF (MOV_IVA = 'NO') .AND. (CAMBIO(MOV_VALUTA,MOV_IMPORT,MOV_CAMBIO) = 0)   
         SELECT MOV_CONT
	     SKIP +1
	     LOOP
      ENDIF
   ENDIF

*!*	.......................................................................................... VERIFICA CONTO CONTabile

   SELECT MOV_CONT
   XX_CONTO = MOV_CONTO
   XX_ANNO  = MOV_ANNO
   XX_NREGI = MOV_NREGIS  
   
   *__MOV_NUMPRO__ = MOV_NUMPRO  && ERASMO/SERGIO - 01/08/2017

*!*	IF ALLTRIM(XX_NREGI) = '2'
*!*	SET STEP ON 
*!*	ENDIF


   x_soci  = "con_soc = '" + PUB_CODSOC + "'"
   x_anno  = "con_anno = '" + XX_ANNO + "'"
   x_codi  = "con_conto = '" + ALLTRIM(XX_CONTO) + "'"
   x_cond  = x_soci + " and " + x_anno + " and " + x_codi
   Csql    = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecCommand(cSql,"cur_conti")
      return(.f.)
   ENDIF
   SELECT cur_conti
   GO TOP
   IF EOF()
	  =MESSAGEBOX("Registrazione non corretta "+XX_NREGI+CHR(13)+"manca conto "+XX_CONTO,16,"*** ATTENZIONE ***") 
	  RETURN
   ENDIF

   TIPOCONTO = CON_TIPOCO		&& IDENTIFICA IL TIPO DI CONTO

*!*	.......................................................................................... ESTRAE INCASSI AL BANCO PER CORRISPETTIVI
   
   SELECT MOV_CONT

   WTOP   	= MOV_TOP
   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   	= SUBSTR(LIBERA,2,1)
      TMOV      = SUBSTR(LIBERA,33,2)
      BOLL		= SUBSTR(LIBERA,9,1)
   ELSE
      FAT    	= SPACE(1)
      TMOV      = SPACE(2)
      BOLL		= SPACE(1)
   ENDIF

   SELECT MOV_CONT

   IF BOLL = 'N'
      SELECT MOV_CONT
	  SKIP +1
	  LOOP
   ENDIF

   IF FAT = 'C' AND TMOV = 'VB'  AND  TIPOCONTO = 'K' && SE REGISTRAZIONE VENDITA AL BANCO X CORRISPETTIVI ED IL CONTO IN ELABORAZIONE E' UN CORRISPETTIVO : ESTARE
      SELECT MOV_CONT
	  SCATTER MEMVAR MEMO	    && Salva i vecchi valori
	  ** VERIFICA SE LA REGISTRAZIONE E' GIA' STATA TRATTATA
 	  SELECT cur_regis
 	  SEEK M.MOV_NUMPRO
 	  IF !FOUND()
		 APPEND BLANK
		 REPLACE ____NUMPRO WITH M.MOV_NUMPRO
	     SELECT IVA
		 APPEND BLANK
		 GATHER MEMVAR MEMO		&& Salva le modifiche
		 REPLACE MOV_FLG 	WITH "C"					&& IDENTIFICA RECORD VENDITE AL BANCO PER CORRISPETTIVI	   	
		 CTRELAB=CTRELAB+1 
	  ENDIF
      SELECT MOV_CONT
	  SKIP +1
	  LOOP
   ENDIF
  
*!*	.......................................................................................... ESCLUDE I RECORD IVA
   
   IF (MOV_IVA = 'NO') .AND. (CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) = 0)
   ELSE
      SKIP +1
      LOOP
   ENDIF

*!*	.......................................................................................... VERIFICA CLIENTI/FORNITORI

   IF VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CF")
   ELSE
      SKIP +1
      LOOP
   ENDIF

   IF VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CL")
     _STO_TRATTANDO_UN_CLIENTE = .T.
   ENDIF

*!*	.......................................................................................... SCRIVE IL CURSORE CON I RECORD CLIENTI / FORNITORI GUIDA PER IL TRATTAMENTO SUCCESSIVO 

   SELECT MOV_CONT
   SCATTER MEMVAR MEMO	    && Salva i vecchi valori

   SELECT IVA
   APPEND BLANK
   GATHER MEMVAR MEMO		&& Salva le modifiche

   CTRELAB=CTRELAB+1 

   SELECT MOV_CONT
   SKIP +1

ENDDO

CT = 0




CREATE CURSOR SOLOUNCLI (SOL_CODSOC C(02), SOL_ANNO C(04), SOL_NUMPRO C(13))
INDEX ON SOL_CODSOC + SOL_ANNO + SOL_NUMPRO TAG I_UNCLI ADDITIVE



SELECT IVA
INDEX ON MOV_NPROT + MOV_NUMPRO + MOV_ANNO + MOV_TOP + MOV_CONTO TAG I_IVA ADDITIVE
SET ORDER TO I_IVA
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   __MOV_NUMPRO__ = MOV_NUMPRO  && ERASMO - 18/12/2017
   
   IF OK_PROTCL < 0    && ASSUME IL NUMERO DI FATTURA ORIGINALE
	  VNUMPRT	= VAL(SUBSTR(MOV_NPROT,1,6))       && CONTIENE IL NUMERO DI PROTOCOLLO
   ELSE
	  VNUMPRT	= VAL(SUBSTR(MOV_NDOC,1,6))        && CONTIENE IL NUMERO DI PROTOCOLLO
   ENDIF 


   ___NREGI = MOV_NREGIS  
*!*	IF ALLTRIM(___NREGI) = '5'
*!*	SET STEP ON 
*!*	ENDIF

   NREG   		= MOV_NUMPRO
   ANNO   		= MOV_ANNO
   WTOP   		= MOV_TOP
   WCONTO 		= MOV_CONTO
   WCODCLI  	= MOV_CONTO

   _MOV_CONTO   = MOV_CONTO
   _MOV_DTREG   = MOV_DTREG   
   _MOV_NREGIS  = MOV_NREGIS   
   _MOV_NPROT   = MOV_NPROT  
   _MOV_NDOC    = MOV_NDOC  
   _MOV_DTDOC   = MOV_DTDOC    
   
*!*	   IF _MOV_NPROT = "001347"
*!*	      SET STEP ON
*!*	   ENDIF

   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   	= SUBSTR(LIBERA,2,1)
      NOTAC 	= SUBSTR(LIBERA,11,1) 
	  VER_CONTO = SUBSTR(LIBERA,12,1)
      CEE   	= SUBSTR(LIBERA,23,1)
      VENSOSP  	= SUBSTR(LIBERA,61,1)
   ELSE
      FAT    	= SPACE(1)
      NOTAC  	= SPACE(1)
      VER_CONTO = SPACE(1)
      CEE    	= SPACE(1)
      VENSOSP  	= SPACE(1)
   ENDIF

   IF FAT = 'S' OR FAT = 'C' && SALTA I TOP NON FATTURA / CORRISPETTIVI
   ELSE
      SELECT IVA 
      SKIP +1
      LOOP
   ENDIF


   IF VENSOSP = 'S'  && ESCLUDE LE VENDITE IN SOSPENSIONE IVA
      SELECT IVA 
      SKIP +1
      LOOP
   ENDIF
   

	_MOV_RAGSOC = ""

   *IF CEE = 'E' OR CEE = 'R' && FATTURA CEE o per iva reverse change PRELEVA IL CODICE CLIENTE CEE DA ANAGRAFICA DEL FORNITORE
   IF CEE = 'E' OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017 - FATTURA CEE o per iva reverse change o per Autofatture PRELEVA IL CODICE CLIENTE CEE DA ANAGRAFICA DEL FORNITORE
	  WCOD   = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
	  WCODF  = WCODCLI
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + ALLTRIM(WCOD) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"u_for_an")
         return(.f.)
      ENDIF
      SELECT u_for_an
      GO TOP
	  IF !EOF()
         WNAZION     = FOR_NAZION
	     WCLICEE     = FOR_CLICEE
	     _MOV_RAGSOC = FOR_RAGSOC
	  ELSE
	     WNAZION     = "ITA"
	     WCLICEE     = WCOD
	     _MOV_RAGSOC = ""
	  ENDIF
	  V_ER=SOTTOGEN(WNAZION)
      IF !V_ER
		 XCC = PUB_CC 
      ELSE
         XCC = CCC 
      ENDIF 
      WCODCLI     = XCC + WCLICEE	&& FORZA CODICE CLIENTE CEE AL POSTO DEL CODICE FORNITORE
      M.MOV_CONTO = WCODCLI
      SELECT IVA
      IF EMPTY(WCLICEE)
         
         DO MANCA_CODICE_CLIENTE_CEE
         
         SELECT IVA
         SKIP +1
         LOOP
      ENDIF
      REPLACE MOV_CONTO WITH M.MOV_CONTO
   
   ENDIF

   SELECT IVA

   DO CASE
   
      CASE MOV_FLG = "C"								&& CORRISPETTIVO DA VENDITA AL BANCO

			   XX_CONTO = MOV_CONTO
			   XX_ANNO  = MOV_ANNO
			   XX_NREGI = MOV_NREGIS  
			   x_soci = "con_soc = '" + PUB_CODSOC + "'"
			   x_anno = "con_anno = '" + XX_ANNO + "'"
			   x_codi = "con_conto = '" + ALLTRIM(XX_CONTO) + "'"
			   x_cond = x_soci + " and " + x_anno + " and " + x_codi
			   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
			   IF !ExecCommand(cSql,"cur_conti")
			      return(.f.)
			   ENDIF
			   SELECT cur_conti
			   GO TOP
			   IF EOF()
				  =MESSAGEBOX("Registrazione non corretta "+XX_NREGI+CHR(13)+"manca conto "+XX_CONTO,16,"*** ATTENZIONE ***") 
				  RETURN
			   ENDIF
		       WRAGSOC   = CON_DESCR
		       WINDIRI   = AQUADATI(4)
		       WLOCALI   = AQUADATI(5)
		       WCAP      = AQUADATI(6)
		       WPARIVA   = AQUADATI(3)
		       WCCAGE    = "001"
		       WNAZION   = "ITA"

 		OTHERWISE
 		
			   WCOD    = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
			   WCODCLI = WCOD
			   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
			   x_codi = "cli_codcli = '" + ALLTRIM(WCOD) + "'"
			   x_cond = x_soci + " and " + x_codi
			   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
			   IF !ExecCommand(cSql,"u_cli_an")
			      return(.f.)
			   ENDIF
			   SELECT U_CLI_AN
			   GO TOP
			   IF !EOF()
			      WRAGSOC   = CLI_RAGSOC
			      WINDIRI   = CLI_INDIR
			      WLOCALI   = CLI_LOCALI
			      WCAP      = CLI_CAP
			      WPARIVA   = CLI_PARIVA
			      WCCAGE    = CLI_AGE
			      WNAZION   = CLI_NAZION
			   ELSE
			      *WRAGSOC   = SPACE(40)
			      WRAGSOC   = "*ANAGR. CLI. " + ALLTRIM(WCODCLI) + " INESISTENTE*"  && ERASMO - 28/07/2017
			      WINDIRI   = SPACE(40)
			      WLOCALI   = SPACE(40)
			      WCAP      = SPACE(5)
			      WPARIVA   = SPACE(16)  
			      WCCAGE    = SPACE(03)
			      WNAZION   = SPACE(03)
			   ENDIF
			   SELECT IVA
			   IF !VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CL")
			      SELECT IVA
			      SKIP +1
			      LOOP
			   ENDIF

   ENDCASE

   CT = CT + 1

   *===>>> ACCESSO AI MOVIMENTI CONTABILI PER ELABORARE I RECORDS IVA 
   SELECT IVA 
   _NUMPRO     	= MOV_NUMPRO
   _NREGIS     	= MOV_NREGIS
   XX_FLG   	= MOV_FLG



   *=> INIZIO - SERGIO 04/05/2006
   *=> Dal momento che in una registrazione contabile possono esserci 2 o più clienti, per evitare che si riporti
   *   più volte l'imposta, si deve verificare che la registrazione in esame NON sia già stata elaborata.
   
   SELECT SOLOUNCLI
   SET ORDER TO I_UNCLI
   SEEK PUB_CODSOC + PUB_ANNO + _NUMPRO
   IF FOUND()
      SELECT IVA
      SKIP +1
      LOOP
   ELSE
      APPEND BLANK
      REPLACE SOL_CODSOC WITH PUB_CODSOC
      REPLACE SOL_ANNO   WITH PUB_ANNO
      REPLACE SOL_NUMPRO WITH _NUMPRO
   ENDIF

   SELECT IVA
   
   *=> FINE - SERGIO 04/05/2006


   
   WAIT WINDOWS "Fattura cliente elaborata n. " + STR(VNUMPRT,6,0) + " registrazione : " + _NREGIS NOWAIT
   WTOP        = MOV_TOP

*!*	IF MOV_NUMPRO = '_4CZ0R9LMZ'
*!*	  SET STEP ON 
*!*	ENDIF


   x_soci = "mov_soc = '" + PUB_CODSOC + "'"
   x_anno = "mov_anno = '" + PUB_ANNO + "'"
   x_npro = "mov_numpro = '" + _NUMPRO + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_npro
   cSql="SELECT * FROM mov_cont WHERE " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
   IF !ExecCommand(cSql,"MOV_CONT")
      return(.f.)
   ENDIF
   SELECT MOV_CONT
   GO TOP

   OK_CONTA = .T. 
   
   IF !EOF()
	  DO WHILE .T.
	     IF EOF()
            EXIT
         ENDIF
	 	 IF DELETED()
			SKIP +1
			LOOP
		 ENDIF
         **=> ERASMO/FABIANO INIZIO - 29/06/2015 - PEZZO DI CODICE ASTERISCATO IN QUANTO ALTRIMENTI NON CONVERGONO NEI BOLLATI DEI PROTOCOLLI FATTURE INTERAMENTE CON IMPORTO ZERO, CREANDO DEI BUCHI DI PROTOCOLLI
*!*	 		 * CASO DI VENDITE CON ARTICOLO PUBBLICITARIO FATTE ALL'ESTERO (QUINDI IN ESENZIONE IVA)
*!*			 IF CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) = 0 	.AND. 	CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) = 0
*!*				SKIP +1
*!*				LOOP
*!*			 ENDIF
         **=> ERASMO/FABIANO FINE - 29/06/2015 - PEZZO DI CODICE ASTERISCATO IN QUANTO ALTRIMENTI NON CONVERGONO NEI BOLLATI DEI PROTOCOLLI FATTURE INTERAMENTE CON IMPORTO ZERO, CREANDO DEI BUCHI DI PROTOCOLLI

		 XX_NREGI = MOV_NREGIS
		 XX_CONTO = MOV_CONTO
		 XX_ANNO  = MOV_ANNO
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + XX_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(XX_CONTO) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(cSql,"cur_conti")
            return(.f.)  
         ENDIF
         SELECT cur_conti
         GO TOP
		 IF !EOF()
		    XX_TIPOC = CON_TIPOCO
		 ELSE
		    XX_TIPOC = " "
	  	    =MESSAGEBOX("Registrazione non corretta "+XX_NREGI+CHR(13)+"manca conto "+XX_CONTO,16,"*** ATTENZIONE ***") 
	 	    RETURN
 		 ENDIF
		 SELECT MOV_CONT
		 IF XX_TIPOC = "I"    && SCARTA I RECORD IVA
	 		SKIP +1
			LOOP
		 ENDIF
		 IF MOV_IVA = 'NO' 
	 		SKIP +1
			LOOP
         ENDIF
		 IMPONIES  = 0      && IMPONIBILE ESENTE DA IVA
		 IMPONIE2  = 0      && IMPONIBILE ESENTE DA IVA
         COD_IVA   = MOV_IVA
         COD_IVAES = "ES "
         v_seek	  = 'IVA'+COD_IVAES      && VENDITE PUBBLICITARIE (SOLO IVA)
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            DES_IVES   = SUBSTR(DESCRI,1,21)
            ALIQES     = SUBSTR(LIBERA,1,3)
         ELSE
            DES_IVES   = "*************"
            ALIQES     = "20"
         ENDIF
         v_seek	  = 'IVA'+ALLTRIM(COD_IVA)     
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            DES_IVA   = SUBSTR(DESCRI,1,30)
            ALIQ      = SUBSTR(LIBERA,1,3)
            NO_IVAREVERSE = NOIVAREVERSE	&& ERASMO/FABIANO - 29/12/2017
         ELSE
            DES_IVA   = SPACE(30)
            ALIQ      = SPACE(3)
            NO_IVAREVERSE = ""				&& ERASMO/FABIANO - 29/12/2017
         ENDIF
         SELECT MOV_CONT
         
		**=> ERASMO/FABIANO - INIZIO 03/08/2015
		*** SE IVA IN ESENZIONE (ALIQUOTA ZERO) QUESTO CODICE IVA NON PREVEDE COMPENSAZIONE CON AUTOFATTURA REVERSE CHARGE
		IF CEE = 'R'
			IF VAL(ALIQ)      > 0
			ELSE
				SELECT MOV_CONT
				SKIP +1
				LOOP
			ENDIF
		ENDIF
		**=> ERASMO/FABIANO - FINE 03/08/2015
		
		**=> ERASMO/FABIANO - INIZIO 29/12/2017
		*** SKIPPO SE TOP REVERSE CHARGE MA IVA CONFIGURATA CON FLAG "Esclude questo codice Iva ai fini delle compensazioni nel bollato Iva per Reverse Charge" = 'S'
		IF CEE = 'R'
			IF NO_IVAREVERSE = 'S'
				SELECT MOV_CONT
				SKIP +1
				LOOP
			ENDIF
		ENDIF
		**=> ERASMO/FABIANO - FINE 29/12/2017
	         
         
  	     ** 2015/05/26 FABIANO/SERGIO GESTIONE ANTICIPI CON CAMBIO SEGNO 
	     IF   MOV_ANT_CAMB_SEGNO
	          REPLACE  MOV_IMP    WITH MOV_IMP    * -1
	          REPLACE  MOV_IMPOST WITH MOV_IMPOST * -1
	     ENDIF
	     ** 2015/05/26 FABIANO/SERGIO GESTIONE ANTICIPI CON CAMBIO SEGNO 
                
         
         WNUMPRO     	= MOV_NUMPRO
         WNREG       	= MOV_NREGIS
         WNPART      	= MOV_NPART
         WNUMDOC     	= ALLTRIM(MOV_NPROT)
         WNPROG      	= "000"
         WDTREG      	= MOV_DTREG
         WDTFAT      	= MOV_DTDOC
         WNUMFAT     	= MOV_NDOC
         WTIPFAT     	= MOV_TOP
         WMESE       	= SUBSTR(MOV_DTREG,6,2) 
         WFR         	= MOV_FATRI
         WCODPAG     	= MOV_MODPAG
         WTOTIM      	= CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
   		 WBOLLATOIVA  	= MOV_BOLLATOIVA
	 	 IF VAL(ALIQ) = 0		&& ESENZIONE
	        WTIMPOS   = 0
		 ELSE
	        WTIMPOS   = CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
		 ENDIF
         WFATT       = CAMBIO(MOV_VALUTA,MOV_IMP+MOV_IMPOST,MOV_CAMBIO)
         IMPONIBILE  = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
	 	 IF VAL(ALIQ) = 0	&& ESENZIONE
			IMPOSTA     = 0
         ELSE	
        	IMPOSTA     = CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
		 ENDIF
         TOTALE     = CAMBIO(MOV_VALUTA,MOV_IMP+MOV_IMPOST,MOV_CAMBIO)
 	     WVALUTA  	= MOV_VALUTA
	     WCAMBIO  	= MOV_CAMBIO
 		 ** VERIFICA IMPONIBILE : NEL CASO IN CUI ESISTE UN ARTICOLO VENDUTO COME MATERIALE PUBBLICITARIO
		 ** 					   : CHE CONFLUISCE IN IN UN CONTO VENDITA NORMALE
		 OK_ESE    = .F.		
	 	 * SE MOV_IMP <> 0 E MOV_IMPOST = 0 CASO DI IVA IN ESENZIONE
 		 IF OK_ESECLI	.AND.  FAT <> 'C'  			&& VERIFICA SE DEVE VERAMENTE GESTIRE LE ESENZIONI
			IF CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) <> 0 
		  	   IF CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) <> 0
				  IMPO_STA    = CAMBIO(MOV_VALUTA,((IMPONIBILE * VAL(ALIQ)) / 100),MOV_CAMBIO)		
				  IF IMPO_STA <> IMPOSTA
				     NW_IMPOST = IMPOSTA - IMPO_STA
				     IF VAL(ALIQ) = 0
					    NW_IMPONI = 0	   						  && CLIENTE IN ESENZIONE IVA (ESTERO)
				     ELSE
					    NW_IMPONI = NW_IMPOST / (VAL(ALIQ)/100) && IMPONIBILE OMAGGIO
				     ENDIF
				     IMPONIBILE= IMPONIBILE + NW_IMPONI      							 && IMPONIBILE ESATTO 
	    	         TOTALE    = IMPONIBILE + CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)   && RICALCOLO DEL TOTALE   
	        	     WFATT     = IMPONIBILE + CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)   && RICALCOLO DEL TOTALE   
 		             OK_ESE    = .T.
				  ENDIF
			   ENDIF
			ENDIF
		 ENDIF
         IF !EMPTY(MOV_CEE)
            WCCAGE = MOV_CEE
         ENDIF  
         v_seek	  = 'TOP'+ALLTRIM(WTOP)     
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            NOTAC = SUBSTR(LIBERA,11,1) 
            FAT   = SUBSTR(LIBERA,2,1)
            TMOV  = SUBSTR(LIBERA,33,2)
         ELSE
            NOTAC = SPACE(1)
            FAT   = SPACE(1)
		    TMOV  = SPACE(2)
         ENDIF
	     IF _STO_TRATTANDO_UN_CLIENTE 		&& SOLO SE MOV.CONTABILE CLIENTE SOMMA
			 IF NOTAC = 'S'  
		 	 	IF OK_CONTA  
				    OK_CONTA = .F. 
			 	 	___CTF_NC_CLI = ___CTF_NC_CLI  +  1 
				ENDIF
			 ELSE
		 	 	IF OK_CONTA  
				    OK_CONTA = .F. 
	                IF WBOLLATOIVA =  " "
						IF XX_FLG <> "C"						&& NON SOMMA I CORRISPETTIVI PER VENDITA AL BANCO
				 	 		___CTF_CLI = ___CTF_CLI  +  1 							
			 	 		ENDIF
					ENDIF
	                IF WBOLLATOIVA =  "D"
			 	 		___CTF_CLI_AUTO = ___CTF_CLI_AUTO  +  1 
					ENDIF
				ENDIF
			 ENDIF
	     ENDIF
 		 SELECT MOV_CONT
		 * SE MOV_IMP <> 0 E MOV_IMPOST = 0 CASO DI IVA IN ESENZIONE
		 IF CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) <> 0 
		 	IF CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) = 0
	           IMPONIBILE  = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
		       IMPOSTA     = CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
		       TOTALE      = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) + CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
			   DO IVACLIES	&&  GESTIONE IVA ESENTE PER CLIENTI
			   SELECT MOV_CONT
			   SKIP +1
			   LOOP
			ENDIF
		 ENDIF
     	 ** === > AGGIORNA  ARCHIVI IVA (DETTAGLI / TOTALE)
     	 ** === > 19/01/2004 NUOVA GESTIONE MATERIALE PUBBLICITARIO------INIZIO
         ___MPUBBLI  = CAMBIO(MOV_VALUTA,MOV_PUBBLI,MOV_CAMBIO)
		 IF	___MPUBBLI = 0 			&& GETIONE NORMALE
     	 ** === > 19/01/2004 NUOVA GESTIONE MATERIALE PUBBLICITARIO------FINE
		    IF FAT = 'C'  
	 		   DO CORRISP     && GESTIONE CORRISPETTIVI
               XXX_FATNOT = 'C'
            ELSE
		       IF NOTAC = 'S'  
		          T_IPO = 'N'
	    	   ELSE
		          T_IPO = 'F'
		       ENDIF  
               x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
               x_anno = "iva_anno = '" + PUB_ANNO + "'"
               x_mese = "iva_mese = '" + WMESE + "'"
               x_chia = "iva_chiave = "  + ALLTRIM(STR(VNUMPRT,6,0))
               x_codi = "iva_codiva = '" + ALLTRIM(COD_IVA) + "'"
               x_fatt = "iva_fatnot = '" + ALLTRIM(T_IPO) + "'"
               x_biva = "iva_bollatoiva = '" + ALLTRIM(WBOLLATOIVA) + "'"
               x_clie = "iva_codcli = '" + ALLTRIM(WCODCLI) + "'"  && ERASMO - 18/12/2017
               x_tipo = "iva_top = '" + ALLTRIM(WTOP) + "'"  && ERASMO - 18/12/2017
               x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_chia + " and " + x_codi + " and " + x_fatt + " and " + x_biva + " and " + x_clie + " and " + x_tipo
               CSQL   = "select * from u_iva_cl where " + x_cond + " order by iva_codsoc,iva_anno,iva_mese,iva_chiave,iva_codiva,iva_fatnot" 
               IF !ExecRW(CSQL,"u_iva_cl","R")
                  RETURN (.f.)
               ENDIF 
  	 	       SELECT U_IVA_CL
  	 	       GO TOP
  	 	       IF EOF()
 			      APPEND BLANK
 			      REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
                  REPLACE    IVA_TOP	   WITH WTOP 
		          REPLACE    IVA_CHIAVE    WITH VNUMPRT 
		          REPLACE    IVA_CODSOC    WITH PUB_CODSOC
		          REPLACE    IVA_ANNO      WITH PUB_ANNO
		          REPLACE    IVA_CODCLI    WITH WCODCLI 
		          REPLACE    IVA_RAGSOC    WITH WRAGSOC 
		          REPLACE    IVA_DTCREA    WITH WDTREG
		          REPLACE    IVA_DTFATT    WITH WDTFAT
		          REPLACE    IVA_NUMFAT    WITH WNUMFAT 
	              IF CEE = "E"   && OR CEE = 'R' 
			         REPLACE    IVA_NUMCEE    WITH WNUMFAT 
			      ENDIF             
 		          REPLACE    IVA_INDIRI    WITH WINDIRI
		          REPLACE    IVA_LOCALI    WITH WLOCALI  
		          REPLACE    IVA_CAP       WITH WCAP
		          REPLACE    IVA_PARIVA    WITH WPARIVA
		          REPLACE    IVA_MESE      WITH WMESE
		          REPLACE    IVA_NUMDOC    WITH WNUMDOC 
		          REPLACE    IVA_CODAGE    WITH WCCAGE 
		          REPLACE    IVA_VALUTA    WITH WVALUTA
		          REPLACE    IVA_CAMBIO    WITH WCAMBIO
		          IF NOTAC = 'S'  
		             REPLACE    IVA_FATNOT    WITH 'N'
  	                 XXX_FATNOT = 'N'
		          ELSE
			         REPLACE    IVA_FATNOT    WITH 'F'
  	                 XXX_FATNOT = 'F'
		          ENDIF  
		          
  	              REPLACE    IVA_DESIVA     WITH DES_IVA
		          REPLACE    IVA_ALIQUO     WITH VAL(ALIQ) 
		          REPLACE    IVA_IMPONI     WITH IMPONIBILE    
		          REPLACE    IVA_IMPOST     WITH IMPOSTA
		          REPLACE    IVA_CODIVA     WITH COD_IVA
		          REPLACE    IVA_TOTALE    	WITH WFATT  
				  REPLACE    IVA_BOLLATOIVA WITH WBOLLATOIVA
               ELSE
   	              REPLACE    IVA_IMPONI     WITH IVA_IMPONI + IMPONIBILE    
		          REPLACE    IVA_IMPOST     WITH IVA_IMPOST + IMPOSTA
		          REPLACE    IVA_TOTALE     WITH IVA_TOTALE + WFATT  
		       ENDIF        
               ** CREA MOVIMENTO IMPONIBILE ESENTE NEL CASO DI ARTICOLI PUBB.CHE SONO CONFLUITI NELLE VENDITE
     	       IF OK_ESE		
 	              APPEND BLANK
 	              REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
                  REPLACE    IVA_TOP	   WITH WTOP 
		          REPLACE    IVA_CHIAVE    WITH VNUMPRT 
		          REPLACE    IVA_CODSOC    WITH PUB_CODSOC
		          REPLACE    IVA_ANNO      WITH PUB_ANNO
		          REPLACE    IVA_CODCLI    WITH WCODCLI 
		          REPLACE    IVA_RAGSOC    WITH WRAGSOC 
		          REPLACE    IVA_DTCREA    WITH WDTREG
		          REPLACE    IVA_DTFATT    WITH WDTFAT
		          REPLACE    IVA_NUMFAT    WITH WNUMFAT 
                  IF CEE = "E"  &&  OR CEE = 'R' 
			         REPLACE    IVA_NUMCEE    WITH WNUMFAT 
		  	      ENDIF             
         	      REPLACE    IVA_INDIRI    WITH WINDIRI
		          REPLACE    IVA_LOCALI    WITH WLOCALI  
		          REPLACE    IVA_CAP       WITH WCAP
		          REPLACE    IVA_PARIVA    WITH WPARIVA
		          REPLACE    IVA_MESE      WITH WMESE
		          REPLACE    IVA_NUMDOC    WITH WNUMDOC 
	              REPLACE    IVA_CODAGE    WITH WCCAGE 
	              REPLACE    IVA_VALUTA    WITH WVALUTA
		          REPLACE    IVA_CAMBIO    WITH WCAMBIO
			      IF NOTAC = 'S'  
		             REPLACE    IVA_FATNOT    WITH 'N'
  	                 XXX_FATNOT = 'N'
		          ELSE
		             REPLACE    IVA_FATNOT    WITH 'F'
  	                 XXX_FATNOT = 'F'
		          ENDIF  
				  IF FAT = 'C'   && CORRISPETTIVI
		 	         REPLACE    IVA_FATNOT    WITH 'C'
  	                 XXX_FATNOT = 'C'
			      ENDIF  
 		          REPLACE    IVA_DESIVA     WITH DES_IVES
		          REPLACE    IVA_ALIQUO     WITH VAL(ALIQ)
 			      IMPONIE2 = 	NW_IMPONI * -1 && RIOTTIENE L'IMPONIBILE OMAGGIO "FUSO"
 		          REPLACE    IVA_IMPONI     WITH IMPONIE2
		          REPLACE    IVA_TOTALE     WITH IMPONIE2
		          REPLACE    IVA_IMPOST     WITH 0
		          REPLACE    IVA_CODIVA     WITH COD_IVAES
				  REPLACE    IVA_BOLLATOIVA WITH WBOLLATOIVA
	           ENDIF		
               IF !ExecRW(cSql,"U_IVA_CL","W")
                  return(.f.)
               ENDIF
            ENDIF  
         ELSE
            ** GESTIONE VENDITE PUBBLICITARIE (SOLO IVA) 
       	    ** === > 19/01/2004 NUOVA GESTIONE MATERIALE PUBBLICITARIO------INIZIO
            SELECT CU_IVA_CL
            APPEND BLANK
            REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
            REPLACE    IVA_TOP	     WITH WTOP 
	        REPLACE    IVA_CHIAVE    WITH VNUMPRT 
	        REPLACE    IVA_CODSOC    WITH PUB_CODSOC
	        REPLACE    IVA_ANNO      WITH PUB_ANNO
	        REPLACE    IVA_CODCLI    WITH WCODCLI 
	        REPLACE    IVA_RAGSOC    WITH WRAGSOC 
	        REPLACE    IVA_DTCREA    WITH WDTREG
	        REPLACE    IVA_DTFATT    WITH WDTFAT
	        REPLACE    IVA_NUMFAT    WITH WNUMFAT 
            IF CEE = "E"  && OR CEE = 'R' 
	           REPLACE    IVA_NUMCEE    WITH WNUMFAT 
   		    ENDIF             
 	        REPLACE    IVA_INDIRI    WITH WINDIRI
	        REPLACE    IVA_LOCALI    WITH WLOCALI  
	        REPLACE    IVA_CAP       WITH WCAP
	        REPLACE    IVA_PARIVA    WITH WPARIVA
	        REPLACE    IVA_MESE      WITH WMESE
	        REPLACE    IVA_NUMDOC    WITH WNUMDOC 
            REPLACE    IVA_CODAGE    WITH WCCAGE 	      
            REPLACE    IVA_VALUTA    WITH WVALUTA
	        REPLACE    IVA_CAMBIO    WITH WCAMBIO
 	        IF NOTAC = 'S'  
	           REPLACE    IVA_FATNOT    WITH 'N'
               XXX_FATNOT = 'N'
	        ELSE
	           REPLACE    IVA_FATNOT    WITH 'F'
               XXX_FATNOT = 'F'
	        ENDIF  
            IF FAT = 'C'  
	           REPLACE    IVA_FATNOT    WITH 'C'
               XXX_FATNOT = 'C'
	        ENDIF  
  	        REPLACE    IVA_DESIVA    WITH DES_IVA
	        REPLACE    IVA_ALIQUO    WITH VAL(ALIQ) 
	        IMPONIBILE = (100 * IMPOSTA) /  VAL(ALIQ) 
  	        REPLACE    IVA_IMPONI    WITH IMPONIBILE
	        REPLACE    IVA_IMPOST    WITH IMPOSTA
	        REPLACE    IVA_TOTALE    WITH IMPONIBILE + IMPOSTA
 	        REPLACE    IVA_CODIVA    WITH COD_IVA
            ** CREA MOVIMENTO IMPONIBILE ESENTE
            APPEND BLANK
            REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
            REPLACE    IVA_TOP	     WITH WTOP 
	        REPLACE    IVA_CHIAVE    WITH VNUMPRT 
	        REPLACE    IVA_CODSOC    WITH PUB_CODSOC
	        REPLACE    IVA_ANNO      WITH PUB_ANNO
	        REPLACE    IVA_CODCLI    WITH WCODCLI 
	        REPLACE    IVA_RAGSOC    WITH WRAGSOC 
	        REPLACE    IVA_DTCREA    WITH WDTREG
	        REPLACE    IVA_DTFATT    WITH WDTFAT
	        REPLACE    IVA_NUMFAT    WITH WNUMFAT 
            IF CEE = "E"  && OR CEE = 'R' 
	           REPLACE    IVA_NUMCEE    WITH WNUMFAT 
			ENDIF             
	        REPLACE    IVA_INDIRI    WITH WINDIRI
	        REPLACE    IVA_LOCALI    WITH WLOCALI  
	        REPLACE    IVA_CAP       WITH WCAP
	        REPLACE    IVA_PARIVA    WITH WPARIVA
	        REPLACE    IVA_MESE      WITH WMESE
	        REPLACE    IVA_NUMDOC    WITH WNUMDOC 
            REPLACE    IVA_CODAGE    WITH WCCAGE 
            REPLACE    IVA_VALUTA    WITH WVALUTA
	        REPLACE    IVA_CAMBIO    WITH WCAMBIO
            IF NOTAC = 'S'  
	           REPLACE    IVA_FATNOT    WITH 'N'
	           XXX_FATNOT = 'N'
	        ELSE
	           REPLACE    IVA_FATNOT    WITH 'F'
	           XXX_FATNOT = 'F'
	        ENDIF  
		    IF FAT = 'C'   && CORRISPETTIVI
		       REPLACE    IVA_FATNOT    WITH 'C'
	           XXX_FATNOT = 'C'
		    ENDIF  
            REPLACE    IVA_DESIVA     WITH DES_IVES
	        REPLACE    IVA_ALIQUO     WITH VAL(ALIQ)
   	  	    IMPONIES = 	((100 * IMPOSTA) /  VAL(ALIQ)) * -1  && RIOTTIENE L'IMPONIBILE
  	        REPLACE    IVA_IMPONI     WITH IMPONIES
	        REPLACE    IVA_TOTALE     WITH IMPONIES
	        REPLACE    IVA_IMPOST     WITH 0
	        REPLACE    IVA_CODIVA     WITH COD_IVAES
		    REPLACE    IVA_BOLLATOIVA WITH WBOLLATOIVA
         ENDIF
         
         ** RECORD TOTALE 
         *IF CEE = "E" OR CEE = 'R' 
         IF CEE = 'E' OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017
            x_tipo = "ito_clifor = 'E'"
            IF CEE = 'R'
            	x_tipo = "ito_clifor = 'R'"
            ENDIF
            **=> ERASMO - INIZIO 18/12/2017
            IF CEE = 'A'
            	x_tipo = "ito_clifor = 'A'"
            ENDIF
            **=> ERASMO - FINE 18/12/2017
         ELSE
            x_tipo = "ito_clifor = 'C'"
         ENDIF
 
	     IF PUB_NFATDIFFERITA
			IF WBOLLATOIVA = "D"
	            x_tipo = "ito_clifor = 'D'"			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
			ENDIF
 		 ENDIF	
		 
         x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
         x_anno = "ito_anno = '" + PUB_ANNO + "'"
         x_mese = "ito_mese = '" + WMESE + "'"
         x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
         x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
         CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
         IF !ExecRW(CSQL,"u_iva_to","R")
            RETURN (.f.)
         ENDIF 
         SELECT U_IVA_TO
         GO TOP
         IF !EOF()
            DO IVA_REP  
         ELSE
            APPEND BLANK
            DO IVA_INS
         ENDIF 
         IF !ExecRW(cSql,"U_IVA_TO","W")
            return(.f.)
         ENDIF
    	 
    	 **  RECORD TOTALE PER GESTIONE IMPONIBILE ESENTE SE VENDITA PUBBLICITARIA
		 IF IMPONIES <> 0   
            IMPONIBILE = IMPONIES 
	        IMPOSTA    = 0 
			COD_IVA    = COD_IVAES
   		    DES_IVA    = DES_IVES
            *IF CEE = "E" OR CEE = 'R' 
            IF CEE = 'E' OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017
               x_tipo = "ito_clifor = 'E'"
               IF CEE = 'R' 
	               x_tipo = "ito_clifor = 'R'"
               ENDIF
               **=> ERASMO - INIZIO 18/12/2017
               IF CEE = 'A'
	               x_tipo = "ito_clifor = 'A'"
               ENDIF
               **=> ERASMO - FINE 18/12/2017
            ELSE
               x_tipo = "ito_clifor = 'C'"
            ENDIF
            x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
            x_anno = "ito_anno = '" + PUB_ANNO + "'"
            x_mese = "ito_mese = '" + WMESE + "'"
            x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
            x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
            x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
            CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
            IF !ExecRW(CSQL,"u_iva_to","R")
               RETURN (.f.)
            ENDIF 
            SELECT U_IVA_TO
            GO TOP
            IF !EOF()
               DO IVA_REP  
            ELSE
               APPEND BLANK
               DO IVA_INS
            ENDIF 
            IF !ExecRW(cSql,"U_IVA_TO","W")
               return(.f.)
            ENDIF
 		 ENDIF
 		 
 		 **  RECORD TOTALE PER GESTIONE IMPONIBILE ESENTE SE VENDITA PUBBLICITARIA 
		 IF IMPONIE2 <> 0   
	        IMPONIBILE = IMPONIE2 
	        IMPOSTA    = 0 
			COD_IVA    = COD_IVAES
   		    DES_IVA    = DES_IVES
            *IF CEE = "E" OR CEE = 'R' 
            IF CEE = 'E' OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017
               x_tipo = "ito_clifor = 'E'"
               IF CEE = 'R' 
	               x_tipo = "ito_clifor = 'R'"
               ENDIF
               **=> ERASMO - INIZIO 18/12/2017
               IF CEE = 'A'
	               x_tipo = "ito_clifor = 'A'"
               ENDIF
               **=> ERASMO - FINE 18/12/2017
            ELSE
               x_tipo = "ito_clifor = 'C'"
            ENDIF
            x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
            x_anno = "ito_anno = '" + PUB_ANNO + "'"
            x_mese = "ito_mese = '" + WMESE + "'"
            x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
            x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
            x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
            CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
            IF !ExecRW(CSQL,"u_iva_to","R")
               RETURN (.f.)
            ENDIF 
            SELECT U_IVA_TO
            GO TOP
            IF !EOF()
               DO IVA_REP  
            ELSE
               APPEND BLANK
               DO IVA_INS
            ENDIF 
            IF !ExecRW(cSql,"U_IVA_TO","W")
               return(.f.)
            ENDIF
  		 ENDIF
 		  		 
 		 SELECT MOV_CONT
		 SKIP +1
	  
	  ENDDO
   
   ELSE
   
      WAIT WINDOWS "Registrazione prima nota clienti n. " + _NREGIS + " errata"
   
   ENDIF 
   
   SELECT IVA
   *IF CEE = "E" OR CEE = 'R' 
   IF CEE = 'E' OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017
      REPLACE MOV_CONTO WITH WCODF && RIPRISTINA CODICE FORNITORE PER ELABORAZIONE SUCCESSIVA ACQUISTI
   ENDIF
   
   SKIP +1

ENDDO  



RETURN


***********************************************************************************************
PROCEDURE IVAACQUI    
***********************************************************************************************
* GESTIONE IMPOSTE INDEDUCIBILI AL 100%
* GESTIONE IMPOSTE INDEDUCIBILI AL n%
* GESTIONE IMPOSTE BOLLE DOGANALI

*==>>> ANNULLO DEL BOLLATO PRECEDENTE 

x_soci = "ivf_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ivf_anno = '" + ANNODAL + "'"
x_mese = "ivf_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese
CSQL   = "delete from u_ivf_cl where " + x_cond
IF !ExecCommand(CSQL,"U_IVF_CL")
   RETURN (.f.)
ENDIF 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNODAL + "'"
x_mese = "ito_mese = '" + MESEDAL + "'"
**x_tipo = "(ito_clifor = 'F' or ito_clifor = 'E' or ito_clifor = 'R')"    && CANCELLO SOLO I RECORD CON ITO_CLIFOR = 'F'
x_tipo = "(ito_clifor = 'F' or ito_clifor = 'E' or ito_clifor = 'R' or ito_clifor = 'A')"  && ERASMO - 18/12/2017
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_tipo
CSQL   = "delete from u_iva_to where " + x_cond
IF !ExecCommand(CSQL,"U_IVA_TO")
   RETURN (.f.)
ENDIF 



CREATE CURSOR SOLOUNFOR (SOL_CODSOC C(02), SOL_ANNO C(04), SOL_NUMPRO C(13))
INDEX ON SOL_CODSOC + SOL_ANNO + SOL_NUMPRO TAG I_UNFOR ADDITIVE

**=> ERASMO/SERGIO INIZIO - 01/08/2017
RELEASE __MOV_NUMPRO__
PUBLIC __MOV_NUMPRO__
__MOV_NUMPRO__ = ""
**=> ERASMO/SERGIO FINE - 01/08/2017

SELECT IVA
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

*!*	   IF MOV_NREGIS = '225'
*!*	      SET STEP ON 
*!*	   ENDIF

   VNUMPRT = VAL(SUBSTR(MOV_NPROT,1,6))
   NREG    = MOV_NUMPRO
   ANNO    = MOV_ANNO
   WTOP    = MOV_TOP
   WCONTO  = MOV_CONTO
   __MOV_NUMPRO__ = MOV_NUMPRO  && ERASMO/SERGIO - 01/08/2017

*!*	  PER FATTURE CON ACCONTI SCARTA I MOVIMENTI RELATIVI AI PAGAMENTI AGGANCIATI
   IF MOV_NOIVA = 'S'			
      SKIP +1
      LOOP
   ENDIF
 
   IF !VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"FO")
      SKIP +1
      LOOP
   ENDIF

   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      NOTAC = SUBSTR(LIBERA,11,1) 
      FAT   = SUBSTR(LIBERA,2,1)
      CEE   = SUBSTR(LIBERA,23,1)
   ELSE
      NOTAC  = SPACE(1)
      FAT    = SPACE(1)
      CEE    = SPACE(1)
   ENDIF

   IF FAT <> 'S'   && SALTA I TOP NON FATTURA
      SELECT IVA 
      SKIP +1
      LOOP
   ENDIF
 
   *===>>> ACCESSO AI MOVIMENTI CONTABILI PER ELABORARE I RECORDS IVA 
   SELECT IVA 
   _NUMPRO     = MOV_NUMPRO
   _NREGIS     = MOV_NREGIS
   WCODCLI     = MOV_CONTO
   WTOP        = MOV_TOP
   WCOD        = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
   WCODCLI     = WCOD
   
   x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "for_codcli = '" + ALLTRIM(WCOD) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
   IF !ExecCommand(cSql,"u_for_an")
      return(.f.)
   ENDIF
   SELECT u_for_an
   GO TOP
   IF !EOF()
      WRAGSOC   = FOR_RAGSOC
      WINDIRI   = FOR_INDIR
      WLOCALI   = FOR_LOCALI
      WCAP      = FOR_CAP
      WPARIVA   = FOR_PARIVA
      WCLICEE   = FOR_CLICEE
   ELSE
      *WRAGSOC   = SPACE(40)
      WRAGSOC   = "*ANAGR.FOR. " + ALLTRIM(WCODCLI) + " INESISTENTE*"  && ERASMO - 28/07/2017
      WINDIRI   = SPACE(40)
      WLOCALI   = SPACE(40)
      WCAP      = SPACE(5)
      WPARIVA   = SPACE(16)  
      WCLICEE   = SPACE(10)
   ENDIF

   IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
   ELSE
	   *IF CEE = 'E' OR CEE = 'R' && FATTURA ACQUISTO CEE o per iva reverse change PRELEVA IL CODICE CLIENTE CEE DA ANAGRAFICA DEL FORNITORE
	   IF CEE = 'E' OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017
	      SELECT IVA
	      IF EMPTY(WCLICEE)
	         SKIP +1
	         LOOP
	      ENDIF
	   ENDIF
   ENDIF

   
   *=> Dal momento che in una registrazione contabile possono esserci 2 o più fornitori, per evitare che si riporti
   *   più volte l'imposta, si deve verificare che la registrazione in esame NON sia già stata elaborata.
   SELECT SOLOUNFOR
   SET ORDER TO I_UNFOR
   SEEK PUB_CODSOC + PUB_ANNO + _NUMPRO
   IF FOUND()
      SELECT IVA
      SKIP +1
      LOOP
   ELSE
      APPEND BLANK
      REPLACE SOL_CODSOC WITH PUB_CODSOC
      REPLACE SOL_ANNO   WITH PUB_ANNO
      REPLACE SOL_NUMPRO WITH _NUMPRO
   ENDIF
   
   
   WAIT WINDOWS "Fattura fornitore elaborata protocollo n. " + STR(VNUMPRT,6,0) + " registrazione : " + _NREGIS  NOWAIT

   x_soci = "mov_soc = '" + PUB_CODSOC + "'"
   x_anno = "mov_anno = '" + PUB_ANNO + "'"
   x_npro = "mov_numpro = '" + _NUMPRO + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_npro
   cSql="SELECT * FROM mov_cont WHERE " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
   IF !ExecCommand(cSql,"MOV_CONT")
      return(.f.)
   ENDIF
   SELECT MOV_CONT
   GO TOP
   OK_CONTA = .T. 

   IF !EOF()

	  DO WHILE .T.
	   
	     IF EOF()
	        EXIT
	     ENDIF
	 
	 	 IF DELETED()
			SKIP +1
			LOOP
		 ENDIF
 	
         COD_IVA     = MOV_IVA
    
         v_seek	  = 'IVA'+ALLTRIM(COD_IVA)     
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
			TIPOIVA  	=SUBSTR(LIBERA,100,1)
			PERIVAI   	=VAL(SUBSTR(LIBERA,110,3))
			PERIVA		=VAL(SUBSTR(LIBERA,1,3))
         ELSE
			TIPOIVA  	=SPACE(01)
			PERIVAI   	=0
			PERIVA      =0
         ENDIF
    
         SELECT MOV_CONT
 		 XXCONTO=MOV_CONTO

         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + PUB_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(XXCONTO) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(cSql,"cur_conti")
            return(.f.)  
         ENDIF
         SELECT cur_conti
         GO TOP
		 IF !EOF()
		    XXTIPOCO=CON_TIPOCO
	     ELSE
	        RIT=MSGBOX('Non esiste il conto '+XXCONTO+' sul piano dei conti','ATTENZIONE',31)
		    XXTIPOCO='I'
	     ENDIF
	
	     IF XXTIPOCO='I'       && SCARTA RECORD IVA
            SELECT MOV_CONT
		    SKIP +1
		    LOOP
		 ENDIF  
    
         SELECT MOV_CONT
 	 	 IF (MOV_IVA <> 'NO') .AND. (CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) <> 0)
		 ELSE
		    IF MOV_IVA = 'NO'  
		       IF CAMBIO(MOV_VALUTA,MOV_IMPORT,MOV_CAMBIO) = 0  
	              SELECT MOV_CONT
		 		  SKIP +1
				  LOOP
			   ELSE	
			      ***    GESTIONE REGISTRAZIONE DI SOLA IVA DA CONSIDERARE
			   ENDIF		
  	        ENDIF
		    IF TIPOIVA = "I"     && TRATTA IVA INDEDUCIBILE AL 100 % SOLO RECORD CON IMPONIBILE
			   IF PERIVAI = 100
			      IF CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) = 0
		           	 SELECT MOV_CONT
			 		 SKIP +1
					 LOOP
			      ENDIF
			   ELSE
	          	  SELECT MOV_CONT
		 		  SKIP +1
				  LOOP
			   ENDIF
  		    ENDIF
 		 ENDIF
    
         COD_IVA     = MOV_IVA
         ** RIOTTIENE IL CODICE IVA  PER REGISTRAZIONE DI SOLA IVA BOLLE DOGANALI
	     IF MOV_IVA = 'NO'  
		    IF CAMBIO(MOV_VALUTA,MOV_IMPORT,MOV_CAMBIO) > 0  
		 	   *COD_IVA = "BD2"
				**=> ERASMO/FABIANO - INIZIO 22/02/2018
				*** LA RICERCA DEVE ESSERE FATTA PER ALIQUOTA RICALCOLATA, SUI CODICI IVA DEDICATI ALLA GESTIONE DELLE BOLLE DOGANALI (BD1 / BD2 / BD3 - ...)
				SELECT MOV_CONT
				XTOTDOC = MOV_IMPORT + MOV_IMP      && IMPONIBILE + IMPOSTA
				COD_IV  = ROUND(((XTOTDOC / MOV_IMPORT) * 100) - 100,0)
				COD_IVA = ""
				IF !ExecCommand("select * from para where codice like 'IVABD%' and SUBSTRING(LIBERA,1,3) = '" + PADL(ALLTRIM(STR(COD_IV,3,0)),3,'0') + "'","TMP_IVA_PARA")
				   RETURN
				ENDIF
				SELECT TMP_IVA_PARA
				GO TOP
				IF EOF()
					COD_IVA = "BD2"
				ELSE
					COD_IVA = SUBSTR(CODICE,4,3)
				ENDIF
				SELECT MOV_CONT
				**=> ERASMO/FABIANO - FINE 22/02/2018
			ENDIF
         ENDIF
    
         v_seek	  = 'IVA'+ALLTRIM(COD_IVA)     
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            DES_IVA   = SUBSTR(DESCRI,1,30)
            ALIQ      = SUBSTR(LIBERA,1,3)
            NO_IVAREVERSE = NOIVAREVERSE	&& ERASMO/FABIANO - 29/12/2017
         ELSE
            DES_IVA   = SPACE(30)
            ALIQ      = SPACE(3)
            NO_IVAREVERSE = ""				&& ERASMO/FABIANO - 29/12/2017
         ENDIF
   
         SELECT MOV_CONT
  	     ** 2015/06/30 FABIANO GESTIONE ANTICIPI CON CAMBIO SEGNO FORNITORI
	     IF   MOV_ANT_CAMB_SEGNO
	          REPLACE  MOV_IMP    WITH MOV_IMP    * -1
	          REPLACE  MOV_IMPOST WITH MOV_IMPOST * -1
	     ENDIF
  	     ** 2015/06/30 FABIANO GESTIONE ANTICIPI CON CAMBIO SEGNO FORNITORI
                         
         
         WTOP		 = MOV_TOP
         WNUMPRO     = MOV_NUMPRO
         WNREG       = MOV_NREGIS
         WNPART      = MOV_NPART
         WNPROG      = "000"
         WDTREG      = MOV_DTREG
         WDTFAT      = MOV_DTDOC
         WNUMFAT     = MOV_NDOC
         WNUMORI     = MOV_NDOC
         WTIPFAT     = MOV_TOP
         WTOTIM      = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
         WTIMPOS     = CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
	 	 WIVA 		 = MOV_IVA
	 	 WIMPORT	 = CAMBIO(MOV_VALUTA,MOV_IMPORT,MOV_CAMBIO)
		 WVALUTA 	 = MOV_VALUTA
		 WCAMBIO	 = MOV_CAMBIO
	
	 	 IF TIPOIVA = "I"     && TRATTA IVA INDEDUCIBILE AL 100 %
			IF PERIVAI = 100
			   IVX       = PERIVA+100
			   _VALDOC   = MOV_VALUTA
 	           _XTOTIM    = CAMBIO(MOV_VALUTA,MOV_IMP+MOV_IMPOST,MOV_CAMBIO)
			   _XTIMPOS   = CAMBIO(MOV_VALUTA,MOV_IMP+MOV_IMPOST,MOV_CAMBIO)
			   IF PUB_VALRIF = "ITL" .OR. _VALDOC = "LIT"   && ARROTONDA SULLA BASE DELLA DIFFERENZA
			      WTOTIM    = ROUND(((_XTOTIM * 100) / IVX),0) 
				  WTIMPOS   = ROUND((_XTIMPOS - WTOTIM),0)
			   ELSE
			      WTOTIM    = ROUND(((_XTOTIM * 100) / IVX),2) 
			      WTIMPOS   = ROUND((_XTIMPOS - WTOTIM),2)
			   ENDIF
			   IF PUB_VALRIF = "ITL" .OR. _VALDOC = "LIT"   && ARROTONDA SULLA BASE DELLA DIFFERENZA
				  IF WTIMPOS > INT(WTIMPOS)
					 WTIMPOS   = INT(WTIMPOS) + 1
				  ENDIF
		    	  WTOTIM    = INT(WTOTIM) 
			   ENDIF
            ENDIF
		 ENDIF
 	
 	     IF MOV_IVA = 'NO'    && TRATTA REGISTRAZIONE DI SOLA IVA BOLLE DOGANALI
		    IF CAMBIO(MOV_VALUTA,MOV_IMPORT,MOV_CAMBIO) > 0  
		       WTOTIM      = CAMBIO(MOV_VALUTA,MOV_IMPORT,MOV_CAMBIO)
		       WTIMPOS     = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
			ENDIF
		 ENDIF
    
         WFATT       = WTOTIM+WTIMPOS
         WMESE       = SUBSTR(MOV_DTREG,6,2) 
         WFR         = MOV_FATRI
         WCODPAG     = MOV_MODPAG
         IMPONIBILE  = WTOTIM
         IMPOSTA     = WTIMPOS
         TOTALE      = WFATT
    
         v_seek	  = 'TOP'+ALLTRIM(WTOP) 
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            NOTAC = SUBSTR(LIBERA,11,1) 
            FAT   = SUBSTR(LIBERA,2,1)
		    CEEF  = SUBSTR(LIBERA,23,1)
         ELSE
            NOTAC = SPACE(1)
            FAT   = SPACE(1)
            CEEF  = SPACE(1)
         ENDIF
 	
        IF NOTAC = 'S'  
            IF OK_CONTA           
                OK_CONTA = .F.           
		 		 ___CTF_NC_FOR = ___CTF_NC_FOR + 1  	
			ENDIF
		ELSE
            IF OK_CONTA           
                OK_CONTA = .F.     
                IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
				 	___CTF_FOR = ___CTF_FOR + 1  	
                ELSE
					*IF CEEF = "E" OR CEEF = 'R'
					IF CEEF = "E" OR CEEF = 'R' OR CEEF = 'A'  && ERASMO - 18/12/2017
						 ___CTF_FOR_CEE=___CTF_FOR_CEE +1
					ELSE
				 		 ___CTF_FOR = ___CTF_FOR + 1  	
					ENDIF
                ENDIF 
			ENDIF
		ENDIF 	
 
 	
 		 SELECT MOV_CONT
		 IF TIPOIVA = "I"     && TRATTA IVA INDEDUCIBILE AL N %
			IF PERIVAI <> 100
	           IMPONIBILE  = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
		       IMPOSTA     = CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
		       TOTALE      = CAMBIO(MOV_VALUTA,MOV_IMP+MOV_IMPOST,MOV_CAMBIO)
		       WFATT       = CAMBIO(MOV_VALUTA,MOV_IMP+MOV_IMPOST,MOV_CAMBIO)
  		       DO IVAFORES	&&  GESTIONE IVA IMPONIBILE AL N% 
			   SELECT MOV_CONT
			   SKIP +1
			   LOOP
			ENDIF
		 ENDIF
    
         ** === > AGGIORNA  ARCHIVI IVA (DETTAGLI / TOTALE)
         SELECT CU_IVF_CL
	     APPEND BLANK
	     REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
         REPLACE    IVF_TOP		  WITH WTOP 
         REPLACE    IVF_CHIAVE    WITH VNUMPRT 
         REPLACE    IVF_CODSOC    WITH PUB_CODSOC
         REPLACE    IVF_ANNO      WITH PUB_ANNO
         REPLACE    IVF_CODCLI    WITH WCODCLI 
         REPLACE    IVF_RAGSOC    WITH WRAGSOC 
         REPLACE    IVF_DTCREA    WITH WDTREG
         REPLACE    IVF_DTFATT    WITH WDTFAT
         REPLACE    IVF_NUMFAT    WITH WNUMFAT 
         REPLACE    IVF_INDIRI    WITH WINDIRI
         REPLACE    IVF_LOCALI    WITH WLOCALI  
         REPLACE    IVF_CAP       WITH WCAP
         REPLACE    IVF_PARIVA    WITH WPARIVA
         REPLACE    IVF_MESE      WITH WMESE
         REPLACE    IVF_TOTALE    WITH WFATT  
         REPLACE    IVF_FATRI     WITH WFR 
         REPLACE    IVF_IND100    WITH " "    && GESTIONE IVA INDEDUCIBILE AL 100%
         REPLACE    IVF_VALUTA    WITH WVALUTA
         REPLACE    IVF_CAMBIO    WITH WCAMBIO
         REPLACE    IVF_NUMORI    WITH WNUMORI 
         
		 REPLACE    IVF_DEDUCIBILE	WITH .F.	&& IVA INDEDUCIBILE NON ENTRA NEL CALCOLO DELLE IMPOSTE
		 __DEDUCIBILE 				=    .F.	&& IVA INDEDUCIBILE NON ENTRA NEL CALCOLO DELLE IMPOSTE
 
         
 		 IF TIPOIVA = "I"     && TRATTA IVA INDEDUCIBILE AL 100 % SOLO RECORD CON IMPONIBILE
			IF PERIVAI = 100
  		       REPLACE    IVF_IND100     WITH "S"
			ENDIF    	
		 ENDIF
         IF WIVA = 'NO'    && TRATTA REGISTRAZIONE DI SOLA IVA BOLLE DOGANALI
		    IF WIMPORT > 0  
	           REPLACE    IVF_BDOG     WITH .T. 
			ENDIF
	 	 ENDIF	
         IF NOTAC = 'S'  
            REPLACE    IVF_FATNOT    WITH 'N'
            XXX_FATNOT = 'N'
         ELSE
            REPLACE    IVF_FATNOT    WITH 'F'
            XXX_FATNOT = 'F'
         ENDIF  
         REPLACE    IVF_DESIVA    WITH DES_IVA
         REPLACE    IVF_ALIQUO    WITH VAL(ALIQ) 
         REPLACE    IVF_IMPONI    WITH IMPONIBILE    
         REPLACE    IVF_IMPOST    WITH IMPOSTA
         REPLACE    IVF_CODIVA    WITH COD_IVA

*!*	IF COD_IVA = 'FC'
*!*	SET STEP ON 
*!*	ENDIF


         x_tipo = "ito_clifor = 'F'"

*!*	         IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
*!*	         ELSE
*!*		         IF CEE = "E"
*!*		            x_tipo = "ito_clifor = 'E'"
*!*		         ENDIF
*!*			 ENDIF
		 
			IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
			   x_tipo = "ito_clifor = 'F'"
			ELSE
				*IF CEE = "E" OR CEE = 'R' 
				IF CEE = "E" OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017
				   x_tipo = "ito_clifor = 'E'"

**=> ERASMO/FABIANO - INIZIO 03/08/2015   
*!*					   IF CEE = 'R'
*!*						   x_tipo = "ito_clifor = 'R'"
*!*					   ENDIF

						IF CEE = 'R'

							**=> ERASMO/FABIANO - INIZIO 03/08/2015
							*** SE IVA IN ESENZIONE (ALIQUOTA ZERO) QUESTO CODICE IVA NON PREVEDE COMPENSAZIONE CON AUTOFATTURA REVERSE CHARGE
							IF PERCENTUALE_IVA(IVF_CODIVA)> 0
								x_tipo = "ito_clifor = 'R'"
							ELSE
							    x_tipo = "ito_clifor = 'F'" && ERASMO/FABIANO - 03/08/2015  
							ENDIF
							**=> ERASMO/FABIANO - FINE 03/08/2015
							
							**=> ERASMO/FABIANO - INIZIO 29/12/2017
							*** TOTALI NON DI TIPO REVERSE SE TOP REVERSE CHARGE MA IVA CONFIGURATA CON FLAG "Esclude questo codice Iva ai fini delle compensazioni nel bollato Iva per Reverse Charge" = 'S'
							IF NO_IVAREVERSE = 'S'
								x_tipo = "ito_clifor = 'F'"
							ENDIF
							**=> ERASMO/FABIANO - FINE 29/12/2017

					   ENDIF
**=> ERASMO/FABIANO - FINE 03/08/2015 

					**=> ERASMO - INIZIO 18/12/2017
					IF CEE = 'A'
						x_tipo = "ito_clifor = 'A'"
					ENDIF
					**=> ERASMO - FINE 18/12/2017

				ELSE
				   x_tipo = "ito_clifor = 'F'"
				ENDIF
			ENDIF
		          
         x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
         x_anno = "ito_anno = '" + PUB_ANNO + "'"
         x_mese = "ito_mese = '" + WMESE + "'"
         x_codi = "ito_codiva = '" + ALLTRIM(IVF_CODIVA) + "'"
         x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
         x_fatt1 = "ito_clifor = 'F'"

         x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt 
         CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
         IF !ExecRW(CSQL,"u_iva_to","R")
            RETURN (.f.)
         ENDIF 
         SELECT U_IVA_TO
         GO TOP
         IF !EOF()
            DO IVF_REP  
         ELSE
            APPEND BLANK
            DO IVF_INS
         ENDIF 
         IF !ExecRW(cSql,"U_IVA_TO","W")
            return(.f.)
         ENDIF
     
   
     	 SELECT MOV_CONT
		 SKIP +1
 	
 	  ENDDO
   
   ELSE
   
      WAIT WINDOWS "Registrazione prima nota n. : " + _NREGIS + " ERRATA"
   
   ENDIF
   
   SELECT IVA
   SKIP +1

ENDDO  

RETURN



***********************************************************************************************
PROCEDURE IVAVENSO		&& GESTIONE IVA CLIENTI IN SOSPENSIONE
***********************************************************************************************
*???
* GESTIONE IMPOSTE ESENTI
* CREAZIONE AUTOMATICA RECORD DI ESENZIONE NEL CASO IN CUI ESISTE ARTICOLO PUBBLICITARIO
* CREAZIONE AUTOMATICA RECORD ESENZ. SE ARTICOLO PUBBLICITARIO MISTO AD ARTICOLI DI VENDITA NORMALE

*==>>> ANNULLO DEL BOLLATO PRECEDENTE 
x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = '" + ANNODAL + "'"
x_mese = "iva_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese
CSQL   = "delete from U_IVA_CS where " + x_cond
IF !ExecCommand(CSQL,"U_IVA_CS")
   RETURN (.f.)
ENDIF 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNODAL + "'"
x_mese = "ito_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese 
CSQL   = "delete from U_IVA_TS where " + x_cond
IF !ExecCommand(CSQL,"U_IVA_TS")
   RETURN (.f.)
ENDIF 
*==>>> ANNULLO DEL BOLLATO PRECEDENTE 

FATTURE_ELETTRONICHE_PA = ""

DATA_DA = RIBALTA2(DATADAL)
DATA_A  = RIBALTA2(DATAAL)

**=> ERASMO/SERGIO INIZIO - 01/08/2017
RELEASE __MOV_NUMPRO__
PUBLIC __MOV_NUMPRO__
__MOV_NUMPRO__ = ""
**=> ERASMO/SERGIO FINE - 01/08/2017

RELEASE _STO_TRATTANDO_UN_CLIENTE 
PUBLIC  _STO_TRATTANDO_UN_CLIENTE 
_STO_TRATTANDO_UN_CLIENTE = .F.

CTRELAB = 0
CT = 0

CREATE CURSOR SOLOUNCLI (SOL_CODSOC C(02), SOL_ANNO C(04), SOL_NUMPRO C(13))
INDEX ON SOL_CODSOC + SOL_ANNO + SOL_NUMPRO TAG I_UNCLI ADDITIVE



SELECT IVA
SET ORDER TO I_IVA
GO TOP



DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF


   
   IF OK_PROTCL < 0    && ASSUME IL NUMERO DI FATTURA ORIGINALE
	  VNUMPRT	= VAL(SUBSTR(MOV_NPROT,1,6))        && CONTIENE IL NUMERO DI PROTOCOLLO
   ELSE
	  VNUMPRT	= VAL(SUBSTR(MOV_NDOC,1,6))        && CONTIENE IL NUMERO DI PROTOCOLLO
   ENDIF 

   NREG   		= MOV_NUMPRO
   ANNO   		= MOV_ANNO
   WTOP   		= MOV_TOP
   WCONTO 		= MOV_CONTO
   WCODCLI  	= MOV_CONTO

   _MOV_CONTO   = MOV_CONTO
   _MOV_DTREG   = MOV_DTREG   
   _MOV_NREGIS  = MOV_NREGIS   
   _MOV_NPROT   = MOV_NPROT  
   _MOV_NDOC    = MOV_NDOC  
   _MOV_DTDOC   = MOV_DTDOC    
   
   __MOV_NUMPRO__ = MOV_NUMPRO  && ERASMO/SERGIO - 01/08/2017


   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   	= SUBSTR(LIBERA,2,1)
      NOTAC 	= SUBSTR(LIBERA,11,1) 
	  VER_CONTO = SUBSTR(LIBERA,12,1)
      CEE   	= SUBSTR(LIBERA,23,1)
      VENSOSP  	= SUBSTR(LIBERA,61,1)
   ELSE
      FAT    	= SPACE(1)
      NOTAC  	= SPACE(1)
      VER_CONTO = SPACE(1)
      CEE    	= SPACE(1)
      VENSOSP  	= SPACE(1)
   ENDIF


   IF FAT = 'S' OR FAT = 'C' && SALTA I TOP NON FATTURA / CORRISPETTIVI
   ELSE
      SELECT IVA 
      SKIP +1
      LOOP
   ENDIF


   IF VENSOSP = 'S'  && TRATTA SOLO LE VENDITE IN SOSPENSIONE IVA
   ELSE
      SELECT IVA 
      SKIP +1
      LOOP
   ENDIF



	_MOV_RAGSOC = ""

   IF CEE = 'E' OR CEE = 'R' && FATTURA ACQUISTO CEE o per iva reverse change PRELEVA IL CODICE CLIENTE CEE DA ANAGRAFICA DEL FORNITORE
	  WCOD   = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
	  WCODF  = WCODCLI
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + ALLTRIM(WCOD) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"u_for_an")
         return(.f.)
      ENDIF
      SELECT u_for_an
      GO TOP
	  IF !EOF()
         WNAZION     = FOR_NAZION
	     WCLICEE     = FOR_CLICEE
	     _MOV_RAGSOC = FOR_RAGSOC
	  ELSE
	     WNAZION     = "ITA"
	     WCLICEE     = WCOD
	     _MOV_RAGSOC = ""
	  ENDIF
	  V_ER=SOTTOGEN(WNAZION)
      IF !V_ER
		 XCC = PUB_CC 
      ELSE
         XCC = CCC 
      ENDIF 
      WCODCLI     = XCC + WCLICEE	&& FORZA CODICE CLIENTE CEE AL POSTO DEL CODICE FORNITORE
      M.MOV_CONTO = WCODCLI
      SELECT IVA
      IF EMPTY(WCLICEE)
         
         DO MANCA_CODICE_CLIENTE_CEE
         
         SELECT IVA
         SKIP +1
         LOOP
      ENDIF
      REPLACE MOV_CONTO WITH M.MOV_CONTO
   
   ENDIF

   SELECT IVA

   DO CASE
   
      CASE MOV_FLG = "C"								&& CORRISPETTIVO DA VENDITA AL BANCO

			   XX_CONTO = MOV_CONTO
			   XX_ANNO  = MOV_ANNO
			   XX_NREGI = MOV_NREGIS  
			   x_soci = "con_soc = '" + PUB_CODSOC + "'"
			   x_anno = "con_anno = '" + XX_ANNO + "'"
			   x_codi = "con_conto = '" + ALLTRIM(XX_CONTO) + "'"
			   x_cond = x_soci + " and " + x_anno + " and " + x_codi
			   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
			   IF !ExecCommand(cSql,"cur_conti")
			      return(.f.)
			   ENDIF
			   SELECT cur_conti
			   GO TOP
			   IF EOF()
				  =MESSAGEBOX("Registrazione non corretta "+XX_NREGI+CHR(13)+"manca conto "+XX_CONTO,16,"*** ATTENZIONE ***") 
				  RETURN
			   ENDIF
		       WRAGSOC   = CON_DESCR
		       WINDIRI   = AQUADATI(4)
		       WLOCALI   = AQUADATI(5)
		       WCAP      = AQUADATI(6)
		       WPARIVA   = AQUADATI(3)
		       WCCAGE    = "001"
		       WNAZION   = "ITA"

 		OTHERWISE
 		
			   WCOD    = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
			   WCODCLI = WCOD
			   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
			   x_codi = "cli_codcli = '" + ALLTRIM(WCOD) + "'"
			   x_cond = x_soci + " and " + x_codi
			   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
			   IF !ExecCommand(cSql,"u_cli_an")
			      return(.f.)
			   ENDIF
			   SELECT U_CLI_AN
			   GO TOP
			   IF !EOF()
			      WRAGSOC   = CLI_RAGSOC
			      WINDIRI   = CLI_INDIR
			      WLOCALI   = CLI_LOCALI
			      WCAP      = CLI_CAP
			      WPARIVA   = CLI_PARIVA
			      WCCAGE    = CLI_AGE
			      WNAZION   = CLI_NAZION
			   ELSE
			      *WRAGSOC   = SPACE(40)
			      WRAGSOC   = "*ANAGR. CLI. " + ALLTRIM(WCODCLI) + " INESISTENTE*"  && ERASMO - 28/07/2017
			      WINDIRI   = SPACE(40)
			      WLOCALI   = SPACE(40)
			      WCAP      = SPACE(5)
			      WPARIVA   = SPACE(16)  
			      WCCAGE    = SPACE(03)
			      WNAZION   = SPACE(03)
			   ENDIF
			   SELECT IVA
			   IF !VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CL")
			      SELECT IVA
			      SKIP +1
			      LOOP
			   ENDIF

   ENDCASE

   CT = CT + 1

   *===>>> ACCESSO AI MOVIMENTI CONTABILI PER ELABORARE I RECORDS IVA 
   SELECT IVA 
   _NUMPRO     	= MOV_NUMPRO
   _NREGIS     	= MOV_NREGIS
   XX_FLG   	= MOV_FLG




   *=> INIZIO - SERGIO 04/05/2006
   *=> Dal momento che in una registrazione contabile possono esserci 2 o più clienti, per evitare che si riporti
   *   più volte l'imposta, si deve verificare che la registrazione in esame NON sia già stata elaborata.
   
   SELECT SOLOUNCLI
   SET ORDER TO I_UNCLI
   SEEK PUB_CODSOC + PUB_ANNO + _NUMPRO
   IF FOUND()
      SELECT IVA
      SKIP +1
      LOOP
   ELSE
      APPEND BLANK
      REPLACE SOL_CODSOC WITH PUB_CODSOC
      REPLACE SOL_ANNO   WITH PUB_ANNO
      REPLACE SOL_NUMPRO WITH _NUMPRO
   ENDIF

   SELECT IVA
   
   *=> FINE - SERGIO 04/05/2006


   
   WAIT WINDOWS "Fattura cliente elaborata n. " + STR(VNUMPRT,6,0) + " registrazione : " + _NREGIS NOWAIT
   WTOP        = MOV_TOP

   x_soci = "mov_soc = '" + PUB_CODSOC + "'"
   x_anno = "mov_anno = '" + PUB_ANNO + "'"
   x_npro = "mov_numpro = '" + _NUMPRO + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_npro
   cSql="SELECT * FROM mov_cont WHERE " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
   IF !ExecCommand(cSql,"MOV_CONT")
      return(.f.)
   ENDIF
   SELECT MOV_CONT
   GO TOP

   OK_CONTA = .T. 
   
   IF !EOF()
	  DO WHILE .T.
	     IF EOF()
            EXIT
         ENDIF
	 	 IF DELETED()
			SKIP +1
			LOOP
		 ENDIF
*!*	 		 * CASO DI VENDITE CON ARTICOLO PUBBLICITARIO FATTE ALL'ESTERO (QUINDI IN ESENZIONE IVA)
*!*			 IF CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) = 0 	.AND. 	CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) = 0
*!*				SKIP +1
*!*				LOOP
*!*			 ENDIF
		 XX_NREGI = MOV_NREGIS
		 XX_CONTO = MOV_CONTO
		 XX_ANNO  = MOV_ANNO
         x_soci = "con_soc = '" + PUB_CODSOC + "'"
         x_anno = "con_anno = '" + XX_ANNO + "'"
         x_codi = "con_conto = '" + ALLTRIM(XX_CONTO) + "'"
         x_cond = x_soci + " and " + x_anno + " and " + x_codi
         Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
         IF !ExecCommand(cSql,"cur_conti")
            return(.f.)  
         ENDIF
         SELECT cur_conti
         GO TOP
		 IF !EOF()
		    XX_TIPOC = CON_TIPOCO
		 ELSE
		    XX_TIPOC = " "
	  	    =MESSAGEBOX("Registrazione non corretta "+XX_NREGI+CHR(13)+"manca conto "+XX_CONTO,16,"*** ATTENZIONE ***") 
	 	    RETURN
 		 ENDIF
		 SELECT MOV_CONT
		 IF XX_TIPOC = "I"    && SCARTA I RECORD IVA
	 		SKIP +1
			LOOP
		 ENDIF
		 IF MOV_IVA = 'NO' 
	 		SKIP +1
			LOOP
         ENDIF
		 IMPONIES  = 0      && IMPONIBILE ESENTE DA IVA
		 IMPONIE2  = 0      && IMPONIBILE ESENTE DA IVA
         COD_IVA   = MOV_IVA
         COD_IVAES = "ES "
         v_seek	  = 'IVA'+COD_IVAES      && VENDITE PUBBLICITARIE (SOLO IVA)
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            DES_IVES   = SUBSTR(DESCRI,1,21)
            ALIQES     = SUBSTR(LIBERA,1,3)
         ELSE
            DES_IVES   = "*************"
            ALIQES     = "20"
         ENDIF
         v_seek	  = 'IVA'+ALLTRIM(COD_IVA)     
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            DES_IVA   = SUBSTR(DESCRI,1,30)
            ALIQ      = SUBSTR(LIBERA,1,3)
         ELSE
            DES_IVA   = SPACE(30)
            ALIQ      = SPACE(3)
         ENDIF
         SELECT MOV_CONT
         WNUMPRO     	= MOV_NUMPRO
         WNREG       	= MOV_NREGIS
         WNPART      	= MOV_NPART
         WNUMDOC     	= ALLTRIM(MOV_NPROT)
         
         IF SUBSTR(WNUMDOC,1,1) = "8"  
          	FATTURE_ELETTRONICHE_PA = "S"		&& IDENTIFICA IL TOTALE DELLE FATTURE ELETTRONICHE PA IN SOSPENSIONE IVA
         ELSE 
            FATTURE_ELETTRONICHE_PA = "" 		&& IDENTIFICA IL TOTALE DI TUTTE LE ALTRE FATTURE ELETTRONICHE PA IN SOSPENSIONE IVA          
         ENDIF         
         
         WNPROG      	= "000"
         WDTREG      	= MOV_DTREG
         WDTFAT      	= MOV_DTDOC
         WNUMFAT     	= MOV_NDOC
         WTIPFAT     	= MOV_TOP
         WMESE       	= SUBSTR(MOV_DTREG,6,2) 
         WFR         	= MOV_FATRI
         WCODPAG     	= MOV_MODPAG
         WTOTIM      	= CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
   		 WBOLLATOIVA  	= MOV_BOLLATOIVA
	 	 IF VAL(ALIQ) = 0		&& ESENZIONE
	        WTIMPOS   = 0
		 ELSE
	        WTIMPOS   = CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
		 ENDIF
         WFATT       = CAMBIO(MOV_VALUTA,MOV_IMP+MOV_IMPOST,MOV_CAMBIO)
         IMPONIBILE  = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
	 	 IF VAL(ALIQ) = 0	&& ESENZIONE
			IMPOSTA     = 0
         ELSE	
        	IMPOSTA     = CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
		 ENDIF
         TOTALE     = CAMBIO(MOV_VALUTA,MOV_IMP+MOV_IMPOST,MOV_CAMBIO)
 	     WVALUTA  	= MOV_VALUTA
	     WCAMBIO  	= MOV_CAMBIO
 		 ** VERIFICA IMPONIBILE : NEL CASO IN CUI ESISTE UN ARTICOLO VENDUTO COME MATERIALE PUBBLICITARIO
		 ** 					   : CHE CONFLUISCE IN IN UN CONTO VENDITA NORMALE
		 OK_ESE    = .F.		
	 	 * SE MOV_IMP <> 0 E MOV_IMPOST = 0 CASO DI IVA IN ESENZIONE
 		 IF OK_ESECLI	.AND.  FAT <> 'C'  			&& VERIFICA SE DEVE VERAMENTE GESTIRE LE ESENZIONI
			IF CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) <> 0 
		  	   IF CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) <> 0
				  IMPO_STA    = CAMBIO(MOV_VALUTA,((IMPONIBILE * VAL(ALIQ)) / 100),MOV_CAMBIO)		
				  IF IMPO_STA <> IMPOSTA
				     NW_IMPOST = IMPOSTA - IMPO_STA
				     IF VAL(ALIQ) = 0
					    NW_IMPONI = 0	   						  && CLIENTE IN ESENZIONE IVA (ESTERO)
				     ELSE
					    NW_IMPONI = NW_IMPOST / (VAL(ALIQ)/100) && IMPONIBILE OMAGGIO
				     ENDIF
				     IMPONIBILE= IMPONIBILE + NW_IMPONI      							 && IMPONIBILE ESATTO 
	    	         TOTALE    = IMPONIBILE + CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)   && RICALCOLO DEL TOTALE   
	        	     WFATT     = IMPONIBILE + CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)   && RICALCOLO DEL TOTALE   
 		             OK_ESE    = .T.
				  ENDIF
			   ENDIF
			ENDIF
		 ENDIF
         IF !EMPTY(MOV_CEE)
            WCCAGE = MOV_CEE
         ENDIF  
         v_seek	  = 'TOP'+ALLTRIM(WTOP)     
         v_chiave = "codice"
         IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
            SELECT CUR_PARA
            NOTAC = SUBSTR(LIBERA,11,1) 
            FAT   = SUBSTR(LIBERA,2,1)
            TMOV  = SUBSTR(LIBERA,33,2)
         ELSE
            NOTAC = SPACE(1)
            FAT   = SPACE(1)
		    TMOV  = SPACE(2)
         ENDIF
         
         
		 IF NOTAC = 'S'  
	 	 	IF OK_CONTA  
			    OK_CONTA = .F. 
		 	 	___CTF_FVS_NC_CLI = ___CTF_FVS_NC_CLI  +  1 
			ENDIF
		 ELSE
	 	 	IF OK_CONTA  
			    OK_CONTA = .F. 
                IF WBOLLATOIVA =  " "
					IF XX_FLG <> "C"						
			 	 		___CTF_FVS_CLI = ___CTF_FVS_CLI  +  1 							
		 	 		ENDIF
				ENDIF
                IF WBOLLATOIVA =  "D"						&& NON SOMMA I CORRISPETTIVI PER VENDITA AL BANCO
		 	 		___CTF_CLI_FVS = ___CTF_CLI_FVS  +  1 
				ENDIF
			ENDIF
		 ENDIF
	     
	     
	     
 		 SELECT MOV_CONT
		 * SE MOV_IMP <> 0 E MOV_IMPOST = 0 CASO DI IVA IN ESENZIONE
		 IF CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) <> 0 
		 	IF CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) = 0
	           IMPONIBILE  = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)
		       IMPOSTA     = CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
		       TOTALE      = CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) + CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO)
			   DO IVACLIES	&&  GESTIONE IVA ESENTE PER CLIENTI
			   SELECT MOV_CONT
			   SKIP +1
			   LOOP
			ENDIF
		 ENDIF
     	 ** === > AGGIORNA  ARCHIVI IVA (DETTAGLI / TOTALE)
     	 ** === > 19/01/2004 NUOVA GESTIONE MATERIALE PUBBLICITARIO------INIZIO
         ___MPUBBLI  = CAMBIO(MOV_VALUTA,MOV_PUBBLI,MOV_CAMBIO)
		 IF	___MPUBBLI = 0 			&& GETIONE NORMALE
     	 ** === > 19/01/2004 NUOVA GESTIONE MATERIALE PUBBLICITARIO------FINE
		    IF FAT = 'C'  
	 		   DO CORRISP     && GESTIONE CORRISPETTIVI
               XXX_FATNOT = 'C'
            ELSE
		       IF NOTAC = 'S'  
		          T_IPO = 'N'
	    	   ELSE
		          T_IPO = 'F'
		       ENDIF  
               x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
               x_anno = "iva_anno = '" + PUB_ANNO + "'"
               x_mese = "iva_mese = '" + WMESE + "'"
               x_chia = "iva_chiave = "  + ALLTRIM(STR(VNUMPRT,6,0))
               x_codi = "iva_codiva = '" + ALLTRIM(COD_IVA) + "'"
               x_fatt = "iva_fatnot = '" + ALLTRIM(T_IPO) + "'"
               x_biva = "iva_bollatoiva = '" + ALLTRIM(WBOLLATOIVA) + "'"
               x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_chia + " and " + x_codi + " and " + x_fatt+ " and " + x_biva
               CSQL   = "select * from U_IVA_CS where " + x_cond + " order by iva_codsoc,iva_anno,iva_mese,iva_chiave,iva_codiva,iva_fatnot" 
               IF !ExecRW(CSQL,"U_IVA_CS","R")
                  RETURN (.f.)
               ENDIF 
  	 	       SELECT U_IVA_CS
  	 	       GO TOP
  	 	       IF EOF()
 			      APPEND BLANK
 			      REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
                  REPLACE    IVA_TOP	   WITH WTOP 
		          REPLACE    IVA_CHIAVE    WITH VNUMPRT 
		          REPLACE    IVA_CODSOC    WITH PUB_CODSOC
		          REPLACE    IVA_ANNO      WITH PUB_ANNO
		          REPLACE    IVA_CODCLI    WITH WCODCLI 
		          REPLACE    IVA_RAGSOC    WITH WRAGSOC 
		          REPLACE    IVA_DTCREA    WITH WDTREG
		          REPLACE    IVA_DTFATT    WITH WDTFAT
		          REPLACE    IVA_NUMFAT    WITH WNUMFAT 
	              IF CEE = "E"   && OR CEE = 'R' 
			         REPLACE    IVA_NUMCEE    WITH WNUMFAT 
			      ENDIF             
 		          REPLACE    IVA_INDIRI    WITH WINDIRI
		          REPLACE    IVA_LOCALI    WITH WLOCALI  
		          REPLACE    IVA_CAP       WITH WCAP
		          REPLACE    IVA_PARIVA    WITH WPARIVA
		          REPLACE    IVA_MESE      WITH WMESE
		          REPLACE    IVA_NUMDOC    WITH TRC(6,ALLTRIM(WNUMDOC))  		&& NUMERO DI FATTURA WNUMDOC 
		          REPLACE    IVA_CODAGE    WITH WCCAGE 
		          REPLACE    IVA_VALUTA    WITH WVALUTA
		          REPLACE    IVA_CAMBIO    WITH WCAMBIO
		          IF NOTAC = 'S'  
		             REPLACE    IVA_FATNOT    WITH 'N'
  	                 XXX_FATNOT = 'N'
		          ELSE
			         REPLACE    IVA_FATNOT    WITH 'F'
  	                 XXX_FATNOT = 'F'
		          ENDIF  
		          
  	              REPLACE    IVA_DESIVA     WITH DES_IVA
		          REPLACE    IVA_ALIQUO     WITH VAL(ALIQ) 
		          REPLACE    IVA_IMPONI     WITH IMPONIBILE    
		          REPLACE    IVA_IMPOST     WITH IMPOSTA
		          REPLACE    IVA_CODIVA     WITH COD_IVA
		          REPLACE    IVA_TOTALE    	WITH WFATT  
				  REPLACE    IVA_BOLLATOIVA WITH WBOLLATOIVA
               ELSE
   	              REPLACE    IVA_IMPONI     WITH IVA_IMPONI + IMPONIBILE    
		          REPLACE    IVA_IMPOST     WITH IVA_IMPOST + IMPOSTA
		          REPLACE    IVA_TOTALE     WITH IVA_TOTALE + WFATT  
		       ENDIF        
               ** CREA MOVIMENTO IMPONIBILE ESENTE NEL CASO DI ARTICOLI PUBB.CHE SONO CONFLUITI NELLE VENDITE
     	       IF OK_ESE		
 	              APPEND BLANK
 	              REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
                  REPLACE    IVA_TOP	   WITH WTOP 
		          REPLACE    IVA_CHIAVE    WITH VNUMPRT 
		          REPLACE    IVA_CODSOC    WITH PUB_CODSOC
		          REPLACE    IVA_ANNO      WITH PUB_ANNO
		          REPLACE    IVA_CODCLI    WITH WCODCLI 
		          REPLACE    IVA_RAGSOC    WITH WRAGSOC 
		          REPLACE    IVA_DTCREA    WITH WDTREG
		          REPLACE    IVA_DTFATT    WITH WDTFAT
		          REPLACE    IVA_NUMFAT    WITH WNUMFAT 
                  IF CEE = "E"  &&  OR CEE = 'R' 
			         REPLACE    IVA_NUMCEE    WITH WNUMFAT 
		  	      ENDIF             
         	      REPLACE    IVA_INDIRI    WITH WINDIRI
		          REPLACE    IVA_LOCALI    WITH WLOCALI  
		          REPLACE    IVA_CAP       WITH WCAP
		          REPLACE    IVA_PARIVA    WITH WPARIVA
		          REPLACE    IVA_MESE      WITH WMESE
		          REPLACE    IVA_NUMDOC    WITH TRC(6,ALLTRIM(WNUMDOC))  		&& NUMERO DI FATTURA WNUMDOC 
	              REPLACE    IVA_CODAGE    WITH WCCAGE 
	              REPLACE    IVA_VALUTA    WITH WVALUTA
		          REPLACE    IVA_CAMBIO    WITH WCAMBIO
			      IF NOTAC = 'S'  
		             REPLACE    IVA_FATNOT    WITH 'N'
  	                 XXX_FATNOT = 'N'
		          ELSE
		             REPLACE    IVA_FATNOT    WITH 'F'
  	                 XXX_FATNOT = 'F'
		          ENDIF  
				  IF FAT = 'C'   && CORRISPETTIVI
		 	         REPLACE    IVA_FATNOT    WITH 'C'
  	                 XXX_FATNOT = 'C'
			      ENDIF  
 		          REPLACE    IVA_DESIVA     WITH DES_IVES
		          REPLACE    IVA_ALIQUO     WITH VAL(ALIQ)
 			      IMPONIE2 = 	NW_IMPONI * -1 && RIOTTIENE L'IMPONIBILE OMAGGIO "FUSO"
 		          REPLACE    IVA_IMPONI     WITH IMPONIE2
		          REPLACE    IVA_TOTALE     WITH IMPONIE2
		          REPLACE    IVA_IMPOST     WITH 0
		          REPLACE    IVA_CODIVA     WITH COD_IVAES
				  REPLACE    IVA_BOLLATOIVA WITH WBOLLATOIVA
	           ENDIF		
               IF !ExecRW(cSql,"U_IVA_CS","W")
                  return(.f.)
               ENDIF
            ENDIF  
         ELSE
            ** GESTIONE VENDITE PUBBLICITARIE (SOLO IVA) 
       	    ** === > 19/01/2004 NUOVA GESTIONE MATERIALE PUBBLICITARIO------INIZIO
            SELECT CU_IVA_CS
            APPEND BLANK
            REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
            REPLACE    IVA_TOP	     WITH WTOP 
	        REPLACE    IVA_CHIAVE    WITH VNUMPRT 
	        REPLACE    IVA_CODSOC    WITH PUB_CODSOC
	        REPLACE    IVA_ANNO      WITH PUB_ANNO
	        REPLACE    IVA_CODCLI    WITH WCODCLI 
	        REPLACE    IVA_RAGSOC    WITH WRAGSOC 
	        REPLACE    IVA_DTCREA    WITH WDTREG
	        REPLACE    IVA_DTFATT    WITH WDTFAT
	        REPLACE    IVA_NUMFAT    WITH WNUMFAT 
            IF CEE = "E"  && OR CEE = 'R' 
	           REPLACE    IVA_NUMCEE    WITH WNUMFAT 
   		    ENDIF             
 	        REPLACE    IVA_INDIRI    WITH WINDIRI
	        REPLACE    IVA_LOCALI    WITH WLOCALI  
	        REPLACE    IVA_CAP       WITH WCAP
	        REPLACE    IVA_PARIVA    WITH WPARIVA
	        REPLACE    IVA_MESE      WITH WMESE
	        REPLACE    IVA_NUMDOC    WITH TRC(6,ALLTRIM(WNUMDOC))  		&& NUMERO DI FATTURA WNUMDOC 
            REPLACE    IVA_CODAGE    WITH WCCAGE 	      
            REPLACE    IVA_VALUTA    WITH WVALUTA
	        REPLACE    IVA_CAMBIO    WITH WCAMBIO
 	        IF NOTAC = 'S'  
	           REPLACE    IVA_FATNOT    WITH 'N'
               XXX_FATNOT = 'N'
	        ELSE
	           REPLACE    IVA_FATNOT    WITH 'F'
               XXX_FATNOT = 'F'
	        ENDIF  
            IF FAT = 'C'  
	           REPLACE    IVA_FATNOT    WITH 'C'
               XXX_FATNOT = 'C'
	        ENDIF  
  	        REPLACE    IVA_DESIVA    WITH DES_IVA
	        REPLACE    IVA_ALIQUO    WITH VAL(ALIQ) 
	        IMPONIBILE = (100 * IMPOSTA) /  VAL(ALIQ) 
  	        REPLACE    IVA_IMPONI    WITH IMPONIBILE
	        REPLACE    IVA_IMPOST    WITH IMPOSTA
	        REPLACE    IVA_TOTALE    WITH IMPONIBILE + IMPOSTA
 	        REPLACE    IVA_CODIVA    WITH COD_IVA
            ** CREA MOVIMENTO IMPONIBILE ESENTE
            APPEND BLANK
            REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
            REPLACE    IVA_TOP	     WITH WTOP 
	        REPLACE    IVA_CHIAVE    WITH VNUMPRT 
	        REPLACE    IVA_CODSOC    WITH PUB_CODSOC
	        REPLACE    IVA_ANNO      WITH PUB_ANNO
	        REPLACE    IVA_CODCLI    WITH WCODCLI 
	        REPLACE    IVA_RAGSOC    WITH WRAGSOC 
	        REPLACE    IVA_DTCREA    WITH WDTREG
	        REPLACE    IVA_DTFATT    WITH WDTFAT
	        REPLACE    IVA_NUMFAT    WITH WNUMFAT 
            IF CEE = "E"  && OR CEE = 'R' 
	           REPLACE    IVA_NUMCEE    WITH WNUMFAT 
			ENDIF             
	        REPLACE    IVA_INDIRI    WITH WINDIRI
	        REPLACE    IVA_LOCALI    WITH WLOCALI  
	        REPLACE    IVA_CAP       WITH WCAP
	        REPLACE    IVA_PARIVA    WITH WPARIVA
	        REPLACE    IVA_MESE      WITH WMESE
	        REPLACE    IVA_NUMDOC    WITH TRC(6,ALLTRIM(WNUMDOC))  		&& NUMERO DI FATTURA WNUMDOC 
            REPLACE    IVA_CODAGE    WITH WCCAGE 
            REPLACE    IVA_VALUTA    WITH WVALUTA
	        REPLACE    IVA_CAMBIO    WITH WCAMBIO
            IF NOTAC = 'S'  
	           REPLACE    IVA_FATNOT    WITH 'N'
	           XXX_FATNOT = 'N'
	        ELSE
	           REPLACE    IVA_FATNOT    WITH 'F'
	           XXX_FATNOT = 'F'
	        ENDIF  
		    IF FAT = 'C'   && CORRISPETTIVI
		       REPLACE    IVA_FATNOT    WITH 'C'
	           XXX_FATNOT = 'C'
		    ENDIF  
            REPLACE    IVA_DESIVA     WITH DES_IVES
	        REPLACE    IVA_ALIQUO     WITH VAL(ALIQ)
   	  	    IMPONIES = 	((100 * IMPOSTA) /  VAL(ALIQ)) * -1  && RIOTTIENE L'IMPONIBILE
  	        REPLACE    IVA_IMPONI     WITH IMPONIES
	        REPLACE    IVA_TOTALE     WITH IMPONIES
	        REPLACE    IVA_IMPOST     WITH 0
	        REPLACE    IVA_CODIVA     WITH COD_IVAES
		    REPLACE    IVA_BOLLATOIVA WITH WBOLLATOIVA
         ENDIF
         
         ** RECORD TOTALE 
         IF CEE = "E"   OR CEE = 'R' 
            x_tipo = "ito_clifor = 'E'"
            IF   CEE = 'R' 
            	x_tipo = "ito_clifor = 'R'"
            ENDIF
         ELSE
            x_tipo = "ito_clifor = 'C'"
         ENDIF
 
	     IF PUB_NFATDIFFERITA
			IF WBOLLATOIVA = "D"
	            x_tipo = "ito_clifor = 'D'"			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
			ENDIF
 		 ENDIF	
		 
         x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
         x_anno = "ito_anno = '" + PUB_ANNO + "'"
         x_mese = "ito_mese = '" + WMESE + "'"
         x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
         x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
         x_pa   = "ito_pa = '" + FATTURE_ELETTRONICHE_PA + "'"
        
         x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt + " and " + x_pa
         CSQL   = "select * from U_IVA_TS where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
         IF !ExecRW(CSQL,"U_IVA_TS","R")
            RETURN (.f.)
         ENDIF 
         SELECT U_IVA_TS
         GO TOP
         IF !EOF()
            DO IVA_REP  
         ELSE
            APPEND BLANK
            DO IVA_INS_SOS
         ENDIF 
         IF !ExecRW(cSql,"U_IVA_TS","W")
            return(.f.)
         ENDIF
    	 
    	 **  RECORD TOTALE PER GESTIONE IMPONIBILE ESENTE SE VENDITA PUBBLICITARIA
		 IF IMPONIES <> 0   
            IMPONIBILE = IMPONIES 
	        IMPOSTA    = 0 
			COD_IVA    = COD_IVAES
   		    DES_IVA    = DES_IVES
            IF CEE = "E" OR CEE = 'R' 
               x_tipo = "ito_clifor = 'E'"
               IF CEE = 'R' 
	               x_tipo = "ito_clifor = 'R'"
               ENDIF
            ELSE
               x_tipo = "ito_clifor = 'C'"
            ENDIF
            x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
            x_anno = "ito_anno = '" + PUB_ANNO + "'"
            x_mese = "ito_mese = '" + WMESE + "'"
            x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
            x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
            x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
            CSQL   = "select * from U_IVA_TS where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
            IF !ExecRW(CSQL,"U_IVA_TS","R")
               RETURN (.f.)
            ENDIF 
            SELECT U_IVA_TS
            GO TOP
            IF !EOF()
               DO IVA_REP  
            ELSE
               APPEND BLANK
               DO IVA_INS
            ENDIF 
            IF !ExecRW(cSql,"U_IVA_TS","W")
               return(.f.)
            ENDIF
 		 ENDIF
 		 
 		 **  RECORD TOTALE PER GESTIONE IMPONIBILE ESENTE SE VENDITA PUBBLICITARIA 
		 IF IMPONIE2 <> 0   
	        IMPONIBILE = IMPONIE2 
	        IMPOSTA    = 0 
			COD_IVA    = COD_IVAES
   		    DES_IVA    = DES_IVES
            IF CEE = "E" OR CEE = 'R' 
               x_tipo = "ito_clifor = 'E'"
               IF CEE = 'R' 
	               x_tipo = "ito_clifor = 'R'"
               ENDIF
            ELSE
               x_tipo = "ito_clifor = 'C'"
            ENDIF
            x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
            x_anno = "ito_anno = '" + PUB_ANNO + "'"
            x_mese = "ito_mese = '" + WMESE + "'"
            x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
            x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
            x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
            CSQL   = "select * from U_IVA_TS where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
            IF !ExecRW(CSQL,"U_IVA_TS","R")
               RETURN (.f.)
            ENDIF 
            SELECT U_IVA_TS
            GO TOP
            IF !EOF()
               DO IVA_REP  
            ELSE
               APPEND BLANK
               DO IVA_INS
            ENDIF 
            IF !ExecRW(cSql,"U_IVA_TS","W")
               return(.f.)
            ENDIF
  		 ENDIF
 		  		 
 		 SELECT MOV_CONT
		 SKIP +1
	  
	  ENDDO
   
   ELSE
   
      WAIT WINDOWS "Registrazione prima nota clienti n. " + _NREGIS + " errata"
   
   ENDIF 
   
   SELECT IVA
   IF CEE = "E" OR CEE = 'R' 
      REPLACE MOV_CONTO WITH WCODF && RIPRISTINA CODICE FORNITORE PER ELABORAZIONE SUCCESSIVA ACQUISTI
   ENDIF
   
   SKIP +1

ENDDO  



RETURN


******************
PROCEDURE IVAVENLI
******************
*!*	ELABORA I PAGAMENTI RELATIVE ALLE FATTURE IN SOSPENSIONE IVA 
*!*	EFFETTUATI NEL PERIODO DI CARICAMENTO DEL BOLLATO IVA

FATTURE_ELETTRONICHE_PA = ""

cSql=""     
cNomeCursorSql="PART_CLI_INCASSATE"
			
TEXT TO cSql NOSHOW

    SELECT 
        *
    FROM 
        PART_CLI
    WHERE 
        PAR_DESMOV LIKE '%Fatt.Sospens.IVA incassata%'
		AND PAR_DTREG >= '<<RIBALTA2(DATADAL)>>'
		AND PAR_DTREG <= '<<RIBALTA2(DATAAL)>>'
	ORDER BY PAR_DTREG, PAR_CODCLI
	
ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF		

**=> ERASMO/SERGIO INIZIO - 01/08/2017
RELEASE __MOV_NUMPRO__
PUBLIC __MOV_NUMPRO__
__MOV_NUMPRO__ = ""
**=> ERASMO/SERGIO FINE - 01/08/2017

SELECT PART_CLI_INCASSATE
GO TOP		
DO WHILE .NOT. EOF()


    **ACCESSO ALLA FATTURA ORIGINALE PER INTERCETTARE IL CODICE IVA
    __PAR_CODCLI = PAR_CODCLI 
    __PAR_NPART  = PAR_NPART 
    __PAR_FATT   = PAR_FATT
    __PAR_NPROG  = '100'		&& PER PUNTARE AL RECORD ORIGINALE DELLA FATTURA E PRELEVARE IL CODICE IVA     
    __DTPAGAM    = PAR_DTREG
    
    __PAR_CIVA1  = ""
    
    __MOV_NUMPRO__ = PAR_NUMPRO  && ERASMO/SERGIO - 01/08/2017
    
	cSql=""     
	cNomeCursorSql="PART_CLI_FATTURA"
				
	TEXT TO cSql NOSHOW

	    SELECT 
	        *
	    FROM 
	        PART_CLI
	    WHERE 
	        PAR_CODCLI = '<<__PAR_CODCLI>>'
			AND PAR_NPART = '<<__PAR_NPART)>>'
			AND PAR_NPROG = '<<__PAR_NPROG>>'
		ORDER BY PAR_DTREG, PAR_CODCLI
		
	ENDTEXT

	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF		

	SELECT PART_CLI_FATTURA
	GO TOP	    
    IF !EOF()
    
        SCATTER MEMVAR MEMO    && CARICA I DATI ORIGINALI DELLA FATTURA PER LA CREAZIONE DEL DETTAGIO SUCCESSIVO IN U_IVA_CS
    	__PAR_CIVA1 = PAR_CIVA1
	
	ELSE
	    WAIT WINDOWS "FATTURA NON TROVATA CLIENTE : " + __PAR_CODCLI + " NUMERO PARTITA : "+ PAR_NPART NOWAIT
		SELECT PART_CLI_INCASSATE
		SKIP +1
		LOOP
	ENDIF

	*** 2015/06/16 SERGIO/ERASMO FORZATURA PER GESTIRE PROBLEMATICHE DI CONVERSIONE
    IF EMPTY(__PAR_CIVA1) OR __PAR_CIVA1 = 'NO'
    	__PAR_CIVA1 = "22S"	&& CODICE IVA SOSPENSIONE
    ENDIF 
	*** 2015/06/16 SERGIO/ERASMO FORZATURA PER GESTIRE PROBLEMATICHE DI CONVERSIONE
  
  	**=> SERGIO/ERASMO/FABIANO - INIZIO 31/07/2015
	v_seek	 = 'IVA'+__PAR_CIVA1
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA_IVA')
	     SELECT CUR_PARA_IVA
         IF (NOIVACARCLI) = "S" 
			*** CODICE IVA SPLIT PAYMENT
			*** LE FATTURE SPLIT PAYMENT PAGATE NEGLI INCASSI CONSISTONO DEL SOLO IMPONIBILE: L'IVA VIENE PAGATA DIRETTAMENTE DAL CLIENTE PA ALL'ERARIO
			*** QUINDI NON DEVO CONSIDERARLE AI FINI DEL CALCOLO DELL'IVA DA PAGARE NELLA LIQUIDAZIONE
	     	SELECT PART_CLI_INCASSATE
	    	SKIP +1
	    	LOOP        
		 ENDIF
	ENDIF
	**=> SERGIO/ERASMO/FABIANO - FINE 31/07/2015
  

	** CALCOLO IMPOSTA
    __IMPONIBILE  = __PAR_FATT && FORZATURA PROVVISORIA
    __IMPOSTA     = 0
    __DESIVA      = ''
    __ALIQUOTA    = 0
    
	v_seek	 = 'IVA'+__PAR_CIVA1
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA_IVA')
	     SELECT CUR_PARA_IVA
         __DESIVA   = ALLTRIM(DESCRI)         
         __ALIQUOTA    = VAL(SUBSTR(LIBERA,1,3))
         __IMPONIBILE  = ROUND((__PAR_FATT  * 100 / (__ALIQUOTA+100)),2) 
         
         __IMPOSTA     =  ROUND(__PAR_FATT  - __IMPONIBILE,2)   
	ENDIF

	DO CREAZIONE_DETTAGLIO_FATTURA_INCASSATA_U_IVA_CS

	SELECT PART_CLI_INCASSATE
	SKIP +1
	

ENDDO


RETURN 



********************************************************
PROCEDURE CREAZIONE_DETTAGLIO_FATTURA_INCASSATA_U_IVA_CS
********************************************************


   ** ############################################### AGGIORNA RECORD DETTAGLIO ###############################################


   WTOP             = M.PAR_TIPFAT
   VNUMPRT			= VAL(SOLO_NUMERI(M.PAR_NPROT,6))   && NUMERO DI FATTURA
   WNPART           = ALLTRIM(STR(M.PAR_NPART,18,0))	&& NUMERO DI PARTITA
   WMESE    		= MESEDAL 
   WBOLLATOIVA		= " "
   COD_IVA  		= __PAR_CIVA1
   WDTREG           = M.PAR_DTREG
   WDTFAT           = M.PAR_DTFAT
   WNUMFAT          = M.PAR_NPROT						&& NUMERO DI FATTURA
   WNUMDOC 			= TRC(6,ALLTRIM(M.PAR_NPROT))  		&& NUMERO DI FATTURA
   WVALUTA          = M.PAR_VALUTA
   WCAMBIO          = M.PAR_CAMBIO

   IF SUBSTR(WNUMDOC,1,1) = "8"  
  	  FATTURE_ELETTRONICHE_PA = "S"		&& IDENTIFICA IL TOTALE DELLE FATTURE ELETTRONICHE PA IN SOSPENSIONE IVA
   ELSE 
      FATTURE_ELETTRONICHE_PA = "" 		&& IDENTIFICA IL TOTALE DI TUTTE LE ALTRE FATTURE ELETTRONICHE PA IN SOSPENSIONE IVA          
   ENDIF         

   
   v_seek	= 'TOP'+ALLTRIM(M.PAR_TIPFAT)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   	= SUBSTR(LIBERA,2,1)
      NOTAC 	= SUBSTR(LIBERA,11,1) 
	  VER_CONTO = SUBSTR(LIBERA,12,1)
      CEE   	= SUBSTR(LIBERA,23,1)
      VENSOSP  	= SUBSTR(LIBERA,61,1)
   ELSE
      FAT    	= SPACE(1)
      NOTAC  	= SPACE(1)
      VER_CONTO = SPACE(1)
      CEE    	= SPACE(1)
      VENSOSP  	= SPACE(1)
   ENDIF  

   IF NOTAC = 'S'  
      T_IPO = 'N'
   ELSE
      T_IPO = 'F'
   ENDIF  
   
   WCODCLI = ALLTRIM(SUBSTR(M.PAR_CODCLI,PUB_SOTTOG,PUB_CONTO))
   
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + WCODCLI + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_cli_an")
      return(.f.)
   ENDIF
   SELECT u_cli_an
   GO TOP
   IF EOF()
      WRAGSOC   = '????? MANCA ANAGRAFICA CLIENTE : '+ WCODCLI 
  	  WINDIRI   = ''
      WLOCALI   = ''
      WCAP      = ''
      WPARIVA   = ''
      WCCAGE    = ''
   ELSE
      WRAGSOC	= ALLTRIM(CLI_RAGSOC)
  	  WINDIRI   = ALLTRIM(CLI_INDIR)
      WLOCALI   = ALLTRIM(CLI_LOCALI)
      WCAP      = CLI_CAP
      WPARIVA   = CLI_PARIVA
      WCCAGE    = CLI_AGE
   ENDIF   
   
   x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
   x_anno = "iva_anno = '" + PUB_ANNO + "'"
   x_mese = "iva_mese = '" + WMESE + "'"
   x_chia = "iva_chiave = "  + ALLTRIM(STR(VNUMPRT,6,0))
   x_codi = "iva_codiva = '" + ALLTRIM(COD_IVA) + "'"
   x_fatt = "iva_fatnot = '" + ALLTRIM(T_IPO) + "'"
   x_biva = "iva_bollatoiva = '" + ALLTRIM(WBOLLATOIVA) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_chia + " and " + x_codi + " and " + x_fatt+ " and " + x_biva
   CSQL   = "select * from U_IVA_CS where " + x_cond + " order by iva_codsoc,iva_anno,iva_mese,iva_chiave,iva_codiva,iva_fatnot" 
   IF !ExecRW(CSQL,"U_IVA_CS","R")
      RETURN (.f.)
   ENDIF 
   SELECT U_IVA_CS
   GO TOP

*!*	   IF EOF()
 
 
   
      ___CTF_FVS_CLI_INC = ___CTF_FVS_CLI_INC +1
      

 	  APPEND BLANK

 	  REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017

 	  REPLACE    IVA_STATO	   WITH 'INCASSATA'
 	  REPLACE    IVA_DTPAGAM   WITH __DTPAGAM
 	   	   
      REPLACE    IVA_TOP	   WITH WTOP 
      REPLACE    IVA_CHIAVE    WITH VNUMPRT 
      REPLACE    IVA_CODSOC    WITH PUB_CODSOC
      REPLACE    IVA_ANNO      WITH PUB_ANNO
      REPLACE    IVA_CODCLI    WITH WCODCLI 
      REPLACE    IVA_RAGSOC    WITH WRAGSOC 
      REPLACE    IVA_DTCREA    WITH WDTREG
      REPLACE    IVA_DTFATT    WITH WDTFAT
      REPLACE    IVA_NUMFAT    WITH WNPART && WNUMFAT 
  
      IF CEE = "E"   && OR CEE = 'R' 
         REPLACE    IVA_NUMCEE    WITH WNUMFAT 
      ENDIF     
              
 	  REPLACE    IVA_INDIRI    WITH WINDIRI
      REPLACE    IVA_LOCALI    WITH WLOCALI  
      REPLACE    IVA_CAP       WITH WCAP
      REPLACE    IVA_PARIVA    WITH WPARIVA
      REPLACE    IVA_MESE      WITH WMESE
      REPLACE    IVA_NUMDOC    WITH WNUMDOC 
      REPLACE    IVA_CODAGE    WITH WCCAGE 
      REPLACE    IVA_VALUTA    WITH WVALUTA
      REPLACE    IVA_CAMBIO    WITH WCAMBIO
      
      IF NOTAC = 'S'  
         REPLACE    IVA_FATNOT    WITH 'N'
  	     XXX_FATNOT = 'N'
      ELSE
         REPLACE    IVA_FATNOT    WITH 'F'
  	     XXX_FATNOT = 'F'
      ENDIF  
      
  	  REPLACE    IVA_DESIVA     WITH __DESIVA   
      REPLACE    IVA_ALIQUO     WITH __ALIQUOTA

      REPLACE    SOS_IMPONI     WITH __IMPONIBILE    			&& IMPONIBILE IVA DA SOSPESO A INCASSATO
      REPLACE    SOS_IMPOST     WITH __IMPOSTA					&& IMPOSTA IVA DA SOSPESA A INCASSATA
      REPLACE    SOS_TOTALE    	WITH __IMPONIBILE + __IMPOSTA   && TOTALE DA SOSPESO A INCASSATO
      REPLACE    IVA_IMPONI     WITH 0    
      REPLACE    IVA_IMPOST     WITH 0
      REPLACE    IVA_TOTALE    	WITH 0 
  


      REPLACE    IVA_CODIVA     WITH COD_IVA
	  REPLACE    IVA_BOLLATOIVA WITH WBOLLATOIVA
   
*!*	   ELSE
*!*	   	  
*!*	   	  REPLACE    SOS_IMPONI     WITH SOS_IMPONI + __IMPONIBILE    
*!*	      REPLACE    SOS_IMPOST     WITH SOS_IMPOST + __IMPOSTA
*!*	      REPLACE    SOS_TOTALE     WITH SOS_TOTALE + (__IMPONIBILE + __IMPOSTA)
*!*	   
*!*	   ENDIF 
          
   IF !ExecRW(cSql,"U_IVA_CS","W")
      return(.f.)
   ENDIF


     ** ############################################### AGGIORNA RECORD TOTALE ###############################################
     
     WFR = .F.
     IF CEE = "E"   OR CEE = 'R' 
        x_tipo = "ito_clifor = 'E'"
        IF   CEE = 'R' 
        	x_tipo = "ito_clifor = 'R'"
        ENDIF
     ELSE
        x_tipo = "ito_clifor = 'C'"
     ENDIF
 
     IF PUB_NFATDIFFERITA
		IF WBOLLATOIVA = "D"
            x_tipo = "ito_clifor = 'D'"			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
		ENDIF
 	 ENDIF	
	 
     x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
     x_anno = "ito_anno = '" + PUB_ANNO + "'"
     x_mese = "ito_mese = '" + WMESE + "'"
     x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
     x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
     x_pa   = "ito_pa = '" + FATTURE_ELETTRONICHE_PA + "'"
      
     x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt + " and " + x_pa
     CSQL   = "select * from U_IVA_TS where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
     IF !ExecRW(CSQL,"U_IVA_TS","R")
        RETURN (.f.)
     ENDIF 
     SELECT U_IVA_TS
     GO TOP
     IF !EOF()

	   REPLACE    ITS_IMPONI    WITH ITS_IMPONI+__IMPONIBILE 	&& IMPONIBILE INCASSATO DA SOSPENSIONE   
	   REPLACE    ITS_IMPOST    WITH ITS_IMPOST+__IMPOSTA		&& IMPOSTA INCASSATA DA SOSPENSIONE
     
     ELSE
     
        APPEND BLANK
		REPLACE    ITO_CODSOC    WITH PUB_CODSOC
		REPLACE    ITO_ANNO      WITH PUB_ANNO
		REPLACE    ITO_MESE      WITH WMESE
		REPLACE    ITO_DTCREA    WITH WDTREG
        REPLACE    ITO_PA        WITH FATTURE_ELETTRONICHE_PA 	&& SE FATTURA ELETTRONICA PA : 'S'
		
		
		IF CEE = "E" OR CEE = 'R' 
		   REPLACE    ITO_CLIFOR    WITH 'E' 
		   IF CEE = 'R'
		      REPLACE  ITO_CLIFOR WITH 'R'
		   ENDIF
		ELSE
		   REPLACE    ITO_CLIFOR    WITH 'C' 
		ENDIF
		               
		IF PUB_NFATDIFFERITA
			IF WBOLLATOIVA = 'D'
		          REPLACE    ITO_CLIFOR    WITH 'D' 			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
			ENDIF
		ENDIF	

		IF NOTAC = 'S'  
		   REPLACE    ITO_FATNOT    WITH 'N'
		   XXX_FATNOT = 'N'
		ELSE
		   REPLACE    ITO_FATNOT    WITH 'F'
		   XXX_FATNOT = 'F'
		ENDIF  
		IF FAT = 'C'   && CORRISPETTIVI
		   REPLACE    ITO_FATNOT    WITH 'C'
		   XXX_FATNOT = 'C'
		ENDIF  

		REPLACE    ITO_DESIVA    WITH __DESIVA
		REPLACE    ITS_IMPONI    WITH __IMPONIBILE 				&& IMPONIBILE INCASSATO DA SOSPENSIONE   
		REPLACE    ITS_IMPOST    WITH __IMPOSTA					&& IMPOSTA INCASSATA DA SOSPENSIONE
		REPLACE    ITO_CODIVA    WITH COD_IVA            
        
     ENDIF 
     IF !ExecRW(cSql,"U_IVA_TS","W")
        return(.f.)
     ENDIF

RETURN

************************
PROCEDURE IVA_INS
************************

REPLACE    ITO_CODSOC    WITH PUB_CODSOC
REPLACE    ITO_ANNO      WITH PUB_ANNO
REPLACE    ITO_MESE      WITH WMESE
REPLACE    ITO_DTCREA    WITH WDTREG

*IF CEE = "E" OR CEE = 'R' 
IF CEE = "E" OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017
   REPLACE    ITO_CLIFOR    WITH 'E' 

   IF CEE = 'R'
      REPLACE  ITO_CLIFOR WITH 'R'
   ENDIF   
   
	**=> ERASMO - INIZIO 18/12/2017
	IF CEE = 'A'
		REPLACE ITO_CLIFOR WITH 'A'
	ENDIF
	**=> ERASMO - FINE 18/12/2017

ELSE
   REPLACE    ITO_CLIFOR    WITH 'C' 
ENDIF
               
IF PUB_NFATDIFFERITA
	IF WBOLLATOIVA = 'D'
          REPLACE    ITO_CLIFOR    WITH 'D' 			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
	ENDIF
ENDIF	

IF NOTAC = 'S'  
   REPLACE    ITO_FATNOT    WITH 'N'
   XXX_FATNOT = 'N'
ELSE
   REPLACE    ITO_FATNOT    WITH 'F'
   XXX_FATNOT = 'F'
ENDIF  
IF FAT = 'C'   && CORRISPETTIVI
   REPLACE    ITO_FATNOT    WITH 'C'
   XXX_FATNOT = 'C'
ENDIF  

REPLACE    ITO_DESIVA    WITH DES_IVA
REPLACE    ITO_IMPONI    WITH IMPONIBILE  
REPLACE    ITO_IMPOST    WITH IMPOSTA
REPLACE    ITO_CODIVA    WITH COD_IVA


RETURN

************************
PROCEDURE IVA_INS_SOS	&& SOLO PER IVA VENDITE IN SOSPENSIONE : IDENTIFICA IL TOTALE DELLE FATTURE ELETTRONICHE DALLE ALTRE
************************



REPLACE    ITO_CODSOC    WITH PUB_CODSOC
REPLACE    ITO_ANNO      WITH PUB_ANNO
REPLACE    ITO_MESE      WITH WMESE
REPLACE    ITO_DTCREA    WITH WDTREG
IF CEE = "E" OR CEE = 'R' 
   REPLACE    ITO_CLIFOR    WITH 'E' 
   IF CEE = 'R'
      REPLACE  ITO_CLIFOR WITH 'R'
   ENDIF
ELSE
   REPLACE    ITO_CLIFOR    WITH 'C' 
ENDIF
               
IF PUB_NFATDIFFERITA
	IF WBOLLATOIVA = 'D'
          REPLACE    ITO_CLIFOR    WITH 'D' 			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
	ENDIF
ENDIF	

IF NOTAC = 'S'  
   REPLACE    ITO_FATNOT    WITH 'N'
   XXX_FATNOT = 'N'
ELSE
   REPLACE    ITO_FATNOT    WITH 'F'
   XXX_FATNOT = 'F'
ENDIF  
IF FAT = 'C'   && CORRISPETTIVI
   REPLACE    ITO_FATNOT    WITH 'C'
   XXX_FATNOT = 'C'
ENDIF  

REPLACE    ITO_DESIVA    WITH DES_IVA
REPLACE    ITO_IMPONI    WITH IMPONIBILE  
REPLACE    ITO_IMPOST    WITH IMPOSTA
REPLACE    ITO_CODIVA    WITH COD_IVA
REPLACE    ITO_PA        WITH FATTURE_ELETTRONICHE_PA 

RETURN


************************
PROCEDURE IVA_REP
************************

IF WFR && SE FATTURA IN RITARDO MEMORIZZA I TOTALI PER LA LIQUIDAZIONE 
   REPLACE    ITO_IMPONR    WITH ITO_IMPONR+IMPONIBILE   
   REPLACE    ITO_IMPOSR    WITH ITO_IMPOSR+IMPOSTA
ELSE  
   REPLACE    ITO_IMPONI    WITH ITO_IMPONI+IMPONIBILE    
   REPLACE    ITO_IMPOST    WITH ITO_IMPOST+IMPOSTA
ENDIF

RETURN

 
************************
PROCEDURE IVF_REP
************************

IF WFR && SE FATTURA IN RITARDO MEMORIZZA I TOTALI PER LA LIQUIDAZIONE 
   REPLACE    ITO_IMPONR    WITH ITO_IMPONR+IMPONIBILE   
   REPLACE    ITO_IMPOSR    WITH ITO_IMPOSR+IMPOSTA
   REPLACE    ITO_IND100    WITH " "    && GESTIONE IVA INDEDUCIBILE AL 100%
ELSE  
   IF TIPOIVA = "I"     && TRATTA IVA INDEDUCIBILE AL 100 % SOLO RECORD CON IMPONIBILE
      IF PERIVAI = 100
	     REPLACE    ITO_IND100     	WITH "S"	&& GESTIONE IVA INDEDUCIBILE AL 100%
	     REPLACE    ITO_IMPONI     	WITH ITO_IMPONI+ (IMPONIBILE - IMPOSTA)
         REPLACE    ITO_IMPOST     	WITH ITO_IMPOST+IMPOSTA

      	 REPLACE    ITO_DEDUCIBILE	WITH .F.		&&  IVA INDEDUCIBILE NON ENTRA NEL CALCOLO DELLE IMPOSTE
         
      ELSE
         REPLACE    ITO_IMPONI    WITH ITO_IMPONI+IMPONIBILE    
         REPLACE    ITO_IMPOST    WITH ITO_IMPOST+IMPOSTA
         REPLACE    ITO_IND100    WITH " "    
         
		 REPLACE    ITO_DEDUCIBILE	WITH __DEDUCIBILE 	&& IVA INDEDUCIBILE = .F. / DEDUCIBILE = .T.
         
      ENDIF    	
   ELSE
      REPLACE    ITO_IMPONI    	WITH ITO_IMPONI+IMPONIBILE    
      REPLACE    ITO_IMPOST    	WITH ITO_IMPOST+IMPOSTA
      REPLACE    ITO_IND100    	WITH " "    	&& GESTIONE IVA INDEDUCIBILE AL 100%
      
      REPLACE    ITO_DEDUCIBILE	WITH .F.		&&  IVA INDEDUCIBILE NON ENTRA NEL CALCOLO DELLE IMPOSTE
   
   ENDIF
ENDIF

RETURN

 
************************
PROCEDURE IVF_INS
************************

REPLACE    ITO_CODSOC    WITH PUB_CODSOC
REPLACE    ITO_ANNO      WITH PUB_ANNO
REPLACE    ITO_MESE      WITH WMESE
REPLACE    ITO_DTCREA    WITH WDTREG

IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
   REPLACE    ITO_CLIFOR    WITH 'F' 
ELSE
	*IF CEE = "E" OR CEE = 'R'
	IF CEE = "E" OR CEE = 'R' OR CEE = 'A'  && ERASMO - 18/12/2017
	   REPLACE    ITO_CLIFOR    WITH 'E' 
**=> ERASMO/FABIANO - INIZIO 03/08/2015   
*!*	   IF CEE = 'R'
*!*	      REPLACE  ITO_CLIFOR WITH 'R'
*!*	   ENDIF   
		IF CEE = 'R'

			**=> ERASMO/FABIANO - INIZIO 03/08/2015
			*** SE IVA IN ESENZIONE (ALIQUOTA ZERO) QUESTO CODICE IVA NON PREVEDE COMPENSAZIONE CON AUTOFATTURA REVERSE CHARGE
			IF PERCENTUALE_IVA(COD_IVA)> 0
				REPLACE  ITO_CLIFOR WITH 'R'
			ELSE
			    REPLACE  ITO_CLIFOR WITH 'F'  && ERASMO/FABIANO - 03/08/2015  
			ENDIF
			**=> ERASMO/FABIANO - FINE 03/08/2015
			
			**=> ERASMO/FABIANO - INIZIO 29/12/2017
			*** TOTALI NON DI TIPO REVERSE SE TOP REVERSE CHARGE MA IVA CONFIGURATA CON FLAG "Esclude questo codice Iva ai fini delle compensazioni nel bollato Iva per Reverse Charge" = 'S'
			IF NO_IVAREVERSE = 'S'
				REPLACE ITO_CLIFOR WITH 'F'
			ENDIF
			**=> ERASMO/FABIANO - FINE 29/12/2017
			
	   ENDIF
**=> ERASMO/FABIANO - FINE 03/08/2015  
		**=> ERASMO - INIZIO 18/12/2017
		IF CEE = 'A'
			REPLACE ITO_CLIFOR WITH 'A'
		ENDIF
		**=> ERASMO - FINE 18/12/2017
	ELSE
	   REPLACE    ITO_CLIFOR    WITH 'F' 
	ENDIF
ENDIF

IF NOTAC = 'S'  
   REPLACE    ITO_FATNOT    WITH 'N'
   XXX_FATNOT = 'N'
ELSE
   REPLACE    ITO_FATNOT    WITH 'F'
   XXX_FATNOT = 'F'
ENDIF  

REPLACE    ITO_DESIVA    WITH DES_IVA
 
IF WFR && SE FATTURA IN RITARDO MEMEORIZZA I TOTALI PER LA LIQUIDAZIONE 
   REPLACE    ITO_IMPONR    WITH IMPONIBILE    
   REPLACE    ITO_IMPOSR    WITH IMPOSTA
ELSE  
   REPLACE    ITO_IMPONI    WITH IMPONIBILE    
   REPLACE    ITO_IMPOST    WITH IMPOSTA
ENDIF
 
REPLACE    ITO_CODIVA    WITH COD_IVA

REPLACE    ITO_IND100    WITH " "    && GESTIONE IVA INDEDUCIBILE AL 100%
IF TIPOIVA = "I"     && TRATTA IVA INDEDUCIBILE AL 100 % SOLO RECORD CON IMPONIBILE
   IF PERIVAI = 100
	  REPLACE    ITO_IND100     WITH "S"
	  REPLACE    ITO_IMPONI     WITH IMPONIBILE    - IMPOSTA
      
      REPLACE    ITO_DEDUCIBILE	WITH .F.			&& IVA INDEDUCIBILE NON ENTRA NEL CALCOLO DELLE IMPOSTE

   ELSE 

 	  REPLACE    ITO_DEDUCIBILE	WITH __DEDUCIBILE 	&& IVA INDEDUCIBILE = .F. / DEDUCIBILE = .T.
   
   ENDIF    	
ELSE 

   	  REPLACE    ITO_DEDUCIBILE	WITH .F.			&& IVA INDEDUCIBILE NON ENTRA NEL CALCOLO DELLE IMPOSTE

ENDIF

RETURN
 

************************
PROCEDURE IVACLIES	&&  GESTIONE IVA ESENTE PER CLIENTI
************************

IF FAT = 'C'  
   DO CORRISP     && GESTIONE CORRISPETTIVI
   XXX_FATNOT = 'C'
   ** RECORD TOTALE 
   IF CEE = "E" OR CEE = 'R' 
      x_tipo = "ito_clifor = 'E'"
      IF CEE = 'R' 
	      x_tipo = "ito_clifor = 'R'"
      ENDIF
   ELSE
      x_tipo = "ito_clifor = 'C'"
   ENDIF


   x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
   x_anno = "ito_anno = '" + PUB_ANNO + "'"
   x_mese = "ito_mese = '" + WMESE + "'"
   x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
   x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
   CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
   IF !ExecRW(CSQL,"u_iva_to","R")
      RETURN (.f.)
   ENDIF 
   SELECT U_IVA_TO
   GO TOP
   IF !EOF()
      DO IVA_REP  
   ELSE
      APPEND BLANK
      DO IVA_INS
   ENDIF 
   IF !ExecRW(cSql,"U_IVA_TO","W")
      return(.f.)
   ENDIF
   RETURN
ENDIF
	
IF NOTAC = 'S'  
   T_IPO = 'N'
ELSE
   T_IPO = 'F'
ENDIF  

x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = '" + PUB_ANNO + "'"
x_mese = "iva_mese = '" + WMESE + "'"
x_chia = "iva_chiave = " + ALLTRIM(STR(VNUMPRT,6,0))
x_codi = "iva_codiva = '" + ALLTRIM(COD_IVA) + "'"
x_fatt = "iva_fatnot = '" + ALLTRIM(T_IPO) + "'"
x_biva = "iva_bollatoiva = '" + ALLTRIM(WBOLLATOIVA) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_chia + " and " + x_codi + " and " + x_fatt+ " and " + x_biva
*!*	x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_chia + " and " + x_codi + " and " + x_fatt
CSQL   = "select * from u_iva_cl where " + x_cond + " order by iva_codsoc,iva_anno,iva_mese,iva_chiave,iva_codiva,iva_fatnot" 
IF !ExecRW(CSQL,"u_iva_cl","R")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_CL
GO TOP
IF EOF()
   APPEND BLANK
   REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
   REPLACE    IVA_TOP	    WITH WTOP 
   REPLACE    IVA_CHIAVE    WITH VNUMPRT 
   REPLACE    IVA_CODSOC    WITH PUB_CODSOC
   REPLACE    IVA_ANNO      WITH PUB_ANNO
   REPLACE    IVA_CODCLI    WITH WCODCLI 
   REPLACE    IVA_RAGSOC    WITH WRAGSOC 
   REPLACE    IVA_DTCREA    WITH WDTREG
   REPLACE    IVA_DTFATT    WITH WDTFAT
   REPLACE    IVA_NUMFAT    WITH WNUMFAT 
   IF CEE = "E" && OR CEE = 'R' 
      REPLACE    IVA_NUMCEE    WITH WNUMFAT 
   ENDIF             
   REPLACE    IVA_INDIRI    WITH WINDIRI
   REPLACE    IVA_LOCALI    WITH WLOCALI  
   REPLACE    IVA_CAP       WITH WCAP
   REPLACE    IVA_PARIVA    WITH WPARIVA
   REPLACE    IVA_MESE      WITH WMESE
   REPLACE    IVA_NUMDOC    WITH WNUMDOC 
   REPLACE    IVA_CODAGE    WITH WCCAGE 
   REPLACE    IVA_VALUTA    WITH WVALUTA
   REPLACE    IVA_CAMBIO    WITH WCAMBIO
   IF NOTAC = 'S'  
      REPLACE    IVA_FATNOT    WITH 'N'
      XXX_FATNOT = 'N'
   ELSE
      REPLACE    IVA_FATNOT    WITH 'F'
      XXX_FATNOT = 'F'
   ENDIF  
   REPLACE    IVA_DESIVA     WITH DES_IVA
   REPLACE    IVA_ALIQUO     WITH VAL(ALIQ) 
   REPLACE    IVA_IMPONI     WITH IMPONIBILE    
   REPLACE    IVA_IMPOST     WITH IMPOSTA
   REPLACE    IVA_CODIVA     WITH COD_IVA
   REPLACE    IVA_TOTALE     WITH WFATT  
   REPLACE    IVA_BOLLATOIVA WITH WBOLLATOIVA
ELSE
   REPLACE    IVA_IMPONI    WITH IVA_IMPONI + IMPONIBILE    
   REPLACE    IVA_IMPOST    WITH IVA_IMPOST + IMPOSTA
   REPLACE    IVA_TOTALE    WITH IVA_TOTALE + WFATT  
ENDIF
IF !ExecRW(cSql,"U_IVA_CL","W")
   return(.f.)
ENDIF

** RECORD TOTALE 

IF CEE = "E" OR CEE = 'R' 
   x_tipo = "ito_clifor = 'E'"
   IF CEE = 'R' 
	   x_tipo = "ito_clifor = 'R'"
   ENDIF
 ELSE
   x_tipo = "ito_clifor = 'C'"
ENDIF


IF PUB_NFATDIFFERITA
   IF WBOLLATOIVA = "D"
	  x_tipo = "ito_clifor = 'D'"			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
   ENDIF
ENDIF	

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mese = "ito_mese = '" + WMESE + "'"
x_codi = "ito_codiva = '" + ALLTRIM(COD_IVA) + "'"
x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
IF !ExecRW(CSQL,"u_iva_to","R")
   RETURN (.f.)
ENDIF 

IF PUB_NFATDIFFERITA
   IF WBOLLATOIVA = "D"
      x_tipo = "ito_clifor = 'D'"			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
   ENDIF
ENDIF	

SELECT U_IVA_TO
GO TOP
IF !EOF()
   DO IVA_REP  
ELSE
   APPEND BLANK
   DO IVA_INS
ENDIF 
IF !ExecRW(cSql,"U_IVA_TO","W")
   return(.f.)
ENDIF
    
RETURN


************************
PROCEDURE IVAFORES	&&  GESTIONE IVA INDEDUCIBILE A N% PER FORNITORI
************************

** RICALCOLO IMPONIBILE SOGGETTO A N%

_TOT_DOC    = IMPONIBILE + IMPOSTA
__VALUTA    = MOV_VALUTA
__CAMBIO    = MOV_CAMBIO
SW_IMPONI   = IMPONIBILE
NW_IMPONI   = IMPOSTA / (PERIVA / 100)
IMPONIBILE  = CAMBIO(MOV_VALUTA,NW_IMPONI,MOV_CAMBIO)
WFATT       = IMPONIBILE + IMPOSTA
TOTALE      = IMPONIBILE + IMPOSTA

** === > AGGIORNA  ARCHIVI IVA (DETTAGLI / TOTALE)
SELECT CU_IVF_CL
APPEND BLANK
REPLACE    MOV_NUMPRO    	WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
REPLACE    IVF_TOP		 	WITH WTOP 
REPLACE    IVF_CHIAVE    	WITH VNUMPRT 
REPLACE    IVF_CODSOC    	WITH PUB_CODSOC
REPLACE    IVF_ANNO      	WITH PUB_ANNO
REPLACE    IVF_CODCLI    	WITH WCODCLI 
REPLACE    IVF_RAGSOC    	WITH WRAGSOC 
REPLACE    IVF_DTCREA    	WITH WDTREG
REPLACE    IVF_DTFATT    	WITH WDTFAT
REPLACE    IVF_NUMFAT    	WITH WNUMFAT 
REPLACE    IVF_INDIRI    	WITH WINDIRI
REPLACE    IVF_LOCALI    	WITH WLOCALI  
REPLACE    IVF_CAP       	WITH WCAP
REPLACE    IVF_PARIVA    	WITH WPARIVA
REPLACE    IVF_MESE      	WITH WMESE
REPLACE    IVF_TOTALE    	WITH WFATT  
REPLACE    IVF_FATRI     	WITH WFR 
REPLACE    IVF_IND100    	WITH " "    && GESTIONE IVA INDEDUCIBILE AL 100%
REPLACE    IVF_VALUTA    	WITH WVALUTA
REPLACE    IVF_CAMBIO    	WITH WCAMBIO

REPLACE    IVF_DEDUCIBILE	WITH .F.	&& IVA INDEDUCIBILE NON ENTRA NEL CALCOLO DELLE IMPOSTE
__DEDUCIBILE 				=    .F.	&& IVA INDEDUCIBILE NON ENTRA NEL CALCOLO DELLE IMPOSTE

IF WIVA = 'NO'    && TRATTA REGISTRAZIONE DI SOLA IVA BOLLE DOGANALI
   IF WIMPORT > 0  
      REPLACE    IVF_BDOG     WITH .T. 
   ENDIF
ENDIF	
IF NOTAC = 'S'  
   REPLACE    IVF_FATNOT    WITH 'N'
   XXX_FATNOT = 'N'
ELSE
   REPLACE    IVF_FATNOT    WITH 'F'
   XXX_FATNOT = 'F'
ENDIF  
REPLACE    IVF_DESIVA    	WITH DES_IVA
REPLACE    IVF_ALIQUO    	WITH VAL(ALIQ) 
REPLACE    IVF_IMPONI    	WITH IMPONIBILE    
REPLACE    IVF_IMPOST    	WITH IMPOSTA
REPLACE    IVF_CODIVA    	WITH COD_IVA
     
x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mese = "ito_mese = '" + WMESE + "'"
x_codi = "ito_codiva = '" + ALLTRIM(IVF_CODIVA) + "'"
x_tipo = "ito_clifor = 'F'"
x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
IF !ExecRW(CSQL,"u_iva_to","R")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_TO
GO TOP
IF !EOF()
   DO IVF_REP  
ELSE
   APPEND BLANK
   DO IVF_INS
ENDIF 
IF !ExecRW(cSql,"U_IVA_TO","W")
   return(.f.)
ENDIF

** ############################################################# IVA INDEDUCIBILE ####################################################################
** CREA I RECORDS DI IVA CON IMPONIBILE NON SOGGETTO
** RICALCOLO IMPONIBILE NON SOGGETTO A IVA
** MODIFICA PER LA GESTIONE DI IMPONIBILE/IMPOSTA NON DEDUCIBILI PER EVIDEZIARE SEPARATAMENTE IN FASE DI STAMPA

IMPON_DED    = IMPONIBILE
IMPOS_DED    = IMPOSTA
TOT_LORD     = _TOT_DOC - IMPON_DED - IMPOS_DED
IMPONIBILE   = (TOT_LORD * 100) / (PERIVA + 100)
IMPONIBILE   = CAMBIO(__VALUTA,IMPONIBILE,__CAMBIO)
IMPOSTA      = TOT_LORD  - IMPONIBILE 
WFATT        = IMPONIBILE 
TOTALE       = IMPONIBILE 


COD_IVA_DI_PARTENZA = ALLTRIM(COD_IVA)
COD_IVA      		= ALLTRIM(COD_IVA)+"*"   && PER DISTINGUERE DA ALIQUOTA SOGGETTA

v_seek   = 'IVA'+ALLTRIM(COD_IVA)     
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DES_IVA   = SUBSTR(DESCRI,1,30)
ELSE
	*** NUOVA GESTIONE CODICE IVA ABBINATO
	v_seek   = 'IVA'+ALLTRIM(COD_IVA_DI_PARTENZA) 
	seek_std('para',v_seek,v_chiave,'CUR_PARA')
   	SELECT CUR_PARA
   	COD_IVA = CODICE_ABBINATO
	v_seek   = 'IVA'+ALLTRIM(COD_IVA ) 
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
  		SELECT CUR_PARA
   		DES_IVA   = SUBSTR(DESCRI,1,30)
	ELSE 
   		DES_IVA   = "CODIFICARE IVA DETRAIBILE :"+COD_IVA + "???????"
	ENDIF
ENDIF

** === > AGGIORNA  ARCHIVI IVA (DETTAGLI / TOTALE)
SELECT CU_IVF_CL
APPEND BLANK
REPLACE    MOV_NUMPRO    	WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
REPLACE    IVF_TOP		 	WITH WTOP 
REPLACE    IVF_CHIAVE    	WITH VNUMPRT 
REPLACE    IVF_CODSOC    	WITH PUB_CODSOC
REPLACE    IVF_ANNO      	WITH PUB_ANNO
REPLACE    IVF_CODCLI    	WITH WCODCLI 
REPLACE    IVF_RAGSOC    	WITH WRAGSOC 
REPLACE    IVF_DTCREA    	WITH WDTREG
REPLACE    IVF_DTFATT    	WITH WDTFAT
REPLACE    IVF_NUMFAT    	WITH WNUMFAT 
REPLACE    IVF_INDIRI    	WITH WINDIRI
REPLACE    IVF_LOCALI    	WITH WLOCALI  
REPLACE    IVF_CAP       	WITH WCAP
REPLACE    IVF_PARIVA    	WITH WPARIVA
REPLACE    IVF_MESE      	WITH WMESE
REPLACE    IVF_TOTALE    	WITH WFATT  
REPLACE    IVF_FATRI     	WITH WFR 
REPLACE    IVF_IND100    	WITH " "    && GESTIONE IVA INDEDUCIBILE AL 100%
REPLACE    IVF_VALUTA    	WITH WVALUTA
REPLACE    IVF_CAMBIO    	WITH WCAMBIO

REPLACE    IVF_DEDUCIBILE	WITH .T.	&& IVA DEDUCIBILE ENTRA NEL CALCOLO DELLE IMPOSTE
__DEDUCIBILE 				=    .T.	&& IVA DEDUCIBILE ENTRA NEL CALCOLO DELLE IMPOSTE

IF WIVA = 'NO'    && TRATTA REGISTRAZIONE DI SOLA IVA BOLLE DOGANALI
   IF WIMPORT > 0  
      REPLACE    IVF_BDOG     WITH .T. 
   ENDIF
ENDIF	
IF NOTAC = 'S'  
   REPLACE    IVF_FATNOT    WITH 'N'
   XXX_FATNOT = 'N'
ELSE
   REPLACE    IVF_FATNOT    WITH 'F'
   XXX_FATNOT = 'F'
ENDIF  
REPLACE    IVF_DESIVA    	WITH DES_IVA
REPLACE    IVF_ALIQUO    	WITH VAL(ALIQ) 
REPLACE    IVF_IMPONI    	WITH IMPONIBILE    
REPLACE    IVF_IMPOST    	WITH IMPOSTA
REPLACE    IVF_CODIVA    	WITH COD_IVA

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mese = "ito_mese = '" + WMESE + "'"
x_codi = "ito_codiva = '" + ALLTRIM(IVF_CODIVA) + "'"
x_tipo = "ito_clifor = 'F'"
x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
IF !ExecRW(CSQL,"u_iva_to","R")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_TO
GO TOP
IF !EOF()
   DO IVF_REP  
ELSE
   APPEND BLANK
   DO IVF_INS
ENDIF 
IF !ExecRW(cSql,"U_IVA_TO","W")
   return(.f.)
ENDIF
     
RETURN


************************
PROCEDURE CORRISP       && GESTIONE MOVIMENTI IVA CORRISPETTIVI
************************

IF TMOV <> "VB"
	___CTC_CORRISP=___CTC_CORRISP+1		&& I CORRISPETTIVI PER VENDITA AL BANCO SONO CONTEGGIATI TRAMITE IL CURSORE DI SUPPORTO CURS_REGIS
ENDIF

SELECT CU_IVA_CL
APPEND BLANK
REPLACE    MOV_NUMPRO    WITH __MOV_NUMPRO__  && ERASMO/SERGIO - 01/08/2017
REPLACE    IVA_TOP	     WITH WTOP 
REPLACE    IVA_CHIAVE    WITH VNUMPRT 
REPLACE    IVA_CODSOC    WITH PUB_CODSOC
REPLACE    IVA_ANNO      WITH PUB_ANNO
REPLACE    IVA_CODCLI    WITH WCODCLI 
REPLACE    IVA_RAGSOC    WITH WRAGSOC 
REPLACE    IVA_DTCREA    WITH WDTREG
REPLACE    IVA_DTFATT    WITH WDTFAT
REPLACE    IVA_NUMFAT    WITH ALLTRIM(WNUMFAT)
IF CEE = "E" && OR CEE = 'R' 
   REPLACE    IVA_NUMCEE    WITH WNUMFAT 
ENDIF             
REPLACE    IVA_INDIRI    WITH WINDIRI
REPLACE    IVA_LOCALI    WITH WLOCALI  
REPLACE    IVA_CAP       WITH WCAP
REPLACE    IVA_PARIVA    WITH WPARIVA
REPLACE    IVA_MESE      WITH WMESE

IF TMOV <> "VB"
	REPLACE    IVA_NUMDOC    WITH WNUMDOC 
ELSE
	REPLACE    IVA_NUMDOC    WITH ALLTRIM(WNUMFAT)		&& corrispettivi per vendita al banco 
ENDIF

REPLACE    IVA_CODAGE    WITH WCCAGE 
REPLACE    IVA_VALUTA    WITH WVALUTA
REPLACE    IVA_CAMBIO    WITH WCAMBIO
REPLACE    IVA_FATNOT    WITH 'C'
REPLACE    IVA_DESIVA    WITH DES_IVA
REPLACE    IVA_ALIQUO    WITH VAL(ALIQ) 
REPLACE    IVA_IMPONI    WITH IMPONIBILE    
REPLACE    IVA_IMPOST    WITH IMPOSTA
REPLACE    IVA_CODIVA    WITH COD_IVA
REPLACE    IVA_TOTALE    WITH WFATT  

XXX_FATNOT = 'C'

RETURN


***********************************
PROCEDURE MANCA_CODICE_CLIENTE_CEE
***********************************

CONTAERR = CONTAERR + 1
SELECT STAMPAERR
APPEND BLANK
REPLACE MOV_CONTO_    WITH   _MOV_CONTO   
REPLACE MOV_RAGSOC_   WITH   _MOV_RAGSOC
REPLACE MOV_DTREG_    WITH   _MOV_DTREG   
REPLACE MOV_NREGIS_   WITH   _MOV_NREGIS  
REPLACE MOV_NPROT_    WITH   _MOV_NPROT   
REPLACE MOV_NDOC_     WITH   _MOV_NDOC    
REPLACE MOV_DTDOC_    WITH   _MOV_DTDOC   

_CODICE_FORNITORE = ALLTRIM(SUBSTR(_MOV_CONTO,PUB_SOTTOG))

RETURN


***********************************
PROCEDURE RAGGRUPPA_FATTURE
***********************************
** RAGRUPPAMENTO CURSORI PER DOCUMENTO/IVA
*!*	               x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
*!*	               x_anno = "iva_anno = '" + PUB_ANNO + "'"
*!*	               x_mese = "iva_mese = '" + WMESE + "'"
*!*	               x_chia = "iva_chiave = "  + ALLTRIM(STR(VNUMPRT,6,0))
*!*	               x_codi = "iva_codiva = '" + ALLTRIM(COD_IVA) + "'"
*!*	               x_fatt = "iva_fatnot = '" + ALLTRIM(T_IPO) + "'"
*!*	               x_biva = "iva_bollatoiva = '" + ALLTRIM(WBOLLATOIVA) + "'"
** RAGRUPPAMENTO CURSORI PER DOCUMENTO/IVA


IF !ExecCommand("select * from u_ivf_cl where 0=1","R_ivf_cl")			&& bollato iva fornitori
   return(.f.)
ENDIF

SELECT R_IVF_CL
*INDEX ON IVF_CODSOC + IVF_ANNO + IVF_MESE + ALLTRIM(STR(IVF_CHIAVE)) + ALLTRIM(IVF_CODIVA) + IVF_FATNOT  TAG RAGGRUPPA
INDEX ON IVF_CODSOC + IVF_ANNO + IVF_MESE + ALLTRIM(STR(IVF_CHIAVE)) + ALLTRIM(IVF_CODIVA) + IVF_FATNOT + ALLTRIM(IVF_NUMFAT)  TAG RAGGRUPPA  && ERASMO - 18/12/2017

SELECT CU_IVF_CL
GO TOP
SCAN
	
	SCATTER MEMVAR MEMO
	
	SELECT R_IVF_CL
	SET ORDER TO RAGGRUPPA
	*_CHIAVE= M.IVF_CODSOC + M.IVF_ANNO + M.IVF_MESE + ALLTRIM(STR(M.IVF_CHIAVE)) + ALLTRIM(M.IVF_CODIVA) + M.IVF_FATNOT 
	_CHIAVE= M.IVF_CODSOC + M.IVF_ANNO + M.IVF_MESE + ALLTRIM(STR(M.IVF_CHIAVE)) + ALLTRIM(M.IVF_CODIVA) + M.IVF_FATNOT + ALLTRIM(M.IVF_NUMFAT)  && ERASMO - 18/12/2017
	SEEK _CHIAVE
	IF !FOUND()
		APPEND BLANK
	ENDIF
	
	M.IVF_IMPONI = IVF_IMPONI + M.IVF_IMPONI
	M.IVF_IMPOST = IVF_IMPOST + M.IVF_IMPOST
	M.IVF_TOTALE = IVF_TOTALE + M.IVF_TOTALE
	
	GATHER MEMVAR MEMO
	
	SELECT CU_IVF_CL

ENDSCAN

SELECT CU_IVF_CL
ZAP

SELECT R_IVF_CL
GO TOP
SCAN
	SCATTER MEMVAR MEMO

	SELECT CU_IVF_CL
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	SELECT R_IVF_CL

ENDSCAN


SELECT CU_IVF_CL
GO TOP


RETURN

*******************************************************
PROCEDURE AGGIORNA_DATA_ORA_CARICAMENTO_BOLLATO_IVA
*******************************************************


_TOTALONE =  ___CTF_CLI + ___CTF_CLI_AUTO +  ___CTF_FVS_CLI +  ___CTF_FVS_CLI_INC + ___CTF_FVS_NC_CLI + ___CTF_FOR +  ___CTC_CORRISP +  ___TOT_REC +  ___CTF_FOR_CEE +  ___CTF_NC_CLI + ___CTF_NC_FOR 
IF _TOTALONE <> 0
ELSE
	RETURN	&& nessun caricamento fatto
ENDIF 
	

_SELx=SELECT()


x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = " + PUB_ANNO
x_cond = x_soci + " and " + x_anno
cSqlco   = "select * from u_iva_cr where " + x_cond + " order by iva_codsoc,iva_anno"
IF !ExecRW(cSqlco,"u_iva_cr","R")
  return(.f.)
ENDIF



SELECT U_IVA_CR
IF !EOF()
	SCATTER MEMVAR MEMO
ELSE
	APPEND BLANK
	REPLACE IVA_CODSOC WITH PUB_CODSOC
	REPLACE IVA_ANNO   WITH PUB_ANNO
ENDIF 


IF MESE_CARI = "01"
	REPLACE M01_DATREG WITH DATA_CARI 
	REPLACE M01_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "02"
	REPLACE M02_DATREG WITH DATA_CARI 
	REPLACE M02_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "03"
	REPLACE M03_DATREG WITH DATA_CARI 
	REPLACE M03_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "04"
	REPLACE M04_DATREG WITH DATA_CARI 
	REPLACE M04_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "05"
	REPLACE M05_DATREG WITH DATA_CARI 
	REPLACE M05_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "06"
	REPLACE M06_DATREG WITH DATA_CARI 
	REPLACE M06_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "07"
	REPLACE M07_DATREG WITH DATA_CARI 
	REPLACE M07_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "08"
	REPLACE M08_DATREG WITH DATA_CARI 
	REPLACE M08_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "09"
	REPLACE M09_DATREG WITH DATA_CARI 
	REPLACE M09_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "10"
	REPLACE M10_DATREG WITH DATA_CARI 
	REPLACE M10_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "11"
	REPLACE M11_DATREG WITH DATA_CARI 
	REPLACE M11_ORAREG WITH TIME()
ENDIF
IF MESE_CARI = "12"
	REPLACE M12_DATREG WITH DATA_CARI 
	REPLACE M12_ORAREG WITH TIME()
ENDIF




IF !ExecRW("","u_iva_cr","W")
  return(.f.)
ENDIF


SELECT(_SELx)
	
	
	
RETURN	
	

******************************
FUNCTION PERCENTUALE_IVA
******************************
LPARAMETERS _CODICE_IVA

LOCAL _N_ALIQUOTA,_C_OLDCUR
_N_ALIQUOTA = 0
_C_OLDCUR = SELECT()

IF !ExecCommand("select libera from para where codice = 'IVA" + ALLTRIM(_CODICE_IVA) + "'","TMP_IVA_PARA")
   RETURN
ENDIF

SELECT TMP_IVA_PARA
IF !EOF()
   _N_ALIQUOTA = VAL(SUBSTR(LIBERA,1,3))
ENDIF
SELECT(_C_OLDCUR)

RETURN _N_ALIQUOTA

