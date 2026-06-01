**********************************************************************************************
* 			 CREAZIONE MOVIMENTI CONTABILI PER COMPENSAZIONE IVA REVERSE CHANGE				 *
*			 A FRONTE DI NOTE DI CREDITO									 				 *
**********************************************************************************************
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_PESO,XNPRO,XNUMPRO,NOTAC,DATA_SCAD,CT,XXCONTO
RELEASE NPROT,__CEE
PUBLIC  NPROT,__CEE

XDESF     = "REGISTRAZIONE AUTOMATICA"
COMPENSO  = 0
TIVA      = 0
CIVA      = 0
TOP_TOP   = SPACE(03)
DATREG    = XDATA      && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
NOTAC     = " "
DATA_SCAD = ""

IF !ExecCommand("select * from mov_cont where 1=0","mov_cont")
   return(.f.)
ENDIF
SELECT MOV_CONT
HH=AFIELDS(TRANSITO)
CREATE CURSOR CMOV_CONT FROM ARRAY TRANSITO

PUBLIC M.TAGGANCIO
M.TAGGANCIO = ""

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

*--> PRELEVA I DATI AZIENDALI

x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"u_azi_an")
   return(.f.)
ENDIF
SELECT u_azi_an
GO TOP
IF !EOF()
   M.ORD_CODCLI	= AZI_CODCLI
   M.ORD_RAGSOC	= AZI_RAGSOC
   M.ORD_INDIRI	= AZI_INDIRI
   M.ORD_CAP	= AZI_CAP
   M.ORD_LOCALI	= AZI_LOCALI
   M.ORD_PARIVA	= AZI_PIVA
   V_TELEFO     = AZI_TELEFO
ELSE
   M.ORD_CODCLI	= SPACE(10)
   M.ORD_RAGSOC	= SPACE(40)
   M.ORD_INDIRI	= SPACE(40)
   M.ORD_CAP	= SPACE(05)
   M.ORD_LOCALI	= SPACE(40)
   M.ORD_PARIVA	= SPACE(11)
   V_TELEFO     = ""
   WAIT WINDOW "Per cortesia codifica i dati anagrafici per bollati con apposita procedura"
ENDIF


TOP_TOP  = PUB_NOTRC                   && COMPENSAZIONE NOTE CREDITO REVERSE CHANGE
_TOP = SEEK_PARA('TOP',ALLTRIM(TOP_TOP),'CODICE','CODICE',"4,10")

IF EMPTY(_TOP)
   =MESSAGEB("Errore manca parametro TOP : "+TOP_TOP,64,"*** ATTENZIONE ***")
   RETURN
ENDIF

SELECT _pj_para
XXCONTO = CONTO1

IF EMPTY(XXCONTO)
   WAIT WINDOW "Errore manca conto nel parametro TOP : "+TOP_TOP
   RETURN
ENDIF

ANNODAL  = SUBSTR(DATADAL,7,4)
V_TOTALE = 0
CT       = 0
CTRELAB  = 0
PERDAL   = RIBALTA2(DATADAL)
PERAL    = RIBALTA2(DATAAL)
CT       = 0
CTRELAB  = 0
V_IVACEE = SPACE(20)

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + ANNODAL + "'"
x_data = "mov_dtreg >= '" + PERDAL + "'"
cSql="SELECT * FROM mov_cont WHERE " + x_soci + " and " + x_anno + " and " + x_data + ;
                                   " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"
IF !ExecCommand(cSql,"CU_MOVCONT")
   return(.f.)
