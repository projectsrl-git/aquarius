PARAMETERS V_SEEK

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   
   CASE V_SCELTA=1          				&& ACCESSO CODICE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_age = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_lg where " + x_cond + ;
                                                    " order by lis_codsoc,lis_age,lis_tipo" 
        ELSE
           x_codi = "lis_age = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_lg where " + x_cond + ;
                                                 " order by lis_codsoc,lis_age,lis_tipo" 
          
   CASE V_SCELTA=2          				&& ACCESSO CODICE LINEA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_linart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_lg where " + x_cond + ;
                                                    " order by lis_codsoc,lis_linart,lis_tipo" 
        ELSE
           x_codi = "lis_linart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_lg where " + x_cond + ;
                                                 " order by lis_codsoc,lis_linart,lis_tipo" 
   
   CASE V_SCELTA=3          				&& ACCESSO CODICE ZONA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_zona = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_lg where " + x_cond + ;
                                                    " order by lis_codsoc,lis_zona,lis_tipo" 
        ELSE
           x_codi = "lis_zona = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_lg where " + x_cond + ;
                                                 " order by lis_codsoc,lis_zona,lis_tipo" 
  
   CASE V_SCELTA=4          				&& ACCESSO CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 	          IF SUBSTR(V_SEEK,1,1)  <  "A"
		         V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	          ENDIF
              x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_lg where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codcli,lis_tipo" 
        ELSE
           IF SUBSTR(V_SEEK,1,1)  <  "A"
	          V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	       ENDIF
           x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_lg where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codcli,lis_tipo" 

ENDCASE

      