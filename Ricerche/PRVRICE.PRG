PARAMETERS V_SEEK

 
x_soci = "prv_codsoc = '" + PUB_CODSOC + "'"
x_anno = "prv_anno = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO NUMERO FATTURA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nor6   = 6
              x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              x_nord   = "prv_numfat = '" + x_nor0 + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select * from u_prv_an where " + x_cond + ;
                                                    " order by prv_codsoc,prv_numfat,prv_anno" 
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "prv_numfat = '" + x_nor0 + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_prv_an where " + x_cond + ;
                                                 " order by prv_codsoc,prv_numfat,prv_anno" 
  
   CASE V_SCELTA=2          				&& ACCESSO RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nord   = "prv_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select * from u_prv_an where " + x_cond + ;
                                                    " order by prv_codsoc,prv_ragsoc,prv_anno" 
        ELSE
           x_nord   = "prv_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_prv_an where " + x_cond + ;
                                                 " order by prv_codsoc,prv_ragsoc,prv_anno" 

   CASE V_SCELTA=3          				&& ACCESSO CODICE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nord   = "prv_codage = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select * from u_prv_an where " + x_cond + ;
                                                    " order by prv_codsoc,prv_codage,prv_anno" 
        ELSE
           x_nord   = "prv_codage = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_prv_an where " + x_cond + ;
                                                 " order by prv_codsoc,prv_codage,prv_anno" 
		  	
ENDCASE