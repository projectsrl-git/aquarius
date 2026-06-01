

**********************************************************************************************************
FUNCTION OK_LISTINO_CLIENTE_TIPO_PRODOTTO_SPESSORE
**********************************************************************************************************
**
**  DETERMINA IL PREZZO DI VENDITA PER CLIENTE /TIPO PRODOTTO / SPESSORE
**
**
**  	SE TIPO PRODOTTO NOBILITATO ACCESSO A U_LIS_TS PER:
**		===================================================
**
**
**			1) CLIENTE + TIPO PRODOTTO + SPESSORE + GRUPPO COLORE (A/B/C/D/E/F/G)
**			in questo caso è un listino specifico per il cliente
** 
**			2) TIPO PRODOTTO + SPESSORE + GRUPPO COLORE (A/B/C/D/E/F/G)
**			in questo caso è un listino generico per tutti i clienti
**
**
**			SE NON ESISTE UN PREZZO DI LISTINO PER QUESTI DUE ALLORA SI PROVA AD ACCEDERE PER :
**
**			3) CLIENTE + TIPO PRODOTTO + SPESSORE 
**			in questo caso è un listino specifico per il cliente
**			 
**			4) TIPO PRODOTTO + SPESSORE
**			in questo caso è un listino generico per tutti i clienti
**
**
**  	SE TIPO PRODOTTO GREZZO ACCESSO A U_LIS_TS PER:
**		===============================================
**
**			3) CLIENTE + TIPO PRODOTTO + SPESSORE 
**			in questo caso è un listino specifico per il cliente
**			 
**			4) TIPO PRODOTTO + SPESSORE
**			in questo caso è un listino generico per tutti i clienti
**
**  RITORNA :
**
**		-  PUB_PREZZO/M.ORD_PREZZO : CONTENENTE L'ULTIMO PREZZO DI LISTINO VALIDO
**					
**

PARA _SOC,_CLI,_ART,_DTDO,_TIPO

IF SUBSTR(_DTDO,3,1) = '/'
ELSE
   _DTDO = RIBALTA2(_DTDO)
ENDIF

S_S=STR(SELECT())

local_cliente = _CLI
local_data_listino = _DTDO

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

	local_spesso 	= ""				&& spessore
	local_tipoG  	= ""				&& flag tipo prodotto grezzo
	local_tipoN  	= ""				&& flag tipo prodotto nobilitato
	local_codcol 	= ""   				&& colore anteriore
	local_codcolret	= ""				&& colore retro
	

ELSE

	local_spesso 	= art_spesso		&& spessore
	local_tipoG  	= art_tipoG			&& flag tipo prodotto grezzo
	local_tipoN  	= art_tipoN			&& flag tipo prodotto nobilitato
	local_codcol 	= art_codcol   		&& colore anteriore
	local_codcolret	= art_codcolret		&& colore retro
	

ENDIF  		

IF !EMPTY(local_tipoG)  				&& tipo prodotto grezzo
    lpcal_flaggn = "G"					&& identifica il prodotto grezzo
	=accesso_u_lis_ts(local_cliente,local_flaggn,local_tipoG,local_spesso,local_data_listino)
	SELECT &S_S
	RETURN
ENDIF


SELECT &S_S

RETURN




****************************************************************************
FUNCTION accesso_u_lis_ts
****************************************************************************
PARAMETERS ___l_cliente,___l_flaggn,___l_tipoG,___l_spesso,___l_data_listino 

*!*	accesso per cliente / tipo prodotto /spessore

x_soci   = "lis_codsoc = '" + PUB_CODSOC + "'"
x_clie   = "lis_codcli = '" + ALLTRIM(___l_cliente) + "'"
x_flaggn = "lis_flaggn = '" + ALLTRIM(___l_flaggn) + "'"
x_tipopr = "lis_tipopr = '" + ALLTRIM(___l_tipoG) + "'"
x_spesso = "lis_spesso = '" + ALLTRIM(___l_spesso) + "'"
x_data   =  " '"+RIBALTA2(___l_data_listino)+"' between lis_datada and lis_dataal"

x_cond = x_soci + " and " + x_clie + " and " + x_flaggn + " and " + x_tipopr + " and " + x_spesso + " and " + x_data

Csql   = "select * from U_LIS_TS where " + x_cond + " order by lis_codsoc,lis_codcli,lis_tipopr"
IF !ExecCommand(cSql,"TMP1_TS")
   return(.f.)
ENDIF
SELECT TMP1_TS
GO TOP 
IF !EOF()    						

	PUB_PREZZO		= LIS_PREZZO
	M.ORD_PREZZO	= LIS_PREZZO
	
ENDIF          


RETURN