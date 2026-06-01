PARAMETERS V_SEEK

x_soci = "1 = 1"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER ID TIME SHEET
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "IDTimeSht = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from timesht where " + x_cond + ;
                                                      " order by IDTimeSht,D_Data,IDRisUmana" 
        ELSE
           x_tipo = "IDTimeSht = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from timesht where " + x_cond + ;
                                                   " order by IDTimeSht,D_Data,IDRisUmana" 
                                                   
   CASE V_SCELTA=2                          && ACCESSO PER ID RISORSA UMANA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "IDRisUmana = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from timesht where " + x_cond + ;
                                                      " order by IDRisUmana,D_Data" 
        ELSE
           x_tipo = "IDRisUmana = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from timesht where " + x_cond + ;
                                                   " order by IDRisUmana,D_Data" 
                                                   
   CASE V_SCELTA=3                          && ACCESSO PER DATA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "D_Data = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from timesht where " + x_cond + ;
                                                      " order by D_Data,IDRisUmana"
        ELSE
           x_tipo = "D_Data = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from timesht where " + x_cond + ;
                                                   " order by D_Data,IDRisUmana"
                                                   
   CASE V_SCELTA=4                          && ACCESSO PER FLAG FATTURATO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = IIF(ALLTRIM(V_SEEK) = "SI","FlgFatt = 1",IIF(ALLTRIM(V_SEEK) = "NO","FlgFatt = 0","FlgFatt = FlgFatt"))
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from timesht where " + x_cond + ;
                                                      " order by FlgFatt,D_Data,IDRisUmana" 
        ELSE
           x_tipo = IIF(ALLTRIM(V_SEEK) = "SI","FlgFatt = 1",IIF(ALLTRIM(V_SEEK) = "NO","FlgFatt = 0","FlgFatt = FlgFatt"))
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from timesht where " + x_cond + ;
                                                   " order by FlgFatt,D_Data,IDRisUmana" 
                                                   
ENDCASE
