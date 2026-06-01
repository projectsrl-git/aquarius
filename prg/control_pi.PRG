
PARAMETERS __TIPO_ARCHIVIO



IF ALLTRIM(__TIPO_ARCHIVIO) = 'CLIENTI'
	=CONTROLLA_PI_CLIENTI()
ELSE
	=CONTROLLA_PI_FORNITORI()
ENDIF

*****************************************
FUNCTION CONTROLLA_PI_CLIENTI
*****************************************

**
** ####################### CONTROLLO PARTITA IVA CODICE FISCALE #######################
**

__xxannop = VAL(pub_anno) - 1
RIT = MESSAGEBOX("Procedo con il controllo delle PI/CF clienti"+CHR(13)+"per i soli clienti con fattura relativi all'anno :"+STR(__xxannop,4,0),292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF



RELEASE _conta_rec 
PUBLIC _conta_rec 
_conta_rec = 0

CREATE CURSOR VERCLI(CODICE C(10), RAGSOC C(40), DESCRI2 C(40), NUMERO N(10,0), PARIVA C(11), CODICEFISC C(16), PIVACEE C(16), INDIRI C(30), CAP C(10), LOCALI C(30), AGE C(03))
INDEX ON CODICE TAG VERCLI ADDITIVE

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_pariva"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SELECT CUR_CLIENTI
      SKIP +1
      LOOP
   ENDIF   
   

   V_COD 	= CLI_CODCLI
   V_DES 	= CLI_RAGSOC
   V_DE2 	= ""
   V_AGE 	= CLI_AGE
   V_IVA 	= CLI_PARIVA
   V_CF  	= CLI_CODFIS
   V_IND 	= CLI_INDIR
   V_CAP 	= CLI_CAP
   V_LOC 	= CLI_LOCALI
   V_IVACEE = ALLTRIM(CLI_IVACEE)
   V_NAZION = CLI_NAZION
   
   _CONTA_REC = _CONTA_REC  + 1
   
*!*	IF ALLTRIM(V_COD) = '0000212'
*!*	SET STEP ON 
*!*	ENDIF   
*!*	      
   
   WAIT windows "Clienti elaborati : " + STR(_conta_rec,5,0) nowait


   ** VERIFICA LE FATTURE DELL'ESERCIZIO 
   
	x_anno = "ord_anno = '" + STR(__xxannop,4,0) + "'"
	x_codi = "ord_codcli = '" + alltrim(V_COD) + "'"
	x_cond = x_anno + " and " + x_codi 
	cSql = "select * from u_fat_tt where " + x_cond + " order by ord_codcli"
	IF !ExecCommand(cSql,"CUR_FATTURE")
	   RETURN .F.
	ENDIF
	SELECT CUR_FATTURE
	GO TOP
	IF EOF()					&& SE NON ESISTE NESSUNA FATTURA NELL'ESERCIZIO IN ELAGORAZIONE SCARTA IL CLIENTE
      SELECT CUR_CLIENTI
      SKIP +1
      LOOP	
	ENDIF
   

   SELECT CUR_CLIENTI


   IF SUBSTR(V_NAZION,1,2) <> "IT"		&& CLIENTE ESTERO
      
      IF EMPTY(ALLTRIM(V_IVACEE))
      
	      SELECT VERCLI
	      APPEND BLANK
	      REPLACE CODICE  WITH V_COD
	      REPLACE RAGSOC  WITH V_DES
	      REPLACE DESCRI2 WITH "PARTITA IVA CLIENTE ESTERO INESISTENTE"
	      REPLACE PARIVA  WITH V_IVA
	      REPLACE INDIRI  WITH V_IND
	      REPLACE CAP     WITH V_CAP
	      REPLACE LOCALI  WITH V_LOC
	      REPLACE AGE     WITH V_AGE
	      REPLACE CODICEFISC WITH V_CF
	      REPLACE PIVACEE WITH V_IVACEE 
	      
	      SELECT CUR_CLIENTI
	      SKIP +1
	      LOOP

      ELSE
	      
	      SELECT CUR_CLIENTI	&& CLIENTE ESTERO CON PARTITA IVE CEE OK : LO SCARTO
	      SKIP +1
	      LOOP
	      
	  ENDIF      
      
   ENDIF

   

   SELECT CUR_CLIENTI
   
   IF LEN(ALLTRIM(CLI_PARIVA)) = 11		&& PARTITA IVA ESISTENTE
      SELECT CUR_CLIENTI
      SKIP +1
      LOOP
   ENDIF
  

 
   IF EMPTY(ALLTRIM(CLI_PARIVA)) AND EMPTY(ALLTRIM(CLI_CODFIS))	&& PARTITA IVA E CODICI FISCALI NON ESISTENTI

      SELECT VERCLI
      APPEND BLANK
      REPLACE CODICE  WITH V_COD
      REPLACE RAGSOC  WITH V_DES
      REPLACE DESCRI2 WITH "PARTITA IVA E CODICE FISCALE INESISTENTE"
      REPLACE PARIVA  WITH V_IVA
      REPLACE INDIRI  WITH V_IND
      REPLACE CAP     WITH V_CAP
      REPLACE LOCALI  WITH V_LOC
      REPLACE AGE     WITH V_AGE
      REPLACE CODICEFISC WITH V_CF
      REPLACE PIVACEE WITH V_IVACEE 
      
      SELECT CUR_CLIENTI
      SKIP +1
      LOOP

   ENDIF
 

   IF EMPTY(ALLTRIM(CLI_PARIVA)) OR EMPTY(ALLTRIM(CLI_CODFIS))	&& PARTITA IVA O CODICI FISCALI NON ESISTENTI

	   IF EMPTY(ALLTRIM(CLI_CODFIS))	&& CODICE FISCALE NON ESISTENTE
     
          SELECT VERCLI
	      APPEND BLANK
	      REPLACE CODICE  WITH V_COD
	      REPLACE RAGSOC  WITH V_DES
	      REPLACE DESCRI2 WITH "CODICE FISCALE INESISTENTE"
	      REPLACE PARIVA  WITH V_IVA
	      REPLACE INDIRI  WITH V_IND
	      REPLACE CAP     WITH V_CAP
	      REPLACE LOCALI  WITH V_LOC
	      REPLACE AGE     WITH V_AGE
          REPLACE CODICEFISC WITH V_CF
          REPLACE PIVACEE WITH V_IVACEE 

	      SELECT CUR_CLIENTI
	      SKIP +1
	      LOOP

	   ENDIF
	 

	   IF EMPTY(ALLTRIM(CLI_PARIVA))	&& PARTITA IVA NON ESISTENTE
	   
	   	  *** FABIANO 14/03/2015
	   	  *** LA PARTITA IVA E' NEL CODICE FISCALE
	      IF LEN(ALLTRIM(CLI_CODFIS)) = 11		&& PARTITA IVA ESISTENTE
		      SELECT CUR_CLIENTI
		      SKIP +1
		      LOOP
		   ENDIF

          SELECT VERCLI
	      APPEND BLANK
	      REPLACE CODICE  WITH V_COD
	      REPLACE RAGSOC  WITH V_DES
	      REPLACE DESCRI2 WITH "PARTITA IVA INESISTENTE"
	      REPLACE PARIVA  WITH V_IVA
	      REPLACE INDIRI  WITH V_IND
	      REPLACE CAP     WITH V_CAP
	      REPLACE LOCALI  WITH V_LOC
	      REPLACE AGE     WITH V_AGE
          REPLACE CODICEFISC WITH V_CF
          REPLACE PIVACEE WITH V_IVACEE 


	      SELECT CUR_CLIENTI
	      SKIP +1
	      LOOP

	   ENDIF 
   ENDIF	 
 

  
  
   SELECT CUR_CLIENTI
   SKIP +1

ENDDO


SELECT VERCLI
SET ORDER TO VERCLI 
GO TOP

IF !EOF()
   DO PRG\MENUSTA WITH "VERCLI",.T.,.T.,"XXX","cliparivacf","cliparivacf.FRX"
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF


RIT = MESSAGEBOX("Fine controllo esistenza di partite IVA codici fiscali in anagrafica clienti",62,"ATTENZIONE")
RELEASE WINDOW DISPLAY


RETURN


*****************************************
FUNCTION CONTROLLA_PI_FORNITORI
*****************************************

**
** ####################### CONTROLLO PARTITA IVA CODICE FISCALE #######################
**

__xxannop = VAL(pub_anno) - 1
RIT = MESSAGEBOX("Procedo con il controllo delle PI/CF fornitori"+CHR(13)+"per i soli fornitori con fattura relativi all'anno :"+STR(__xxannop,4,0),292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

RELEASE _conta_rec 
PUBLIC _conta_rec 
_conta_rec = 0

CREATE CURSOR VERFOR(CODICE C(10), RAGSOC C(40), DESCRI2 C(40), NUMERO N(10,0), PARIVA C(11), CODICEFISC C(16), PIVACEE C(16), INDIRI C(30), CAP C(10), LOCALI C(30), AGE C(03))
INDEX ON CODICE TAG VERFOR ADDITIVE

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_pariva"
IF !ExecCommand(cSql,"CUR_FORNITORI")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORI
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SELECT CUR_FORNITORI
      SKIP +1
      LOOP
   ENDIF   
   

   V_COD 	= FOR_CODCLI
   V_DES 	= FOR_RAGSOC
   V_DE2 	= ""
   V_AGE 	= ''
   V_IVA 	= FOR_PARIVA
   V_CF  	= FOR_CODFIS
   V_IND 	= FOR_INDIR
   V_CAP 	= FOR_CAP
   V_LOC 	= FOR_LOCALI
   V_IVACEE = ALLTRIM(FOR_IVACEE)
   V_NAZION = FOR_NAZION
   
   _CONTA_REC = _CONTA_REC  + 1
   
*!*	IF ALLTRIM(V_COD) = '0000212'
*!*	SET STEP ON 
*!*	ENDIF   
*!*	   
   WAIT windows "Fornitori elaborati : " + STR(_conta_rec,5,0) nowait


   ** VERIFICA LE FATTURE DELL'ESERCIZIO 
   
	x_anno = "ivf_anno = '" + STR(__xxannop,4,0) + "'"
	x_codi = "ivf_codcli = '" + alltrim(V_COD) + "'"
	x_cond = x_anno + " and " + x_codi 
	cSql = "select * from u_ivf_cl where " + x_cond + " order by ivf_codcli"
	IF !ExecCommand(cSql,"CUR_FATTUREFOR")
	   RETURN .F.
	ENDIF
	SELECT CUR_FATTUREFOR
	GO TOP
	IF EOF()					&& SE NON ESISTE NESSUNA FATTURA NELL'ESERCIZIO IN ELAGORAZIONE SCARTA IL FORNITORE
      SELECT CUR_FORNITORI
      SKIP +1
      LOOP	
	ENDIF
   

   SELECT CUR_FORNITORI



   IF SUBSTR(V_NAZION,1,2) <> "IT"		&& FORNITORE ESTERO
      
      IF EMPTY(ALLTRIM(V_IVACEE))
      
	      SELECT VERFOR
	      APPEND BLANK
	      REPLACE CODICE  WITH V_COD
	      REPLACE RAGSOC  WITH V_DES
	      REPLACE DESCRI2 WITH "PARTITA IVA FORNITORE ESTERO INESISTENTE"
	      REPLACE PARIVA  WITH V_IVA
	      REPLACE INDIRI  WITH V_IND
	      REPLACE CAP     WITH V_CAP
	      REPLACE LOCALI  WITH V_LOC
	      REPLACE AGE     WITH V_AGE
	      REPLACE CODICEFISC WITH V_CF
	      REPLACE PIVACEE WITH V_IVACEE 
	      
	      SELECT CUR_FORNITORI
	      SKIP +1
	      LOOP

      ELSE
	      
	      SELECT CUR_FORNITORI	&& FORNITORE ESTERO CON PARTITA IVE CEE OK : LO SCARTO
	      SKIP +1
	      LOOP
	      
      
	  ENDIF      
      

   ENDIF
  
   

   SELECT CUR_FORNITORI
   
   IF LEN(ALLTRIM(VV)) = 11		&& PARTITA IVA ESISTENTE
      SELECT CUR_FORNITORI
      SKIP +1
      LOOP
   ENDIF
  

 
   IF EMPTY(ALLTRIM(FOR_PARIVA)) AND EMPTY(ALLTRIM(FOR_CODFIS))	&& PARTITA IVA E CODICI FISCALI NON ESISTENTI

      SELECT VERFOR
      APPEND BLANK
      REPLACE CODICE  WITH V_COD
      REPLACE RAGSOC  WITH V_DES
      REPLACE DESCRI2 WITH "PARTITA IVA E CODICE FISCALE INESISTENTE"
      REPLACE PARIVA  WITH V_IVA
      REPLACE INDIRI  WITH V_IND
      REPLACE CAP     WITH V_CAP
      REPLACE LOCALI  WITH V_LOC
      REPLACE AGE     WITH V_AGE
      REPLACE CODICEFISC WITH V_CF
      REPLACE PIVACEE WITH V_IVACEE 
      
      SELECT CUR_FORNITORI
      SKIP +1
      LOOP

   ENDIF
 

   IF EMPTY(ALLTRIM(FOR_PARIVA)) OR EMPTY(ALLTRIM(FOR_CODFIS))	&& PARTITA IVA O CODICI FISCALI NON ESISTENTI

	   IF EMPTY(ALLTRIM(FOR_CODFIS))	&& CODICE FISCALE NON ESISTENTE
     
          SELECT VERFOR
	      APPEND BLANK
	      REPLACE CODICE  WITH V_COD
	      REPLACE RAGSOC  WITH V_DES
	      REPLACE DESCRI2 WITH "CODICE FISCALE INESISTENTE"
	      REPLACE PARIVA  WITH V_IVA
	      REPLACE INDIRI  WITH V_IND
	      REPLACE CAP     WITH V_CAP
	      REPLACE LOCALI  WITH V_LOC
	      REPLACE AGE     WITH V_AGE
          REPLACE CODICEFISC WITH V_CF
          REPLACE PIVACEE WITH V_IVACEE 

	      SELECT CUR_FORNITORI
	      SKIP +1
	      LOOP

	   ENDIF
	 

	   IF EMPTY(ALLTRIM(FOR_PARIVA))	&& PARTITA IVA NON ESISTENTE

	   	  *** FABIANO 14/03/2015
	   	  *** LA PARTITA IVA E' NEL CODICE FISCALE
	      IF LEN(ALLTRIM(FOR_CODFIS)) = 11		&& PARTITA IVA ESISTENTE
		      SELECT CUR_FORNITORI
		      SKIP +1
		      LOOP
		   ENDIF

          SELECT VERFOR
	      APPEND BLANK
	      REPLACE CODICE  WITH V_COD
	      REPLACE RAGSOC  WITH V_DES
	      REPLACE DESCRI2 WITH "PARTITA IVA INESISTENTE"
	      REPLACE PARIVA  WITH V_IVA
	      REPLACE INDIRI  WITH V_IND
	      REPLACE CAP     WITH V_CAP
	      REPLACE LOCALI  WITH V_LOC
	      REPLACE AGE     WITH V_AGE
          REPLACE CODICEFISC WITH V_CF
          REPLACE PIVACEE WITH V_IVACEE 


	      SELECT CUR_FORNITORI
	      SKIP +1
	      LOOP

	   ENDIF 
   ENDIF	 
 

  
  
   SELECT CUR_FORNITORI
   SKIP +1

ENDDO


SELECT VERFOR
SET ORDER TO VERFOR 
GO TOP

IF !EOF()
   DO PRG\MENUSTA WITH "VERFOR",.T.,.T.,"XXX","forparivacf","forparivacf.FRX"
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF


RIT = MESSAGEBOX("Fine controllo esistenza di partite IVA codici fiscali in anagrafica fornitori",62,"ATTENZIONE")
RELEASE WINDOW DISPLAY


RETURN





