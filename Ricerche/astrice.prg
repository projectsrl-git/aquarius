PARAMETERS V_SEEK

x_cond   = "ast_codsoc = '" + PUB_CODSOC + "'"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER NUMERO SCATOLA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "ast_numsca = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "ast_numsca = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_ast_an where " + x_cond + ;
                                                 " order by ast_numsca,ast_datsca" 
   
ENDCASE
