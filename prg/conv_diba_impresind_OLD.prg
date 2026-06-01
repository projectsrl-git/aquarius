*************************************************************************************************
*							CONVERSIONE DISTINTE BASE   										*
*							 																	*
*	by Project S.r.l.																			*
*	luglio 2016 : Impresind				 														*
*************************************************************************************************

** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "IMP"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'IMP' non configurato" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	USE
	RETURN .F.
ENDIF

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH


RIT = MESSAGEBOX("Conversione Distinte Base da .DBF : " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2003 IN POI NON FUNZIONA
gcFile = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF



*!*	RIT = MESSAGEBOX("Desideri cancellare le Distinte Base esistenti?" + REPLICATE(CHR(13),2) + ;
*!*			 "Continuare?",4+32+256,"ATTENZIONE")
*!*			
*!*	IF RIT <> 7
	WAIT WINDOWS "Cancellazione vecchie Distinte Base in corso..." NOWAIT

	cSql = "DELETE FROM U_DIS_TT"
	IF !ExecCommand(cSql,"DEL_DIS_TT")
	   return
	ENDIF

	cSql = "DELETE FROM U_DIS_DD"
	IF !ExecCommand(cSql,"DEL_DIS_DD")
	   return
	ENDIF
*!*	ENDIF 


WAIT WINDOWS "Conversione Distinte Base in corso..." NOWAIT		

CREATE CURSOR IMPORTADBF ( ;
	CODART   C(20), ;
	DISPAD   C(20), ;
	ORDINE   C(1), ;
	NUMERO   N(11), ; 
	CODCOM   C(20), ;
	NUMLEV   C(4), ;
	DESCOM   C(40), ;
	DESFAS   C(40), ;
	UNIMIS   C(3), ;
	UMDIS    C(3), ;
	QTANET   N(17,6), ; 
	QTANET1  N(17,6), ; 
	PERSCA   N(17,2), ; 
	PERSFR   N(17,2), ; 
	QTALOR   N(17,6), ; 
	QTALO1   N(17,6), ; 
	QTAFIN   N(17,6), ; 
	QTAFIN1  N(17,6), ; 
	RECSCA   N(17,2), ; 
	RECSFR   N(17,2), ; 
	PERRIC   N(17,2), ; 
	FLVARI   C(1), ;
	FLESPL   C(1), ;
	CODDIS   C(20), ;
	ARTCOM   C(20), ;
	PERCOS   N(17,2), ; 
	CODRES   C(20), ;
	FLCOMP   C(1), ;
	FLSETU   C(1), ;
	LVLKEY   C(200), ;
	PROPRE   C(1), ;
	COSTO    N(17,6), ; 
	COSREC   N(17,6), ; 
	LIVELLO  N(11), ; 
	COSUNISE N(17,6), ; 
	COSCIC   N(17,6), ; 
	COSSETU  N(17,6), ; 
	CSTANDR  N(17,6), ; 
	CMEDIO   N(17,6), ; 
	CULTIM   N(17,6), ; 
	EVASOCL  C(1), ;
	COSTOCL  N(17,6), ; 
	LFCODFOR C(15), ;
	RAGGRUPP N(17,6), ; 
	PRLOTMED N(17,6), ; 
	DESPAD   C(40))



_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "'"
&_COMMAND



_LIVELLO = -1
_TOT_COUNT = 0

_GRUPPO = ""
_AGGANCIO = ""

CREATE CURSOR CU_GRUPPI (LIVELLO N(10,0), GRUPPO C(16), AGGANCIO C(10))
INDEX ON ALLTRIM(STR(LIVELLO,3,0)) TAG I_LIVELLO

CREATE CURSOR CU_GRUPPI_CREATI (GRUPPO C(16), FLG_COMPLETED L)
INDEX ON ALLTRIM(GRUPPO) TAG I_GRUPPO

SELECT IMPORTADBF
GO TOP

DO WHILE .T.
	IF EOF()
		EXIT
	ENDIF
	
    IF RECNO() = 1  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
    	SKIP +1
		LOOP
    ENDIF
    
    SCATTER MEMVAR MEMO
    

    IF M.LIVELLO = -1   && SCARTO RECORD NON SIGNIFICATIVI
    	SELECT IMPORTADBF
    	SKIP +1
    	LOOP
    ENDIF
    

    IF EMPTY(M.DISPAD) && SCARTO RECORD NON SIGNIFICATIVI
    	SELECT IMPORTADBF
    	SKIP +1
    	LOOP
    ENDIF    
    

    
    *** SE LIVELLO MINORE DI QUELLO PRECEDENTE, CHIUDO TUTTI I GRUPPI DEI LIVELLI PRECEDENTI
    IF M.LIVELLO < _LIVELLO
    	FOR _i = (_LIVELLO - 1) TO (M.LIVELLO) STEP -1
    		_cNomevar = "_ULT_GRUPPO_DETT_LIV_" + ALLTRIM(STR(_i,3,0))
    		IF TYPE(_cNomevar) == 'C'
				SELECT CU_GRUPPI_CREATI
				SET ORDER TO I_GRUPPO
				GO TOP
				SEEK ALLTRIM(&_cNomevar)
				IF FOUND()
					REPLACE FLG_COMPLETED WITH .T.
				ENDIF
			ENDIF
		NEXT
	ENDIF
    
    IF M.LIVELLO <> _LIVELLO
    	
    	_LIVELLO = M.LIVELLO
    	
		
    	IF IDENTIFICA_ARTICOLO(ALLTRIM(M.CODCOM))  <> 'A'	&& PER SOLI ARTICOLI NON DI ACQUISTO/MATERIE PRIME

			
			_SEEK = ALLTRIM(STR(_LIVELLO,3,0))
			_AGGANCIO = SYS(2015)
			
			SELECT CU_GRUPPI
			SET ORDER TO I_LIVELLO
			GO TOP
			SEEK _SEEK
			IF !FOUND()
				APPEND BLANK
				REPLACE LIVELLO WITH _LIVELLO
			ENDIF
			
			REPLACE GRUPPO WITH ALLTRIM(M.CODCOM)
			REPLACE AGGANCIO WITH SYS(2015)
			
			_GRUPPO   = ALLTRIM(GRUPPO)
			_AGGANCIO = ALLTRIM(AGGANCIO)
			
			SELECT CU_GRUPPI_CREATI
			SET ORDER TO I_GRUPPO
			GO TOP
			SEEK _GRUPPO
			IF !FOUND()
				
				SELECT IMPORTADBF
				
				WAIT WINDOWS "Conversione Distinta Base Gruppo " + ALLTRIM(M.CODCOM) + " (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
				
				__DIT_CODSOC 	= PUB_CODSOC
				__TAGGANCIO 	= _AGGANCIO
				__DIT_GRUPPO 	= _GRUPPO
				__DIT_NOTE 		= ""
				__DIT_DESCRI 	= ""
				__DIT_UM 		= ""
				__DIT_MAGA 		= ""
				__DIT_CODIVA 	= ""
				__DIT_LINEA 	= ""
					
				x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
				x_codi = "ART_CODPRI = '" + __DIT_GRUPPO + "'"
				x_cond = x_soci + " and " + x_codi
				cSql = "SELECT ART_CODPRI,ART_DESCR,ART_UMMAGA,ART_MAGA,ART_CODIVA,ART_LINEA FROM U_ART_PR WHERE " + x_cond
				IF !ExecCommand(cSql,"CX_ART_PR")
					RETURN .F.
				ENDIF
				SELECT CX_ART_PR
				GO TOP
				IF !EOF()
					__DIT_DESCRI 	= ART_DESCR
					__DIT_UM 		= ART_UMMAGA
					__DIT_MAGA 		= ART_MAGA
					__DIT_CODIVA 	= ART_CODIVA
					__DIT_LINEA 	= ART_LINEA
				ELSE
					
					DO CONV_DIBA_IMPRESIND_CREA_ARTICOLO
					
					x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
					x_codi = "ART_CODPRI = '" + __DIT_GRUPPO + "'"
					x_cond = x_soci + " and " + x_codi
					cSql = "SELECT ART_CODPRI,ART_DESCR,ART_UMMAGA,ART_MAGA,ART_CODIVA,ART_LINEA FROM U_ART_PR WHERE " + x_cond
					IF !ExecCommand(cSql,"CX_ART_PR")
						RETURN .F.
					ENDIF
					SELECT CX_ART_PR
					GO TOP
					IF !EOF()
						__DIT_DESCRI 	= ART_DESCR
						__DIT_UM 		= ART_UMMAGA
						__DIT_MAGA 		= ART_MAGA
						__DIT_CODIVA 	= ART_CODIVA
						__DIT_LINEA 	= ART_LINEA
					ELSE
						MESSAGEBOX("Impossibile creare l'articolo " + __DIT_GRUPPO,48,"Attenzione")
					ENDIF
					
				ENDIF
				
				cSql = "SELECT * FROM U_DIS_TT WHERE 1=0"
				IF !ExecRW(cSql,"U_DIS_TT","R")
				   return
				ENDIF
				SELECT U_DIS_TT
				GO TOP
				APPEND BLANK
				REPLACE DIT_CODSOC 	WITH __DIT_CODSOC 
				REPLACE TAGGANCIO 	WITH __TAGGANCIO 
				REPLACE DIT_GRUPPO 	WITH __DIT_GRUPPO 
				REPLACE DIT_NOTE 	WITH __DIT_NOTE 
				REPLACE DIT_DESCRI 	WITH __DIT_DESCRI 
				REPLACE DIT_UM 		WITH __DIT_UM 
				REPLACE DIT_MAGA 	WITH __DIT_MAGA 
				REPLACE DIT_CODIVA 	WITH __DIT_CODIVA 
				REPLACE DIT_LINEA 	WITH __DIT_LINEA
				IF !ExecRW(cSql,"U_DIS_TT","W")
				   return
				ENDIF
				
				SELECT CU_GRUPPI_CREATI
				APPEND BLANK
				REPLACE GRUPPO WITH __DIT_GRUPPO
				REPLACE FLG_COMPLETED WITH .F.
				
				_TOT_COUNT = _TOT_COUNT + 1
				
			ENDIF
			
			IF _LIVELLO > 0
			ELSE
				SELECT IMPORTADBF
				SKIP +1
				LOOP
			ENDIF
			
			
		ENDIF
		
	ENDIF
	
	_GRUPPO = ""
	_AGGANCIO = ""
	_SEEK = ALLTRIM(STR(_LIVELLO - 1,3,0))
	
	SELECT CU_GRUPPI
	SET ORDER TO I_LIVELLO
	GO TOP
	SEEK _SEEK
	IF !FOUND()
		SELECT IMPORTADBF
		SKIP +1
		LOOP
	ENDIF
	_GRUPPO = ALLTRIM(GRUPPO)
	_AGGANCIO = ALLTRIM(AGGANCIO)
	
	
	SELECT CU_GRUPPI_CREATI
	SET ORDER TO I_GRUPPO
	GO TOP
	SEEK _GRUPPO
	IF FOUND()
		IF !FLG_COMPLETED  && CONTINUA A SCRIVERE I DETTAGLI DEL GRUPPO SOLO SE NON GIA' COMPLETATI PRECEDENTEMENTE
		ELSE
			SELECT IMPORTADBF
			SKIP +1
			LOOP		
		ENDIF
	ELSE
		SELECT IMPORTADBF
		SKIP +1
		LOOP
	ENDIF
	
	_cNomevar = "_ULT_GRUPPO_DETT_LIV_" + ALLTRIM(STR(_LIVELLO - 1,3,0))
	&_cNomevar = _GRUPPO
	
	__DIS_SEQUEN 	= M.NUMERO
	__DAGGANCIO 	= _AGGANCIO 
	__DIS_GRUPPO 	= _GRUPPO 
	__DIS_CODART 	= ALLTRIM(M.CODCOM)
	__DIS_QTA 		= M.QTANET
	__DIS_NOTE 		= ""
	__DIS_DESCRI 	= ""
	__DIS_UM 		= ""
	__DIS_MAGA 		= ""
	__COSTO			= M.CULTIM


	

*!*		__DIS_TIPO 		= IIF(ALLTRIM(M.ARTIPART) = 'PH','A','G')
*!*		__DIS_FITTIZ 	= IIF(ALLTRIM(M.ARTIPART) = 'PH',.T.,.F.)
		
	IF IDENTIFICA_ARTICOLO(ALLTRIM(M.CODCOM))  = 'A'	
		__DIS_TIPO 		= 'A'	&& MATERIA PRIMA ACQUISTATA		
		__DIS_FITTIZ 	= .T.	&& MATERIA PRIMA ACQUISTATA
	ELSE 
		__DIS_TIPO 		= 'G'	&& GRUPPO DI.BA
		__DIS_FITTIZ 	= .F.	&& GRUPPO DI.BA
	ENDIF
	

	x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "ART_CODPRI = '" + __DIS_CODART + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT ART_CODPRI,ART_DESCR,ART_UMMAGA,ART_MAGA,ART_PRZVEN,ART_COSLAI,ART_COSLAE,ART_COSMAT,ART_COSATR,ART_RICLAI,ART_RICLAE,ART_RICMAT,ART_RICATR FROM U_ART_PR WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_ART_PR")
		RETURN .F.
	ENDIF
	SELECT CX_ART_PR
	GO TOP
	IF !EOF()
		__DIS_DESCRI 	= ART_DESCR
		__DIS_UM 		= ART_UMMAGA
		__DIS_MAGA 		= ART_MAGA
		__PREZZO		= ART_PRZVEN	
		__COSLAI        = ART_COSLAI	
		__COSLAE        = ART_COSLAE	
		__COSMAT        = ART_COSMAT	
		__COSATR        = ART_COSATR	
		__RICLAI        = ART_RICLAI	
		__RICLAE        = ART_RICLAE	
		__RICMAT        = ART_RICMAT	
		__RICATR        = ART_RICATR	 
		
	ELSE
		
		DO CONV_DIBA_IMPRESIND_CREA_ARTICOLO


		__PREZZO		= 0	
		__COSLAI        = 0	
		__COSLAE        = 0	
		__COSMAT        = 0	
		__COSATR        = 0	
		__RICLAI        = 0	
		__RICLAE        = 0	
		__RICMAT        = 0	
		__RICATR        = 0	
		
		x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
		x_codi = "ART_CODPRI = '" + __DIS_CODART + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "SELECT ART_CODPRI,ART_DESCR,ART_UMMAGA,ART_MAGA FROM U_ART_PR WHERE " + x_cond
		IF !ExecCommand(cSql,"CX_ART_PR")
			RETURN .F.
		ENDIF
		SELECT CX_ART_PR
		GO TOP
		IF !EOF()
			__DIS_DESCRI 	= ART_DESCR
			__DIS_UM 		= ART_UMMAGA
			__DIS_MAGA 		= ART_MAGA
		ELSE
			MESSAGEBOX("Impossibile creare l'articolo " + __DIS_CODART,48,"Attenzione")
		ENDIF
	ENDIF
	
	cSql = "SELECT * FROM U_DIS_DD WHERE 1=0"
	IF !ExecRW(cSql,"U_DIS_DD","R")
	   return
	ENDIF
	SELECT U_DIS_DD
	APPEND BLANK

	REPLACE DIS_SEQUEN 	WITH __DIS_SEQUEN 
	REPLACE DAGGANCIO 	WITH __DAGGANCIO 
	REPLACE DIS_GRUPPO 	WITH __DIS_GRUPPO 
	REPLACE DIS_CODART 	WITH __DIS_CODART 
	REPLACE DIS_QTA 	WITH __DIS_QTA 
	REPLACE DIS_NOTE 	WITH __DIS_NOTE 
	REPLACE DIS_DESCRI 	WITH __DIS_DESCRI 
	REPLACE DIS_UM 		WITH __DIS_UM 
	REPLACE DIS_MAGA 	WITH __DIS_MAGA 
	REPLACE DIS_TIPO 	WITH __DIS_TIPO 
	REPLACE DIS_FITTIZ 	WITH __DIS_FITTIZ
	
	REPLACE DIS_COSTO   WITH __COSTO
	REPLACE DIS_PREZZO  WITH __PREZZO	&& DA ANAGRAFICA ARTICOLI
	REPLACE DIS_COSLAI  WITH __COSLAI	&& DA ANAGRAFICA ARTICOLI
	REPLACE DIS_COSLAE  WITH __COSLAE	&& DA ANAGRAFICA ARTICOLI
	REPLACE DIS_COSMAT  WITH __COSMAT	&& DA ANAGRAFICA ARTICOLI
	REPLACE DIS_COSATR  WITH __COSATR	&& DA ANAGRAFICA ARTICOLI

	REPLACE DIS_RICLAI  WITH __RICLAI	&& DA ANAGRAFICA ARTICOLI
	REPLACE DIS_RICLAE  WITH __RICLAE	&& DA ANAGRAFICA ARTICOLI
	REPLACE DIS_RICMAT  WITH __RICMAT	&& DA ANAGRAFICA ARTICOLI
	REPLACE DIS_RICATR  WITH __RICATR	&& DA ANAGRAFICA ARTICOLI 
	
	
	
	IF !ExecRW(cSql,"U_DIS_DD","W")
	   return
	ENDIF
	
	SELECT IMPORTADBF
	SKIP +1
	
ENDDO


WAIT WINDOWS "Rinumerazione sequenza dettagli Distinte Base in corso..." NOWAIT

cSql = "SELECT * FROM U_DIS_TT"
IF !ExecCommand(cSql,"CX_DIS_TT")
   return
ENDIF
SELECT CX_DIS_TT
GO TOP
SCAN

	WAIT WINDOWS "Rinumerazione sequenza dettagli Distinte Base Gruppo " + ALLTRIM(DIT_GRUPPO) + " (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	__DIS_SEQUEN = 0
	
	__TAGGANCIO = TAGGANCIO 
	__DIT_GRUPPO = DIT_GRUPPO
	x_agga = "DAGGANCIO = '" + __TAGGANCIO + "'"
	x_grup = "DIS_GRUPPO = '" + __DIT_GRUPPO + "'"
	x_cond = x_agga + " and " + x_grup 
	cSql = "SELECT * FROM U_DIS_DD WHERE " + x_cond + " ORDER BY DIS_CODART"
	IF !ExecRW(cSql,"U_DIS_DD","R")
	   return
	ENDIF
	SELECT U_DIS_DD
	GO TOP
	SCAN
		__DIS_SEQUEN = __DIS_SEQUEN + 10
		REPLACE DIS_SEQUEN WITH __DIS_SEQUEN
	ENDSCAN
	IF !ExecRW(cSql,"U_DIS_DD","W")
	   return
	ENDIF

ENDSCAN


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale gruppi convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN



*************************************************************************************
PROCEDURE CONV_DIBA_IMPRESIND_CREA_ARTICOLO
*************************************************************************************

M.ART_CODSOC = PUB_CODSOC
M.ART_CODPRI = ALLTRIM(M.CODCOM)
M.ART_DESCR  = APITOSPA(ALLTRIM(M.DESCOM))
M.ART_CATMER = ""
M.ART_UNIMIS = IIF(EMPTY(M.UNIMIS),"NR",ALLTRIM(M.UNIMIS))
M.ART_UMMAGA = IIF(EMPTY(M.UNIMIS),"NR",ALLTRIM(M.UNIMIS))
M.ART_CODIVA = PUB_IVA

IF M.NUMERO = 0	&& E' UN GRUPPO DI DISTINTA BASE
	M.ART_LINEA = 'PF'
ELSE
	M.ART_LINEA = 'MP'
ENDIF
	
M.ART_CHDIBA = .F.
	
DO CASE
	CASE M.ART_LINEA = "MP"
		M.ART_TIPART = 'A'
	CASE M.ART_LINEA = "SE"
		M.ART_TIPART = 'P'
	CASE M.ART_LINEA = "PF"
		M.ART_TIPART = 'P'
	OTHERWISE
		M.ART_TIPART = 'A'
ENDCASE

M.ART_MAGA = "SEDE"
M.ART_CODMAT = "001"

M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
M.ART_DATINS = RIBALTA2(DTOC(DATE()))

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"VERIFICA_ART_PR")
   RETURN .F.
