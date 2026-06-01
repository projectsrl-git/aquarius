PARAMETERS V_SEEK

* -->> DF 
*V_SCELTA=VAL(V_SCELTA)
* -->> DF 

x_soci = "bud_codsoc = '" + PUB_CODSOC + "'"
x_anno = "bud_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE GRUPPO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "bud_codgru = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_bud_an where " + x_cond + ;
                                                    " order by bud_codsoc,bud_codgru" 
        ELSE
           x_codi   = "bud_codgru = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_bud_an where " + x_cond + ;
                                                 " order by bud_codsoc,bud_codgru" 
 		
   CASE V_SCELTA=2          				&& ACCESSO DENOMINAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "bud_desgru like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
           _ii_cSql = "select * from u_bud_an where " + x_cond + ;
                                                    " order by bud_codsoc,bud_desgru" 
        ELSE
           x_desc = "bud_desgru like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select * from u_bud_an where " + x_cond + ;
                                                 " order by bud_codsoc,bud_desgru"    
ENDCASE

* -->> DF 
*V_SCELTA=ALLTRIM(STR(V_SCELTA))
* -->> DF