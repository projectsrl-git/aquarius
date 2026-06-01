********************************************************************************************************
*  				     CARICAMENTO BOLLATI IVA CLIENTI / FORNITORI / CORRISPETTIVI   				       *
*                                                                                                      *
*                                      *************************                                       *
*                                        GESTIONE IVA PER CASSA                                        *
*                                      *************************                                       *
*                                                                                                      *
********************************************************************************************************

RELEASE NO_IVAPERCASSA 
PUBLIC NO_IVAPERCASSA 

NO_IVAPERCASSA = .F.


** GESTIONE ERRORI DI NON CODIFICA CORRETTA PER FORNITORI CEE SENZA CODICE CLIENTE CEE IN ANAGRAFICA FORNITORI
CREATE CURSOR STAMPAERR (MOV_CONTO_ C(13),MOV_RAGSOC_ C(40),MOV_DTREG_ C(10), MOV_NREGIS_ C(10), MOV_NPROT_ C(10), MOV_NDOC_ C(10), MOV_DTDOC_ C(10))
INDEX ON ALLTRIM(MOV_RAGSOC_)+ MOV_DTDOC_ +ALLTRIM(MOV_NDOC_) TAG ORDERR ADDITIVE

RELEASE CONTAERR 
PUBLIC CONTAERR
CONTAERR = 0



RELEASE XXX_FATNOT,WBOLLATOIVA
PUBLIC  XXX_FATNOT,WBOLLATOIVA     
XXX_FATNOT  = ''
WBOLLATOIVA = SPACE(01) 

RELEASE ___PIN_CTF_FOR,___PIN_CTF_CLI,___PIN_CTN_FOR,___PIN_CTN_CLI
PUBLIC ___PIN_CTF_FOR,___PIN_CTF_CLI,___PIN_CTN_FOR,___PIN_CTN_CLI

___PIN_CTF_FOR	= 0
___PIN_CTF_CLI	= 0
___PIN_CTN_FOR	= 0
___PIN_CTN_CLI	= 0



RELEASE ___CTF_CLI,___CTF_CLI_AUTO,___CTF_FOR,___CTF_FOR_CEE,___CTC_CORRISP,___CTF_NC_CLI
PUBLIC ___CTF_CLI,___CTF_CLI_AUTO,___CTF_FOR,___CTF_FOR_CEE,___CTC_CORRISP,___CTF_NC_CLI
RELEASE ___CTF_NC_FOR,OK_CONTA
PUBLIC  ___CTF_NC_FOR,OK_CONTA

___CTF_CLI				= 0
___CTF_CLI_AUTO 		= 0
___CTF_FOR				= 0
___CTF_FOR_CEE			= 0
___CTC_CORRISP			= 0
___CTF_NC_CLI			= 0
___CTF_NC_FOR			= 0
OK_CONTA								= .F.

ANNODAL   = SUBSTR(DATADAL,7,4)
MESEDAL   = SUBSTR(DATADAL,4,2)
V_ANNO	  = ANNODAL
V_MESE	  = MESEDAL
CONTA_REC = 0

PUBLIC OK_PROTCL 
OK_PROTCL = 0

IF (EMPTY(MESEDAL)) .OR.  (EMPTY(ANNODAL))  
   RETURN
ENDIF  

RIT = MESSAGEBOX('Sei sicuro di voler caricare il mese iva da : '+DATADAL+CHR(13)+" a :"+DATAAL+CHR(13),292,"ATTENZIONE")
IF RIT = 7
   DO CLEAR_VAR
   RETURN
ENDIF

*** DEFINICE UN CURSORE DI SUPPORTO USATO PER LA GESTIONE DELLE VENDITE AL BANCO PER CORRISPETTIVI (VB)
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

** SERGIO 18/12/2021 INIZIO
IF PUB_CONTOSIMILCEE 
	CCC=SUBSTR(LIBERA,01,PUB_GRUPPOCF)
	FFF=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
ELSE
	CCC=SUBSTR(LIBERA,01,PUB_SOTTOG-1)
	FFF=SUBSTR(LIBERA,18,PUB_SOTTOG-1)
ENDIF
** SERGIO 18/12/2021 FINE  

IF !ExecCommand("select * from c_iva_cl where 0=1","cc_iva_cl")
   return(.f.)
ENDIF
IF !ExecCommand("select * from C_IVF_cl where 0=1","cC_IVF_cl")
   return(.f.)
ENDIF

DO IVAVENDI      &&  CARICAMENTO BOLLATO IVA VENDITE NEGLI ARCHIVI IVA PER CASSA
DO IVAACQUI      &&  CARICAMENTO BOLLATO IVA ACQUISTI NEGLI ARCHIVI IVA PER CASSA 

IF !ExecRW('','c_iva_cl','I','','Cc_iva_CL')
   return(.f.)
ENDIF
IF !ExecRW('','C_IVF_cl','I','','CC_IVF_CL')
   return(.f.)
ENDIF


DO IVAPERCA      &&  DETERMINA PERCENTUALE IVA PER CASSA E CREA IVA DEL MESE 




SELECT cur_regis
GO TOP
COUNT TO ___TOT_REC
IF ___TOT_REC <> 0		&& VERIFICA SE DOPPIA GESTIONE CORRISPETTIVI E CORRISPETTIVI PER VENDITA AL BANCO
   WAIT WINDOWS  "Fat.clienti man.."+PADL(ALLTRIM(STR(___CTF_CLI,10,0)),13,'.')		+ ;
		 	 CHR(13)+ "Fat.clienti autom." + PADL(ALLTRIM(STR(___CTF_CLI_AUTO,10,0)),8,'.')	+ ;
			 CHR(13)+ "Fat.fornitori...." + PADL(ALLTRIM(STR(___CTF_FOR,10,0)),17,'.')		+ ;
			 CHR(13)+ "Cor.clienti......" + PADL(ALLTRIM(STR(___CTC_CORRISP,10,0)),18,'.')	+ ;
			 CHR(13)+ "Cor.cli.v.banco" + PADL(ALLTRIM(STR(___TOT_REC,10,0)),18,'.')	+ ;
			 CHR(13)+ "Fat.cee.rev." + PADL(ALLTRIM(STR(___CTF_FOR_CEE,10,0)),17,'.')	+ ;
			 CHR(13)+ "Note c.cli.." + PADL(ALLTRIM(STR(___CTF_NC_CLI,10,0)),18,'.')	+ ;
			 CHR(13)+ "Note c.for.." + PADL(ALLTRIM(STR(___CTF_NC_FOR,10,0)),15,'.')
ELSE
   WAIT WINDOWS  "Fat.clienti manuali..."+PADL(ALLTRIM(STR(___CTF_CLI,10,0)),13,'.')		+ ;
		 	 CHR(13)+ "Fat.clienti automatiche.." + PADL(ALLTRIM(STR(___CTF_CLI_AUTO,10,0)),8,'.')	+ ;
			 CHR(13)+ "Fat.fornitori......" + PADL(ALLTRIM(STR(___CTF_FOR,10,0)),17,'.')		+ ;
			 CHR(13)+ "Cor.clienti........" + PADL(ALLTRIM(STR(___CTC_CORRISP,10,0)),18,'.')	+ ;
			 CHR(13)+ "Fat.for.cee.rev..." + PADL(ALLTRIM(STR(___CTF_FOR_CEE,10,0)),17,'.')	+ ;
			 CHR(13)+ "Note c.clienti...." + PADL(ALLTRIM(STR(___CTF_NC_CLI,10,0)),18,'.')	+ ;
			 CHR(13)+ "Note c.fornitori....." + PADL(ALLTRIM(STR(___CTF_NC_FOR,10,0)),15,'.')
ENDIF


WAIT WINDOWS  CHR(13)+ "Fat.clienti per cassa.." + PADL(ALLTRIM(STR(___PIN_CTF_CLI,10,0)),8,'.')	+ ;
		 CHR(13)+ "Fat.fornitori per cassa." + PADL(ALLTRIM(STR(___PIN_CTF_FOR,10,0)),17,'.')		+ ;
		 CHR(13)+ "Note c.clienti per cassa." + PADL(ALLTRIM(STR(___PIN_CTN_CLI,10,0)),18,'.')	+ ;
		 CHR(13)+ "Note c.fornitori per cassa." + PADL(ALLTRIM(STR(___PIN_CTN_FOR,10,0)),15,'.')





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
CSQL   = "delete from c_iva_cl where " + x_cond
IF !ExecCommand(CSQL,"c_iva_CL")
   RETURN (.f.)
ENDIF 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNODAL + "'"
x_mese = "ito_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese 
CSQL   = "delete from c_iva_to where " + x_cond
IF !ExecCommand(CSQL,"c_iva_TO")
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


x_soci  = "mov_soc = '" + PUB_CODSOC + "'"
x_anno  = "mov_anno = '" + ANNODAL + "'"
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


   
  **=> SERGIO - INIZIO 18/12/2021
  IF PUB_CONTOSIMILCEE
	   IF VERYCF_SIMILCEE(MOV_CONTO,"CF")
	   ELSE
	      SKIP +1
	      LOOP
	   ENDIF
  ELSE
	   IF VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CF")
	   ELSE
	      SKIP +1
	      LOOP
	   ENDIF
  ENDIF
  **=> SERGIO - FINE 18/12/2021
   
   
   
  **=> SERGIO - INIZIO 18/12/2021
  IF PUB_CONTOSIMILCEE
	   IF VERYCF_SIMILCEE(MOV_CONTO,"CL")
	     _STO_TRATTANDO_UN_CLIENTE = .T.
	   ENDIF
  ELSE
	   IF VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CL")
	     _STO_TRATTANDO_UN_CLIENTE = .T.
	   ENDIF
  ENDIF
  **=> SERGIO - FINE 18/12/2021   
   
   
   


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

*=> INIZIO - SERGIO 04/05/2006
CREATE CURSOR SOLOUNCLI (SOL_CODSOC C(02), SOL_ANNO C(04), SOL_NUMPRO C(13))
INDEX ON SOL_CODSOC + SOL_ANNO + SOL_NUMPRO TAG I_UNCLI ADDITIVE
*=> FINE -  SERGIO 04/05/2006


SELECT IVA
INDEX ON MOV_NPROT + MOV_NUMPRO + MOV_ANNO + MOV_TOP + MOV_CONTO TAG I_IVA ADDITIVE
SET ORDER TO I_IVA
GO TOP


_MOV_RAGSOC = ""


*!*	VVV_NPROT = ''
*!*	VVV_NPROD = ''
*!*	VVV_ANNO  = ''
*!*	VVV_TOP   = ''
*!*	VVV_CONTO = ''

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

*!*	   IF MOV_NPROT = VVV_NPROT .AND. ;
*!*	      MOV_NUMPRO = VVV_NPROD .AND. ;
*!*	      MOV_ANNO = VVV_ANNO .AND. ;
*!*	      MOV_TOP = VVV_TOP
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   VVV_NPROT = MOV_NPROT
*!*	   VVV_NPROD = MOV_NUMPRO
*!*	   VVV_ANNO  = MOV_ANNO
*!*	   VVV_TOP   = MOV_TOP
*!*	   VVV_CONTO = MOV_CONTO
   
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


   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   	= SUBSTR(LIBERA,2,1)
      NOTAC 	= SUBSTR(LIBERA,11,1) 
	  VER_CONTO = SUBSTR(LIBERA,12,1)
      CEE   	= SUBSTR(LIBERA,23,1)
   ELSE
      FAT    	= SPACE(1)
      NOTAC  	= SPACE(1)
      VER_CONTO = SPACE(1)
      CEE    	= SPACE(1)
   ENDIF

   IF FAT = 'S' OR FAT = 'C' && SALTA I TOP NON FATTURA / CORRISPETTIVI
   ELSE
      SELECT IVA 
      SKIP +1
      LOOP
   ENDIF

   IF CEE = 'E' OR CEE = 'R' && FATTURA ACQUISTO CEE o per iva reverse change PRELEVA IL CODICE CLIENTE CEE DA ANAGRAFICA DEL FORNITORE

	   ** SERGIO 18/12/2021 INIZIO
	   IF PUB_CONTOSIMILCEE 
		  WCOD   = ALLTRIM(SCORPRA_CODICE_CLIENTE_FORNITORE_SE_SIMILCEE(WCODCLI))
	   ELSE
		  WCOD   = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
	   ENDIF
	   ** SERGIO 18/12/2021 FINE  	  
	  
	  
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
         WNAZION   = FOR_NAZION
	     WCLICEE   = FOR_CLICEE
	     _MOV_RAGSOC = FOR_RAGSOC
	  ELSE
	     WNAZION   = "ITA"
	     WCLICEE   = WCOD
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
 		
			   ** SERGIO 18/12/2021 INIZIO
			   IF PUB_CONTOSIMILCEE 
				  WCOD   = ALLTRIM(SCORPRA_CODICE_CLIENTE_FORNITORE_SE_SIMILCEE(WCODCLI))
			   ELSE
				  WCOD   = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
			   ENDIF
			   ** SERGIO 18/12/2021 FINE  			   
			   
			   
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
			      WRAGSOC   = SPACE(40)
			      WINDIRI   = SPACE(40)
			      WLOCALI   = SPACE(40)
			      WCAP      = SPACE(5)
			      WPARIVA   = SPACE(16)  
			      WCCAGE    = SPACE(03)
			      WNAZION   = SPACE(03)
			   ENDIF
			   SELECT IVA

			   
			  **=> SERGIO - INIZIO 18/12/2021
			  IF PUB_CONTOSIMILCEE
				   IF !VERYCF_SIMILCEE(MOV_CONTO,"CL")
				      SELECT IVA
				      SKIP +1
				      LOOP
				   ENDIF
			  ELSE
				   IF !VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CL")
				      SELECT IVA
				      SKIP +1
				      LOOP
				   ENDIF
			  ENDIF
			  **=> SERGIO - FINE 18/12/2021 			   
						   
			   

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
 		 * CASO DI VENDITE CON ARTICOLO PUBBLICITARIO FATTE ALL'ESTERO (QUINDI IN ESENZIONE IVA)
		 IF CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO) = 0 	.AND. 	CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) = 0
			SKIP +1
			LOOP
		 ENDIF
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
               x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_chia + " and " + x_codi + " and " + x_fatt+ " and " + x_biva
               CSQL   = "select * from c_iva_cl where " + x_cond + " order by iva_codsoc,iva_anno,iva_mese,iva_chiave,iva_codiva,iva_fatnot" 
               IF !ExecRW(CSQL,"c_iva_cl","R")
                  RETURN (.f.)
               ENDIF 
  	 	       SELECT c_iva_CL
  	 	       GO TOP
  	 	       IF EOF()
 			      APPEND BLANK
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
               IF !ExecRW(cSql,"c_iva_CL","W")
                  return(.f.)
               ENDIF
            ENDIF  
         ELSE
            ** GESTIONE VENDITE PUBBLICITARIE (SOLO IVA) 
       	    ** === > 19/01/2004 NUOVA GESTIONE MATERIALE PUBBLICITARIO------INIZIO
            SELECT Cc_iva_CL
            APPEND BLANK
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
         x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
         CSQL   = "select * from c_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
         IF !ExecRW(CSQL,"c_iva_to","R")
            RETURN (.f.)
         ENDIF 
         SELECT c_iva_TO
         GO TOP
         IF !EOF()
            DO IVA_REP  
         ELSE
            APPEND BLANK
            DO IVA_INS
         ENDIF 
         IF !ExecRW(cSql,"c_iva_TO","W")
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
            CSQL   = "select * from c_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
            IF !ExecRW(CSQL,"c_iva_to","R")
               RETURN (.f.)
            ENDIF 
            SELECT c_iva_TO
            GO TOP
            IF !EOF()
               DO IVA_REP  
            ELSE
               APPEND BLANK
               DO IVA_INS
            ENDIF 
            IF !ExecRW(cSql,"c_iva_TO","W")
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
            CSQL   = "select * from c_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
            IF !ExecRW(CSQL,"c_iva_to","R")
               RETURN (.f.)
            ENDIF 
            SELECT c_iva_TO
            GO TOP
            IF !EOF()
               DO IVA_REP  
            ELSE
               APPEND BLANK
               DO IVA_INS
            ENDIF 
            IF !ExecRW(cSql,"c_iva_TO","W")
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


*!*	SELECT IVA
*!*	BROWSE NORMAL
*!*	GO TOP



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
CSQL   = "delete from C_IVF_cl where " + x_cond
IF !ExecCommand(CSQL,"C_IVF_CL")
   RETURN (.f.)
ENDIF 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNODAL + "'"
x_mese = "ito_mese = '" + MESEDAL + "'"
x_tipo = "(ito_clifor = 'F' or ito_clifor = 'E' or ito_clifor = 'R')"    && CANCELLO SOLO I RECORD CON ITO_CLIFOR = 'F'
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_tipo
CSQL   = "delete from c_iva_to where " + x_cond
IF !ExecCommand(CSQL,"c_iva_TO")
   RETURN (.f.)
ENDIF 

*=> INIZIO - PROJECT 09/09/2005
CREATE CURSOR SOLOUNFOR (SOL_CODSOC C(02), SOL_ANNO C(04), SOL_NUMPRO C(13))
INDEX ON SOL_CODSOC + SOL_ANNO + SOL_NUMPRO TAG I_UNFOR ADDITIVE
*=> FINE - PROJECT 09/09/2005

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

*!*	   IF MOV_NREGIS = '1470'
*!*	      SET STEP ON 
*!*	   ENDIF

   VNUMPRT = VAL(SUBSTR(MOV_NPROT,1,6))
   NREG    = MOV_NUMPRO
   ANNO    = MOV_ANNO
   WTOP    = MOV_TOP
   WCONTO  = MOV_CONTO

*!*	  PER FATTURE CON ACCONTI SCARTA I MOVIMENTI RELATIVI AI PAGAMENTI AGGANCIATI
   IF MOV_NOIVA = 'S'			
      SKIP +1
      LOOP
   ENDIF
 


  **=> SERGIO - INIZIO 18/12/2021
  IF PUB_CONTOSIMILCEE
	   IF !VERYCF_SIMILCEE(MOV_CONTO,"FO")
	      SKIP +1
	      LOOP
	   ENDIF
  ELSE
	   IF !VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"FO")
	      SKIP +1
	      LOOP
	   ENDIF
  ENDIF
  **=> SERGIO - FINE 18/12/2021 


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
   ** SERGIO 18/12/2021 INIZIO
   IF PUB_CONTOSIMILCEE 
	  WCOD   = ALLTRIM(SCORPRA_CODICE_CLIENTE_FORNITORE_SE_SIMILCEE(WCODCLI))
   ELSE
	  WCOD   = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
   ENDIF
   ** SERGIO 18/12/2021 FINE     
   
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
      WRAGSOC   = SPACE(40)
      WINDIRI   = SPACE(40)
      WLOCALI   = SPACE(40)
      WCAP      = SPACE(5)
      WPARIVA   = SPACE(16)  
      WCLICEE   = SPACE(10)
   ENDIF

   IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
   ELSE
	   IF CEE = 'E' OR CEE = 'R' && FATTURA ACQUISTO CEE o per iva reverse change PRELEVA IL CODICE CLIENTE CEE DA ANAGRAFICA DEL FORNITORE
	      SELECT IVA
	      IF EMPTY(WCLICEE)
	         SKIP +1
	         LOOP
	      ENDIF
	   ENDIF
   ENDIF

   *=> INIZIO - PROJECT 09/09/2005
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
   *=> FINE - PROJECT 09/09/2005
   
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
		 	   COD_IVA = "BD2"
			ENDIF
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
         WTOP		 = MOV_TOP
         WNUMPRO     = MOV_NUMPRO
         WNREG       = MOV_NREGIS
         WNPART      = MOV_NPART
         WNPROG      = "000"
         WDTREG      = MOV_DTREG
         WDTFAT      = MOV_DTDOC
         WNUMFAT     = MOV_NDOC
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
					IF CEEF = "E" OR CEEF = 'R'
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
         SELECT CC_IVF_CL
	     APPEND BLANK
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

         x_tipo = "ito_clifor = 'F'"

         IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
         ELSE
	         IF CEE = "E"
	            x_tipo = "ito_clifor = 'E'"
	         ENDIF
		 ENDIF
		          
         x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
         x_anno = "ito_anno = '" + PUB_ANNO + "'"
         x_mese = "ito_mese = '" + WMESE + "'"
         x_codi = "ito_codiva = '" + ALLTRIM(IVF_CODIVA) + "'"
         x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
         x_fatt1 = "ito_clifor = 'F'"

         x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt 
         CSQL   = "select * from c_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
         IF !ExecRW(CSQL,"c_iva_to","R")
            RETURN (.f.)
         ENDIF 
         SELECT c_iva_TO
         GO TOP
         IF !EOF()
            DO IVF_REP  
         ELSE
            APPEND BLANK
            DO IVF_INS
         ENDIF 
         IF !ExecRW(cSql,"c_iva_TO","W")
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


************************
PROCEDURE IVA_INS
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
   XXX_FATNOT = 'S'
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
	     REPLACE    ITO_IND100     WITH "S"
	     REPLACE    ITO_IMPONI     WITH ITO_IMPONI+ (IMPONIBILE - IMPOSTA)
         REPLACE    ITO_IMPOST     WITH ITO_IMPOST+IMPOSTA
      ELSE
         REPLACE    ITO_IMPONI    WITH ITO_IMPONI+IMPONIBILE    
         REPLACE    ITO_IMPOST    WITH ITO_IMPOST+IMPOSTA
         REPLACE    ITO_IND100    WITH " "    && GESTIONE IVA INDEDUCIBILE AL 100%
      ENDIF    	
   ELSE
      REPLACE    ITO_IMPONI    WITH ITO_IMPONI+IMPONIBILE    
      REPLACE    ITO_IMPOST    WITH ITO_IMPOST+IMPOSTA
      REPLACE    ITO_IND100    WITH " "    && GESTIONE IVA INDEDUCIBILE AL 100%
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
	IF CEE = "E" OR CEE = 'R' 
	   REPLACE    ITO_CLIFOR    WITH 'E' 
	   IF CEE = 'R'
	      REPLACE ITO_CLIFOR WITH 'R'
	   ENDIF
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
   ENDIF    	
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
   CSQL   = "select * from c_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
   IF !ExecRW(CSQL,"c_iva_to","R")
      RETURN (.f.)
   ENDIF 
   SELECT c_iva_TO
   GO TOP
   IF !EOF()
      DO IVA_REP  
   ELSE
      APPEND BLANK
      DO IVA_INS
   ENDIF 
   IF !ExecRW(cSql,"c_iva_TO","W")
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
CSQL   = "select * from c_iva_cl where " + x_cond + " order by iva_codsoc,iva_anno,iva_mese,iva_chiave,iva_codiva,iva_fatnot" 
IF !ExecRW(CSQL,"c_iva_cl","R")
   RETURN (.f.)
