PARAMETERS V_SEEK

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 	          IF SUBSTR(V_SEEK,1,1)  <  "A"
		         V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	          ENDIF
              x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_tt where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codcli,lis_codart" 
        ELSE
           IF SUBSTR(V_SEEK,1,1)  <  "A"
	          V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	       ENDIF
           x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_tt where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codcli,lis_codart" 

   CASE V_SCELTA=2          				&& ACCESSO RAGIONE SOCIALE
   
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "lis_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_lis_tt where " + x_cond + ;
                                                      " order by lis_codsoc,lis_ragsoc,lis_codart" 
        ELSE
           x_rags = "lis_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_lis_tt where " + x_cond + ;
                                                   " order by lis_codsoc,lis_ragsoc,lis_codart" 
   
   	  	
   CASE V_SCELTA=3                          && ACCESSO PER CODICE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_codart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_tt where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codart,lis_codcli" 
        ELSE
           x_codi = "lis_codart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_tt where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codart,lis_codcli" 

   CASE V_SCELTA=4          				&& ACCESSO PER DATA LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_lis_tt where " + x_cond + ;
                                                      " order by lis_codsoc,lis_datlis,lis_codcli,lis_codart" 
        ELSE
           x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_lis_tt where " + x_cond + ;
                                                   " order by lis_codsoc,lis_datlis,lis_codcli,lis_codart"
                                                   
   **=> ERASMO - INIZIO 17/02/2015
   CASE V_SCELTA=5          				&& ACCESSO PER TIPOLOGIA LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "lis_codgli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_lis_tt where " + x_cond + ;
                                                      " order by lis_codsoc,lis_codgli,lis_datlis,lis_codcli,lis_codart" 
        ELSE
           x_data = "lis_codgli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_lis_tt where " + x_cond + ;
                                                   " order by lis_codsoc,lis_codgli,lis_datlis,lis_codcli,lis_codart" 
   **=> ERASMO - FINE 17/02/2015
   
ENDCASE