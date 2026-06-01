PARAMETERS V_SEEK

x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = " + PUB_ANNO
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER ANNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              IF DOC_ANNO
              ELSE
                 x_anno = "iva_anno = " + ALLTRIM(V_SEEK)
                 x_cond   = x_cond + " and " + x_anno
              ENDIF
           ENDIF
           _ii_cSql = "select * from u_iva_cr where " + x_cond + ;
                                                    " order by iva_codsoc,iva_anno" 
        ELSE
           IF DOC_ANNO
           ELSE
              x_anno = "iva_anno = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_anno
           ENDIF
        ENDIF
        _ii_cSql = "select * from u_iva_cr where " + x_cond + ;
                                                 " order by iva_codsoc,iva_anno" 

       
ENDCASE