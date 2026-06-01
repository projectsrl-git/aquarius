PARAMETERS V_SEEK

x_codi = "codice like 'NUM___       '"
x_cond = x_codi 

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(ALLTRIM(V_SEEK))
           ELSE
              x_codi = "substring(codice,4,10) = '" + SUBSTR(ALLTRIM(V_SEEK),1,3) + "       '"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "substring(codice,4,10) = '" + SUBSTR(ALLTRIM(V_SEEK),1,3) + "       '"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select substring(codice,4,3) as codi,descri,substring(libera,1,10) as libe,par_datins from para where " + x_cond + ;
                                                 " order by codi"

   CASE V_SCELTA=2          				&& ACCESSO PER DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(ALLTRIM(V_SEEK))
           ELSE
              x_desc = "descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select substring(codice,4,3) as codi,descri,substring(libera,1,10) as libe,par_datins from para where " + x_cond + ;
                                                 " order by descri"
   
ENDCASE
