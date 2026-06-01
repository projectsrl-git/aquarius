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
           _ii_cSql   = "select * from u_prv_cl where " + x_cond + ;
                                                      " order by prv_codsoc,prv_codage,prv_codcli" 
        ELSE
           x_age = "prv_codage = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_age
        ENDIF
        _ii_cSql   = "select * from u_prv_cl where " + x_cond + ;
                                                   " order by prv_codsoc,prv_codage" 

   CASE V_SCELTA=2          				&& ACCESSO PER CODICE CLIENTE
         IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 		      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_clie = "prv_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
           _ii_cSql   = "select * from u_prv_cl where " + x_cond + ;
                                                      " order by prv_codsoc,prv_codage,prv_codcli"
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_clie = "prv_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = "select * from u_prv_cl where " + x_cond + ;
                                                   " order by prv_codsoc,prv_codage,prv_codcli"

 
    CASE V_SCELTA=3                          && ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "prv_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_prv_cl where " + x_cond + ;
                                                      " order by prv_codsoc,prv_ragsoc" 
        ELSE
           x_rags = "cli_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_prv_cl where " + x_cond + ;
                                                   " order by prv_codsoc,prv_ragsoc" 

 ENDCASE


