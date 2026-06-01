**********************************************************************************************************
FUNCTION OK_SCONTI_CLIENTE_CATEGORIA_MERCEOLOGICA
**********************************************************************************************************
**
**  ACCESE ALLA TABELLA U_SCO_CM CON DUE MODALITA' : 
**
**
**  	1) SCONTO PER CLIENTE\CATEGORIA MERCEOLOGICA E PRELEVA GLI SCONTI DI PRIMA E/O SECONDA SCELTA
**		=============================================================================================
**
**		SE NON ESISTE
**
**  	2) SCONTO PER CATEGORIA MERCEOLOGICA E PRELEVA GLI SCONTI DI PRIMA E/O SECONDA SCELTA
**		=====================================================================================
**
**
**
**
**
**  RITORNA :
**
**		-  PUB_SC1,PUB_SC2,PUB_SC3,PUB_SC4/M.ORD_SC1,M.ORD_SC2,M.ORD_SC3,M.ORD_SC4 : SCONTI DI PRIMA E/O SECONDA CELTA
**					
**

PARA _SOC,_CLI,_ART,_DTDO

IF SUBSTR(_DTDO,3,1) = '/'
ELSE
   _DTDO = RIBALTA2(_DTDO)
ENDIF

S_S=STR(SELECT())

RELEASE _local_trovato                 && flag di sconto trovato
PUBLIC  _local_trovato                 && flag di sconto trovato
_local_trovato= .f.                    && flag di sconto trovato


local_cliente 		= _CLI
local_data_listino 	= _DTDO

* ACCESSO ALL'ANAGRAFICA ARTICOLI

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_ART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"local_cu_art_pr")
   return(.f.)
ENDIF
SELECT local_cu_art_pr
GO TOP
IF eof() 
    local_catmer    = art_catmer        && categoria merceologica
ELSE
    local_catmer    = art_catmer        && categoria merceologica
ENDIF  	

 
local_accesso	= "ACCESSO-01"														&& cliente + categoria merceologica
_local_trovato	= .f.               												&& flag di prezzo trovato
=accesso_u_u_sco_cm(local_cliente,local_catmer,local_data_listino,local_accesso)
IF _local_trovato
	select &s_s
	return	
ENDIF 

local_accesso= "ACCESSO-02"															&& categoria merceologica
_local_trovato= .f.                 												&& flag di prezzo trovato
=accesso_u_u_sco_cm(local_cliente,local_catmer,local_data_listino,local_accesso)
IF _local_trovato
	select &s_s
	return	
ENDIF 



SELECT &S_S
RETURN


****************************************************************************
FUNCTION accesso_u_u_sco_cm
****************************************************************************
PARAMETERS ___l_cliente,___l_catmer,___l_data_listino,___l_accesso 


