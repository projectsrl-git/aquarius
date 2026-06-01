PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO CODICE 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_con_pe order by con_codice" 
           ELSE
              x_codi   = "con_codice LIKE '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
              _ii_cSql = "select * from u_con_pe where " + x_cond + " order by con_codice" 
           ENDIF
        ELSE
           x_codi   = "con_codice LIKE '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi
           _ii_cSql = "select * from u_con_pe where " + x_cond + " order by con_codice" 
        ENDIF

   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_con_pe order by con_descri" 
           ELSE
              x_codi   = "con_descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
              _ii_cSql = "select * from u_con_pe where " + x_cond + " order by con_descri" 
           ENDIF
        ELSE
           x_codi   = "con_descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi
           _ii_cSql = "select * from u_con_pe where " + x_cond + " order by con_descri" 
        ENDIF

   CASE V_SCELTA=3          				&& ACCESSO SIGLA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_con_pe order by con_sigla,con_codice" 
           ELSE
              x_codi   = "con_sigla = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_codi
              _ii_cSql = "select * from u_con_pe where " + x_cond + " order by con_sigla,con_codice" 
           ENDIF
        ELSE
           x_codi   = "con_sigla = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_codi
           _ii_cSql = "select * from u_con_pe where " + x_cond + " order by con_sigla,con_codice" 
        ENDIF

   CASE V_SCELTA=4          				&& ACCESSO TIPO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_con_pe order by con_tipcon,con_codice" 
           ELSE
              x_codi   = "con_tipcon = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_codi
              _ii_cSql = "select * from u_con_pe where " + x_cond + " order by con_tipcon,con_codice" 
           ENDIF
        ELSE
           x_codi   = "con_tipcon = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_codi
           _ii_cSql = "select * from u_con_pe where " + x_cond + " order by con_tipcon,con_codice" 
        ENDIF

ENDCASE

