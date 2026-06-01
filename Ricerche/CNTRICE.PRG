* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK
*SET STEP ON 
*!*	x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
*!*	x_anno = "ord_anno = '" + PUB_ANNO + "'"
*!*	x_cond = x_soci
*!*	IF DOC_ANNO
*!*	   x_cond = x_cond + " and " + x_anno
*!*	ENDIF

x_cond="1=1"

DO CASE

	CASE V_SCELTA=1          				&& ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ragsoc = "cnt_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ragsoc
           ENDIF
        ELSE
           x_ragsoc = "cnt_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ragsoc
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 
                                                   
   CASE V_SCELTA=2                          && ACCESSO PER RAGIONE SOCIALE (TESTO CONTENUTO)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ragsoc = "cnt_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ragsoc
           ENDIF
        ELSE
           x_ragsoc = "cnt_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ragsoc
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 

	CASE V_SCELTA=3          				&& ACCESSO PER CODICE AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cage = "cnt_codage = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_cage
           ENDIF
        ELSE
           x_cage = "cnt_codage = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_cage
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 
                                                   
	
	CASE V_SCELTA=4          				&& ACCESSO PER AGENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cdesage = "cnt_desage like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_cdesage
           ENDIF
        ELSE
           x_cdesage = "cnt_desage like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_cdesage
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 	                                                   

   CASE V_SCELTA=5        				&& ACCESSO PER CODICE NAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codnaz   = "cnt_codnaz = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_codnaz
           ENDIF
        ELSE
           x_codnaz   = "cnt_codnaz = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_codnaz 
        ENDIF
        _ii_cSql = "select * from u_cnt_tt where " + x_cond + ;
                                                 " order by cnt_ragsoc" 

   CASE V_SCELTA=6                          && ACCESSO PER NAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desnaz = "cnt_desnaz like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desnaz
           ENDIF
        ELSE
           x_desnaz = "cnt_desnaz like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desnaz
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 

   CASE V_SCELTA=7          				&& ACCESSO PER CODICE ZONA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codzon = "cnt_codzon = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codzon
           ENDIF
        ELSE
           x_codzon = "cnt_codzon = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codzon
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 
                                                   
   CASE V_SCELTA=8          				&& ACCESSO PER ZONA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_deszon = "cnt_deszon like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_deszon
           ENDIF
        ELSE
           x_deszon = "cnt_deszon like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_deszon
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 
	  	
   CASE V_SCELTA=9         				&& ACCESSO PER CODICE SETTORE
         IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      x_codset="cnt_codset = '" +ALLTRIM(v_seek)+"'"
              x_cond = x_cond + " and " + x_codset
           ENDIF
        ELSE
			x_codset="cnt_codset ='" + ALLTRIM(V_SEEK)+"'"
           x_cond = x_cond + " and " + x_codset
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 


	CASE V_SCELTA=10          				&& ACCESSO PER SETTORE
         IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      x_desset="cnt_desset like '" +ALLTRIM(v_seek)+"%'"
              x_cond = x_cond + " and " + x_desset
           ENDIF
        ELSE
			x_desset="cnt_desset like '" + ALLTRIM(V_SEEK)+"%'"
           x_cond = x_cond + " and " + x_desset
        ENDIF
        _ii_cSql   = "select * from u_cnt_tt where " + x_cond + ;
                                                   " order by cnt_ragsoc" 

	CASE V_SCELTA=11          				&& ACCESSO PER CODICE CONTATTO
         IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      x_codcon="cnt_codcon = '" +ALLTRIM(v_seek)+"'"
              x_cond = x_cond + " and " + x_codcon
           ENDIF
        ELSE
			x_codcon="cnt_codcon= '" + ALLTRIM(V_SEEK)+"'"
           x_cond = x_cond + " and " + x_codcon
        ENDIF
        _ii_cSql   = "select taggancio,cnt_ragsoc,cnt_codage,cnt_desage,cnt_codzon,cnt_deszon,cnt_codnaz,cnt_desnaz,cnt_codset,cnt_desset,cnt_codres,cnt_desres,cnt_codcon,cnt_descon,cnt_dsconu from u_cnt_tt inner join u_cnt_dd on daggancio=taggancio where " + x_cond + ;
        	" group by taggancio,cnt_ragsoc,cnt_codage,cnt_desage,cnt_codzon,cnt_deszon,cnt_codnaz,cnt_desnaz,cnt_codset,cnt_desset,cnt_codres,cnt_desres ,cnt_codcon,cnt_descon,cnt_dsconu"
        
	CASE V_SCELTA=12          				&& ACCESSO PER CONTATTO
         IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      x_descon="cnt_descon like '" +ALLTRIM(v_seek)+"%'"
              x_cond = x_cond + " and " + x_descon
           ENDIF
        ELSE
			x_descon="cnt_descon like '" + ALLTRIM(V_SEEK)+"%'"
           x_cond = x_cond + " and " + x_descon
        ENDIF
        _ii_cSql   = "select taggancio,cnt_ragsoc,cnt_codage,cnt_desage,cnt_codzon,cnt_deszon,cnt_codnaz,cnt_desnaz,cnt_codset,cnt_desset,cnt_codres,cnt_desres,cnt_codcon,cnt_descon,cnt_dsconu from u_cnt_tt inner join u_cnt_dd on daggancio=taggancio where " + x_cond + ;
        	" group by taggancio,cnt_ragsoc,cnt_codage,cnt_desage,cnt_codzon,cnt_deszon,cnt_codnaz,cnt_desnaz,cnt_codset,cnt_desset,cnt_codres,cnt_desres ,cnt_codcon,cnt_descon,cnt_dsconu"      


	CASE V_SCELTA=13          				&& ACCESSO PER CODICE RESPONSO
         IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      x_codres="cnt_codres = '" +ALLTRIM(v_seek)+"'"	
              x_cond = x_cond + " and " + x_codres
           ENDIF
        ELSE
			x_codres="cnt_codres = '" + ALLTRIM(V_SEEK)+"'"
           x_cond = x_cond + " and " + x_codres
        ENDIF
       
        _ii_cSql   = "select taggancio,cnt_ragsoc,cnt_codage,cnt_desage,cnt_codzon,cnt_deszon,cnt_codnaz,cnt_desnaz,cnt_codset,cnt_desset,cnt_codres,cnt_desres,cnt_codcon,cnt_descon,cnt_dsconu from u_cnt_tt inner join u_cnt_dd on daggancio=taggancio where " + x_cond + ;
        	" group by taggancio,cnt_ragsoc,cnt_codage,cnt_desage,cnt_codzon,cnt_deszon,cnt_codnaz,cnt_desnaz,cnt_codset,cnt_desset,cnt_codres,cnt_desres ,cnt_codcon,cnt_descon,cnt_dsconu"      

	 
	CASE V_SCELTA=14          				&& ACCESSO PER RESPONSO
         IF PUB_VISRIC 	
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
	  	      x_desres="cnt_desres like '" +ALLTRIM(v_seek)+"%'"	
              x_cond = x_cond + " and " + x_desres
           ENDIF
        ELSE
			x_desres="cnt_desres like '" + ALLTRIM(V_SEEK)+"%'"
           x_cond = x_cond + " and " + x_desres
        ENDIF
        _ii_cSql   = "select taggancio,cnt_ragsoc,cnt_codage,cnt_desage,cnt_codzon,cnt_deszon,cnt_codnaz,cnt_desnaz,cnt_codset,cnt_desset,cnt_codres,cnt_desres,cnt_codcon,cnt_descon,cnt_dsconu from u_cnt_tt inner join u_cnt_dd on daggancio=taggancio where " + x_cond + ;
        	" group by taggancio,cnt_ragsoc,cnt_codage,cnt_desage,cnt_codzon,cnt_deszon,cnt_codnaz,cnt_desnaz,cnt_codset,cnt_desset,cnt_codres,cnt_desres ,cnt_codcon,cnt_descon,cnt_dsconu"      
	       
