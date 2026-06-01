RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei movimenti contabili ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

cSql = "delete from mov_cont where 1=1"
IF !ExecCommand(cSql,"MOV_CONT")
   return(.f.)
ENDIF
cSql = "delete from indice where 1=1"
IF !ExecCommand(cSql,"indice")
   return(.f.)
ENDIF

IF !ExecCommand("select * from mov_cont where 1=0","cur_controlli")
   return
ENDIF
IF !ExecCommand("select * from mov_cont where 1=0","impo_movcont")
   return
ENDIF
IF !ExecCommand("select * from mov_cont where 1=0","dive_movcont")
   return
ENDIF
IF !ExecCommand("select * from mov_cont where 1=0","nreg_movcont")
   return
ENDIF
SELECT NREG_MOVCONT
INDEX ON MOV_RECNO TAG I_INDICE ADDITIVE

IF !ExecCommand("select * from mov_cont where 1=0","cur_movcont")
   return
ENDIF
IF !ExecCommand("select * from indice where 1=0","cur_indice")
   return
ENDIF


RELEASE V_CAMPO,Y_CAMPO,V_DATA,_CTR,V_PRIMA,V_NUMREG,V_PRIMA,V_CLIFOR,V_TIPIVA,V_VALTOT, ;
        V_VALIVA,XXX_CODIVA,XXX_NUMIVA,XXX_NOIVA,V_TOTALE,V_TROV
PUBLIC  V_CAMPO,Y_CAMPO,V_DATA,_CTR,V_PRIMA,V_NUMREG,V_PRIMA,V_CLIFOR,V_TIPIVA,V_VALTOT, ;
        V_VALIVA,XXX_CODIVA,XXX_NUMIVA,XXX_NOIVA,V_TOTALE,V_TROV
V_CAMPO    = ""
Y_CAMPO    = ""
V_DATA     = ""
_CTR       = 0
V_PRIMA    = .T.
V_NUMREG   = ""
V_PRIMA    = .T.
V_CLIFOR   = 0
V_TIPIVA   = 0
V_VALTOT   = 0
V_VALIVA   = 0
XXX_CODIVA = '20 '
XXX_NUMIVA = 20
XXX_NOIVA  = 'FC '
V_TOTALE   = 0
V_TROV     = .F.

=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'PNO'
IF FOUND()
ELSE
   RETURN
ENDIF

V_PATH = ALLTRIM(PER_PATH)

cSql = "select * from u_cnt_an where cnt_tipo = 'PNO'"
IF !ExecRW(cSql,"U_CNT_AN","R")
   return(.f.)
ENDIF
SELECT U_CNT_AN
IF EOF()
   APPEND BLANK
ENDIF
REPLACE CNT_TIPO   WITH 'PNO'
REPLACE CNT_DATINI WITH RIBALTA2(DTOC(DATE()))
REPLACE CNT_ORAINI WITH TIME()
REPLACE CNT_DATFIN WITH SPACE(10)
REPLACE CNT_ORAFIN WITH SPACE(05)
REPLACE CNT_NUMREC WITH 0
REPLACE CNT_FILE   WITH V_PATH
IF !ExecRW(cSql,"U_CNT_AN","W")
   return(.f.)
ENDIF

x_cond = "codice = 'GEN" + PUB_CODSOC + "'"
cSql   = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF
SELECT PARA
IF reccount() > 0
   PUB_CC=SUBSTR(LIBERA,1,pub_sottog-1)
   PUB_FF=SUBSTR(LIBERA,18,pub_sottog-1)
ELSE
   =MESSAGEBOX("Parametro << GEN01 >> non trovato",16,"*** ATTENZIONE ***")
   RETURN
ENDIF

CREATE CURSOR TRANSITO (TRA_RECORD C(200))

SELECT TRANSITO
APPEND FROM &V_PATH SDF

