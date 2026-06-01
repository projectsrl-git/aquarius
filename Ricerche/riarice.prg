PARAMETERS V_SEEK

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER NUMERO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              *x_nor6   = 6
              *x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              *x_nord   = "ord_numord = '" + x_nor0 + "'"
              x_nord   = "ord_numord = '" + ALLTRIM(V_SEEK) + "'"  && ERASMO - 04/12/2023
              x_cond   = x_cond + " and " + x_nord
           ENDIF
        ELSE
           *x_nor6   = 6
           *x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           *x_nord   = "ord_numord = '" + x_nor0 + "'"
           x_nord   = "ord_numord = '" + ALLTRIM(V_SEEK) + "'"  && ERASMO - 04/12/2023
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        *_ii_cSql = "select * from u_ria_tt where " + x_cond + ;
                                                 " order by ord_codsoc,ord_numord,ord_anno"
        _ii_cSql = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_ria_tt where " + x_cond + " order by ord_codsoc,ord_numord,ord_anno"  && ERASMO - 04/12/2023

   CASE V_SCELTA=2                          && ACCESSO PER DATA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        *_ii_cSql   = "select * from u_ria_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_datord,ord_numord"
        _ii_cSql = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_ria_tt where " + x_cond + " order by ord_codsoc,ord_numord,ord_anno"  && ERASMO - 04/12/2023

   CASE V_SCELTA=3          				&& ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        *_ii_cSql   = "select * from u_ria_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_ragsoc,ord_anno"
        _ii_cSql = "select dbo.ribalta2(ord_datord) as ord_datord_r, * from u_ria_tt where " + x_cond + " order by ord_codsoc,ord_numord,ord_anno"  && ERASMO - 04/12/2023
      
ENDCASE