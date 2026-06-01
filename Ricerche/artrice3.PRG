PARAMETERS V_TITOLO,V_AUTORE,V_EDITORE,V_COLLANA,V_CATEGORIA,V_NOTIZIA,V_CODICE,V_TIPO

_x_cond = "art_codsoc = '" + PUB_CODSOC + "'"
_Ordine = "art_codsoc"


IF V_TIPO = 1

   IF !EMPTY(V_TITOLO)
      _x_cond = _x_cond + " and art_descr like '" + ALLTRIM(V_TITOLO) + "%'"
   ENDIF
   IF !EMPTY(V_AUTORE)
      _x_cond = _x_cond + " and art_autore like '" + ALLTRIM(V_AUTORE) + "%'"
   ENDIF
   IF !EMPTY(V_EDITORE)
      _x_cond = _x_cond + " and art_desedi like '" + ALLTRIM(V_EDITORE) + "%'"
   ENDIF
   IF !EMPTY(V_COLLANA)
      _x_cond = _x_cond + " and art_descoa like '" + ALLTRIM(V_COLLANA) + "%'"
   ENDIF
   IF !EMPTY(V_CATEGORIA)
      _x_cond = _x_cond + " and art_catago like '" + ALLTRIM(V_CATEGORIA) + "%'"
   ENDIF
   IF !EMPTY(V_NOTIZIA)
      _x_cond = _x_cond + " and art_argome like '" + ALLTRIM(V_NOTIZIA) + "%'"
   ENDIF
   IF !EMPTY(V_CODICE)
      _x_cond = _x_cond + " and art_cdisbn like '" + ALLTRIM(V_CODICE) + "%'"
   ENDIF
   
ELSE
   
   IF !EMPTY(V_TITOLO)
      _x_cond = _x_cond + " and art_descr like '%" + ALLTRIM(V_TITOLO) + "%'"
   ENDIF
   IF !EMPTY(V_AUTORE)
      _x_cond = _x_cond + " and art_autore like '%" + ALLTRIM(V_AUTORE) + "%'"
   ENDIF
   IF !EMPTY(V_EDITORE)
      _x_cond = _x_cond + " and art_desedi like '%" + ALLTRIM(V_EDITORE) + "%'"
   ENDIF
   IF !EMPTY(V_COLLANA)
      _x_cond = _x_cond + " and art_descoa like '%" + ALLTRIM(V_COLLANA) + "%'"
   ENDIF
   IF !EMPTY(V_CATEGORIA)
      _x_cond = _x_cond + " and art_catago like '%" + ALLTRIM(V_CATEGORIA) + "%'"
   ENDIF
   IF !EMPTY(V_NOTIZIA)
      _x_cond = _x_cond + " and art_argome like '%" + ALLTRIM(V_NOTIZIA) + "%'"
   ENDIF
   IF !EMPTY(V_CODICE)
      _x_cond = _x_cond + " and art_cdisbn like '%" + ALLTRIM(V_CODICE) + "%'"
   ENDIF
   
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

*_ii_cSql = "select * from u_art_pr AS U1 INNER JOIN u_mag_an as M1 on U1.art_codsoc = M1.mag_codsoc	and U1.art_codpri = M1.mag_codart where " + _x_cond + " order by " + _Ordine
*_ii_cSql = "select * from u_art_pr AS U1 LEFT OUTER JOIN u_mag_an as M1 on U1.art_codsoc = M1.mag_codsoc and U1.art_codpri = M1.mag_codart where " + _x_cond + " order by " + _Ordine
_ii_cSql = "select *,ISNULL(mag_giacen,0) as mag_gianul from u_art_pr AS U1 LEFT OUTER JOIN u_mag_an as M1 on U1.art_codsoc = M1.mag_codsoc and U1.art_codpri = M1.mag_codart where " + _x_cond + " order by " + _Ordine

RETURN