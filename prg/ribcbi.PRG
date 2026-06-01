************************************************************************************
*                                                                                  *
*             Nome Programma    : RIBADK.PRG                                       *
*             Data              : 06/08/1997                                       *
*                                                                                  *
*             CREAZIONE FILE DELLE RICEVUTE BANCARIE DA SPEDIRE IN BANCA           *
*                                                                                  *           
************************************************************************************

PARA  _CBANCA

CODIBAN = _CBANCA

GO_ON = MESSAGEBOX("VUOI CONTINUARE NELLA CREAZIONE DEL FILE RELATIVO LE RICEVUTE BANCARIE DA TRASFERIRE IN BANCA ?",292,"ATTENZIONE")

IF GO_ON = 7
  RETURN
ENDIF

*** -= COUGAR =- 26/01/2005
IF !ExecRW("select * from U_AZI_AN","U_AZI_AN","R")
	return(.f.)
ENDIF

IF !ExecRW("select * from U_RIC_DD","U_RIC_DD","R")
	return(.f.)
ENDIF

IF USED("U_RIC_TT")

  SELECT U_RIC_TT
  USE
  
ENDIF

IF !ExecRW("select * from U_RIC_TT","U_RIC_TT","R")
	return(.f.)
ENDIF

IF !ExecRW("select * from U_RID_AN","U_RID_AN","R")
	return(.f.)
ENDIF

IF !ExecRW("select * from U_BAN_AN","U_BAN_AN","R")
	return(.f.)
ENDIF

IF !ExecRW("select * from U_CLI_AN","U_CLI_AN","R")
	return(.f.)
ENDIF
*** -= COUGAR =- 26/01/2005


** DEFINISCO SU QUALE RECORD CERCARE LE RIBA SU U_RID_AN

PUBLIC REC,XX_MITT,XX_RICEV,XX_MIFIS,XX_DTCREA,XX_NOMESUP,XX_PROGRE,XX_DESFIS,XX_NUMCC,XX_CPA
PUBLIC XX_CODAZI,XX_INDIRI,XX_CAP,XX_COMUNE,XX_NUMCCC,XX_CODFIS
PUBLIC I_FIN,V_CAMPO,CONTAREC
PUBLIC R01,R02,R03,R04,R05,R06,R07,R08,R09,R10,R11,R12

REC        = _CBANCA

XX_MITT    = CHKPARA("RID_MITTEN",REC)			&& abi mittente
XX_MIFIS   = STR(CHKPARA("RID_MITFIS",REC),5,0) && mittente fisico
XX_DESFIS  = STR(CHKPARA("RID_DESFIS",REC),5,0)	&& destinatario fisico
XX_NOMESUP = CHKPARA("RID_NOMSUP",REC)			&& nome supporto
XX_CODAZI  = CHKPARA("RID_CODAZI",REC)			&& codice azienda
XX_NUMCC   = CHKPARA("RID_NUMCC",REC)			&& numero conto corrente

XX_CODABI = ALLTRIM(BANCA_ABI(_CBANCA))
IF XX_CODABI="NO"
  RETURN
ENDIF  

IF LEN(XX_CODABI) = 1
  XX_CODABI = XX_CODABI + "    "
ENDIF

IF LEN(XX_CODABI) = 2
  XX_CODABI = XX_CODABI + "   "
ENDIF

IF LEN(XX_CODABI) = 3
  XX_CODABI = XX_CODABI + "  "
ENDIF

IF LEN(XX_CODABI) = 4
  XX_CODABI = XX_CODABI + " "
ENDIF

IF LEN(XX_CODABI)<5
  WAIT WIND "CODICE ABI DELLA BANCA MINORE DI 5 CARATTERI. SISTEMARE ANA. BANCHE"
  RETURN
ENDIF  

IF LEN(XX_CODABI)>5
  WAIT WIND "CODICE ABI DELLA BANCA MAGGIORE DI 5 CARATTERI. SISTEMARE ANA. BANCHE"
  RETURN
ENDIF  

XX_INDIRI  = SPACE(30)
XX_CAP     = SPACE(05)
XX_COMUNE  = SPACE(30)
XX_NUMCCC  = SPACE(12)
XX_CODFIS  = SPACE(16)

SELECT U_AZI_AN
GO TOP
SCATTER MEMVAR MEMO


