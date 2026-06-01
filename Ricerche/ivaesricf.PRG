PARAMETERS V_SEEK

x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = " + PUB_ANNO
x_codf = "iva_desfor = '" + M.iva_desfor + "'"			 
x_cond = x_soci + " and " + x_anno + " and " + x_codf 

x_cond = x_soci

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER RAGIONE SOCIALE FORNITORE (CONTENUTO)


        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "iva_desfor like '%" + ALLTRIM(V_SEEK) + "%'"
              x_anno = "iva_anno = " + PUB_ANNO
              x_cond = x_cond + " and " + x_anno + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_iva_fe where " + x_cond + ;
                                                      " order by iva_codsoc,iva_anno,iva_desfor" 
        ELSE
           x_rags = "iva_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
           x_anno = "iva_anno = " + PUB_ANNO
           x_cond = x_cond + " and " + x_anno + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_iva_fe where " + x_cond + ;
                                                   " order by iva_codsoc,iva_anno,iva_desfor" 

       
ENDCASE