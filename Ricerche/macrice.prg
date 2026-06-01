PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_mac_an order by mac_codice"
           ELSE
              x_codi   = "mac_codice >= " + ALLTRIM(V_SEEK)
              x_cond   = x_codi
              _ii_cSql = "select * from u_mac_an where " + x_cond + ;
                                                       " order by mac_codice"
           ENDIF
        ELSE
           x_codi   = "mac_codice >= " + ALLTRIM(V_SEEK)
           x_cond   = x_codi
           _ii_cSql = "select * from u_mac_an where " + x_cond + ;
                                                    " order by mac_codice"
        ENDIF

   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_mac_an order by mac_codice"
           ELSE
              x_codi   = "mac_descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
              _ii_cSql = "select * from u_mac_an where " + x_cond + ;
                                                       " order by mac_descri"
           ENDIF
        ELSE
           x_codi   = "mac_descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi
           _ii_cSql = "select * from u_mac_an where " + x_cond + ;
                                                    " order by mac_descri"
        ENDIF

ENDCASE