
PARAMETERS V_SEEK

x_soci = "1 = 1"
*!*	x_anno = "BDG_ANNO = '" + PUB_ANNO + "'"
x_cond = x_soci
*!*	IF DOC_ANNO
*!*	   x_cond = x_cond + " and " + x_anno
*!*	ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER NUMERO PROGRAMMA DI PRODUZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(5,ALLTRIM(V_SEEK))
              x_codi = "PTT_NUMPRG = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi 
           ENDIF
        ELSE
           V_SEEK = TRC(5,ALLTRIM(V_SEEK))
           x_codi = "PTT_NUMPRG = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi 
        ENDIF
        _ii_cSql  = "select (SUBSTRING(PTT_DATPRG,9,2)+'/'+SUBSTRING(PTT_DATPRG,6,2)+'/'+SUBSTRING(PTT_DATPRG,1,4)) AS PTT_DATGMA,* from U_PRD_CT where " + x_cond + " order by PTT_NUMPRG,PTT_DATPRG"


   CASE V_SCELTA=2                          && ACCESSO PER DATA PROGRAMMA DI PRODUZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "PTT_DATPRG = '" + RIBALTA2(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi 
           ENDIF
        ELSE
           x_codi = "PTT_DATPRG = '" + RIBALTA2(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi 
        ENDIF
        _ii_cSql  = "select (SUBSTRING(PTT_DATPRG,9,2)+'/'+SUBSTRING(PTT_DATPRG,6,2)+'/'+SUBSTRING(PTT_DATPRG,1,4)) AS PTT_DATGMA,* from U_PRD_CT where " + x_cond + " order by PTT_DATPRG,PTT_NUMPRG"

   CASE V_SCELTA=3                          && ACCESSO PER CODICE ADESIVO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "PTT_CODADE like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi 
           ENDIF
        ELSE
           x_codi = "PTT_CODADE like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi 
        ENDIF
        _ii_cSql  = "select (SUBSTRING(PTT_DATPRG,9,2)+'/'+SUBSTRING(PTT_DATPRG,6,2)+'/'+SUBSTRING(PTT_DATPRG,1,4)) AS PTT_DATGMA,* from U_PRD_CT where " + x_cond + " order by PTT_CODADE,PTT_DATPRG,PTT_NUMPRG"

ENDCASE
