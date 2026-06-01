PARAMETERS V_SEEK


_codsco  = ""
x_cond   = "codsco > '" + _codsco  + "'"


DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE TIPOLOGIA SCONTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "codsco = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_sco_sc where " + x_cond + ;
                                                    " order by codsco" 
        ELSE
           x_codi = "codsco = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_sco_sc where " + x_cond + ;
                                                 " order by codsco" 

   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE SCONTO
   
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "dessco like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_sco_sc where " + x_cond + ;
                                                      " order by dessco" 
        ELSE
           x_rags = "dessco like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_sco_sc where " + x_cond + ;
                                                   " order by dessco" 
 
   CASE V_SCELTA=3          				&& ACCESSO PER DATA LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "dtvada = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_sco_sc where " + x_cond + ;
                                                      " order by codsco,dtvada" 
        ELSE
           x_data = "dtvada = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_sco_sc where " + x_cond + ;
                                                   " order by codsco,dtvada" 

ENDCASE