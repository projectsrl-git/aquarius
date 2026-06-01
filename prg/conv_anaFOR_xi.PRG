*************************************************************************************************
*							CONVERSIONE ANAGRAFICA FORNITORI									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2011 : Xilopan 				 														*
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




*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_FOR_AN SQL ESCLUDENDO IL CODICE CLIENTE AZIENDA PER LA GESTIONE AZIENDA


*!*			__SOC= "01"
*!*			__CLI= "999999999" 

*!*			x_soci = "for_codsoc = '" + __SOC + "'"
*!*			x_codi = "for_codcli <> '" + __CLI + "'"
*!*			x_cond = x_soci + " and " + x_codi

*!*			cSql   = "delete from U_FOR_AN where " + x_cond 
*!*			IF !ExecCommand(cSql,"U_FOR_AN")
*!*			   return(.f.)
*!*			ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
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

		CREATE CURSOR IMPORTAXLS (FOR_CODCLI  c(06),;
			FOR_RAGSOC   c(80),;			
			FOR_RAGDUE   c(80),;
			FOR_INDIR    c(70),;
			FOR_LOCALI   c(80),;
			FOR_PROVIN   c(02),;
			FOR_CAP      c(10),;
			FOR_TELEFO   c(30),;
			FOR_NOTE     c(200),;
			FOR_NAZION   c(03),;
			FOR_CODFIS   c(16),;
			FOR_PARIVA   c(11),;
			FOR_VALUTA   c(03),;
			FOR_CONPAG   c(03),;
			FOR_FAX      c(30))

		
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



    
*!*	#####################################################


				M.ID_UNIQUE  = ""
            	M.FOR_CODSOC = '01' 

           
           		M.FOR_CODCLI = FOR_CODCLI
 	        	M.FOR_CODCLI = TRC(PUB_LCL,ALLTRIM(FOR_CODCLI))
 	            
  				M.FOR_RAGSOC = ALLTRIM (FOR_RAGSOC)
   		        M.FOR_RAGSOC = UPPER(M.FOR_RAGSOC)
                M.FOR_RAGSOC = APITOSPA(M.FOR_RAGSOC)

  				M.FOR_RAGDUE = ALLTRIM (FOR_RAGDUE)
   		        M.FOR_RAGDUE = UPPER(M.FOR_RAGDUE)
                M.FOR_RAGDUE = APITOSPA(M.FOR_RAGDUE)

		   		M.FOR_INDIR = ALLTRIM (FOR_INDIR)
   		        M.FOR_INDIR  = UPPER(M.FOR_INDIR)
                M.FOR_INDIR  = APITOSPA(M.FOR_INDIR)

				M.FOR_CAP = ALLTRIM (FOR_CAP)
				
				M.FOR_LOCALI = ALLTRIM (FOR_LOCALI)
   		        M.FOR_LOCALI = UPPER(M.FOR_LOCALI)
                M.FOR_LOCALI = APITOSPA(M.FOR_LOCALI)

				M.FOR_PROVIN = ALLTRIM (FOR_PROVIN)
   		        M.FOR_PROVIN = UPPER(M.FOR_PROVIN)
                M.FOR_PROVIN = APITOSPA(M.FOR_PROVIN)


				M.FOR_TELEFO = ALLTRIM (FOR_TELEFO)
				M.FOR_NOTE   = ALLTRIM (FOR_NOTE)				
				M.FOR_NAZION = ALLTRIM (FOR_NAZION)	
			    IF EMPTY(ALLTRIM(M.FOR_NAZION))
			       M.FOR_NAZION = 'ITA'
			    ENDIF								

				M.FOR_IVACEE = ""
				M.FOR_PARIVA =ALLTRIM (FOR_PARIVA)	
				M.FOR_CODFIS =ALLTRIM (FOR_CODFIS)
	
	
			    M.FOR_VALUTA = ALLTRIM (FOR_VALUTA)
			    IF EMPTY(ALLTRIM(M.FOR_VALUTA))
			       M.FOR_VALUTA = 'EUR'
			    ENDIF	
	
			    M.FOR_CONPAG = ALLTRIM (FOR_CONPAG)				
				M.FOR_FAX = ALLTRIM (FOR_FAX)



				*!*	 ######################################################  INFORMAZIONI MANCANTI  ###################################################à

                M.FOR_CODIVA = '21'
			    M.FOR_ABI = ""
			    M.FOR_CAB = ""

				M.FOR_BAE = ""
				M.FOR_CODCHE = ""
				M.FOR_NUMCC  = ""
				m.FOR_codcin = ""
				m.FOR_codabi = ""
				m.FOR_codcab = ""
                M.FOR_cdiban = SUBSTR(m.FOR_nazion,1,2) + m.FOR_codche + m.FOR_codcin + m.FOR_codabi + m.FOR_codcab + m.FOR_numcc
				M.FOR_EMAIL  = ""
				M.FOR_CONTO1 = ""
				
				*!*	 ######################################################  VALORI DI DEFAULT   ###################################################à


                M.FOR_BDAL   = "0108"
                M.FOR_BAL    = "3108"
                M.FOR_GG1    = "1009"
                M.FOR_B2DAL  = "2012"
                M.FOR_B2AL   = "3112"
                M.FOR_GG2    = "1001"
                M.FOR_TIPFAT = "FDV"
                M.FOR_FLGTRA = .T.

			   	M.FOR_COSATRATTA 		= 'GENER'
			   	M.FOR_GRADOIMPORTANZA 	= 'PRIMA'
			   	M.FOR_FORMAPAGAMENTO 	= 'RIMES'
			   	M.FOR_TIPOCONTRATTO 	= 'SCADE'
			   	M.FOR_CODACQ	 		= '001'
			   	M.FOR_PRIPAGA			= '0500'

				
				M.TIPOFOR = ""
				M.for_Dtnasc= ""
				M.for_lunasc=""
				M.FOR_PRVNASC=""
 
				M.FOR_VALORD = 0
				M.FOR_IMPFID = 0
			    
			    M.FOR_LINGUA = ""
			    M.FOR_AGE = ""
			    M.FOR_ABI2 = ""
			    M.FOR_CAB2 = ""
			    M.FOR_ZONA = ""
			    M.FOR_SOTZONA = ""
			    M.FOR_MEZZO = ""
			    M.FOR_LISTIN = ""
			    M.FOR_SC1 = ""
			    M.FOR_BOLLI = ""
			    M.FOR_SPINCA = ""
		   

 				M.FOR_DATNEW = RIBALTA2(DTOC(DATE()))
				M.FOR_DATINS = RIBALTA2(DTOC(DATE()))


*!*	#####################################################

   	SELECT curs_U_FOR_AN				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
    SCATTER MEMVAR MEMO
		
		
	x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "for_codcli = '" + M.for_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_for_AN where " + x_cond + " order by for_codsoc,for_codcli"



	IF !ExecCommand(cSql,"U_for_AN")
	   RETURN .F.
	ENDIF

	SELECT U_for_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_for_AN
	IF !ExecRW('','U_for_AN','I','','U_for_AN')
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


 