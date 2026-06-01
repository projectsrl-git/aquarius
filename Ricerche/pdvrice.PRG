PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              x_cond   = "1=1"
           ELSE
              x_codi   = "pdv_codice = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_codi
           ENDIF
        ELSE
           x_codi   = "pdv_codice = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_codi
        ENDIF
        _ii_cSql = "select * from u_pdv_an where " + x_cond + ;
                                                 " order by pdv_codice" 

   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              x_cond   = "1=1"
           ELSE
              x_codi   = "pdv_descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
           ENDIF
        ELSE
           x_codi   = "pdv_descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi
        ENDIF
        _ii_cSql = "select * from u_pdv_an where " + x_cond + ;
                                                 " order by pdv_descri" 

ENDCASE
