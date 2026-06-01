PARAMETERS V_SEEK

x_soci = "msg_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

*x_cond="1=1"

*SET STEP ON


DO CASE

	CASE V_SCELTA=1          				&& accesso codice mittente
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
             ELSE
	              x_codmit = "msg_codmit like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_codmit
	              *x_cond=" "+x_desc
			
	           ENDIF
	        ELSE
	           x_codmit = "msg_codmit like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_codmit
	           *x_cond=" "+x_desc
			
	        ENDIF
			
					
	        _ii_cSql = "select * from u_msg_au where " + x_cond + ;
	                                    	             " order by msg_codmit" 
	


   	CASE V_SCELTA=2          				&& accesso mittente
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
             ELSE
	              x_desmit = "msg_desmit like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_desmit
	              *x_cond=" "+x_desc
			
	           ENDIF
	        ELSE
	           x_desmit = "msg_desmit like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_desmit
	           *x_cond=" "+x_desc
			
	        ENDIF
			
					
	        _ii_cSql = "select * from u_msg_au where " + x_cond + ;
	                                    	             " order by msg_desmit,msg_codmit" 
	   
	   CASE V_SCELTA=3          				&& ACCESSO codice operatore
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_codope = "msg_codope like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_codope
	             *x_cond=x_desc
	           ENDIF
	        ELSE
	           x_codope = "msg_codope like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_codope
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_msg_au where " + x_cond + ;
	                                                 " order by msg_codope" 





   CASE V_SCELTA=4          				&& ACCESSO operatore
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_desope = "msg_desope like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_desope
	             *x_cond=x_desc
	           ENDIF
	        ELSE
	           x_desope = "msg_desope like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_desope
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_msg_au where " + x_cond + ;
	                                                 " order by msg_desope,msg_codope" 
	   
*!*		CASE V_SCELTA=3          				&& ACCESSO professione
*!*		        IF PUB_VISRIC 
*!*		           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*		           ELSE
*!*		              x_desc = "tes_profes like '" + ALLTRIM(V_SEEK) + "%'"
*!*		              x_cond = x_cond + " and " + x_desc
*!*		              *x_cond=x_desc	   
*!*		           ENDIF
*!*		        ELSE
*!*		           x_desc = "tes_profes like '" + ALLTRIM(V_SEEK) + "%'"
*!*		           x_cond = x_cond + " and " + x_desc
*!*		           *x_cond=x_desc
*!*		        ENDIF
*!*		        _ii_cSql = "select * from u_tes_an where " + x_cond + ;
*!*		                                                 " order by tes_cogn,tes_nome" 
	   

		CASE V_SCELTA=5          				&& ACCESSO codice destinatario
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_coddes = "msg_coddes like '" + ALLTRIM(V_SEEK) + "%' or msg_desdes like '%"+ALLTRIM(v_seek) + "%'" 
	              x_cond = x_cond + " and " + x_coddes
	              *x_cond=x_desc	   
	           ENDIF
	        ELSE
	           x_coddes = "msg_coddes like '" + ALLTRIM(V_SEEK) + "%' or msg_desdes like '%"+ALLTRIM(v_seek) + "%'"
	           x_cond = x_cond + " and " + x_coddes
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_msg_au where " + x_cond + ;
	                                                 " order by msg_coddes" 


		CASE V_SCELTA=6          				&& ACCESSO destinatario
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_desdes = "msg_desdes like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_desdes
	              *x_cond=x_desc	   
	           ENDIF
	        ELSE
	           x_desdes = "msg_desdes like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_desdes
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_msg_au where " + x_cond + ;
	                                                 " order by msg_desdes,msg_coddes" 
   		
   		CASE V_SCELTA=7          				&& ACCESSO data invio
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_datinv = "msg_datinv = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
	              x_cond = x_cond + " and " + x_datinv
	              *x_cond=x_desc	   
	           ENDIF
	        ELSE
	           x_datinv = "msg_datinv = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
	           x_cond = x_cond + " and " + x_datinv
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_msg_au where " + x_cond + ;
	                                                 " order by msg_datinv,msg_desdes" 



	   		CASE V_SCELTA=8          				&& ACCESSO data ricezione
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_datric = "msg_datinv = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
	              x_cond = x_cond + " and " + x_datric
	              *x_cond=x_desc	   
	           ENDIF
	        ELSE
	           x_datric = "msg_datinv = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
	           x_cond = x_cond + " and " + x_datric
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_msg_au where " + x_cond + ;
	                                                 " order by msg_datric,msg_desdes" 
   
   
ENDCASE