ENDIF 
SELECT c_iva_CL
GO TOP
IF EOF()
   APPEND BLANK
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
IF !ExecRW(cSql,"c_iva_CL","W")
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
CSQL   = "select * from c_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
IF !ExecRW(CSQL,"c_iva_to","R")
   RETURN (.f.)
ENDIF 

IF PUB_NFATDIFFERITA
   IF WBOLLATOIVA = "D"
      x_tipo = "ito_clifor = 'D'"			&& GESTIONE BOLLATO IVA FATTURE AUTOMATICHE DA DOCUMENTI DI TRASPORTO
   ENDIF
ENDIF	

SELECT c_iva_TO
GO TOP
IF !EOF()
   DO IVA_REP  
ELSE
   APPEND BLANK
   DO IVA_INS
ENDIF 
IF !ExecRW(cSql,"c_iva_TO","W")
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
SELECT CC_IVF_CL
APPEND BLANK
REPLACE    IVF_TOP		 WITH WTOP 
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
     
x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mese = "ito_mese = '" + WMESE + "'"
x_codi = "ito_codiva = '" + ALLTRIM(IVF_CODIVA) + "'"
x_tipo = "ito_clifor = 'F'"
x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
CSQL   = "select * from c_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
IF !ExecRW(CSQL,"c_iva_to","R")
   RETURN (.f.)
ENDIF 
SELECT c_iva_TO
GO TOP
IF !EOF()
   DO IVF_REP  
ELSE
   APPEND BLANK
   DO IVF_INS
ENDIF 
IF !ExecRW(cSql,"c_iva_TO","W")
   return(.f.)
ENDIF

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
COD_IVA      = ALLTRIM(COD_IVA)+"*"   && PER DISTINGUERE DA ALIQUOTA SOGGETTA

v_seek   = 'IVA'+ALLTRIM(COD_IVA)     
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DES_IVA   = SUBSTR(DESCRI,1,30)
ENDIF

** === > AGGIORNA  ARCHIVI IVA (DETTAGLI / TOTALE)
SELECT CC_IVF_CL
APPEND BLANK
REPLACE    IVF_TOP		 WITH WTOP 
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

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + PUB_ANNO + "'"
x_mese = "ito_mese = '" + WMESE + "'"
x_codi = "ito_codiva = '" + ALLTRIM(IVF_CODIVA) + "'"
x_tipo = "ito_clifor = 'F'"
x_fatt = "ito_fatnot = '" + ALLTRIM(XXX_FATNOT) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt
CSQL   = "select * from c_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
IF !ExecRW(CSQL,"c_iva_to","R")
   RETURN (.f.)
ENDIF 
SELECT c_iva_TO
GO TOP
IF !EOF()
   DO IVF_REP  
ELSE
   APPEND BLANK
   DO IVF_INS
ENDIF 
IF !ExecRW(cSql,"c_iva_TO","W")
   return(.f.)
ENDIF
     
RETURN


************************
PROCEDURE CORRISP       && GESTIONE MOVIMENTI IVA CORRISPETTIVI
************************

IF TMOV <> "VB"
	___CTC_CORRISP=___CTC_CORRISP+1		&& I CORRISPETTIVI PER VENDITA AL BANCO SONO CONTEGGIATI TRAMITE IL CURSORE DI SUPPORTO CURS_REGIS
ENDIF

SELECT Cc_iva_CL
APPEND BLANK
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


***********************************************************************************************
PROCEDURE IVAPERCA    
***********************************************************************************************
* ELABORA PAGAMENTI FORNITORI / INCASSI CLIENTI PER :
*
* -- IL CALCOLO DELLA % D'INCASSO/PAGAMENTO
* -- IL CALCOLO DEL VALORE IMPONIBILE/IMPOSTA/TOTALE DA RIPORTARE SUL BOLLATO EFFETTIVO U_IVA....
* -- L'AGGIORNAMENTO DEL VALORE PAGATO/INCASSATO SUGLI ARCHIVI IVA PER CASSA C_IVA....

* ________________________________OTTIENE LA DATA DI REGISTRAZIONE  
GIORNOFM = '31'
MESEX  =VAL(MESEDAL)
ANNOX  =VAL(PUB_ANNO)
BISESTILEX=(ANNOX/4)=INT(ANNOX/4)
DO CASE
  CASE MESEX=11 .OR. MESEX=4 .OR. MESEX=6 .OR. MESEX=9
     GIORNOFM ='30'
  CASE MESEX=2
     IF BISESTILEX
       GIORNOFM ='29'
     ELSE
       GIORNOFM ='28'
     ENDIF
  OTHERWISE
     GIORNOFM ='31'
ENDCASE
__DATA_DI_REGISTRAZIONE_FINE_MESE = PUB_ANNO+"/"+MESEDAL+"/"+GIORNOFM
* ________________________________OTTIENE LA DATA DI REGISTRAZIONE  


CREATE CURSOR cPAGAMENTI (MOV_CONTO C(13), PAR_DTFAT C(10), PAR_NUMFAT C(10), PAR_TOTFAT N(19,3), MOV_IMP N(19,3), MOV_PERC N(19,6),MOV_TOP C(10))
INDEX ON ALLTRIM(MOV_CONTO)+PAR_DTFAT+ALLTRIM(PAR_NUMFAT) TAG I_CONFAT
CREATE CURSOR cINCASSI   (MOV_CONTO C(13), PAR_DTFAT C(10), PAR_NUMFAT C(10), PAR_TOTFAT N(19,3), MOV_IMP N(19,3), MOV_PERC N(19,6),MOV_TOP C(10))
INDEX ON ALLTRIM(MOV_CONTO)+PAR_DTFAT+ALLTRIM(PAR_NUMFAT) TAG I_CONFAT


DATA_DA = RIBALTA2(DATADAL)
DATA_A  = RIBALTA2(DATAAL)

 
x_soci  = "mov_soc = '" + PUB_CODSOC + "'"
x_anno  = "mov_anno = '" + ANNODAL + "'"
x_datad = "mov_dtreg >= '" + DATA_DA + "'"
x_dataa = "mov_dtreg <= '" + DATA_A + "'"

x_cond = x_soci + " and " + x_anno + " and " + x_datad + " and " + x_dataa


cSql   = "SELECT MOV_CONT.*, " + ;
         "COALESCE(PF.PAR_DTFAT,'') AS PF_DTFAT, COALESCE(PF.PAR_NUMFAT,'') AS PF_NUMFAT, COALESCE(PF.PAR_FATT,0) AS PF_TOTFATT, " + ;
         "COALESCE(PC.PAR_DTFAT,'') AS PC_DTFAT, COALESCE(PC.PAR_NUMFAT,'') AS PC_NUMFAT, COALESCE(PC.PAR_FATT,0) AS PC_TOTFATT " + ;
         "FROM mov_cont " + ;
         "LEFT OUTER JOIN (SELECT PAR_NPART, PAR_NUMPRO, PAR_CODCLI FROM PART_FOR GROUP BY PAR_NPART, PAR_NUMPRO, PAR_CODCLI) AS PF1 ON PF1.PAR_NUMPRO = MOV_CONT.MOV_NUMPRO AND PF1.PAR_CODCLI = MOV_CONT.MOV_CONTO " + ;
         "LEFT OUTER JOIN PART_FOR AS PF ON PF.PAR_NPART = PF1.PAR_NPART AND PF.PAR_CODCLI = MOV_CONT.MOV_CONTO AND PF.PAR_NPROG = 100 " + ;
         "LEFT OUTER JOIN (SELECT PAR_NPART, PAR_NUMPRO, PAR_CODCLI FROM PART_CLI GROUP BY PAR_NPART, PAR_NUMPRO, PAR_CODCLI) AS PC1 ON PC1.PAR_NUMPRO = MOV_CONT.MOV_NUMPRO AND PC1.PAR_CODCLI = MOV_CONT.MOV_CONTO " + ;
         "LEFT OUTER JOIN PART_CLI AS PC ON PC.PAR_NPART = PC1.PAR_NPART AND PC.PAR_CODCLI = MOV_CONT.MOV_CONTO AND PC.PAR_NPROG = 100 " + ;
         "WHERE " + x_cond + " order by mov_soc,mov_anno,mov_dtreg,mov_numpro,mov_sequen"
IF !ExecCommand(cSql,"PIN_MOV_CONT")
   return(.f.)
ENDIF


SELECT PIN_MOV_CONT
GO TOP


RELEASE _STO_TRATTANDO_UN_CLIENTE 
PUBLIC  _STO_TRATTANDO_UN_CLIENTE 
_STO_TRATTANDO_UN_CLIENTE = .F.

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


*!*	.......................................................................................... VERIFICA CONTO CONTabile

   SELECT PIN_MOV_CONT
   XX_CONTO = MOV_CONTO
   XX_ANNO  = MOV_ANNO
   XX_NREGI = MOV_NREGIS  

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



   SELECT PIN_MOV_CONT

   WTOP   	= MOV_TOP
   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   			= SUBSTR(LIBERA,2,1)
      NOTAC 			= SUBSTR(LIBERA,11,1) 
      TMOV      		= SUBSTR(LIBERA,33,2)
      BOLL				= SUBSTR(LIBERA,9,1)
      NO_IVAPERCASSA 	= SUBSTR(LIBERA,57,1)	 
   ELSE
      FAT    			= SPACE(1)
      NOTAC 			= SPACE(1)
      TMOV      		= SPACE(2)
      BOLL				= SPACE(1)
      NO_IVAPERCASSA 	= SPACE(1)
   ENDIF

   SELECT PIN_MOV_CONT


   IF FAT <> 'P'							&& TRATTA SOLO I PAGAMENTI/INCASSI
	   IF FAT = 'S'	AND NOTAC = 'S'			&& ELABORA LE NOTE DI ACCREDITO
       ELSE
      	 SELECT PIN_MOV_CONT
	  	 SKIP +1
	  	 LOOP
	   ENDIF
   ENDIF



*!*	.......................................................................................... VERIFICA CLIENTI/FORNITORI



  **=> SERGIO - INIZIO 18/12/2021
  IF PUB_CONTOSIMILCEE
	   IF VERYCF_SIMILCEE(MOV_CONTO,"CF")
	   ELSE
	      SKIP +1
	      LOOP
	   ENDIF
  ELSE
	   IF VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CF")
	   ELSE
	      SKIP +1
	      LOOP
	   ENDIF
  ENDIF
  **=> SERGIO - FINE 18/12/2021 