ENDCASE

RETURN


* ------------------------------------------------------------------------------------------
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

*!*	x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
*!*	x_anno = "ord_anno = '" + PUB_ANNO + "'"
*!*	_x_cond = x_soci
*!*	IF DOC_ANNO
*!*	   _x_cond = _x_cond + " and " + x_anno
*!*	ENDIF
x_cond=""

DO CASE

	   CASE V_SCELTA=1                          && ACCESSO PER RAGIONE SOCIALE
		_CampiFiltro = "U2.cnt_ragsoc < U1.cnt_ragsoc"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " cnt_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
   		_Ordine = "cnt_ragsoc"
   		_Tabella 		= "u_cnt_tt"


   CASE V_SCELTA=2                          && ACCESSO PER CODICE AGENTE
		_CampiFiltro = "U2.cnt_codage < U1.cnt_codage"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " cnt_codage = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
   		_Ordine = "cnt_ragsoc"
   		_Tabella 		= "u_cnt_tt"

   CASE V_SCELTA=3                          && ACCESSO PER AGENTE
		_CampiFiltro = "U2.cnt_desage < U1.cnt_desage"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "cnt_desage like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
	    _Ordine = "cnt_ragsoc"
	    _Tabella 		= "u_cnt_tt"

 	  CASE V_SCELTA=4                          && ACCESSO PER CODICE NAZIONE
		_CampiFiltro = "U2.cnt_codnaz < U1.cnt_codnaz"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " cnt_codnaz = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
   		_Ordine = "cnt_ragsoc"
   		_Tabella 		= "u_cnt_tt"

   CASE V_SCELTA=5                          && ACCESSO PER NAZIONE
		_CampiFiltro = "U2.cnt_desnaz < U1.cnt_desnaz"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "cnt_desnaz like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
	    _Ordine = "cnt_ragsoc"
	    _Tabella 		= "u_cnt_tt"
	   
	  CASE V_SCELTA=6                          && ACCESSO PER CODICE ZONA
		_CampiFiltro = "U2.cnt_codzon < U1.cnt_codzon"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " cnt_codzon = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
   		_Ordine = "cnt_ragsoc"
   		_Tabella 		= "u_cnt_tt"

   CASE V_SCELTA=7                          && ACCESSO PER ZONA
		_CampiFiltro = "U2.cnt_deszon < U1.cnt_deszon"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "cnt_deszon like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
	    _Ordine = "cnt_ragsoc"
	    _Tabella 		= "u_cnt_tt"
	    
	  CASE V_SCELTA=8                          && ACCESSO PER CODICE SETTORE
		_CampiFiltro = "U2.cnt_codset < U1.cnt_codset"
        IF EMPTY(V_SEEK) .OR. SUBSTr(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " cnt_codset = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
   		_Ordine = "cnt_ragsoc"
   		_Tabella 		= "u_cnt_tt"

   CASE V_SCELTA=9                          && ACCESSO PER SETTORE
		_CampiFiltro = "U2.cnt_desset < U1.cnt_desset"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "cnt_desset like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
	    _Ordine = "cnt_ragsoc"    
	    _Tabella 		= "u_cnt_tt"    
	
	  CASE V_SCELTA=10                          && ACCESSO PER CODICE CONTATTO
		_CampiFiltro = "U2.cnt_codcon < U1.cnt_codcon"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " cnt_codcon = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
   		_Ordine = "cos_ragsoc"
   		_Tabella 		= "u_cnt_dd"

   CASE V_SCELTA=11                          && ACCESSO PER CONTATTO
		_CampiFiltro = "U2.cnt_descon < U1.cnt_descon"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "cnt_descon like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
	    _Ordine = "cos_ragsoc" 
	    _Tabella 		= "u_cnt_dd"   
 	
 	  CASE V_SCELTA=12                          && ACCESSO PER CODICE RESPONSO
		_CampiFiltro = "U2.cnt_codres < U1.cnt_codres"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " cnt_codres = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
   		_Ordine = "cos_ragsoc"
   		_Tabella 		= "u_cnt_dd"

   CASE V_SCELTA=13                          && ACCESSO PER RESPONSO
		_CampiFiltro = "U2.cnt_desres < U1.cnt_desres"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "cnt_desres like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
	    _Ordine = "cos_ragsoc"
	    _Tabella 		= "u_cnt_dd"
ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
*!*	_Tabella 		= "u_cnt_tt"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN


