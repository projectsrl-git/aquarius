PARAMETERS V_SEEK


x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

**=> ERASMO - INIZIO 08/12/2017
*** GESTIONE OPERATORE/AGENTE: PUO' VISUALIZZARE ESCLUSIVAMENTE I SUOI CLIENTI
IF !EMPTY(PUB_AGEOPE)
	x_agop = "AGE_CODICE = '" + PUB_AGEOPE + "'"
	x_cond = x_cond + " and " + x_agop
ENDIF
**=> ERASMO - FINE 08/12/2017

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "age_codice = '" + ALLTRIM(v_seek) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_age_an where " + x_cond + ;
                                                    " order by age_codsoc,age_codice" 
        ELSE
           x_codi = "age_codice = '" + ALLTRIM(v_seek) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_age_an where " + x_cond + ;
                                                 " order by age_codsoc,age_codice" 
   
   CASE V_SCELTA=2                          && ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "age_ragsoc like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_age_an where " + x_cond + ;
                                                    " order by age_codsoc,age_ragsoc" 
        ELSE
           x_codi = "age_ragsoc like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_age_an where " + x_cond + ;
                                                 " order by age_codsoc,age_ragsoc" 

ENDCASE