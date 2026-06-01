PARAMETERS V_SEEK

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 	          IF SUBSTR(V_SEEK,1,1)  <  "A"
		         V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	          ENDIF
              x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lif_sc where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codcli,lis_codlis" 
        ELSE
           IF SUBSTR(V_SEEK,1,1)  <  "A"
	          V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	       ENDIF
           x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lif_sc where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codcli,lis_codlis" 
		  	
   CASE V_SCELTA=2                          && ACCESSO PER CODICE LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_codlis = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lif_sc where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codlis,lis_codcli" 
        ELSE
           x_codi = "lis_codlis = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lif_sc where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codlis,lis_codcli" 
		  	

   CASE V_SCELTA=3          				&& ACCESSO PER DATA LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_lif_sc where " + x_cond + ;
                                                      " order by lis_codsoc,lis_datlis,lis_codcli,lis_codlis" 
        ELSE
           x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_lif_sc where " + x_cond + ;
                                                   " order by lis_codsoc,lis_datlis,lis_codcli,lis_codlis" 

ENDCASE