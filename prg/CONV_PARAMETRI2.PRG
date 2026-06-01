RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei gruppi merceologici ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'PA2'
IF FOUND()
ELSE
   RETURN
ENDIF

V_PATH = ALLTRIM(PER_PATH)

PUBLIC Y_CAMPO,V_CAMPO,_CTR
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0

CREATE CURSOR TRANSITO (TRA_RECORD C(200))

SELECT TRANSITO
APPEND FROM &V_PATH SDF

DELETE FOR SUBSTR(TRA_RECORD,3,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,7,3) = "Gr."  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,2,10) = "----------"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,100) = SPACE(100)  ALL
GO TOP

V_PRIMO = .T.
V_CONTA = 0

cSql = "delete from para where codice like 'MER%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   x_codice = SUBSTR(TRA_RECORD,10,3)
   x_descri = SUBSTR(TRA_RECORD,20,50)

   x_codi = "codice = 'MER" + ALLTRIM(x_codice) + "'"
   cSql   = "select * from para where " + x_codi + " order by codice"
   IF !ExecRW(cSql,"para","R")
      return
   ENDIF
   SELECT para
   IF EOF()
      APPEND BLANK
      M.ID_UNIQUE = ""
   ENDIF
   REPLACE CODICE  WITH 'MER' + ALLTRIM(x_codice)
   REPLACE DESCRI  WITH x_descri
   IF !ExecRW(cSql,"para","W")
      return
   ENDIF
   
   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(V_CONTA,10,0) NOWAIT
   
   SELECT TRANSITO
   SKIP +1
   
ENDDO

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN

   