*SELECT TRANSITO  
*gcTable = GETFILE('', 'Seleziona file movimenti contabili da convertire', 'Converti',0)
*IF empty(gcTable) .or. gcTable = ""
*   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
*   RETURN
*ENDIF
*APPEND FROM &gcTable SDF
*GO TOP

V_CONTA = 0
V_SALTA = .T.

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF UPPER(SUBSTR(TRA_RECORD,1,7)) = 'MINERVA'
      SKIP +1
      LOOP
   ENDIF

   IF SUBSTR(TRA_RECORD,1,4) = 'Data'
      SKIP +1
      LOOP
   ENDIF

*  IF SUBSTR(TRA_RECORD,31,10) = SPACE(10)
   IF SUBSTR(TRA_RECORD,1,10) = SPACE(10)
      SKIP +1
      LOOP
   ENDIF

   IF V_PRIMA
      V_PRIMA = .F.
      V_NUMREG = SUBSTR(TRA_RECORD,11,06)
   ENDIF
   
   IF V_NUMREG = SUBSTR(TRA_RECORD,11,06)
   ELSE
      DO GESTIONE_CONT
      V_CLIFOR = 0
      V_TIPIVA = 0
      V_VALTOT = 0
      V_VALIVA = 0
      V_CONTA  = 0
      V_PRIMA  = .T.
      SELECT TRANSITO
      LOOP
   ENDIF
   
