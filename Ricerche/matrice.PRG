
PARAMETERS V_SEEK

x_cond = "cas_matric = cas_matric"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER CODICE MATRICOLA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cas_matric like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
           ENDIF
        ELSE
           x_codi   = "cas_matric like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi
        ENDIF
        _ii_cSql = "select * from u_cas_an where " + x_cond + ;
                                                 " order by cas_matric,cas_cognom,cas_nome"
                                                 
   CASE V_SCELTA=2                         && ACCESSO PER COGNOME
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cas_cognom like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
           ENDIF
        ELSE
           x_codi   = "cas_cognom like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi
        ENDIF
        _ii_cSql = "select * from u_cas_an where " + x_cond + ;
                                                 " order by cas_cognom,cas_nome,cas_matric"
                                                 
   CASE V_SCELTA=3                         && ACCESSO PER NOME
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cas_nome like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
           ENDIF
        ELSE
           x_codi   = "cas_nome like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi
        ENDIF
        _ii_cSql = "select * from u_cas_an where " + x_cond + ;
                                                 " order by cas_nome,cas_cognom,cas_matric"                                                        
   
ENDCASE
