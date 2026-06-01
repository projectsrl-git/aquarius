PARAMETERS V_SEEK

IF DOC_ANNO
   x_anno = "bud_anno = '" + PUB_ANNO + "'"
   x_cond = x_anno
ELSE
   x_cond = "1=1"
ENDIF

DO CASE

   CASE V_SCELTA = 1                          && ACCESSO PER CODICE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "bud_codart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_bud_am where " + x_cond + ;
                                                    " order by bud_codart,bud_anno,bud_mese" 
        ELSE
           x_codi   = "bud_codart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_bud_am where " + x_cond + ;
                                                 " order by bud_codart,bud_anno,bud_mese" 
 		
   CASE V_SCELTA = 2          				&& ACCESSO PER ANNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "bud_anno = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_bud_am where " + x_cond + ;
                                                    " order by bud_anno,bud_mese,bud_codart" 
        ELSE
           x_codi = "bud_anno = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_bud_am where " + x_cond + ;
                                                 " order by bud_anno,bud_mese,bud_codart" 
                                                 
   CASE V_SCELTA = 3          				&& ACCESSO PER MESE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "bud_mese = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_bud_am where " + x_cond + ;
                                                    " order by bud_anno,bud_mese,bud_codart" 
        ELSE
           x_codi = "bud_mese = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_bud_am where " + x_cond + ;
                                                 " order by bud_anno,bud_mese,bud_codart"                                                  
ENDCASE

