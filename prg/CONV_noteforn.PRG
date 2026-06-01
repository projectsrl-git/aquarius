RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"delle note in anagrafica fornitori ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
SEEK 'NOF'
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

*SELECT TRANSITO  
*gcTable = GETFILE('', 'Seleziona file piano mdei conti da convertire', 'Converti',0)
*IF empty(gcTable) .or. gcTable = ""
*   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
*   RETURN
*ENDIF
*APPEND FROM &gcTable SDF
*GO TOP

DELETE FOR SUBSTR(TRA_RECORD,2,5) = "-----"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,3,7) = "Azienda"  ALL
GO TOP
DELETE FOR SUBSTR(TRA_RECORD,1,100) = SPACE(100) ALL
GO TOP

V_PRIMO = .T.
V_CONTA = 0

SELECT TRANSITO
GO TOP

DO WHILE .T.

   IF EOF()
      DO VERIFICA_FORNITORE
      EXIT
   ENDIF

   IF SUBSTR(TRA_RECORD,4,8) <> SPACE(08)
      IF V_PRIMO
         V_PRIMO  = .F.
         V_CODSOC = '01'
         V_CODFOR = ALLTRIM(SUBSTR(TRA_RECORD,4,2)) +  ALLTRIM(SUBSTR(TRA_RECORD,7,5))
         V_CODFOR = TRC(PUB_LCL,ALLTRIM(V_CODFOR))
         V_NOTE   = ""
      ELSE
         DO VERIFICA_FORNITORE
         SELECT TRANSITO
         V_CODSOC = '01'
         V_CODFOR = ALLTRIM(SUBSTR(TRA_RECORD,4,2)) +  ALLTRIM(SUBSTR(TRA_RECORD,7,5))
         V_CODFOR = TRC(PUB_LCL,ALLTRIM(V_CODFOR))
         V_NOTE   = ""
      ENDIF
   ENDIF

   IF EMPTY(V_NOTE) 
      V_NOTE = SUBSTR(TRA_RECORD,13,70)
   ELSE
      V_NOTE = V_NOTE + CHR(13) + SUBSTR(TRA_RECORD,13,70)
   ENDIF
          
   SELECT TRANSITO      
   SKIP +1

ENDDO

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN

   
****************************
PROCEDURE VERIFICA_FORNITORE
****************************

x_soci = "for_codsoc = '" + V_CODSOC + "'"
x_codi = "for_codcli = '" + V_CODFOR + "'"
x_cond = x_soci + " and " + x_codi
cSql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecRW(cSql,"u_for_an","R")
   return
ENDIF
SELECT u_for_an
IF EOF()
ELSE
   REPLACE FOR_NOTE   WITH V_NOTE
ENDIF
IF !ExecRW(cSql,"u_for_an","W")
   return
ENDIF

V_CONTA = V_CONTA + 1

_CTR = _CTR +1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

RETURN