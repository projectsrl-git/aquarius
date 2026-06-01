PARAMETERS V_SEEK

x_soci = "vva_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nord   = "vva_codval = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select * from u_vva_ch where " + x_cond + ;
                                                    " order by vva_codsoc,vva_codval,vva_data" 
        ELSE
           x_nord   = "vva_codval = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_vva_ch where " + x_cond + ;
                                                 " order by vva_codsoc,vva_codval,vva_data" 

   CASE V_SCELTA=2                          && ACCESSO PER DATA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nord   = "vva_data = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select * from u_vva_ch where " + x_cond + ;
                                                    " order by vva_codsoc,vva_data,vva_codval" 
        ELSE
           x_nord   = "vva_data = '" + ALLTRIM(RIBALTA2(V_SEEK)) + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_vva_ch where " + x_cond + ;
                                                 " order by vva_codsoc,vva_data,vva_codval" 

ENDCASE