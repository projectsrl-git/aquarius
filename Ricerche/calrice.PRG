PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER ANNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              x_cond   = "1=1"
           ELSE
              x_codi   = "cal_anno = " + STR(VAL(ALLTRIM(V_SEEK)),4,0)
              x_cond   = x_codi
           ENDIF
        ELSE
           x_codi   = "cal_anno = " + STR(VAL(ALLTRIM(V_SEEK)),4,0)
           x_cond   = x_codi
        ENDIF
        _ii_cSql = "select * from u_cal_la where " + x_cond + ;
                                                 " order by cal_anno,cal_datamg" 

   CASE V_SCELTA=2          				&& ACCESSO PER DATA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              x_cond   = "1=1"
           ELSE
              x_codi   = "cal_datamg = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
              x_cond   = x_codi
           ENDIF
        ELSE
           x_codi   = "cal_datamg = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
           x_cond   = x_codi
        ENDIF
        _ii_cSql = "select * from u_cal_la where " + x_cond + ;
                                                 " order by cal_datamg" 

ENDCASE
