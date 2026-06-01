PARAMETERS V_SEEK

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE IMBALLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_imb_tb order by imb_codice"
           ELSE
              x_cond = "imb_codice = '" + ALLTRIM(V_SEEK) + "'"
              _ii_cSql = "select * from u_imb_tb where " + x_cond + ;
                                                       " order by imb_codice"
           ENDIF
        ELSE
           x_cond = "imb_codice = '" + ALLTRIM(V_SEEK) + "'"
           _ii_cSql = "select * from u_imb_tb where " + x_cond + ;
                                                    " order by imb_codice"
        ENDIF
ENDCASE