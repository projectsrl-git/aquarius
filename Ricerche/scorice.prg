PARAMETERS V_SEEK

x_cond = "sco_codart = '" + M.SCO_CODART + "'"

DO CASE
 
   CASE V_SCELTA=1                         && ACCESSO PER ALTEZZA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "sco_altezz = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "sco_altezz = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_sco_mi where " + x_cond + ;
                                                 " order by sco_codart,sco_altezz,sco_lunghe,sco_scormi" 
                                                 
   CASE V_SCELTA=2                         && ACCESSO PER LUNGHEZZA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "sco_lunghe = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "sco_lunghe = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_sco_mi where " + x_cond + ;
                                                 " order by sco_lunghe,sco_codart,sco_altezz,sco_scormi" 
                                                 
   CASE V_SCELTA=3                         && ACCESSO PER SCORTA MINIMA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "sco_scormi = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "sco_scormi = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_sco_mi where " + x_cond + ;
                                                 " order by sco_codart,sco_scormi,sco_altezz,sco_lunghe"                                                                                                   
ENDCASE
