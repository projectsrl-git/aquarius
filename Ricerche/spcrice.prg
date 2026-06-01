PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE SPESSORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_my order by mic_spesso"
           ELSE
              x_codi = "mic_spesso = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_my where " + x_cond + ;
                                                    " order by mic_spesso" 
           ENDIF
        ELSE
           x_codi = "mic_spesso = " + ALLTRIM(v_seek)
           x_cond = x_codi
           _ii_cSql = "select * from u_pro_my where " + x_cond + ;
                                                    " order by mic_spesso" 
        ENDIF

   
   CASE V_SCELTA=2                          && ACCESSO PER TIPO MATERIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_my order by mic_spesso" 
           ELSE
              IF VAL(ALLTRIM(V_SEEK)) = 0                     
                 V_SEEK = ALLTRIM(V_SEEK)
              ELSE
                 PUB_LNO = 3
                 V_SEEK = TRC(PUB_LNO,ALLTRIM(V_SEEK))
                 _SCREEN.ActiveForm.REFRESH
              ENDIF              
              x_codi = "mic_codmat like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_my where " + x_cond + ;
                                                    " order by mic_spesso" 
           ENDIF
        ELSE
           IF VAL(ALLTRIM(V_SEEK)) = 0                     
              V_SEEK = ALLTRIM(V_SEEK)
           ELSE
              PUB_LNO = 3
              V_SEEK = TRC(PUB_LNO,ALLTRIM(V_SEEK))
              _SCREEN.ActiveForm.REFRESH
           ENDIF              
           x_codi = "mic_codmat like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from u_pro_my where " + x_cond + ;
                                                    " order by mic_spesso" 
        ENDIF
   
   CASE V_SCELTA=3                          && ACCESSO PER DESCRIZIONE MATERIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_my order by mic_spesso"
           ELSE
              x_codi = "mic_desmat like '" + ALLTRIM(v_seek) + "%'" 
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_my where " + x_cond + ;
                                                    " order by mic_spesso" 
           ENDIF
        ELSE
           x_codi = "mic_desmat like '" + ALLTRIM(v_seek) + "%'" 
           x_cond = x_codi
           _ii_cSql = "select * from u_pro_my where " + x_cond + ;
                                                    " order by mic_spesso" 
        ENDIF

ENDCASE

