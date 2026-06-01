
PUB_OK = .F.   && VERIFICA SE EFFETTIVAMENTE AGGIORNA GLI ARCHIVI

DO REGISTRA

DO _MESSAGGIO

XPRALEGX = SPACE(01)

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
x_npro = "mov_numpro = '" + PN_C + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_npro
cSql   = "select * from indice where " + x_cond + " order by mov_soc,mov_anno,mov_numpro" 
IF !ExecRW(cSql,"INDICE","R")
   return(.f.)
ENDIF
SELECT INDICE
IF RECCOUNT() <> 0
   _NUMPRO  = MOV_NUMPRO
   _NPRPRN  = MOV_NPROT
   _NPAPRN  = MOV_NPART
   _IMPPRN  = MOV_IMP
   S_NUMINT = NUM_INT
   CSQL     = "DELETE FROM U_BFO_LE WHERE LEG_NUMPRO = ?S_NUMINT"
   IF !ExecCommand(CSQL,"U_BFO_LE")
      RETURN (.f.)
   ENDIF 
   SELECT CU_BFO_LE
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      REPLACE LEG_NUMPRO WITH _NUMPRO
      REPLACE LEG_NPRPRN WITH STR(_NPAPRN,10,0)
      REPLACE LEG_NPAPRN WITH _NPAPRN
      REPLACE LEG_TOTPRN WITH _IMPPRN
      IF SUBSTR(LEG_DATPRN,3,1) = '/'
         REPLACE LEG_DATPRN WITH RIBALTA2(LEG_DATPRN)
      ENDIF
      IF SUBSTR(LEG_DATDOC,3,1) = '/'
         REPLACE LEG_DATDOC WITH RIBALTA2(LEG_DATDOC)
      ENDIF
      XPRALEGX = 'S'
      SELECT CU_BFO_LE
      SKIP +1
   ENDDO
   IF !ExecRW('','U_BFO_LE','I','','CU_BFO_LE')
      return(.f.)
   ENDIF
   SELECT INDICE
   REPLACE MOV_PRALEG WITH XPRALEGX
ENDIF
IF !ExecRW(cSql,"INDICE","W")
   return(.f.)
ENDIF

DO REG_CLEAR             && AZZERAMENTO VARIABILI PN

RETURN