*   IF SUBSTR(TRA_RECORD,1,10) = SPACE(10)
*      M.MOV_DESMO1 = ALLTRIM(SUBSTR(TRA_RECORD,31,40))      
*      SELECT NREG_MOVCONT
*      REPLACE MOV_DESMO1 WITH M.MOV_DESMO1
*      M.MOV_DESMO1 = ""
*      SELECT TRANSITO
*      SKIP +1
*   ENDIF

   M.MOV_NREGIS  = ALLTRIM(SUBSTR(TRA_RECORD,11,6))
   M.MOV_SOC     = PUB_CODSOC
   M.MOV_CONTO   = SUBSTR(TRA_RECORD,18,11)
   XXXXX_CONTO   = SUBSTR(TRA_RECORD,18,11)
   V_DATA        = SUBSTR(TRA_RECORD,1,8)
   DO TROVA_DATA
   M.MOV_DTREG   = V_DATA
   M.MOV_ANNO    = SUBSTR(M.MOV_DTREG,1,4)
   V_DATA        = SUBSTR(TRA_RECORD,108,8)
   DO TROVA_DATA
   M.MOV_DTDOC   = V_DATA
   IF EMPTY(M.MOV_DTDOC) .OR. M.MOV_DTDOC = SPACE(10)
      M.MOV_DTDOC = M.MOV_DTREG
   ENDIF
   M.MOV_ANNODO  = SUBSTR(M.MOV_DTDOC,1,4)
   M.MOV_NDOC    = ALLTRIM(SUBSTR(TRA_RECORD,98,6))
   M.MOV_DESMOV  = ALLTRIM(SUBSTR(TRA_RECORD,31,40))      
   M.MOV_DTVAL   = M.MOV_DTREG
   M.MOV_VALUTA  = PUB_VALRIF
   M.MOV_CAMBIO  = 1
   V_CAMPO       = ALLTRIM(SUBSTR(TRA_RECORD,117,15))
   DO TOGLI_PUNTI
   M.MOV_IMP     = VAL(ALLTRIM(Y_CAMPO))
   M.MOV_TMOV    = ALLTRIM(SUBSTR(TRA_RECORD,133,1))
   M.MOV_IVA     = 'NO'
   M.MOV_CONTOP  = '1'
   
   x_tipo = "codice like 'TOP%'"
   x_risu = ""
   x_cam  = ALLTRIM(SUBSTR(TRA_RECORD,72,24))
   x_ind  = 1
   x_len  = LEN(x_cam)
   DO WHILE .T.
      IF x_ind > x_len
         EXIT
      ENDIF
      IF SUBSTR(x_cam,x_ind,1) = "'"
         EXIT
      ENDIF
      x_risu = x_risu + SUBSTR(x_cam,x_ind,1)
      x_ind  = x_ind + 1
   ENDDO
   x_desc = "descri like '" + x_risu + "%'"
   x_cond = x_tipo + " and " + x_desc
   cSql   = "select * from para where " + x_cond + " order by descri"
   IF !ExecCommand(cSql,"para")
      return
   ENDIF
   SELECT PARA
   GO TOP
   M.MOV_TOP    = SUBSTR(CODICE,4,3) 

   SELECT TRANSITO
   IF ALLTRIM(SUBSTR(TRA_RECORD,18,5)) = '10909' .OR. ALLTRIM(SUBSTR(TRA_RECORD,18,5)) = '10910'
      IF SUBSTR(TRA_RECORD,23,2) = '  '
      ELSE
         M.MOV_CODICE = ALLTRIM(SUBSTR(TRA_RECORD,21,9))      
         M.MOV_CODICE = TRC(PUB_LCL,ALLTRIM(M.MOV_CODICE))
         M.MOV_CONTO  = PUB_CC + M.MOV_CODICE      
      ENDIF
   ELSE
      IF ALLTRIM(SUBSTR(TRA_RECORD,18,5)) = '22020' .OR. ALLTRIM(SUBSTR(TRA_RECORD,18,5)) = '22030' .OR. ;
         ALLTRIM(SUBSTR(TRA_RECORD,18,5)) = '22040' .OR. ALLTRIM(SUBSTR(TRA_RECORD,18,5)) = '22050' .OR. ;
         ALLTRIM(SUBSTR(TRA_RECORD,18,5)) = '22060' 
         IF SUBSTR(TRA_RECORD,23,2) = '  '
         ELSE
            M.MOV_CODICE = ALLTRIM(SUBSTR(TRA_RECORD,21,9))      
            M.MOV_CODICE = TRC(PUB_LCL,ALLTRIM(M.MOV_CODICE))
            M.MOV_CONTO  = PUB_FF + M.MOV_CODICE      
         ENDIF
      ENDIF  
   ENDIF  
   
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + M.MOV_ANNO + "'"
   x_cont = "con_conto = '" + ALLTRIM(M.MOV_CONTO) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"conti","R")
      return(.f.)
   ENDIF
   SELECT conti
   GO TOP
   IF EOF()
      APPEND BLANK
      REPLACE CON_SOC    WITH '01'
      REPLACE CON_ANNO   WITH '2003'
      REPLACE CON_CONOLD WITH M.MOV_CONTO 
      REPLACE CON_CONTO  WITH M.MOV_CONTO        
      REPLACE CON_DESCR  WITH "*** CONTO NON TROVATO ***"      
      REPLACE CON_TIPOCO WITH 'X'     
      V_POSBIL = ALLTRIM(SUBSTR(XXXXX_CONTO,1,1))
      IF V_POSBIL = '1' .OR. V_POSBIL = '2'
         REPLACE CON_POSBIL WITH 'P'
      ELSE
         REPLACE CON_POSBIL WITH 'E'
      ENDIF
   ENDIF
   M.MOV_SALDO = CON_TIPOCO
   IF CON_TIPOCO = 'C' .OR. CON_TIPOCO = 'F'
      V_CLIFOR = V_CLIFOR + 1
      M.MOV_SALDO = CON_TIPOCO
      IF CON_TIPOCO = 'F'
         M.MOV_NPROT  = M.MOV_NDOC
      ENDIF
   ELSE 
      IF CON_TIPOCO = 'I'
         V_TIPIVA = V_TIPIVA + 1
         V_VALIVA = V_VALIVA + M.MOV_IMP
         M.MOV_SALDO = CON_TIPOCO
         M.MOV_CONTOP = ""
      ENDIF
   ENDIF
   P_IMPA= CON_IMP_A
   P_IMPD= CON_IMP_D
   IF M.MOV_TOP = "CHI"
      MESE    = "12"
   ELSE
      MESE    = SUBSTR(M.MOV_DTREG,6,2)
   ENDIF
   IF EMPTY(MESE) .OR. MESE = SPACE(02) 
      MESE = '12'
   ENDIF
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF M.MOV_TMOV = 'A'
      P_IMPA = M.MOV_IMP
      P_IMPD = 0
   ELSE
      P_IMPD = M.MOV_IMP
      P_IMPA = 0
   ENDIF
   * CHI_EUR_ITL
   REPLACE   CON_IMP_D   WITH CON_IMP_D + P_IMPD
   REPLACE   CON_IMP_A   WITH CON_IMP_A + P_IMPA
   REPLACE   &VAR2       WITH &VAR2 + P_IMPD
   REPLACE   &VAR        WITH &VAR + P_IMPA
   IF !ExecRW(cSql,"CONTI","W")
      return(.f.)
   ENDIF

   IF M.MOV_TMOV = 'A'
      V_VALTOT = V_VALTOT + M.MOV_IMP
   ENDIF
   
   V_CONTA     = V_CONTA + 1
   
   M.MOV_RECNO = V_CONTA

   SELECT NREG_MOVCONT
   APPEND BLANK
   GATHER MEMVAR

   SELECT DIVE_MOVCONT
   APPEND BLANK
   GATHER MEMVAR
   
   _CTR = _CTR +1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

   SELECT TRANSITO      
   SKIP +1

