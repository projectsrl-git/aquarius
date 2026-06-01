PARAMETERS V_SEEK

x_soci   = "ope_codsoc = '" + PUB_CODSOC + "'"
x_cond	 = x_soci

DO CASE

   CASE V_SCELTA = 1          				&& ACCESSO CODICE 
        IF PUB_VISRIC 
           IF EMPTY(ALLTRIM(V_SEEK)) 
           ELSE
              x_codi = "ope_codice like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "ope_codice like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql   = "select * from res_oper_conf where " + x_cond + ;
                                                        " order by ope_codsoc,ope_codice"

   CASE V_SCELTA = 2                          && ACCESSO PER DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(ALLTRIM(V_SEEK)) 
           ELSE
              x_desc = "ope_descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "ope_descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql   = "select * from res_oper_conf where " + x_cond + ;
                                                        " order by ope_codsoc,ope_descri"

ENDCASE

RETURN


