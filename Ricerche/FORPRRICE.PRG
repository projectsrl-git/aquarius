PARAMETERS V_SEEK
*SET STEP ON 
*!*	x_soci = "fpr_codsoc = '" + PUB_CODSOC + "'"
*!*	x_arti = "fpr_codart = '" + V_CODICE + "'"
*!*	x_cond = x_soci + " and " + x_arti
x_cond="1=1"

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
   		      V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_codf = "fpr_codfor = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codf
           ENDIF
           _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
                                                      " order by fpr_codfor" 
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_codf = "fpr_codfor = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codf
        ENDIF
        _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
                                                   " order by fpr_codfor" 
   
   CASE V_SCELTA=2          				&& ACCESSO RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "fpr_ragfor like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
                                                      " order by fpr_ragfor"
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_rags = "fpr_ragfor like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
                                                   " order by fpr_ragfor"
                                                   
   CASE V_SCELTA=3          				&& ACCESSO codice articolo
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "fpr_codart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
                                                      " order by fpr_codart"
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_rags = "fpr_codart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
                                                   " order by fpr_codart"
                                                   
                                                   
	  CASE V_SCELTA=4          				&& ACCESSO descrizione articolo
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "fpr_desart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
                                                      " order by fpr_desart"
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
           x_rags = "fpr_desart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
                                                   " order by fpr_desart"
                                                       
*!*	   CASE V_SCELTA=3                          && ACCESSO PER MAGAZZINO
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	              XXX_LUN = 3
*!*	   		      V_SEEK = TRC(XXX_LUN,ALLTRIM(V_SEEK))
*!*	              x_codm = "fpr_codmag = '" + ALLTRIM(V_SEEK) + "'"
*!*	              x_cond = x_cond + " and " + x_codm
*!*	           ENDIF
*!*	           _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
*!*	                                                      " order by fpr_codmag" 
*!*	        ELSE
*!*	           V_SEEK = TRC(XXX_LUN,ALLTRIM(V_SEEK))
*!*	           x_codm = "fpr_codmag = '" + ALLTRIM(V_SEEK) + "'"
*!*	           x_cond = x_cond + " and " + x_codm
*!*	        ENDIF
*!*	        _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
*!*	                                                   " order by fpr_codmag"

*!*	   CASE V_SCELTA=4          				&& ACCESSO PER DATA ULTIMO CARICO
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	              x_data = "fpr_datuca like '" + RIBALTA2(ALLTRIM(V_SEEK)) + "%'"
*!*	              x_cond = x_cond + " and " + x_data
*!*	           ENDIF
*!*	           _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
*!*	                                                      " order by fpr_datuca" 
*!*	        ELSE
*!*	           x_data = "fpr_datuca like '" + RIBALTA2(ALLTRIM(V_SEEK)) + "%'"
*!*	           x_cond = x_cond + " and " + x_data
*!*	        ENDIF
*!*	        _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
*!*	                                                   " order by fpr_datuca" 
*!*	        
*!*	   CASE V_SCELTA=5          				&& RICERCA PREZZO DA CONTRATTO
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	              x_przc = "fpr_przcon like '" + ALLTRIM(V_SEEK) + "%'"
*!*	              x_cond = x_cond + " and " + x_przc
*!*	           ENDIF
*!*		       _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
*!*	                                                      " order by fpr_przcon" 
*!*	        ELSE
*!*	           x_przc = "fpr_przcon like '" + ALLTRIM(V_SEEK) + "%'"
*!*	           x_cond = x_cond + " and " + x_przc
*!*	        ENDIF
*!*	        _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
*!*	                                                   " order by fpr_przcon" 

*!*	   CASE V_SCELTA=6          				&& RICERCA SEQUENZA / PRIORITA'
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	              x_sequ = "fpr_seqpri like '" + ALLTRIM(V_SEEK) + "%'"
*!*	              x_cond = x_cond + " and " + x_sequ
*!*	           ENDIF
*!*		       _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
*!*	                                                      " order by fpr_seqpri" 
*!*	        ELSE
*!*	           x_sequ = "fpr_seqpri like '" + ALLTRIM(V_SEEK) + "%'"
*!*	           x_cond = x_cond + " and " + x_sequ
*!*	        ENDIF
*!*	        _ii_cSql   = "select * from u_for_pr where " + x_cond + ;
*!*	                                                   " order by fpr_seqpri" 
        
ENDCASE