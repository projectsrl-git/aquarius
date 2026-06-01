PARAMETERS V_SEEK

x_soci   = "cam_soc = '" + PUB_CODSOC + "'"



* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

x_cond	 = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,6) = SPACE(06)
           ELSE
              x_categ = "cam_categ like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_categ
           ENDIF
           _ii_cSql   = "select * from u_cam_an where " + x_cond + ;
                                                      " order by cam_soc,cam_categ" 
        ELSE
           x_categ = "cam_categ like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_categ
        ENDIF
        _ii_cSql   = "select * from u_cam_an where " + x_cond + ;
                                                   " order by cam_soc,cam_categ" 
   
   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,40) = SPACE(40)
           ELSE
 		      x_descr = "cam_descr like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_descr
           ENDIF
           _ii_cSql   = "select * from u_cam_an where " + x_cond + ;
                                                      " order by cam_soc,cam_categ"
        ELSE
           x_descr = "cam_descr like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_descr
        ENDIF
        _ii_cSql   = "select * from u_cam_an where " + x_cond + ;
                                                   " order by cam_soc,cam_categ"
                                                    
	   CASE V_SCELTA=3          				&& ACCESSO contropartita contabile
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,13) = SPACE(13)
           ELSE
 		      x_descr = "cam_contr like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_descr
           ENDIF
           _ii_cSql   = "select * from u_cam_an where " + x_cond + ;
                                                      " order by cam_soc,cam_categ"
        ELSE
           x_descr = "cam_contr like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_descr
        ENDIF
        _ii_cSql   = "select * from u_cam_an where " + x_cond + ;
                                                   " order by cam_soc,cam_categ"
      
ENDCASE




