**********************************************************************************
*       CONTROLLO NUMERAZIONE FATTURE                                           *
**********************************************************************************
ANNODAL = SUBSTR(DATADAL,7,4)
MESEDAL = SUBSTR(DATADAL,4,2)
V_ANNO  = ANNODAL
V_MESE	= MESEDAL

CONTA_REC = 0

PUBLIC  OK_PROTCL 
OK_PROTCL = 0

IF (EMPTY(MESEDAL)) .OR.  (EMPTY(ANNODAL))  
   RETURN
ENDIF  

***CERCA SU U_AZI_AN SE E' NECESSARIO GESTIRE LE ESENZIONI SUL CLIENTE NEL CASO DI ARTICOLO PUBBLICITARIO

x_cond = "azi_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"CUR_AZI")
   RETURN .F.
ENDIF
SELECT CUR_AZI
GO TOP
IF !EOF()
   OK_ESECLI = AZI_ARTPUB  && ARTICOLO PUBBLICITARIO
   OK_PROTCL = AZI_PROTCL
ELSE
   OK_ESECLI = .F.  && ARTICOLO PUBBLICITARIO
   OK_PROTCL = -1
   WAIT WINDOW "Per cortesia codifica il parametro bollati IVA"
ENDIF

***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE/FORNITORE

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   RIT=MSGBOX("Errore manca parametro GEN 4 caratteri conti CLI",'ATTENZIONE',31)
   RETURN(3)
ENDIF

CCC = SUBSTR(LIBERA,01,PUB_SOTTOG-1)
FFF = SUBSTR(LIBERA,18,PUB_SOTTOG-1)

DO FATVENDI      &&  CONTROLLO FATTURE CLIENTI

=MESSAGEBOX("Fine controllo numerazione fatture !",62,"*** ATTENZIONE ***")
RELEASE WINDOW DISPLAY
RETURN

***********************************************************************************************
PROCEDURE FATVENDI    
***********************************************************************************************
IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
   return(.f.)
ENDIF
SELECT MOV_CONT
HH=AFIELDS(TRANSIVC)
CREATE CURSOR CTRFAT FROM ARRAY TRANSIVC

CREATE CURSOR FAT_ERR;
(ERR_CODCLI C(10), ERR_RAGSOC C(40),   ERR_NUMFAT C(10),   ERR_DATFAT C(10),   ;
 ERR_NUMREG C(10), ERR_DATREG C(10),   ERR_NUMPRT C(10),   ERR_TOP C(10),      ;
 ERR_AGE C(03),    ERR_VALORE N(17,3), ERR_DESERR C(50))

DATA_DA = RIBALTA2(DATADAL)
DATA_A  = RIBALTA2(DATAAL)

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_conto"
IF !ExecCommand(cSql,"CUR_MOVCONT")
   RETURN .F.
ENDIF
SELECT CUR_MOVCONT
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
  
   IF MOV_DTDOC < DATA_DA
      SELECT CUR_MOVCONT
      SKIP +1
      LOOP
   ENDIF

   **=> SERGIO - INIZIO 18/12/2021
   IF PUB_CONTOSIMILCEE
 
	   IF VERYCF_SIMILCEE(MOV_CONTO,"CF")
	   ELSE
	      SELECT CUR_MOVCONT
	      SKIP +1
	      LOOP
	   ENDIF   
   
   ELSE

	   IF VERYCF(SUBSTR(MOV_CONTO,1,PUB_SOTTOG-1),"CF")
	   ELSE
	      SELECT CUR_MOVCONT
	      SKIP +1
	      LOOP
	   ENDIF
   
   ENDIF
   **=> SERGIO - FINE 18/12/2021



   WCODCLI = MOV_CONTO
*   WCOD    = SUBSTR(WCODCLI,PUB_SOTTOG,8)
   WCOD    = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
   
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(WCOD) + "'"
   x_cond = x_soci + " and " + x_codi
   cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP   
   IF !EOF()
      WAGE = CLI_AGE
   ELSE
      WAGE = SPACE(03)
   ENDIF

   IF AGEDAL = '999'
   ELSE
      IF WAGE = AGEDAL
      ELSE
         SELECT CUR_MOVCONT
         SKIP +1
         LOOP
      ENDIF   
   ENDIF

   SELECT CUR_MOVCONT

   IF MOV_DTDOC > DATA_A
      EXIT
   ENDIF

   NREG   	= MOV_NUMPRO
   ANNO   	= MOV_ANNO
   WTOP   	= MOV_TOP
   WCONTO 	= MOV_CONTO
   WCODCLI  = MOV_CONTO

   v_seek	= 'TOP' + ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      NOTAC = SUBSTR(LIBERA,11,1) 
      FAT   = SUBSTR(LIBERA,2,1)
   ELSE
      NOTAC = SPACE(1)
      FAT   = SPACE(1)
   ENDIF
  
   IF FAT = 'S' .OR. FAT = 'C'    && SALTA I TOP NON FATTURA
   ELSE
      SELECT CUR_MOVCONT 
      SKIP +1
      LOOP
   ENDIF

   IF NOTAC = 'S'    
      SELECT CUR_MOVCONT 
      SKIP +1
      LOOP
   ENDIF

   SELECT CUR_MOVCONT
    
   SCATTER MEMVAR MEMO	    && Salva i vecchi valori

   SELECT CTRFAT
   APPEND BLANK
   GATHER MEMVAR MEMO		&& Salva le modifiche
   REPLACE MOV_PORTO WITH WAGE

   CTRELAB = CTRELAB + 1 
   =CONTATORE("Fatture Clienti",CTRELAB)

   SELECT CUR_MOVCONT
   SKIP +1

ENDDO 

