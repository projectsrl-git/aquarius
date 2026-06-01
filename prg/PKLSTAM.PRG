*********************************************************************************************
*								STAMPA PACKING-LIST									*
*********************************************************************************************

PUBLIC ULT_PAG

DO STAMPAPKL

x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_nazi = "cod_naz = '" + _CODNAZ + "'"
x_tipo = "tipo_doc = 'OR'"
x_cond = x_soci + " and " + x_nazi + " and " + x_tipo
cSql = "select * from lingue where " + x_cond + " order by codsoc,cod_naz,tipo_doc"
IF !ExecCommand(cSql,"CUR_LINGUE")
   RETURN .F.
ENDIF
SELECT CUR_LINGUE
GO TOP   
IF EOF()
   =MESSAGEBOX("Non trovo il codice nazione selezionato su"+CHR(13)+;
               "anagrafica lingue da stampare",62,"ATTENZIONE")
   SCATTER MEMVAR MEMO BLANK
ELSE
   SCATTER MEMVAR MEMO
ENDIF

SELECT CU_ORD_DD
GO TOP

FLAG_PREZZO = .T.

IF PUB_MAGLOG
   IF !EOF()
      DO PRG\MENUSTA WITH "CU_ORD_DD",_V_PREVIEW,_V_STAMPA,"XXX","PKL_MAGLOGIS","PKLMAGLO.FRX"
   ELSE
      =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
   ENDIF
ELSE
   IF !EOF()
      DO PRG\MENUSTA WITH "CU_ORD_DD",_V_PREVIEW,_V_STAMPA,"XXX","PKL_MAGCOORD","PKLMAGCO.FRX"
   ELSE
      =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
   ENDIF
ENDIF

DO RILA_VARZ    && RELEASE DI TUTTE LE VARIABILI

RETURN

*****************************
PROCEDURE STAMPAPKL
*****************************

*====>>>> CREAZIONE DI UN CURSORE PER SALVARE I VARI PERIODI DI SCADENZA

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15),NUM_TRAN N(5))

PUBLIC V_DATA,V_NUMORD,V_INTESTA,V_PIVA,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,V_CODCLI,V_NSRIF,V_PAG
PUBLIC V_BANAP,NUMORD,TOT_IMPO,TOT_IMPOS,TOT_ORDT,V_CPAG,V_VSRIF,V_DESCAU
PUBLIC IVA1,IVA2,IVA3,IVA4,IVA5,IMPO1,IMPO2,IMPO3,IMPO4,IMPO5,IMPOS1,IMPOS2,IMPOS3,IMPOS4,IMPOS5
PUBLIC V_CFISC,V_CAGE,V_DAGE,V_VALUTA,NETTO,MATPUB,V_RIGA1,V_RIGA2,V_RIGA3,V_DESTI
PUBLIC V_SPINCA,V_SPTRAS,V_OPE,V_UM
PUBLIC DIVA1,DIVA2,DIVA3,DIVA4,DIVA5
PUBLIC PIVA1,PIVA2,PIVA3,PIVA4,PIVA5
PUBLIC DS1,DS2,DS3,DS4,DS5
PUBLIC IS1,IS2,IS3,IS4,IS5
PUBLIC DESPUBL,V_PORTO,V_VETTO,V_MERCRE
PUBLIC V_TEL,V_FAX,V_DTCONS,V_SC1,V_SC2
PUBLIC X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA,X__NORME1,X__NORME2
PUBLIC X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES

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

X__FAX    = ""
X__COMUNI = ""
X__OGGETT = ""
X__COMMIS = ""
X__IMBALL = ""
X__GGCONS = ""
X__DESPES = ""
X__DESCPA = ""
X__NORME1 = ""
X__NORME2 = ""

X_ASPETT = ""
X_VETTO  = ""
X_PORTO  = ""
X_ACURA  = ""
X_CCODES = ""

V_INTESTA = ""
V_DESTI   = ""
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
V_NUMORD  = SPACE(10)
V_DESCAU  = "VENDITA"
V_CFISC   = SPACE(40)
V_CAGE    = SPACE(03)
V_DAGE    = SPACE(03)
V_VALUTA  = SPACE(15)
V_UM      = SPACE(02)

V_SPINCA  = 0
V_SPTRAS  = 0

