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

	CASE V_SCELTA=1          				&& ACCESSO PER CODICE PRODOTTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codart = "slc_codart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_codart
           ENDIF
        ELSE
           x_codart = "slc_codart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codart
        ENDIF
        _ii_cSql   = "select * from u_slc_cq where " + x_cond + ;
                                                   " order by slc_codart" 

	

	CASE V_SCELTA=2          				&& ACCESSO PER DESCRIZIONE PRODOTTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desart = "slc_desart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desart
           ENDIF
        ELSE
           x_cage = "slc_desart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desart
        ENDIF
        _ii_cSql   = "select * from u_slc_cq where " + x_cond + ;
                                                   " order by slc_desart" 
                                                   
	
	CASE V_SCELTA=3          				&& ACCESSO PER DATA ANALISI
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_datana = "slc_datana= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_datana
           ENDIF
        ELSE
           x_datana = "slc_datana = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_datana
        ENDIF
        _ii_cSql   = "select * from u_slc_cq where " + x_cond + ;
                                                   " order by slc_datana" 	                                                   

   CASE V_SCELTA=4         				&& ACCESSO PER RAGIONE SOCIALE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descli   = "slc_descli like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_descli
           ENDIF
        ELSE
           x_descli   = "slc_descli like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_descli
        ENDIF
        _ii_cSql = "select * from u_slc_cq where " + x_cond + ;
                                                 " order by slc_descli" 

   CASE V_SCELTA=5                          && ACCESSO PER CAMPIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE	
              x_campio = "slc_campio like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_campio
           ENDIF
        ELSE
           x_campio = "slc_campio like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_campio
        ENDIF
        _ii_cSql   = "select * from u_slc_cq where " + x_cond + ;
                                                   " order by slc_campio" 

   CASE V_SCELTA=6          				&& ACCESSO PER RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_respon = "slc_respon like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_respon
           ENDIF
        ELSE
           x_respon = "slc_respon like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_respon
        ENDIF
        _ii_cSql   = "select * from u_slc_cq where " + x_cond + ;
                                                   " order by slc_respon" 
                                                   
   CASE V_SCELTA=7          				&& ACCESSO PER DATA RESPONSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_resdat = "slc_resdat = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_resdat
           ENDIF
        ELSE
           x_resdat = "slc_resdat= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_resdat
        ENDIF
        _ii_cSql   = "select * from u_slc_cq where " + x_cond + ;
                                                  " order by slc_resdat" 
	  	
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

	   CASE V_SCELTA=1                          && ACCESSO PER CODICE PRODOTTO
		_CampiFiltro = "U2.slc_codart < U1.slc_codart"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " slc_codart like '" + ALLTRIM(V_SEEK) + "'%"
		ENDIF
   		_Ordine = "slc_codart"
   		_Tabella 		= "u_slc_cq"


   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE PRODOTTO
		_CampiFiltro = "U2.slc_desart < U1.slc_desart"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " slc_desart like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
   		_Ordine = "slc_desart"
   		_Tabella 		= "u_slc_cq"

   CASE V_SCELTA=3                          && ACCESSO PER DATA ANALISI
		_CampiFiltro = "U2.slc_datana < U1.slc_datana"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "slc_datana= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
        ENDIF
	    _Ordine = "slc_datana"
	    _Tabella 		= "u_slc_cq"

 	  CASE V_SCELTA=4                          && ACCESSO PER RAGIONE SOCIALE CLIENTE
		_CampiFiltro = "U2.slc_descli < U1.slc_descli"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " slc_descli like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
   		_Ordine = "slc_descli"
   		_Tabella 		= "u_slc_cq"

   CASE V_SCELTA=5                          && ACCESSO PER CAMPIONE
		_CampiFiltro = "U2.slc_campio < U1.slc_campio"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "slc_campio like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
	    _Ordine = "slc_campio"
	    _Tabella 		= "u_slc_cq"
	   
	  CASE V_SCELTA=6                          && ACCESSO PER RESPONSO
		_CampiFiltro = "U2.slc_respon < U1.slc_respon"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " slc_respon like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
   		_Ordine = "slc_respon"
   		_Tabella 		= "u_slc_cq"

   CASE V_SCELTA=7                          && ACCESSO PER 	DATA RESPONSO
		_CampiFiltro = "U2.slc_resdat < U1.slc_resdat"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "slc_resdat = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
        ENDIF
	    _Ordine = "slc_resdat"
	    _Tabella 		= "u_slc_cq"
	    
ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
*!*	_Tabella 		= "u_cnt_tt"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN


