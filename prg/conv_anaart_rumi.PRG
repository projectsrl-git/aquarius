*************************************************************************************************
*							CONVERSIONE ANAGRAFICA ARTICOLI										*
*							 																	*
*	by Project S.r.l.																			*
*	dicembre 2013 : Rumi					 													*
*************************************************************************************************

** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "RUM"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'RUM' non configurato" + CHR(13) + CHR(13) + ;
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

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

RIT = MESSAGEBOX("Conversione anagrafica articoli da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


RIT = MESSAGEBOX("Desideri cancellare l'anagrafica articoli esistente ??" + REPLICATE(CHR(13),2) + ;
		 "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT <> 7
	WAIT WINDOWS "Cancellazione vecchia anagrafica articoli in corso..." NOWAIT

	cSql = "DELETE FROM U_ART_PR"
	IF !ExecCommand(cSql,"DEL_ART_PR")
	   return
	ENDIF

	cSql = "DELETE FROM U_ART_AN"
	IF !ExecCommand(cSql,"DEL_ART_AN")
	   return
	ENDIF
ENDIF 


CT_ESISTENTI = 0

WAIT WINDOWS "Conversione anagrafica articoli in corso..." NOWAIT		

CREATE CURSOR IMPORTAXLS ( ;
	ARCODART C(30), ;
	ARDESART C(200), ;
	CARIFCLA N(10,0), ;
	ARGRUMER C(10), ;
	ARCATOMO C(2), ;
	ARCODFAM C(2), ;
	ARCATCON C(10), ;
	ARCODIVA C(20), ;
	ARUNMIS1 C(3), ;
	ARTIPART C(2), ;
	CACMPCAR C(20))

APPEND FROM (gcFile) TYPE XLS

_TOT_COUNT = 0

SELECT IMPORTAXLS
GO TOP 
SCAN   

    IF ALLTRIM(ARCODART) = "ARCODART"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
		LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
    
	WAIT WINDOWS "Conversione Articolo " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
	
	cSql = "SELECT * FROM U_ART_PR WHERE 1=0"
	IF !ExecCommand(cSql,"CX_ART_PR")
	   RETURN .F.
	ENDIF
	
	SCATTER MEMVAR MEMO BLANK
	
	M.ART_CODSOC = PUB_CODSOC
	M.ART_CODPRI = ALLTRIM(M.ARCODART)
	M.ART_DESCR = APITOSPA(ALLTRIM(M.ARDESART))
	*** M.CARIFCLA ??????????????????? DA CHIARIRE ????????????????????
	M.ART_CATMER = SUBSTR(ALLTRIM(M.ARGRUMER),1,3)
	*** M.ARCATOMO ??????????????????? DA CHIARIRE ????????????????????
	*** M.ARCODFAM ??????????????????? DA CHIARIRE ????????????????????
	*** M.ARCATCON ??????????????????? DA CHIARIRE ????????????????????
	M.ART_UNIMIS = ALLTRIM(M.ARUNMIS1)
	M.ART_UMMAGA = ALLTRIM(M.ARUNMIS1)
	M.ART_CODIVA = ALLTRIM(M.ARCODIVA)
	M.ART_LINEA  = SUBSTR(ALLTRIM(M.ARTIPART),1,2)
	IF ALLTRIM(M.CACMPCAR) = 'S'
		M.ART_CHDIBA = .T.
	ELSE
		M.ART_CHDIBA = .F.
	ENDIF
		
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
				REPLACE ART_DESCR WITH M.ART_DESCR 
				REPLACE ART_CATMER WITH M.ART_CATMER 
				REPLACE ART_UNIMIS WITH M.ART_UNIMIS 
				REPLACE ART_UMMAGA WITH M.ART_UMMAGA 
				REPLACE ART_CODIVA WITH M.ART_CODIVA 
				REPLACE ART_LINEA WITH M.ART_LINEA 
				REPLACE ART_TIPART WITH M.ART_TIPART 
				REPLACE ART_MAGA WITH M.ART_MAGA
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
	
	
	ELSE
	
			CT_ESISTENTI = CT_ESISTENTI +1
	
	ENDIF
	
	

					   
   	_TOT_COUNT = _TOT_COUNT + 1



ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale articoli convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

WAIT WINDOWS "TOTALE ARTICOLI SCARTATI:" +STR(CT_ESISTENTI,5,0)

RETURN


 