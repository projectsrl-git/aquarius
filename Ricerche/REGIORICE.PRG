PARAMETERS V_SEEK

x_cond = "1=1"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER CODICE REGIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "codice = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "codice = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from regioni where " + x_cond + ;
                                                 " order by codice,regione"
                                                 
   CASE V_SCELTA=2                         && ACCESSO PER DESCRIZIONE REGIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc   = "regione like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_desc   
           ENDIF
        ELSE
           x_desc   = "regione like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_desc   
        ENDIF
        _ii_cSql = "select * from regioni where " + x_cond + ;
                                                 " order by codice,regione"
   
ENDCASE
