PARAMETERS V_SEEK

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE ARTICOLO 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_codart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_ve where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codart,lis_tipo" 
        ELSE
           x_codi = "lis_codart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_ve where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codart,lis_tipo" 

   CASE V_SCELTA=2          				&& ACCESSO CODICE TIPO LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_tipo = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lis_ve where " + x_cond + ;
                                                    " order by lis_codsoc,lis_tipo,lis_codart" 
        ELSE
           x_codi = "lis_tipo = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lis_ve where " + x_cond + ;
                                                 " order by lis_codsoc,lis_tipo,lis_codart" 

ENDCASE