ENDDO

DO GESTIONE_CONT

IF !ExecRW('','MOV_CONT','I','','CUR_MOVCONT')
   return(.f.)
ENDIF
IF !ExecRW('','INDICE','I','','CUR_INDICE')
   return(.f.)
ENDIF

cSql = "select * from u_cnt_an where cnt_tipo = 'PNO'"
IF !ExecRW(cSql,"U_CNT_AN","R")
   return(.f.)
ENDIF
SELECT U_CNT_AN
REPLACE CNT_DATFIN WITH RIBALTA2(DTOC(DATE()))
REPLACE CNT_ORAFIN WITH TIME()
REPLACE CNT_NUMREC WITH V_CONTA
IF !ExecRW(cSql,"U_CNT_AN","W")
   return(.f.)
ENDIF

SELECT cur_controlli
GO TOP
IF EOF()
ELSE
   BROWSE NORMAL
ENDIF

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN
   

*********************
PROCEDURE TOGLI_PUNTI
*********************

YY      = LEN(V_CAMPO)
XX      = 1
Y_CAMPO =  ' '
DO WHILE .T.
   IF XX > YY
      EXIT
   ENDIF
   IF SUBSTR(V_CAMPO,XX,1) = '.' 
   ELSE
      Y_CAMPO = Y_CAMPO + SUBSTR(V_CAMPO,XX,1) 
   ENDIF
   XX = XX + 1
ENDDO

RETURN


********************
PROCEDURE TROVA_DATA
********************

IF V_DATA = SPACE(08) .OR. V_DATA = '  /  /  ' .OR. EMPTY(V_DATA)
   V_DATA = SPACE(10)
   RETURN
ENDIF

IF SUBSTR(V_DATA,1,1) = ' '
   V_DATA = '0' + SUBSTR(V_DATA,2,7)
ENDIF

IF SUBSTR(V_DATA,4,1) = ' '
   V_DATA = SUBSTR(V_DATA,1,3) + '0' + SUBSTR(V_DATA,5,4)
ENDIF

IF VAL(SUBSTR(V_DATA,7,2)) > 50
   V_DATA = SUBSTR(V_DATA,1,6) + '19' + SUBSTR(V_DATA,7,2)