ENDIF
SELECT CU_MOVCONT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SELECT CU_MOVCONT
      SKIP +1
      LOOP
   ENDIF

   IF MOV_DTREG > PERAL
      EXIT
   ENDIF

   IF MOV_NOTRC = "S"					&& SCARTA MOVIMENTO GIA' TRATTATO
      SELECT CU_MOVCONT
      SKIP +1
      LOOP
   ENDIF


   SELECT CU_MOVCONT
   _TOP=MOV_TOP



   v_seek	= 'TOP' + _TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
	  CEE 		=SUBSTR(LIBERA,23,1)
      _NOTAC  	=SUBSTR(LIBERA,11,1)			&& NOTA CREDITO = S
   ELSE
	  CEE 		= " "
      _NOTAC  	= " "
   ENDIF

   SELECT CU_MOVCONT

   IF _NOTAC  <> "S"
      SELECT CU_MOVCONT
      SKIP +1
      LOOP
   ENDIF


   IF CEE <> "R"
      SELECT CU_MOVCONT
	  SKIP +1
	  LOOP
   ENDIF

   XX_CONTO = MOV_CONTO
   XX_ANNO  = MOV_ANNO
   XX_NREGI = MOV_NREGIS

   _TIPOCO = " "

   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + XX_ANNO + "'"
   x_cont = "con_conto = '" + ALLTRIM(XX_CONTO) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecCommand(cSql,"conti")
      return(.f.)
   ENDIF
   SELECT conti
   GO TOP
   IF EOF()
 	  =MESSAGEBOX("Registrazione non corretta "+XX_NREGI+CHR(13)+"manca conto "+XX_CONTO,16,"*** ATTENZIONE ***")
	  RETURN
   ELSE
      _TIPOCO=CON_TIPOCO
   ENDIF

   SELECT CU_MOVCONT

   IF _TIPOCO <> "I"    && SCARTA I MOVIMENTI NON IVA
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO	    && Salva i vecchi valori

   CTRELAB=CTRELAB+1
   WAIT WINDOWS "Fatture Fornitori elaborate : "+STR(CTRELAB,6,0) NOWAIT

   =CEI_CREA()
   =CEI_AGGIORNA_MOV_CONT()

   SELECT CU_MOVCONT
   SKIP +1

ENDDO

=CEI_COPIA() 		&& COPIA DAL CURSORE SU MOV_CONT

IF CTRELAB <> 0
   =MESSAGEBOX("Creazione movimenti iva compensazione acquisti su NOTE CREDITO REVERSE CHANGE"+CHR(13)+"terminata correttamente",16,"*** ATTENZIONE ***")
ELSE
   =MESSAGEBOX("Nessun movimento creato"+CHR(13)+"",16,"*** ATTENZIONE ***")
ENDIF

RETURN


*************************
FUNCTION CEI_CREA			&& CREA MOVIMENTI PER COMPENSAZIONE CEE
*************************



XDESF    = M.MOV_DESCR
XVALUTA  = M.MOV_VALUTA
XCAMBIO  = M.MOV_CAMBIO
VALFAT   = M.MOV_IMP
VALUTA   = M.MOV_VALUTA
XDOC     = M.MOV_NDOC
XDTDOC   = M.MOV_DTDOC
XNPRO    = M.MOV_NPROT
XNUMPRO  = M.MOV_NUMPRO
XNPART   = M.MOV_NPART     && NUMERO PARTITA ORIGINALE DA ATTRIBUIRE ALLA COMPENSAZIONE IVA
XTOP     = M.MOV_TOP
VALORE   = CAMBIO(XVALUTA,VALFAT,XCAMBIO)
NUMF     = ALLTRIM(M.MOV_NDOC)
V_PESO   = OK_ARROT1(M.MOV_PESO,XVALUTA)
V_TISPE  = M.MOV_TISPE

DO REG_NUMRPN
DO REG_NUMREG

v_seek 	 = 'TOP' + XTOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   NOTAC	= SUBSTR(LIBERA,11,1)
ELSE
   NOTAC	= " "
ENDIF

SELECT CU_MOVCONT

_RS     = " "
_KK     = MOV_SOC+MOV_ANNO+MOV_NUMPRO
M.CONTO = " "

* ACCEDE A INDICE PER PRELEVARE IL CODICE DEL FORNITORE
x_soci = "mov_soc = '" + MOV_SOC + "'"
x_anno = "mov_anno = '" + MOV_ANNO + "'"
x_npro = "mov_numpro = '" + ALLTRIM(MOV_NUMPRO) + "'"
cSql="SELECT * FROM indice WHERE " + x_soci + " and " + x_anno + " and " + x_npro + ;
                                   " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(cSql,"INDICE")
   return(.f.)
ENDIF
SELECT INDICE
GO TOP
IF !EOF()
   M.CONTO  = MOV_CONTO
   V_CODFOR = SUBSTR(MOV_CONTO,PUB_SOTTOG,9)
   x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "for_codcli = '" + ALLTRIM(V_CODFOR) + "'"
   x_cond = x_soci + " and " + x_codi
   cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
   IF !ExecCommand(cSql,"CUR_FORNITORE")
      RETURN .F.
   ENDIF
   SELECT CUR_FORNITORE
   GO TOP
   IF !EOF()
      _RS  		= FOR_RAGSOC
      M.RAGSOC	= FOR_RAGSOC
   ELSE
      _RS  = " "
      M.RAGSOC	= ""
   ENDIF
