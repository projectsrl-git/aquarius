PARAMETERS V_SEEK

x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_anno = "age_anno = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO PER CODICE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "age_codice = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_fag_tt where " + x_cond + ;
                                                    " order by age_codsoc,age_anno,age_codice"
       ELSE
          x_codi = "age_codice = '" + ALLTRIM(V_SEEK) + "'"
          x_cond = x_cond + " and " + x_codi
       ENDIF
       _ii_cSql = "select * from u_fag_tt where " + x_cond + ;
                                                " order by age_codsoc,age_anno,age_codice"

   CASE V_SCELTA=2          				&& ACCESSO PER RAGIONE SOCIALE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "age_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql = "select * from u_fag_tt where " + x_cond + ;
                                                    " order by age_codsoc,age_anno,age_ragsoc"
        ELSE
           x_rags = "age_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql = "select * from u_fag_tt where " + x_cond + ;
                                                 " order by age_codsoc,age_anno,age_ragsoc"

ENDCASE