SELECT U_RID_AN
*** -= COUGAR =- 26/01/2005 - SOSTITUZIONE DELLA SEEK, ELIMINAZIONE SET ORDER
cSql = "select * from U_RID_AN where RID_CODSOC = '" + ALLTRIM(PUB_CODSOC) + "' and RID_BANCA = '" + ALLTRIM(_CBANCA) + "' INTO CURSOR CU_RID_AN READWRITE"
&cSql

IF !EOF()
   REPLACE RID_PROGRE WITH 1
ELSE
   =MESSAGEBOX("NUMERO PROGRESSIVO RIBA MANCANTE "+CHR(13)+"IMPOSSIBILE CONTINUARE",62,"ATTENZIONE")
   RETURN
ENDIF  

IF EMPTY(XX_MITT) .OR. EMPTY(XX_MIFIS) .OR. EMPTY(XX_NOMESUP) .OR. EMPTY(XX_CODAZI)
   =MESSAGEBOX("PARAMETRI RIBA MANCANTI "+CHR(13)+"IMPOSSIBILE CONTINUARE",62,"ATTENZIONE")
   RETURN
ENDIF

CREATE CURSOR RID (CAMPO C(120))

SETDATA = SET("CENTURY")
SET CENTURY OFF

SELECT U_RIC_TT
GO TOP

NUMREC     = 0
VUOTO      = .T.
CONTARIBA  = 0
TOTIMPO    = 0
CONTAREC   = 0
CONTAGIRO  = 0
CONTARIB   = 0
_NODK      = 0
XX_PROGRE  = 0  && SERGIO 2008-02-05



DO WHILE !EOF()

   IF DELETED()
      SKIP + 1
      LOOP
   ENDIF
  
   IF RIC_TRASF
      SKIP + 1
      LOOP
   ENDIF
  

   IF RIC_BAPRES = _CBANCA
   ELSE
     SKIP + 1
     LOOP
   ENDIF


   IF !EMPTY(ALLTRIM(_NDISTINTA)) 								&&  SCARTA LE RIBA NON DELLA DISTINTA

     IF ALLTRIM(RIC_NUMDIS) <> ALLTRIM(_NDISTINTA)
	     SKIP + 1
	     LOOP
     ENDIF


   ELSE

	   IF RIC_DTFATT < RIBALTA2(_DATADAL)
	      SKIP + 1
	      LOOP
	   ENDIF

	   IF RIC_DTFATT > RIBALTA2(_DATAAL)
	      SKIP + 1
	      LOOP
	   ENDIF

   ENDIF





   SCATTER MEMVAR
  
   CONTARIBA = CONTARIBA + 1
   TOTIMPO = TOTIMPO + RIC_TRANC

   _DATA = DTOC(DATE())
  
   XX_DTCREA  = SUBSTR(_DATA,1,2)+SUBSTR(_DATA,4,2)+SUBSTR(_DATA,7,2)
*!*	   XX_PROGRE  = CHKPARA("RID_PROGRE",REC)
   XX_PROGRE   = XX_PROGRE + 1  && SERGIO 2008-02-05 
   XX_DTSCAD  = SUBSTR(RIC_DTSCAD,9,2)+SUBSTR(RIC_DTSCAD,6,2)+SUBSTR(RIC_DTSCAD,3,2)
   XX_IMPO    = RIC_TRANC
   XX_BANCAP  = RIC_BAPRES
   XX_BANCAC  = RIC_BACLI
   XX_CODCLI  = RIC_CODCLI
   XX_DATSCA  = RIBALTA2(RIC_DTSCAD)
   XX_RICEV   = CHKBAN(M.RIC_BAPRES)
  
   IF XX_RICEV = "NO"
      CONTARIBA = CONTARIBA - 1
      TOTIMPO = TOTIMPO - RIC_TRANC
      SELECT U_RIC_TT
      SKIP + 1
      LOOP
   ENDIF
 
   DO DATICLI WITH XX_CODCLI
  
   IF EMPTY(XX_INDIRI) .OR. EMPTY(XX_CAP) .OR. EMPTY(XX_COMUNE) 
      =MESSAGEBOX("DATI ANAGRAFICI CLIENTE NON CORRETTI"+CHR(13)+;
                  "CLIENTE   : "+M.RIC_CODCLI+CHR(13)+;
                  "FATTURA   : "+ALLTRIM(M.RIC_NFATT)+CHR(13)+;
                  "INDIRIZZO : "+XX_INDIRI+CHR(13)+;
                  "CAP       : "+XX_CAP+CHR(13)+;
                  "COMUNE    : "+XX_COMUNE+CHR(13)+;
                  "N.CONTO C.: "+XX_NUMCCC+CHR(13)+;
                  "NON ELABORO LA RIBA",62,"ATTENZIONE")
      SELECT U_RIC_TT
      SKIP + 1
      LOOP             
   ENDIF
    
   SS = SELECT()
   * ACCESSO ALLE CONDIZIONI DI PAGAMENTO PER VERIFICARE SE RIBA
   * RID  = POSIZIONE 10 DI LIBERA UGUALE A "R"  (MOD.RINO)
   * RIBA = POSIZIONE 10 DI LIBERA UGUALE A "X"  (MOD.RINO)

   *** COUGAR
   cSql = "select LIBERA from PARA where CODICE = 'CPA"+ALLTRIM(XX_CPA)+"'"
   IF !ExecCommand(cSql,"PARA")
      RETURN
   ENDIF
   
   IF !EOF()
   	  IF SUBSTR(LIBERA,10,1) = 'X' && E' UNA RIBA (MOD.RINO)
         OKRIBA = .T.
	  ELSE
         OKRIBA = .F.
	  ENDIF
   ELSE
      OKRIBA = .F.
   ENDIF
   *** END COUGAR
   SELECT(SS)

   IF !OKRIBA
      SELECT U_RIC_TT
      =MESSAGEBOX("RICEVUTA CON CONDIZIONI DI PAGAMENTO DA VERIFICARE"+CHR(13)+;
                  "CLIENTE   : "+M.RIC_CODCLI+CHR(13)+;
                  "FATTURA   : "+ALLTRIM(M.RIC_NFATT)+CHR(13)+;
                  "INDIRIZZO : "+XX_INDIRI+CHR(13)+;
                  "CAP       : "+XX_CAP+CHR(13)+;
                  "COMUNE    : "+XX_COMUNE+CHR(13)+;
                  "N.CONTO C.: "+XX_NUMCCC+CHR(13)+;
                  "NON ELABORO LA RIBA",62,"ATTENZIONE")
      _NODK = _NODK +1
      SKIP + 1
      LOOP             
   ENDIF
    
   IF VUOTO 
      DO PRIMOREC
      CONTAGIRO = CONTAGIRO + 1
   ENDIF

   
   FOR II = 1 TO 7
       CONTAREC = CONTAREC + 1  
       NOMEPROC = "RECORD"+STR(II,1,0)
       DO &NOMEPROC  
   NEXT
  
   VUOTO = .F.
  
   CONTARIB   = CONTARIB + 1

   SELECT U_RIC_TT
   REPLACE RIC_TRASF WITH .T.
   
   SKIP +1

ENDDO

IF _NODK  <> 0
  WAIT WINDOWS "NUMERO FATTURE SCARTATE " + STR(_NODK,10,0)
ENDIF

CONTAREC = CONTAREC + 2

IF CONTAGIRO > 0
   DO LASTREC
ENDIF  

SET CENTURY &SETDATA

IF CONTARIB > 0


    ***** PRENDE IL PATH DAL PARAMETRO FSD500 

	v_seek   = 'FSD'+"500"		&& DOCUMENTI BASE
	v_chiave = 'codice'
	cSql="SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
	IF !ExecCommand(cSql,"CODICE_FSD")
	  return(.f.)
	ENDIF
	SELECT CODICE_FSD
	GO TOP
	PUB_PATH_FSD_BASE=""
	IF !EOF()
	  PUB_PATH_FSD_BASE= ALLTRIM(LIBERA)
	ENDIF

	IF DIRECTORY(PUB_PATH_FSD_BASE)
	ELSE
	   MKDIR &PUB_PATH_FSD_BASE
	ENDIF


   NOCOPI = .F.


   IF NOCOPI
      = MESSAGEBOX("CREAZIONE FILE PER LA BANCA NON AVVENUTA",62,"ATTENZIONE")
   ELSE
      = MESSAGEBOX("CREAZIONE FILE PER LA BANCA TERMINATO CORRETTAMENTE"+CHR(13)+;
                   "NUMERO RICEVUTE ELABORATE : "+ALLTRIM(STR(CONTARIB))+CHR(13)+;
                   "TOTALE DISPOSIZIONI "+STR(TOTIMPO,10,0),62,"ATTENZIONE")
   ENDIF  

   SETD = SET("DEFA")

   SETDIR = SETD+PUB_PATH_FSD_BASE
   
   SET DEFA TO &SETDIR
   
   WAIT WINDOW SYS(2003)

