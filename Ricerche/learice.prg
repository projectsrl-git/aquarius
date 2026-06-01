PARAMETERS V_SEEK

x_soci = "lea_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER NUMERO
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nor6   = 6
              x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              x_nord   = "lea_numcon = '" + x_nor0 + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "lea_numcon = '" + x_nor0 + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_lea_tt where " + x_cond + ;
                                                 " order by lea_codsoc,lea_numcon" 

   CASE V_SCELTA=2                          && ACCESSO PER DATA
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "lea_datcon = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "lea_datcon = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_lea_tt where " + x_cond + ;
                                                   " order by lea_codsoc,lea_datcon,lea_numcon" 

   CASE V_SCELTA=3          				&& ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "lea_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "lea_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_lea_tt where " + x_cond + ;
                                                   " order by lea_codsoc,lea_ragsoc" 
   CASE V_SCELTA=4          				&& ACCESSO PER CODICE PDV
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cage = "lea_codpdv = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_cage
           ENDIF
        ELSE
           x_cage = "lea_codpdv = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_cage
        ENDIF
        _ii_cSql   = "select * from u_lea_tt where " + x_cond + ;
                                                   " order by lea_codsoc,lea_codpdv,ord_datcon" 
	  	
   CASE V_SCELTA=5          				&& ACCESSO PER CODICE CLIENTE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_clie = "lea_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
        ELSE
 	       V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_clie = "lea_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = "select * from u_lea_tt where " + x_cond + ;
                                                   " order by lea_codsoc,lea_codcli,lea_datcon" 
       
ENDCASE