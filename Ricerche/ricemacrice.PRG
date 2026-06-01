PARAMETERS V_SEEK



x_soci = "1 = 1"
*!*	x_anno = "BDG_ANNO = '" + PUB_ANNO + "'"
x_cond = x_soci
*!*	IF DOC_ANNO
*!*	   x_cond = x_cond + " and " + x_anno
*!*	ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE RICETTA + DATA DECRESCENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "CODICE like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by CODICE,DATATARICE DESC,PROGRICE DESC"
        ELSE
           x_tipo = "CODICE like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by CODICE,DATATARICE DESC,PROGRICE DESC"


   CASE V_SCELTA=2                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "CODICE like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by CODICE,PRODOTTO,MATERIALE,FASCIA"
        ELSE
           x_tipo = "CODICE like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by CODICE,PRODOTTO,MATERIALE,FASCIA"

   CASE V_SCELTA=3                          && ACCESSO PER PRODOTTO + FASCIA + DATA DECRESCENTE + PROGRESSIVO DECRESCENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "PRODOTTO like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by PRODOTTO,FASCIA,DATATARICE DESC,PROGRICE DESC,CODICE,MATERIALE"
        ELSE
           x_tipo = "PRODOTTO like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by PRODOTTO,FASCIA,DATATARICE DESC,PROGRICE DESC,CODICE,MATERIALE"
        
   CASE V_SCELTA=4                          && ACCESSO PER FASCIA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "FASCIA like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by FASCIA,CODICE,PRODOTTO,MATERIALE"
        ELSE
           x_tipo = "FASCIA like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by FASCIA,CODICE,PRODOTTO,MATERIALE"
        
   CASE V_SCELTA=5                          && ACCESSO PER MATERIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "MATERIALE like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by MATERIALE,CODICE,PRODOTTO,FASCIA"
        ELSE
           x_tipo = "MATERIALE like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from ricemac_tt where " + x_cond + " order by MATERIALE,CODICE,PRODOTTO,FASCIA"
        
                                                           
ENDCASE
