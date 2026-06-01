PARAMETERS V_SEEK

x_soci = "not_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "not_codice like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "not_codice like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
           _ii_cSql = "select substring(not_testo,1,254) as not_testo_c, * from note_com where " + x_cond + " order by not_codice"
        ENDIF
        _ii_cSql = "select substring(not_testo,1,254) as not_testo_c, * from note_com where " + x_cond + " order by not_codice"
        
   CASE V_SCELTA=2                          && ACCESSO DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "substring(not_testo,1,8000) like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "substring(not_testo,1,8000) like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
           _ii_cSql = "select substring(not_testo,1,254) as not_testo_c, * from note_com where " + x_cond + " order by not_codice"
        ENDIF
        _ii_cSql = "select substring(not_testo,1,254) as not_testo_c, * from note_com where " + x_cond + " order by not_codice"
        
ENDCASE