ELSE
   WAIT WINDOWS "Attenzione indice non trovato su NUMPRO "+_KK
   SELECT CU_MOVCONT
   RETURN
ENDIF

SELECT CU_MOVCONT

XNOTA   = SUBSTR(_RS,1,25) + " N.DOC: " + XDOC

IF NOTAC   = "S"
   DAVD    = "A"
   DAVA    = "D"
ELSE
   DAVD    = "D"
   DAVA    = "A"
ENDIF

** CREA MOVIMENTO IN DARE SU FORNITORE
DO MOVCRINC WITH DAVD,VALORE,0,'NO',M.CONTO,TOP_TOP,XDOC,XDTDOC,.T.,XDOC,XVALUTA,XCAMBIO  &&TESTATA
DO MOVCREAI WITH DAVD,VALORE,0,'NO',M.CONTO,TOP_TOP,XDOC,XDTDOC,XDOC,XVALUTA,XCAMBIO      &&INDICE

** CREA MOVIMENTO IN AVERE SU IVA CLIENTI
DO MOVCRINC WITH DAVA,VALORE,0,'NO',XXCONTO,TOP_TOP,XDOC,XDTDOC,.F.,XDOC,XVALUTA,XCAMBIO   &&DETTAGLI

RETURN


*************************
FUNCTION CEI_COPIA			&& COPIA SU MOV_CONT IL CURSORE
*************************

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF

SELECT CMOV_CONT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SELECT CMOV_CONT
   SCATTER MEMVAR MEMO
   SELECT CU_MOVCONT
   APPEND BLANK
   GATHER MEMVAR MEMO
   SELECT CMOV_CONT
   SKIP +1
ENDDO
IF !ExecRW('','mov_cont','I','','CU_MOVCONT')
   return(.f.)
ENDIF

RETURN


***************************************************************************
PROCEDURE MOVCRINC      && crea la partita primaria
***************************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,PARTITARIO,NPRO,YVALUTA,YCAMBIO

SELE=SELECT()

SELECT CMOV_CONT
APPEND BLANK
REPLACE MOV_SOC    WITH PUB_CODSOC
REPLACE MOV_ANNO   WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG
ENDIF
REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_ANNODO WITH SUBSTR(MOV_DTDOC,1,4)
REPLACE MOV_NDOC   WITH NDOC
REPLACE MOV_TOP    WITH TOP
REPLACE MOV_NPROT  WITH ALLTRIM(NPRO)
REPLACE MOV_CONTO  WITH CON
REPLACE MOV_IVA    WITH IV
REPLACE MOV_IMPOST WITH TAS
REPLACE MOV_DESMOV WITH XNOTA
REPLACE MOV_NUMPRO WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    WITH IMP
REPLACE MOV_TMOV   WITH DA_AV
REPLACE MOV_VALUTA WITH YVALUTA
REPLACE MOV_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF

*******AGGIORNA IL D.B. DEI CONTI

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(CON) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"conti","R")
   return(.f.)
ENDIF
SELECT conti
GO TOP
IF !EOF()
   P_IMPA= CON_IMP_A
   P_IMPD= CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR
   ENDIF
ELSE
   APPEND BLANK
   REPLACE CON_SOC    WITH PUB_CODSOC
   REPLACE CON_ANNO   WITH PUB_ANNO
   REPLACE CON_CONTO  WITH CON
   REPLACE CON_DESCR  WITH M.RAGSOC
   REPLACE CON_TIPOCO WITH "C"
   REPLACE CON_POSBIL WITH "P"
   REPLACE CON_IVASN  WITH .F.
   P_IMPA = CON_IMP_A
   P_IMPD = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR
   ENDIF
ENDIF
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

IF PARTITARIO
   DO RED_PARINF    && AGGIORNA PARTITARIO FORNITORI
ENDIF

SELECT(SELE)
RETURN


***************************************************************************
PROCEDURE movcreai      && crea la partita primaria SU INDICE
***************************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO

SELE=SELECT()

IF !ExecCommand("select * from indice where 0=1","cu_indice")
   return(.f.)
ENDIF
SELECT CU_INDICE
APPEND BLANK
REPLACE MOV_SOC    WITH PUB_CODSOC
REPLACE MOV_ANNO   WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG
ENDIF
REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_NDOC   WITH NDOC
REPLACE MOV_TOP    WITH TOP
REPLACE MOV_NPROT  WITH ALLTRIM(NPRO)
REPLACE MOV_CONTO  WITH CON
REPLACE MOV_IVA    WITH IV
REPLACE MOV_IMPOST WITH TAS
REPLACE MOV_DESMOV WITH XNOTA
REPLACE MOV_NUMPRO WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    WITH IMP
REPLACE MOV_TMOV   WITH DA_AV
REPLACE MOV_VALUTA WITH YVALUTA
REPLACE MOV_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF
IF !ExecRW('','indice','I','','CU_INDICE')
   return(.f.)
