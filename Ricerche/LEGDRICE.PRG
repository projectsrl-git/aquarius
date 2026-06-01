PARAMETERS V_SEEK

x_cond = "0=0"

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER TIPO DOCUMENTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "leg_tipdoc like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "leg_tipdoc like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from u_leg_do where " + x_cond + ;
                                                 " order by leg_tipdoc" 
        ENDIF
        _ii_cSql = "select * from u_leg_do where " + x_cond + ;
                                                 " order by leg_tipdoc" 

   CASE V_SCELTA=2                          && ACCESSO PER CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "leg_codcli like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "leg_codcli like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from u_leg_do where " + x_cond + ;
                                                 " order by leg_codcli" 
        ENDIF
        _ii_cSql = "select * from u_leg_do where " + x_cond + ;
                                                 " order by leg_codcli" 

   CASE V_SCELTA=3                          && ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "leg_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "leg_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from u_leg_do where " + x_cond + ;
                                                 " order by leg_ragsoc" 
        ENDIF
        _ii_cSql = "select * from u_leg_do where " + x_cond + ;
                                                 " order by leg_ragsoc" 

   CASE V_SCELTA=4                          && ACCESSO PER I PRIMI SEI CAMPI DELLA TABELLA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cond = "leg_tipdoc like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
        ELSE
           x_cond = "leg_tipdoc like '" + ALLTRIM(V_SEEK) + "%'"
           _ii_cSql = "select * from u_leg_do where " + x_cond + ;
                                                 " order by leg_tipdoc,leg_anno,leg_codcli,leg_ragsoc,leg_numdoc,leg_datdoc,leg_tipcre,leg_numcre,leg_datcre,leg_salcon" 
        ENDIF
        _ii_cSql = "select * from u_leg_do where " + x_cond + ;
                                                 " order by leg_tipdoc,leg_anno,leg_codcli,leg_ragsoc,leg_numdoc,leg_datdoc,leg_tipcre,leg_numcre,leg_datcre,leg_salcon" 
ENDCASE