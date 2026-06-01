PARAMETERS V_SEEK

x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci 

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE RIGA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "LTRIM(RTRIM(bil_codrig)) = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql   = "select * from bilnew where " + x_cond + ;
                                                    " order by bil_codsoc,bil_codrig" 
        ELSE
           x_codi = "LTRIM(RTRIM(bil_codrig)) = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql   = "select * from bilnew where " + x_cond + ;
                                                 " order by bil_codsoc,bil_codrig" 

ENDCASE