PARAMETERS V_SEEK

x_soci = "pnc_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO CODICE UTENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              PUB_LEN = 10
              V_SEEK = TRC(PUB_LEN,ALLTRIM(V_SEEK))
              x_codu = "pnc_codute = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codu
           ENDIF
        ELSE
           PUB_LEN = 10
           V_SEEK = TRC(PUB_LEN,ALLTRIM(V_SEEK))
           x_codu = "pnc_codute = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codu
        ENDIF
        _ii_cSql = "select * from u_pnc_bu where " + x_cond + ;
                                                 " order by pnc_codsoc,pnc_codute" 

   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE UTENTE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ragi = "pnc_desute like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ragi
           ENDIF
        ELSE
           x_ragi = "pnc_desute like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ragi
        ENDIF
        _ii_cSql = "select * from u_pnc_bu where " + x_cond + ;
                                                 " order by pnc_codsoc,pnc_desute" 

   CASE V_SCELTA=3          				&& ACCESSO DATA OPERAZIONE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "pnc_datope = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "pnc_datope = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql = "select * from u_pnc_bu where " + x_cond + ;
                                                 " order by pnc_codsoc,pnc_datope" 

   CASE V_SCELTA=4          				&& ACCESSO DESCRIZIONE OPERAZIONE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ragi = "pnc_desope like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ragi
           ENDIF
        ELSE
           x_ragi = "pnc_desope like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ragi
        ENDIF
        _ii_cSql = "select * from u_pnc_bu where " + x_cond + ;
                                                 " order by pnc_codsoc,pnc_desope" 

   CASE V_SCELTA=3          				&& ACCESSO DATA REGISTRAZIONE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datr = "pnc_datreg = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datr
           ENDIF
        ELSE
           x_datr = "pnc_datreg = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datr
        ENDIF
        _ii_cSql = "select * from u_pnc_bu where " + x_cond + ;
                                                 " order by pnc_codsoc,pnc_datreg" 

ENDCASE