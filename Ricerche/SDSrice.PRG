PARAMETERS V_SEEK

x_soci = "sds_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "Sds_codice like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "Sds_codice like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from schede_sds where " + x_cond + " order by sds_codsoc,sds_codice,sds_version"
        
   CASE V_SCELTA=2          				&& ACCESSO PER DESCRIZIONE SCHEDA SICUREZZA (CONTIENE)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "sds_descsds like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "sds_descsds like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from schede_sds where " + x_cond + " order by sds_codsoc,sds_codice,sds_version" 
   			
   CASE V_SCELTA=3                          && ACCESSO PER DATA SCADENZA

       IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "sds_datasds = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "sds_datasds = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql = "select * from schede_sds where " + x_cond + " order by sds_codsoc,sds_codice,sds_version" 


		  	
   
ENDCASE