PARAMETERS V_SEEK

*x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
*x_cond = x_soci
*x_soci = "id_unique = '" + PUB_CODSOC + "'"
*x_cond = x_soci
*x_cond="id_unique="
x_cond="1=1"

*SET STEP ON


DO CASE

	
*   CASE V_SCELTA=1                          && ACCESSO PER CODICE BANCA
*        IF PUB_VISRIC 
*           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*           ELSE
*              x_codi   = "ban_codban = '" + ALLTRIM(V_SEEK) + "'"
*              x_cond   = x_cond + " and " + x_codi
*           ENDIF
*        ELSE
*           x_codi   = "ban_codban = '" + ALLTRIM(V_SEEK) + "'"
*           x_cond   = x_cond + " and " + x_codi
*        ENDIF
*        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
*                                                 " order by ban_codsoc,ban_codban" 
 		
*!*	   CASE V_SCELTA=2          				&& ACCESSO DENOMINAZIONE
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	              x_desc = "ban_desban like '" + ALLTRIM(V_SEEK) + "%'"
*!*	              x_cond = x_cond + " and " + x_desc
*!*	           ENDIF
*!*	        ELSE
*!*	           x_desc = "ban_desban like '" + ALLTRIM(V_SEEK) + "%'"
*!*	           x_cond = x_cond + " and " + x_desc
*!*	        ENDIF
*!*	        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
*!*	                                                 " order by ban_codsoc,ban_desban" 
*!*	   
*!*	   CASE V_SCELTA=3          				&& ACCESSO LOCALITA'
*!*	        IF PUB_VISRIC 
*!*	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           ELSE
*!*	              x_loca = "ban_loca like '" + ALLTRIM(V_SEEK) + "%'"
*!*	              x_cond = x_cond + " and " + x_loca
*!*	           ENDIF
*!*	        ELSE
*!*	           x_loca = "ban_loca like '" + ALLTRIM(V_SEEK) + "%'"
*!*	           x_cond = x_cond + " and " + x_loca
*!*	        ENDIF
*!*	        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
*!*	                                                 " order by ban_codsoc,ban_loca" 

   	CASE V_SCELTA=1          				&& ACCESSO COGNOME
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
             ELSE
	              x_desc = "tes_cogn like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_desc
	              *x_cond=" "+x_desc
			
	           ENDIF
	        ELSE
	           x_desc = "tes_cogn like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_desc
	           *x_cond=" "+x_desc
			
	        ENDIF
			
					
	        _ii_cSql = "select * from u_tes_an where " + x_cond + ;
	                                    	             " order by tes_cogn,tes_nome" 
	   
   CASE V_SCELTA=2          				&& ACCESSO Nome'
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_desc = "tes_nome like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_desc
	             *x_cond=x_desc
	           ENDIF
	        ELSE
	           x_desc = "tes_nome like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_desc
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_tes_an where " + x_cond + ;
	                                                 " order by tes_cogn,tes_nome" 
	   
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
	   

		CASE V_SCELTA=3          				&& ACCESSO città
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_desc = "tes_loc like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_desc
	              *x_cond=x_desc	   
	           ENDIF
	        ELSE
	           x_desc = "tes_loc like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_desc
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_tes_an where " + x_cond + ;
	                                                 " order by tes_cogn,tes_nome" 
   		
   		CASE V_SCELTA=4          				&& ACCESSO provincia
	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_desc = "tes_prov like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond = x_cond + " and " + x_desc
	              *x_cond=x_desc	   
	           ENDIF
	        ELSE
	           x_desc = "tes_prov like '" + ALLTRIM(V_SEEK) + "%'"
	           x_cond = x_cond + " and " + x_desc
	           *x_cond=x_desc
	        ENDIF
	        _ii_cSql = "select * from u_tes_an where " + x_cond + ;
	                                                 " order by tes_cogn,tes_nome" 

   
ENDCASE

