PARAMETERS V_SEEK

x_soci = "anno = '" + PUB_anno + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,3) = SPACE(03)
           ELSE
              x_codi = "Codice = '" + ALLTRIM(v_seek) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select CODICE,SUBSTRING(TITOLO,1,40) AS TITOLO,* from BUDGET_SINT_TT where " + x_cond + ;
                                                    " order by Codice" 
        ELSE
           x_codi = "Codice = '" + ALLTRIM(v_seek) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select CODICE,SUBSTRING(TITOLO,1,40) AS TITOLO,* from BUDGET_SINT_TT where " + x_cond + ;
                                                 " order by Codice" 
   
   CASE V_SCELTA=2                          && ACCESSO PER TITOLO
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,3) = SPACE(03)
           ELSE
              x_codi = "Titolo like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select CODICE,SUBSTRING(TITOLO,1,40) AS TITOLO,* from BUDGET_SINT_TT where " + x_cond + ;
                                                    " order by Codice" 
        ELSE
           x_codi = "Titolo like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select CODICE,SUBSTRING(TITOLO,1,40) AS TITOLO,* from BUDGET_SINT_TT where " + x_cond + ;
                                                 " order by Codice" 

ENDCASE