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

	CASE V_SCELTA=1          				&& ACCESSO PER DATA SOLARE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data_solar = "data_solar = '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data_solar
           ENDIF
        ELSE
           x_data_solar = "data_solar = '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data_solar
        ENDIF
        _ii_cSql   = "select * from u_ela_an where " + x_cond + ;
                                                   " order by data_solar" 

	

	CASE V_SCELTA=2          				&& ACCESSO PER DATA ELABORAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dataela = "dataela_01 ='" + ribalta2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_dataela
           ENDIF
        ELSE
           x_dataela= "dataela_01 = '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_dataela
        ENDIF
        _ii_cSql   = "select * from u_ela_an where " + x_cond + ;
                                                   " order by data_solar" 
                                                   
	
	CASE V_SCELTA=3          				&& ACCESSO PER PROCEDURA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_proc = "proc_01 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_2="proc_02 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_3="proc_03 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_4="proc_04 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_5="proc_05 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_6="proc_06 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_7="proc_07 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_8="proc_08 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_9="proc_09 like '" + ALLTRIM(V_SEEK) + "%'"
              x_proc_10="proc_10 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_proc + " or " + x_proc_2 + " or "+ x_proc_3 + " or "+ x_proc_4 +" or "+ x_proc_5 +;
              			" or "+ x_proc_6 + " or " + x_proc_7 + " or "+ x_proc_8 + " or "+ x_proc_9 +" or "+ x_proc_10 
           ENDIF
        ELSE
           x_proc = "proc_01 like '" + ALLTRIM(V_SEEK) + "%'"
	       x_proc_2="proc_02 like '" + ALLTRIM(V_SEEK) + "%'"
           x_proc_3="proc_03 like '" + ALLTRIM(V_SEEK) + "%'"
           x_proc_4="proc_04 like '" + ALLTRIM(V_SEEK) + "%'"
           x_proc_5="proc_05 like '" + ALLTRIM(V_SEEK) + "%'"
           x_proc_6="proc_06 like '" + ALLTRIM(V_SEEK) + "%'"
           x_proc_7="proc_07 like '" + ALLTRIM(V_SEEK) + "%'"
           x_proc_8="proc_08 like '" + ALLTRIM(V_SEEK) + "%'"
           x_proc_9="proc_09 like '" + ALLTRIM(V_SEEK) + "%'"
           x_proc_10="proc_10 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_proc + " or " + x_proc_2 + " or "+ x_proc_3 + " or "+ x_proc_4 +" or "+ x_proc_5 +;
              			" or "+ x_proc_6 + " or " + x_proc_7 + " or "+ x_proc_8 + " or "+ x_proc_9 +" or "+ x_proc_10 
          
        ENDIF
        _ii_cSql   = "select * from u_ela_an where " + x_cond + ;
                                                   " order by data_solar" 	                                                   

          
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

	   CASE V_SCELTA=1                          && ACCESSO PER DATA SOLARE
		_CampiFiltro = "U2.data_solar < U1.data_solar"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " data_solar = '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
		ENDIF
   		_Ordine = "data_solar"
   		_Tabella 		= "u_ela_an"


   CASE V_SCELTA=2                          && ACCESSO PER DATA ELABORAZIONE
		_CampiFiltro = "U2.dataela_01 < U1.dataela_01"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
        	
		   _x_cond  = " dataela_01 < '" + ribalta2(ALLTRIM(V_SEEK)) + "'"
		ENDIF
   		_Ordine = "data_solar"
   		_Tabella 		= "u_ela_an"

   CASE V_SCELTA=3                          && ACCESSO PER PROCEDURA
		_CampiFiltro = "U2.proc_01 < U1.proc_01"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
   		   _x_cond = "proc_01 like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
	    _Ordine = "data_solar"
	    _Tabella 		= "u_ela_an"

ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
*!*	_Tabella 		= "u_cnt_tt"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN


