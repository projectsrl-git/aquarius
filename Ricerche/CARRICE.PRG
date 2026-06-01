PARAMETERS V_SEEK

x_soci = "prv_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO PER CODICE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_age = "prv_codage = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_age
           ENDIF
           _ii_cSql   = "select * from u_car_an where " + x_cond + ;
                                                      " order by prv_codsoc,prv_codage" 
        ELSE
           x_age = "prv_codage = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_age
        ENDIF
        _ii_cSql   = "select * from u_car_an where " + x_cond + ;
                                                   " order by prv_codsoc,prv_codage" 

   CASE V_SCELTA=2          				&& ACCESSO PER CODICE CAPO AREA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "prv_codcar = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql   = "select * from u_car_an where " + x_cond + ;
                                                      " order by prv_codsoc,prv_codcar" 
        ELSE
           x_codi = "prv_codcar = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql   = "select * from u_car_an where " + x_cond + ;
                                                   " order by prv_codsoc,prv_codcar" 
ENDCASE


