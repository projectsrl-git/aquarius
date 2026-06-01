PARAMETERS V_SEEK

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO PER CODICE
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           _ii_cSql = "select * from u_azi_an order by azi_codsoc" 
        ELSE
           x_cond   = "azi_codsoc = '" + PUB_CODSOC + "'"
           _ii_cSql = "select * from u_azi_an where " + x_cond + " order by azi_codsoc" 
        ENDIF

ENDCASE