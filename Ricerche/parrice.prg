PARAMETERS V_SEEK

x_cond   = "1=1"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER COD.NAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "par_codnaz like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "par_codnaz like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_par_ct where " + x_cond + ;
                                                 " order by par_codnaz,par_desnaz,par_zona,par_tiptra,par_destra" 
                                                 
   CASE V_SCELTA=2                         && ACCESSO PER DESCR.NAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "par_desnaz like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "par_desnaz like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_par_ct where " + x_cond + ;
                                                 " order by par_codnaz,par_desnaz,par_zona,par_tiptra,par_destra" 
                                                 
   CASE V_SCELTA=3                         && ACCESSO PER ZONA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "par_zona like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "par_zona like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_par_ct where " + x_cond + ;
                                                 " order by par_codnaz,par_desnaz,par_zona,par_tiptra,par_destra" 
                                                 
   CASE V_SCELTA=4                         && ACCESSO PER COD.TIPO TRASPORTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "par_tiptra like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "par_tiptra like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_par_ct where " + x_cond + ;
                                                 " order by par_codnaz,par_desnaz,par_zona,par_tiptra,par_destra" 
                                                 
   CASE V_SCELTA=5                         && ACCESSO PER DESCR.TIPO TRASPORTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "par_destra like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "par_destra like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_par_ct where " + x_cond + ;
                                                 " order by par_codnaz,par_desnaz,par_zona,par_tiptra,par_destra" 
                                                   
ENDCASE
