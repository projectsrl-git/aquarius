PARAMETERS V_SEEK

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1                          && ACCESSO PER CODICE LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_codlis = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lif_ba where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codlis" 
        ELSE
           x_codi = "lis_codlis = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lif_ba where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codlis" 
		  	
   CASE V_SCELTA=2                          && ACCESSO PER CODICE FAMIGLIA SCONTI/MAGGIORAZIONI
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_scomagg = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lif_ba where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codlis,lis_scomagg,lis_datlis" 
        ELSE
           x_codi = "lis_scomagg = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lif_ba where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codlis,lis_scomagg,lis_datlis" 

   CASE V_SCELTA=3          				&& ACCESSO PER DATA LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_lif_ba where " + x_cond + ;
                                                      " order by lis_codsoc,lis_datlis,lis_codlis" 
        ELSE
           x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_lif_ba where " + x_cond + ;
                                                   " order by lis_codsoc,lis_datlis,lis_codlis" 


   CASE V_SCELTA=4                          && ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "lis_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_lif_ba where " + x_cond + ;
                                                      " order by lis_ragsoc,lis_datlis,lis_codlis" 
        ELSE
           x_rags = "lis_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_lif_ba where " + x_cond + ;
                                                    " order by lis_ragsoc,lis_datlis,lis_codlis" 
                                                   
   CASE V_SCELTA=5                          && ACCESSO PER RAGIONE SOCIALE (TESTO CONTENUTO)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "lis_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_lif_ba where " + x_cond + ;
                                                       " order by lis_ragsoc,lis_datlis,lis_codlis" 
        ELSE
           x_rags = "lis_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_lif_ba where " + x_cond + ;
                                                    " order by lis_ragsoc,lis_datlis,lis_codlis" 




ENDCASE