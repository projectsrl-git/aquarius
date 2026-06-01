TI_PX = 'C'

NUMPRO = TAGGANCIO

SELECT CU_FAT_DD
GO TOP

DO STAMPAMOD

SELECT CU_FAT_DD

IF RIF_COPIE = 0
   RIF_COPIE = 1
ENDIF

_COPIE = 0

DO WHILE .T.

   _COPIE = _COPIE +1

   IF _COPIE > RIF_COPIE
      EXIT
   ENDIF

   IF V_VALUTA="ITL" .OR. V_VALUTA="LIT"
      DO PRG\MENUSTA WITH "CU_FAT_DD",.T.,.T.,"XXX","FATPJITA","FATMODI.FRX"
      *V_REPORT=CERCAREPO("XXX","FATPJITA","FATMODI.FRX")
   ELSE
      IF V_VALUTA="EUR"
         DO PRG\MENUSTA WITH "CU_FAT_DD",.T.,.T.,"XXX","FATPJEUR","FATPJEUR.FRX"
         *V_REPORT=CERCAREPO("XXX","FATPJEUR","FATPJEUR.FRX")
      ELSE
         DO PRG\MENUSTA WITH "CU_FAT_DD",.T.,.T.,"XXX","FATPJEST","FATMODE.FRX"
         *V_REPORT=CERCAREPO("XXX","FATPJEST","FATMODE.FRX")
      ENDIF
   ENDIF

*   IF SOLO_UNO
*      SOLO_UNO = .F.
*      REPORT FORM &V_REPORT NOEJECT NOCONSOLE TO PRINTER PROMPT
*   ELSE
*      REPORT FORM &V_REPORT NOEJECT NOCONSOLE TO PRINTER
*   ENDIF

ENDDO

SELECT CU_FAT_DD
GO BOTTOM

DO RILA_VAR    && RELEASE DI TUTTE LE VARIABILI

RETURN


*****************************
PROCEDURE STAMPAMOD
*****************************

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
  (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

PUBLIC V_DATA,V_NUMFAT,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMFAT,TOT_IMPO,TOT_IMPOS,TOT_FATT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB
PUBLIC V_SPINCA,V_SPTRAS,SAY_PORTO
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_VETTO,V_MERCRE,V_PORTO,DPU
RELEASE V_FERIE,NOTAC
PUBLIC  V_FERIE,NOTAC
PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]

IS1 = 0
IS2 = 0
IS3 = 0
IS4 = 0
IS5 = 0

DS1 = SPACE(10)
DS2 = SPACE(10)
DS3 = SPACE(10)
DS4 = SPACE(10)
DS5 = SPACE(10)

V_INTESTA = ""
V_RAGSOC  = SPACE(40)
V_INDIRI  = SPACE(40)
V_CAP     = SPACE(10)
V_LOCALI  = SPACE(30)
V_CODCLI  = SPACE(13)
V_PIVA    = SPACE(20)
V_VSRIF   = SPACE(30)
V_NSRIF   = SPACE(30)
V_PAG     = SPACE(3)
V_DATA    = SPACE(10)
V_BANCA   = SPACE(15)
V_CPAG	  = SPACE(40)
V_BANAP   = SPACE(30)
V_NUMFAT  = SPACE(10)
V_DESCAU  = "FATTURA DI VENDITA"
NOTAC     = " "
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)

V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_FATT  = 0

IMPO1     = 0
IMPO2     = 0
IMPO3     = 0
IMPO4     = 0
IMPO5     = 0

IVA1      = SPACE(3)
IVA2      = SPACE(3)
IVA3      = SPACE(3)
IVA4      = SPACE(3)
IVA5      = SPACE(3)

DIVA1     = SPACE(25)
DIVA2     = SPACE(25)
DIVA3     = SPACE(25)
DIVA4     = SPACE(25)
DIVA5     = SPACE(25)

PIVA1     = SPACE(3)
PIVA2     = SPACE(3)
PIVA3     = SPACE(3)
PIVA4     = SPACE(3)
PIVA5     = SPACE(3)

IMPOS1    = 0
IMPOS2    = 0
IMPOS3    = 0
IMPOS4    = 0
IMPOS5    = 0

PUBLIC VTOTIMP,VTOTIVA,VTOTDOC

VTOTIMP = 0
VTOTIVA = 0
VTOTDOC = 0
MATPUB  = 0   && MATERIALE PUBBLICITARIO


SELECT CU_FAT_DD

DAGGA = DAGGANCIO

PUBLIC V_TOP
V_TOP=''

x_tagg = "taggancio = '" + DAGGA + "'"
cSql   = "select * from u_fat_tt where " + x_tagg
IF !ExecCommand(cSql,"CU_FAT_TT")
   return(.f.)
ENDIF

SELECT CU_FAT_TT
GO TOP

V_INTESTA = ""

IF !EOF()

   SCATTER MEMVAR MEMO

   V_NUMFAT = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_PORTO  = M.ORD_PORTO
   V_VETTO  = M.ORD_VETTO
   V_MERCRE = M.ORD_MERCRE
   V_VALUTA = M.ORD_VALUTA
***  V_NSRIF  = M.ORD_RIFERI
   V_CAGE   = M.ORD_AGE
   V_PAG    = M.ORD_CPA
   V_DATA   = (M.ORD_DATORD)
   V_BANCA  = M.ORD_BANCA
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO

   ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 


   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi   
   cSql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP   
   IF EOF()
      WAIT WINDOWS "Cliente inesistente"+V_CODCLI
   ELSE
   
      V_RAGDUE  = CLI_RAGDUE
      VET_DAL[1]= CLI_BDAL
      VET_DAL[2]= CLI_B2DAL
      VET_AL[1] = CLI_BAL
      VET_AL[2] = CLI_B2AL
      VET_DAY[1]= CLI_GG1
      VET_DAY[2]= CLI_GG2

      ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
  	  ___CLIENTE     = V_CODCLI		&& 2010-08-04 sergio posticipi per tutto l'anno

   ENDIF         

   V_INTESTA=V_RAGSOC+CHR(13)
   IF !EMPTY(V_RAGDUE)
      V_INTESTA=V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   IF !EMPTY(V_RAGTRE)
      V_INTESTA=V_INTESTA+V_RAGTRE+CHR(13)
   ENDIF
   IF !EMPTY(V_RAGQUA)
      V_INTESTA=V_INTESTA+V_RAGQUA+CHR(13)
   ENDIF
   V_INTESTA=V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI

ELSE

   **--> SE NON LO TROVA CASO DELLA STAMPA DIRETTA DALLO SCHERMO CARICO LE VAR DI MEMORIA

   V_NUMFAT = M.ORD_NUMORD
   V_RAGSOC = M.ORD_RAGSOC
   V_RAGDUE = ""
   V_RAGTRE = ""
   V_RAGQUA = ""
   V_INDIRI = M.ORD_INDIRI
   V_CAP    = M.ORD_CAP
   V_LOCALI = M.ORD_LOCALI
   V_CODCLI = M.ORD_CODCLI
   V_PIVA   = M.ORD_PARIVA
   V_NSRIF  = M.ORD_RIFERI
   **V_VSRIF  = M._ORDDTCONS
   V_PAG    = M.ORD_CPA
   V_DATA   = M.ORD_DATORD
   V_BANCA  = M.ORD_BANCA
   V_CAGE   = M.ORD_AGE
   V_VALUTA = M.ORD_VALUTA 
   V_TOP    = M.ORD_CAUS
   V_SPINCA = M.ORD_SPBOLL   && SPESE INCASSO
   V_SPTRAS = M.ORD_SPTRAS   && SPESE TRASPORTO
   V_PORTO  = M.ORD_PORTO
   V_VETTO  = M.ORD_VETTO
   V_MERCRE = M.ORD_MERCRE

   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + V_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi   
   cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP   
   IF EOF()
   ELSE
      V_RAGDUE = CLI_RAGDUE
   ENDIF         

   V_INTESTA=V_RAGSOC+CHR(13)
   IF !EMPTY(V_RAGDUE)
      V_INTESTA=V_INTESTA+V_RAGDUE+CHR(13)
   ENDIF
   IF !EMPTY(V_RAGTRE)
      V_INTESTA=V_INTESTA+V_RAGTRE+CHR(13)
   ENDIF
   IF !EMPTY(V_RAGQUA)
      V_INTESTA=V_INTESTA+V_RAGQUA+CHR(13)
   ENDIF
   V_INTESTA=V_INTESTA+V_INDIRI+CHR(13)+V_CAP+" "+V_LOCALI
