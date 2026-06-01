
PARAMETERS V_SEEK

x_cond = "1=1"

DO CASE

   CASE V_SCELTA = 1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_codces like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                    " order by amm_codces" 
        ELSE
           x_codi   = "amm_codces like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                 " order by amm_codces" 
 		
   CASE V_SCELTA = 2          				&& ACCESSO PER DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                    " order by amm_descri" 
        ELSE
           x_codi   = "amm_descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                 " order by amm_descri"
                                                 
   CASE V_SCELTA = 3          				&& ACCESSO PER CATEGORIA DI APPARTENENZA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_codcat like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                    " order by amm_codcat" 
        ELSE
           x_codi   = "amm_codcat like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                 " order by amm_codcat" 
                                                 
   CASE V_SCELTA = 4          				&& ACCESSO PER TIPO CATEGORIA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_tipcat like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                    " order by amm_tipcat" 
        ELSE
           x_codi   = "amm_tipcat like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                 " order by amm_tipcat" 
                                                 
   CASE V_SCELTA = 5          				&& ACCESSO PER FLAG NUOVO/USATO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_flgnew like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                    " order by amm_flgnew" 
        ELSE
           x_codi   = "amm_flgnew like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_at where " + x_cond + ;
                                                 " order by amm_flgnew"                                             
ENDCASE



