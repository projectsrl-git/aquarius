
PARAMETERS W_CODCLI,W_RAGSOC,W_INDIRI,W_PARIVA,W_RICALT,W_RAGDUE,V_TIPO

_x_cond = "for_codsoc = '" + PUB_CODSOC + "'"
_Ordine = "for_codsoc,"


IF V_TIPO = 1

   IF !EMPTY(W_CODCLI)
      _x_cond = _x_cond + " and for_codcli like '" + ALLTRIM(W_CODCLI) + "%'"
   ENDIF
   IF !EMPTY(W_RAGSOC)
      _x_cond = _x_cond + " and for_ragsoc like '" + ALLTRIM(W_RAGSOC) + "%'"
   ENDIF
   IF !EMPTY(W_INDIRI)
      _x_cond = _x_cond + " and for_indir like '" + ALLTRIM(W_INDIRI) + "%'"
   ENDIF
   IF !EMPTY(W_PARIVA)
      _x_cond = _x_cond + " and for_pariva like '" + ALLTRIM(W_PARIVA) + "%'"
   ENDIF
   IF !EMPTY(W_RICALT)
      _x_cond = _x_cond + " and for_ricerc like '" + ALLTRIM(W_RICALT) + "%'"
   ENDIF
   IF !EMPTY(W_RAGDUE)
      _x_cond = _x_cond + " and for_ragdue like '" + ALLTRIM(W_RAGDUE) + "%'"
   ENDIF
   
ELSE
   
   IF !EMPTY(W_CODCLI)
      _x_cond = _x_cond + " and for_codcli like '%" + ALLTRIM(W_CODCLI) + "%'"
   ENDIF
   IF !EMPTY(W_RAGSOC)
      _x_cond = _x_cond + " and for_ragsoc like '%" + ALLTRIM(W_RAGSOC) + "%'"
   ENDIF
   IF !EMPTY(W_INDIRI)
      _x_cond = _x_cond + " and for_indir like '%" + ALLTRIM(W_INDIRI) + "%'"
   ENDIF
   IF !EMPTY(W_PARIVA)
      _x_cond = _x_cond + " and for_pariva like '%" + ALLTRIM(W_PARIVA) + "%'"
   ENDIF
   IF !EMPTY(W_RICALT)
      _x_cond = _x_cond + " and for_ricerc like '%" + ALLTRIM(W_RICALT) + "%'"
   ENDIF
   IF !EMPTY(W_RAGDUE)
      _x_cond = _x_cond + " and for_ragdue like '%" + ALLTRIM(W_RAGDUE) + "%'"
   ENDIF
   
ENDIF

IF _V_OPZION=1
   _Ordine = _Ordine + "for_codcli"
ENDIF   
IF _V_OPZION=2
   _Ordine = _Ordine + "for_ragsoc"
ENDIF   
IF _V_OPZION=3
   _Ordine = _Ordine + "for_indir"
ENDIF   
IF _V_OPZION=4
   _Ordine = _Ordine + "for_pariva"
ENDIF   
IF _V_OPZION=5
   _Ordine = _Ordine + "for_ricerc"
ENDIF   

*_ii_cSql = "select * from u_art_pr AS U1 INNER JOIN u_mag_an as M1 on U1.art_codsoc = M1.mag_codsoc	and U1.art_codpri = M1.mag_codart where " + _x_cond + " order by " + _Ordine
*_ii_cSql = "select * from u_art_pr AS U1 LEFT OUTER JOIN u_mag_an as M1 on U1.art_codsoc = M1.mag_codsoc and U1.art_codpri = M1.mag_codart where " + _x_cond + " order by " + _Ordine
*!*	_ii_cSql = "select *,ISNULL(mag_giacen,0) as mag_gianul from u_art_pr AS U1 LEFT OUTER JOIN u_mag_an as M1 on U1.art_codsoc = M1.mag_codsoc and U1.art_codpri = M1.mag_codart where " + _x_cond + " order by " + _Ordine

_ii_cSql = "select for_codcli,for_ragsoc,for_indir,for_cap,for_locali,for_pariva,for_ricerc,for_ragdue " + ;
           "from u_for_an where " + _x_cond + " order by " + _Ordine

RETURN