PARAMETERS V_NOME,V_COGNOME,V_CODPDV,V_TELEF,V_cell,V_cellAZ,V_email,V_AGN_TIPOL,V_AGN_SOCIET ,V_AGN_TELEF2,V_AGN_TELEF3,V_AGN_FAX1 ,V_aGN_FAX2 ,V_AGN_INDIR ,V_AGN_SITO,V_AGN_NOTE, V_TIPO

                     
_x_cond = "AGN_codsoc = '" + PUB_CODSOC + "'" +" and AGN_UTENTE = '" + PUB_CODOPE + "'"
_Ordine = "AGN_codsoc"


IF V_TIPO= 1

   IF !EMPTY(V_NOME)
      _x_cond = _x_cond + " and AGN_NOME like '" + ALLTRIM(V_NOME) + "%'"
   ENDIF
   IF !EMPTY(V_COGNOME)
      _x_cond = _x_cond + " and AGN_COGNOME like '" + ALLTRIM(V_COGNOME) + "%'"
   ENDIF
   IF !EMPTY(V_CODPDV)
      _x_cond = _x_cond + " and AGN_CODPDV like '" + ALLTRIM(V_CODPDV) + "%'"
   ENDIF
   IF !EMPTY(V_TELEF)
      _x_cond = _x_cond + " and AGN_TELEF like '" + ALLTRIM(V_TELEF) + "%'"
   ENDIF
   IF !EMPTY(V_cell)
      _x_cond = _x_cond + " and AGN_CELL like '" + ALLTRIM(V_cell) + "%'"
   ENDIF
   IF !EMPTY(V_cellAZ)
      _x_cond = _x_cond + " and AGN_CELLAZ like '" + ALLTRIM(V_cellAZ) + "%'"
   ENDIF
   IF !EMPTY(V_EMAIL)
      _x_cond = _x_cond + " and AGN_EMAIL like '" + ALLTRIM(V_EMAIL) + "%'"
   ENDIF 
   IF !EMPTY(V_AGN_TIPOL)
    _x_cond = _x_cond + " and AGN_tipol like '" + ALLTRIM(V_AGN_TIPOL) + "%'"
   ENDIF  
   IF !EMPTY(V_AGN_SOCIET)
   _x_cond = _x_cond + " and AGN_SOCIET like '" + ALLTRIM(V_AGN_SOCIET) + "%'"
   ENDIF    
   IF !EMPTY(V_AGN_TELEF2)
    _x_cond = _x_cond + " and AGN_TELEF2 like '" + ALLTRIM(V_AGN_TELEF2) + "%'"
   ENDIF  
   IF !EMPTY(V_AGN_TELEF3)
    _x_cond = _x_cond + " and AGN_TELEF3 like '" + ALLTRIM(V_AGN_TELEF3) + "%'"
   ENDIF    
   IF !EMPTY(V_AGN_FAX1)
   _x_cond = _x_cond + " and AGN_FAX1 like '" + ALLTRIM(V_AGN_FAX1) + "%'"
   ENDIF     
   IF !EMPTY(V_aGN_FAX2)
   _x_cond = _x_cond + " and AGN_FAX2 like '" + ALLTRIM(V_AGN_FAX2) + "%'"
   ENDIF     
   IF !EMPTY(V_AGN_INDIR)
   _x_cond = _x_cond + " and AGN_INDIR like '" + ALLTRIM(V_AGN_INDIR) + "%'"
   ENDIF     
   IF !EMPTY(V_AGN_SITO)
    _x_cond = _x_cond + " and AGN_SITO like '" + ALLTRIM(V_AGN_SITO) + "%'"
   ENDIF   
   IF !EMPTY(V_AGN_NOTE)
   _x_cond = _x_cond + " and AGN_NOTE like '" + ALLTRIM(V_AGN_note) + "%'"
   ENDIF  
   
   
