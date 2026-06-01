PARAMETERS V_SEEK

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE C.COSTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "con_conto = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql   = "select * from ccosto where " + x_cond + ;
                                                    " order by con_soc,con_anno,con_conto" 
        ELSE
           x_codi = "con_conto = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql   = "select * from ccosto where " + x_cond + ;
                                                 " order by con_soc,con_anno,con_conto" 

   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "con_descr like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
           _ii_cSql   = "select * from ccosto where " + x_cond + ;
                                                    " order by con_soc,con_anno,con_descr" 
        ELSE
           x_desc = "con_descr like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql   = "select * from ccosto where " + x_cond + ;
                                                 " order by con_soc,con_anno,con_descr" 

ENDCASE