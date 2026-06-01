PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO CODICE 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pdv_cc order by pdv_codice" 
           ELSE
              x_codi   = "pdv_codice = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_codi
              _ii_cSql = "select * from u_pdv_cc where " + x_cond + ;
                                                       " order by pdv_codice" 
           ENDIF
        ELSE
           x_codi   = "pdv_codice = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_codi
           _ii_cSql = "select * from u_pdv_cc where " + x_cond + ;
                                                    " order by pdv_codice" 
        ENDIF

   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pdv_cc order by pdv_descri" 
           ELSE
              x_codi   = "pdv_descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
              _ii_cSql = "select * from u_pdv_cc where " + x_cond + ;
                                                       " order by pdv_descri" 
           ENDIF
        ELSE
           x_codi   = "pdv_descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi
           _ii_cSql = "select * from u_pdv_cc where " + x_cond + ;
                                                    " order by pdv_descri" 
        ENDIF

   CASE V_SCELTA=3          				&& ACCESSO PROGRESSIVO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pdv_cc order by pdv_progre" 
           ELSE
              x_codi   = "pdv_progre >= " + ALLTRIM(V_SEEK) 
              x_cond   = x_codi
              _ii_cSql = "select * from u_pdv_cc where " + x_cond + ;
                                                       " order by pdv_progre" 
           ENDIF
        ELSE
           x_codi   = "pdv_progre >= " + ALLTRIM(V_SEEK) 
           x_cond   = x_codi
           _ii_cSql = "select * from u_pdv_cc where " + x_cond + ;
                                                    " order by pdv_progre" 
        ENDIF

ENDCASE

