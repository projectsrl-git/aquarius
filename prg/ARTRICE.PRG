* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci  = "art_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

RELEASE XXX_VISRIC
PUBLIC  XXX_VISRIC

XXX_VISRIC = PUB_VISRIC
PUB_VISRIC = .F.

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "art_codpri = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_codpri"
        ELSE
           x_codi   = "art_codpri = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_codpri"

   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "art_descr like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_descr"
        ELSE
           x_codi   = "art_descr like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_descr"

   CASE V_SCELTA=3                          && ACCESSO PER LINEA DI PRODOTTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clin = "art_linea = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clin
           ENDIF
	       _ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_linea,art_codpri" 
        ELSE
           x_clin = "art_linea = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clin
        ENDIF
        _ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_linea,art_codpri" 
		  	         				
   CASE V_SCELTA=4                          && ACCESSO PER COORDINATE DI MAGAZZINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_coor = "art_coord = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_coor
           ENDIF
	       _ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_coor = "art_coord = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_coor
        ENDIF
        _ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri" 
 	
ENDCASE

PUB_VISRIC = XXX_VISRIC

RETURN


* ------------------------------------------------------------------------------------------
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci  = "art_codsoc = '" + PUB_CODSOC + "'"
_x_cond	= x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE ARTICOLO
		_CampiFiltro = "U2.art_codsoc = U1.art_codsoc and U2.art_codpri < U1.art_codpri"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
  		   _x_cond = _x_cond + " and art_codpri like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
		_Ordine	= "art_codsoc,art_codpri"
  
   CASE V_SCELTA=2          				&& ACCESSO PER DESCRIZIONE ARTICOLO
		_CampiFiltro = "U2.art_codsoc = U1.art_codsoc and U2.art_descr < U1.art_descr"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond = _x_cond + " and art_descr like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
		_Ordine	= "art_codsoc,art_descr"
                                                      
   CASE V_SCELTA=3          				&& ACCESSO PER LINEA DI PRODOTTO
		_CampiFiltro = "U2.art_codsoc = U1.art_codsoc and U2.art_linea < U1.art_linea"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
	  	   _x_cond = _x_cond + " and art_linea = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
		_Ordine	= "art_codsoc,art_linea,art_codpri"

   CASE V_SCELTA=4          				&& ACCESSO PER COORDINATE DI MAGAZZINO
		_CampiFiltro = "U2.art_codsoc = U1.art_codsoc and U2.art_coord < U1.art_coord"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond	= _x_cond + " and art_coord like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
		_Ordine = "art_codsoc,art_coord,art_codpri"

ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
_Tabella 		= "u_art_pr"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN