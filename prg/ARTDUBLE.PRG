cSql = "select * from u_art_pr"
IF !ExecCommand(cSql,"PIPPO")
   RETURN .F.
ENDIF

SELECT PIPPO
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   V_CODICE = ART_CODPRI

   x_cond = "art_codpri = '" + V_CODICE + "'"
   cSql = "select * from u_art_pr where " + x_cond
   IF !ExecCommand(cSql,"VIVA")
      RETURN .F.
   ENDIF
   SELECT VIVA
   IF RECCOUNT() > 1
      GO TOP
      SKIP +1
      M.ID_UNIQUE = ID_UNIQUE
      CSQL="DELETE FROM U_ART_PR WHERE ID_UNIQUE = ?M.ID_UNIQUE"
      IF !ExecCommand(CSQL,"U_ART_PR")
         RETURN (.f.)
      ENDIF
   ENDIF 
   
   SELECT PIPPO
   SKIP +1
   
ENDDO