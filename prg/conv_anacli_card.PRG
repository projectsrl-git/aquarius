*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CLIENTI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2013 : Cardioline			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica clienti da foglio Excel?",292,"ATTENZIONE")
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


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CLIENTI" NOWAIT

IF !ExecCommand("select * from U_CLI_AN where 1=0","curs_U_CLI_AN")
   return
ENDIF

*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA ZONE" NOWAIT
*!*	*!*	cSql = "delete from PARA where CODICE LIKE 'ZON%' "
*!*	*!*	IF !ExecCommand(cSql,"PARA")
*!*	*!*	   return(.f.)
*!*	*!*	ENDIF

*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA NAZIONI" NOWAIT
*!*	*!*	cSql = "delete from PARA where CODICE LIKE 'STA%' "
*!*	*!*	IF !ExecCommand(cSql,"PARA")
*!*	*!*	   return(.f.)
*!*	*!*	ENDIF

*!*	*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA AGENTI" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'AGE%' "
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF

*!*	*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA AGENTI" NOWAIT
*!*	cSql = "delete from U_AGE_AN"
*!*	IF !ExecCommand(cSql,"U_AGE_AN")
*!*	   return(.f.)
*!*	ENDIF



*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL ESCLUDENDO IL CODICE CLIENTE AZIENDA PER LA GESTIONE AZIENDA


__SOC= "01"
__CLI= "000000" 

x_soci = "cli_codsoc = '" + __SOC + "'"
x_codi = "cli_codcli <> '" + __CLI + "'"
x_cond = x_soci + " and " + x_codi

cSql   = "delete from u_cli_an where " + x_cond 
IF !ExecCommand(cSql,"U_CLI_AN")
   return(.f.)
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA,_CODICE_AGENTE 
PUBLIC _CODICE_ZONA,_CODICE_AGENTE 
_CODICE_ZONA = 0
_CODICE_AGENTE  = 0


RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	
	RETURN
ENDIF



WAIT WINDOWS "Selezionato file EXCEL >>>>>>>>>>> "+gcFile 		

CREATE CURSOR IMPORTAXLS (CLI_CODCLI  c(10),;
	CLI_RAGSOC   c(80),;
	CLI_INDIR    c(70),;
	CLI_LOCALI   c(80),;
	CLI_CAP      c(10),;
	CLI_COMUNE   c(80),;
	CLI_PROVIN   c(02),;			
	CLI_NAZIONE  c(30),;
	CLI_PREFTEL  c(30),;
	CLI_TELEFO   c(30),;
	CLI_PREFAX   c(30),;			
	CLI_FAX      c(30),;
	CLI_CELLUL   c(30),; 
	CLI_HOMPAG   c(100),;
	CLI_EMAIL    c(90),;
	CLI_FATT_A   c(90),;
	CLI_RAGFOR   c(90),;
	CLI_CODFIS   c(16),;
	CLI_ALIQ_IVA c(60),;
	CLI_PARIVA   c(11),;
	CLI_LISTINO  c(50),;
	CLI_CATESCO  c(20),;
	CLI_TIPOPAG  c(90),;
	CLI_CVALUTA  c(03),;
	CLI_SCONVAL  c(03),;
	CLI_SCONTO1  c(03),;
	CLI_SCONTO2  c(03),;
	CLI_SCONTO3  c(03),;
	CLI_SCONTO4  c(03),;
	CLI_SCONTO5  c(03),;
	CLI_MAGGIO1  c(03),;
	CLI_MAGGIO2  c(03),;
	CLI_IVAOMA  c(03),;
	CLI_IVACOM  c(03),;
	CLI_IVARID  c(03),;			
	CLI_DESAGE  c(90),;
	CLI_PROVAGE  n(05,2),;
	CLI_PROVCZO  n(05,2),;
	CLI_DESPORT  c(90),;			
	CLI_INDISPE  c(90),;   
	CLI_INDIDOC  c(90),;  	
	CLI_DESVET   c(90),;  						
	CLI_SPEDIZI  c(90),;  
	CLI_DESZON   c(50),;  
	CLI_DESABIC  c(80),;  
	CLI_CONTCOR  c(50),;  
	CLI_CIN      c(2),;  
	CLI_FIDO     n(12,2),;
	CLI_CDIBAN   c(50),;  
	CLI_CODBIC   c(15),;  
	CLI_SOTTOC   c(15),;  
	CLI_TIPOCON  c(15))  


