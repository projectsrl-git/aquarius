
PARAMETERS V_SEEK

x_soci = "per_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO CODICE PERSONALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codp = "per_codice LIKE '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codp
           ENDIF
        ELSE
           x_codp = "per_codice LIKE '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codp
        ENDIF
        _ii_cSql = "select * from u_per_an where " + x_cond + ;
                                                 " order by per_codsoc,per_codice" 

   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE PERSONALE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ragi = "per_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ragi
           ENDIF
        ELSE
           x_ragi = "per_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ragi
        ENDIF
        _ii_cSql = "select * from u_per_an where " + x_cond + ;
                                                 " order by per_codsoc,per_ragsoc" 

   CASE V_SCELTA=3          				&& ACCESSO TIPO CONTRATTO
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "per_tipcon like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo
           ENDIF
        ELSE
           x_tipo = "per_tipcon like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo
        ENDIF
        _ii_cSql = "select * from u_per_an where " + x_cond + ;
                                                 " order by per_codsoc,per_tipcon" 

   CASE V_SCELTA=4          				&& ACCESSO DESCRIZIONE CONTRATTO
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "per_descon like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "per_descon like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select * from u_per_an where " + x_cond + ;
                                                 " order by per_codsoc,per_descon" 

   CASE V_SCELTA=5          				&& ACCESSO DATA CONTRATTO
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "per_datcon = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "per_datcon = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql = "select * from u_per_an where " + x_cond + ;
                                                 " order by per_codsoc,per_datcon" 

ENDCASE