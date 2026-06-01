RIT = MESSAGEBOX("Procedo con la sistemazione"+CHR(13)+"del prezzo di acquisto sul'anagrafica articoli (solo s.l.) ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

RELEASE Y_CAMPO,V_CAMPO,_CTR
PUBLIC  Y_CAMPO,V_CAMPO,_CTR
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0

CREATE CURSOR TRANSITO (TRA_RECORD C(250))

SELECT TRANSITO
APPEND FROM COVMAG001-04 SDF

SELECT TRANSITO
GO TOP

DELETE FOR SUBSTR(TRA_RECORD,4,5) = "====="  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,4,5) = "-----"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,5,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,3) = "Da "  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,6) = "Codice"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,11) = "Descrizione"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,2) = SPACE(2)  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,21) = 'TRASPARENTE PERFORATO'  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,9) = 'PERFORATO'  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,5) = 'T O T'  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,8) = 'COPRENTE'  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,15) = 'BLU TRASPARENTE'  ALL
GO TOP

V_CONTA = 0

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   V_CODART = ALLTRIM(SUBSTR(TRA_RECORD,1,16))  
   SKIP +1
   
   V_CAMPO  = ALLTRIM(SUBSTR(TRA_RECORD,93,7))
   DO TOGLI_PUNTI
   V_PREZZO = VAL(ALLTRIM(Y_CAMPO))
   V_PRZCOS = V_PREZZO

   DO GESTIONE_ART

   SELECT TRANSITO
   SKIP +1
   
ENDDO

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN


**********************
PROCEDURE GESTIONE_ART
**********************

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
   REPLACE ART_PRZCOS WITH V_PRZCOS
ENDIF
IF !ExecRW(cSql,"u_art_pr","W")
   return
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