TOT_IMPO  = 0
TOT_IMPOS = 0
TOT_ORDT  = 0

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

V_RIGA1 = SPACE(20)
V_RIGA2 = SPACE(20)
V_RIGA3 = SPACE(20)

v_seek	= 'DTE_R1' + PUB_CODSOC     && PARAMETRO - DATI TESTATA RIGA 1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_RIGA1 = ALLTRIM(DESCRI)
   V_RIGA2 = ALLTRIM(LIBERA)
ENDIF

v_seek	= 'DTE_R2' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_RIGA3 = ALLTRIM(LIBERA)
ENDIF

PUBLIC V_TOP
V_TOP = ''

V_INTESTA = ""
V_DESTI   = ""

V_OPE     = SUBSTR(M.ORD_CODOPE,1,1)
V_NUMORD  = M.ORD_NUMORD
V_RAGSOC  = M.ORD_RAGSOC
V_RAGDUE  = ""
V_RAGTRE  = ""
V_RAGQUA  = ""
V_INDIRI  = M.ORD_INDIRI
V_CAP     = M.ORD_CAP
V_LOCALI  = M.ORD_LOCALI
V_CODCLI  = M.ORD_CODCLI
V_PIVA    = M.ORD_PARIVA
V_VETTO   = "   "
V_PORTO   = M.ORD_PORTO
V_MERCRE  = "     "
V_CAGE    = M.ORD_AGE
V_PAG     = M.ORD_CPA
V_DATA    = M.ORD_DATORD
V_BANCA   = M.ORD_BANCA
V_TOP     = M.ORD_CAUS
V_DTCONS  = M.ORD_DTCONS
V_VALUTA  = M.ORD_VALUTA
V_SPINCA  = M.ORD_SPBOLL   && SPESE INCASSO
V_SPTRAS  = M.ORD_SPTRAS   && SPESE TRASPORTO
X__FAX    = M.ORD_FAX
X__COMUNI = M.ORD_COMUNI
X__OGGETT = M.ORD_OGGETT
X__COMMIS = M.ORD_COMMIS
X__IMBALL = M.ORD_IMBALL
X__GGCONS = M.ORD_GGCONS
X__DESPES = M.ORD_DESPES
X__NORME1 = M.ORD_NORME1
X__NORME2 = M.ORD_NORME2
V_INTESTA = V_RAGSOC+CHR(13)

IF !EMPTY(V_RAGDUE)
   V_INTESTA = V_INTESTA + V_RAGDUE + CHR(13)
ENDIF
IF !EMPTY(V_RAGTRE)
   V_INTESTA = V_INTESTA + V_RAGTRE + CHR(13)
ENDIF
IF !EMPTY(V_RAGQUA)
   V_INTESTA = V_INTESTA + V_RAGQUA + CHR(13)
ENDIF
V_INTESTA = V_INTESTA + V_INDIRI + CHR(13) + V_CAP + " " + V_LOCALI
IF !EMPTY(M.ORD_RAGC)
   V_DESTI = M.ORD_RAGC + CHR(13)
   V_DESTI = V_DESTI + M.ORD_INDC + CHR(13)
   V_DESTI = V_DESTI + M.ORD_CAPC + M.ORD_LOCC
ENDIF

v_seek	= 'POR' + V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_PORTO = DESCRI
ELSE
   V_PORTO = ""
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
  WAIT WINDOWS "Cliente inesistente"+V_CODCLI
  V_CFISC = " "
  V_TEL   = SPACE(12)
  V_FAX   = SPACE(12)

   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
  ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
  ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 


ELSE
  V_CFISC = CLI_CODFIS
  V_TEL   = CLI_TELEFO
  V_FAX   = CLI_FAX
  IF EMPTY(V_CAGE)
     V_CAGE = "   "
  ENDIF
  VET_DAL[1]= CLI_BDAL
  VET_DAL[2]= CLI_B2DAL
  VET_AL[1] = CLI_BAL
  VET_AL[2] = CLI_B2AL
  VET_DAY[1]= CLI_GG1
  VET_DAY[2]= CLI_GG2
  ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
  ___CLIENTE     = V_CODCLI			&& 2010-08-04 sergio posticipi per tutto l'anno
  
  
ENDIF

