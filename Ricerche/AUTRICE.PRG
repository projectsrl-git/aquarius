PARAMETERS V_SEEK

x_soci = "pdv_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO DATA RICHIESTA AUTORIZZAZIONE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "pdv_dataut = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "pdv_dataut = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql = "select * from u_pdv_au where " + x_cond + ;
                                                 " order by pdv_codsoc,pdv_dataut" 

   CASE V_SCELTA=2          				&& ACCESSO CODICE UTENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              PUB_LCL = 10
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_codi = "pdv_codute = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           PUB_LCL = 10
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_codi = "pdv_codute = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_pdv_au where " + x_cond + ;
                                                 " order by pdv_codsoc,pdv_codute" 

   CASE V_SCELTA=3          				&& ACCESSO DESCRIZIONE UTENTE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ragi = "pdv_desute like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ragi
           ENDIF
        ELSE
           x_ragi = "pdv_desute like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ragi
        ENDIF
        _ii_cSql = "select * from u_pdv_au where " + x_cond + ;
                                                 " order by pdv_codsoc,pdv_desute" 

   CASE V_SCELTA=4          				&& ACCESSO CODICE PDV
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              PUB_LCL = 3
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_codi = "pdv_codbun = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
        ELSE
           PUB_LCL = 3
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_codi = "pdv_codbun = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_pdv_au where " + x_cond + ;
                                                 " order by pdv_codsoc,pdv_codbun" 

   CASE V_SCELTA=5          				&& ACCESSO DESCRIZIONE PDV
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ragi = "pdv_desbun like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ragi
           ENDIF
        ELSE
           x_ragi = "pdv_desbun like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ragi
        ENDIF
        _ii_cSql = "select * from u_pdv_au where " + x_cond + ;
                                                 " order by pdv_codsoc,pdv_desbun" 
   
ENDCASE