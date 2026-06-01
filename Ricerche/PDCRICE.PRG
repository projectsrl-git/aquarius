PARAMETERS V_SEEK
 

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci


IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno               
ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE CONTO

*!*			IF PUB_CONTOSIMILCEE
*	PADL(ALLTRIM(conv_toglie_punti(con_conto))),2,'0')	

	        IF PUB_VISRIC 
	           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
	           ELSE
	              x_codi   = "con_conto like '" + ALLTRIM(V_SEEK) + "%'"
	              x_cond   = x_cond + " and " + x_codi
	           ENDIF
	        ELSE
	           x_codi   = "con_conto like '" + ALLTRIM(V_SEEK) + "%'"
			   x_cond   = x_cond + " and " + x_codi
	        ENDIF
	        _ii_cSql = "select * from conti where " + x_cond + ;
	                                                 " order by con_soc,con_anno,con_conto" 


   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_descr like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_codi
			  
			  IF DOC_ANNO
				   x_cond = x_cond + " and " + x_anno               
			  ENDIF

           ENDIF
           _ii_cSql = "select * from conti where " + x_cond + ;
                                                    " order by con_soc,con_anno,con_descr" 
        ELSE
           x_codi   = "con_descr like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_codi

			  
		   IF DOC_ANNO
			   x_cond = x_cond + " and " + x_anno               
		   ENDIF



        ENDIF
        _ii_cSql = "select * from conti where " + x_cond + ;
                                                 " order by con_soc,con_anno,con_descr" 
                                                 
   CASE V_SCELTA=3                          && ACCESSO PER CATEGORIA AMMORTAMENTO (DA ANAGRAFICA)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_categ like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "con_categ like '" + ALLTRIM(V_SEEK) + "%'"
		   x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from conti where " + x_cond + ;
                                                 " order by con_soc,con_anno,con_conto"
                                                 
   CASE V_SCELTA=4                          && ACCESSO PER CATEGORIA AMMORTAMENTO (DA CESPITE)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_codamm like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "con_codamm like '" + ALLTRIM(V_SEEK) + "%'"
		   x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from conti where " + x_cond + ;
                                                 " order by con_soc,con_anno,con_conto"
                                                 
   CASE V_SCELTA=5                          && ACCESSO PER CODICE ANAGRAFICA CESPITE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_codces like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "con_codces like '" + ALLTRIM(V_SEEK) + "%'"
		   x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from conti where " + x_cond + ;
                                                 " order by con_soc,con_anno,con_conto"                                                                                                  

ENDCASE

RETURN


* ------------------------------------------------------------------------------------------
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* ------------------------------------------------------------------------------------------


PARAMETERS V_SEEK

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
_x_cond = x_soci
IF DOC_ANNO
   _x_cond = _x_cond + " and " + x_anno
ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE CONTO
		_CampiFiltro = "U2.con_soc = U1.con_soc and U2.con_conto < U1.con_conto"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond  = _x_cond + " and con_conto = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
   		_Ordine = "con_soc,con_anno,con_conto"

   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE
		_CampiFiltro = "U2.con_soc = U1.con_soc and U2.con_descr < U1.con_descr"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond  = _x_cond + " and con_descr like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
   		_Ordine = "con_soc,con_anno,con_descr"

ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
_Tabella 		= "conti"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN