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
        ELSE
           IF SUBSTR(V_SEEK,1,1)  <  "A"
	          V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	       ENDIF
           x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_li where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codcli,lis_linart,lis_codart" 
   
   **=> ERASMO - INIZIO 06/11/2017
   CASE V_SCELTA=2          				&& ACCESSO RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_coddes like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "lis_coddes like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_li where " + x_cond + ;
                                                 " order by lis_codsoc,lis_coddes,lis_linart,lis_codart"                
   **=> ERASMO - FINE 06/11/2017
		  	
   CASE V_SCELTA=3                          && ACCESSO PER CODICE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_linart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "lis_linart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_li where " + x_cond + ;
                                                 " order by lis_codsoc,lis_linart,lis_codart,lis_codcli" 


   CASE V_SCELTA=4                          && ACCESSO PER CODICE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_codart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "lis_codart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_li where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codart,lis_linart,lis_codcli" 

   CASE V_SCELTA=5          				&& ACCESSO PER DATA LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_lis_li where " + x_cond + ;
                                                   " order by lis_codsoc,lis_datlis,lis_codcli,lis_linart,lis_codart" 

ENDCASE