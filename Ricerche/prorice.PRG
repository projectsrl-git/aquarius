PARAMETERS V_SEEK

x_soci = "pro_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO PER CODICE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "pro_codage = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_pro_an where " + x_cond + ;
                                                    " order by pro_codsoc,pro_codage" 
        ELSE
           x_codi = "pro_codage = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_pro_an where " + x_cond + ;
                                                 " order by pro_codsoc,pro_codage" 

   CASE V_SCELTA=2          				&& ACCESSO PER RAGIONE SOCIALE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "pro_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_pro_an where " + x_cond + ;
                                                    " order by pro_codsoc,pro_ragsoc" 
        ELSE
           x_codi = "pro_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_pro_an where " + x_cond + ;
                                                 " order by pro_codsoc,pro_ragsoc" 

ENDCASE


