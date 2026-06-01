RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"delle giacenze di magazzino ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'GIA'
IF FOUND()
ELSE
   RETURN
ENDIF

SELECT PERCORSO
V_PATH = ALLTRIM(PER_PATH)

cSql = "select * from u_cnt_an where cnt_tipo = 'GIA'"
IF !ExecRW(cSql,"U_CNT_AN","R")
   return(.f.)
ENDIF
SELECT U_CNT_AN
IF EOF()
   APPEND BLANK
ENDIF
REPLACE CNT_TIPO   WITH 'GIA'
REPLACE CNT_DATINI WITH RIBALTA2(DTOC(DATE()))
REPLACE CNT_ORAINI WITH TIME()
REPLACE CNT_DATFIN WITH SPACE(10)
REPLACE CNT_ORAFIN WITH SPACE(05)
REPLACE CNT_NUMREC WITH 0
REPLACE CNT_FILE   WITH V_PATH
IF !ExecRW(cSql,"U_CNT_AN","W")
   return(.f.)
ENDIF

cSql = "delete from para where codice like 'MAG%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
cSql = "delete from u_mag_an where 1=1"
IF !ExecCommand(cSql,"U_MAG_AN")
   return(.f.)
ENDIF
cSql = "delete from u_mag_mo where 1=1"
IF !ExecCommand(cSql,"U_MAG_MO")
   return(.f.)
ENDIF
cSql = "delete from u_mag_gg where 1=1"
IF !ExecCommand(cSql,"U_MAG_GG")
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
DELETE FOR SUBSTR(TRA_RECORD,3,30) = SPACE(30)  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,3,9) = "Magazzino"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,3,3) = "Da "  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,3,4) = "Tipo"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,3,6) = "Codice"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,8) = "Gr.Merc."  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,6) = "TOTALI"  ALL
GO TOP

V_CONTA = 0

SELECT TRANSITO
GO TOP

M.MAG_CODSOC = PUB_CODSOC

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF SUBSTR(TRA_RECORD,1,9) = 'Magazzino'
      M.MAG_CODMAG = ALLTRIM(SUBSTR(TRA_RECORD,13,03))
      PUB_LNO      = 3
      M.MAG_CODMAG = TRC(PUB_LNO,ALLTRIM(M.MAG_CODMAG))
      V_DESMAG     = ALLTRIM(SUBSTR(TRA_RECORD,16,50))
      v_seek   = 'MAG'+ALLTRIM(M.MAG_CODMAG)
      v_chiave = "codice"
      cSql     = "select * from para where " + v_chiave + " = '" + v_seek + "'"
      IF !ExecRW(cSql,"PARA","R")
         return(.f.)
      ENDIF
      SELECT PARA
      IF RECCOUNT() <> 0
      ELSE
         APPEND BLANK
	     REPLACE CODICE WITH 'MAG'+ALLTRIM(M.MAG_CODMAG)
	     REPLACE DESCRI WITH V_DESMAG
	  ENDIF
      IF !ExecRW(cSql,"PARA","W")
         return(.f.)
      ENDIF
      SELECT TRANSITO
      SKIP +1
      LOOP
   ENDIF  
      
   M.MAG_CODART = ALLTRIM(SUBSTR(TRA_RECORD,1,16))  
   M.MAG_DESART = ALLTRIM(SUBSTR(TRA_RECORD,20,35))  

   V_CAMPO      = ALLTRIM(SUBSTR(TRA_RECORD,150,7))
   DO TOGLI_PUNTI
   M.MAG_GIACEN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(SUBSTR(TRA_RECORD,57,10))
   DO TOGLI_PUNTI
   V_PRZIVA     = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(SUBSTR(TRA_RECORD,73,10))
   DO TOGLI_PUNTI
   V_PRZCOP     = VAL(ALLTRIM(Y_CAMPO))

   x_soci = "art_codsoc = '" + M.MAG_CODSOC + "'"
   x_codi = "art_codpri = '" + M.MAG_CODART + "'"
   x_cond = x_soci + " and " + x_codi
   cSql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"u_art_pr")
      return
   ENDIF
   SELECT u_art_pr
   IF EOF()
      V_DESART = M.MAG_DESART
      V_UNIMIS = 'NR'
      V_CODIVA = '74'
      V_PRZVEN = 0
   ELSE
      V_UNIMIS = ART_UNIMIS
      V_DESART = ART_DESCR
      V_CODIVA = ART_CODIVA
      V_PRZVEN = ART_PRZVEN
   ENDIF

   M.MAG_UNIMIS = V_UNIMIS

   DO GESTIONE_GIA

   SELECT TRANSITO      
   SKIP +1

ENDDO

cSql = "select * from u_cnt_an where cnt_tipo = 'GIA'"
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


   
**********************
PROCEDURE GESTIONE_GIA
**********************

M.MAG_CODSOC = '01'

