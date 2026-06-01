* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------



PARAMETERS V_SEEK


x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

*!*	PUB_VISRIC = .F.  && FORZATURA PER PROBLEMA IMPAGINAZIONE

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER NUMERO D'ORDINE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nor6   = 6
              x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              x_nord   = "ord_numord = '" + x_nor0 + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select * from u_ctl_tt where " + x_cond + ;
                                                    " order by ord_codsoc,ord_numord,ord_anno" 
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "ord_numord = '" + x_nor0 + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_ctl_tt where " + x_cond + ;
                                                 " order by ord_codsoc,ord_numord,ord_anno" 

   CASE V_SCELTA=2                          && ACCESSO PER DATA ORDINE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_ctl_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_datord,ord_numord" 
        ELSE
           x_data = "ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_ctl_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_datord,ord_numord" 
		  	
   CASE V_SCELTA=3          				&& ACCESSO PER NUMERO BOLLA DI RIFERIMENTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nor6   = 6
              x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              x_nord   = "ord_numbol = '" + x_nor0 + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
           _ii_cSql = "select * from u_ctl_tt where " + x_cond + ;
                                                    " order by ord_codsoc,ord_numbol,ord_anno" 
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "ord_numbol = '" + x_nor0 + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_ctl_tt where " + x_cond + ;
                                                 " order by ord_codsoc,ord_numbol,ord_anno" 
		  	
   CASE V_SCELTA=4                          && ACCESSO PER DATA BOLLA DI RIFERIMENTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "ord_datbol = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
           _ii_cSql   = "select * from u_ctl_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_datbol,ord_numord" 
        ELSE
           x_data = "ord_datbol = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select * from u_ctl_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_datbol,ord_numord" 
		  	
   CASE V_SCELTA=5          				&& ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_ctl_tt where " + x_cond + ;
                                                      " order by ord_codsoc,ord_ragsoc,ord_anno" 
        ELSE
           x_rags = "ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_ctl_tt where " + x_cond + ;
                                                   " order by ord_codsoc,ord_ragsoc,ord_anno" 
		  	
ENDCASE

RETURN


* ------------------------------------------------------------------------------------------
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ord_anno = '" + PUB_ANNO + "'"
_x_cond = x_soci
IF DOC_ANNO
   _x_cond = _x_cond + " and " + x_anno
ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER NUMERO
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_numord < U1.ord_numord"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
		   _x_cond  = _x_cond + " and ord_numord = '" + x_nor0 + "'"
		ENDIF
   		_Ordine = "ord_codsoc,ord_numord,ord_anno"

   CASE V_SCELTA=2                          && ACCESSO PER DATA ORDINE
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_datord < U1.ord_datord"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = _x_cond + " and ord_datord = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
        ENDIF
	    _Ordine = "ord_codsoc,ord_datord,ord_numord"

   CASE V_SCELTA=3                          && ACCESSO PER NUMERO BOLLA DI RIFERIMENTO
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_numbol < U1.ord_numbol"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
		   _x_cond  = _x_cond + " and ord_numbol = '" + x_nor0 + "'"
		ENDIF
   		_Ordine = "ord_codsoc,ord_numbol,ord_anno"

   CASE V_SCELTA=4                          && ACCESSO PER DATA BOLLA DI RIFERIMENTO
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_datbol < U1.ord_datbol"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = _x_cond + " and ord_datbol = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
        ENDIF
	    _Ordine = "ord_codsoc,ord_datbol,ord_numord"

   CASE V_SCELTA=5                          && ACCESSO PER RAGIONE SOCIALE
		_CampiFiltro = "U2.ord_codsoc = U1.ord_codsoc and U2.ord_ragsoc < U1.ord_ragsoc"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond	= _x_cond + " and ord_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
		_Ordine	= "ord_codsoc,ord_ragsoc,ord_anno"

ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
_Tabella 		= "u_ctl_tt"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN



