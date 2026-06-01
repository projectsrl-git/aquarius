PARAMETERS V_SEEK
          
x_cond="1=1"
DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER MATRICOLA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "gpp_matri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "gpp_matri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_gpp_mo where " + x_cond + ;
                                                 " order by gpp_matri,gpp_cognom" 
 		
   CASE V_SCELTA=2          				&& ACCESSO PER COGNOME
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "gpp_cognom like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "gpp_cognom like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select * from u_gpp_mo where " + x_cond + ;
                                                 " order by gpp_matri,gpp_cognom" 
   
   CASE V_SCELTA=3          				&& ACCESSO PER ANNO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "gpp_anno like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
        ELSE
           x_loca = "gpp_anno like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql = "select * from u_gpp_mo where " + x_cond + ;
                                                 " order by gpp_matri,gpp_cognom" 

   CASE V_SCELTA=4          				&& ACCESSO PER MESE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "gpp_mese like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
        ELSE
           x_loca = "gpp_mese like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql = "select * from u_gpp_mo where " + x_cond + ;
                                                 " order by gpp_matri,gpp_cognom" 

ENDCASE