ELSE
   V_DATA = SUBSTR(V_DATA,1,6) + '20' + SUBSTR(V_DATA,7,2)
ENDIF

V_DATA = RIBALTA2(V_DATA)

RETURN


***********************
PROCEDURE GESTIONE_CONT
***********************

RELEASE X_TIPIVA
PUBLIC  X_TIPIVA
X_TIPIVA = V_TIPIVA

V_TROV   = .F.

IF V_TIPIVA > 0
   V_IMPONI = V_VALTOT - V_VALIVA
   V_IVAN   = ROUND(((V_VALIVA * 100) / V_IMPONI),2)
   V_IVA    = ROUND(((V_IMPONI * V_IVAN) / 100),2)
   V_IVACOD = ALLTRIM(STR(V_IVAN,3,0))
   V_IVADIF = V_VALIVA - V_IVA
   IF V_IVADIF > 1 .OR. V_IVADIF < -1
   ELSE
      V_IVA = V_VALIVA
   ENDIF
   V_PROVA  = V_IVAN - INT(V_IVAN)
   IF V_PROVA = 0 
      x_cond   = "codice = 'IVA" + ALLTRIM(V_IVACOD) + "'"
      cSql     = "select * from para where " + x_cond + " order by codice"
      IF !ExecCommand(cSql,"para")
         return
      ENDIF
      SELECT PARA
      GO TOP
      IF EOF()
         V_TROV = .F.
      ELSE
         V_TROV = .T.
      ENDIF
   ELSE
      V_TROV = .F.
   ENDIF  
   IF V_TROV
      V_IVANUM = ROUND(((V_VALIVA * 100) / V_IMPONI),2)
      V_IVACOD = ALLTRIM(STR(V_IVANUM,3,0))
   ELSE
      V_IMPONI = V_VALTOT - V_VALIVA
      V_IMPO20 = ROUND(((V_VALIVA / XXX_NUMIVA) * 100),2)  
      V_DIFFER = V_IMPONI - V_IMPO20
      V_IVANUM = XXX_NUMIVA
      V_IVACOD = XXX_CODIVA
   ENDIF
ENDIF

SELECT NREG_MOVCONT
SET ORDER TO I_INDICE
GO TOP
SCATTER MEMVAR 

M.MOV_NUMPRO = SYS(2015)

*IF V_CLIFOR > 1 .OR. V_TIPIVA > 1
IF V_TIPIVA > 1
   SELECT CUR_CONTROLLI
   APPEND BLANK
   GATHER MEMVAR
   SELECT NREG_MOVCONT
ENDIF
   
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   REPLACE MOV_NUMPRO WITH M.MOV_NUMPRO

   IF V_TIPIVA > 0
      IF MOV_SALDO = 'C' .OR. MOV_SALDO = 'F'
      ELSE
         IF MOV_SALDO = 'I'
            REPLACE MOV_IVA WITH V_IVACOD
         ELSE
            IF V_TROV
               REPLACE MOV_IVA    WITH V_IVACOD
               REPLACE MOV_IMPOST WITH V_VALIVA
               REPLACE MOV_SALDO  WITH ""
            ELSE
               IF MOV_RECNO = 2
                  REPLACE MOV_IMP WITH V_DIFFER
                  REPLACE MOV_IVA WITH XXX_NOIVA
                  SCATTER MEMVAR
                  SELECT IMPO_MOVCONT
                  APPEND BLANK
                  GATHER MEMVAR
                  REPLACE MOV_IMP    WITH V_IMPO20
                  REPLACE MOV_IVA    WITH V_IVACOD
                  REPLACE MOV_IMPOST WITH V_VALIVA    
                  REPLACE MOV_SALDO WITH "" 
                  V_CONTA = V_CONTA + 1
                  REPLACE MOV_RECNO  WITH V_CONTA
                  V_TIPIVA = 0
                  SELECT NREG_MOVCONT
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   IF MOV_SALDO = 'I'
      REPLACE MOV_IVA    WITH V_IVACOD
      REPLACE MOV_CONTOP WITH ""
   ENDIF

   SELECT NREG_MOVCONT
   SKIP +1
   