ENDIF

SELECT(SELE)

RETURN


***********************************************
* AGG. NUMERO DI REGISTRAZIONE  UTENTE        *
***********************************************

PROCEDURE REG_NUMREG

v_seek   = 'NUMREG'+PUB_ANNO+PUB_CODSOC
v_chiave = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
ELSE
   RIT=MSGBOX("Errore durante l'aggiornamento del numero di registrazione",'ATTENZIONE',31)
   RETURN
ENDIF
C_NUM=SUBSTR(LIBERA,1,10)
V_NUM=VAL(C_NUM)
T_NUM=V_NUM+1
TC_NUM=STR(T_NUM)
REPLACE LIBERA WITH ALLTRIM(TC_NUM)
NREG=TC_NUM
X_NREG = NREG
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN

***********************************************
* AGG. NUMERO DI REGISTRAZIONE  INTERNO DI PN *
***********************************************

PROCEDURE REG_NUMRPN


PN_C= sys(2015)

*!*	v_seek   = 'NUMREGPN'+PUB_CODSOC
*!*	v_chiave = "codice"
*!*	cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
*!*	IF !ExecRW(cSql,"PARA","R")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT PARA
*!*	IF RECCOUNT() <> 0
*!*	ELSE
*!*	   RIT=MSGBOX('Numero di registrazione (NUMREGPN) interno non trovato','ATTENZIONE',31)
*!*	   RETURN
*!*	ENDIF
*!*	PN=VAL(SUBSTR(LIBERA,1,10))
*!*	PN=PN + 1
*!*	PN_C=STR(PN)
*!*	REPLACE LIBERA WITH ALLTRIM(PN_C)
*!*	IF !ExecRW(cSql,"PARA","W")
*!*	   return(.f.)
*!*	ENDIF

RETURN

*************************************************************************
*   AGGIORNAMENTO PARTITARIO FORNITORI                                  *
*************************************************************************
PROCEDURE RED_PARINF

*** ACCESSO AL PARTITARIO PER PRELEVARE LA DATA DI SCADENZA ORIGINALE DELLA FATTURA

x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_npar = "par_npart = " + ALLTRIM(STR(XNPART,10,0))
x_cond = x_soci + " and " + x_npar
cSql = "select * from part_for where " + x_cond + " order by par_codsoc,par_npart"
IF !ExecCommand(cSql,"_TMP")
   RETURN .F.
ENDIF
SELECT _TMP
GO TOP
IF RECCOUNT()<>0
   _DTSCA = PAR_DTSCAD
ELSE
   _DTSCA = DTD
ENDIF

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORE")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORE
GO TOP
IF !EOF()
   V_TELEFO  				= FOR_TELEFO
   V_PARIVA  				= FOR_PARIVA
   V_RAGSOC  				= FOR_RAGSOC
   V_CODAGE  				= "   "
   V_CONPAG  				= FOR_CONPAG
   V_COSATRATTA 			= FOR_COSATRATTA
   V_GRADOIMPORTANZA 		= FOR_GRADOIMPORTANZA
   V_FORMAPAGAMENTO 		= FOR_FORMAPAGAMENTO
   V_TIPOCONTRATTO 			= FOR_TIPOCONTRATTO
   V_CODACQ 				= ALLTRIM(FOR_CODACQ)	
   V_PRIPAGA 				= ALLTRIM(FOR_PRIPAGA)	
ELSE
   V_TELEFO 	 			= SPACE(15)
   V_PARIVA  				= SPACE(16)
   V_RAGSOC  				= "FORNITORE INESISTENTE"
   V_CODAGE  				= "   "
   V_CONPAG  				= "101"
   V_COSATRATTA 			= SPACE(05)
   V_GRADOIMPORTANZA 		= SPACE(05)
   V_FORMAPAGAMENTO 		= SPACE(05)
   V_TIPOCONTRATTO 			= SPACE(05)
   V_CODACQ 				= SPACE(03)	
   V_PRIPAGA 				= SPACE(04)	
ENDIF

v_seek	 = "CPA"+V_CONPAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   V_CONPAG  = "101"   && FORZATURA CPA CONTANTI
ENDIF

IF !ExecCommand("select * from part_for where 0=1","cu_partfor")
   return(.f.)
