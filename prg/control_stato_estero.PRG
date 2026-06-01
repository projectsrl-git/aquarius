
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
** ####################### CONTROLLO STATO ESTERO AGENZIA ENTRATE #######################
**

__xxannop = VAL(pub_anno) - 1
RIT = MESSAGEBOX("Procedo con il controllo dello STATO ESTERO in anagrafica clienti"+CHR(13)+"per i soli clienti con fattura relativi all'anno :"+STR(__xxannop,4,0),292,"ATTENZIONE")
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
   V_STATOE = ALLTRIM(CLI_ESTNAZ)
   **=> ERASMO - INIZIO 23/03/2017
   IF CLI_RECCAT = 2
      V_STATOE = ALLTRIM(CLI_ESTDOM)
   ENDIF
   **=> ERASMO - FINE 23/03/2017
   
   _CONTA_REC = _CONTA_REC  + 1
   

   
   WAIT windows "Clienti elaborati : " + STR(_conta_rec,5,0) nowait



   IF SUBSTR(V_NAZION,1,2) = "IT"		&& CLIENTE ITALIANO : LO SCARTO
      SELECT CUR_CLIENTI
      SKIP +1
      LOOP
   ENDIF 


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



   IF EMPTY(ALLTRIM(V_STATOE))
  
      SELECT VERCLI
      APPEND BLANK
      REPLACE CODICE  WITH V_COD
      REPLACE RAGSOC  WITH V_DES
      REPLACE DESCRI2 WITH "STATO ESTERO AGENZIA ENTRATE MANCANTE"
      REPLACE PARIVA  WITH V_IVA
      REPLACE INDIRI  WITH V_IND
      REPLACE CAP     WITH V_CAP
      REPLACE LOCALI  WITH V_LOC
      REPLACE AGE     WITH V_AGE
      REPLACE CODICEFISC WITH V_CF
      REPLACE PIVACEE WITH V_IVACEE 
      

   ENDIF      

   
   SELECT CUR_CLIENTI
   SKIP +1

ENDDO


SELECT VERCLI
SET ORDER TO VERCLI 
GO TOP

IF !EOF()
   DO PRG\MENUSTA WITH "VERCLI",.T.,.T.,"XXX","clistatoestero","clistatoestero.FRX"
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF


RIT = MESSAGEBOX("Fine controllo esistenza STATI ESTERI in anagrafica clienti",62,"ATTENZIONE")
RELEASE WINDOW DISPLAY


RETURN


*****************************************
FUNCTION CONTROLLA_PI_FORNITORI
*****************************************

**
** ####################### CONTROLLO PARTITA IVA CODICE FISCALE #######################
**

__xxannop = VAL(pub_anno) - 1
RIT = MESSAGEBOX("Procedo con il controllo dello STATO ESTERO in anagrafica fornitori"+CHR(13)+"per i soli fornitori con fattura relativi all'anno :"+STR(__xxannop,4,0),292,"ATTENZIONE")
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
   V_STATOE = ALLTRIM(FOR_ESTNAZ)  
   **=> ERASMO - INIZIO 23/03/2017
   IF FOR_RECCAT = 2
      V_STATOE = ALLTRIM(FOR_ESTDOM)
   ENDIF
   **=> ERASMO - FINE 23/03/2017
   
   _CONTA_REC = _CONTA_REC  + 1
   

   WAIT windows "Fornitori elaborati : " + STR(_conta_rec,5,0) nowait


   IF SUBSTR(V_NAZION,1,2) = "IT"		&& FORNITORE ITALIANO : LO SCARTO
      SELECT CUR_FORNITORI
      SKIP +1
      LOOP
   ENDIF 


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



       
   IF EMPTY(ALLTRIM(V_STATOE))
  
      SELECT VERFOR
      APPEND BLANK
      REPLACE CODICE  WITH V_COD
      REPLACE RAGSOC  WITH V_DES
      REPLACE DESCRI2 WITH "STATO ESTERO AGENZIA ENTRATE MANCANTE"
      REPLACE PARIVA  WITH V_IVA
      REPLACE INDIRI  WITH V_IND
      REPLACE CAP     WITH V_CAP
      REPLACE LOCALI  WITH V_LOC
      REPLACE AGE     WITH V_AGE
      REPLACE CODICEFISC WITH V_CF
      REPLACE PIVACEE WITH V_IVACEE 
      

   ENDIF      
  

  
   SELECT CUR_FORNITORI
   SKIP +1

ENDDO


SELECT VERFOR
SET ORDER TO VERFOR 
GO TOP

IF !EOF()
   DO PRG\MENUSTA WITH "VERFOR",.T.,.T.,"XXX","forstatoestero","forstatoestero.FRX"
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF


RIT = MESSAGEBOX("Fine controllo esistenza STATI ESTERI in anagrafica fornitori",62,"ATTENZIONE")
RELEASE WINDOW DISPLAY


RETURN





