PARAMETERS V_SEEK



x_soci = "1 = 1"
x_anno = "SUBSTRING(TUR_DATINI,1,4) = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

_XX_SELECT = "SELECT (SUBSTRING(TUR_DATINI,9,2) + '/' + SUBSTRING(TUR_DATINI,6,2) + '/' + SUBSTRING(TUR_DATINI,1,4)) AS DATINI, " + ;
             "(SUBSTRING(TUR_DATFIN,9,2) + '/' + SUBSTRING(TUR_DATFIN,6,2) + '/' + SUBSTRING(TUR_DATFIN,1,4)) AS DATFIN,* from turni_tt where "

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE TURNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(3,V_SEEK)
              x_tipo = "TUR_CODICE = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _XX_SELECT + x_cond + " order by TUR_CODICE,TUR_DATINI DESC"
        ELSE
           V_SEEK = TRC(3,V_SEEK)
           x_tipo = "TUR_CODICE = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _XX_SELECT + x_cond + " order by TUR_CODICE,TUR_DATINI DESC"


   CASE V_SCELTA=2                          && ACCESSO PER DATA INIZIO TURNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "TUR_DATINI = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _XX_SELECT + x_cond + " order by TUR_DATINI DESC"
        ELSE
           x_tipo = "TUR_DATINI = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _XX_SELECT + x_cond + " order by TUR_DATINI DESC"
        
        
   CASE V_SCELTA=3                          && ACCESSO PER DATA FINE TURNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "TUR_DATFIN = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _XX_SELECT + x_cond + " order by TUR_DATFIN DESC"
        ELSE
           x_tipo = "TUR_DATFIN = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _XX_SELECT + x_cond + " order by TUR_DATFIN DESC"        
                                                           
ENDCASE
