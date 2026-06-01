* ------------------------------------------------------------------------------------------
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* ------------------------------------------------------------------------------------------

PARAMETERS V_TITOLO,V_AUTORE,V_EDITORE,V_COLLANA,V_CATEGORIA,V_NOTIZIA,V_CODICE,V_TIPO

_x_cond	     = "art_codsoc = '" + PUB_CODSOC + "'"
_CampiFiltro = "U2.art_codsoc = U1.art_codsoc"
_Ordine      = "art_codsoc"


IF V_TIPO = 1

   IF !EMPTY(V_TITOLO)
      _CampiFiltro	= _CampiFiltro + " and U2.art_descr < U1.art_descr"
      _x_cond	 	= _x_cond + " and art_descr like '" + ALLTRIM(V_TITOLO) + "%'"
   ENDIF
   IF !EMPTY(V_AUTORE)
      _CampiFiltro	= _CampiFiltro + " and U2.art_autore < U1.art_autore"
      _x_cond	 	= _x_cond + " and art_autore like '" + ALLTRIM(V_AUTORE) + "%'"
   ENDIF
   IF !EMPTY(V_EDITORE)
      _CampiFiltro	= _CampiFiltro + " and U2.art_desedi < U1.art_desedi"
      _x_cond	 	= _x_cond + " and art_desedi like '" + ALLTRIM(V_EDITORE) + "%'"
   ENDIF
   IF !EMPTY(V_COLLANA)
      _CampiFiltro	= _CampiFiltro + " and U2.art_descoa < U1.art_descoa"
      _x_cond	 	= _x_cond + " and art_descoa like '" + ALLTRIM(V_COLLANA) + "%'"
   ENDIF
   IF !EMPTY(V_CATEGORIA)
      _CampiFiltro	= _CampiFiltro + " and U2.art_catago < U1.art_catago"
      _x_cond	 	= _x_cond + " and art_catago like '" + ALLTRIM(V_CATEGORIA) + "%'"
   ENDIF
   IF !EMPTY(V_NOTIZIA)
      _CampiFiltro	= _CampiFiltro + " and U2.art_argome < U1.art_argome"
      _x_cond	 	= _x_cond + " and art_argome like '" + ALLTRIM(V_NOTIZIA) + "%'"
   ENDIF
   IF !EMPTY(V_CODICE)
      _CampiFiltro	= _CampiFiltro + " and U2.art_cdisbn < U1.art_cdisbn"
      _x_cond	 	= _x_cond + " and art_cdisbn like '" + ALLTRIM(V_CODICE) + "%'"
   ENDIF
   
ELSE
   
   IF !EMPTY(V_TITOLO)
      _CampiFiltro	= _CampiFiltro + " and U2.art_descr < U1.art_descr"
      _x_cond	 	= _x_cond + " and art_descr like '%" + ALLTRIM(V_TITOLO) + "%'"
   ENDIF
   IF !EMPTY(V_AUTORE)
      _CampiFiltro	= _CampiFiltro + " and U2.art_autore < U1.art_autore"
      _x_cond	 	= _x_cond + " and art_autore like '%" + ALLTRIM(V_AUTORE) + "%'"
   ENDIF
   IF !EMPTY(V_EDITORE)
      _CampiFiltro	= _CampiFiltro + " and U2.art_desedi < U1.art_desedi"
      _x_cond	 	= _x_cond + " and art_desedi like '%" + ALLTRIM(V_EDITORE) + "%'"
   ENDIF
   IF !EMPTY(V_COLLANA)
      _CampiFiltro	= _CampiFiltro + " and U2.art_descoa < U1.art_descoa"
      _x_cond	 	= _x_cond + " and art_descoa like '%" + ALLTRIM(V_COLLANA) + "%'"
   ENDIF
   IF !EMPTY(V_CATEGORIA)
      _CampiFiltro	= _CampiFiltro + " and U2.art_catago < U1.art_catago"
      _x_cond	 	= _x_cond + " and art_catago like '%" + ALLTRIM(V_CATEGORIA) + "%'"
   ENDIF
   IF !EMPTY(V_NOTIZIA)
      _CampiFiltro	= _CampiFiltro + " and U2.art_argome < U1.art_argome"
      _x_cond	 	= _x_cond + " and art_argome like '%" + ALLTRIM(V_NOTIZIA) + "%'"
   ENDIF
   IF !EMPTY(V_CODICE)
      _CampiFiltro	= _CampiFiltro + " and U2.art_cdisbn < U1.art_cdisbn"
      _x_cond	 	= _x_cond + " and art_cdisbn like '%" + ALLTRIM(V_CODICE) + "%'"
   ENDIF
   
ENDIF

IF _CampiFiltro = "U2.art_codsoc = U1.art_codsoc"
   _CampiFiltro = "U2.art_codsoc = U1.art_codsoc and M2.mag_codmag = M1.mag_codmag and U2.art_descr < U1.art_descr"
ENDIF

IF _V_OPZION=1
   _Ordine = "art_codsoc,art_datins,art_descr"
ENDIF   
IF _V_OPZION=2
   _Ordine = "art_codsoc,art_descr"
ENDIF   
IF _V_OPZION=3
   _Ordine = "art_codsoc,art_desedi,art_descr"
ENDIF   
IF _V_OPZION=4
   _Ordine = "art_codsoc,art_autore,art_descr"
ENDIF   
IF _V_OPZION=5
   _Ordine = "art_codsoc,art_catago,art_descr"
ENDIF   
IF _V_OPZION=6
   _Ordine = "art_codsoc,art_descoa,art_descr"
ENDIF   

pub_pagina = 14

_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
_Tabella 		= "u_art_pr"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1   = _x_cond 

_ii_cSql = 'EXEC sp_art000_new ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN