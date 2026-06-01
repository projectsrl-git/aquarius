PARAMETERS V_SEEK

x_soci   = "fid_codsoc = '" + PUB_CODSOC + "'"
_x_cond	 = " and fid_codsoc = '" + PUB_CODSOC + "'"

x_cond	 = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "fid_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "fid_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_cli_fi where " + x_cond + ;
                                                   " order by fid_codsoc,fid_ragsoc" 
   
   CASE V_SCELTA=2          				&& ACCESSO CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 		      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_clie = "fid_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_clie = "fid_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = "select * from u_cli_fi where " + x_cond + ;
                                                   " order by fid_codsoc,fid_codcli"
                                                       
       
ENDCASE

RETURN


