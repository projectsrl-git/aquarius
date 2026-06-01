PARAMETERS V_SEEK

x_soci = "xls_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "xls_codice like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE       
           x_codi   = "xls_codice like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_xls_tt where " + x_cond + ;
                                                 " order by xls_codsoc,xls_codice" 
 		
   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "xls_descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "xls_descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select * from u_xls_tt where " + x_cond + ;
                                                 " order by xls_codsoc,xls_descri" 
ENDCASE

RETURN
