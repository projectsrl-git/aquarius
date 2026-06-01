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

WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA ARTICOLI." NOWAIT

cSql = "delete from u_art_pr where art_nonmov=0"
IF !ExecCommand(cSql,"U_ART_PR")
   return(.f.)
ENDIF

cSql = "select * from u_art_pr where 1=1"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   REPLACE ART_PRZVEN WITH 0
   REPLACE ART_PRZIVA WITH 0
   SKIP +1
ENDDO
IF !ExecRW(cSql,"U_ART_PR","W")
   return(.f.)
ENDIF

PUBLIC Y_CAMPO,V_CAMPO,_CTR
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0

CREATE CURSOR TRANSITO (TRA_RECORD C(250))

SELECT TRANSITO
APPEND FROM &V_PATH SDF

*SELECT TRANSITO  
*gcTable = GETFILE('', 'Seleziona file anagrafica articoli da convertire', 'Converti',0)
*IF empty(gcTable) .or. gcTable = ""
*   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
*   RETURN
*ENDIF
*SELECT TRANSITO
*APPEND FROM &gcTable SDF

SELECT TRANSITO
GO TOP

DELETE FOR SUBSTR(TRA_RECORD,2,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,2) = SPACE(2)  ALL
GO TOP

V_CONTA = 0

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

*   IF V_CONTA > 121821
*   ELSE
*      V_CONTA = V_CONTA + 1
*      _CTR = _CTR +1
*      WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
*   ENDIF
   
   M.ART_CODPRI = ALLTRIM(SUBSTR(TRA_RECORD,1,16))  
   M.ART_DESCR  = ALLTRIM(SUBSTR(TRA_RECORD,18,30)) + ALLTRIM(SUBSTR(TRA_RECORD,49,20))
   IF SUBSTR(TRA_RECORD,68,10) = SPACE(10)
      M.ART_DESEST = SPACE(40)
   ELSE
      M.ART_DESEST = ALLTRIM(SUBSTR(TRA_RECORD,68,10))
   ENDIF

   X_CDISBN     = EANTOISBN(M.ART_CODPRI)
   M.ART_CDISBN = X_CDISBN
   M.ART_UNIMIS = ALLTRIM(SUBSTR(TRA_RECORD,84,3))   
   M.ART_CODIVA = ALLTRIM(SUBSTR(TRA_RECORD,99,2))   
   M.ART_AUTORE = ALLTRIM(SUBSTR(TRA_RECORD,119,17))   
   M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
   M.ART_DATINS = RIBALTA2(DTOC(DATE()))

   V_CAMPO      = ALLTRIM(SUBSTR(TRA_RECORD,103,7))
   DO TOGLI_PUNTI
   V_PREZZO     = VAL(ALLTRIM(Y_CAMPO))
   M.ART_PRZIVA = V_PREZZO

   V_CAMPO      = ALLTRIM(SUBSTR(TRA_RECORD,111,7))
   DO TOGLI_PUNTI
   V_PREZZO     = VAL(ALLTRIM(Y_CAMPO))
   M.ART_PRZCOP = V_PREZZO
   
   v_seek	= 'IVA' + M.ART_CODIVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      ALIQ = SUBSTR(LIBERA,1,3)
      NUM_ALIQ = VAL(ALIQ)
   ELSE
      NUM_ALIQ = 0
   ENDIF
   M.ART_PRZVEN = ROUND((M.ART_PRZIVA / ((NUM_ALIQ / 100) + 1)),2)

   M.ART_LINEA  = PUB_LINEA  
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
    
   M.ART_CATMER = ALLTRIM(SUBSTR(TRA_RECORD,88,3))   
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

   M.ART_COLLAN = ALLTRIM(SUBSTR(TRA_RECORD,80,3))   
   IF M.ART_COLLAN = SPACE(03) .OR. EMPTY(M.ART_COLLAN)
      M.ART_COLLAN = SPACE(03)
      M.ART_DESCOA = SPACE(50)
   ELSE
      v_seek   = 'COA'+ALLTRIM(M.ART_COLLAN)
      v_chiave = "codice"
      cSql     = "select * from para where " + v_chiave + " = '" + v_seek + "'"
      IF !ExecCommand(cSql,"PARA")
         return(.f.)
      ENDIF
      SELECT PARA
      IF RECCOUNT() <> 0
         M.ART_DESCOA = DESCRI
      ELSE
         M.ART_DESCOA = SPACE(50)
	  ENDIF
   ENDIF
   SELECT TRANSITO

   M.ART_EDITOR = ALLTRIM(SUBSTR(TRA_RECORD,93,5))   
   IF M.ART_EDITOR = SPACE(05) .OR. EMPTY(M.ART_EDITOR)
      M.ART_EDITOR = SPACE(05)
      M.ART_DESEDI = SPACE(50)
   ELSE
      v_seek   = 'EDR'+ALLTRIM(M.ART_EDITOR)
      v_chiave = "codice"
      cSql     = "select * from para where " + v_chiave + " = '" + v_seek + "'"
      IF !ExecCommand(cSql,"PARA")
         return(.f.)
      ENDIF
      SELECT PARA
      IF RECCOUNT() <> 0
         M.ART_DESEDI = DESCRI
      ELSE
         M.ART_DESEDI = SPACE(50)
	  ENDIF
   ENDIF
   SELECT TRANSITO

   DO GESTIONE_ART

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