APPEND FROM (gcFile) TYPE xls	

***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP
SELECT IMPORTAXLS
GO TOP 


DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF ALLTRIM(CLI_CODCLI) = "Codice"
       SELECT IMPORTAXLS   && scarto primo record
       SKIP +1
       LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
    
    
*!*	#####################################################


    M.ID_UNIQUE  = ""
   	M.CLI_CODSOC = PUB_CODSOC 
    M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(CLI_CODCLI))
 	M.CLI_RAGSOC = ALLTRIM (CLI_RAGSOC)
   	M.CLI_RAGSOC = UPPER(M.CLI_RAGSOC)
    M.CLI_RAGSOC = APITOSPA(M.CLI_RAGSOC)
 	M.CLI_RAGDUE = ""
   	M.CLI_INDIR  = ALLTRIM (CLI_INDIR)
   	M.CLI_INDIR  = UPPER(M.CLI_INDIR)
    M.CLI_INDIR  = APITOSPA(M.CLI_INDIR)
	M.CLI_LOCALI = ALLTRIM (CLI_LOCALI)
   	M.CLI_LOCALI = UPPER(M.CLI_LOCALI)
    M.CLI_LOCALI = APITOSPA(M.CLI_LOCALI)
	M.CLI_CAP    = ALLTRIM(CLI_CAP)
	M.CLI_PROVIN = ALLTRIM (CLI_PROVIN)
   	M.CLI_PROVIN = UPPER(M.CLI_PROVIN)
    M.CLI_PROVIN = APITOSPA(M.CLI_PROVIN)


	*** ################################## AGGIORNA PARAMETRO NAZIONE ##################################
    M.CLI_NAZIONE = UPPER(CLI_NAZIONE)
    
    IF ALLTRIM(CLI_NAZIONE) = 'HONDURAS'
    	M.CLI_NAZION 	= "HOD"			
	ENDIF     
	
    IF ALLTRIM(CLI_NAZIONE) = 'Italia'
    	M.CLI_NAZION 	= "ITA"			
	ELSE 
		M.CLI_NAZION 	= ALLTRIM(UPPER(SUBSTR(CLI_NAZIONE,1,3)))	
	ENDIF 
	
	IF EMPTY(ALLTRIM(M.CLI_NAZION))
		M.CLI_NAZION = "ITA"
	ENDIF
	
	gcFindString= M.CLI_NAZION
	TIPO_PARAMETRO = "STA"
	X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
	X_CODICE = "CODICE = '" + gcFindString + "'"
	x_cond = x_chiave  + " and " + x_codice 
	Csql    = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecCommand(cSql,"sta_para")
	   return(.f.)
	ENDIF
	SELECT sta_para
	GO top
	IF EOF()
		x_codi = "codice = 'STA"+M.CLI_NAZION+"'"
		x_cond = x_codi
		cSql = "select * from PARA where " + x_cond
		IF !ExecRW(cSql,"PARA","R")
		   return(.f.)
		ENDIF
		SELECT PARA
		GO TOP
		IF EOF()
		   APPEND BLANK
		   V1 = "STA"+M.CLI_NAZION
		   REPLACE CODICE WITH V1
		   REPLACE DESCRI WITH ALLTRIM(M.CLI_NAZIONE)
		ENDIF
		IF !ExecRW(cSql,"PARA","W")
		   return(.f.)
		ENDIF
	ENDIF       				
 	SELECT IMPORTAXLS 
	*** ################################## AGGIORNA PARAMETRO NAZIONE ##################################
	
	M.CLI_TELEFO = ALLTRIM(CLI_PREFTEL)	+ " " + ALLTRIM(CLI_TELEFO)		
	m.CLI_FAX    = ALLTRIM(CLI_PREFAX)  + " " + ALLTRIM(CLI_FAX)
    M.CLI_NOTE   = ALLTRIM(CLI_CELLUL)	
	M.CLI_HOMPAG = LOWER(CLI_HOMPAG)
    m.CLI_EMAIL  = LOWER(CLI_EMAIL)

	M.CLI_CODFIS = UPPER(CLI_CODFIS)


	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO CONDIZIONI IVA
	gcFindString= ALLTRIM(CLI_ALIQ_IVA)
	TIPO_PARAMETRO = "IVA"
	X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
	X_DESCRI = "DESCRI = '" + gcFindString + "'"
	x_cond = x_chiave  + " and " + x_descri 
	Csql    = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecCommand(cSql,"iva_para")
	   return(.f.)
	ENDIF
	SELECT iva_para
	GO top
	IF !EOF()
		M.CLI_CODIVA   	= SUBSTR(CODICE,4,3)
	ELSE
		M.CLI_CODIVA   	= "21"
    ENDIF       				
 	SELECT IMPORTAXLS 


	M.CLI_PARIVA = UPPER(CLI_PARIVA)	


	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO CONDIZIONI DI PAGAMENTO
	gcFindString= ALLTRIM(CLI_TIPOPAG)
	TIPO_PARAMETRO = "CPA"
	X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
	X_DESCRI = "DESCRI = '" + gcFindString + "'"
	x_cond = x_chiave  + " and " + x_descri 
	Csql    = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecCommand(cSql,"cpa_para")
	   return(.f.)
	ENDIF
	SELECT cpa_para
	GO top
	IF !EOF()
		M.CLI_CONPAG   	= SUBSTR(CODICE,4,3)
	ELSE
		M.CLI_CONPAG   	= PUB_CPA
    ENDIF       				
 	SELECT IMPORTAXLS    


	IF EMPTY(ALLTRIM(CLI_CVALUTA))
	    M.CLI_VALUTA = PUB_VALU
	ELSE
		M.CLI_VALUTA = UPPER(SUBSTR(CLI_CVALUTA,1,3))
	ENDIF 
	


	*** ################################## AGGIORNA PARAMETRO AGENTE + ANAGRAFICA AGENTI ##################################

    M.CLI_DESAGE = ALLTRIM(UPPER(CLI_DESAGE))

	IF EMPTY(M.CLI_DESAGE)
		*M.CLI_AGE 		= ""
		M.CLI_AGE 		= "000"
    ELSE
    
*!*			gcFindString= M.CLI_DESAGE
*!*			TIPO_PARAMETRO = "AGE"
*!*			X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
*!*			X_DESCRI = "DESCRI = '" + gcFindString + "'"
*!*			x_cond = x_chiave  + " and " + x_descri
*!*			Csql    = "SELECT * FROM PARA WHERE " + x_cond
*!*			IF !ExecCommand(cSql,"age_para")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT age_para
*!*			GO top
*!*			IF EOF()
*!*				M.CLI_AGE 	= ""
*!*				_CODICE_AGENTE = _CODICE_AGENTE + 1
*!*				IF LEN(ALLTRIM(STR(_CODICE_AGENTE,3,0))) = 1
*!*					M.CLI_AGE 	= "00" + ALLTRIM(STR(_CODICE_AGENTE,3,0))
*!*				ENDIF
*!*				IF LEN(ALLTRIM(STR(_CODICE_AGENTE,3,0))) = 2
*!*					M.CLI_AGE 	= "0" +	 ALLTRIM(STR(_CODICE_AGENTE,3,0))
*!*				ENDIF
*!*				TIPO_PARAMETRO = "AGE"
*!*				X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
*!*				X_DESCRI = "DESCRI = '" + gcFindString + "'"
*!*				x_cond = x_chiave  + " and " + x_descri 
*!*				Csql    = "SELECT * FROM PARA WHERE " + x_cond
*!*				IF !ExecRW(cSql,"PARA","R")
*!*				   return(.f.)
*!*				ENDIF
*!*				SELECT PARA
*!*				GO TOP
*!*				IF EOF()
*!*				   APPEND BLANK
*!*				   V1 = "AGE"+M.CLI_AGE
*!*				   REPLACE CODICE WITH V1
*!*				   REPLACE DESCRI WITH ALLTRIM(M.CLI_DESAGE)
*!*				ENDIF
*!*				IF !ExecRW(cSql,"PARA","W")
*!*				   return(.f.)
*!*				ENDIF
*!*				** ################################ AGGIORNA ANAGRAFICA AGENTE
*!*			    x_cond= "AGE_CODICE = '" + M.CLI_AGE + "'"
*!*				cSql = "select * from U_AGE_AN where " + x_cond
*!*				IF !ExecRW(cSql,"U_AGE_AN","R")
*!*				   return(.f.)
*!*				ENDIF
*!*				SELECT U_AGE_AN 
*!*				GO TOP
*!*				IF EOF()
*!*				    APPEND BLANK
*!*					REPLACE AGE_CODSOC WITH PUB_CODSOC
*!*					REPLACE AGE_CODICE WITH M.CLI_AGE
*!*					REPLACE AGE_RAGSOC WITH ALLTRIM(M.CLI_DESAGE)
*!*					REPLACE AGE_CODIVA WITH "21"
*!*					REPLACE AGE_DATINS WITH RIBALTA2(DTOC(DATE()))
*!*	 			ENDIF
*!*				IF !ExecRW(cSql,"U_AGE_AN","W")
*!*				   return(.f.)
*!*				ENDIF
*!*			ENDIF   
*!*	  	 	SELECT IMPORTAXLS 

		gcFindString = ALLTRIM(M.CLI_DESAGE)
		IF gcFindString = "J.C. ANAIN"
			gcFindString = "ANAIN J.C."
		ENDIF
		TIPO_PARAMETRO = "AGE"
		X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
		X_DESCRI = "DESCRI LIKE '%" + gcFindString + "%'"
		x_cond = x_chiave  + " and " + x_descri
		Csql    = "SELECT * FROM PARA WHERE " + x_cond
		IF !ExecCommand(cSql,"age_para")
		   return(.f.)
		ENDIF
		SELECT age_para
		GO top
		IF EOF()
			M.CLI_AGE = "000"
		ELSE
			M.CLI_AGE = ALLTRIM(SUBSTR(CODICE,4,3))
		ENDIF
	
	ENDIF
	
	*** ################################## AGGIORNA PARAMETRO AGENTE + ANAGRAFICA AGENTI ##################################
	
	SELECT IMPORTAXLS 
	
	M.CLI_PROVVI = CLI_PROVAGE
	
	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO PORTO
	gcFindString= ALLTRIM(CLI_DESPORT)
	TIPO_PARAMETRO = "POR"
	X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
	X_DESCRI = "DESCRI = '" + gcFindString + "'"
	x_cond = x_chiave  + " and " + x_descri 
	Csql    = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecCommand(cSql,"por_para")
	   return(.f.)
	ENDIF
	SELECT por_para
	GO top
	IF !EOF()
		M.CLI_PORTO   	= SUBSTR(CODICE,4,3)
	ELSE
		M.CLI_PORTO 	= ""
    ENDIF       				
 	SELECT IMPORTAXLS    



	IF !EXECCOMMAND("SELECT * FROM U_LOC_AN WHERE LOC_CODCLI='"+M.CLI_CODCLI+"' AND LOC_RAGSOC='"+ALLTRIM(CLI_INDISPE)+"' AND LOC_CF = 'C' ORDER BY LOC_CODCLI ","CURS_LOCALI")
	   RETURN .F.
	ENDIF
	IF !EOF()
		M.CLI_LOCDOC = LOC_CODLOC
	ELSE
		M.CLI_LOCDOC = ""
	ENDIF
 	SELECT IMPORTAXLS 



	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO VETTORI
	gcFindString= ALLTRIM(CLI_DESVET)
	TIPO_PARAMETRO = "VET"
	X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
	X_DESCRI = "DESCRI = '" + gcFindString + "'"
	x_cond = x_chiave  + " and " + x_descri 
	Csql    = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecCommand(cSql,"vet_para")
	   return(.f.)
	ENDIF
	SELECT vet_para
	GO top
	IF !EOF()
	    M.CLI_VETTO1   	= SUBSTR(CODICE,4,3)
	ELSE
		M.CLI_VETTO1   	= ""
	ENDIF       				
 	SELECT IMPORTAXLS 



    M.CLI_ZONA   	= ""
    
*!*	*!*		*** ################################## CREA PARAMETRO ZONA ##################################
*!*	*!*		*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO ZONA
*!*	*!*		IF EMPTY(ALLTRIM(CLI_DESZON))
*!*	*!*			M.CLI_ZONA   	= ""	
*!*	*!*		ELSE
*!*	*!*		    M.CLI_DESZON=CLI_DESZON
*!*	*!*			gcFindString= ALLTRIM(CLI_DESZON)
*!*	*!*			TIPO_PARAMETRO = "ZON"
*!*	*!*			X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
*!*	*!*			X_DESCRI = "DESCRI = '" + gcFindString + "'"
*!*	*!*			x_cond = x_chiave  + " and " + x_descri 
*!*	*!*			Csql    = "SELECT * FROM PARA WHERE " + x_cond
*!*	*!*			IF !ExecCommand(cSql,"zon_para")
*!*	*!*			   return(.f.)
*!*	*!*			ENDIF
*!*	*!*			SELECT zon_para
*!*	*!*			GO top
*!*	*!*			IF !EOF()
*!*	*!*			    M.CLI_ZONA   	= SUBSTR(CODICE,4,3)
*!*	*!*			ELSE
*!*	*!*				M.CLI_ZONA   	= ""
*!*	*!*				_CODICE_ZONA = _CODICE_ZONA  + 1
*!*	*!*				IF LEN(ALLTRIM(STR(_CODICE_ZONA,3,0))) = 1
*!*	*!*					M.CLI_ZONA   	= "00" + ALLTRIM(STR(_CODICE_ZONA,3,0))
*!*	*!*				ENDIF
*!*	*!*				IF LEN(ALLTRIM(STR(_CODICE_ZONA,3,0))) = 2
*!*	*!*					M.CLI_ZONA   	= "0" +	 ALLTRIM(STR(_CODICE_ZONA,3,0))
*!*	*!*				ENDIF
*!*	*!*				x_codi = "codice = 'ZON"+M.CLI_ZONA+"'"
*!*	*!*				x_cond = x_codi
*!*	*!*				cSql = "select * from PARA where " + x_cond
*!*	*!*				IF !ExecRW(cSql,"PARA","R")
*!*	*!*				   return(.f.)
*!*	*!*				ENDIF
*!*	*!*				SELECT PARA
*!*	*!*				GO TOP
*!*	*!*				IF EOF()
*!*	*!*				   APPEND BLANK
*!*	*!*				   V1 = "ZON"+M.CLI_ZONA
*!*	*!*				   REPLACE CODICE WITH V1
*!*	*!*				   REPLACE DESCRI WITH ALLTRIM(M.CLI_DESZON)
*!*	*!*				ENDIF
*!*	*!*				IF !ExecRW(cSql,"PARA","W")
*!*	*!*				   return(.f.)
*!*	*!*				ENDIF
*!*	*!*			ENDIF       				
*!*	*!*		 	SELECT IMPORTAXLS 
*!*	*!*		 ENDIF
	 
	*** ################################## CREA PARAMETRO ZONA ##################################
	

	*** ################################## DECODIFICA IBAN ##################################
	*CLI_DESABIC  c(80),;  		??????????????? DECODIFICA DELLA BANCA 
	
	IF !EMPTY(ALLTRIM(CLI_CDIBAN))
	   M.CLI_CODCHE = ""
	   M.CLI_CODCIN = ""
	   M.CLI_CODABI = ""
	   M.CLI_CODCAB = ""
	   M.CLI_NUMCC  = ""
	   =DECODIFICA_CODICE_IBAN(ALLTRIM(CLI_CDIBAN),'CLI')
       M.CLI_BAE    = M.CLI_CODABI+M.CLI_CODCAB				   
	ELSE
	   M.CLI_NUMCC   = CLI_CONTCOR  
	   M.CLI_CODCIN  = CLI_CIN  
	   M.CLI_CDIBAN  = ""  
	ENDIF
	
	M.CLI_BSWFOR = CLI_CODBIC   

	*** ################################## DECODIFICA IBAN ##################################


	M.CLI_IMPFID = CLI_FIDO     
	_TIPO_CONTO  = CLI_TIPOCON   
	
	DO CASE 
		
		CASE _TIPO_CONTO = "VENDITE ITALIA"
			M.CLI_CONTO1    = "60010004"		&& VENDITE ITALIA


		CASE _TIPO_CONTO = "VENDITE CEE"
			M.CLI_CONTO1    = "60010006"		&& VENDITE CEE


		CASE _TIPO_CONTO = "VENDITE EXTRACEE"
			M.CLI_CONTO1    = "60010005"		&& VENDITE EXTRACEE

		
		OTHERWISE
			M.CLI_CONTO1    = "60020004"		&& VENDITE DIVERSE    
			
	ENDCASE




	*!*	 ######################################################  INFORMAZIONI MANCANTI  ###################################################à

	*CLI_COMUNE   c(80),;
	*CLI_FATT_A   c(90),;
	*CLI_RAGFOR   c(90),;
	*CLI_LISTINO  c(50),;
	*CLI_CATESCO  c(20),;
	*CLI_SCONVAL  c(03),;
	*CLI_SCONTO1  c(03),;
	*CLI_SCONTO2  c(03),;
	*CLI_SCONTO3  c(03),;
	*CLI_SCONTO4  c(03),;
	*CLI_SCONTO5  c(03),;
	*CLI_MAGGIO1  c(03),;
	*CLI_MAGGIO2  c(03),;
	*CLI_IVAOMA  c(03),;
	*CLI_IVACOM  c(03),;
	*CLI_IVARID  c(03),;			
	*CLI_PROVCZO  n(05,2),; 
	*CLI_INDIDOC  c(90),;  	
	*CLI_SPEDIZI  c(90),;  				
	*CLI_SOTTOC   c(15),;  			    			

	
	*!*	 ######################################################  VALORI DI DEFAULT   ###################################################à
 				

	
	*IF EMPTY(ALLTRIM(M.CLI_PROVIN))				&& SONO CLIENTI ESTERI 
	IF M.CLI_NAZION <> 'ITA' AND !EMPTY(M.CLI_NAZION) AND !EMPTY(M.CLI_PARIVA)
		*M.CLI_IVACEE = M.CLI_CODFIS
		IF (ASC(SUBSTR(ALLTRIM(M.CLI_PARIVA),1,1)) >= 65 AND ASC(SUBSTR(ALLTRIM(M.CLI_PARIVA),1,1)) <= 90)  && IL PRIMO CARATTERE DELLA PARTITA IVA NON DEVE ESSERE GIA' ALFABETICO (A-Z)
			M.CLI_IVACEE = M.CLI_PARIVA
		ELSE
			M.CLI_IVACEE = SUBSTR(M.CLI_NAZION,1,2) + ALLTRIM(M.CLI_PARIVA)
		ENDIF
		
		M.CLI_PARIVA = ""
	ELSE
		M.CLI_IVACEE = ""			
	ENDIF


	M.CLI_VALIMP   	= 0
    M.CLI_NUMINSOL 	= 0

    
    M.CLI_LINGUA 	= ""



    M.CLI_ABI  		= ""
    M.CLI_CAB  		= ""
    M.CLI_ABI2 		= ""
    M.CLI_CAB2 		= ""
    M.CLI_MEZZO 	= ""


    M.CLI_LISTIN 	= ""
    M.CLI_SC1 		= ""
    M.CLI_BOLLI 	= ""
    M.CLI_SPINCA 	= 0

    M.CLI_BDAL    = "0108"
    M.CLI_BAL     = "3108"
    M.CLI_GG1     = "1009"
    M.CLI_B2DAL   = "2012"
    M.CLI_B2AL    = "3112"
    M.CLI_GG2     = "1001"
    M.CLI_TIPFAT  = "FDV"
    M.CLI_FLGTRA  = .T.


	M.CLI_01DAL = '0101'
	M.CLI_02DAL = '0102'
	M.CLI_03DAL = '0103'
	M.CLI_04DAL = '0104'
	M.CLI_05DAL = '0105'
	M.CLI_06DAL = '0106'
	M.CLI_07DAL = '0107'
	M.CLI_09DAL = '0109'
	M.CLI_10DAL = '0110'
	M.CLI_11DAL = '0111'


	M.CLI_01AL = '3101'
	M.CLI_02AL = '2802'
	M.CLI_03AL = '3103'
	M.CLI_04AL = '3004'
	M.CLI_05AL = '3105'
	M.CLI_06AL = '3006'
	M.CLI_07AL = '3107'
	M.CLI_09AL = '3009'
	M.CLI_10AL = '3110'
	M.CLI_11AL = '3011'


	M.CLI_01GG = '0502'
	M.CLI_02GG = '0503'
	M.CLI_03GG = '0504'
	M.CLI_04GG = '0505'
	M.CLI_05GG = '0506'
	M.CLI_06GG = '0507'
	M.CLI_07GG = '0509'
	M.CLI_09GG = '0510'
	M.CLI_10GG = '0511'
	M.CLI_11GG = '0512'



 	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
	M.CLI_DATINS = RIBALTA2(DTOC(DATE()))
	
	M.CLI_ENPACL = 0
	M.CLI_RA     = 0




   	SELECT curs_U_CLI_AN				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
    SCATTER MEMVAR MEMO
    


	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_CLI_AN where " + x_cond + " order by cli_codsoc,cli_codcli"



	IF !ExecCommand(cSql,"U_CLI_AN")
	   RETURN .F.
	ENDIF

	SELECT U_CLI_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_CLI_AN
	IF !ExecRW('','U_CLI_AN','I','','U_CLI_AN')
	  return(.f.)
	ENDIF	

							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO


*!*	SELECT curs_U_CLI_AN
*!*	GO TOP



*!*	****** AGGIORNA TABELLA U_CLI_AN SQL
*!*	IF !ExecRW('','U_CLI_AN','I','','curs_U_CLI_AN')
*!*	   return(.f.)
*!*	ENDIF
*!*		 


*** AGGIORNAMENTO TABELLA U_ANA_CL (TABELLA AGGIUNTIVA IN RAPPORTO 1 a 1 LEGATA A U_CLI_AN)
cSql = "INSERT INTO U_ANA_CL (CLI_CODSOC, CLI_CODCLI, CLI_TISPE) " + ;
       "	SELECT CLI_CODSOC, CLI_CODCLI, 'S' AS CLI_TISPE FROM U_CLI_AN WHERE CLI_CODCLI NOT IN (SELECT CLI_CODCLI FROM U_ANA_CL)"
IF !ExecCommand(cSql,"INS_ANA_CL")
	RETURN .F.
ENDIF

cSql = "DELETE FROM U_ANA_CL WHERE CLI_CODCLI NOT IN (SELECT CLI_CODCLI FROM U_CLI_AN)"
IF !ExecCommand(cSql,"DEL_ANA_CL")
	RETURN .F.
ENDIF


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 