ENDIF

v_seek	= 'VET' + V_VETTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_VETTO = ALLTRIM(DESCRI)
ELSE
   V_VETTO = ""
ENDIF

v_seek	= 'POR' + V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   SAY_PORTO = ALLTRIM(DESCRI)
   V_PORTO   = ALLTRIM(DESCRI)
ELSE
   SAY_PORTO = ""
   V_PORTO   = ""
ENDIF

v_seek	= 'FAT000'				&& CHIUSURA PER FERIE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_FERIE = ALLTRIM(DESCRI)+ ' ' +ALLTRIM(LIBERA)
ELSE
   V_FERIE = ""
ENDIF

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + V_CODCLI + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP   
IF EOF()
   V_CFISC = " "
   V_ALRID = "   "
ELSE
   V_ALRID = CLI_ALRID
   V_CFISC = CLI_CODFIS
ENDIF         

v_seek	= 'CPA' + ALLTRIM(V_PAG)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
ELSE
   V_CPAG = SPACE(40)
ENDIF

v_seek	= 'AGE' + ALLTRIM(V_CAGE)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DAGE = DESCRI
ELSE
   V_DAGE = SPACE(40)
ENDIF

v_seek	= 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DPU = ALLTRIM(LIBERA)
ELSE
   DPU = ""
ENDIF

v_seek	= 'TOP' + ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
   NOTAC	= SUBSTR(LIBERA,11,1)
ELSE
   V_DESCAU = SPACE(40)
   NOTAC	= " "
ENDIF

x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
x_codi = "ban_codban = '" + ALLTRIM(V_BANCA) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_ban_an where " + x_cond + " order by ban_codsoc,ban_codban"
IF !ExecCommand(cSql,"CUR_BANCA")
   RETURN .F.
ENDIF
SELECT CUR_BANCA
GO TOP   
IF EOF()
   V_BANAP = SPACE(40)
ELSE
   V_BANAP = ALLTRIM(BAN_DESBAN)+' '+ALLTRIM(BAN_LOCA)+' ABI:'+ALLTRIM(BAN_CODABI)+' CAB:'+ALLTRIM(BAN_CODCAB)
ENDIF         

IF ALLTRIM(V_BANCA) = "."
   V_BANAP = SPACE(40)
ENDIF


***************************************************************************
*							FERIE											
***************************************************************************

