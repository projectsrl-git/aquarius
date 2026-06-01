*************************************************************************************************
*							CONVERSIONE ANAGRAFICA ARTICOLI										*
*							 																	*
*	by Project S.r.l.																			*
*	giugno 2017 : Impresind					 													*
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



RIT = MESSAGEBOX("Conversione anagrafica articoli da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


**** CARICAMENTO DEL FILE IN FORMATO DBF 
gcFile = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF



*!*	IF !ExecCommand("select * from U_ART_PR where 1=0","curs_U_ART_PR")
*!*	   return
*!*	ENDIF


CREATE CURSOR curs_U_ART_PR (ART_CODPRI C(30), ;
					   ART_DESCR  C(90),   ART_UMMAGA C(2))



*!*	RIT = MESSAGEBOX("Desideri cancellare l'anagrafica articoli esistente ??" + REPLICATE(CHR(13),2) + ;
*!*			 "Continuare?",4+32+256,"ATTENZIONE")
*!*			
*!*	IF RIT <> 7
*!*		WAIT WINDOWS "Cancellazione vecchia anagrafica articoli in corso..." NOWAIT

*!*		cSql = "DELETE FROM U_ART_PR"
*!*		IF !ExecCommand(cSql,"DEL_ART_PR")
*!*		   return
*!*		ENDIF

*!*		cSql = "DELETE FROM U_ART_AN"
*!*		IF !ExecCommand(cSql,"DEL_ART_AN")
*!*		   return
*!*		ENDIF
*!*	ENDIF 


CT_INESISTENTI = 0

WAIT WINDOWS "Conversione anagrafica articoli in corso..." NOWAIT		

CREATE CURSOR IMPORTADBF ( ;
	arcodart C(100), ;	
	ardesart C(100), ;		
	arunmis1 C(100), ;		
	aroperat C(100), ;		
	armoltip C(100), ;		
	arunmis2 C(100), ;		
	artipart C(100), ;		
	argrumer C(100), ;		
	argrupro C(100), ;		
	arcatscm C(100), ;		
	arcodiva C(100), ;		
	arcatomo C(100), ;		
	arcatcon C(100), ;		
	arpesnet C(100), ;		
	arpesne2 C(100), ;		
	arpeslo2 C(100), ;		
	ardesvol C(100), ;		
	ardesvo2 C(100), ;		
	arumvolu C(100), ;		
	artpconf C(100), ;		
	artpcon2 C(100), ;		
	arpzconf C(100), ;		
	arpzcon2 C(100), ;		
	arnomenc C(100), ;		
	arumsupp C(100), ;		
	armolsup C(100), ;		
	arstasup C(100), ;		
	ardimlun C(100), ;		
	ardimlu2 C(100), ;		
	ardimlar C(100), ;		
	ardimla2 C(100), ;		
	ardimal2 C(100), ;		
	arumdime C(100), ;		
	arumdim2 C(100), ;		
	ardtinva C(100), ;		
	ardtobso C(100), ;		
	arcodmar C(100), ;		
	arcodric C(100), ;		
	arcodcla C(100), ;		
	arcodfam C(100), ;		
	arflesau C(100), ;		
	arflinve C(100), ;		
	arpeslor C(100), ;		
	ardimalt C(100), ;		
	arumvol2 C(100), ;		
	arfldisp C(100), ;		
	arcodalt C(100), ;		
	ardesalt C(100), ;		
	arpubweb C(100), ;		
	artipope C(100), ;		
	arcatope C(100), ;		
	arflusep C(100), ;		
	arcocol1 C(100), ;		
	arcocol2 C(100))




_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "'"
&_COMMAND

_TOT_COUNT = 0

SELECT IMPORTADBF
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
	M.ART_DESCR  = APITOSPA(ALLTRIM(M.ARDESART))
	M.ART_CATMER = SUBSTR(ALLTRIM(M.ARGRUMER),1,3)
	M.ART_UNIMIS = ALLTRIM(M.ARUNMIS1)
	M.ART_UMMAGA = ALLTRIM(M.ARUNMIS1)
	M.ART_CODIVA = ALLTRIM(M.ARCODIVA)
	
	IF M.ART_CODIVA = '22' 
		M.ART_CODIVA = '022'
	ENDIF
	
			
	M.ART_LINEA  = SUBSTR(ALLTRIM(M.ARTIPART),1,2)		
	M.ART_CHDIBA = .F.
		
	DO CASE
		CASE M.ART_LINEA = "MP"
			M.ART_TIPART = '12'
		CASE M.ART_LINEA = "SE"
			M.ART_TIPART = 'AM'
		CASE M.ART_LINEA = "PF"
			M.ART_TIPART = 'AM'
		OTHERWISE
			M.ART_TIPART = '12'
	ENDCASE
	
	M.ART_MAGA = "SEDE"
	M.ART_CODMAT = "001"
	
	M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
	M.ART_DATINS = RIBALTA2(DTOC(DATE()))
	

	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + ALLTRIM(M.ARCODART) + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"
	IF !ExecCommand(cSql,"VERIFICA_ART_PR")
	   RETURN .F.
	ENDIF
	SELECT VERIFICA_ART_PR
	GO TOP 
	IF EOF() 

		CT_INESISTENTI = CT_INESISTENTI +1


	   	SELECT curs_U_ART_PR				&& SALVATAGGIO PER ELENCO CLIENTI INESISTENTI DA VERIFICARE
		APPEND BLANK
		REPLACE ART_CODPRI WITH ALLTRIM(M.ARCODART)
		REPLACE ART_DESCR  WITH APITOSPA(ALLTRIM(M.ARDESART))
		REPLACE ART_UMMAGA WITH ALLTRIM(M.ARUNMIS1)	


		cSql = "SELECT * FROM U_ART_PR WHERE 1=0"
		IF !ExecRW(cSql,"U_ART_PR","R")
		   RETURN .F.
		ENDIF
		SELECT U_ART_PR
		APPEND BLANK


		DO aggiorna_campi_anagrafici


		IF !ExecRW(cSql,"U_ART_PR","W")
		   RETURN .F.
		ENDIF
						
		cSql = "SELECT * FROM U_ART_AN WHERE 1=0"
		IF !ExecRW(cSql,"U_ART_AN","R")
		   RETURN .F.
		ENDIF
		SELECT U_ART_AN
		APPEND BLANK
		REPLACE ART_CODSOC WITH PUB_CODSOC
		REPLACE ART_CODPRI WITH ALLTRIM(M.ARCODART)	
		
		IF !ExecRW(cSql,"U_ART_AN","W")
		   RETURN .F.
		ENDIF


	ELSE
	
	
	ENDIF
	

	

	

					   
   	_TOT_COUNT = _TOT_COUNT + 1



ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale articoli elaborati: " + ALLTRIM(STR(_TOT_COUNT,10,0)) + ;
	"Totale articoli inseriti: " + ALLTRIM(STR(CT_INESISTENTI,10,0)),64,"Informazione")



SELECT curs_U_ART_PR
GO TOP
COPY TO ANART_INE SDF



RETURN

PROCEDURE aggiorna_campi_anagrafici

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


RETURN
 