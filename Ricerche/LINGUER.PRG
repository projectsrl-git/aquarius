PARAMETERS V_SEEK

x_soci = "codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE NAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nazi = "cod_naz like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_nazi
           ENDIF
        ELSE
           x_nazi = "cod_naz like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_nazi
           _ii_cSql = "select * from lingue where " + x_cond + ;
                                                 " order by cod_naz" 
        ENDIF
        _ii_cSql = "select * from lingue where " + x_cond + ;
                                                 " order by cod_naz" 
ENDCASE