*!*	   SELECT LIBERA FROM PARA WHERE CODICE="PTHRIBAOK" INTO CURSOR _TMP_RIB1
*!*	   SELECT LIBERA FROM PARA WHERE CODICE="PTHRIBAOLD" INTO CURSOR _TMP_RIB2
   
*!*	   TXTRID =ALLTRIM(_TMP_RIB1.LIBERA)+TXTRID
*!*	   TXTRID1=ALLTRIM(_TMP_RIB2.LIBERA)+"RIBA_DEL_"+dtos(date())+"_"+strtran(time(),":","_")
   
   IF FILE('&TXTRID')
      ERASE &TXTRID
   ENDIF
   
   * -->> copia file riba x remot
   SELECT RID
   GO TOP
   COPY TO &TXTRID SDF

*!*	   * -->> salva copia file riba x remot
*!*	   SELECT RID
*!*	   GO TOP
*!*	   COPY TO &TXTRID1 SDF

   SET DEFA TO &PUB_DIR

   SELECT RID  

   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IND = 0
      V_CAMPO = CAMPO
      FOR IND = 1 TO 120
          IF IND = 1
             V_CAMPO = '*' + SUBSTR(V_CAMPO,2,119)
          ELSE    
             IF IND = 120
                IF SUBSTR(V_CAMPO,120,1) = ' '
                   V_CAMPO = SUBSTR(V_CAMPO,1,119) + '*'
                ENDIF   
             ELSE    
                AA = IND - 1
                BB = IND + 1
                CC = 120 - IND
                IF SUBSTR(V_CAMPO,IND,1) = ' '
                   V_CAMPO = SUBSTR(V_CAMPO,1,AA) + '*' + SUBSTR(V_CAMPO,BB,CC)
                ENDIF
             ENDIF
          ENDIF
      NEXT          
      REPLACE CAMPO WITH V_CAMPO
      SKIP +1            
   ENDDO

   SELECT RID 
   GO TOP

   DO PRG\MENUSTA WITH "RID",.t.,.T.,"XXX","RIDDISKF","RIDDISKF.FRX"
   
*!*	   RIT = MESSAGEBOX("VUOI ANTEPRIMA DEL MODULO ?",292,"ATTENZIONE")
*!*	   IF RIT = 6
*!*	      REPORT FORM RIDDISKF.FRX PREVIEW   
*!*	   ENDIF  
*!*	   RIT = MESSAGEBOX("VUOI LA STAMPA DEL MODULO ?",292,"ATTENZIONE")
*!*	   IF RIT = 6
*!*	      REPORT FORM RIDDISKF.FRX NOCONSOLE TO PRINTER PROMPT   
*!*	   ENDIF  

ELSE
   = MESSAGEBOX("NUMERO RICEVUTE ELABORATE : "+ALLTRIM(STR(CONTARIB)),62,"ATTENZIONE")
ENDIF  

SET CENTURY ON

RETURN

****************************
PROCEDURE DATICLI
****************************
PARA CLIENTE

**xSql="select * from U_CLI_AN where CLI_CODSOC = '"+ALLTRIM(PUB_CODSOC)+"' and CLI_CODCLI = '"+ALLTRIM(CLIENTE)+"'"
x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
x_cont = "CLI_CODCLI = '" + ALLTRIM(CLIENTE) + "'"
x_cond = x_soci +  " and " + x_cont
Csql   = "select * from U_CLI_AN where " + x_cond + " order by CLI_CODCLI"
IF !ExecCommand(cSql,"CU_CLI_AN")
   return(.f.)
ENDIF
SELECT CU_CLI_AN
IF !EOF()
   XX_CPA    = CLI_CONPAG
   XX_INDIRI = CLI_INDIR
   XX_CAP    = CLI_CAP
   XX_COMUNE = CLI_LOCALI
   XX_NUMCCC = CLI_NUMCC
   XX_CODFIS = CLI_CODFIS
   IF EMPTY(XX_CODFIS) 
      XX_CODFIS = CLI_PARIVA
   ENDIF  
ELSE
   XX_CPA    = SPACE(03)
   XX_INDIRI  = SPACE(30)
   XX_CAP     = SPACE(05)
   XX_COMUNE  = SPACE(30)
   XX_NUMCCC  = SPACE(12)
   XX_CODFIS  = SPACE(16)
ENDIF
*** END COUGAR
RETURN

****************************
PROCEDURE PRIMOREC
****************************
** RECORD DI TESTA DI TUTTI I MOVIMENTI

FILLER     = SPACE(1)
FILLER2    = SPACE(65)
VUOTO1     = SPACE(11)
VUOTO_6    = SPACE(06)
*TIPREC     = "IB"  && (MOD.RINO)
TIPREC     = "IB"   && (MOD.RINO)

I_FIN    = 5
V_CAMPO  = XX_MIFIS 
DO ZERISIX
XX_MIFIS = V_CAMPO

I_FIN    = 5
V_CAMPO  = XX_DESFIS 
DO ZERISIX
XX_DESFIS = V_CAMPO

I_FIN   = 5
V_CAMPO = XX_MITT  
DO ZERISIX
XX_MITT = V_CAMPO

I_FIN   = 5
V_CAMPO = XX_RICEV  
DO ZERISIX
XX_RICEV = V_CAMPO
 
RIGA = FILLER+TIPREC+XX_MITT+XX_CODABI+XX_DTCREA+XX_NOMESUP+VUOTO1+XX_MIFIS+XX_DESFIS+FILLER2

SELECT RID
APPEND BLANK
REPLACE CAMPO WITH substr(RIGA,1,113)+'E'+substr(RIGA,115)
  
RETURN

****************************
PROCEDURE RECORD1
****************************

  FILLER   = SPACE(1)
  TIPREC   = "14"
  PROGRE   = STR(XX_PROGRE,7,0)
  CAU      = "30000"
  IMPORTO  = STR((XX_IMPO*100),13,0)
  SEGNO    = "-"
  TIPCOD   = "4"
  FILLER3  = SPACE(6)
  f1       = SPACE(12)

  xSql="select * from U_BAN_AN where BAN_CODSOC = '"+PUB_CODSOC+"' and BAN_CODBAN = '"+ALLTRIM(XX_BANCAP)+"' INTO CURSOR RECORD1_BAN"
  *?xSql
  &xSql
  SELECT RECORD1_BAN
  GO TOP 
  IF !EOF()
     BANCABIP = BAN_CODABI
     SPORTP   = BAN_CODCAB
  ELSE
     BANCABIP = XX_BANCAP
     SPORTP   = SPACE(05)
  ENDIF    

  xSql="select * from U_BAN_AN where BAN_CODSOC = '"+PUB_CODSOC+"' and BAN_CODBAN = '"+ALLTRIM(XX_BANCAC)+"' INTO CURSOR RECORD1_BAN"
  *?xSql
  &xSql
  SELECT RECORD1_BAN
  GO TOP 
     
  IF !EOF()
     BANCABIC = BAN_CODABI
     SPORTC   = BAN_CODCAB
  ELSE
     BANCABIC = XX_BANCAC
     SPORTC   = SPACE(05)
  ENDIF    

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO

  I_FIN   = 13
  V_CAMPO = IMPORTO  
  DO ZERISIX
  IMPORTO  = V_CAMPO

  I_FIN   = 5
  V_CAMPO = BANCABIP  
  DO ZERISIX
  BANCABIP= V_CAMPO
 
  I_FIN   = 5
  V_CAMPO = SPORTP  
  DO ZERISIX
  SPORTP  = V_CAMPO

  I_FIN   = 5
  V_CAMPO = BANCABIC  
  DO ZERISIX
  BANCABIC= V_CAMPO

  I_FIN   = 5
  V_CAMPO = SPORTC  
  DO ZERISIX
  SPORTC  = V_CAMPO

  I_FIN   = 16
  V_CAMPO = XX_CODCLI  
  DO ZERISIX
  YY_CODCLI= V_CAMPO

    
  RIGA = FILLER+TIPREC+PROGRE+SPACE(12)+XX_DTSCAD+CAU+IMPORTO+SEGNO+;
         XX_CODABI+SPORTP+XX_NUMCC+BANCABIC+SPORTC+XX_NUMCCC+XX_CODAZI+;
         TIPCOD+YY_CODCLI+FILLER3   
     
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH SUBSTR(RIGA,1,119)+"E"    
   

RETURN

