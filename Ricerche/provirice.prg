PARAMETERS V_SEEK

x_cond   = "1=1"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER SIGLA PROVINCIA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "sigla like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "sigla like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from province where " + x_cond + ;
                                                 " order by sigla,provincia" 
                                                 
   CASE V_SCELTA=2                         && ACCESSO PER DESCRIZIONE PROVINCIA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "provincia like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "provincia like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from province where " + x_cond + ;
                                                 " order by provincia" 
 		
   CASE V_SCELTA=3                         && ACCESSO PER CODICE REGIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "regione = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "regione = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from province where " + x_cond + ;
                                                 " order by regione,provincia"                                                                                           
   
ENDCASE
