PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE TIPO LAVORAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_ca order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
           ELSE
              x_codi = "cap_codlav like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_ca where " + x_cond + ;
                         " order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
           ENDIF
        ELSE
           x_codi = "cap_codlav like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from u_pro_ca where " + x_cond + ;
                      " order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
        ENDIF
    
   CASE V_SCELTA=2                          && ACCESSO PER CODICE MACCHINA DI PRODUZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_ca order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
           ELSE             
              x_codi = "cap_codmac like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_ca where " + x_cond + ;
                         " order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
           ENDIF
        ELSE
           x_codi = "cap_codmac like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from u_pro_ca where " + x_cond + ;
                      " order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
        ENDIF
        
     CASE V_SCELTA=3                          && ACCESSO PER CODICE TIPO PRODOTTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_ca order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
           ELSE
              IF VAL(ALLTRIM(V_SEEK)) = 0                     
                 V_SEEK = ALLTRIM(V_SEEK)
              ELSE
                 PUB_LNO = 3
                 V_SEEK = TRC(PUB_LNO,ALLTRIM(V_SEEK))
                 _SCREEN.ActiveForm.REFRESH
              ENDIF              
              x_codi = "cap_codmat like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_ca where " + x_cond + ;
                         " order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
           ENDIF
        ELSE
           IF VAL(ALLTRIM(V_SEEK)) = 0                     
              V_SEEK = ALLTRIM(V_SEEK)
           ELSE
              PUB_LNO = 3
              V_SEEK = TRC(PUB_LNO,ALLTRIM(V_SEEK))
              _SCREEN.ActiveForm.REFRESH
           ENDIF              
           x_codi = "cap_codmat like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from u_pro_ca where " + x_cond + ;
                      " order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
        ENDIF
        
     CASE V_SCELTA=4                          && ACCESSO PER CODICE FORMULA DI.BA.
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_pro_ca order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
           ELSE              
              x_codi = "cap_cddiba like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from u_pro_ca where " + x_cond + ;
                         " order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
           ENDIF
        ELSE              
           x_codi = "cap_cddiba like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from u_pro_ca where " + x_cond + ;
                      " order by cap_codlav,cap_codmac,cap_codmat,cap_cddiba" 
        ENDIF

ENDCASE