****************************
PROCEDURE RECORD2
****************************

  FILLER   = SPACE(1)
  TIPREC   = "20"
  PROGRE   = STR(XX_PROGRE,7,0)
  SEG1     = ALLTRIM(M.AZI_RAGSOC)
  IF LEN(SEG1) < 24
    SEG1 = SEG1+SPACE(24-LEN(SEG1))
  ENDIF
  IF LEN(SEG1) > 24
    SEG1 = SUBSTR(SEG1,1,24)
  ENDIF
  
  SEG2     = ALLTRIM(M.AZI_INDIRI)+"-"+M.AZI_CAP
  IF LEN(SEG2) < 24
    SEG2 = SEG2+SPACE(24-LEN(SEG2))
  ENDIF
  IF LEN(SEG2) > 24
    SEG2 = SUBSTR(SEG2,1,24)
  ENDIF
 
  SEG3     = ALLTRIM(M.AZI_LOCALI)
  IF LEN(SEG3) < 24
    SEG3 = SEG3+SPACE(24-LEN(SEG3))
  ENDIF
  IF LEN(SEG3) > 24
    SEG3 = SUBSTR(SEG3,1,24)
  ENDIF
 
   
  SEG4     = SPACE(24)
  FILLER2  = SPACE(14)

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+SEG1+SEG2+SEG3+SEG4+FILLER2
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN
 

****************************
PROCEDURE RECORD3
****************************

  FILLER   = SPACE(1)
  TIPREC   = "30"
  PROGRE   = STR(XX_PROGRE,7,0)
  SEG1     = SUBSTR(M.RIC_RAGSOC,1,30)
  SEG2     = SUBSTR(M.RIC_RAGSOC,31,10) + SPACE(20)
  CODFISD  = SPACE(16)
  FILLER2  = SPACE(34)

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+SEG1+SEG2+XX_CODFIS+FILLER2
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN

****************************
PROCEDURE RECORD4
****************************

  FILLER   = SPACE(1)
  TIPREC   = "40"
  PROGRE   = STR(XX_PROGRE,7,0)
  FILLER2  = SPACE(20)

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+SUBSTR(XX_INDIRI,1,30)+SUBSTR(XX_CAP,1,5)+SUBSTR(XX_COMUNE,1,25)+FILLER2
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN

****************************
PROCEDURE RECORD5
****************************


  R01	= ""
  R02	= ""
  R03	= ""
  R04	= ""
  R05	= ""
  R06	= ""
  R07	= ""
  R08	= ""
  R09	= ""
  R10	= ""
  R11	= ""
  R12	= ""


  _SEG1    = CHKDET(M.TAGGANCIO)	&& AGGANCIA I DETTAGLI

  XIMPORTO  = STR((XX_IMPO*100),13,0)
  IF _SEG1 = "NO"						&& DETTAGLI NON TR0VATI
	  SEG1     = "FATT N. "+M.RIC_NFATT+" DEL "+RIBALTA2(M.RIC_DTFATT) +"  DI IMPORTO: " + SUBSTR(XIMPORTO,1,11) + "," + SUBSTR(XIMPORTO,12,2) + " SCAD. " + XX_DATSCA
	  _R01 = CREA50_60(SEG1,"","50",.T.)
  ENDIF

  IF LEN(ALLTRIM(R01+R02+R03+R04+R05+R06)) < 81

	  _R01 = CREA50_60(R01,R02,"50",.F.)

  ELSE
	  _R01 = CREA50_60(R01,R02,"50",.F.)
	  _R01 = CREA50_60(R03,R04,"50",.F.)
	  IF !EMPTY(R03)
	  	  CONTAREC=CONTAREC+1
	  ENDIF
      _R01 = CREA50_60(R05,R06,"50",.F.)
	  IF !EMPTY(R05)
	  	  CONTAREC=CONTAREC+1
	  ENDIF
  ENDIF



RETURN


****************************
PROCEDURE RECORD6
****************************

  FILLER   = SPACE(1)
  TIPREC   = "51"
  PROGRE   = STR(XX_PROGRE,7,0)

  *NUMDISP  = M.RIC_NUMDIS
  NUMDISP  = M.RIC_NFATT

  FIRMEMI  = ALLTRIM(PUB_DESSOC)
  IF LEN(FIRMEMI) < 20
    FIRMEMI = FIRMEMI+SPACE(20-LEN(FIRMEMI))
  ENDIF
  IF LEN(FIRMEMI) > 20
    FIRMEMI = SUBSTR(FIRMEMI,1,20)
  ENDIF
  FILLER2  = SPACE(31)
  FILLER3  = SPACE(49) 

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO

  I_FIN   = 10
  V_CAMPO = NUMDISP  
  DO ZERISIX
  NUMDISP = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+NUMDISP+FIRMEMI+FILLER2+FILLER3
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN



****************************
PROCEDURE RECORD7
****************************

  FILLER   = SPACE(1)
  TIPREC   = "70"
  PROGRE   = STR(XX_PROGRE,7,0)
  FILLER2  = SPACE(90)
  TIPDOC   = SPACE(01)
  RICESI   = SPACE(01)
  FILLER3  = SPACE(18)

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+FILLER2+TIPDOC+RICESI+FILLER3
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN

****************************
PROCEDURE LASTREC
****************************

  FILLER     = SPACE(1)
  TIPREC     = "EF"
  NUMDISP    = STR(CONTARIBA,7,0)  
  TOTIMP     = STR((TOTIMPO*100),15,0)
  VUOTO0     = '000000000000000'
  CONTAREC   = STR(CONTAREC,7,0)
  MIFIS      = XX_MIFIS
  VUOTO1     = SPACE(11)
  VUOTO2     = SPACE(11)
  DATA       = DTOC(DATE())
  GIORNATA   = SUBSTR(DATA,1,2)+SUBSTR(DATA,4,2)+SUBSTR(DATA,7,2)
  FILLER2    = SPACE(15)

  I_FIN   = 7
  V_CAMPO = NUMDISP  
  DO ZERISIX
  NUMDISP = V_CAMPO

  I_FIN   = 15
  V_CAMPO = TOTIMP  
  DO ZERISIX
  TOTIMP  = V_CAMPO

  I_FIN   = 7
  V_CAMPO = CONTAREC  
  DO ZERISIX
  CONTAREC = V_CAMPO

  RIGA = FILLER+TIPREC+XX_MITT+XX_CODABI+XX_DTCREA+XX_NOMESUP+VUOTO2+;
         NUMDISP+TOTIMP+VUOTO0+CONTAREC++XX_MIFIS+XX_DESFIS+XX_DTCREA+FILLER2
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH SUBSTR(RIGA,1,113)+"E"
  
RETURN


****************************
PROCEDURE ZERISIX
****************************
** RIEMPIMENTO CON ZERI NON SIGNIFICATIVI A SINISTRA DEL NUMERO

V_CAMPO = ALLTRIM(V_CAMPO)
V_LEN   = LEN(V_CAMPO)
V_ZERI  = I_FIN - V_LEN

IF V_LEN < I_FIN
   V_CAMPO = REPLICATE("0",V_ZERI) +  V_CAMPO
ENDIF

RETURN


****************************
PROCEDURE CHKPARA
****************************

PARA _CAMPO,_POS

xSql = "select "+_CAMPO+" from U_RID_AN where RID_CODSOC = '"+PUB_CODSOC+"' and RID_BANCA = '"+_POS+"' INTO CURSOR CHKPARA READWRITE"
&xSql
SELECT CHKPARA 
GO TOP 
IF EOF() && IL CURSORE E' VUOTO
	=MESSAGEBOX("AGGANCIO A PARAMETRI RIBA NON AVVENUTO"+CHR(13)+;
               "IMPOSSIBILE CONTINUARE",62,"ATTENZIONE")
    IF _CAMPO = "RID_PROGRE" 
    	OUT = -1
	ELSE
		OUT = ""
	ENDIF
	RETURN .F.
ELSE
	OUT = &_CAMPO
ENDIF
  
RETURN(OUT)  

*EOF()  


****************************
PROCEDURE CHKBAN
****************************
PARA _BANCA

xSql="select * from U_BAN_AN where BAN_CODSOC = '"+PUB_CODSOC+"' and BAN_CODBAN = '"+ALLTRIM(_BANCA)+"' INTO CURSOR CHKBAN"
*?xSql
&xSql   
SELECT CHKBAN
GO TOP 
IF !EOF()
   OUT = BAN_CODABI
ELSE
   =MESSAGEBOX("NON TROVO IL CODICE ABI DELLA BANCA :" +_BANCA+CHR(13)+;
               "DEL CLIENTE : "+M.RIC_CODCLI+CHR(13)+;
               "DELL'EFFETTO NUMERO : "+ALLTRIM(M.RIC_NFATT)+CHR(13)+;
               "IN SCADENZA AL : "+RIBALTA2(M.RIC_DTSCAD)+CHR(13)+;
               "IMPOSSIBILE TRATTARE LA RIBA",62,"ATTENZIONE")
   OUT = "NO"
