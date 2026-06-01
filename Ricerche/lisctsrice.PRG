PARAMETERS V_SEEK


x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE GREZZO/NOBILITATO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_flaggn = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                    " order by lis_flaggn,lis_spesso,lis_codcli" 
        ELSE
           x_codi = "lis_flaggn = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                 " order by lis_flaggn,lis_spesso,lis_codcli" 



   CASE V_SCELTA=2          				&& ACCESSO CODICE TIPO PRODOTTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_tipopr = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                    " order by lis_tipopr,lis_spesso,lis_codcli" 
        ELSE
           x_codi = "lis_tipopr = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                 " order by lis_tipopr,lis_spesso,lis_codcli" 

   CASE V_SCELTA=3          				&& ACCESSO CODICE COLORE FRONTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "LIS_GRCOLF = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                    " order by lis_tipopr,LIS_GRCOLF,lis_spesso,lis_codcli" 
        ELSE
           x_codi = "LIS_GRCOLF = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                 " order by lis_tipopr,LIS_GRCOLF,lis_spesso,lis_codcli" 


   CASE V_SCELTA=4          				&& ACCESSO CODICE COLORE RETRO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "LIS_GRCOLR = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                    " order by lis_tipopr,LIS_GRCOLR,lis_spesso,lis_codcli" 
        ELSE
           x_codi = "LIS_GRCOLR = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                 " order by lis_tipopr,LIS_GRCOLR,lis_spesso,lis_codcli" 



   CASE V_SCELTA=5          				&& ACCESSO CODICE CLIENTE 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 	          IF SUBSTR(V_SEEK,1,1)  <  "A"
		         V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	          ENDIF
              x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codcli" 
        ELSE
           IF SUBSTR(V_SEEK,1,1)  <  "A"
		      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	       ENDIF

           x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_ts where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codcli" 

   CASE V_SCELTA=6          				&& ACCESSO RAGIONE SOCIALE
 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "lis_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_lis_ts where " + x_cond + ;
                                                      " order by lis_codsoc,lis_ragsoc" 
        ELSE
           x_rags = "lis_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_lis_ts where " + x_cond + ;
                                                   " order by lis_codsoc,lis_ragsoc" 


ENDCASE