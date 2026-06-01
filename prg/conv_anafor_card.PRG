*************************************************************************************************
*							CONVERSIONE ANAGRAFICA FORNITORI									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2013 : Cardioline			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica fornitori da foglio Execl	 ?",292,"ATTENZIONE")
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


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA FORNITORI" NOWAIT

IF !ExecCommand("select * from U_FOR_AN where 1=0","curs_U_FOR_AN")
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



*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_FOR_AN SQL ESCLUDENDO IL CODICE CLIENTE AZIENDA PER LA GESTIONE AZIENDA


__SOC= "01"
__CLI= "000000" 

x_soci = "FOR_codsoc = '" + __SOC + "'"
x_codi = "FOR_codcli <> '" + __CLI + "'"
x_cond = x_soci + " and " + x_codi

cSql   = "delete from U_FOR_AN where " + x_cond 
IF !ExecCommand(cSql,"U_FOR_AN")
   return(.f.)
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA
PUBLIC _CODICE_ZONA
_CODICE_ZONA = 0



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

CREATE CURSOR IMPORTAXLS (FOR_CODCLI  c(10),;
	FOR_RAGSOC 	 c(80),;
	FOR_INDIR    c(70),;
	FOR_LOCALI   c(80),;
	FOR_CAP      c(10),;
	FOR_COMUNE   c(80),;
	FOR_PROVIN   c(02),;			
	FOR_NAZIONE  c(30),;
	FOR_PREFTEL  c(30),;
	FOR_TELEFO   c(30),;
	FOR_PREFAX   c(30),;			
	FOR_FAX      c(30),;
	FOR_CELLUL   c(30),; 
	FOR_HOMPAG   c(100),;
	FOR_EMAIL    c(90),;
	FOR_FATT_A   c(90),;
	FOR_RAGFOR   c(90),;
	FOR_CODFIS   c(16),;
	FOR_ALIQ_IVA c(60),;
	FOR_PARIVA   c(11),;
	FOR_LISTINO  c(50),;
	FOR_CATESCO  c(20),;
	FOR_TIPOPAG  c(90),;
	FOR_CVALUTA  c(03),;
	FOR_SCONVAL  c(03),;
	FOR_SCONTO1  c(03),;
	FOR_SCONTO2  c(03),;
	FOR_SCONTO3  c(03),;
	FOR_SCONTO4  c(03),;
	FOR_SCONTO5  c(03),;
	FOR_MAGGIO1  c(03),;
	FOR_MAGGIO2  c(03),;
	FOR_IVAOMA  c(03),;
	FOR_IVACOM  c(03),;
	FOR_IVARID  c(03),;			
	FOR_DESAGE  c(90),;
	FOR_PROVAGE  n(05,2),;
	FOR_PROVCZO  n(05,2),;
	FOR_DESPORT  c(90),;			
	FOR_INDISPE  c(90),;   
	FOR_INDIDOC  c(90),;  	
	FOR_DESVET   c(90),;  						
	FOR_SPEDIZI  c(90),;  
	FOR_DESZON   c(50),;  
	FOR_DESABIC  c(80),;  
	FOR_CONTCOR  c(50),;  
	FOR_CIN      c(2),;  
	FOR_FIDO     n(12,2),;
	FOR_CDIBAN   c(50),;  
	FOR_CODBIC   c(15),;  
	FOR_SOTTOC   c(15),;  
	FOR_TIPOCON  c(15))  


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
    

    IF ALLTRIM(FOR_CODCLI) = "Codice"
       SELECT IMPORTAXLS   && scarto primo record
       SKIP +1
       LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
    
    
*!*	#####################################################


    M.ID_UNIQUE  = ""
   	M.FOR_CODSOC = PUB_CODSOC 
    M.FOR_CODCLI = TRC(PUB_LCL,ALLTRIM(FOR_CODCLI))
 	M.FOR_RAGSOC = ALLTRIM (FOR_RAGSOC)
   	M.FOR_RAGSOC = UPPER(M.FOR_RAGSOC)
    M.FOR_RAGSOC = APITOSPA(M.FOR_RAGSOC)
 	M.FOR_RAGDUE = ""
   	M.FOR_INDIR  = ALLTRIM (FOR_INDIR)
   	M.FOR_INDIR  = UPPER(M.FOR_INDIR)
    M.FOR_INDIR  = APITOSPA(M.FOR_INDIR)
	M.FOR_LOCALI = ALLTRIM (FOR_LOCALI)
   	M.FOR_LOCALI = UPPER(M.FOR_LOCALI)
    M.FOR_LOCALI = APITOSPA(M.FOR_LOCALI)
	M.FOR_CAP    = ALLTRIM(FOR_CAP)
	M.FOR_PROVIN = ALLTRIM (FOR_PROVIN)
   	M.FOR_PROVIN = UPPER(M.FOR_PROVIN)
    M.FOR_PROVIN = APITOSPA(M.FOR_PROVIN)


	*** ################################## AGGIORNA PARAMETRO NAZIONE ##################################
    M.FOR_NAZIONE = UPPER(FOR_NAZIONE)
    
    IF ALLTRIM(FOR_NAZIONE) = 'HONDURAS'
    	M.FOR_NAZION 	= "HOD"			
	ENDIF     
	
    IF ALLTRIM(FOR_NAZIONE) = 'Italia'
    	M.FOR_NAZION 	= "ITA"			
	ELSE 
		M.FOR_NAZION 	= ALLTRIM(UPPER(SUBSTR(FOR_NAZIONE,1,3)))	
	ENDIF 
	
	IF EMPTY(ALLTRIM(M.FOR_NAZION))
		M.FOR_NAZION = "ITA"
	ENDIF
	
	gcFindString= M.FOR_NAZION
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
		x_codi = "codice = 'STA"+M.FOR_NAZION+"'"
		x_cond = x_codi
		cSql = "select * from PARA where " + x_cond
		IF !ExecRW(cSql,"PARA","R")
		   return(.f.)
		ENDIF
		SELECT PARA
		GO TOP
		IF EOF()
		   APPEND BLANK
		   V1 = "STA"+M.FOR_NAZION
		   REPLACE CODICE WITH V1
		   REPLACE DESCRI WITH ALLTRIM(M.FOR_NAZIONE)
		ENDIF
		IF !ExecRW(cSql,"PARA","W")
		   return(.f.)
		ENDIF
	ENDIF       				
 	SELECT IMPORTAXLS 
	*** ################################## AGGIORNA PARAMETRO NAZIONE ##################################
	
	M.FOR_TELEFO = ALLTRIM(FOR_PREFTEL)	+ " " + ALLTRIM(FOR_TELEFO)		
	M.FOR_FAX    = ALLTRIM(FOR_PREFAX)  + " " + ALLTRIM(FOR_FAX)
    M.FOR_NOTE   = ALLTRIM(FOR_CELLUL)	
	M.FOR_HOMPAG = LOWER(FOR_HOMPAG)
    M.FOR_EMAIL  = LOWER(FOR_EMAIL)

	M.FOR_CODFIS = UPPER(FOR_CODFIS)


	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO CONDIZIONI IVA
	gcFindString= ALLTRIM(FOR_ALIQ_IVA)
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
		M.FOR_CODIVA   	= SUBSTR(CODICE,4,3)
	ELSE
		M.FOR_CODIVA   	= "21"
    ENDIF       				
 	SELECT IMPORTAXLS 


	M.FOR_PARIVA = UPPER(FOR_PARIVA)	


	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO CONDIZIONI DI PAGAMENTO
	gcFindString= ALLTRIM(FOR_TIPOPAG)
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
		M.FOR_CONPAG   	= SUBSTR(CODICE,4,3)
	ELSE
		M.FOR_CONPAG   	= PUB_CPA
    ENDIF       				
 	SELECT IMPORTAXLS    


	IF EMPTY(ALLTRIM(FOR_CVALUTA))
	    M.FOR_VALUTA = PUB_VALU
	ELSE
		M.FOR_VALUTA = UPPER(SUBSTR(FOR_CVALUTA,1,3))
	ENDIF 
	
	

	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO VETTORI
	gcFindString= ALLTRIM(FOR_DESVET)
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
	    M.FOR_VETTO1   	= SUBSTR(CODICE,4,3)
	ELSE
		M.FOR_VETTO1   	= ""
	ENDIF       				
 	SELECT IMPORTAXLS 



    M.FOR_ZONA   	= ""
*!*	*!*		*** ################################## CREA PARAMETRO ZONA ##################################
*!*	*!*		*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO ZONA
*!*	*!*		IF EMPTY(ALLTRIM(FOR_DESZON))
*!*	*!*			M.FOR_ZONA   	= ""	
*!*	*!*		ELSE
*!*	*!*		    M.FOR_DESZON=FOR_DESZON
*!*	*!*			gcFindString= ALLTRIM(FOR_DESZON)
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
*!*	*!*			    M.FOR_ZONA   	= SUBSTR(CODICE,4,3)
*!*	*!*			ELSE
*!*	*!*				M.FOR_ZONA   	= ""
*!*	*!*				_CODICE_ZONA = _CODICE_ZONA  + 1
*!*	*!*				IF LEN(ALLTRIM(STR(_CODICE_ZONA,3,0))) = 1
*!*	*!*					M.FOR_ZONA   	= "00" + ALLTRIM(STR(_CODICE_ZONA,3,0))
*!*	*!*				ENDIF
*!*	*!*				IF LEN(ALLTRIM(STR(_CODICE_ZONA,3,0))) = 2
*!*	*!*					M.FOR_ZONA   	= "0" +	 ALLTRIM(STR(_CODICE_ZONA,3,0))
*!*	*!*				ENDIF
*!*	*!*				x_codi = "codice = 'ZON"+M.FOR_ZONA+"'"
*!*	*!*				x_cond = x_codi
*!*	*!*				cSql = "select * from PARA where " + x_cond
*!*	*!*				IF !ExecRW(cSql,"PARA","R")
*!*	*!*				   return(.f.)
*!*	*!*				ENDIF
*!*	*!*				SELECT PARA
*!*	*!*				GO TOP
*!*	*!*				IF EOF()
*!*	*!*				   APPEND BLANK
*!*	*!*				   V1 = "ZON"+M.FOR_ZONA
*!*	*!*				   REPLACE CODICE WITH V1
*!*	*!*				   REPLACE DESCRI WITH ALLTRIM(M.FOR_DESZON)
*!*	*!*				ENDIF
*!*	*!*				IF !ExecRW(cSql,"PARA","W")
*!*	*!*				   return(.f.)
*!*	*!*				ENDIF
*!*	*!*			ENDIF       				
*!*	*!*		 	SELECT IMPORTAXLS 
*!*	*!*		 ENDIF
	 
	*** ################################## CREA PARAMETRO ZONA ##################################
	

	*** ################################## DECODIFICA IBAN ##################################
	*FOR_DESABIC  c(80),;  		??????????????? DECODIFICA DELLA BANCA 
	
	IF !EMPTY(ALLTRIM(FOR_CDIBAN))
	   M.FOR_CODCHE = ""
	   M.FOR_CODCIN = ""
	   M.FOR_CODABI = ""
	   M.FOR_CODCAB = ""
	   M.FOR_NUMCOC = ""
	   =DECODIFICA_CODICE_IBAN(ALLTRIM(FOR_CDIBAN),'FOR')
       M.FOR_BAE    = M.FOR_CODABI+M.FOR_CODCAB				   
	ELSE
	   M.FOR_NUMCOC  = FOR_CONTCOR  
	   M.FOR_CODCIN  = FOR_CIN  
	   M.FOR_CDIBAN  = ""  
	ENDIF
	
	*M.FOR_BSWFOR = FOR_CODBIC   

	*** ################################## DECODIFICA IBAN ##################################


	*** ################################## DECODIFICA CONTO CONTABILE ##################################

	_TIPO_CONTO  = ALLTRIM(FOR_TIPOCON)
	
	IF !EXECCOMMAND("SELECT * FROM CONTI WHERE CON_DESCR='"+_TIPO_CONTO+"' AND CON_ANNO='"+ALLTRIM(PUB_ANNO)+"' AND CON_SOC = '01' ORDER BY CON_CONTO ","CURS_CONTI")
	   RETURN .F.
	ENDIF
	SELECT CURS_CONTI
	IF !EOF()
		M.FOR_CONTO1 = CON_CONTO
	ELSE
		M.FOR_CONTO1 = ""
	ENDIF
 	SELECT IMPORTAXLS 
 	
 	
   

	*!*	 ######################################################  INFORMAZIONI MANCANTI  ###################################################à

	*FOR_COMUNE   c(80),;
	*FOR_FATT_A   c(90),;
	*FOR_RAGFOR   c(90),;
	*FOR_LISTINO  c(50),;
	*FOR_CATESCO  c(20),;
	*FOR_SCONVAL  c(03),;
	*FOR_SCONTO1  c(03),;
	*FOR_SCONTO2  c(03),;
	*FOR_SCONTO3  c(03),;
	*FOR_SCONTO4  c(03),;
	*FOR_SCONTO5  c(03),;
	*FOR_MAGGIO1  c(03),;
	*FOR_MAGGIO2  c(03),;
	*FOR_IVAOMA  c(03),;
	*FOR_IVACOM  c(03),;
	*FOR_IVARID  c(03),;			
	*FOR_PROVCZO  n(05,2),; 
	*FOR_INDIDOC  c(90),;  	
	*FOR_SPEDIZI  c(90),;  				
	*FOR_SOTTOC   c(15),;  			    			
	
	*!*	 ######################################################  VALORI DI DEFAULT   ###################################################à
 				




    M.FOR_BDAL    = "0108"
    M.FOR_BAL     = "3108"
    M.FOR_GG1     = "1009"
    M.FOR_B2DAL   = "2012"
    M.FOR_B2AL    = "3112"
    M.FOR_GG2     = "1001"


 	M.FOR_DATNEW = RIBALTA2(DTOC(DATE()))
	M.FOR_DATINS = RIBALTA2(DTOC(DATE()))
	


   	SELECT curs_U_FOR_AN				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
    SCATTER MEMVAR MEMO
    


	x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "FOR_codcli = '" + M.FOR_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"



	IF !ExecCommand(cSql,"U_FOR_AN")
	   RETURN .F.
	ENDIF

	SELECT U_FOR_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_FOR_AN
	IF !ExecRW('','U_FOR_AN','I','','U_FOR_AN')
	  return(.f.)
	ENDIF	

							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO


SELECT curs_U_FOR_AN
GO TOP



*!*	****** AGGIORNA TABELLA U_FOR_AN SQL
*!*	IF !ExecRW('','U_FOR_AN','I','','curs_U_FOR_AN')
*!*	   return(.f.)
*!*	ENDIF
*!*		 



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 