DO CASE

	CASE ___l_accesso = "ACCESSO-01"
			
			*!*	________________________________________________________________________1) accesso per cliente / tipo prodotto /spessore
	
			x_soci   = "sco_codsoc = '" + PUB_CODSOC + "'"
			x_clie   = "sco_codcli = '" + ALLTRIM(___l_cliente) + "'"
			x_catm   = "sco_catmer = '" + ALLTRIM(___l_catmer) + "'"
			x_data   =  " '"+RIBALTA2(___l_data_listino)+"' between sco_datlis and sco_alllist"

			x_cond = x_soci + " and " + x_clie + " and " + x_catm  + " and " + x_data

			Csql   = "select * from U_SCO_CM where " + x_cond + " order by sco_codsoc,sco_codcli,sco_catmer"
			IF !ExecCommand(cSql,"TMP1_CM")
			   return(.f.)
			ENDIF
			SELECT TMP1_CM
			GO TOP 
			IF !EOF()    	
			    PUB_SC1	= SCO_SC1
			    PUB_SC2	= SCO_SC2
			    PUB_SC3	= SCO_SC3
			    PUB_SC4	= SCO_SC4
			    
			    IF PUB_SC1 = 0		&& NON ESISTE SCONTO : SCALO DI UNO TUTTI GLI SCONTI ALLINEANDOLI A SINISTRA
			       PUB_SC1 = PUB_SC2
			       PUB_SC2 = PUB_SC3
			       PUB_SC3 = PUB_SC4	
			       PUB_SC4 = 0		     
			    ENDIF
			    
			    IF PUB_SC1 = 0		&& NON ESISTE SCONTO : SCALO DI UNO TUTTI GLI SCONTI ALLINEANDOLI A SINISTRA
			       PUB_SC1 = PUB_SC2
			       PUB_SC2 = PUB_SC3
			       PUB_SC3 = 0	
			       PUB_SC4 = 0	     
			    ENDIF

			    IF PUB_SC1 = 0		&& NON ESISTE SCONTO : SCALO DI UNO TUTTI GLI SCONTI ALLINEANDOLI A SINISTRA
			       PUB_SC1 = PUB_SC2
			       PUB_SC2 = 0
			       PUB_SC3 = 0	
			       PUB_SC4 = 0	     
			    ENDIF

			    ORD_SC1	= PUB_SC1 
			    ORD_SC2	= PUB_SC2 
			    ORD_SC3	= PUB_SC3 
			    ORD_SC4	= PUB_SC4
			     
				_local_trovato= .T.                 									&& flag di prezzo trovato
				RETURN 
			ENDIF          


	CASE ___l_accesso = "ACCESSO-02"
	

			*!*	________________________________________________________________________1) accesso per tipo prodotto /spessore
	
			x_soci   = "sco_codsoc = '" + PUB_CODSOC + "'"
			___x_cliente = ""
			x_clie   = "sco_codcli = '" + ALLTRIM(___x_cliente) + "'"
			x_catm   = "sco_catmer = '" + ALLTRIM(___l_catmer) + "'"
			x_data   =  " '"+RIBALTA2(___l_data_listino)+"' between sco_datlis and sco_alllist"

			x_cond = x_soci + " and " + x_clie + " and " + x_catm  + " and " + x_data

			Csql   = "select * from U_SCO_CM where " + x_cond + " order by sco_codsoc,sco_codcli,sco_catmer"
			IF !ExecCommand(cSql,"TMP1_CM")
			   return(.f.)
			ENDIF
			SELECT TMP1_CM
			GO TOP 
			IF !EOF()    	
			    PUB_SC1	= SCO_SC1
			    PUB_SC2	= SCO_SC2
			    PUB_SC3	= SCO_SC3
			    PUB_SC4	= SCO_SC4
			    
			    IF PUB_SC1 = 0		&& NON ESISTE SCONTO : SCALO DI UNO TUTTI GLI SCONTI ALLINEANDOLI A SINISTRA
			       PUB_SC1 = PUB_SC2
			       PUB_SC2 = PUB_SC3
			       PUB_SC3 = PUB_SC4	
			       PUB_SC4 = 0		     
			    ENDIF
			    
			    IF PUB_SC1 = 0		&& NON ESISTE SCONTO : SCALO DI UNO TUTTI GLI SCONTI ALLINEANDOLI A SINISTRA
			       PUB_SC1 = PUB_SC2
			       PUB_SC2 = PUB_SC3
			       PUB_SC3 = 0	
			       PUB_SC4 = 0	     
			    ENDIF

			    IF PUB_SC1 = 0		&& NON ESISTE SCONTO : SCALO DI UNO TUTTI GLI SCONTI ALLINEANDOLI A SINISTRA
			       PUB_SC1 = PUB_SC2
			       PUB_SC2 = 0
			       PUB_SC3 = 0	
			       PUB_SC4 = 0	     
			    ENDIF

			    ORD_SC1	= PUB_SC1 
			    ORD_SC2	= PUB_SC2 
			    ORD_SC3	= PUB_SC3 
			    ORD_SC4	= PUB_SC4
			     
				_local_trovato= .T.                 									&& flag di prezzo trovato
				RETURN 
			ENDIF          




	ENDCASE
	

RETURN
