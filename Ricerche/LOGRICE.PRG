PARAMETERS V_SEEK

x_cond = "0=0"

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER POSTAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "log_posope like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "log_posope like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_posope,log_datope,log_oraope" 
        ENDIF
        _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_posope,log_datope,log_oraope" 

   CASE V_SCELTA=2                          && ACCESSO PER NOME UTENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "log_nomope like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "log_nomope like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_nomope,log_datope,log_oraope" 
        ENDIF
        _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_nomope,log_datope,log_oraope" 

   CASE V_SCELTA=3                          && ACCESSO PER CODICE UTENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "log_codope like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "log_codope like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_codope,log_datope,log_oraope" 
        ENDIF
        _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_codope,log_datope,log_oraope" 


   CASE V_SCELTA=4                          && ACCESSO PER CONTO CONTABILE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "log_codcon like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "log_codcon like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_codcon,log_datope,log_oraope" 
        ENDIF
        _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_codcon,log_datope,log_oraope" 

   CASE V_SCELTA=5                          && ACCESSO PER DATA OPERAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "log_datope like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "log_datope like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_datope,log_oraope" 
        ENDIF
        _ii_cSql = "select * from log_cont where " + x_cond + ;
                                                 " order by log_datope,log_oraope" 

ENDCASE