v_seek	= 'CPA' + V_PAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CPAG = DESCRI
   DO CASE
      CASE _CODNAZ = "ITA"
           X__DESCPA = ITALIANO
      CASE _CODNAZ = "ING"
           X__DESCPA = INGLESE
      CASE _CODNAZ = "FRA"
           X__DESCPA = FRANCESE
      CASE _CODNAZ = "GER"
           X__DESCPA = TEDESCO
      CASE _CODNAZ = "SPA"
           X__DESCPA = SPAGNOLO
   ENDCASE
ELSE
   V_CPAG    = SPACE(40)
   X__DESCPA = ""
ENDIF

v_seek	= 'AGE' + ALLTRIM(V_CAGE)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DAGE = DESCRI
ELSE
   V_DAGE = SPACE(40)
ENDIF

IF "NESSUNO" $ V_DAGE
   V_DAGE = "       "
ENDIF
IF ALLTRIM(V_DAGE) = "."
   V_DAGE = "       "
ENDIF

v_seek	= 'PUB000'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   DESPUBL = ALLTRIM(LIBERA)
ELSE
   DESPUBL = ""
ENDIF

v_seek	= 'TOP' + ALLTRIM(V_TOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_DESCAU = DESCRI
ELSE
   V_DESCAU = SPACE(40)
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

v_seek	= 'ASP' + M.ORD_ASPETT
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_ASPETT = SUBSTR(DESCRI,1,30)
ELSE
   X_ASPETT = ""
ENDIF

v_seek	= 'VET' + ALLTRIM(M.ORD_VETTO1)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_VETTO = SUBSTR(DESCRI,1,30)
ELSE
   X_VETTO = ""
ENDIF

v_seek	= 'POR' + ALLTRIM(M.ORD_PORTO)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_PORTO = SUBSTR(DESCRI,1,30)
ELSE
   X_PORTO = ""
ENDIF

v_seek	= 'MEZ' + ALLTRIM(M.ORD_ACURA)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   X_ACURA = SUBSTR(DESCRI,1,30)
ELSE
   X_ACURA = ""
ENDIF

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(M.ORD_CCOSTO) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
cSql = "select * from ccosto where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"CUR_CCOSTO")
   RETURN .F.
ENDIF
SELECT CUR_CCOSTO
GO TOP   
IF EOF()
   X_CCODES = ""
ELSE
   X_CCODES = SUBSTR(CON_DESCR,1,30)
ENDIF         

CTR_REC = 0
ULT_PAG = 0

IF !ExecCommand("select * from u_ord_dd where 0=1","u_ord_dd")
   return(.f.)
ENDIF
SELECT U_ORD_DD
HH=AFIELDS(TRANSITO)
CREATE CURSOR CU_ORD_DD FROM ARRAY TRANSITO

IF PUB_MLPLTU .OR. PUB_MLPLDT
   SELECT CU_ORD_DD
   =MODTBL(ALIAS(SELECT()),"LOC_COORDL","C(10)")
   =MODTBL(ALIAS(SELECT()),"LOC_DATCAR","C(10)")
   =MODTBL(ALIAS(SELECT()),"LOC_QTAGIA","N(11,2)")
ENDIF

x_cond = "daggancio = '" + ALLTRIM(NUMPRO) + "'"
Csql   = "select * from u_ord_dd where " + x_cond + " order by daggancio"
IF !ExecCommand(cSql,"cu_dettagli")
   return(.f.)
ENDIF
SELECT CU_DETTAGLI
GO TOP
IF EOF()
   PUB_ERRORE=MESSAGEBOX('Dettagli inesistenti ordine : '+ M.ORD_NUMORD,64,'*** ATTENZIONE ***')
   RETURN
ENDIF

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
      SELECT CU_DETTAGLI
      SKIP +1
      LOOP
   ENDIF

   IF ORD_QTAORD < ORD_QTAEV .OR. ;
      ORD_QTAORD = ORD_QTAEV .OR. ;
      ORD_CHIUSO = .T.
      SKIP +1
      LOOP
   ENDIF          	

   COD_IVA = ORD_IVA
   IMPONIB = ORD_VALORE
   DES_ART = SUBSTR(ORD_DESART,1,16)

   SCATTER MEMVAR MEMO

   * VERIFICA SE DEVE STAMPARE LA RIGA IN MODO SINTETICO
   =VERYSIN("CU_DETTAGLI")

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
      IMPO1  = IMPO1 + IMPONIB
      IMPOS1 = IMPOS1 + IMPOSTA
   ELSE
      IF ((IVA2 = SPACE(3)) .OR. (IVA2 = COD_IVA))  .AND. (DES_ART <> ('*** COMMENTO ***'))
         IVA2   = COD_IVA
         IMPO2  = IMPO2 + IMPONIB
         IMPOS2 = IMPOS2 + IMPOSTA
      ELSE
         IF ((IVA3 = SPACE(3)) .OR. (IVA3 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
            IVA3   = COD_IVA
            IMPO3  = IMPO3 + IMPONIB
            IMPOS3 = IMPOS3 + IMPOSTA
         ELSE
            IF ((IVA4 = SPACE(3)) .OR. (IVA4 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
               IVA4   = COD_IVA
               IMPO4  = IMPO4 + IMPONIB
               IMPOS4 = IMPOS4 + IMPOSTA
            ELSE
               IF ((IVA5 = SPACE(3)) .OR. (IVA5 = COD_IVA)) .AND. (DES_ART <> ('*** COMMENTO ***'))
                  IVA5   = COD_IVA
                  IMPO5  = IMPO5 + IMPONIB
                  IMPOS5 = IMPOS5 + IMPOSTA
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   **--> ACQUISIZIONE DELLA QTA' IN GIACENZA STANDARD

   IF V_OPZGIAC = 1
      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "mag_codmag = '" + M.ORD_MAGS + "'"
      x_arti = "mag_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi + " and " + x_arti
      cSql = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecCommand(cSql,"CUR_GIACENZE")
         RETURN .F.
      ENDIF
      SELECT CUR_GIACENZE
      GO TOP   
      IF EOF()
         M.ORD_QTAORG = 0
      ELSE
         M.ORD_QTAORG = MAG_GIACEN
      ENDIF    
   ELSE
      SELECT CU_MAG_AN
      GO TOP
      LOCATE FOR MAG_CODSOC = PUB_CODSOC .AND. ;
                 MAG_CODMAG = M.ORD_MAGS .AND. ;
                 MAG_CODART = M.ORD_CODART
      IF FOUND()
         M.ORD_QTAORG = MAG_GIACEN
      ELSE
         x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
         x_codi = "mag_codmag = '" + M.ORD_MAGS + "'"
         x_arti = "mag_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
         x_cond = x_soci + " and " + x_codi + " and " + x_arti
         cSql = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
         IF !ExecCommand(cSql,"CUR_GIACENZE")
            RETURN .F.
         ENDIF
         SELECT CUR_GIACENZE
         GO TOP   
         IF EOF()
            M.MAG_CODSOC = PUB_CODSOC
            M.MAG_CODMAG = M.ORD_MAGS
            M.MAG_CODART = M.ORD_CODART
            M.MAG_MAGIAC = 0
         ELSE
            SCATTER MEMVAR MEMO
         ENDIF    
         SELECT CU_MAG_AN
         APPEND BLANK
         GATHER MEMVAR MEMO
         M.ORD_QTAORG = MAG_GIACEN
      ENDIF
      REPLACE MAG_GIACEN WITH MAG_GIACEN - (M.ORD_QTAORD - M.ORD_QTAEV)
      IF M.ORD_MAGD = SPACE(06)
      ELSE
         GO TOP
         LOCATE FOR MAG_CODSOC = PUB_CODSOC .AND. ;
                    MAG_CODMAG = M.ORD_MAGS .AND. ;
                    MAG_CODART = M.ORD_CODART
         IF FOUND()
            M.ORD_QTAORG = MAG_GIACEN
         ELSE
            x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
            x_codi = "mag_codmag = '" + M.ORD_MAGD + "'"
            x_arti = "mag_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
            x_cond = x_soci + " and " + x_codi + " and " + x_arti
            cSql = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
            IF !ExecCommand(cSql,"CUR_GIACENZE")
               RETURN .F.
            ENDIF
            SELECT CUR_GIACENZE
            GO TOP   
            IF EOF()
               M.MAG_CODSOC = PUB_CODSOC
               M.MAG_CODMAG = M.ORD_MAGD
               M.MAG_CODART = M.ORD_CODART
               M.MAG_MAGIAC = 0   
            ELSE
               SCATTER MEMVAR MEMO
            ENDIF    

            SELECT CU_MAG_AN
            APPEND BLANK
            GATHER MEMVAR MEMO
            M.ORD_QTAORG = MAG_GIACEN
         ENDIF
         REPLACE MAG_GIACEN WITH MAG_GIACEN + (M.ORD_QTAORD - M.ORD_QTAEV)
      ENDIF
   ENDIF

   **--> ACQUISIZIONE DELLA QTA' IN ORDINE A FORNITORE

   M.ORD_QTAORF = GETORFO(M.ORD_CODART,M.ORD_DATCON)

   **--> ACQUISIZIONE DELLA SCORTA MINIMA DELL'ARTICOLO

   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + M.ORD_CODART + "'"
   x_cond = x_soci + " and " + x_codi
   cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"CUR_ARTICOLI")
      RETURN .F.
   ENDIF
   SELECT CUR_ARTICOLI
   GO TOP
   IF EOF()
      M.ORD_QTAORP = 0
      M.ORD_COORD  = SPACE(10)
   ELSE
	  M.ORD_QTAORP = ART_SCORMI
	  M.ORD_COORD  = ART_COORD
   ENDIF

  * IF PUB_MLPLTU .OR. PUB_MLPLDT
  *    M.LOC_COORDL = SPACE(10)
  *    M.LOC_DATCAR = SPACE(10)
  *    M.LOC_QTAGIA = 0
  *    V_PRIMO = .T.
  * ELSE
  *    SELECT CU_ORD_DD
  *    APPEND BLANK
  *    GATHER MEMVAR MEMO
  * ENDIF

   IF PUB_MAGLOG
      IF PUB_MLPLTU .OR. PUB_MLPLDT
         M.LOC_COORDL = SPACE(10)
         M.LOC_DATCAR = SPACE(10)
         M.LOC_QTAGIA = 0
         V_PRIMO = .T.
      ELSE
         SELECT CU_ORD_DD
         APPEND BLANK
         GATHER MEMVAR MEMO
      ENDIF
   ELSE
      V_DAEVAD = (M.ORD_QTAORD - M.ORD_QTAEV)
      IF V_DAEVAD <= M.ORD_QTAORG
      ELSE 
         W_FLAG = .F.
      ENDIF
      IF M.ORD_QTAORG > 0
         SELECT CU_ORD_DD
         APPEND BLANK
         GATHER MEMVAR MEMO
      ENDIF
      CTR_REC = CTR_REC +1
      SELECT CU_DETTAGLI
      SKIP +1
      LOOP
   ENDIF

   **--> ACQUISIZIONE DELLA QTA' IN GIACENZA SU MAGAZZINO LOGISTICO
   IF PUB_MLPLTU .OR. PUB_MLPLDT
      SELECT CU_ORD_DD
      IF V_OPZGIAC = 1
         X_QTAORD = M.ORD_QTAORD
         X_QTAGIA = 0
         x_soci = "loc_codmag = '" + M.ORD_MAGS + "'"
         x_codi = "loc_codart = '" + M.ORD_CODART + "'"
         x_cond = x_soci + " and " + x_codi
         cSql = "select * from u_loc_gi where " + x_cond + " order by loc_codmag,loc_codart"
         IF !ExecCommand(cSql,"U_LOC_GI")
            RETURN .F. 
         ENDIF
         SELECT U_LOC_GI
         GO TOP
         DO WHILE .T.
            IF EOF()
               EXIT
            ENDIF
            M.LOC_COORDL = ALLTRIM(LOC_CORSIA) + '-' + ALLTRIM(STR(LOC_FILA,2,0)) + '-' + ALLTRIM(STR(LOC_PIANO,2,0))
            M.LOC_DATCAR = LOC_DATCAR
            M.LOC_QTAGIA = LOC_QTAGIA
            IF V_PRIMO
               V_PRIMO = .F.
            ELSE
               M.ORD_QTAORD = 0
               M.ORD_QTAORG = 0
               M.ORD_QTAORP = 0
            ENDIF
            SELECT CU_ORD_DD
            APPEND BLANK
            GATHER MEMVAR MEMO
            IF PUB_MLPLTU
            ELSE
               SELECT U_LOC_GI
               X_QTAGIA = X_QTAGIA + LOC_QTAGIA
               IF X_QTAORD > X_QTAGIA
               ELSE
                  EXIT
               ENDIF
            ENDIF
            SELECT U_LOC_GI
            SKIP +1
         ENDDO
      ELSE
         SELECT CU_LOC_GI
         SET ORDER TO CI_LOC6
         SEEK M.ORD_MAGS+M.ORD_CODART
         X_QTAORD  = M.ORD_QTAORD
         X_QTAGIA  = 0
         X_CALCOLA = .T.
         IF FOUND()
            DO WHILE .T.
               IF EOF()
                  EXIT
               ENDIF
               IF LOC_CODMAG = M.ORD_MAGS .AND. LOC_CODART = M.ORD_CODART
               ELSE
                  EXIT
               ENDIF
               M.LOC_COORDL = ALLTRIM(LOC_CORSIA) + '-' + ALLTRIM(STR(LOC_FILA,2,0)) + '-' + ALLTRIM(STR(LOC_PIANO,2,0))
               M.LOC_DATCAR = LOC_DATCAR
               M.LOC_QTAGIA = LOC_QTAGIA
               IF V_PRIMO
                  V_PRIMO = .F.
               ELSE
                  M.ORD_QTAORD = 0
                  M.ORD_QTAORG = 0
                  M.ORD_QTAORP = 0
               ENDIF
               SELECT CU_ORD_DD
               APPEND BLANK
               GATHER MEMVAR MEMO
               SELECT CU_LOC_GI
               IF X_CALCOLA
                  X_QTAGIA = X_QTAGIA + LOC_QTAGIA
                  IF X_QTAORD > X_QTAGIA
                     DELETE
                  ELSE
                     REPLACE LOC_QTAGIA WITH X_QTAGIA - X_QTAORD
                     IF LOC_QTAGIA > 0
                     ELSE
                        DELETE
                     ENDIF
                     X_CALCOLA = .F.
                  ENDIF
               ENDIF
               IF PUB_MLPLTU
               ELSE
                  IF X_QTAORD > X_QTAGIA
                  ELSE
                     EXIT
                  ENDIF
               ENDIF
               SELECT CU_LOC_GI
               SKIP +1
            ENDDO
         ENDIF
      ENDIF
      IF V_PRIMO
         SELECT CU_ORD_DD
         APPEND BLANK
         GATHER MEMVAR MEMO
      ENDIF
   ENDIF

   CTR_REC = CTR_REC +1

   SELECT CU_DETTAGLI
   SKIP +1

ENDDO

ULT_PAG = CTR_REC / 5

*** SOMMA SPESE DI TRASPORTO + INCASSO
V_SPESE   = V_SPINCA + V_SPTRAS

PUB_IVADEF = CERCA_IVA_DEFAULT("U_ORD_DD","CODICE")  && ERASMO - 21/09/2011
PUB_ALIQ = CERCA_IVA_DEFAULT("U_ORD_DD","ALIQUOTA")  && ERASMO - 21/09/2011

*V_IMPSP   = V_SPESE * (VAL(PUB_IVA)/100)
V_IMPSP = V_SPESE * (PUB_ALIQ/100)  && ERASMO - 21/09/2011

NETTO     = (IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5) - MATPUB

v_seek	= 'IVA' + IVA1
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA1 = IVA1
   DIVA1 = SUBSTR(DESCRI,1,25)
   *IF IVA1 = PUB_IVA
   IF IVA1 = PUB_IVADEF  && ERASMO - 21/09/2011
      IMPO1  = IMPO1 + V_SPESE
      IMPOS1 = IMPOS1 + V_IMPSP
   ENDIF
ENDIF
   
v_seek	= 'IVA' + IVA2
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA2 = IVA2
   DIVA2 = SUBSTR(DESCRI,1,25)
   *IF IVA2 = PUB_IVA
   IF IVA2 = PUB_IVADEF  && ERASMO - 21/09/2011
      IMPO2  = IMPO2 + V_SPESE
      IMPOS2 = IMPOS2 + V_IMPSP
   ENDIF
ENDIF

v_seek	= 'IVA' + IVA3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA3 = IVA3
   DIVA3 = SUBSTR(DESCRI,1,25)
   *IF IVA3 = PUB_IVA
   IF IVA3 = PUB_IVADEF  && ERASMO - 21/09/2011
      IMPO3  = IMPO3 + V_SPESE
      IMPOS3 = IMPOS3 + V_IMPSP
   ENDIF
ENDIF

v_seek	= 'IVA' + IVA4
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA4 = IVA4
   DIVA4 = SUBSTR(DESCRI,1,25)
   *IF IVA4 = PUB_IVA
   IF IVA4 = PUB_IVADEF  && ERASMO - 21/09/2011
      IMPO4  = IMPO4 + V_SPESE
      IMPOS4 = IMPOS4 + V_IMPSP
   ENDIF
ENDIF

v_seek	= 'IVA' + IVA5
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   PIVA5 = IVA5
   DIVA5 = SUBSTR(DESCRI,1,25)
   *IF IVA5 = PUB_IVA
   IF IVA5 = PUB_IVADEF  && ERASMO - 21/09/2011
      IMPO5  = IMPO5 + V_SPESE
      IMPOS5 = IMPOS5 + V_IMPSP
   ENDIF
ENDIF

TOT_IMPO  = IMPO1 + IMPO2 + IMPO3 + IMPO4 + IMPO5

IF TOT_IMPO < 0        && SOLO MATERIALE PUBBLICITARIO
 TOT_IMPO = TOT_IMPO * -1
ENDIF

TOT_IMPOS = IMPOS1 + IMPOS2 + IMPOS3 + IMPOS4 + IMPOS5

**--> ARROTONDAMENTO IVA

TOT_IMPOS =	ROUND((TOT_IMPOS),2)
IMPOS1	  =	ROUND((IMPOS1),2)
IMPOS2	  =	ROUND((IMPOS2),2)
IMPOS3	  =	ROUND((IMPOS3),2)
IMPOS4	  =	ROUND((IMPOS4),2)		
IMPOS5	  =	ROUND((IMPOS5),2)

TOT_ORDT  = TOT_IMPO + TOT_IMPOS


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= TOT_ORDT - TOT_IMPOS   
__T_IMPOS   = TOT_IMPOS  

***************************************************************************
*                    CREA TRANCHE                                         *
***************************************************************************

V_DATASCAD = RIBALTA2(V_DATA)

V_TUTTO    = TRANCHE("PARA",V_PAG,V_DATASCAD,TOT_ORDT,VET_DAL,VET_AL,VET_DAY,V_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)

*!*	DO PERIODIZ
*!*	DO VAR_PERIZ

=CREA_SCADENZE()

RETURN

*************************
  PROCEDURE PERIODIZ
*************************

CONTA_TRA = 0

** RICERCA IMPORTO TRANCHE
IS      = 0
XPAROLA = ''

DO PAROLAZ

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

   DO PAROLAZ

   DATA_SCAD = XPAROLA

   DO CREA_PERIZ

ENDDO

RETURN

*************************
  PROCEDURE PAROLAZ
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
  PROCEDURE CREA_PERIZ
*************************

** ===>>> CREA I PERIODI DI SCADENZA

SELECT PERIODI
APPEND BLANK

REPLACE IMP_SCAD WITH IMP_TRANK
REPLACE NUM_TRAN WITH CONTA_TRA
REPLACE DSCAD    WITH DATA_SCAD

RETURN

*************************
  PROCEDURE VAR_PERIZ
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
  PROCEDURE CLEAR_VARZ
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
TOT_ORDT  = 0

CREATE CURSOR PERIODI;
   (DSCAD C(10),IMP_SCAD N(15),NUM_TRAN N(5))

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
  PROCEDURE RILA_VARZ
*************************

RELEASE V_RIGA1
RELEASE V_RIGA2
RELEASE V_RIGA3
RELEASE V_INTESTA
RELEASE V_DESTI
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
RELEASE V_NUMORD
RELEASE V_DESCAU
RELEASE V_OPE
RELEASE TOT_IMPO
RELEASE TOT_IMPOS
RELEASE TOT_ORDT

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

RELEASE V_TEL
RELEASE V_FAX
RELEASE V_DTCONS
RELEASE V_SC1
RELEASE V_SC2
RELEASE X__FAX,X__COMUNI,X__OGGETT,X__COMMIS,X__IMBALL,X__GGCONS,X__DESPES,X__DESCPA
RELEASE X_ASPETT,X_VETTO,X_PORTO,X_ACURA,X_CCODES

RETURN