********************************************************************************************************
*  				     CARICAMENTO BOLLATI IVA CLIENTI / FORNITORI / CORRISPETTIVI   				       *
********************************************************************************************************
                     
RELEASE XXX_FATNOT,WBOLLATOIVA
PUBLIC  XXX_FATNOT,WBOLLATOIVA     
XXX_FATNOT  = ''
WBOLLATOIVA = SPACE(01) 


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


IF !ExecCommand("select * from u_iva_cl where 0=1","cu_iva_cl")
  return(.f.)
ENDIF
IF !ExecCommand("select * from u_ivf_cl where 0=1","cu_ivf_cl")
  return(.f.)
ENDIF

DO IVAVENDI      &&  CARICAMENTO BOLLATO IVA VENDITE
DO IVAACQUI      &&  CARICAMENTO BOLLATO IVA ACQUISTI

IF !ExecRW('','u_iva_cl','I','','CU_IVA_CL')
   return(.f.)
ENDIF
IF !ExecRW('','u_ivf_cl','I','','CU_IVF_CL')
   return(.f.)
ENDIF



WAIT WINDOWS  "Fat.clienti manuali..."+PADL(ALLTRIM(STR(___CTF_CLI,10,0)),13,'.')		+ ;
 	 CHR(13)+ "Fat.clienti automatiche.." + PADL(ALLTRIM(STR(___CTF_CLI_AUTO,10,0)),8,'.')	+ ;
	 CHR(13)+ "Fat.fornitori......" + PADL(ALLTRIM(STR(___CTF_FOR,10,0)),17,'.')		+ ;
	 CHR(13)+ "Cor.clienti........" + PADL(ALLTRIM(STR(___CTC_CORRISP,10,0)),18,'.')	+ ;
	 CHR(13)+ "Fat.fornit.cee...." + PADL(ALLTRIM(STR(___CTF_FOR_CEE,10,0)),17,'.')	+ ;
	 CHR(13)+ "Note c.clienti...." + PADL(ALLTRIM(STR(___CTF_NC_CLI,10,0)),18,'.')	+ ;
	 CHR(13)+ "Note c.fornitori....." + PADL(ALLTRIM(STR(___CTF_NC_FOR,10,0)),15,'.')


* =MESSAGEBOX("Fine caricamento bollato iva !",62,"*** ATTENZIONE ***")

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
x_tipo = "(ito_clifor = 'C' or ito_clifor = 'E' or ito_clifor = 'D')"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_tipo
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

SET STEP ON 

DATA_DA = RIBALTA2(DATADAL)
DATA_A  = RIBALTA2(DATAAL)

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + ANNODAL + "'"
x_data = "mov_dtreg >= '" + DATA_DA + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_data
cSql="SELECT * FROM mov_cont WHERE " + x_cond + " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"
IF !ExecCommand(cSql,"MOV_CONT")
   return(.f.)
ENDIF
SELECT MOV_CONT
GO TOP



CTRELAB = 0

DO WHILE .T.       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF (MOV_IVA = 'NO') .AND. (CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) = 0)
   ELSE
      SKIP +1
      LOOP
   ENDIF

   IF MOV_DTREG > DATA_A
      EXIT
   ENDIF

   IF ALLTRIM(MOV_TOP)="BD"    && CASO BOLLE DOGANALI 
      IF (MOV_IVA = 'NO') .AND. (CAMBIO(MOV_VALUTA,MOV_IMPORT,MOV_CAMBIO) = 0)   
         SELECT MOV_CONT
	     SKIP +1
	     LOOP
      ENDIF
   ENDIF

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

BROWSE normal
SET STEP ON 
   
   TIPOCONTO = CON_TIPOCO		&& IDENTIFICA IL TIPO DI CONTO

   SELECT MOV_CONT
   
   WTOP   	= MOV_TOP
   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   	= SUBSTR(LIBERA,2,1)
      NOTAC 	= SUBSTR(LIBERA,11,1) 
	  VER_CONTO = SUBSTR(LIBERA,12,1)
      CEE   	= SUBSTR(LIBERA,23,1)
      TMOV      = SUBSTR(LIBERA,33,2)
   ELSE
      FAT    	= SPACE(1)
      NOTAC  	= SPACE(1)
      VER_CONTO = SPACE(1)
      CEE    	= SPACE(1)
      TMOV      = SPACE(2)
   ENDIF

   SELECT MOV_CONT
   
   DO CASE 
   		
   		CASE FAT = 'C' AND TMOV = 'VB' && VERIFICA SE CORRISPETTIVI PER VENDITE AL BANCO
   		
		   IF TIPOCONTO = "K"			&& CONTO INCASSI PER VENDITA AL BANCO
		   ELSE
		      SKIP +1
		      LOOP
		   ENDIF
   		
   		OTHERWISE

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



   ENDCASE


   SELECT MOV_CONT
   SCATTER MEMVAR MEMO	    && Salva i vecchi valori

   SELECT IVA
   APPEND BLANK
   GATHER MEMVAR MEMO		&& Salva le modifiche

   CTRELAB=CTRELAB+1 
   **=CONTATORE("Fatture Cli./For.",CTRELAB)
   SELECT MOV_CONT
   SKIP +1

ENDDO

CT = 0
SELECT IVA
GO TOP
BROWSE NORMAL


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


   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      FAT   	= SUBSTR(LIBERA,2,1)
      NOTAC 	= SUBSTR(LIBERA,11,1) 
	  VER_CONTO = SUBSTR(LIBERA,12,1)
      CEE   	= SUBSTR(LIBERA,23,1)
      TMOV      = SUBSTR(M.LIBERA,33,2)
   ELSE
      FAT    	= SPACE(1)
      NOTAC  	= SPACE(1)
      VER_CONTO = SPACE(1)
      CEE    	= SPACE(1)
      TMOV      = SPACE(2)
   ENDIF

   IF FAT = 'S' OR FAT = 'C' && SALTA I TOP NON FATTURA / CORRISPETTIVI
   ELSE
      SELECT IVA 
      SKIP +1
      LOOP
   ENDIF



   IF CEE = 'E'   && FATTURA ACQUISTO CEE PRELEVA IL CODICE CLIENTE CEE DA ANAGRAFICA DEL FORNITORE

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
	  ELSE
	     WNAZION   = "ITA"
	     WCLICEE   = WCOD
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
      REPLACE MOV_CONTO WITH M.MOV_CONTO
   ENDIF

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
   

   CT = CT + 1

   *===>>> ACCESSO AI MOVIMENTI CONTABILI PER ELABORARE I RECORDS IVA 
   SELECT IVA 
   _NUMPRO     = MOV_NUMPRO
   _NREGIS     = MOV_NREGIS
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
				     IMPONIBILE= IMPONIBILE + NW_IMPONI      							  && IMPONIBILE ESATTO 
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
         ELSE
            NOTAC = SPACE(1)
            FAT   = SPACE(1)
         ENDIF

		 IF NOTAC = 'S'  
	 	 	IF OK_CONTA  
			    OK_CONTA = .F. 
		 	 	___CTF_NC_CLI = ___CTF_NC_CLI  +  1 
			ENDIF
		 ELSE
	 	 	IF OK_CONTA  
			    OK_CONTA = .F. 
                IF WBOLLATOIVA =  " "
		 	 		___CTF_CLI = ___CTF_CLI  +  1 
				ENDIF
                IF WBOLLATOIVA =  "D"
		 	 		___CTF_CLI_AUTO = ___CTF_CLI_AUTO  +  1 
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
 		 IF IMPONIBILE <> 0    && SE IMP=0 E' MATERIALE PUBBLICITARIO

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
               CSQL   = "select * from u_iva_cl where " + x_cond + " order by iva_codsoc,iva_anno,iva_mese,iva_chiave,iva_codiva,iva_fatnot" 
               IF !ExecRW(CSQL,"u_iva_cl","R")
                  RETURN (.f.)
               ENDIF 
  	 	       SELECT U_IVA_CL
  	 	       GO TOP
  	 	       IF EOF()
 			      APPEND BLANK
		          REPLACE    IVA_CHIAVE    WITH VNUMPRT 
		          REPLACE    IVA_CODSOC    WITH PUB_CODSOC
		          REPLACE    IVA_ANNO      WITH PUB_ANNO
		          REPLACE    IVA_CODCLI    WITH WCODCLI 
		          REPLACE    IVA_RAGSOC    WITH WRAGSOC 
		          REPLACE    IVA_DTCREA    WITH WDTREG
		          REPLACE    IVA_DTFATT    WITH WDTFAT
		          REPLACE    IVA_NUMFAT    WITH WNUMFAT 
	              IF CEE = "E"
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
		          REPLACE    IVA_CHIAVE    WITH VNUMPRT 
		          REPLACE    IVA_CODSOC    WITH PUB_CODSOC
		          REPLACE    IVA_ANNO      WITH PUB_ANNO
		          REPLACE    IVA_CODCLI    WITH WCODCLI 
		          REPLACE    IVA_RAGSOC    WITH WRAGSOC 
		          REPLACE    IVA_DTCREA    WITH WDTREG
		          REPLACE    IVA_DTFATT    WITH WDTFAT
		          REPLACE    IVA_NUMFAT    WITH WNUMFAT 
                  IF CEE = "E"
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
            SELECT CU_IVA_CL
            APPEND BLANK
	        REPLACE    IVA_CHIAVE    WITH VNUMPRT 
	        REPLACE    IVA_CODSOC    WITH PUB_CODSOC
	        REPLACE    IVA_ANNO      WITH PUB_ANNO
	        REPLACE    IVA_CODCLI    WITH WCODCLI 
	        REPLACE    IVA_RAGSOC    WITH WRAGSOC 
	        REPLACE    IVA_DTCREA    WITH WDTREG
	        REPLACE    IVA_DTFATT    WITH WDTFAT
	        REPLACE    IVA_NUMFAT    WITH WNUMFAT 
            IF CEE = "E"
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
	        REPLACE    IVA_CHIAVE    WITH VNUMPRT 
	        REPLACE    IVA_CODSOC    WITH PUB_CODSOC
	        REPLACE    IVA_ANNO      WITH PUB_ANNO
	        REPLACE    IVA_CODCLI    WITH WCODCLI 
	        REPLACE    IVA_RAGSOC    WITH WRAGSOC 
	        REPLACE    IVA_DTCREA    WITH WDTREG
	        REPLACE    IVA_DTFATT    WITH WDTFAT
	        REPLACE    IVA_NUMFAT    WITH WNUMFAT 
            IF CEE = "E"
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
         IF CEE = "E"
            x_tipo = "ito_clifor = 'E'"
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
            IF CEE = "E"
               x_tipo = "ito_clifor = 'E'"
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
            IF CEE = "E"
               x_tipo = "ito_clifor = 'E'"
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
   IF CEE = "E"
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
x_tipo = "(ito_clifor = 'F' or ito_clifor = 'E')"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_tipo
CSQL   = "delete from u_iva_to where " + x_cond
IF !ExecCommand(CSQL,"U_IVA_TO")
   RETURN (.f.)
ENDIF 


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

   VNUMPRT = VAL(SUBSTR(MOV_NPROT,1,6))
   NREG    = MOV_NUMPRO
   ANNO    = MOV_ANNO
   WTOP    = MOV_TOP
   WCONTO  = MOV_CONTO


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
   ELSE
      WRAGSOC   = SPACE(40)
      WINDIRI   = SPACE(40)
      WLOCALI   = SPACE(40)
      WCAP      = SPACE(5)
      WPARIVA   = SPACE(16)  
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
				IF CEEF = "E"
					 ___CTF_FOR_CEE=___CTF_FOR_CEE +1
				ELSE
			 		 ___CTF_FOR = ___CTF_FOR + 1  	
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
         IF CEE = "E"
            x_tipo = "ito_clifor = 'E'"
         ENDIF
         
         x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
         x_anno = "ito_anno = '" + PUB_ANNO + "'"
         x_mese = "ito_mese = '" + WMESE + "'"
         x_codi = "ito_codiva = '" + ALLTRIM(IVF_CODIVA) + "'"
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
IF CEE = "E"
   REPLACE    ITO_CLIFOR    WITH 'E' 
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


IF CEE = "E"
   REPLACE    ITO_CLIFOR    WITH 'E' 
ELSE
   REPLACE    ITO_CLIFOR    WITH 'F' 
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
   IF CEE = "E"
      x_tipo = "ito_clifor = 'E'"
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
   REPLACE    IVA_CHIAVE    WITH VNUMPRT 
   REPLACE    IVA_CODSOC    WITH PUB_CODSOC
   REPLACE    IVA_ANNO      WITH PUB_ANNO
   REPLACE    IVA_CODCLI    WITH WCODCLI 
   REPLACE    IVA_RAGSOC    WITH WRAGSOC 
   REPLACE    IVA_DTCREA    WITH WDTREG
   REPLACE    IVA_DTFATT    WITH WDTFAT
   REPLACE    IVA_NUMFAT    WITH WNUMFAT 
   IF CEE = "E"
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

IF CEE = "E"
   x_tipo = "ito_clifor = 'E'"
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
SELECT CU_IVF_CL
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

___CTC_CORRISP=___CTC_CORRISP+1

SELECT CU_IVA_CL
APPEND BLANK
REPLACE    IVA_CHIAVE    WITH VNUMPRT 
REPLACE    IVA_CODSOC    WITH PUB_CODSOC
REPLACE    IVA_ANNO      WITH PUB_ANNO
REPLACE    IVA_CODCLI    WITH WCODCLI 
REPLACE    IVA_RAGSOC    WITH WRAGSOC 
REPLACE    IVA_DTCREA    WITH WDTREG
REPLACE    IVA_DTFATT    WITH WDTFAT
REPLACE    IVA_NUMFAT    WITH WNUMFAT 
IF CEE = "E"
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
REPLACE    IVA_FATNOT    WITH 'C'
REPLACE    IVA_DESIVA    WITH DES_IVA
REPLACE    IVA_ALIQUO    WITH VAL(ALIQ) 
REPLACE    IVA_IMPONI    WITH IMPONIBILE    
REPLACE    IVA_IMPOST    WITH IMPOSTA
REPLACE    IVA_CODIVA    WITH COD_IVA
REPLACE    IVA_TOTALE    WITH WFATT  

XXX_FATNOT = 'C'

RETURN


