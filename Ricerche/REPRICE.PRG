PARAMETERS V_SEEK

x_cond = "0=0"

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO CODICE DI ACCESSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "compa like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi = "compa like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from pjtiprep where " + x_cond + ;
                                                 " order by compa" 

   CASE V_SCELTA=2          				&& ACCESSO NOME PROCEDURA
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
        _ii_cSql = "select * from pjtiprep where " + x_cond + ;
                                                 " order by nomeproc" 

   CASE V_SCELTA=3          				&& ACCESSO NOME 1° REPORT
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rep1 = "nomerep like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rep1
           ENDIF
        ELSE
           x_rep1 = "nomerep like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rep1
        ENDIF
        _ii_cSql = "select * from pjtiprep where " + x_cond + ;
                                                 " order by nomerep" 

   CASE V_SCELTA=4          				&& ACCESSO NOME 2° REPORT
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rep2 = "nomerep2 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rep2
           ENDIF
        ELSE
           x_rep2 = "nomerep2 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rep2
        ENDIF
        _ii_cSql = "select * from pjtiprep where " + x_cond + ;
                                                 " order by nomerep2" 

   CASE V_SCELTA=5          				&& ACCESSO NOME 3° REPORT
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rep3 = "nomerep3 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rep3
           ENDIF
        ELSE
           x_rep3 = "nomerep3 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rep3
        ENDIF
        _ii_cSql = "select * from pjtiprep where " + x_cond + ;
                                                 " order by nomerep3"

   CASE V_SCELTA=6          				&& ACCESSO NOME 4° REPORT
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rep4 = "nomerep4 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rep4
           ENDIF
        ELSE
           x_rep4 = "nomerep4 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rep4
        ENDIF
        _ii_cSql = "select * from pjtiprep where " + x_cond + ;
                                                 " order by nomerep4"

ENDCASE