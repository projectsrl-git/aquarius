
PARAMETERS V_SEEK

x_cond   = "cas_codsoc = '" + PUB_CODSOC + "'"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER NUMERO SCATOLA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cas_numsca like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cas_numsca like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cas_tt where " + x_cond + ;
                                                 " order by cas_numsca,cas_datsca"
   
ENDCASE
