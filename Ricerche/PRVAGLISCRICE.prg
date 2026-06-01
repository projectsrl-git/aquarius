PARAMETERS V_SEEK

x_soci = "PRV_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE
   CASE V_SCELTA=1                          && ACCESSO PER CODICE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "PRV_CODAGE = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "PRV_CODAGE = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from U_PRV_AL where " + x_cond + ;
                                                 " order by PRV_codsoc,PRV_CODAGE,PRV_CODLIN,PRV_SCO_DA" 


   CASE V_SCELTA=2                          && ACCESSO PER CODICE LINEA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "PRV_CODLIN = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "PRV_CODLIN = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from U_PRV_AL where " + x_cond + ;
                                                 " order by PRV_codsoc,PRV_CODLIN,PRV_CODAGE,PRV_SCO_DA" 

ENDCASE