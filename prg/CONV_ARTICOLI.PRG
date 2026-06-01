RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica articoli ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'AR1'
IF FOUND()
ELSE
   RETURN
ENDIF

SELECT PERCORSO
V_PATH = ALLTRIM(PER_PATH)

cSql = "select * from u_cnt_an where cnt_tipo = 'ART'"
IF !ExecRW(cSql,"U_CNT_AN","R")
   return(.f.)
ENDIF
SELECT U_CNT_AN
IF EOF()
   APPEND BLANK
ENDIF
REPLACE CNT_TIPO   WITH 'ART'
REPLACE CNT_DATINI WITH RIBALTA2(DTOC(DATE()))
REPLACE CNT_ORAINI WITH TIME()
REPLACE CNT_DATFIN WITH SPACE(10)
REPLACE CNT_ORAFIN WITH SPACE(05)
REPLACE CNT_NUMREC WITH 0
REPLACE CNT_FILE   WITH V_PATH
IF !ExecRW(cSql,"U_CNT_AN","W")
   return(.f.)
ENDIF

cSql = "delete from u_art_pr where art_nonmov=0"
IF !ExecCommand(cSql,"U_ART_PR")
   return(.f.)
ENDIF

*cSql = "select * from u_art_pr where 1=0"
*IF !ExecCommand(cSql,"CU_ART_PR")
*   return(.f.)
*ENDIF
*SELECT CU_ART_PR
*APPEND FROM X_ART_PR
*SELECT CU_ART_PR
*GO TOP
*DO WHILE .T.
*   IF EOF()
*      EXIT
*   ENDIF
*   REPLACE ID_UNIQUE WITH ""
*   REPLACE ART_DATVAR WITH '1980/01/01'
*   REPLACE ART_DATINS WITH '1980/01/01'
*   REPLACE ART_ULDSCA WITH SPACE(10)
*   REPLACE ART_ULNSCA WITH SPACE(06)
*   REPLACE ART_ULQSCA WITH 0
*   REPLACE ART_ULPSCA WITH 0
*   REPLACE ART_ULDCAR WITH SPACE(10)
*   REPLACE ART_ULNCAR WITH SPACE(06)
*   REPLACE ART_ULQCAR WITH 0
*   REPLACE ART_ULPCAR WITH 0
*   SKIP +1
*ENDDO
*IF !ExecRW('','u_art_pr','I','','CU_ART_PR')
*   return(.f.)
*ENDIF

PUBLIC Y_CAMPO,V_CAMPO,_CTR
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0

CREATE CURSOR TRANSITO (TRA_RECORD C(250))

*SELECT TRANSITO
*APPEND FROM &V_PATH SDF

SELECT TRANSITO  
gcTable = GETFILE('', 'Seleziona file anagrafica articoli da convertire', 'Converti',0)
IF empty(gcTable) .or. gcTable = ""
   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF
SELECT TRANSITO
APPEND FROM &gcTable SDF

SELECT TRANSITO
GO TOP

DELETE FOR SUBSTR(TRA_RECORD,2,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,3,30) = SPACE(30)  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Unit"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,6) = "Contro"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Peso"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Dise"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,8) = "Codice a"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,8) = "Gruppo F"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Cate"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Cent"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Tass"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,18) = "Data Trasferimento"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Cost"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Ubic"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,8) = "Scorta S"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Punt"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,4) = "Mini"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,6) = "Scorta"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,7) = "Quantit"  ALL
GO TOP

V_CONTA = 0

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(SUBSTR(TRA_RECORD,1,8)) = 'Articolo'
      M.ART_CODPRI = ALLTRIM(SUBSTR(TRA_RECORD,12,16))  
      M.ART_DESCR  = ALLTRIM(SUBSTR(TRA_RECORD,32,50))  
      X_CDISBN     = EANTOISBN(M.ART_CODPRI)
      M.ART_CDISBN = X_CDISBN
      M.ART_UNIMIS = SPACE(03)
      M.ART_LINEA  = SPACE(02)   
      M.ART_DESLIN = SPACE(50)   
      M.ART_OBSOL  = SPACE(01)   
      M.ART_CODIVA = SPACE(03)   
      M.ART_CATMER = SPACE(03)   
      M.ART_DESMER = SPACE(50)   
      M.ART_DATINS = SPACE(10)   
      M.ART_DATVAR = SPACE(10)   
      SKIP +1
      DO COMPONI_ART
      SELECT TRANSITO
      LOOP
   ENDIF
 
   SELECT TRANSITO
   SKIP +1
   
ENDDO

cSql = "select * from u_cnt_an where cnt_tipo = 'ART'"
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

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN


*********************
PROCEDURE COMPONI_ART
*********************

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF ALLTRIM(SUBSTR(TRA_RECORD,1,8)) = 'Articolo'
      DO GESTIONE_ART
      EXIT      
   ENDIF
   
   IF ALLTRIM(SUBSTR(TRA_RECORD,2,13)) = 'Tabella Conv.'
      M.ART_UNIMIS = ALLTRIM(SUBSTR(TRA_RECORD,87,3))   
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(SUBSTR(TRA_RECORD,2,13)) = 'Tipo Articolo'
      M.ART_LINEA = ALLTRIM(SUBSTR(TRA_RECORD,27,2))   
      M.ART_OBSOL = ALLTRIM(SUBSTR(TRA_RECORD,87,1))   
      IF M.ART_LINEA = SPACE(02) .OR. EMPTY(M.ART_LINEA)
         M.ART_LINEA  = SPACE(02)
         M.ART_DESLIN = SPACE(50)
      ELSE
         v_seek   = 'REP'+ALLTRIM(M.ART_LINEA)
         v_chiave = "codice"
         cSql     = "select * from para where " + v_chiave + " = '" + v_seek + "'"
         IF !ExecCommand(cSql,"PARA")
            return(.f.)
         ENDIF
         SELECT PARA
         IF RECCOUNT() <> 0
            M.ART_DESLIN = DESCRI
         ELSE
	        M.ART_DESLIN = SPACE(50)
	     ENDIF
      ENDIF
      SELECT TRANSITO
      SKIP +1
      LOOP
   ENDIF
    
   IF ALLTRIM(SUBSTR(TRA_RECORD,2,10)) = 'Codice Iva'
      M.ART_CODIVA = ALLTRIM(SUBSTR(TRA_RECORD,27,2))   
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(SUBSTR(TRA_RECORD,2,19)) = 'Gruppo Merceologico'
      M.ART_CATMER = ALLTRIM(SUBSTR(TRA_RECORD,27,3))   
      IF M.ART_CATMER = SPACE(03) .OR. EMPTY(M.ART_CATMER)
         M.ART_CATMER = SPACE(03)
         M.ART_DESMER = SPACE(50)
      ELSE
         v_seek   = 'MER'+ALLTRIM(M.ART_CATMER)
         v_chiave = "codice"
         cSql     = "select * from para where " + v_chiave + " = '" + v_seek + "'"
         IF !ExecCommand(cSql,"PARA")
            return(.f.)
         ENDIF
         SELECT PARA
         IF RECCOUNT() <> 0
            M.ART_DESMER = DESCRI
         ELSE
	        M.ART_DESMER = SPACE(50)
	     ENDIF
      ENDIF
      SELECT TRANSITO
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(SUBSTR(TRA_RECORD,2,14)) = 'Data Creazione'
      _DATA = SUBSTR(TRA_RECORD,27,8)
      IF _DATA = SPACE(08)
         _DATA = DTOC(DATE())
      ENDIF
      IF SUBSTR(_DATA,1,1) = ' ' 
         _DATA = '0' + SUBSTR(_DATA,2,7)
      ENDIF
      IF SUBSTR(_DATA,4,1) = ' ' 
         _DATA = SUBSTR(_DATA,1,3) + '0' + SUBSTR(_DATA,5,4)
      ENDIF
      IF VAL(SUBSTR(_DATA,7,2)) > 50  
         _DATA = SUBSTR(_DATA,1,6) + '19' + SUBSTR(_DATA,7,2)
      ELSE
         _DATA = SUBSTR(_DATA,1,6) + '20' + SUBSTR(_DATA,7,2)
      ENDIF
      M.ART_DATVAR = RIBALTA2(_DATA) 
      _DATA = SUBSTR(TRA_RECORD,87,8)
      IF _DATA = SPACE(08)
         M.ART_DATINS = M.ART_DATVAR
      ELSE
         IF SUBSTR(_DATA,1,1) = ' ' 
            _DATA = '0' + SUBSTR(_DATA,2,7)
         ENDIF
         IF SUBSTR(_DATA,4,1) = ' ' 
            _DATA = SUBSTR(_DATA,1,3) + '0' + SUBSTR(_DATA,5,4)
         ENDIF
         IF VAL(SUBSTR(_DATA,7,2)) > 50  
            _DATA = SUBSTR(_DATA,1,6) + '19' + SUBSTR(_DATA,7,2)
         ELSE
            _DATA = SUBSTR(_DATA,1,6) + '20' + SUBSTR(_DATA,7,2)
         ENDIF
         M.ART_DATINS = RIBALTA2(_DATA) 
      ENDIF
   ENDIF
   
   SELECT TRANSITO      
   SKIP +1

ENDDO


   
**********************
PROCEDURE GESTIONE_ART
**********************

M.ART_CODSOC = '01'

x_soci = "art_codsoc = '" + M.ART_CODSOC + "'"
x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
x_cond = x_soci + " and " + x_codi
cSql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"u_art_pr","R")
   return
ENDIF
SELECT u_art_pr
IF EOF()
   m.id_unique = ""
   APPEND BLANK
ENDIF
REPLACE ART_CODSOC WITH M.ART_CODSOC
REPLACE ART_CODPRI WITH M.ART_CODPRI
REPLACE ART_DESCR  WITH M.ART_DESCR
REPLACE ART_MAGA   WITH 'SEDE  '
REPLACE ART_UNIMIS WITH M.ART_UNIMIS
REPLACE ART_LINEA  WITH M.ART_LINEA
REPLACE ART_DESLIN WITH M.ART_DESLIN
REPLACE ART_OBSOL  WITH M.ART_OBSOL
REPLACE ART_CODIVA WITH M.ART_CODIVA
REPLACE ART_CATMER WITH M.ART_CATMER
REPLACE ART_DESMER WITH M.ART_DESMER
REPLACE ART_DATVAR WITH M.ART_DATVAR
REPLACE ART_DATINS WITH M.ART_DATINS
REPLACE ART_CDISBN WITH M.ART_CDISBN
REPLACE ART_FLGTRA WITH .T.
IF !ExecRW(cSql,"u_art_pr","W")
   return
ENDIF

V_CONTA = V_CONTA + 1

_CTR = _CTR +1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

RETURN