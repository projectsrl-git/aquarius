PARAMETERS V_SEEK

x_soci = "PAR_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER CODICE
          
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "PAR_codspe like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "PAR_codice like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_PAR_my where " + x_cond + ;
                                                   " order by PAR_codspe" 
   
  
ENDCASE