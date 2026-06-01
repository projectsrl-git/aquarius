PARAMETERS V_SEEK

x_cond = "0=0"

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO NOME PROCEDURA
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nome = "nomeproc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_nome
           ENDIF
        ELSE
           x_nome = "nomeproc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_nome
        ENDIF
        _ii_cSql = "select * from FORM_EXE where " + x_cond + ;
                                                 " order by nomeproc" 

   CASE V_SCELTA=2          				&& ACCESSO FORM ESEGUITO
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rep1 = "nomeformexe like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rep1
           ENDIF
        ELSE
           x_rep1 = "nomeformexe like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rep1
        ENDIF
        _ii_cSql = "select * from FORM_EXE where " + x_cond + ;
                                                 " order by nomeformexe" 

  
ENDCASE