*** GESTIONE FERIE *******************
IF SUBSTR(M.ORD_DATORD,4,2) = '07' .OR. SUBSTR(M.ORD_DATORD,4,2) = '12'

   IF !EMPTY(V_FERIE)
      SELECT CU_FAT_DD
      APPEND BLANK

      m.ord_codart = SPACE(16)
      M.ORD_MAGA   = SPACE(06)
      M.ORD_DESART = "*** COMMENTO ***"
      M.ORD_DES2   = SPACE(25)
      M.ORD_UM	   = SPACE(02)
      M.ORD_IVA	   = SPACE(02)
      M.ORD_PREZZO = 0
      M.ORD_QTAORD = 0
      M.ORD_PRZNET = 0
      M.ORD_VALORE = 0
      M.ORD_SC1    = 0
      M.ORD_SC2    = 0
      M.ORD_SC3    = 0	
      M.ORD_NOTE   = SPACE(10)
      M.ORD_PUBBLI = " "

      GATHER MEMVAR MEMO

      APPEND BLANK

      m.ord_codart = SPACE(16)
      M.ORD_MAGA   = SPACE(06)
      M.ORD_DESART = "*** COMMENTO ***"
      M.ORD_DES2   = SPACE(25)
      M.ORD_UM	   = SPACE(02)
      M.ORD_IVA	   = SPACE(02)
      M.ORD_PREZZO = 0
      M.ORD_QTAORD = 0
      M.ORD_PRZNET = 0
      M.ORD_VALORE = 0
      M.ORD_SC1    = 0
      M.ORD_SC2    = 0
      M.ORD_SC3    = 0	
      M.ORD_NOTE   = SPACE(10)
      M.ORD_PUBBLI = " "

      GATHER MEMVAR MEMO

      APPEND BLANK

      m.ord_codart = SPACE(16)
      M.ORD_MAGA   = SPACE(06)
      M.ORD_DESART = "*** COMMENTO ***"
      M.ORD_DES2   = SPACE(25)
      M.ORD_UM	   = SPACE(02)
      M.ORD_IVA	   = SPACE(02)
      M.ORD_PREZZO = 0
      M.ORD_QTAORD = 0
      M.ORD_PRZNET = 0
      M.ORD_VALORE = 0
      M.ORD_SC1    = 0
      M.ORD_SC2    = 0
      M.ORD_SC3    = 0	
      M.ORD_NOTE   = V_FERIE
      M.ORD_PUBBLI = " "

      GATHER MEMVAR MEMO

   ENDIF
ENDIF

SELECT CU_FAT_DD
APPEND BLANK
REPLACE DAGGANCIO WITH 'EOF'

GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART  = SUBSTR(ORD_DESART,1,16)

   IF ORD_PUBBLI = "S"			 && MATERIALE PUBBLICITARIO SI PAGA SOLO IVA
      MATPUB   = MATPUB + IMPONIB
   ENDIF

   v_seek	= 'IVA' + COD_IVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF

   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100

   IF ((IVA1 = SPACE(3)) .OR. (IVA1 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
      IVA1   = COD_IVA
      IMPO1  = IMPO1+IMPONIB
      IMPOS1 = IMPOS1 + IMPOSTA
   ELSE
      IF ((IVA2 = SPACE(3)) .OR. (IVA2 = COD_IVA))  .AND. (DES_ART <> ('*** COMMENTO ***'))
         IVA2   = COD_IVA
         IMPO2  = IMPO2+IMPONIB
         IMPOS2 = IMPOS2 + IMPOSTA
      ELSE
         IF ((IVA3 = SPACE(3)) .OR. (IVA3 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
            IVA3   = COD_IVA
            IMPO3  = IMPO3+IMPONIB
            IMPOS3 = IMPOS3 + IMPOSTA
         ELSE
            IF ((IVA4 = SPACE(3)) .OR. (IVA4 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
               IVA4   = COD_IVA
               IMPO4  = IMPO4+IMPONIB
               IMPOS4 = IMPOS4 + IMPOSTA
            ELSE
               IF ((IVA5 = SPACE(3)) .OR. (IVA5 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
                  IVA5   = COD_IVA
                  IMPO5  = IMPO5+IMPONIB
                  IMPOS5 = IMPOS5 + IMPOSTA
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   SELECT CU_FAT_DD
   SKIP +1

ENDDO


*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE = V_SPINCA + V_SPTRAS

IF !EMPTY(V_ALRID)
   V_IMPSP   = 0						&& IN ESENZIONE QUINDI NON CALOLA IVA SU TRASPORTO
ELSE
   V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
ENDIF

NETTO = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

ACCO_IVA = .F.

v_seek	= 'IVA' + IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = SUBSTR(LIBERA,1,03)
   DIVA1 = SUBSTR(DESCRI,1,25)
   IF IVA1 = PUB_IVA
  	  ACCO_IVA = .T.
      IMPO1  = IMPO1+V_SPESE
      IMPOS1 = IMPOS1 + V_IMPSP
   ENDIF
ENDIF

v_seek	= 'IVA' + IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = SUBSTR(LIBERA,1,03)
   DIVA2 = SUBSTR(DESCRI,1,25)
   IF IVA2 = PUB_IVA
  	  ACCO_IVA = .T.
      IMPO2  = IMPO2+V_SPESE
      IMPOS2 = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek	= 'IVA' + IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = SUBSTR(LIBERA,1,03)
   DIVA3 = SUBSTR(DESCRI,1,25)
   IF IVA3 = PUB_IVA
  	  ACCO_IVA = .T.
      IMPO3  = IMPO3+V_SPESE
      IMPOS3 = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek	= 'IVA' + IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = SUBSTR(LIBERA,1,03)
   DIVA4 = SUBSTR(DESCRI,1,25)
   IF IVA4 = PUB_IVA
	  ACCO_IVA = .T.
      IMPO4  = IMPO4+V_SPESE
      IMPOS4 = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek	= 'IVA' + IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = SUBSTR(LIBERA,1,03)
   DIVA5 = SUBSTR(DESCRI,1,25)
   IF IVA5 = PUB_IVA
	  ACCO_IVA = .T.
      IMPO5  = IMPO5+V_SPESE
      IMPOS5 = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

IF !ACCO_IVA    && SE NON ESIST UN IVA AL 20% NELLE RIGHE SOMMA IMPOSTA SPESE TRASP. ALLA PRIMA IVA
   v_seek	= 'IVA' + IVA1
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      PIVA1 = SUBSTR(LIBERA,1,03)
	  DIVA1 = SUBSTR(DESCRI,1,25)
      IMPO1  = IMPO1+V_SPESE
	  IMPOS1 = IMPOS1 + V_IMPSP
   ENDIF
ENDIF
 
TOT_IMPO = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5 - MATPUB

IF TOT_IMPO < 0        && SOLO MATERIALE PUBBLICITARIO
   TOT_IMPO = TOT_IMPO * -1
ENDIF


**--> ARROTONDAMENTO IVA

IF M.ORD_VALUTA = "ITL" .OR.  M.ORD_VALUTA = "LIT"
   IF TOT_IMPOS	-INT(TOT_IMPOS)<>0
	  TOT_IMPOS=INT(TOT_IMPOS)+1
   ENDIF
   IF IMPOS1	-INT(IMPOS1)<>0
	  IMPOS1=INT(IMPOS1)+1
   ENDIF
   IF IMPOS2	-INT(IMPOS2)<>0
	  IMPOS2=INT(IMPOS2)+1
   ENDIF
   IF IMPOS3	-INT(IMPOS3)<>0
	  IMPOS3=INT(IMPOS3)+1
   ENDIF
   IF IMPOS4	-INT(IMPOS4)<>0
	  IMPOS4=INT(IMPOS4)+1
   ENDIF
   IF IMPOS5	-INT(IMPOS5)<>0
	  IMPOS5=INT(IMPOS5)+1
   ENDIF
ELSE
   IMPOS1		=	ROUND((IMPOS1+.0000),2)
   IMPOS2		=	ROUND((IMPOS2+.0000),2)
   IMPOS3		=	ROUND((IMPOS3+.0000),2)
   IMPOS4		=	ROUND((IMPOS4+.0000),2)		
   IMPOS5		=	ROUND((IMPOS5+.0000),2)
ENDIF

TOT_IMPOS = IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5
TOT_FATT  = TOT_IMPO + TOT_IMPOS


***************************************************************************
*                    CREA TRANCHE                                         *
***************************************************************************


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_FATT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS  


V_DATASCAD = RIBALTA2(V_DATA)

V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_FATT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)

*!*	DO PERIODI
*!*	DO VAR_PERI

=CREA_SCADENZE()

RETURN

*************************
    PROCEDURE PERIODI
*************************

CONTA_TRA = 0
** RICERCA IMPORTO TRANCHE
IS = 0
XPAROLA = ''
DO PAROLA
IMP_TRANK = VAL(XPAROLA)

DO WHILE .T.

   CONTA_TRA = CONTA_TRA + 1
   * CNT IDENTIFICA IL NUMERO DI TRANCHE DETERMINATO DA TRANCHE
   IF CONTA_TRA > CNT
      RETURN
   ENDIF

   IF CONTA_TRA = CNT
      IMP_TRANK = IMP_TRANK + COMPENSO
   ENDIF

   ** RICERCA DATA SCADENZA
    
   XPAROLA = ''
   DO PAROLA
   DATA_SCAD = XPAROLA
   DO CREA_PERI

ENDDO

RETURN

*************************
    PROCEDURE PAROLA
*************************

DO WHILE .T.

   IS = IS + 1
   CARATT = SUBSTR(V_TUTTO,IS,1)
   IF !EMPTY(CARATT)
      XPAROLA = XPAROLA + SUBSTR(V_TUTTO,IS,1)
   ELSE
      EXIT
   ENDIF
ENDDO

RETURN

*************************
    PROCEDURE CREA_PERI
*************************

** ===>>> CREA I PERIODI DI SCADENZA

SELECT PERIODI

APPEND BLANK
REPLACE IMP_SCAD  WITH IMP_TRANK
REPLACE NUM_TRAN  WITH CONTA_TRA
REPLACE DSCAD     WITH DATA_SCAD

RETURN

*************************
  PROCEDURE VAR_PERI
*************************

PUBLIC ARRAY DATA(7)
PUBLIC ARRAY IMPORTO(7)

I = 0
SELECT PERIODI
GO TOP

DO WHILE (!EOF()) .AND. (I < 7)

   I = I + 1

   DATA[I]    = DSCAD
   IMPORTO[I] = IMP_SCAD

   SELECT PERIODI

   SKIP +1

ENDDO

I = I + 1

FOR HH = I TO 7

   DATA[HH]    = SPACE(10)
   IMPORTO[HH] = 0

NEXT

RETURN


*************************
  PROCEDURE CLEAR_VAR
*************************


IMPO1     = 0
IMPO2     = 0
IMPO3     = 0
IMPO4     = 0
IMPO5     = 0

IVA1      = SPACE(3)
IVA2      = SPACE(3)
IVA3      = SPACE(3)
IVA4      = SPACE(3)
IVA5      = SPACE(3)

IMPOS1    = 0
IMPOS2    = 0
IMPOS3    = 0
IMPOS4    = 0
IMPOS5    = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_FATT  = 0

CREATE CURSOR PERIODI;
  (DSCAD C(10),IMP_SCAD N(15,3),NUM_TRAN N(5))

V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_SPINCA  = 0
V_SPTRAS  = 0
NETTO     = 0
MATPUB    = 0

RETURN


*************************
  PROCEDURE RILA_VAR
*************************

RELEASE V_INTESTA
RELEASE V_RAGSOC
RELEASE V_INDIRI
RELEASE V_CAP
RELEASE V_LOCALI
RELEASE V_CODCLI
RELEASE V_PIVA
RELEASE V_VSRIF
RELEASE V_NSRIF
RELEASE V_PAG
RELEASE V_DATA
RELEASE V_BANCA
RELEASE V_CPAG
RELEASE V_BANAP
RELEASE V_NUMFAT
RELEASE V_DESCAU

RELEASE TOT_IMPO
RELEASE TOT_IMPOS
RELEASE TOT_FATT

RELEASE IMPO1
RELEASE IMPO2
RELEASE IMPO3
RELEASE IMPO4
RELEASE IMPO5

RELEASE IVA1
RELEASE IVA2
RELEASE IVA3
RELEASE IVA4
RELEASE IVA5

RELEASE IMPOS1
RELEASE IMPOS2
RELEASE IMPOS3
RELEASE IMPOS4
RELEASE IMPOS5

RELEASE VTOTIMP
RELEASE VTOTIVA
RELEASE VTOTDOC

RELEASE DAGGA
RELEASE V_TOP
RELEASE V_INTESTA

RELEASE V_CFISC
RELEASE V_CAGE
RELEASE V_DAGE
RELEASE V_VALUTA
RELEASE V_SPINCA
RELEASE V_SPTRAS
RELEASE NETTO
RELEASE MATPUB

RETURN