*!*	.......................................................................................... SCRIVE IL CURSORE CON I RECORD CLIENTI / FORNITORI GUIDA PER IL TRATTAMENTO SUCCESSIVO 



   SELECT PIN_MOV_CONT
   SCATTER MEMVAR MEMO	
   

   DO CASE
   	
   	CASE TIPOCONTO = 'C'
   		SELECT cINCASSI					&& CLIENTI
		M.PAR_DTFAT  = M.PC_DTFAT
		M.PAR_NUMFAT = M.PC_NUMFAT
		M.PAR_TOTFAT = M.PC_TOTFATT
		
   	
   	CASE TIPOCONTO = 'F'
        SELECT cPAGAMENTI				&& cPAGAMENTI FORNITORI
		M.PAR_DTFAT  = M.PF_DTFAT
		M.PAR_NUMFAT = M.PF_NUMFAT
		M.PAR_TOTFAT = M.PF_TOTFATT

   		
    OTHERWISE   
	    
	    WAIT WINDOWS "ERRORE CAMPO TIPO CONTO DEL CONTO CONTABILE DEL PIANO DEI CONTI :"+M.MOV_CONTO
	    SELECT PIN_MOV_CONT
   		SKIP +1
        LOOP
   
   ENDCASE
   
   _SEEK = ALLTRIM(M.MOV_CONTO)+M.PAR_DTFAT+ALLTRIM(M.PAR_NUMFAT)
   SET ORDER TO I_CONFAT
   SEEK _SEEK
   IF !FOUND()
	   APPEND BLANK
	   GATHER MEMVAR MEMO
   ELSE
       REPLACE MOV_IMP WITH MOV_IMP + M.MOV_IMP
   ENDIF
   
   IF PAR_TOTFAT > 0
   	  REPLACE MOV_PERC WITH (MOV_IMP * 100) / PAR_TOTFAT
   ENDIF
   
   
   CTRELAB=CTRELAB+1 

   SELECT PIN_MOV_CONT
   SKIP +1

ENDDO


DO ELABORA_INCASSI_CLIENTI
DO ELABORA_NOTE_CREDITO_CLIENTI
DO RICALCOLA_TOTALI_INCASSI_CLIENTI
IF MESEDAL = '12' && PER IL SOLO MESE DI DICEMBRE VERIFICA TUTTE LA FATTURE ANCORA DA SALDARE PER TUTTO L'ANNO
	DO DETERMINA_SALDO_INCASSI_CLIENTI
ENDIF


DO ELABORA_PAGAMENTI_FORNITORI
DO ELABORA_NOTE_CREDITO_FORNITORI
DO RICALCOLA_TOTALI_PAGAMENTI_FORNITORI
IF MESEDAL = '12' && PER IL SOLO MESE DI DICEMBRE VERIFICA TUTTE LA FATTURE ANCORA DA SALDARE PER TUTTO L'ANNO
	DO DETERMINA_SALDO_PAGAMENTI_FORNITORI
ENDIF





RETURN

***********************************************************************************************
PROCEDURE ELABORA_PAGAMENTI_FORNITORI
***********************************************************************************************
** SE SI STA CARICANDO UN MESE DIVERSO DA DICEMBRE VERIFICA I PAGAMENTI EFFETTIVI , RICALCOLA 
** PERCENTUALE L'IMPORTO PAGATO NEL MESE E CREA IL BOLLATO IVA EFFETTIVO PER QUELL'IMPORTO
**

* CREAZIONE CURSORE

IF !ExecCommand("select * from U_IVF_cl where 0=1","cU_IVF_cl")
   return(.f.)
ENDIF

*==>>> ANNULLO DEL BOLLATO PRECEDENTE 

x_soci = "ivf_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ivf_anno = '" + ANNODAL + "'"
x_mese = "ivf_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese
CSQL   = "delete from U_IVF_cl where " + x_cond
IF !ExecCommand(CSQL,"U_IVF_CL")
   RETURN (.f.)
ENDIF 

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNODAL + "'"
x_mese = "ito_mese = '" + MESEDAL + "'"
x_tipo = "(ito_clifor = 'F' or ito_clifor = 'E' or ito_clifor = 'R')"    && CANCELLO SOLO I RECORD CON ITO_CLIFOR = 'F'
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_tipo
CSQL   = "delete from u_iva_to where " + x_cond
IF !ExecCommand(CSQL,"u_iva_TO")
   RETURN (.f.)
ENDIF 


* ELABORA cPAGAMENTI FORNITORI PER RIPORTARE LA FATTURA SUL BOLLATO IVA IN FUNZIONE DELL'IMPORTO PAGATO EFFETTIVO


SELECT cPAGAMENTI
GO TOP

DO WHILE .NOT. EOF()

	IF DELETED()
		SELECT cPAGAMENTI
		SKIP +1
		LOOP
	ENDIF


    SCATTER MEMVAR MEMO




   WTOP   	= M.MOV_TOP
   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   			= SUBSTR(LIBERA,2,1)
      NOTAC 			= SUBSTR(LIBERA,11,1) 
      TMOV      		= SUBSTR(LIBERA,33,2)
      BOLL				= SUBSTR(LIBERA,9,1)
      NO_IVAPERCASSA 	= SUBSTR(LIBERA,57,1)	 
   ELSE
      FAT    			= SPACE(1)
      NOTAC 			= SPACE(1)
      TMOV      		= SPACE(2)
      BOLL				= SPACE(1)
      NO_IVAPERCASSA 	= SPACE(1)
   ENDIF

   SELECT PIN_MOV_CONT

   IF FAT <> 'P'				&& TRATTA SOLO I PAGAMENTI/INCASSI
      SELECT cPAGAMENTI
	  SKIP +1
	  LOOP
   ENDIF





	** ACCESSO A C_IVF_CL PER ELABORARE La FATTURA E IN BASE ALLA % DI PAGAMENTO DETERMINO GLI IMPORTI DA CARICARE SUL BOLLATO EFFETTIVO
    
  	  * 18/12/2021 SERGIO INIZIO
 	  IF PUB_CONTOSIMILCEE
		    _CODCLI = SCORPRA_CODICE_CLIENTE_FORNITORE_SE_SIMILCEE(M.MOV_CONTO)
	  ELSE
		    _CODCLI = SUBSTR(M.MOV_CONTO,PUB_SOTTOG,13)
	  ENDIF
 	  * 18/12/2021 SERGIO FINE   
    
    
    x_codi  = "ivf_codcli = '" + ALLTRIM(_CODCLI) + "'"
    x_datf  = "ivf_dtfatt = '" + M.PAR_DTFAT + "'"
    x_numf  = "ivf_numfat = '" + ALLTRIM(M.PAR_NUMFAT)  + "'" 
    
    x_cond  = x_codi + " and " + x_datf  + " and " + x_numf  
    Csql    = "select * from c_ivf_cl where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"


    IF !ExecCommand(CSQL,"c_ivf_cl")
      return(.f.)
    ENDIF
    
    SELECT c_ivf_cl
    GO TOP

    __TOTALE_PAGATO_AL_MOMENTO = 0
    __PAGATO_EFFETTIVO_MESE    = M.MOV_IMP
    __PERCENTUALE_PAGATA       = M.MOV_PERC 

    IF !EOF() 
    
      	SUM PIN_TOTALE TO __TOTALE_PAGATO_IN_PRECEDENZA

	    IF __TOTALE_PAGATO_IN_PRECEDENZA => M.PAR_TOTFAT  && SE HO PAGATO TUTTO SALTO IL PAGAMENTO DELLA FATTURA
	    
			SELECT cPAGAMENTI
			SKIP +1
			LOOP       
	    
	    ENDIF
 
        * CALCOLO DEL TOTALE PAGATO AL MOMENTO 
        __TOTALE_PAGATO_AL_MOMENTO = __TOTALE_PAGATO_IN_PRECEDENZA  + M.MOV_IMP
        __PAGATO_EFFETTIVO_MESE    = 0
        
        IF __TOTALE_PAGATO_AL_MOMENTO > M.PAR_TOTFAT
           ** CALCOLO LA DIFFERENZA DA TOGLIERE DAL TOTALE PAGATO DEL MESE
           __DIFFERENZA_PAGATA      = __TOTALE_PAGATO_AL_MOMENTO - M.PAR_TOTFAT
           __PAGATO_EFFETTIVO_MESE  = M.MOV_IMP - __DIFFERENZA_PAGATA 

        ELSE 
        	__PAGATO_EFFETTIVO_MESE  = M.MOV_IMP
        ENDIF 
      
    ENDIF 
    
    __PERCENTUALE_PAGATA  =  (__PAGATO_EFFETTIVO_MESE  * 100) / M.PAR_TOTFAT		&& RICALCOLA LA % PAGATA IN QUANTO POTREBBERO ESSERCI DELLE DIFFERENZE
 

    SELECT c_ivf_cl
    GO TOP
 
    _SOLO_PRIMA_VOLTA = .T.
    
    DO WHILE .NOT. EOF()

        SCATTER MEMVAR MEMO
 
 
		IF _SOLO_PRIMA_VOLTA
		
			_SOLO_PRIMA_VOLTA = .F.
			
	        IF M.IVF_FATNOT = 'F'
	        	___PIN_CTF_FOR	= ___PIN_CTF_FOR	+ 1
	        ENDIF      	
	        IF M.IVF_FATNOT = 'N'
	        	___PIN_CTN_FOR	= ___PIN_CTN_FOR	+ 1
	        ENDIF   
		
		ENDIF

		SELECT cU_IVF_cl
		APPEND BLANK 
		GATHER MEMVAR MEMO
        
        REPLACE IVF_MESE   WITH MESEDAL 
        REPLACE IVF_DTCREA WITH __DATA_DI_REGISTRAZIONE_FINE_MESE 
  
		_IMPONI_RICALCOLATO = (M.IVF_IMPONI * __PERCENTUALE_PAGATA) / 100
		_IMPOST_RICALCOLATO = (M.IVF_IMPOST * __PERCENTUALE_PAGATA) / 100
		_TOTALE_RICALCOLATO = (M.IVF_TOTALE * __PERCENTUALE_PAGATA) / 100
  
        
		REPLACE IVF_IMPONI WITH _IMPONI_RICALCOLATO 
		REPLACE IVF_IMPOST WITH _IMPOST_RICALCOLATO 
		REPLACE IVF_TOTALE WITH _TOTALE_RICALCOLATO 

		         
		WFR         	= .F.   && FATTURA IN RITARDO      
		WMESE           = MESEDAL
		WDTREG			= __DATA_DI_REGISTRAZIONE_FINE_MESE 
		DES_IVA			= M.IVF_DESIVA
		IMPONIBILE      = IVF_IMPONI && APPENA AGGIORNATO           
        IMPOSTA			= IVF_IMPOST 
        *PUB_CEEUNO 
        COD_IVA			= M.IVF_CODIVA
 

 	    v_seek	= 'TOP'+ALLTRIM(M.IVF_TOP)
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
	   
        v_seek	  = 'IVA'+ALLTRIM(M.IVF_CODIVA)     
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

        x_tipo = "ito_clifor = 'F'"

        IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
        ELSE
	         IF CEE = "E"
	            x_tipo = "ito_clifor = 'E'"
	         ENDIF
		ENDIF
       
         
        x_soci  = "ito_codsoc = '" + PUB_CODSOC + "'"
        x_anno  = "ito_anno = '" + PUB_ANNO + "'"
        x_mese  = "ito_mese = '" + MESEDAL+ "'"
        x_codi  = "ito_codiva = '" + ALLTRIM(M.IVF_CODIVA) + "'"
        x_fatt  = "ito_fatnot = '" + ALLTRIM(M.IVF_FATNOT) + "'"
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
		

		SELECT c_ivf_cl
		SKIP +1

    ENDDO


	
	SELECT cPAGAMENTI
	SKIP +1
	
ENDDO


IF !ExecRW('','U_IVF_cl','I','','CU_IVF_CL')
   return(.f.)
ENDIF




RETURN



***********************************************************************************************
PROCEDURE ELABORA_NOTE_CREDITO_FORNITORI
***********************************************************************************************
** ELABORA SOLO LE NOTE DI ACCREDITO CONSIDERANDOLE PAGATE/INCASSATE
**

* CREAZIONE CURSORE

IF !ExecCommand("select * from U_IVF_cl where 0=1","cU_IVF_cl")
   return(.f.)
ENDIF



* ELABORA NOTE DI ACCREDITO PER RIPORTARE LA FATTURA SUL BOLLATO IVA 


SELECT cPAGAMENTI
GO TOP

DO WHILE .NOT. EOF()

	IF DELETED()
		SELECT cPAGAMENTI
		SKIP +1
		LOOP
	ENDIF


    SCATTER MEMVAR MEMO

   WTOP   	= M.MOV_TOP
   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   			= SUBSTR(LIBERA,2,1)
      NOTAC 			= SUBSTR(LIBERA,11,1) 
      TMOV      		= SUBSTR(LIBERA,33,2)
      BOLL				= SUBSTR(LIBERA,9,1)
      NO_IVAPERCASSA 	= SUBSTR(LIBERA,57,1)	 
   ELSE
      FAT    			= SPACE(1)
      NOTAC 			= SPACE(1)
      TMOV      		= SPACE(2)
      BOLL				= SPACE(1)
      NO_IVAPERCASSA 	= SPACE(1)
   ENDIF

   SELECT PIN_MOV_CONT

   IF FAT = 'S'	AND NOTAC = 'S'			&& TRATTA SOLO LE NOTE ACCREDITO
   ELSE
   	 SELECT cPAGAMENTI
	 SKIP +1
	 LOOP
   ENDIF


	** ACCESSO A C_IVF_CL PER ELABORARE LA NOTA DI ACCREDITO CONSIDERATA PAGATA/INCASSATA COMPLETAMENTE

  	  * 18/12/2021 SERGIO INIZIO
 	  IF PUB_CONTOSIMILCEE
		    _CODCLI = SCORPRA_CODICE_CLIENTE_FORNITORE_SE_SIMILCEE(M.MOV_CONTO)
	  ELSE
		    _CODCLI = SUBSTR(M.MOV_CONTO,PUB_SOTTOG,13)
	  ENDIF
 	  * 18/12/2021 SERGIO FINE   
        
    x_codi  = "ivf_codcli = '" + ALLTRIM(_CODCLI) + "'"
    x_datf  = "ivf_dtfatt = '" + M.PAR_DTFAT + "'"
    x_numf  = "ivf_numfat = '" + ALLTRIM(M.PAR_NUMFAT)  + "'" 
    
    x_cond  = x_codi + " and " + x_datf  + " and " + x_numf  
    Csql    = "select * from c_ivf_cl where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"


    IF !ExecCommand(CSQL,"c_ivf_cl")
      return(.f.)
    ENDIF
    
    SELECT c_ivf_cl
    GO TOP
 
    _SOLO_PRIMA_VOLTA = .T.
    
    DO WHILE .NOT. EOF()

        SCATTER MEMVAR MEMO
 
 
		IF _SOLO_PRIMA_VOLTA
		
			_SOLO_PRIMA_VOLTA = .F.
			
	        IF M.IVF_FATNOT = 'N'
	        	___PIN_CTN_FOR	= ___PIN_CTN_FOR	+ 1
	        ENDIF   
		
		ENDIF

		SELECT cU_IVF_cl
		APPEND BLANK 
		GATHER MEMVAR MEMO
        
        REPLACE IVF_MESE   WITH MESEDAL 
        REPLACE IVF_DTCREA WITH __DATA_DI_REGISTRAZIONE_FINE_MESE 
  
		_IMPONI_RICALCOLATO = M.IVF_IMPONI 
		_IMPOST_RICALCOLATO = M.IVF_IMPOST 
		_TOTALE_RICALCOLATO = M.IVF_TOTALE   
        
		REPLACE IVF_IMPONI WITH _IMPONI_RICALCOLATO 
		REPLACE IVF_IMPOST WITH _IMPOST_RICALCOLATO 
		REPLACE IVF_TOTALE WITH _TOTALE_RICALCOLATO 

		         
		WFR         	= .F.   && FATTURA IN RITARDO      
		WMESE           = MESEDAL
		WDTREG			= __DATA_DI_REGISTRAZIONE_FINE_MESE 
		DES_IVA			= M.IVF_DESIVA
		IMPONIBILE      = IVF_IMPONI && APPENA AGGIORNATO           
        IMPOSTA			= IVF_IMPOST 
        *PUB_CEEUNO 
        COD_IVA			= M.IVF_CODIVA
 

 	    v_seek	= 'TOP'+ALLTRIM(M.IVF_TOP)
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
	   
        v_seek	  = 'IVA'+ALLTRIM(M.IVF_CODIVA)     
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

        x_tipo = "ito_clifor = 'F'"

        IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
        ELSE
	         IF CEE = "E"
	            x_tipo = "ito_clifor = 'E'"
	         ENDIF
		ENDIF
       
         
        x_soci  = "ito_codsoc = '" + PUB_CODSOC + "'"
        x_anno  = "ito_anno = '" + PUB_ANNO + "'"
        x_mese  = "ito_mese = '" + MESEDAL+ "'"
        x_codi  = "ito_codiva = '" + ALLTRIM(M.IVF_CODIVA) + "'"
        x_fatt  = "ito_fatnot = '" + ALLTRIM(M.IVF_FATNOT) + "'"
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
		

		SELECT c_ivf_cl
		SKIP +1

    ENDDO


	
	SELECT cPAGAMENTI
	SKIP +1
	
ENDDO


IF !ExecRW('','U_IVF_cl','I','','CU_IVF_CL')
   return(.f.)
ENDIF


RETURN



***********************************************************************************************
PROCEDURE RICALCOLA_TOTALI_PAGAMENTI_FORNITORI
***********************************************************************************************
*!*	AGGIORNA IMPORTO PAGATO IN ARCHIVIO STORICO C_IVA.....



** ###################################################### AZZERA IMPORTO PAGATO DI TUTTO L'ANNO IN C_IVA.... ######################################################

x_soci = "ivf_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ivf_anno = '" + ANNODAL + "'"
x_cond = x_soci + " and " + x_anno  
Csql    = "select * from C_IVF_CL where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"
IF !ExecCommand(CSQL,"C_IVF_CL")
   RETURN (.f.)
ENDIF 

SELECT C_IVF_CL
GO TOP
DO WHILE .NOT. EOF()

	REPLACE PIN_IMPONI WITH 0 		 
	REPLACE PIN_IMPOST WITH 0 		 
	REPLACE PIN_TOTALE WITH 0 		 		

	SELECT C_IVF_CL
	SKIP +1

ENDDO

IF !ExecRW('','C_IVF_CL','I','','C_IVF_CL')
   return(.f.)
ENDIF		

** ###################################################### RICALCOLA IMPORTO PAGATO  DI TUTTO L'ANNO ######################################################


x_soci = "ivf_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ivf_anno = '" + ANNODAL + "'"
x_cond = x_soci + " and " + x_anno 
Csql    = "select * from U_IVF_CL where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"
IF !ExecCommand(CSQL,"U_IVF_CL")
   RETURN (.f.)
ENDIF 

SELECT U_IVF_CL
GO TOP
DO WHILE .NOT. EOF()


	SCATTER MEMVAR MEMO


	** ACCESSO A C_IVF_CL PER SOMMARE IL VALORE PAGATO IN FUNZIONE DELL'ALIQUOTA IVA E DEL TIPO FATTURA

    x_codcf  = "ivf_codcli = '" + ALLTRIM(M.IVF_CODCLI) + "'"
    x_datf   = "ivf_dtfatt = '" + M.IVF_DTFATT + "'"
    x_numf   = "ivf_numfat = '" + ALLTRIM(M.IVF_NUMFAT)  + "'" 
    x_codi   = "ivf_codiva = '" + ALLTRIM(M.IVF_CODIVA) + "'"
    x_fatt   = "ivf_fatnot = '" + ALLTRIM(M.IVF_FATNOT) + "'"
    
    x_cond  = x_codcf + " and " + x_datf  + " and " + x_numf  + " and " + x_fatt + " and " + x_codi 

    Csql    = "select * from c_ivf_cl where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"

    IF !ExecRW(CSQL,"c_ivf_cl","R")
      return(.f.)
    ENDIF
    
    SELECT c_ivf_cl
	REPLACE PIN_IMPONI WITH PIN_IMPONI + M.IVF_IMPONI 		 
	REPLACE PIN_IMPOST WITH PIN_IMPOST + M.IVF_IMPOST 		 
	REPLACE PIN_TOTALE WITH PIN_TOTALE + M.IVF_TOTALE 		 		



    IF !ExecRW(cSql,"c_ivf_cl","W")
       return(.f.)
    ENDIF
		

	SELECT U_IVF_CL
	SKIP +1

ENDDO

RETURN







***********************************************************************************************
PROCEDURE DETERMINA_SALDO_PAGAMENTI_FORNITORI
***********************************************************************************************
** PER IL MESE DI DICEMBRE :
**     LA PROCEDURA ELABORA TUTTE LE FATTURE ANCORA DA PAGARE DALL'ARCHIVIO STORICO C_IVF_CL ,
**     CALCOLA L'IMPORTO RESIDUO PER IL SALDO E CREA IL BOLLATO IVA EFFETTIVO 
**

* CREAZIONE CURSORE

IF !ExecCommand("select * from U_IVF_cl where 0=1","cU_IVF_cl")
   return(.f.)
ENDIF

___PIN_CTF_FOR = 0


** ACCESSO A C_IVF_CL PER ELABORARE TUTTE LE FATTURE ANCORA DA PAGARE PER LA CHIUSURA DEFINITIVA DELL'IVA DI CASSA

cSql=""     
cNomeCursorSql="cPAGAMENTI_A_SALDO"
			
TEXT TO cSql NOSHOW

	SELECT
		ivf_codcli,
		ivf_dtfatt,
		ivf_numfat,
		sum(ivf_totale) as par_totale
	FROM c_ivf_cl
	GROUP BY ivf_codcli,ivf_dtfatt,ivf_numfat 
	ORDER BY ivf_codcli,ivf_dtfatt,ivf_numfat
	
ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	



SELECT cPAGAMENTI_A_SALDO
GO TOP

DO WHILE .NOT. EOF()

	IF DELETED()
		SELECT cPAGAMENTI_A_SALDO
		SKIP +1
		LOOP
	ENDIF


    SCATTER MEMVAR MEMO



	** ACCESSO A C_IVF_CL PER ELABORARE La FATTURA E IN BASE ALLA % DI PAGAMENTO DETERMINO GLI IMPORTI DA CARICARE SUL BPLLATO EFFETTIVO

    x_codi  = "ivf_codcli = '" + ALLTRIM(m.ivf_codcli) + "'"
    x_datf  = "ivf_dtfatt = '" + M.ivf_dtfatt + "'"
    x_numf  = "ivf_numfat = '" + ALLTRIM(M.ivf_numfat)  + "'" 
    x_cond  = x_codi + " and " + x_datf  + " and " + x_numf  
    Csql    = "select * from c_ivf_cl where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"


    IF !ExecCommand(CSQL,"c_ivf_cl")
      return(.f.)
    ENDIF

	SELECT c_ivf_cl
	GO TOP
	 
	_SOLO_PRIMA_VOLTA = .T.

	DO WHILE .NOT. EOF()

	    SCATTER MEMVAR MEMO
	 
		IF M.PIN_TOTALE	=> M.IVF_TOTALE  	&& SE RIGA FATTURA SALDATA LA SCARTA
			SELECT c_ivf_cl
			SKIP +1
			LOOP
		ENDIF
	 
		IF _SOLO_PRIMA_VOLTA
		
			_SOLO_PRIMA_VOLTA = .F.
			
	        IF M.IVF_FATNOT = 'F'
	        	___PIN_CTF_FOR	= ___PIN_CTF_FOR	+ 1
	        ENDIF      	
	        IF M.IVF_FATNOT = 'N'
	        	___PIN_CTN_FOR	= ___PIN_CTN_FOR	+ 1
	        ENDIF   
		
		ENDIF

		SELECT cU_IVF_cl
		APPEND BLANK 
		GATHER MEMVAR MEMO
	    
	    REPLACE IVF_MESE   WITH MESEDAL 
	    REPLACE IVF_DTCREA WITH __DATA_DI_REGISTRAZIONE_FINE_MESE 
	  
		_IMPONI_RICALCOLATO = M.IVF_IMPONI - M.PIN_IMPONI 
		_IMPOST_RICALCOLATO = M.IVF_IMPOST - M.PIN_IMPOST
		_TOTALE_RICALCOLATO = M.IVF_TOTALE - M.PIN_TOTALE
	  
	    
		REPLACE IVF_IMPONI WITH _IMPONI_RICALCOLATO 
		REPLACE IVF_IMPOST WITH _IMPOST_RICALCOLATO 
		REPLACE IVF_TOTALE WITH _TOTALE_RICALCOLATO 

		         
		WFR         	= .F.   && FATTURA IN RITARDO      
		WMESE           = MESEDAL
		WDTREG			= __DATA_DI_REGISTRAZIONE_FINE_MESE 
		DES_IVA			= M.IVF_DESIVA
		IMPONIBILE      = IVF_IMPONI && APPENA AGGIORNATO           
	    IMPOSTA			= IVF_IMPOST 
	    *PUB_CEEUNO 
	    COD_IVA			= M.IVF_CODIVA
	 

	 	v_seek	 = 'TOP'+ALLTRIM(M.IVF_TOP)
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
	   
	    v_seek	  = 'IVA'+ALLTRIM(M.IVF_CODIVA)     
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

	    x_tipo = "ito_clifor = 'F'"

	    IF PUB_CEEUNO && NON GESTISCE I FORNITORI CEE LI STAMPA IN UN UNICO BOLLATO IVA FORNITORI NAZIONALI
	    ELSE
	         IF CEE = "E"
	            x_tipo = "ito_clifor = 'E'"
	         ENDIF
		ENDIF
	   
	     
	    x_soci  = "ito_codsoc = '" + PUB_CODSOC + "'"
	    x_anno  = "ito_anno = '" + PUB_ANNO + "'"
	    x_mese  = "ito_mese = '" + MESEDAL+ "'"
	    x_codi  = "ito_codiva = '" + ALLTRIM(M.IVF_CODIVA) + "'"
	    x_fatt  = "ito_fatnot = '" + ALLTRIM(M.IVF_FATNOT) + "'"
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
		

		SELECT c_ivf_cl
		SKIP +1

	ENDDO


	SELECT cPAGAMENTI_A_SALDO
	SKIP +1


ENDDO WHILE .NOT. EOF()



IF !ExecRW('','U_IVF_cl','I','','CU_IVF_CL')
   return(.f.)
ENDIF



*!*	AGGIORNA IMPORTO PAGATO IN ARCHIVIO STORICO C_IVA.....



** ###################################################### AZZERA IMPORTO PAGATO DI TUTTO L'ANNO IN C_IVA.... ######################################################

x_soci = "ivf_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ivf_anno = '" + ANNODAL + "'"
x_cond = x_soci + " and " + x_anno  
Csql    = "select * from C_IVF_CL where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"
IF !ExecCommand(CSQL,"C_IVF_CL")
   RETURN (.f.)
ENDIF 

SELECT C_IVF_CL
GO TOP
DO WHILE .NOT. EOF()

	REPLACE PIN_IMPONI WITH 0 		 
	REPLACE PIN_IMPOST WITH 0 		 
	REPLACE PIN_TOTALE WITH 0 		 		

	SELECT C_IVF_CL
	SKIP +1

ENDDO

IF !ExecRW('','C_IVF_CL','I','','C_IVF_CL')
   return(.f.)
ENDIF		

** ###################################################### RICALCOLA IMPORTO PAGATO  DI TUTTO L'ANNO ######################################################


x_soci = "ivf_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ivf_anno = '" + ANNODAL + "'"
x_cond = x_soci + " and " + x_anno 
Csql    = "select * from U_IVF_CL where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"
IF !ExecCommand(CSQL,"U_IVF_CL")
   RETURN (.f.)
ENDIF 

SELECT U_IVF_CL
GO TOP
DO WHILE .NOT. EOF()


	SCATTER MEMVAR MEMO


	** ACCESSO A C_IVF_CL PER SOMMARE IL VALORE PAGATO IN FUNZIONE DELL'ALIQUOTA IVA E DEL TIPO FATTURA

    x_codcf  = "ivf_codcli = '" + ALLTRIM(M.IVF_CODCLI) + "'"
    x_datf   = "ivf_dtfatt = '" + M.IVF_DTFATT + "'"
    x_numf   = "ivf_numfat = '" + ALLTRIM(M.IVF_NUMFAT)  + "'" 
    x_codi   = "ivf_codiva = '" + ALLTRIM(M.IVF_CODIVA) + "'"
    x_fatt   = "ivf_fatnot = '" + ALLTRIM(M.IVF_FATNOT) + "'"
    
    x_cond  = x_codcf + " and " + x_datf  + " and " + x_numf  + " and " + x_fatt + " and " + x_codi 

    Csql    = "select * from c_ivf_cl where " + x_cond + " order by ivf_codcli ,ivf_dtfatt,ivf_numfat"

    IF !ExecRW(CSQL,"c_ivf_cl","R")
      return(.f.)
    ENDIF
    
    SELECT c_ivf_cl
	REPLACE PIN_IMPONI WITH PIN_IMPONI + M.IVF_IMPONI 		 
	REPLACE PIN_IMPOST WITH PIN_IMPOST + M.IVF_IMPOST 		 
	REPLACE PIN_TOTALE WITH PIN_TOTALE + M.IVF_TOTALE 		 		



    IF !ExecRW(cSql,"c_ivf_cl","W")
       return(.f.)
    ENDIF
		

	SELECT U_IVF_CL
	SKIP +1

ENDDO


RETURN




***********************************************************************************************
PROCEDURE ELABORA_INCASSI_CLIENTI
***********************************************************************************************
** SE SI STA CARICANDO UN MESE DIVERSO DA DICEMBRE VERIFICA GLI INCASSI EFFETTIVI , RICALCOLA 
** PERCENTUALE L'IMPORTO INCASSATO NEL MESE E CREA IL BOLLATO IVA EFFETTIVO PER QUELL'IMPORTO
**

* CREAZIONE CURSORE

IF !ExecCommand("select * from U_IVA_CL where 0=1","cU_IVA_CL")
   return(.f.)
ENDIF

*==>>> ANNULLO DEL BOLLATO PRECEDENTE 

x_soci = "IVA_codsoc = '" + PUB_CODSOC + "'"
x_anno = "IVA_anno = '" + ANNODAL + "'"
x_mese = "IVA_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese
CSQL   = "delete from U_IVA_CL where " + x_cond
IF !ExecCommand(CSQL,"U_IVA_CL")
   RETURN (.f.)
ENDIF 



x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNODAL + "'"
x_mese = "ito_mese = '" + MESEDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese 
CSQL   = "delete from U_IVA_TO where " + x_cond
IF !ExecCommand(CSQL,"U_IVA_TO")
   RETURN (.f.)
ENDIF 

* ELABORA cINCASSI CLIENTI PER RIPORTARE LA FATTURA SUL BOLLATO IVA IN FUNZIONE DELL'IMPORTO INCASSATO EFFETTIVO


SELECT cINCASSI
GO TOP

DO WHILE .NOT. EOF()

	IF DELETED()
		SELECT cINCASSI
		SKIP +1
		LOOP
	ENDIF


    SCATTER MEMVAR MEMO




   WTOP   	= M.MOV_TOP
   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   			= SUBSTR(LIBERA,2,1)
      NOTAC 			= SUBSTR(LIBERA,11,1) 
      TMOV      		= SUBSTR(LIBERA,33,2)
      BOLL				= SUBSTR(LIBERA,9,1)
      NO_IVAPERCASSA 	= SUBSTR(LIBERA,57,1)	 
   ELSE
      FAT    			= SPACE(1)
      NOTAC 			= SPACE(1)
      TMOV      		= SPACE(2)
      BOLL				= SPACE(1)
      NO_IVAPERCASSA 	= SPACE(1)
   ENDIF

   SELECT PIN_MOV_CONT

   IF FAT <> 'P'				&& TRATTA SOLO I INCASSI
      SELECT cINCASSI
	  SKIP +1
	  LOOP
   ENDIF





	** ACCESSO A C_IVA_CL PER ELABORARE La FATTURA E IN BASE ALLA % DI PAGAMENTO DETERMINO GLI IMPORTI DA CARICARE SUL BOLLATO EFFETTIVO

  	  * 18/12/2021 SERGIO INIZIO
 	  IF PUB_CONTOSIMILCEE
		    _CODCLI = SCORPRA_CODICE_CLIENTE_FORNITORE_SE_SIMILCEE(M.MOV_CONTO)
	  ELSE
		    _CODCLI = SUBSTR(M.MOV_CONTO,PUB_SOTTOG,13)
	  ENDIF
 	  * 18/12/2021 SERGIO FINE   
        
    
    x_codi  = "IVA_codcli = '" + ALLTRIM(_CODCLI) + "'"
    x_datf  = "IVA_dtfatt = '" + M.PAR_DTFAT + "'"
    x_numf  = "IVA_numfat = '" + ALLTRIM(M.PAR_NUMFAT)  + "'" 
    
    x_cond  = x_codi + " and " + x_datf  + " and " + x_numf  
    Csql    = "select * from C_IVA_CL where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"


    IF !ExecCommand(CSQL,"C_IVA_CL")
      return(.f.)
    ENDIF
    
    SELECT C_IVA_CL
    GO TOP

    __TOTALE_INCASSATO_AL_MOMENTO = 0
    __INCASSATO_EFFETTIVO_MESE    = M.MOV_IMP
    __PERCENTUALE_INCASSATA       = M.MOV_PERC 

    IF !EOF() 
    
      	SUM PIN_TOTALE TO __TOTALE_INCASSATO_IN_PRECEDENZA

	    IF __TOTALE_INCASSATO_IN_PRECEDENZA => M.PAR_TOTFAT  && SE HO INCASSATO TUTTO SALTO IL PAGAMENTO DELLA FATTURA
	    
			SELECT cINCASSI
			SKIP +1
			LOOP       
	    
	    ENDIF
 
        * CALCOLO DEL TOTALE INCASSATO AL MOMENTO 
        __TOTALE_INCASSATO_AL_MOMENTO = __TOTALE_INCASSATO_IN_PRECEDENZA  + M.MOV_IMP
        __INCASSATO_EFFETTIVO_MESE    = 0
        
        IF __TOTALE_INCASSATO_AL_MOMENTO > M.PAR_TOTFAT
           ** CALCOLO LA DIFFERENZA DA TOGLIERE DAL TOTALE INCASSATO DEL MESE
           __DIFFERENZA_INCASSATA      = __TOTALE_INCASSATO_AL_MOMENTO - M.PAR_TOTFAT
           __INCASSATO_EFFETTIVO_MESE  = M.MOV_IMP - __DIFFERENZA_INCASSATA 

        ELSE 
        	__INCASSATO_EFFETTIVO_MESE  = M.MOV_IMP
        ENDIF 
      
    ENDIF 
    
    __PERCENTUALE_INCASSATA  =  (__INCASSATO_EFFETTIVO_MESE  * 100) / M.PAR_TOTFAT		&& RICALCOLA LA % INCASSATA IN QUANTO POTREBBERO ESSERCI DELLE DIFFERENZE
 

    SELECT C_IVA_CL
    GO TOP
 
    _SOLO_PRIMA_VOLTA = .T.
    
    DO WHILE .NOT. EOF()

        SCATTER MEMVAR MEMO
 
 
		IF _SOLO_PRIMA_VOLTA
		
			_SOLO_PRIMA_VOLTA = .F.
			
	        IF M.IVA_FATNOT = 'F'
	        	___PIN_CTF_CLI	= ___PIN_CTF_CLI	+ 1
	        ENDIF      	
	        IF M.IVA_FATNOT = 'N'
	        	___PIN_CTN_CLI	= ___PIN_CTN_CLI	+ 1
	        ENDIF   
		
		ENDIF

		SELECT cU_IVA_CL
		APPEND BLANK 
		GATHER MEMVAR MEMO
        
        REPLACE IVA_MESE   WITH MESEDAL 
        REPLACE IVA_DTCREA WITH __DATA_DI_REGISTRAZIONE_FINE_MESE 
  
		_IMPONI_RICALCOLATO = (M.IVA_IMPONI * __PERCENTUALE_INCASSATA) / 100
		_IMPOST_RICALCOLATO = (M.IVA_IMPOST * __PERCENTUALE_INCASSATA) / 100
		_TOTALE_RICALCOLATO = (M.IVA_TOTALE * __PERCENTUALE_INCASSATA) / 100
  
        
		REPLACE IVA_IMPONI WITH _IMPONI_RICALCOLATO 
		REPLACE IVA_IMPOST WITH _IMPOST_RICALCOLATO 
		REPLACE IVA_TOTALE WITH _TOTALE_RICALCOLATO 

		         
		WFR         	= .F.   && FATTURA IN RITARDO      
		WMESE           = MESEDAL
		WDTREG			= __DATA_DI_REGISTRAZIONE_FINE_MESE 
		DES_IVA			= M.IVA_DESIVA
		IMPONIBILE      = IVA_IMPONI && APPENA AGGIORNATO           
        IMPOSTA			= IVA_IMPOST 
        *PUB_CEEUNO 
        COD_IVA			= M.IVA_CODIVA
 

 	    v_seek	= 'TOP'+ALLTRIM(M.IVA_TOP)
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
	   
        v_seek	  = 'IVA'+ALLTRIM(M.IVA_CODIVA)     
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

  
       
        x_soci  = "ito_codsoc = '" + PUB_CODSOC + "'"
        x_anno  = "ito_anno = '" + PUB_ANNO + "'"
        x_mese  = "ito_mese = '" + MESEDAL+ "'"
        x_codi  = "ito_codiva = '" + ALLTRIM(M.IVA_CODIVA) + "'"
        x_fatt  = "ito_fatnot = '" + ALLTRIM(M.IVA_FATNOT) + "'"
        x_fatt1 = "ito_clifor = 'C'"


        x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_codi  + " and " + x_tipo + " and " + x_fatt 
        CSQL   = "select * from U_IVA_TO where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
        IF !ExecRW(CSQL,"U_IVA_TO","R")
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
		

		SELECT C_IVA_CL
		SKIP +1

    ENDDO


	
	SELECT cINCASSI
	SKIP +1
	
ENDDO


IF !ExecRW('','U_IVA_CL','I','','CU_IVA_CL')
   return(.f.)
ENDIF




RETURN


***********************************************************************************************
PROCEDURE ELABORA_NOTE_CREDITO_CLIENTI
***********************************************************************************************
** ELABORA SOLO LE NOTE DI ACCREDITO CONSIDERANDOLE PAGATE/INCASSATE
**

* CREAZIONE CURSORE

IF !ExecCommand("select * from U_IVA_CL where 0=1","cU_IVA_CL")
   return(.f.)
ENDIF



* ELABORA NOTE DI ACCREDITO PER RIPORTARE LA FATTURA SUL BOLLATO IVA 


SELECT cINCASSI
GO TOP

DO WHILE .NOT. EOF()

    IF DELETED()
		SELECT cINCASSI
		SKIP +1
		LOOP
	ENDIF


   SCATTER MEMVAR MEMO

   WTOP   	= M.MOV_TOP
   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   			= SUBSTR(LIBERA,2,1)
      NOTAC 			= SUBSTR(LIBERA,11,1) 
      TMOV      		= SUBSTR(LIBERA,33,2)
      BOLL				= SUBSTR(LIBERA,9,1)
      NO_IVAPERCASSA 	= SUBSTR(LIBERA,57,1)	 
   ELSE
      FAT    			= SPACE(1)
      NOTAC 			= SPACE(1)
      TMOV      		= SPACE(2)
      BOLL				= SPACE(1)
      NO_IVAPERCASSA 	= SPACE(1)
   ENDIF

   SELECT PIN_MOV_CONT

   IF FAT = 'S'	AND NOTAC = 'S'			&& TRATTA SOLO LE NOTE ACCREDITO
   ELSE
   	 SELECT cINCASSI
	 SKIP +1
	 LOOP
   ENDIF


	** ACCESSO A C_IVA_CL PER ELABORARE LA NOTA DI ACCREDITO CONSIDERATA PAGATA/INCASSATA COMPLETAMENTE

   	  * 18/12/2021 SERGIO INIZIO
 	  IF PUB_CONTOSIMILCEE
		    _CODCLI = SCORPRA_CODICE_CLIENTE_FORNITORE_SE_SIMILCEE(M.MOV_CONTO)
	  ELSE
		    _CODCLI = SUBSTR(M.MOV_CONTO,PUB_SOTTOG,13)
	  ENDIF
 	  * 18/12/2021 SERGIO FINE   
        
    
    x_codi  = "IVA_codcli = '" + ALLTRIM(_CODCLI) + "'"
    x_datf  = "IVA_dtfatt = '" + M.PAR_DTFAT + "'"
    x_numf  = "IVA_numfat = '" + ALLTRIM(M.PAR_NUMFAT)  + "'" 
    
    x_cond  = x_codi + " and " + x_datf  + " and " + x_numf  
    Csql    = "select * from C_IVA_CL where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"


    IF !ExecCommand(CSQL,"C_IVA_CL")
      return(.f.)
    ENDIF
    
    SELECT C_IVA_CL
    GO TOP
 
    _SOLO_PRIMA_VOLTA = .T.
    
    DO WHILE .NOT. EOF()

        SCATTER MEMVAR MEMO
 
 
		IF _SOLO_PRIMA_VOLTA
		
			_SOLO_PRIMA_VOLTA = .F.
			
	        IF M.IVA_FATNOT = 'N'
	        	___PIN_CTN_CLI	= ___PIN_CTN_CLI	+ 1
	        ENDIF   
		
		ENDIF

		SELECT cU_IVA_CL
		APPEND BLANK 
		GATHER MEMVAR MEMO
        
        REPLACE IVA_MESE   WITH MESEDAL 
        REPLACE IVA_DTCREA WITH __DATA_DI_REGISTRAZIONE_FINE_MESE 
  
		_IMPONI_RICALCOLATO = M.IVA_IMPONI 
		_IMPOST_RICALCOLATO = M.IVA_IMPOST 
		_TOTALE_RICALCOLATO = M.IVA_TOTALE   
        
		REPLACE IVA_IMPONI WITH _IMPONI_RICALCOLATO 
		REPLACE IVA_IMPOST WITH _IMPOST_RICALCOLATO 
		REPLACE IVA_TOTALE WITH _TOTALE_RICALCOLATO 

		         
		WFR         	= .F.   && FATTURA IN RITARDO      
		WMESE           = MESEDAL
		WDTREG			= __DATA_DI_REGISTRAZIONE_FINE_MESE 
		DES_IVA			= M.IVA_DESIVA
		IMPONIBILE      = IVA_IMPONI && APPENA AGGIORNATO           
        IMPOSTA			= IVA_IMPOST 
        *PUB_CEEUNO 
        COD_IVA			= M.IVA_CODIVA
 

 	    v_seek	= 'TOP'+ALLTRIM(M.IVA_TOP)
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
	   
        v_seek	  = 'IVA'+ALLTRIM(M.IVA_CODIVA)     
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
  
       
        x_soci  = "ito_codsoc = '" + PUB_CODSOC + "'"
        x_anno  = "ito_anno = '" + PUB_ANNO + "'"
        x_mese  = "ito_mese = '" + MESEDAL+ "'"
        x_codi  = "ito_codiva = '" + ALLTRIM(M.IVA_CODIVA) + "'"
        x_fatt  = "ito_fatnot = '" + ALLTRIM(M.IVA_FATNOT) + "'"
        x_fatt1 = "ito_clifor = 'C'"

       

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
		

		SELECT C_IVA_CL
		SKIP +1

    ENDDO


	
	SELECT cINCASSI
	SKIP +1
	
ENDDO


IF !ExecRW('','U_IVA_CL','I','','cU_IVA_CL')
   return(.f.)
ENDIF


RETURN


***********************************************************************************************
PROCEDURE RICALCOLA_TOTALI_INCASSI_CLIENTI
***********************************************************************************************
*!*	AGGIORNA IMPORTO INCASSATO IN ARCHIVIO STORICO C_IVA.....



** ###################################################### AZZERA IMPORTO INCASSATO DI TUTTO L'ANNO IN C_IVA.... ######################################################

x_soci = "IVA_codsoc = '" + PUB_CODSOC + "'"
x_anno = "IVA_anno = '" + ANNODAL + "'"
x_cond = x_soci + " and " + x_anno  
Csql    = "select * from C_IVA_CL where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"
IF !ExecCommand(CSQL,"C_IVA_CL")
   RETURN (.f.)
ENDIF 

SELECT C_IVA_CL
GO TOP
DO WHILE .NOT. EOF()

	REPLACE PIN_IMPONI WITH 0 		 
	REPLACE PIN_IMPOST WITH 0 		 
	REPLACE PIN_TOTALE WITH 0 		 		

	SELECT C_IVA_CL
	SKIP +1

