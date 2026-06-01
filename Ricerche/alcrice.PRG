PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER ALTEZZA FILM NUDO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_al order by alt_finudo"
           ELSE
              x_codi = "alt_finudo = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_al where " + x_cond + ;
                                                    " order by alt_finudo" 
           ENDIF
        ELSE
           x_codi = "alt_finudo = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_al where " + x_cond + ;
                                                    " order by alt_finudo" 
        ENDIF

   
   CASE V_SCELTA=2                          && ACCESSO PER ALTEZZA FILM SPALMATO DA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_al order by alt_finudo"
           ELSE
              x_codi = "alt_fispda = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_al where " + x_cond + ;
                                                    " order by alt_finudo" 
           ENDIF
        ELSE
           x_codi = "alt_fispda = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_al where " + x_cond + ;
                                                    " order by alt_finudo" 
        ENDIF
   
   CASE V_SCELTA=3                          && ACCESSO PER ALTEZZA FILM SPALMATO AL
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_al order by alt_finudo"
           ELSE
              x_codi = "alt_fispal = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_al where " + x_cond + ;
                                                    " order by alt_finudo" 
           ENDIF
        ELSE
           x_codi = "alt_fispal = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_al where " + x_cond + ;
                                                    " order by alt_finudo" 
        ENDIF

   CASE V_SCELTA=4                          && ACCESSO PER CILINDRO GOMMATO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_al order by alt_finudo"
           ELSE
              x_codi = "alt_cilgom = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_al where " + x_cond + ;
                                                    " order by alt_finudo" 
           ENDIF
        ELSE
           x_codi = "alt_cilgom = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_al where " + x_cond + ;
                                                    " order by alt_finudo" 
        ENDIF
        
ENDCASE