**********************
PROCEDURE GESTIONE_ART
**********************

M.ART_CODSOC = '01'
M.ART_CODPRI = UPPER(M.ART_CODPRI)
M.ART_CODPRI = APITOSPA(M.ART_CODPRI)

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

M.ART_DESCR  = UPPER(M.ART_DESCR)
M.ART_DESCR  = APITOSPA(M.ART_DESCR)
M.ART_DESEST = UPPER(M.ART_DESEST)
M.ART_DESEST = APITOSPA(M.ART_DESEST)
M.ART_AUTORE = UPPER(M.ART_AUTORE)
M.ART_AUTORE = APITOSPA(M.ART_AUTORE)

REPLACE ART_CODSOC WITH M.ART_CODSOC
REPLACE ART_CODPRI WITH M.ART_CODPRI
REPLACE ART_DESCR  WITH M.ART_DESCR
REPLACE ART_DESEST WITH M.ART_DESEST
REPLACE ART_DESRID WITH M.ART_DESCR
REPLACE ART_MAGA   WITH PUB_CODM
REPLACE ART_UNIMIS WITH M.ART_UNIMIS
REPLACE ART_LINEA  WITH M.ART_LINEA
REPLACE ART_DESLIN WITH M.ART_DESLIN
REPLACE ART_CODIVA WITH M.ART_CODIVA
REPLACE ART_CATMER WITH M.ART_CATMER
REPLACE ART_DESMER WITH M.ART_DESMER
REPLACE ART_COLLAN WITH M.ART_COLLAN
REPLACE ART_DESCOA WITH M.ART_DESCOA
REPLACE ART_EDITOR WITH M.ART_EDITOR
REPLACE ART_DESEDI WITH M.ART_DESEDI
REPLACE ART_AUTORE WITH M.ART_AUTORE
REPLACE ART_DATVAR WITH M.ART_DATVAR
REPLACE ART_DATINS WITH M.ART_DATINS
REPLACE ART_CDISBN WITH M.ART_CDISBN
REPLACE ART_PRZIVA WITH M.ART_PRZIVA
REPLACE ART_PRZCOP WITH M.ART_PRZCOP
REPLACE ART_PRZVEN WITH M.ART_PRZVEN
REPLACE ART_FLGTRA WITH .T.
IF !ExecRW(cSql,"u_art_pr","W")
   return
ENDIF

x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_maga = "mag_codmag = '" + PUB_CODM + "'"
x_codi = "mag_codart = '" + ALLTRIM(M.ART_CODPRI) + "'"
x_cond = x_soci + " and " + x_maga + " and " + x_codi
Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
GO TOP
IF EOF()
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_CODMAG WITH PUB_CODM
   REPLACE MAG_CODART WITH M.ART_CODPRI
   REPLACE MAG_DESART WITH M.ART_DESCR
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_UNIMIS WITH M.ART_UNIMIS
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF

V_CONTA = V_CONTA + 1

_CTR = _CTR +1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

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

