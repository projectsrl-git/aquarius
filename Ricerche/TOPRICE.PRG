PARAMETERS V_SEEK

x_cond   = "1=1"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER MAG.SCARICO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "top_magsca like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "top_magsca like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_top_mo where " + x_cond + ;
                                                 " order by top_magsca,top_magcar,top_causca,top_caucar,top_attivo" 
                                                 
   CASE V_SCELTA=2                        && ACCESSO PER MAG.CARICO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "top_magcar like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "top_magcar like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_top_mo where " + x_cond + ;
                                                 " order by top_magcar,top_magsca,top_causca,top_caucar,top_attivo"   
                                                 
   CASE V_SCELTA=3                        && ACCESSO PER CAUSALE DI SCARICO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "top_causca like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "top_causca like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_top_mo where " + x_cond + ;
                                                 " order by top_causca,top_magcar,top_magsca,top_caucar,top_attivo"   
                                                 
   CASE V_SCELTA=4                        && ACCESSO PER CAUSALE DI CARICO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "top_caucar like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "top_caucar like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_top_mo where " + x_cond + ;
                                                 " order by top_caucar,top_magcar,top_magsca,top_causca,top_attivo" 
                                                                                                                                                                                                                                                                                 
   
ENDCASE