ELSE
   
   IF !EMPTY(V_NOME)
      _x_cond = _x_cond + " and AGN_NOME like '%" + ALLTRIM(V_NOME) + "%'"
   ENDIF
   IF !EMPTY(V_COGNOME)
      _x_cond = _x_cond + " and AGN_COGNOME like '%" + ALLTRIM(V_COGNOME) + "%'"
   ENDIF
   IF !EMPTY(V_CODPDV)
      _x_cond = _x_cond + " and AGN_CODPDV like '%" + ALLTRIM(V_CODPDV) + "%'"
   ENDIF
   IF !EMPTY(V_TELEF)
      _x_cond = _x_cond + " and AGN_TELEF like '%" + ALLTRIM(V_TELEF) + "%'"
   ENDIF
   IF !EMPTY(V_EMAIL)
      _x_cond = _x_cond + " and AGN_EMAIL like '%" + ALLTRIM(V_EMAIL) + "%'"
   ENDIF
   IF !EMPTY(V_cell)
      _x_cond = _x_cond + " and AGN_CELL like '%" + ALLTRIM(V_cell) + "%'"
   ENDIF
   IF !EMPTY(V_cellAZ)
      _x_cond = _x_cond + " and AGN_CELLAZ like '%" + ALLTRIM(V_cellAZ) + "%'"
   ENDIF
   IF !EMPTY(V_AGN_TIPOL)
    _x_cond = _x_cond + " and AGN_tipol like '%" + ALLTRIM(V_AGN_TIPOL) + "%'"
   ENDIF  
   IF !EMPTY(V_AGN_SOCIET)
   _x_cond = _x_cond + " and AGN_SOCIET like '%" + ALLTRIM(V_AGN_SOCIET) + "%'"
   ENDIF    
   IF !EMPTY(V_AGN_TELEF2)
    _x_cond = _x_cond + " and AGN_TELEF2 like '%" + ALLTRIM(V_AGN_TELEF2) + "%'"
   ENDIF  
   IF !EMPTY(V_AGN_TELEF3)
    _x_cond = _x_cond + " and AGN_TELEF3 like '%" + ALLTRIM(V_AGN_TELEF3) + "%'"
   ENDIF    
   IF !EMPTY(V_AGN_FAX1)
   _x_cond = _x_cond + " and AGN_FAX1 like '%" + ALLTRIM(V_AGN_FAX1) + "%'"
   ENDIF     
   IF !EMPTY(V_aGN_FAX2)
   _x_cond = _x_cond + " and AGN_FAX2 like '%" + ALLTRIM(V_AGN_FAX2) + "%'"
   ENDIF     
   IF !EMPTY(V_AGN_INDIR)
   _x_cond = _x_cond + " and AGN_INDIR like '%" + ALLTRIM(V_AGN_INDIR) + "%'"
   ENDIF     
   IF !EMPTY(V_AGN_SITO)
    _x_cond = _x_cond + " and AGN_SITO like '%" + ALLTRIM(V_AGN_SITO) + "%'"
   ENDIF   
   IF !EMPTY(V_AGN_NOTE)
   _x_cond = _x_cond + " and AGN_NOTE like '%" + ALLTRIM(V_AGN_note) + "%'"
   ENDIF  
ENDIF

IF _V_OPZION=1
   _Ordine = "AGN_codsoc,AGN_NOME"
ENDIF   
IF _V_OPZION=2
   _Ordine = "AGN_codsoc,AGN_COGNOME"
ENDIF   
IF _V_OPZION=3
   _Ordine = "AGN_codsoc,AGN_EMAIL"
ENDIF   
IF _V_OPZION=4
   _Ordine = "AGN_codsoc,AGN_TELEF"
ENDIF   
IF _V_OPZION=5
   _Ordine = "AGN_codsoc,AGN_CELL"
ENDIF   
IF _V_OPZION=6
   _Ordine = "AGN_codsoc,AGN_cellaz"
ENDIF   
IF _V_OPZION=7
   _Ordine = "AGN_codsoc,AGN_TIPOL"
ENDIF  
  IF _V_OPZION=8
   _Ordine = "AGN_codsoc,AGN_SOCIET"
ENDIF  
  IF _V_OPZION=9
   _Ordine = "AGN_codsoc,AGN_TELEF2"
ENDIF  
    IF _V_OPZION=10
   _Ordine = "AGN_codsoc,AGN_TELEF3"
ENDIF  
    IF _V_OPZION=11
   _Ordine = "AGN_codsoc,AGN_FAX1"
ENDIF  
   IF _V_OPZION=12
   _Ordine = "AGN_codsoc,AGN_FAX2"
ENDIF  
  IF _V_OPZION=13
   _Ordine = "AGN_codsoc,AGN_INDIR"
ENDIF  
IF _V_OPZION=14
   _Ordine = "AGN_codsoc,AGN_SITO"
ENDIF 
IF _V_OPZION=15
   _Ordine = "AGN_codsoc,AGN_NOTE"
ENDIF 


IF alltrim(V_COGNOME)="TUTTO"				&&  OPZIONE DI SCELTA TUTTI I MOVIMENTI
    V_COGNOME = ""
	M.AGN_COGNOME = ""
	_x_cond = "AGN_codsoc = '" + PUB_CODSOC + "'" +" and AGN_UTENTE = '" + PUB_CODOPE + "'"
	_Ordine = "AGN_COGNOME"
	_ii_cSql = "select * from u_aGN_AN  where " + _x_cond + " order by " + _Ordine
ELSE
	*_ii_cSql = "select * from u_art_pr AS U1 INNER JOIN u_mag_an as M1 on U1.art_codsoc = M1.mag_codsoc	and U1.art_codpri = M1.mag_codart where " + _x_cond + " order by " + _Ordine
	*_ii_cSql = "select * from u_art_pr AS U1 LEFT OUTER JOIN u_mag_an as M1 on U1.art_codsoc = M1.mag_codsoc and U1.art_codpri = M1.mag_codart where " + _x_cond + " order by " + _Ordine
	_ii_cSql = "select * from u_aGN_AN  where " + _x_cond + " order by " + _Ordine
ENDIF


RETURN