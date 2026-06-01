PARAMETERS V_SEEK

x_soci = "SCO_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 	          IF SUBSTR(V_SEEK,1,1)  <  "A"
		         V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	          ENDIF
              x_codi = "SCO_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_sco_cm where " + x_cond + ;
                                                    " order by SCO_codsoc,SCO_codcli,SCO_CATMER" 
        ELSE
           IF SUBSTR(V_SEEK,1,1)  <  "A"
	          V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	       ENDIF
           x_codi = "SCO_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_sco_cm where " + x_cond + ;
                                                 " order by SCO_codsoc,SCO_codcli,SCO_CATMER" 

   CASE V_SCELTA=2          				&& ACCESSO RAGIONE SOCIALE
   
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "SCO_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_sco_cm where " + x_cond + ;
                                                      " order by SCO_codsoc,SCO_ragsoc,SCO_CATMER" 
        ELSE
           x_rags = "SCO_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_sco_cm where " + x_cond + ;
                                                   " order by SCO_codsoc,SCO_ragsoc,SCO_CATMER" 
   
   	  	
   CASE V_SCELTA=3                          && ACCESSO PER CATEGORIA MERCEOLOGICA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "SCO_CATMER = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_sco_cm where " + x_cond + ;
                                                    " order by SCO_codsoc,SCO_CATMER,SCO_codcli" 
        ELSE
           x_codi = "SCO_CATMER = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_sco_cm where " + x_cond + ;
                                                 " order by SCO_codsoc,SCO_CATMER,SCO_codcli" 

   CASE V_SCELTA=4          				&& ACCESSO PER DATA LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "SCO_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_sco_cm where " + x_cond + ;
                                                      " order by SCO_codsoc,SCO_datlis,SCO_codcli,SCO_CATMER" 
        ELSE
           x_data = "SCO_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_sco_cm where " + x_cond + ;
                                                   " order by SCO_codsoc,SCO_datlis,SCO_codcli,SCO_CATMER" 

ENDCASE