PARAMETERS V_SEEK

x_soci = "ric_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_clie = "ric_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
        ELSE
	       V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_clie = "ric_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = "select * from U_ANF_TT where " + x_cond + ;
                                                   " order by ric_codsoc,ric_codcli,ric_dtfatt,ric_dtscad" 
 
   CASE V_SCELTA=2         				&& ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clie = "ric_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_clie
           ENDIF
        ELSE
           x_clie = "ric_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_clie
        ENDIF
        _ii_cSql   = "select * from U_ANF_TT where " + x_cond + ;
                                                   " order by ric_codsoc,ric_ragsoc,ric_dtfatt,ric_dtscad" 
		  	
   CASE V_SCELTA=3         				&& ACCESSO PER NUMERO DI FATTURA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nor6   = 6
              x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              x_nord   = "ric_nfatt = '" + x_nor0 + "'"
              *x_nord   = "ric_nfatt = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "ric_nfatt = '" + x_nor0 + "'"
           *x_nord   = "ric_nfatt = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from U_ANF_TT where " + x_cond + ;
                                                 " order by ric_codsoc,ord_anno,ric_nfatt,ric_dtfatt,ric_dtscad" 
		  	
ENDCASE