ENDIF
  
RETURN(OUT)


****************************
PROCEDURE CHKDET
****************************
PARA _TAGGA

******** NON PIU' ATTIVA SERGIO


SELE=SELECT()

OUT=""

_CONTA = 0
  

x_tagg = "DAGGANCIO = '" + ALLTRIM(_TAGGA)+ "'"
x_cond = x_tagg 
Csql   = "select * from U_RIC_DD where " + x_cond + " order by daggancio"
IF !ExecCommand(cSql,"K_RIC_DD")
   return(.f.)
ENDIF

SELECT K_RIC_DD
GO top

IF !EOF()

   DO WHILE .NOT. EOF()

      IF DELETED()
         SELECT K_RIC_DD
         SKIP +1
         LOOP
      ENDIF

      IF ALLTRIM(_TAGGA) <> ALLTRIM(DAGGANCIO)
         EXIT
      ENDIF
      
      _CONTA = _CONTA +1

      IF _CONTA = 1 .OR. _CONTA = 2 
         R01 = R01+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 3 .OR. _CONTA = 4 
	     R02 = R02+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 5 .OR. _CONTA = 6 
	     R03 = R03+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 7 .OR. _CONTA = 8 
	     R04 = R04+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 8 .OR. _CONTA = 10 
	     R05 = R05+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 11 .OR. _CONTA = 12 
	     R06 = R06+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA > 12 
	     R06 = R06+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      SELECT K_RIC_DD
      SKIP +1

   ENDDO

ELSE
   OUT = "NO"
ENDIF

SELECT(SELE)
  
RETURN(OUT)


****************************
PROCEDURE CREA50_60
****************************
PARA _DATI1,_DATI2,_TR,_SOLO_PRIMA_PARTE

OUT = ""

IF EMPTY(_DATI1)       && NON SCRIVE NIENTE
   RETURN(OUT)
ENDIF

SELE=SELECT()

FILLER   = SPACE(1)
PROGRE   = STR(XX_PROGRE,7,0)
TIPREC   = _TR
SEG1     = SPACE(45)
SEG2     = SPACE(45)


IF _SOLO_PRIMA_PARTE

    SEG1     = SUBSTR(_DATI1,1,90)

ELSE
    
    SEG1     = ALLTRIM(_DATI1)
	IF LEN(SEG1) < 40 
	   SEG1 = SEG1 + SPACE(45 - LEN(SEG1))
	ENDIF

	IF LEN(SEG1) > 40 
	   SEG1 = SUBSTR(SEG1,1,45)
	ENDIF

	SEG2     = ALLTRIM(_DATI2)

	IF LEN(SEG2) < 40 
	   SEG2 = SEG2 + SPACE(45 - LEN(SEG2))
	ENDIF

	IF LEN(SEG2) > 40 
	   SEG2 = SUBSTR(SEG2,1,45)
	ENDIF

ENDIF

FILLER2  = SPACE(30)

I_FIN   = 7
V_CAMPO = PROGRE  
DO ZERISIX
PROGRE  = V_CAMPO
  
RIGA = FILLER+TIPREC+PROGRE+SEG1+SEG2+FILLER2
RIGA = SUBSTR(RIGA,1,100)+SUBSTR(M.AZI_PIVA,1,11)+SUBSTR(RIGA,112,9)	&& FORZATURA SERGIO 2008-02-05 : SUL RECORD 50 DALLA 101 VUOLE LA PARTITA IVA

  
SELECT RID
APPEND BLANK
REPLACE CAMPO WITH RIGA

SELECT(SELE)
  
RETURN(OUT)


*EOF()


****************************
PROCEDURE BANCA_ABI
****************************
PARA _BANCA

xSql = "select BAN_CODABI from U_BAN_AN where BAN_CODSOC = '"+PUB_CODSOC+"' and BAN_CODBAN = '"+_BANCA+"' INTO CURSOR BANCA_ABI READWRITE"
&xSql

SELECT BANCA_ABI 
IF !EOF()
   OUT = BAN_CODABI
ELSE
   =MESSAGEBOX("NON TROVO IL CODICE ABI DELLA BANCA :" +_BANCA+CHR(13)+"IMPOSSIBILE CONTINUARE")
   OUT = "NO"
ENDIF
  
RETURN(OUT)
