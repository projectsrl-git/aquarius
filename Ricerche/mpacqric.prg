PARAMETERS V_CODART,V_DESART,V_CODFOR,V_DESFOR,V_NUMORF,V_DATORF,V_DTCAMA,V_NUMLOT,V_DTCACQ,V_RESPO1,V_RESDT1,V_RESPO2,V_RESDT2, V_TIPO
*V_TOPSEL="SELECT TOP "+ALLTRIM(STR(pub_pagina*pub_paginazione))

_x_cond =''

op_log=' and '
IF V_TIPO > 10
    v_tipo= V_TIPO-10
    op_LOG= ' OR '
ENDIF 
IF V_TIPO= 1
LK=''
ELSE 
LK="%"
ENDIF
   IF !EMPTY(V_CODART)
      _x_cond = _x_cond + OP_LOG + "MPA_CODART like '"+LK + ALLTRIM(V_CODART) + "%'"
   ENDIF
   IF !EMPTY(V_DESART)
      _x_cond = _x_cond + OP_LOG + "MPA_DESART like '"+LK + ALLTRIM(V_DESART) + "%'"
   ENDIF
   IF !EMPTY(V_CODFOR)
      _x_cond = _x_cond + OP_LOG + "MPA_CODFOR like '"+LK + ALLTRIM(V_CODFOR) + "%'"
   ENDIF
   IF !EMPTY(V_DESFOR)
      _x_cond = _x_cond + OP_LOG + "MPA_DESFOR like '"+LK + ALLTRIM(V_DESFOR) + "%'"
   ENDIF
   IF !EMPTY(V_NUMORF)
      _x_cond = _x_cond + OP_LOG + "MPA_NUMORF like '"+LK + ALLTRIM(V_NUMORF) + "%'"
   ENDIF
   IF !EMPTY(V_DATORF)
      _x_cond = _x_cond + OP_LOG + "MPA_DATORF like '"+LK + ALLTRIM(V_DATORF) + "%'"
   ENDIF   
   IF !EMPTY(V_DTCAMA)
      _x_cond = _x_cond + OP_LOG + "MPA_DTCAMA like '"+LK + ALLTRIM(V_DTCAMA) + "%'"
   ENDIF   
   IF !EMPTY(V_NUMLOT)
      _x_cond = _x_cond + OP_LOG + "MPA_NUMLOT like '"+LK + ALLTRIM(V_NUMLOT) + "%'"
   ENDIF   
   IF !EMPTY(V_DTCACQ)
      _x_cond = _x_cond + OP_LOG + "MPA_DTCACQ like '"+LK + ALLTRIM(V_DTCACQ) + "%'"
   ENDIF   
   IF !EMPTY(V_RESPO1)
      _x_cond = _x_cond + OP_LOG + "MPA_V_RESPO1 like '"+LK + ALLTRIM(V_RESPO1) + "%'"
   ENDIF   
   IF !EMPTY(V_RESDT1)
      _x_cond = _x_cond + OP_LOG + "MPA_RESDT1 like '"+LK + ALLTRIM(V_RESDT1) + "%'"
   ENDIF   
   IF !EMPTY(V_RESPO2)
      _x_cond = _x_cond + OP_LOG + "MPA_V_RESPO2 like '"+LK + ALLTRIM(V_RESPO2) + "%'"
   ENDIF   
   IF !EMPTY(V_RESDT2)
      _x_cond = _x_cond + OP_LOG + "MPA_RESDT2 like '"+LK + ALLTRIM(V_RESDT2) + "%'"
   ENDIF
*_X_tiporic V_NUMORF,V_DATORF,V_DTCAMA,V_NUMLOT,V_DTCACQ,V_RESPO1,V_RESDT1,V_RESPO2,V_RESDT2, V_TIPO


 _Ordine =LEFT(_X_CAMPI,AT(';',_X_CAMPI+';',_V_OPZION)-1)
IF _V_OPZION>1 
  _Ordine = SUBSTR(_ORDINE,AT(';',_ORDINE,_V_OPZION-1)+1)
ENDIF   

IF op_LOG= ' OR '
_x_cond=' AND ('+SUBSTR(_X_COND,5)+')'
ENDIF
_x_cond = "MPA_codsoc = '" + PUB_CODSOC + "'"  + _x_cond
_ii_cSql = "select * from u_MPA_CQ  where " + _x_cond + " order by " + _Ordine

RETURN