PARAMETERS V_SEEK

x_soci = "ped_codsoc = '" + PUB_CODSOC + "'"
x_cpdv = "ped_codpdv = '" + V_CODICE + "'"
x_cond = x_soci + " and " + x_cpdv

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO CODICE PERSONALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_codp = "ped_codice = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codp
           ENDIF
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_codp = "ped_codice = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codp
        ENDIF
        _ii_cSql = "select * from u_per_pd where " + x_cond + ;
                                                 " order by ped_codsoc,ped_codice" 

   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE PERSONALE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ragi = "ped_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ragi
           ENDIF
        ELSE
           x_ragi = "ped_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ragi
        ENDIF
        _ii_cSql = "select * from u_per_pd where " + x_cond + ;
                                                 " order by ped_codsoc,ped_ragsoc" 

   CASE V_SCELTA=3          				&& ACCESSO CODICE PDV
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cpdv = "ped_codpdv like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_cpdv
           ENDIF
        ELSE
           x_cpdv = "ped_codpdv like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_cpdv
        ENDIF
        _ii_cSql = "select * from u_per_pd where " + x_cond + ;
                                                 " order by ped_codsoc,ped_codpdv" 

   CASE V_SCELTA=4          				&& ACCESSO DESCRIZIONE PDV
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "ped_despdv like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "ped_despdv like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select * from u_per_pd where " + x_cond + ;
                                                 " order by ped_codsoc,ped_despdv" 

ENDCASE