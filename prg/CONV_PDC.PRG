RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"del piano dei conti ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

*=OPENDB("PERCORSO")
*SELECT PERCORSO
*SET ORDER TO I_TIPO
*SEEK 'PDC'
*IF FOUND()
*ELSE
*   RETURN
*ENDIF
*SELECT PERCORSO
*V_PATH = ALLTRIM(PER_PATH)

V_PATH = ""

cSql = "delete from conti where 1=1"
IF !ExecCommand(cSql,"CONTI")
   return(.f.)
ENDIF

PUBLIC Y_CAMPO,V_CAMPO,_CTR
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0

CREATE CURSOR TRANSITO (TRA_RECORD C(200))

*SELECT TRANSITO
*APPEND FROM &V_PATH SDF

SELECT TRANSITO  
gcTable = GETFILE('', 'Seleziona file piano dei conti da convertire', 'Converti',0)
IF empty(gcTable) .or. gcTable = ""
   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF
APPEND FROM &gcTable SDF
GO TOP

DELETE FOR SUBSTR(TRA_RECORD,1,1) <> "0" ALL
GO TOP

V_CONTA = 0

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

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(SUBSTR(TRA_RECORD,2,1)) = ' '
      SKIP +1
      LOOP
   ENDIF 

   M.CON_SOC  = '01'
   M.CON_ANNO = '2004'

   V_CONTO    = ALLTRIM(SUBSTR(TRA_RECORD,1,9))
   V_COD      = ALLTRIM(SUBSTR(TRA_RECORD,1,2))

   IF SUBSTR(V_CONTO,4,2) = '00'
   ELSE
      V_COD = V_COD + SUBSTR(V_CONTO,4,2)
      IF SUBSTR(V_CONTO,7,3) = '000'
      ELSE
         V_COD = V_COD + SUBSTR(V_CONTO,7,3)
      ENDIF
   ENDIF     

   M.CON_CONOLD = V_COD      
   M.CON_CONTO  = V_COD

   M.CON_DESCR = ALLTRIM(SUBSTR(TRA_RECORD,11,33))
   M.CON_DESCR  = UPPER(M.CON_DESCR)
   M.CON_DESCR  = APITOSPA(M.CON_DESCR)
   
   M.CON_TIPOCO = 'X'
   IF SUBSTR(M.CON_CONTO,1,5) = '01330'  
      M.CON_TIPOCO = 'I'
   ENDIF      
   IF SUBSTR(M.CON_CONTO,1,7) > '0219010' .AND. SUBSTR(M.CON_CONTO,1,7) < '0220000'   
      M.CON_TIPOCO = 'I'
   ENDIF      

   IF SUBSTR(M.CON_CONTO,1,2) > '03'
      M.CON_POSBIL = 'E'
   ELSE
      M.CON_POSBIL = 'P'
   ENDIF
   
   x_soci = "con_soc = '" + M.CON_SOC + "'"
   x_anno = "con_anno = '" + M.CON_ANNO + "'"
   x_codi = "con_conto = '" + M.CON_CONTO + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_codi
   cSql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"conti","R")
      return
   ENDIF
   SELECT conti
   IF EOF()
      m.id_unique = ""
      APPEND BLANK
   ENDIF
   
   REPLACE CON_SOC    WITH M.CON_SOC
   REPLACE CON_ANNO   WITH M.CON_ANNO
   REPLACE CON_CONTO  WITH M.CON_CONTO    
   REPLACE CON_DESCR  WITH M.CON_DESCR
   REPLACE CON_TIPOCO WITH M.CON_TIPOCO    
   REPLACE CON_POSBIL WITH M.CON_POSBIL
   REPLACE CON_CONOLD WITH M.CON_CONOLD

   IF !ExecRW(cSql,"conti","W")
      return
   ENDIF

   V_CONTA = V_CONTA + 1

   _CTR = _CTR +1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

   SELECT TRANSITO      
   SKIP +1

ENDDO

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN
   
