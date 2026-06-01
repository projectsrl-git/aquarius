PARAMETERS V_SEEK

x_soci = "ret_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ret_anno = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO N.RIGA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "ret_riga = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql   = "select * from u_ret_ce where " + x_cond + ;
                                                      " order by ret_codsoc,ret_riga,ret_anno" 
        ELSE
           x_codi = "ret_riga = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql   = "select * from u_ret_ce where " + x_cond + ;
                                                   " order by ret_codsoc,ret_riga,ret_anno" 

ENDCASE