RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei parametri vari ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'PA1'
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

DELETE FOR SUBSTR(TRA_RECORD,2,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,25,3) = "Dal"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,6) = "T Num."  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,100) = SPACE(100)  ALL
GO TOP

V_PRIMO = .T.
V_CONTA = 0

cSql = "delete from para where codice like 'GED%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
cSql = "delete from para where codice like 'EDR%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
cSql = "delete from para where codice like 'COA%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
cSql = "delete from para where codice like 'REP%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF SUBSTR(TRA_RECORD,1,1) <> SPACE(01)
      IF SUBSTR(TRA_RECORD,1,1) = 'P'
         IF SUBSTR(TRA_RECORD,6,1) = '1' .AND. ;
            SUBSTR(TRA_RECORD,19,7) = 'EDITORI'
            DO GESTIONE_EDR
            LOOP
         ENDIF
         IF SUBSTR(TRA_RECORD,6,1) = '2' .AND. ;
            SUBSTR(TRA_RECORD,19,17) = 'GRUPPO EDITORIALE'
            DO GESTIONE_GED
            LOOP
         ENDIF
         IF SUBSTR(TRA_RECORD,6,1) = '3' .AND. ;
            SUBSTR(TRA_RECORD,19,7) = 'COLLANA'
            DO GESTIONE_COA
            LOOP
         ENDIF
      ENDIF
      IF SUBSTR(TRA_RECORD,1,1) = 'M'
         IF SUBSTR(TRA_RECORD,6,1) = '7' .AND. ;
            SUBSTR(TRA_RECORD,19,13) = 'TIPO ARTICOLO'
            DO GESTIONE_REP
            LOOP
         ENDIF
      ENDIF
   ENDIF
   
   SKIP +1
   LOOP
   
ENDDO

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN

   
**********************
PROCEDURE GESTIONE_EDR
**********************

V_CONTA = 0

SELECT TRANSITO
SKIP +1

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF SUBSTR(TRA_RECORD,1,1) <> SPACE(01)
      EXIT
   ENDIF
   
   x_codice = SUBSTR(TRA_RECORD,8,5)
   x_descri = SUBSTR(TRA_RECORD,19,50)

   x_codi = "codice = 'EDR" + ALLTRIM(x_codice) + "'"
   cSql   = "select * from para where " + x_codi + " order by codice"
   IF !ExecRW(cSql,"para","R")
      return
   ENDIF
   SELECT para
   IF EOF()
      APPEND BLANK
      M.ID_UNIQUE = ""
   ENDIF
   REPLACE CODICE  WITH 'EDR' + ALLTRIM(x_codice)
   REPLACE DESCRI  WITH x_descri
   IF !ExecRW(cSql,"para","W")
      return
   ENDIF
   
   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS SCRITTI EDITORI : "+STR(V_CONTA,10,0) NOWAIT

   SELECT TRANSITO
   SKIP +1
   
ENDDO

RETURN


**********************
PROCEDURE GESTIONE_GED
**********************

V_CONTA = 0

SELECT TRANSITO
SKIP +1

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF SUBSTR(TRA_RECORD,1,1) <> SPACE(01)
      EXIT
   ENDIF
   
   x_codice = SUBSTR(TRA_RECORD,8,5)
   x_descri = SUBSTR(TRA_RECORD,19,50)

   x_codi = "codice = 'GED" + ALLTRIM(x_codice) + "'"
   cSql   = "select * from para where " + x_codi + " order by codice"
   IF !ExecRW(cSql,"para","R")
      return
   ENDIF
   SELECT para
   IF EOF()
      APPEND BLANK
      M.ID_UNIQUE = ""
   ENDIF
   REPLACE CODICE  WITH 'GED' + ALLTRIM(x_codice)
   REPLACE DESCRI  WITH x_descri
   IF !ExecRW(cSql,"para","W")
      return
   ENDIF

   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS SCRITTI GR.EDITORIALI : "+STR(V_CONTA,10,0) NOWAIT

   SELECT TRANSITO
   SKIP +1
   
ENDDO

RETURN


**********************
PROCEDURE GESTIONE_COA
**********************

V_CONTA = 0

SELECT TRANSITO
SKIP +1

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF SUBSTR(TRA_RECORD,1,1) <> SPACE(01)
      EXIT
   ENDIF
   
   x_codice = SUBSTR(TRA_RECORD,8,5)
   x_descri = SUBSTR(TRA_RECORD,19,50)

   x_codi = "codice = 'COA" + ALLTRIM(x_codice) + "'"
   cSql   = "select * from para where " + x_codi + " order by codice"
   IF !ExecRW(cSql,"para","R")
      return
   ENDIF
   SELECT para
   IF EOF()
      APPEND BLANK
      M.ID_UNIQUE = ""
   ENDIF
   REPLACE CODICE  WITH 'COA' + ALLTRIM(x_codice)
   REPLACE DESCRI  WITH x_descri
   IF !ExecRW(cSql,"para","W")
      return
   ENDIF

   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS SCRITTI COLLANE : "+STR(V_CONTA,10,0) NOWAIT

   SELECT TRANSITO
   SKIP +1
   
ENDDO

RETURN


**********************
PROCEDURE GESTIONE_REP
**********************

V_CONTA = 0

SELECT TRANSITO
SKIP +1

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF SUBSTR(TRA_RECORD,1,1) <> SPACE(01)
      EXIT
   ENDIF
   
   x_codice = SUBSTR(TRA_RECORD,8,2)
   x_descri = SUBSTR(TRA_RECORD,19,50)

   x_codi = "codice = 'REP" + ALLTRIM(x_codice) + "'"
   cSql   = "select * from para where " + x_codi + " order by codice"
   IF !ExecRW(cSql,"para","R")
      return
   ENDIF
   SELECT para
   IF EOF()
      APPEND BLANK
      M.ID_UNIQUE = ""
   ENDIF
   REPLACE CODICE  WITH 'REP' + ALLTRIM(x_codice)
   REPLACE DESCRI  WITH x_descri
   IF !ExecRW(cSql,"para","W")
      return
   ENDIF

   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS SCRITTI LINEA DI PRODOTTO : "+STR(V_CONTA,10,0) NOWAIT

   SELECT TRANSITO
   SKIP +1
   
ENDDO

RETURN