PARAMETERS V_SEEK

x_soci = "anno = '" + PUB_anno + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,3) = SPACE(03)
           ELSE
              x_codi = "codice = '" + ALLTRIM(v_seek) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from comm_group where " + x_cond + ;
                                                    " order by codice" 
        ELSE
           x_codi = "codice = '" + ALLTRIM(v_seek) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from comm_group where " + x_cond + ;
                                                 " order by codice" 
   
   CASE V_SCELTA=2                          && ACCESSO PER descrizione
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,3) = SPACE(03)
           ELSE
              x_codi = "descri like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from comm_group where " + x_cond + ;
                                                    " order by codice" 
        ELSE
           x_codi = "descri like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from comm_group where " + x_cond + ;
                                                 " order by codice" 

ENDCASE