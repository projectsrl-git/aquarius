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

	CASE V_SCELTA=1          				&& ACCESSO PER CODICE 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cod = "codice like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_cod
           ENDIF
        ELSE
           x_cod = "codice like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_cod
        ENDIF
        _ii_cSql   = "select * from u_com_pe where " + x_cond + ;
                                                   " order by gruppo,codice" 

	

	CASE V_SCELTA=2          				&& ACCESSO PER DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_descri = "descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_descri
           ENDIF
        ELSE
           x_descri = "descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_descri
        ENDIF
        _ii_cSql   = "select * from u_com_pe where " + x_cond + ;
                                                   " order by gruppo,descri" 
                                                   
	
	CASE V_SCELTA=3          				&& ACCESSO PER TIPO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "tipo= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_tipo
           ENDIF
        ELSE
           x_tipo = "tipo = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_tipo
        ENDIF
        _ii_cSql   = "select * from u_com_pe where " + x_cond + ;
                                                   " order by gruppo,tipo" 	                                                   

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

	   CASE V_SCELTA=1                          && ACCESSO PER CODICE 
		_CampiFiltro = "U2.codice < U1.codice"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " codice like '" + ALLTRIM(V_SEEK) + "'%"
		ENDIF
   		_Ordine = "codice"
   		_Tabella 		= "u_com_pe"


   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE 
		_CampiFiltro = "U2.descri < U1.descri"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " descri like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
   		_Ordine = "descri"
   		_Tabella 		= "u_com_pe"

   CASE V_SCELTA=3                          && ACCESSO PER TIPO
		_CampiFiltro = "U2.tipo < U1.tipo"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "tipo= '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
        ENDIF
	    _Ordine = "tipo"
	    _Tabella 		= "u_com_pe"

ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
*!*	_Tabella 		= "u_cnt_tt"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN

