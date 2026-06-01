*************************************************************************************************
*							CONVERSIONE ANAGRAFICA ARTICOLI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Luglio 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica ARTICOLI XILOPAN da foglio Execl	 ?",292,"ATTENZIONE")
		IF RIT = 7
		   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
		   RETURN
		ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
		
		=OPENDB("PERCORSO")
		SELECT PERCORSO
		SET ORDER TO I_TIPO

		SELECT PERCORSO
		V_PATH = ALLTRIM(PER_PATH)
		
		IF DIRECTORY(V_PATH)
		ELSE
			MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
				"Controllare il file PERCORSO.DBF",16,"Attenzione")
			RETURN .F.
		ENDIF

		SET DEFAULT TO &V_PATH 


****** DEFINIZIONE DEI CURSORI STP

		IF !ExecCommand("select * from U_ART_PR where 1=0","cursore_U_ART_PR")
		   return
		ENDIF

		IF !ExecCommand("select * from U_ART_AN where 1=0","cursore_U_ART_AN")
		   return
		ENDIF

*** #######################################################################################################
*** ERASMO - 23/11/2011 - ASTERISCATA LA CANCELLAZIONE DELL'ANAGRAFICA ARTICOLI SOTTO INDICAZIONE DI SERGIO
*** #######################################################################################################
*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_ART_PR SQL 


*!*			RIT = MESSAGEBOX("Desideri cancellare "+CHR(13)+"l'anagrafica articoli XILOPAN ? (NON CANCELLARLI PER FAVORE !!!!! SERGIO )",292,"ATTENZIONE")
*!*			IF RIT = 7
*!*			ELSE 
*!*			
*!*			    WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE ARCHIVI ANAGRAFICA ARTICOLI" NOWAIT
*!*				__ART= "." 
*!*				x_cond = "art_codpri <> '" + __ART + "'"
*!*				cSql   = "delete from U_ART_PR where " + x_cond 
*!*				IF !ExecCommand(cSql,"U_ART_PR")
*!*				   return(.f.)
*!*				ENDIF

*!*				__ART= "." 
*!*				x_cond = "art_codpri <> '" + __ART + "'"
*!*				cSql   = "delete from U_ART_AN where " + x_cond 
*!*				IF !ExecCommand(cSql,"U_ART_AN")
*!*				   return(.f.)
*!*				ENDIF


*!*			ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = RIBALTA2(DTOC(DATE()))
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




		gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file EXCEL >>>>>>>>>>> "+gcFile 		

		CREATE CURSOR IMPORTAXLS (CAMPO1  c(100),;
		    CAMPO2   c(100),;
		    CAMPO3   c(100),;
		    CAMPO4   c(100),;
		    CAMPO5   c(100),;
		    CAMPO6   c(100),;
		    CAMPO7   c(100),;
		    CAMPO8   c(100),;
		    CAMPO9   c(100),;
		    CAMPO10  c(100),;
		    CAMPO11  c(100),;
		    CAMPO12  c(100))
		APPEND FROM (gcFile) TYPE xls	



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP


SELECT IMPORTAXLS 
GO TOP


_CONTAREC = 0

DO WHILE .NOT. EOF()


    IF DELETED()
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 
    
    
  
    IF SUBSTR(CAMPO1,1,10) = "20/10/2011" 
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF   
 
 
    IF SUBSTR(CAMPO1,1,7) = "C=Carta" 
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF   
  
    IF SUBSTR(CAMPO1,1,8) = "G=Grezzo" 
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF   
 
    IF SUBSTR(CAMPO1,1,8) = "N=Nobil." 
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF   

  
  
  
  
   
*!*	#####################################################






   M.ART_CODSOC = PUB_CODSOC
   M.ART_CODPRI = SPACE(16)
   M.ART_DESCR  = SPACE(50)
   M.ART_DESEST = SPACE(50)
   M.ART_UNIMIS = SPACE(02)
   M.ART_UNMAGA = SPACE(02)   
   M.ART_LINEA  = PUB_LINEA
   M.ART_PRZVEN = 0
   M.ART_PRZVE2 = 0
   M.ART_PRZVE3 = 0
   M.ART_PRZVE4 = 0
   M.ART_PRZVE5 = 0
   M.ART_PRZCOS = 0
   M.ART_CODIVA = PUB_IVA
   M.ART_MAGA   = PUB_CODM
   M.ART_PESOUM = 0
   M.ART_CGE    = SPACE(13)
   M.ART_CODF1  = SPACE(10)
   M.ART_CODF2  = SPACE(10)
   M.ART_CODF3  = SPACE(10)
   M.ART_NOTA1  = SPACE(20)
   M.ART_NOTA2  = SPACE(20)
   M.ART_NOTA3  = SPACE(20)
   M.ART_PRZCO1 = 0
   M.ART_PRZCO2 = 0
   M.ART_PRZCO3 = 0
   M.ART_DATINS = RIBALTA2(DTOC(DATE()))
   M.ART_CODVAL = PUB_VALU
   M.ART_ULDCAR = SPACE(10)
   M.ART_ULPCAR = 0
   M.ART_CATMER = SPACE(03)
   M.ART_DESMER = SPACE(50)
   M.ART_CODMAT = "008"
   M.ART_DESMAT = SPACE(50)
   M.ART_CODIMB = SPACE(03)
   M.ART_DESIMB = SPACE(50)
   M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
   M.ART_DESMAT = SPACE(50)
   M.ART_TIPART = 'P'
   M.ART_DISBAS = ' '
   M.ART_RIPCOM = ' '
   M.ART_DESRID = SPACE(50)
   M.ART_SPESSO = 0
   M.ART_ALTEZZ = 0
   M.ART_LUNGHE = 0
   M.ART_LOTMIN = 0
   M.ART_CDDIBA = SPACE(16)
   M.ART_DSDIBA = SPACE(50)
   M.ART_UMMAGA = SPACE(02)
   

   M.ART_CODPRI = ALLTRIM(SUBSTR(CAMPO3,01,16))
   M.ART_CODPRI = UPPER(M.ART_CODPRI)
   M.ART_CODPRI = APITOSPA(M.ART_CODPRI)

   M.ART_DESCR  = ALLTRIM(SUBSTR(CAMPO4,01,50))
   M.ART_DESCR  = UPPER(M.ART_DESCR)
   M.ART_DESCR  = APITOSPA(M.ART_DESCR)

   
   M.ART_DESEST = " "
   
 
   M.ART_UMMAGA = ALLTRIM(SUBSTR(CAMPO5,01,05))
   M.ART_UMMAGA = UPPER(M.ART_UMMAGA)
   M.ART_UMMAGA = APITOSPA(M.ART_UMMAGA)    
 
   IF M.ART_UMMAGA= "PZ"
      M.ART_UMMAGA= "NR"
   ENDIF
 
 
 
   M.ART_UNIMIS = ALLTRIM(SUBSTR(CAMPO5,01,05))
   M.ART_UNIMIS = UPPER(M.ART_UNIMIS)
   M.ART_UNIMIS = APITOSPA(M.ART_UNIMIS)    
 
   IF M.ART_UNIMIS = "PZ"
      M.ART_UNIMIS = "NR"
   ENDIF


*!*	IF M.ART_CODPRI = "140A2B1U05U0501"
*!*	SET STEP ON 
*!*	ENDIF

   M.ART_ALTEZZ = ALLTRIM(SUBSTR(CAMPO7,01,15))			&& lunghezza = lato1
   M.ART_ALTEZZ = UPPER(M.ART_ALTEZZ)
   M.ART_ALTEZZ = APITOSPA(M.ART_ALTEZZ)

*!*	   gcFindString = '.'
*!*	   POSIZIONE_PAROLA = AT(gcFindString,M.ART_ALTEZZ)
*!*	   IF POSIZIONE_PAROLA > 0
*!*		   M.ART_ALTEZZ = VAL(M.ART_ALTEZZ) * 1000    
*!*	   ELSE 
*!*	 	  M.ART_ALTEZZ = VAL(M.ART_ALTEZZ) 
*!*	   ENDIF
   
   **=> ERASMO - INIZIO 23/11/2011
   gcFindString = '.'
   POSIZIONE_PUNTO = AT(gcFindString,M.ART_ALTEZZ)
   gcFindString = ','
   POSIZIONE_VIRGOLA = AT(gcFindString,M.ART_ALTEZZ)
   IF POSIZIONE_PUNTO > 0 OR POSIZIONE_VIRGOLA > 0
	   M.ART_ALTEZZ = VAL(M.ART_ALTEZZ) * 1000    
   ELSE 
 	  M.ART_ALTEZZ = VAL(M.ART_ALTEZZ) 
   ENDIF
   **=> ERASMO - FINE 23/11/2011
   
   M.ART_LUNGHE = ALLTRIM(SUBSTR(CAMPO8,01,15))			&& larghezza = lato2
   M.ART_LUNGHE = UPPER(M.ART_LUNGHE)
   M.ART_LUNGHE = APITOSPA(M.ART_LUNGHE)

*!*	   gcFindString = '.'
*!*	   POSIZIONE_PAROLA = AT(gcFindString,M.ART_LUNGHE)
*!*	   IF POSIZIONE_PAROLA > 0
*!*		  M.ART_LUNGHE = VAL(M.ART_LUNGHE) * 1000    
*!*	   ELSE 
*!*	 	  M.ART_LUNGHE = VAL(M.ART_LUNGHE) 
*!*	   ENDIF
   
   **=> ERASMO - INIZIO 23/11/2011
   gcFindString = '.'
   POSIZIONE_PUNTO = AT(gcFindString,M.ART_LUNGHE)
   gcFindString = ','
   POSIZIONE_VIRGOLA = AT(gcFindString,M.ART_LUNGHE)
   IF POSIZIONE_PUNTO > 0 OR POSIZIONE_VIRGOLA > 0
	   M.ART_LUNGHE = VAL(M.ART_LUNGHE) * 1000    
   ELSE 
 	  M.ART_LUNGHE = VAL(M.ART_LUNGHE) 
   ENDIF
   **=> ERASMO - FINE 23/11/2011
 
  
 
   M.ART_SPESSO = ALLTRIM(SUBSTR(CAMPO9,01,15))
   M.ART_SPESSO = UPPER(M.ART_SPESSO)
   M.ART_SPESSO = APITOSPA(M.ART_SPESSO)
   M.ART_SPESSO = VAL(M.ART_SPESSO)   
   IF M.ART_SPESSO > 9000
   		M.ART_SPESSO = M.ART_SPESSO / 10000
   ELSE 
   		M.ART_SPESSO = M.ART_SPESSO / 1000
   ENDIF
   
   
   M.ART_CATMER = ALLTRIM(SUBSTR(CAMPO10,01,03))
   M.ART_CATMER = UPPER(M.ART_CATMER)
   M.ART_CATMER = APITOSPA(M.ART_CATMER)

   
         
   M.ART_CGE = ALLTRIM(SUBSTR(CAMPO6,01,15))
   M.ART_CGE = UPPER(M.ART_CGE)
   M.ART_CGE = APITOSPA(M.ART_CGE)
   
   
   
   
   M.ART_CODCOLRET 	= "" 					&& COLORE RETRO
   M.ART_TIPOG 		= "" 					&& TIPO DI GREZZO 
   M.ART_TIPON 		= "" 					&& TIPO DI NOBILITATO 
   M.ART_SCELTA 	= "" 					&& SCELTA
   M.ART_FINI 		= ""					&& FINITURA 	
   M.ART_CODCOL 	= ""				 	&& COLORE FRONTE
   M.ART_TOLGRM     = 0  
   M.ART_DESCOL 	= SPACE(50)
    
   _LEN_CODPRI      = LEN(ALLTRIM(M.ART_CODPRI)) 
   
   IF _LEN_CODPRI   = 14
   
       M.ART_TIPOG 		= SUBSTR(M.ART_CODPRI,01,01) 		&& TIPO DI GREZZO 
 	   M.ART_CODCOL 	= SUBSTR(M.ART_CODPRI,07,03) 		&& COLORE FRONTE
   	   M.ART_CODCOLRET 	= SUBSTR(M.ART_CODPRI,10,03) 		&& COLORE RETRO

	   gcFindString = 'NOB.'
	   POSIZIONE_PAROLA = AT(gcFindString,M.ART_DESCR)
	   
	   IF POSIZIONE_PAROLA > 0			
		   M.ART_TIPON 		= SUBSTR(M.ART_CODPRI,01,01) 	&& TIPO DI NOBILITATO 
           M.ART_TIPOG 		= ""					 		&& TIPO DI GREZZO 
	   ENDIF
	   M.ART_FINI 		= SUBSTR(M.ART_CODPRI,13,01)		&& FINITURA 	
	   M.ART_SCELTA 	= SUBSTR(M.ART_CODPRI,14,01) 		&& SCELTA


   ENDIF


   IF _LEN_CODPRI   = 15
   
       M.ART_TIPOG 		= SUBSTR(M.ART_CODPRI,01,01) 		&& TIPO DI GREZZO 
 	   M.ART_CODCOL 	= SUBSTR(M.ART_CODPRI,08,03) 		&& COLORE FRONTE
   	   M.ART_CODCOLRET 	= SUBSTR(M.ART_CODPRI,11,03) 		&& COLORE RETRO

	   gcFindString = 'NOB.'
	   POSIZIONE_PAROLA = AT(gcFindString,M.ART_DESCR)
	   
	   IF POSIZIONE_PAROLA > 0			
		   M.ART_TIPON 		= SUBSTR(M.ART_CODPRI,01,01) 	&& TIPO DI NOBILITATO 
           M.ART_TIPOG 		= ""					 		&& TIPO DI GREZZO 
	   ENDIF
	   M.ART_FINI 		= SUBSTR(M.ART_CODPRI,14,01)		&& FINITURA 	
	   M.ART_SCELTA 	= SUBSTR(M.ART_CODPRI,15,01) 		&& SCELTA


   ENDIF

	SELECT cursore_U_ART_PR
	APPEND BLANK
	GATHER MEMVAR MEMO
	REPLACE ID_UNIQUE WITH ""
    SCATTER MEMVAR MEMO

	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"



	IF !ExecCommand(cSql,"U_ART_PR")
	   RETURN .F.
	ENDIF

	SELECT U_ART_PR 
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_ART_PR
	IF !ExecRW('','U_ART_PR','I','','U_ART_PR')
	  return(.f.)
	ENDIF	

	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_ART_AN where " + x_cond + " order by art_codsoc,art_codpri"



	IF !ExecCommand(cSql,"U_ART_AN")
	   RETURN .F.
	ENDIF

	SELECT U_ART_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_ART_AN
	IF !ExecRW('','U_ART_AN','I','','U_ART_AN')
	  return(.f.)
	ENDIF	




	_CONTAREC = _CONTAREC + 1
	WAIT WINDOWS "RECORD : "+STR(_CONTAREC,5,0) NOWAIT
	
	SELECT IMPORTAXLS 
	SKIP +1
	
ENDDO



SELECT cursore_U_ART_PR
GO TOP



*!*	****** AGGIORNA TABELLA U_ART_PR SQL
*!*	IF !ExecRW('','U_ART_PR','I','','cursore_U_ART_PR')
*!*	   return(.f.)
*!*	ENDIF
*!*		 
*!*		 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