ENDDO               

SELECT IMPO_MOVCONT
GO TOP
IF EOF()
ELSE
   SCATTER MEMVAR
   SELECT NREG_MOVCONT
   APPEND BLANK
   GATHER MEMVAR
ENDIF

V_DARE  = 0
V_AVERE = 0
SELECT NREG_MOVCONT
SET ORDER TO I_INDICE
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF EMPTY(MOV_ANNO) .OR. MOV_ANNO = SPACE(04)
      SKIP +1
      LOOP
   ENDIF
   IF MOV_TMOV = 'D'
      V_DARE = V_DARE + MOV_IMP
   ENDIF
   IF MOV_TMOV = 'A'
      V_AVERE = V_AVERE + MOV_IMP
   ENDIF
   REPLACE MOV_RECNO WITH 0 
   IF MOV_SALDO = 'I'
      REPLACE MOV_IVA    WITH V_IVACOD
      REPLACE MOV_CONTOP WITH ""
   ENDIF
   REPLACE MOV_SALDO     WITH ""
   REPLACE MOV_NUMPRO    WITH M.MOV_NUMPRO
   SKIP +1
ENDDO

IF V_DARE = V_AVERE
ELSE
   DO GESTIONE_ALTRO
ENDIF

SELECT NREG_MOVCONT
SET ORDER TO I_INDICE
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF EMPTY(MOV_ANNO) .OR. MOV_ANNO = SPACE(04)
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR
   SELECT CUR_MOVCONT
   APPEND BLANK
   GATHER MEMVAR
   SELECT NREG_MOVCONT
   SKIP +1
ENDDO

SELECT NREG_MOVCONT
SET ORDER TO I_INDICE
GO TOP
SCATTER MEMVAR

SELECT NREG_MOVCONT
ZAP

SELECT DIVE_MOVCONT
ZAP

SELECT IMPO_MOVCONT
ZAP

SELECT CUR_INDICE
APPEND BLANK
REPLACE MOV_SOC    WITH M.MOV_SOC
REPLACE MOV_ANNO   WITH M.MOV_ANNO
REPLACE MOV_DTDOC  WITH M.MOV_DTDOC
REPLACE MOV_NDOC   WITH M.MOV_NDOC
REPLACE MOV_DTREG  WITH M.MOV_DTREG
REPLACE MOV_NREGIS WITH M.MOV_NREGIS
REPLACE MOV_CONTO  WITH M.MOV_CONTO
REPLACE MOV_TOP    WITH M.MOV_TOP
REPLACE MOV_TMOV   WITH M.MOV_TMOV
REPLACE MOV_IMP    WITH V_VALTOT
REPLACE MOV_NPROT  WITH M.MOV_NPROT
*REPLACE MOV_MODPAG WITH M.MOV_MODPAG  
REPLACE MOV_IVA    WITH M.MOV_IVA
*REPLACE MOV_IMPOST WITH M.MOV_IMPOST
*REPLACE MOV_IMPORT WITH M.MOV_IMPORT
REPLACE MOV_NUMPRO WITH M.MOV_NUMPRO
*REPLACE MOV_FLG    WITH M.MOV_FLG
REPLACE MOV_DESMOV WITH M.MOV_DESMOV
*REPLACE MOV_DESMO1 WITH M.MOV_DESMO1
*REPLACE MOV_SALDO  WITH M.MOV_SALDO
*REPLACE MOV_NPART  WITH VAL(M.MOV_NPART)
*REPLACE MOV_PROGPA WITH M.MOV_PROGPA
*REPLACE MOV_FATRI  WITH M.MOV_FATRI
*REPLACE MOV_NOTE   WITH M.MOV_NOTE
*REPLACE MOV_CODNOT WITH M.MOV_CODNOT
REPLACE MOV_CAMBIO WITH M.MOV_CAMBIO
*REPLACE MOV_IMPVAL WITH M.MOV_IMPVAL
REPLACE MOV_VALUTA WITH M.MOV_VALUTA
REPLACE MOV_DTVAL  WITH M.MOV_DTVAL
*REPLACE MOV_SYS    WITH M.MOV_SYS
*REPLACE SELEZIONE  WITH M.SELEZIONE
*REPLACE MOV_PESO   WITH M.MOV_PESO
*REPLACE MOV_TISPE  WITH M.MOV_TISPE
*REPLACE MOV_PORTO  WITH M.MOV_PORTO
*REPLACE MOV_CLDOG  WITH M.MOV_CLDOG
*REPLACE MOV_BANCA  WITH M.MOV_BANCA
*REPLACE MOV_ANOMAX WITH M.MOV_ANOMAX
*REPLACE MOV_CODCCO WITH M.MOV_CODCCO
*REPLACE MOV_PRALEG WITH M.MOV_PRALEG