ENDDO

IF !ExecRW('','C_IVA_CL','I','','C_IVA_CL')
   return(.f.)
ENDIF		

** ###################################################### RICALCOLA IMPORTO INCASSATO  DI TUTTO L'ANNO ######################################################


x_soci = "IVA_codsoc = '" + PUB_CODSOC + "'"
x_anno = "IVA_anno = '" + ANNODAL + "'"
x_cond = x_soci + " and " + x_anno 
Csql    = "select * from U_IVA_CL where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"
IF !ExecCommand(CSQL,"U_IVA_CL")
   RETURN (.f.)
ENDIF 

SELECT U_IVA_CL
GO TOP
DO WHILE .NOT. EOF()


	SCATTER MEMVAR MEMO


	** ACCESSO A C_IVA_CL PER SOMMARE IL VALORE INCASSATO IN FUNZIONE DELL'ALIQUOTA IVA E DEL TIPO FATTURA

    x_codcf  = "IVA_codcli = '" + ALLTRIM(M.IVA_CODCLI) + "'"
    x_datf   = "IVA_dtfatt = '" + M.IVA_DTFATT + "'"
    x_numf   = "IVA_numfat = '" + ALLTRIM(M.IVA_NUMFAT)  + "'" 
    x_codi   = "IVA_codiva = '" + ALLTRIM(M.IVA_CODIVA) + "'"
    x_fatt   = "IVA_fatnot = '" + ALLTRIM(M.IVA_FATNOT) + "'"
    
    x_cond  = x_codcf + " and " + x_datf  + " and " + x_numf  + " and " + x_fatt + " and " + x_codi 

    Csql    = "select * from c_IVA_cl where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"

    IF !ExecRW(CSQL,"c_IVA_cl","R")
      return(.f.)
    ENDIF
    
    SELECT c_IVA_cl
	REPLACE PIN_IMPONI WITH PIN_IMPONI + M.IVA_IMPONI 		 
	REPLACE PIN_IMPOST WITH PIN_IMPOST + M.IVA_IMPOST 		 
	REPLACE PIN_TOTALE WITH PIN_TOTALE + M.IVA_TOTALE 		 		



    IF !ExecRW(cSql,"c_IVA_cl","W")
       return(.f.)
    ENDIF
		

	SELECT U_IVA_CL
	SKIP +1

ENDDO

RETURN

***********************************************************************************************
PROCEDURE DETERMINA_SALDO_INCASSI_CLIENTI
***********************************************************************************************
** PER IL MESE DI DICEMBRE :
**     LA PROCEDURA ELABORA TUTTE LE FATTURE ANCORA DA INCASSARE DALL'ARCHIVIO STORICO C_IVA_CL ,
**     CALCOLA L'IMPORTO RESIDUO PER IL SALDO E CREA IL BOLLATO IVA EFFETTIVO 
**

* CREAZIONE CURSORE

IF !ExecCommand("select * from U_IVA_cl where 0=1","cU_IVA_cl")
   return(.f.)
ENDIF

___PIN_CTF_CLI = 0


** ACCESSO A C_IVA_CL PER ELABORARE TUTTE LE FATTURE ANCORA DA INCASSARE PER LA CHIUSURA DEFINITIVA DELL'IVA DI CASSA

cSql=""     
cNomeCursorSql="cINCASSI_A_SALDO"
			
TEXT TO cSql NOSHOW

	SELECT
		IVA_codcli,
		IVA_dtfatt,
		IVA_numfat,
		sum(IVA_totale) as par_totale
	FROM C_IVA_CL
	GROUP BY IVA_codcli,IVA_dtfatt,IVA_numfat 
	ORDER BY IVA_codcli,IVA_dtfatt,IVA_numfat
	
ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	



SELECT cINCASSI_A_SALDO
GO TOP

DO WHILE .NOT. EOF()

	IF DELETED()
		SELECT cINCASSI_A_SALDO
		SKIP +1
		LOOP
	ENDIF


    SCATTER MEMVAR MEMO



	** ACCESSO A C_IVA_CL PER ELABORARE La FATTURA E IN BASE ALLA % DI INCASSO DETERMINO GLI IMPORTI DA CARICARE SUL BOLLATO EFFETTIVO

    x_codi  = "IVA_codcli = '" + ALLTRIM(m.IVA_codcli) + "'"
    x_datf  = "IVA_dtfatt = '" + M.IVA_dtfatt + "'"
    x_numf  = "IVA_numfat = '" + ALLTRIM(M.IVA_numfat)  + "'" 
    x_cond  = x_codi + " and " + x_datf  + " and " + x_numf  
    Csql    = "select * from C_IVA_CL where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"


    IF !ExecCommand(CSQL,"C_IVA_CL")
      return(.f.)
    ENDIF

	SELECT C_IVA_CL
	GO TOP
	 
	_SOLO_PRIMA_VOLTA = .T.

	DO WHILE .NOT. EOF()

	    SCATTER MEMVAR MEMO
	 
		IF M.PIN_TOTALE	=> M.IVA_TOTALE  	&& SE RIGA FATTURA SALDATA LA SCARTA
			SELECT C_IVA_CL
			SKIP +1
			LOOP
		ENDIF
	 
		IF _SOLO_PRIMA_VOLTA
		
			_SOLO_PRIMA_VOLTA = .F.
			
	        IF M.IVA_FATNOT = 'F'
	        	___PIN_CTF_CLI	= ___PIN_CTF_CLI	+ 1
	        ENDIF      	
	        IF M.IVA_FATNOT = 'N'
	        	___PIN_CTN_CLI	= ___PIN_CTN_CLI	+ 1
	        ENDIF   
		
		ENDIF

		SELECT cU_IVA_cl
		APPEND BLANK 
		GATHER MEMVAR MEMO
	    
	    REPLACE IVA_MESE   WITH MESEDAL 
	    REPLACE IVA_DTCREA WITH __DATA_DI_REGISTRAZIONE_FINE_MESE 
	  
		_IMPONI_RICALCOLATO = M.IVA_IMPONI - M.PIN_IMPONI 
		_IMPOST_RICALCOLATO = M.IVA_IMPOST - M.PIN_IMPOST
		_TOTALE_RICALCOLATO = M.IVA_TOTALE - M.PIN_TOTALE
	  
	    
		REPLACE IVA_IMPONI WITH _IMPONI_RICALCOLATO 
		REPLACE IVA_IMPOST WITH _IMPOST_RICALCOLATO 
		REPLACE IVA_TOTALE WITH _TOTALE_RICALCOLATO 

		         
		WFR         	= .F.   && FATTURA IN RITARDO      
		WMESE           = MESEDAL
		WDTREG			= __DATA_DI_REGISTRAZIONE_FINE_MESE 
		DES_IVA			= M.IVA_DESIVA
		IMPONIBILE      = IVA_IMPONI && APPENA AGGIORNATO           
	    IMPOSTA			= IVA_IMPOST 
	    *PUB_CEEUNO 
	    COD_IVA			= M.IVA_CODIVA
	 

	 	v_seek	 = 'TOP'+ALLTRIM(M.IVA_TOP)
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
	   
	    v_seek	  = 'IVA'+ALLTRIM(M.IVA_CODIVA)     
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


	     
	    x_soci  = "ito_codsoc = '" + PUB_CODSOC + "'"
	    x_anno  = "ito_anno = '" + PUB_ANNO + "'"
	    x_mese  = "ito_mese = '" + MESEDAL+ "'"
	    x_codi  = "ito_codiva = '" + ALLTRIM(M.IVA_CODIVA) + "'"
	    x_fatt  = "ito_fatnot = '" + ALLTRIM(M.IVA_FATNOT) + "'"
	    x_fatt1 = "ito_clifor = 'C'"

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
		

		SELECT C_IVA_CL
		SKIP +1

	ENDDO


	SELECT cINCASSI_A_SALDO
	SKIP +1


ENDDO WHILE .NOT. EOF()



IF !ExecRW('','U_IVA_cl','I','','CU_IVA_CL')
   return(.f.)
ENDIF



*!*	AGGIORNA IMPORTO PAGATO IN ARCHIVIO STORICO C_IVA.....



** ###################################################### AZZERA IMPORTO PAGATO DI TUTTO L'ANNO IN C_IVA.... ######################################################

x_soci = "IVA_codsoc = '" + PUB_CODSOC + "'"
x_anno = "IVA_anno = '" + ANNODAL + "'"
x_cond = x_soci + " and " + x_anno  
Csql    = "select * from C_IVA_CL where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"
IF !ExecCommand(CSQL,"C_IVA_CL")
   RETURN (.f.)
ENDIF 

SELECT C_IVA_CL
GO TOP
DO WHILE .NOT. EOF()

	REPLACE PIN_IMPONI WITH 0 		 
	REPLACE PIN_IMPOST WITH 0 		 
	REPLACE PIN_TOTALE WITH 0 		 		

	SELECT C_IVA_CL
	SKIP +1

ENDDO

IF !ExecRW('','C_IVA_CL','I','','C_IVA_CL')
   return(.f.)
ENDIF		

** ###################################################### RICALCOLA IMPORTO PAGATO  DI TUTTO L'ANNO ######################################################


x_soci = "IVA_codsoc = '" + PUB_CODSOC + "'"
x_anno = "IVA_anno = '" + ANNODAL + "'"
x_cond = x_soci + " and " + x_anno 
Csql    = "select * from U_IVA_CL where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"
IF !ExecCommand(CSQL,"U_IVA_CL")
   RETURN (.f.)
ENDIF 

SELECT U_IVA_CL
GO TOP
DO WHILE .NOT. EOF()


	SCATTER MEMVAR MEMO


	** ACCESSO A C_IVA_CL PER SOMMARE IL VALORE PAGATO IN FUNZIONE DELL'ALIQUOTA IVA E DEL TIPO FATTURA

    x_codcf  = "IVA_codcli = '" + ALLTRIM(M.IVA_CODCLI) + "'"
    x_datf   = "IVA_dtfatt = '" + M.IVA_DTFATT + "'"
    x_numf   = "IVA_numfat = '" + ALLTRIM(M.IVA_NUMFAT)  + "'" 
    x_codi   = "IVA_codiva = '" + ALLTRIM(M.IVA_CODIVA) + "'"
    x_fatt   = "IVA_fatnot = '" + ALLTRIM(M.IVA_FATNOT) + "'"
    
    x_cond  = x_codcf + " and " + x_datf  + " and " + x_numf  + " and " + x_fatt + " and " + x_codi 

    Csql    = "select * from C_IVA_CL where " + x_cond + " order by IVA_codcli ,IVA_dtfatt,IVA_numfat"

    IF !ExecRW(CSQL,"C_IVA_CL","R")
      return(.f.)
    ENDIF
    
    SELECT C_IVA_CL
	REPLACE PIN_IMPONI WITH PIN_IMPONI + M.IVA_IMPONI 		 
	REPLACE PIN_IMPOST WITH PIN_IMPOST + M.IVA_IMPOST 		 
	REPLACE PIN_TOTALE WITH PIN_TOTALE + M.IVA_TOTALE 		 		



    IF !ExecRW(cSql,"C_IVA_CL","W")
       return(.f.)
    ENDIF
		

	SELECT U_IVA_CL
	SKIP +1

ENDDO


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




RETURN


