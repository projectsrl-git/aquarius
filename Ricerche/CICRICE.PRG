* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci = "cit_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

PUB_VISRIC = .F.  && FORZATURA PER PROBLEMA IMPAGINAZIONE

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cit_gruppo like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cit_gruppo like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cic_tt where " + x_cond + ;
                                                 " order by cit_codsoc,cit_gruppo"

   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "cit_descri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "cit_descri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_cic_tt where " + x_cond + ;
                                                 " order by cit_codsoc,cit_descri"

ENDCASE

RETURN

* ------------------------------------------------------------------------------------------
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci = "cit_codsoc = '" + PUB_CODSOC + "'"
_x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
		_CampiFiltro = "U2.cit_codsoc = U1.cit_codsoc and U2.cit_gruppo < U1.cit_gruppo"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond  = _x_cond + " and cit_gruppo like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
   		_Ordine = "cit_codsoc,cit_gruppo"

   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE
		_CampiFiltro = "U2.cit_codsoc = U1.cit_codsoc and U2.cit_descri < U1.cit_descri"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond  = _x_cond + " and cit_descri like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
   		_Ordine = "cit_codsoc,cit_descri"

ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
_Tabella 		= "u_cic_tt"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN



