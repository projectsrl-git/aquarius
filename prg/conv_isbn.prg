*********************************************************
* PROCEDURA PER CONVERSIONE DA CODICE EAN A CODICE ISBN *
*********************************************************

RIT = MESSAGEBOX("Procedo con la verifica "+CHR(13)+"del codice ISBN ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

PUBLIC V_CONTA
V_CONTA = 0

cSql="select * from u_art_pr where 0=0 order by art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   V_EAN = EANTOISBN(ART_CODPRI)

   REPLACE ART_CDISBN WITH V_EAN

   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(V_CONTA,10,0) NOWAIT
   
   SELECT U_ART_PR
   SKIP +1
   
ENDDO

IF !ExecRW(cSql,"U_ART_PR","W")
   return(.f.)
ENDIF

=MESSAGEBOX("Operazione terminata correttamente ",62,"ATTENZIONE")

RETURN