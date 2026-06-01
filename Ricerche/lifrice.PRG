PARAMETERS V_SEEK

*_p_tiporic	= "Codice fornitore,1,Rag. sociale,2,Codice articolo,3,Data listino al (gg/mm/aaaa),4"								&& ERASMO - 05/12/2019


x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

**=> ERASMO - INIZIO 07/12/2021
IF DOC_ANNO
	x_anno = "'" + PUB_ANNO + "' BETWEEN SUBSTRING(LIS_DATLIS,1,4) AND SUBSTRING(LIS_ALLIST,1,4)"
	x_cond = x_cond + " and " + x_anno
ENDIF
**=> ERASMO - FINE 07/12/2021

DO CASE
   CASE V_SCELTA=1          				&& ACCESSO CODICE FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
 	          IF SUBSTR(V_SEEK,1,1)  <  "A"
		         V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	          ENDIF
              x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lif_tt where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codcli,lis_codart" 
        ELSE
           IF SUBSTR(V_SEEK,1,1)  <  "A"
	          V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
	       ENDIF
           x_codi = "lis_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lif_tt where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codcli,lis_codart"

   **=> ERASMO - INIZIO 05/12/2019
   CASE V_SCELTA=2                          && ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_ragsoc LIKE '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lif_tt where " + x_cond + ;
                                                    " order by lis_codsoc,lis_ragsoc,lis_codart" 
        ELSE
           x_codi = "lis_ragsoc LIKE '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lif_tt where " + x_cond + ;
                                                 " order by lis_codsoc,lis_ragsoc,lis_codart"
   **=> ERASMO - FINE 05/12/2019
		  	
   CASE V_SCELTA=3                          && ACCESSO PER CODICE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "lis_codart = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_lif_tt where " + x_cond + ;
                                                    " order by lis_codsoc,lis_codart,lis_codcli" 
        ELSE
           x_codi = "lis_codart = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_lif_tt where " + x_cond + ;
                                                 " order by lis_codsoc,lis_codart,lis_codcli" 
		  	

   CASE V_SCELTA=4          				&& ACCESSO PER DATA LISTINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_lif_tt where " + x_cond + ;
                                                      " order by lis_codsoc,lis_datlis,lis_codcli,lis_codart" 
        ELSE
           x_data = "lis_datlis = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_lif_tt where " + x_cond + ;
                                                   " order by lis_codsoc,lis_datlis,lis_codcli,lis_codart" 

ENDCASE