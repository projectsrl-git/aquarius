
PARAMETERS V_SEEK

x_cond = "cal_codsoc = '" + PUB_CODSOC + "'"

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER PUNTO DI VENDITA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cal_codpdv like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cal_codpdv like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cal_as where " + x_cond + ;
                                                 " order by cal_codsoc,cal_codpdv,cal_codcol,cal_datass" 

   CASE V_SCELTA=2          				&& ACCESSO PER CODICE COLLABORATORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cal_codcol like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cal_codcol like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cal_as where " + x_cond + ;
                                                 " order by cal_codsoc,cal_codcol,cal_codpdv,cal_datass" 

   CASE V_SCELTA=3          				&& ACCESSO PER RAGIONE SOCIALE COLLABORATORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cal_descol like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cal_descol like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cal_as where " + x_cond + ;
                                                 " order by cal_codsoc,cal_descol,cal_codpdv,cal_datass" 

   CASE V_SCELTA=4          				&& ACCESSO PER DATA ASSENZA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cal_datass = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cal_datass = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cal_as where " + x_cond + ;
                                                 " order by cal_codsoc,cal_datass,cal_codpdv,cal_codcol" 

ENDCASE
