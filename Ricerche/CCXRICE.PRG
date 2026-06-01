PARAMETERS V_SEEK


x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + PUB_ANNO + "'"
x_cond = x_soci 

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER CONTO CORRENTE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_codcco like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_ordcco" 
        ELSE
           x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_codcco" 

   CASE V_SCELTA=2                          && ACCESSO PER DATA APERTURA
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "ord_datape = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_datape,ord_numcon" 
        ELSE
           x_data = "ord_datape = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_datape,ord_numcon" 

   CASE V_SCELTA=3          				&& ACCESSO PER primo coentestatario

        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_1cogno like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_ordcco" 
        ELSE
           x_rags = "ord_1cogno like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_codcco" 
   CASE V_SCELTA=4          				&& ACCESSO PER primo coentestatario
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_2cogno like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_ordcco" 
        ELSE
           x_rags = "ord_2cogno like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_codcco" 
   CASE V_SCELTA=5          				&& ACCESSO PER primo coentestatario
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_3cogno like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_ordcco" 
        ELSE
           x_rags = "ord_3cogno like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_cco_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_ordcco" 



ENDCASE

RETURN