ENDIF

SELECT CU_PARTFOR
APPEND BLANK
REC_PART=RECNO()
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "PAG"
IF NOTAC = "S"
   REPLACE PAR_TMOV    WITH "A"
ELSE
   REPLACE PAR_TMOV    WITH "D"
ENDIF
REPLACE PAR_CODCLI  WITH CON
REPLACE PAR_RAGSOC  WITH V_RAGSOC
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE PAR_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE PAR_DTREG  WITH DATREG
ENDIF
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTFAT  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTFAT  WITH DTD
ENDIF
IF SUBSTR(_DTSCA,3,1) = '/'
   REPLACE PAR_DTSCAD  WITH RIBALTA2(_DTSCA)
   REPLACE PAR_DATPAG  WITH RIBALTA2(_DTSCA)
ELSE
   REPLACE PAR_DTSCAD  WITH _DTSCA
   REPLACE PAR_DATPAG  WITH _DTSCA
ENDIF
REPLACE PAR_TIPFAT  WITH TOP
REPLACE PAR_TOTIM   WITH CAMBIO(YVALUTA,IMP,YCAMBIO)
REPLACE PAR_TIMPOS  WITH 0
REPLACE PAR_FATT    WITH CAMBIO(YVALUTA,IMP,YCAMBIO)
REPLACE PAR_NUMFAT  WITH NDOC
REPLACE PAR_NPROG   WITH 900
REPLACE PAR_NPART   WITH XNPART
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)
REPLACE PAR_CIVA1   WITH "NO"
REPLACE PAR_IMPO1   WITH CAMBIO(YVALUTA,IMP,YCAMBIO)
REPLACE PAR_IMPOS1  WITH 0
REPLACE PAR_TOT1    WITH CAMBIO(YVALUTA,IMP,YCAMBIO)
REPLACE PAR_CIVA2   WITH "   "
REPLACE PAR_IMPO2   WITH 0
REPLACE PAR_IMPOS2  WITH 0
REPLACE PAR_TOT2    WITH 0
REPLACE PAR_CIVA3   WITH "   "
REPLACE PAR_IMPO3   WITH 0
REPLACE PAR_IMPOS3  WITH 0
REPLACE PAR_TOT3    WITH 0
REPLACE PAR_CIVA4   WITH "   "
REPLACE PAR_IMPO4   WITH 0
REPLACE PAR_IMPOS4  WITH 0
REPLACE PAR_TOT4    WITH 0
REPLACE PAR_CIVA5   WITH "   "
REPLACE PAR_IMPO5   WITH 0
REPLACE PAR_IMPOS5  WITH 0
REPLACE PAR_TOT5    WITH 0


* --------  Classifica la partita -------- *
REPLACE PAR_COSATRATTA 		WITH V_COSATRATTA
REPLACE PAR_GRADOIMPORTANZA WITH V_GRADOIMPORTANZA
REPLACE PAR_FORMAPAGAMENTO 	WITH V_FORMAPAGAMENTO
REPLACE PAR_TIPOCONTRATTO 	WITH V_TIPOCONTRATTO
REPLACE PAR_CODACQ			WITH V_CODACQ
REPLACE PAR_PRIPAGA			WITH V_PRIPAGA
* --------  Classifica la partita -------- *


REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH 0	          && VALORE IN VALUTA

IF !ExecRW('','part_for','I','','CU_PARTFOR')
   return(.f.)
ENDIF


=CREA_SALDI_CF("F",CON,ALLTRIM(STR(XNPART,10,0)),"XXXXXXXXXX","CREA")

RETURN




********************************
FUNCTION CEI_AGGIORNA_MOV_CONT			&& AGGIORNA FLAG DI COMPENSAZIONE CREATA
********************************
AABBSS    = SELECT()

SELECT CU_MOVCONT

__id_unique = id_unique

x_id_unique = "id_unique= '" + __id_unique+ "'"

cSql="SELECT * FROM mov_cont WHERE " + x_id_unique + ;
                                   " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"
IF !ExecCommand(cSql,"A_MOV_CONT")
   return(.f.)
ENDIF

SELECT A_MOV_CONT


REPLACE MOV_NOTRC WITH "S"			&& AGGIORNA FLAG DI REGISTRAZIONE TRATTATA AI FINEI DELLA COMPENSAZIONE IVA SU NOTE CREDITO

IF !ExecRW('','mov_cont','I','','A_MOV_CONT')
   return(.f.)
ENDIF

SELECT(AABBSS)

RETURN