RETURN    


************************
PROCEDURE GESTIONE_ALTRO
************************

IF X_TIPIVA > 0
ELSE
   RETURN
ENDIF

RELEASE XXX_NUMPRO
PUBLIC  XXX_NUMPRO
XXX_NUMPRO = SYS(2015)

SELECT NREG_MOVCONT
ZAP

SELECT DIVE_MOVCONT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF MOV_SALDO = 'C' .OR. MOV_SALDO = 'F'
      SKIP +1
      LOOP
   ENDIF

   IF MOV_SALDO = 'I'
      REPLACE MOV_IVA    WITH XXX_CODIVA
      REPLACE MOV_CONTOP WITH ""
      SKIP +1
      LOOP
   ENDIF

   V_IMPOST = ROUND(((MOV_IMP * XXX_NUMIVA) / 100),2)
   REPLACE MOV_IVA    WITH XXX_CODIVA
   REPLACE MOV_IMPOST WITH V_IMPOST
   REPLACE MOV_SALDO  WITH ""

   IF V_VALIVA < V_IMPOST 
      V_IMPO20 = ROUND(((V_VALIVA / XXX_NUMIVA) * 100),2)  
      V_DIFFER = MOV_IMP - V_IMPO20
      REPLACE MOV_IMPOST WITH V_VALIVA
      REPLACE MOV_IMP    WITH V_IMPO20
      SCATTER MEMVAR 
      APPEND BLANK
      GATHER MEMVAR
      REPLACE MOV_IMP    WITH V_DIFFER
      REPLACE MOV_IVA    WITH XXX_NOIVA
      REPLACE MOV_IMPOST WITH 0   
      REPLACE MOV_SALDO  WITH "" 
      EXIT
   ENDIF
            
   V_VALIVA = V_VALIVA - V_IMPOST

   V_MAX = ROUND((10 / 100),2)
   V_MIN = V_MAX * -1
   
   IF V_VALIVA > V_MIN .AND. V_VALIVA < V_MAX
      EXIT
   ENDIF
      
   SKIP +1
   
ENDDO

SELECT DIVE_MOVCONT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR
   SELECT NREG_MOVCONT
   APPEND BLANK
   GATHER MEMVAR
   REPLACE MOV_NUMPRO WITH XXX_NUMPRO
   IF MOV_SALDO = 'I'
      REPLACE MOV_IVA    WITH XXX_CODIVA
      REPLACE MOV_CONTOP WITH ""
   ENDIF
   REPLACE MOV_SALDO  WITH ""
   SELECT DIVE_MOVCONT
   SKIP +1
ENDDO

M.MOV_NUMPRO = XXX_NUMPRO

RETURN