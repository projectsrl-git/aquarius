PARAMETERS V_SEEK
       
x_cond="1=1"
DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER MATRICOLA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "gpe_matri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "gpe_matri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_gpe_an where " + x_cond + ;
                                                 " order by gpe_matri,gpe_cognom" 
 		
   CASE V_SCELTA=2          				&& ACCESSO PER COGNOME
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "gpe_cognom like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "gpe_cognom like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select * from u_gpe_an where " + x_cond + ;
                                                 " order by gpe_matri,gpe_cognom" 
   
   CASE V_SCELTA=3          				&& ACCESSO PER LOCALITA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "gpe_local like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
        ELSE
           x_loca = "gpe_local like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql = "select * from u_gpe_an where " + x_cond + ;
                                                 " order by gpe_matri,gpe_cognom" 

   CASE V_SCELTA=4          				&& ACCESSO PER BANCA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "gpe_banca like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
        ELSE
           x_loca = "gpe_banca like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql = "select * from u_gpe_an where " + x_cond + ;
                                                 " order by gpe_matri,gpe_cognom" 

   CASE V_SCELTA=5          				&& ACCESSO PER DATA ASSUNZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "gpe_dtass = '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
        ELSE
           x_loca = "gpe_dtass = '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql = "select * from u_gpe_an where " + x_cond + ;
                                                 " order by gpe_matri,gpe_cognom" 	   
                                                 
    CASE V_SCELTA=6         				&& ACCESSO PER DATA CESSAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "gpe_dtces = '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
        ELSE
           x_loca = "gpe_dtces = '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql = "select * from u_gpe_an where " + x_cond + ;
                                                 " order by gpe_matri,gpe_cognom" 	   
                                                                                   
ENDCASE
