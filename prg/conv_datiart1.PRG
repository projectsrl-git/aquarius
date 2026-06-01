RIT = MESSAGEBOX("Procedo con il completamento dei campi "+CHR(13)+"editore, collana e ultimo fornitore su anagrafica articoli ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'AR2'
IF FOUND()
ELSE
   RETURN
ENDIF

SELECT PERCORSO
V_PATH = ALLTRIM(PER_PATH)

cSql = "select * from u_cnt_an where cnt_tipo = 'AR2'"
IF !ExecRW(cSql,"U_CNT_AN","R")
   return(.f.)
ENDIF
SELECT U_CNT_AN
IF EOF()
   APPEND BLANK
ENDIF
REPLACE CNT_TIPO   WITH 'AR2'
REPLACE CNT_DATINI WITH RIBALTA2(DTOC(DATE()))
REPLACE CNT_ORAINI WITH TIME()
REPLACE CNT_DATFIN WITH SPACE(10)
REPLACE CNT_ORAFIN WITH SPACE(05)
REPLACE CNT_NUMREC WITH 0
REPLACE CNT_FILE   WITH V_PATH
IF !ExecRW(cSql,"U_CNT_AN","W")
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

DELETE FOR SUBSTR(TRA_RECORD,21,2) = "Da"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,3,30) = SPACE(30)  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,8) = "Gr.Merc."  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,1) = " "  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,1) = "C"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,1) = "G"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,1) = "T"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,1) = "-"  ALL
GO TOP

V_CONTA = 0

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   V_CODART = ALLTRIM(SUBSTR(TRA_RECORD,12,16))
   SKIP +1
      
   V_CAMPO  = ALLTRIM(SUBSTR(TRA_RECORD,9,10))
   DO TOGLI_PUNTI
   V_PRZVEN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO  = ALLTRIM(SUBSTR(TRA_RECORD,28,10))
   DO TOGLI_PUNTI
   V_PRZCOP = VAL(ALLTRIM(Y_CAMPO))

   SKIP +1
   
   V_RAGSOC = ALLTRIM(SUBSTR(TRA_RECORD,23,20))
   V_CAMPO  = ALLTRIM(SUBSTR(TRA_RECORD,45,10))
   DO TOGLI_PUNTI
   V_ULTPRZ = VAL(ALLTRIM(Y_CAMPO))
   _DATA    = SUBSTR(TRA_RECORD,56,8)
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
   V_ULTDAT = RIBALTA2(_DATA) 
   
   SKIP +1
   
   V_DESEDI = ALLTRIM(SUBSTR(TRA_RECORD,9,30))
   V_DESCOA = ALLTRIM(SUBSTR(TRA_RECORD,48,30))
   
   x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "for_ragsoc like '" + ALLTRIM(V_RAGSOC) + "%'"
   x_cond = x_soci + " and " + x_codi
   cSql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_ragsoc"
   IF !ExecCommand(cSql,"u_for_an")
      return
   ENDIF
   SELECT u_for_an
   IF EOF()
      V_CODFOR = SPACE(10)
   ELSE
      V_CODFOR = FOR_CODCLI
   ENDIF
   
   x_codi = "codice like 'EDR%' and descri like '" + V_DESEDI + "%'"
   x_cond = x_codi 
   cSql   = "select * from para where " + x_cond + " order by codice"
   IF !ExecCommand(cSql,"para")
      return
   ENDIF
   SELECT para
   IF !EOF()
      V_CODEDI = SUBSTR(CODICE,4,5)
   ELSE
      V_CODEDI = SPACE(05)
   ENDIF

   x_codi = "codice like 'COA%' and descri like '" + V_DESCOA + "%'"
   x_cond = x_codi 
   cSql   = "select * from para where " + x_cond + " order by codice"
   IF !ExecCommand(cSql,"para")
      return
   ENDIF
   SELECT para
   IF !EOF()
      V_CODCOA = SUBSTR(CODICE,4,5)
   ELSE
      V_CODCOA = SPACE(05)
   ENDIF
   
   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + V_CODART + "'"
   x_cond = x_soci + " and " + x_codi
   cSql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecRW(cSql,"u_art_pr","R")
      return
   ENDIF
   SELECT u_art_pr
   IF EOF()
   ELSE
      IF ART_PRZVEN = 0
         REPLACE ART_PRZVEN WITH V_PRZVEN
      ENDIF
      IF ART_PRZCOP = 0
         REPLACE ART_PRZCOP WITH V_PRZCOP
      ENDIF
      IF ART_CODF1 = SPACE(10)
         REPLACE ART_CODF1  WITH V_CODFOR
         REPLACE ART_PRZCO1 WITH V_ULTPRZ
      ELSE
         IF ART_CODF1 = V_CODFOR
         ELSE
            IF ART_CODF2 = SPACE(10)
               REPLACE ART_CODF2  WITH V_CODFOR
               REPLACE ART_PRZCO2 WITH V_ULTPRZ
            ELSE
               IF ART_CODF2 = V_CODFOR
               ELSE
                  IF ART_CODF3 = SPACE(10)
                     REPLACE ART_CODF3  WITH V_CODFOR
                     REPLACE ART_PRZCO3 WITH V_ULTPRZ
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      REPLACE ART_ULDCAR WITH V_ULTDAT
      REPLACE ART_ULPCAR WITH V_ULTPRZ
      REPLACE ART_EDITOR WITH V_CODEDI
      REPLACE ART_DESEDI WITH V_DESEDI
      REPLACE ART_COLLAN WITH V_CODCOA
      REPLACE ART_DESCOA WITH V_DESCOA
   ENDIF
   IF !ExecRW(cSql,"u_art_pr","W")
      return
   ENDIF

   V_CONTA = V_CONTA + 1

   _CTR = _CTR +1
   WAIT WINDOWS "RECORDS LETTI/AGGIORNATI : "+STR(_CTR,10,0) NOWAIT

   SELECT TRANSITO      
   SKIP +1

ENDDO

cSql = "select * from u_cnt_an where cnt_tipo = 'AR2'"
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