CT = 0
SELECT CTRFAT
INDEX ON VAL(ALLTRIM(MOV_NDOC)) TAG I_VAL ADDITIVE
SET ORDER TO I_VAL
GO TOP

V_PRIMA = 'SI'

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF V_PRIMA = 'SI'
      V_PRIMA = 'NO'
      SCATTER MEMVAR MEMO
      V_NUMERO = VAL(ALLTRIM(M.MOV_NDOC))
      SKIP +1
      LOOP
   ENDIF
   
   IF VAL(ALLTRIM(MOV_NDOC)) = V_NUMERO
      V_ERRORE = 'DOPPIO'
   ELSE
      IF VAL(ALLTRIM(MOV_NDOC)) = V_NUMERO + 1
         V_ERRORE = 'NO    '
      ELSE
         V_ERRORE = 'MANCA '
      ENDIF
   ENDIF   

   IF V_ERRORE = 'DOPPIO'

      WCODCLI = M.MOV_CONTO
      * WCOD    = SUBSTR(WCODCLI,PUB_SOTTOG,8)
      WCOD    = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))
      
      x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "cli_codcli = '" + ALLTRIM(WCOD) + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
      IF !ExecCommand(cSql,"CUR_CLIENTI")
         RETURN .F.
      ENDIF
      SELECT CUR_CLIENTI
      GO TOP
      IF !EOF()
         WRAGSOC = CLI_RAGSOC
      ELSE
         WRAGSOC = SPACE(40)
      ENDIF

      SELECT FAT_ERR
      APPEND BLANK
      REPLACE ERR_CODCLI WITH WCOD
      REPLACE ERR_RAGSOC WITH WRAGSOC
      *REPLACE ERR_NUMFAT WITH M.MOV_NDOC
      REPLACE ERR_NUMFAT WITH M.MOV_NPROT
      REPLACE ERR_DATFAT WITH M.MOV_DTDOC
      REPLACE ERR_NUMREG WITH M.MOV_NREGIS
      REPLACE ERR_DATREG WITH M.MOV_DTREG
      REPLACE ERR_NUMPRT WITH M.MOV_NPROT
      REPLACE ERR_TOP    WITH M.MOV_TOP
      REPLACE ERR_AGE    WITH M.MOV_PORTO
      REPLACE ERR_VALORE WITH M.MOV_IMP
      REPLACE ERR_DESERR WITH 'NUMERAZIONE DOPPIA'

      SELECT CTRFAT
      SCATTER MEMVAR MEMO

      WCODCLI = M.MOV_CONTO
      * WCOD = SUBSTR(WCODCLI,PUB_SOTTOG,8)
      WCOD    = ALLTRIM(SUBSTR(WCODCLI,PUB_SOTTOG,PUB_CONTO))

      x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "cli_codcli = '" + ALLTRIM(WCOD) + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
      IF !ExecCommand(cSql,"CUR_CLIENTI")
         RETURN .F.
      ENDIF
      SELECT CUR_CLIENTI
      GO TOP
      IF !EOF()
         WRAGSOC = CLI_RAGSOC
      ELSE
         WRAGSOC = SPACE(40)
      ENDIF

      SELECT FAT_ERR
      APPEND BLANK
      REPLACE ERR_CODCLI WITH WCOD
      REPLACE ERR_RAGSOC WITH WRAGSOC
      *REPLACE ERR_NUMFAT WITH M.MOV_NDOC
      REPLACE ERR_NUMFAT WITH M.MOV_NPROT
      REPLACE ERR_DATFAT WITH M.MOV_DTDOC
      REPLACE ERR_NUMREG WITH M.MOV_NREGIS
      REPLACE ERR_DATREG WITH M.MOV_DTREG
      REPLACE ERR_NUMPRT WITH M.MOV_NPROT
      REPLACE ERR_TOP    WITH M.MOV_TOP
      REPLACE ERR_AGE    WITH M.MOV_PORTO
      REPLACE ERR_VALORE WITH M.MOV_IMP
      REPLACE ERR_DESERR WITH 'NUMERAZIONE DOPPIA'

      SELECT CTRFAT
      SKIP +1 
      LOOP

   ENDIF

*!*	   IF V_ERRORE = 'MANCA '
*!*	      SELECT CTRFAT
*!*	      SCATTER MEMVAR MEMO
*!*	      DO WHILE .T.
*!*	         IF VAL(ALLTRIM(M.MOV_NDOC)) = V_NUMERO + 1
*!*	            EXIT
*!*	         ENDIF
*!*	         V_NUMERO = V_NUMERO + 1
*!*	         SELECT FAT_ERR
*!*	         APPEND BLANK
*!*	         REPLACE ERR_DESERR WITH 'MANCA NUMERO DI FATTURA ' + STR(V_NUMERO,6,0)
*!*	      ENDDO
*!*	      V_NUMERO = VAL(ALLTRIM(M.MOV_NDOC))
*!*	      SELECT CTRFAT        
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

   SELECT CTRFAT        
   SCATTER MEMVAR MEMO
   V_NUMERO = VAL(ALLTRIM(M.MOV_NDOC))
   SKIP +1
   
ENDDO

SELECT FAT_ERR
GO TOP
IF EOF()
   =MESSAGEBOX("Nessuna anomalia - tutto regolare ",62,"ATTENZIONE")
   RETURN 
ENDIF

IF !EOF()
   DO PRG\MENUSTA WITH "FAT_ERR",.T.,.T.,"XXX","CTRLFAT","CTRLFAT.FRX"
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF

RETURN

************************
  PROCEDURE CLEAR_VAR
************************

MESEDAL = SPACE(2)
ANNODAL = SPACE(4)
SHOW GETS

RETURN