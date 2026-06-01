PARAMETERS V_SEEK

x_soci = "loc_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

*!*	   *CASE V_SCELTA=1                          && ACCESSO PER CODICE LOCALITA'
*!*	   && ERASMO - 09/02/2012
*!*	   CASE V_SCELTA=3                          && ACCESSO PER CODICE LOCALITA'
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	              x_codi = "loc_codloc = '" + ALLTRIM(V_SEEK) + "'"
*!*	              x_cond = x_cond + " and " + x_codi
*!*	           ENDIF
*!*	           _ii_cSql = "select * from u_loc_an where " + x_cond + ;
*!*	                                                    " order by loc_codsoc,loc_codloc,loc_codcli" 
*!*	        ELSE
*!*	           x_codi = "loc_codloc = '" + ALLTRIM(V_SEEK) + "'"
*!*	           x_cond = x_cond + " and " + x_codi
*!*	        ENDIF
*!*	        _ii_cSql = "select * from u_loc_an where " + x_cond + ;
*!*	                                                 " order by loc_codsoc,loc_codloc,loc_codcli" 
*!*				
*!*	   CASE V_SCELTA=2                          && ACCESSO PER CODICE CLIENTE
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	 	          IF SUBSTR(V_SEEK,1,1)  <  "A"
*!*			         V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
*!*		          ENDIF
*!*	              x_codi = "loc_codcli = '" + ALLTRIM(V_SEEK) + "'"
*!*	              x_cond = x_cond + " and " + x_codi
*!*	           ENDIF
*!*	           _ii_cSql = "select * from u_loc_an where " + x_cond + ;
*!*	                                                    " order by loc_codsoc,loc_codcli,loc_codloc" 
*!*	        ELSE
*!*	           IF SUBSTR(V_SEEK,1,1)  <  "A"
*!*		          V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
*!*		       ENDIF
*!*	           x_codi = "loc_codcli = '" + ALLTRIM(V_SEEK) + "'"
*!*	           x_cond = x_cond + " and " + x_codi
*!*	        ENDIF
*!*	        _ii_cSql = "select * from u_loc_an where " + x_cond + ;
*!*	                                                 " order by loc_codsoc,loc_codcli,loc_codloc" 
*!*			  	
*!*	   *CASE V_SCELTA=3          				&& ACCESSO PER RAGIONE SOCIALE
*!*	   && ERASMO - 09/02/2012
*!*	   CASE V_SCELTA=1          				&& ACCESSO PER RAGIONE SOCIALE
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	              x_codi = "loc_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
*!*	              x_cond = x_cond + " and " + x_codi
*!*	           ENDIF
*!*	           _ii_cSql = "select * from u_loc_an where " + x_cond + ;
*!*	                                                    " order by loc_codsoc,loc_ragsoc,loc_codloc" 
*!*	        ELSE
*!*	           x_codi = "loc_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
*!*	           x_cond = x_cond + " and " + x_codi
*!*	        ENDIF
*!*	        _ii_cSql = "select * from u_loc_an where " + x_cond + ;
*!*	                                                 " order by loc_codsoc,loc_ragsoc,loc_codloc"

   **=> ERASMO - INIZIO 13/10/2015
   CASE V_SCELTA=1          				&& ACCESSO PER RAGIONE SOCIALE (INIZIA PER)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "loc_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "loc_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_loc_an where " + x_cond + " order by loc_codsoc,loc_ragsoc,loc_codloc"
        
   CASE V_SCELTA=2          				&& ACCESSO PER RAGIONE SOCIALE (CONTIENE)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "loc_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "loc_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_loc_an where " + x_cond + " order by loc_codsoc,loc_ragsoc,loc_codloc" 
   			
   CASE V_SCELTA=3                          && ACCESSO PER CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 	          IF SUBSTR(V_SEEK,1,1)  <  "A"
		         V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	          ENDIF
              x_codi = "loc_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           IF SUBSTR(V_SEEK,1,1)  <  "A"
	          V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	       ENDIF
           x_codi = "loc_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_loc_an where " + x_cond + " order by loc_codsoc,loc_codcli,loc_codloc" 
		  	
   CASE V_SCELTA=4                          && ACCESSO PER CODICE LOCALITA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "loc_codloc = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "loc_codloc = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_loc_an where " + x_cond + " order by loc_codsoc,loc_codloc,loc_codcli" 
   **=> ERASMO - FINE 13/10/2015
   
ENDCASE