ENDIF
SELECT VERIFICA_ART_PR
GO TOP 
IF EOF()
	cSql = "SELECT * FROM U_ART_PR WHERE 1=0"
	IF !ExecRW(cSql,"U_ART_PR","R")
	   RETURN .F.
	ENDIF
	SELECT U_ART_PR
	APPEND BLANK
	REPLACE ART_CODSOC WITH M.ART_CODSOC 
	REPLACE ART_CODPRI WITH M.ART_CODPRI 
	REPLACE ART_DESCR  WITH M.ART_DESCR 
	REPLACE ART_CATMER WITH M.ART_CATMER 
	REPLACE ART_UNIMIS WITH M.ART_UNIMIS 
	REPLACE ART_UMMAGA WITH M.ART_UMMAGA 
	REPLACE ART_CODIVA WITH M.ART_CODIVA 
	REPLACE ART_LINEA  WITH M.ART_LINEA 
	REPLACE ART_TIPART WITH M.ART_TIPART 
	REPLACE ART_MAGA   WITH M.ART_MAGA
	REPLACE ART_CODMAT WITH M.ART_CODMAT 
	REPLACE ART_DATVAR WITH M.ART_DATVAR 
	REPLACE ART_DATINS WITH M.ART_DATINS 

	
	IF !ExecRW(cSql,"U_ART_PR","W")
	   RETURN .F.
	ENDIF
	
	cSql = "SELECT * FROM U_ART_AN WHERE 1=0"
	IF !ExecRW(cSql,"U_ART_AN","R")
	   RETURN .F.
	ENDIF
	SELECT U_ART_AN
	APPEND BLANK
	REPLACE ART_CODSOC WITH M.ART_CODSOC 
	REPLACE ART_CODPRI WITH M.ART_CODPRI
	REPLACE ART_CHDIBA WITH M.ART_CHDIBA	
	
	IF !ExecRW(cSql,"U_ART_AN","W")
	   RETURN .F.
	ENDIF
ENDIF
	
ENDPROC


******************************************************
FUNCTION IDENTIFICA_ARTICOLO
******************************************************
LPARAMETERS _CODART

	AABBSS_ART    = SELECT()
	_TIPO_ARTICOLO = 'A'
	
	_CODART_ = ALLTRIM(_CODART)
	x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "ART_CODPRI = '" + _CODART_ + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT ART_CODPRI,ART_DESCR,ART_UMMAGA,ART_TIPART FROM U_ART_PR WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_ART_PR")
		RETURN .F.
	ENDIF
	SELECT CX_ART_PR
	GO TOP
	IF !EOF()
		_TIPO_ARTICOLO 	= ART_TIPART 
	ELSE
		MESSAGEBOX("Articolo inesistente " + _CODART_,48,"Attenzione")
		_TIPO_ARTICOLO = 'A'
	ENDIF
	
	SELECT(AABBSS_ART)
	
RETURN(_TIPO_ARTICOLO)