x_soci = "mag_codsoc = '" + M.MAG_CODSOC + "'"
x_maga = "mag_codmag = '" + M.MAG_CODMAG + "'"
x_codi = "mag_codart = '" + M.MAG_CODART + "'"
x_cond = x_soci + " and " + x_maga + " and " + x_codi
cSql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"u_mag_an","R")
   return
ENDIF
SELECT u_mag_an
IF EOF()
   m.id_unique = ""
   APPEND BLANK
ENDIF
V_DESART  = UPPER(V_DESART)
V_DESART  = APITOSPA(V_DESART)
REPLACE MAG_CODSOC WITH M.MAG_CODSOC
REPLACE MAG_CODART WITH M.MAG_CODART
REPLACE MAG_DESART WITH V_DESART
REPLACE MAG_CODMAG WITH M.MAG_CODMAG
REPLACE MAG_GIACEN WITH M.MAG_GIACEN
REPLACE MAG_UNIMIS WITH M.MAG_UNIMIS
IF !ExecRW(cSql,"u_mag_an","W")
   return
ENDIF

cSql   = "select * from u_mag_mo"
IF !ExecRW(cSql,"u_mag_mo","R")
   return
ENDIF
SELECT u_mag_mo
m.id_unique = ""
APPEND BLANK
REPLACE MOV_CODSOC WITH M.MAG_CODSOC
REPLACE MOV_CODMAG WITH M.MAG_CODMAG
REPLACE MOV_CODART WITH M.MAG_CODART
REPLACE MOV_TOP    WITH 'INI'
REPLACE MOV_QTAMOV WITH M.MAG_GIACEN
REPLACE MOV_NUMDOC WITH '000001'
REPLACE MOV_DTDOCU WITH RIBALTA2(DTOC(DATE()))
REPLACE MOV_DTREGI WITH RIBALTA2(DTOC(DATE()))
REPLACE MOV_PREVEN WITH V_PRZVEN
REPLACE MOV_VALVEN WITH ROUND((MOV_PREVEN * MOV_QTAMOV),2)
REPLACE MOV_UM     WITH M.MAG_UNIMIS
REPLACE MOV_DESART WITH V_DESART
REPLACE MOV_ORAMOV WITH TIME()
IF MOV_QTAMOV < 0
   REPLACE MOV_SEGNO  WITH '-' 
   X_SEGNO = '-'
ELSE
   REPLACE MOV_SEGNO  WITH '+'
   X_SEGNO = '+'
ENDIF
REPLACE MOV_FLGTRA WITH .T.
IF !ExecRW(cSql,"u_mag_mo","W")
   return
ENDIF

V_CODFOR = SPACE(10)
V_DESFOR = SPACE(50)

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
x_data   = "mag_datagg = '" + SPACE(10) + "'"
x_codi   = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
x_maga   = "mag_codmag = '" + ALLTRIM(M.MAG_CODMAG) + "'"
x_forn   = "mag_fornit = '" + ALLTRIM(V_CODFOR) + "'"
x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
IF RECCOUNT() = 0
   APPEND BLANK
   REPLACE MAG_CODSOC WITH M.MAG_CODSOC
   REPLACE MAG_DATAGG WITH SPACE(10)
   REPLACE MAG_CODMAG WITH M.MAG_CODMAG
   REPLACE MAG_CODART WITH M.MAG_CODART
   REPLACE MAG_DESART WITH V_DESART
   *REPLACE MAG_CODPDV WITH M.MAG_CODMAG
   REPLACE MAG_FORNIT WITH V_CODFOR
   REPLACE MAG_DESFOR WITH V_DESFOR
   REPLACE MAG_GIACEN WITH 0
ENDIF
IF X_SEGNO = '+'
   REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MAG_GIACEN
ELSE
   REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MAG_GIACEN
ENDIF
IF !ExecRw(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
x_data   = "mag_datagg = '" + RIBALTA2(DTOC(DATE())) + "'"
x_codi   = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
x_maga   = "mag_codmag = '" + ALLTRIM(M.MAG_CODMAG) + "'"
x_forn   = "mag_fornit = '" + ALLTRIM(V_CODFOR) + "'"
x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
IF RECCOUNT() = 0
   APPEND BLANK
   REPLACE MAG_CODSOC WITH M.MAG_CODSOC
   REPLACE MAG_DATAGG WITH RIBALTA2(DTOC(DATE()))
   REPLACE MAG_CODMAG WITH M.MAG_CODMAG
   REPLACE MAG_CODART WITH M.MAG_CODART
   REPLACE MAG_DESART WITH V_DESART
   *REPLACE MAG_CODPDV WITH M.MAG_CODMAG
   REPLACE MAG_FORNIT WITH V_CODFOR
   REPLACE MAG_DESFOR WITH V_DESFOR
   REPLACE MAG_GIACEN WITH 0
ENDIF
IF X_SEGNO = '+'
   REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MAG_GIACEN
ELSE
   REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MAG_GIACEN
ENDIF
IF !ExecRw(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

V_CONTA = V_CONTA + 1

_CTR = _CTR +1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

RETURN