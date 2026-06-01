*************************************************************************************************
*							CONVERSIONE CONDIZIONI DI PAGAMETO									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"delle condizioni di pagamento da foglio Execl	 ?",292,"ATTENZIONE")
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

*!*	*** DEFINIZIONE DEI CURSORI STP

		IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
		   return
		ENDIF


*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL

		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA CONDIZIONI DI PAGAMENTO" NOWAIT

		cSql = "delete from PARA where CODICE LIKE 'CPA%' "
		IF !ExecCommand(cSql,"PARA")
		   return(.f.)
		ENDIF



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

	
		CREATE CURSOR IMPORTAXLS (__DESCRI  c(200),;
			__LIBERA   c(200))			


		
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
		    


		   	M.BAN_CODSOC = '01' 

 
		  	M.CODICE 		= "CPA"+SUBSTR(__DESCRI,1,3)

*!*	IF M.CODICE = "CPA518"
*!*		SET STEP ON 
*!*	ENDIF
 	

*** QUESTA E' DA SISTEMARE CON RAT

		   	M.DESCRI 	= SUBSTR(__DESCRI,7,200)
		   	M.DESCRI 	= APITOSPA(M.DESCRI)
		   	
		   	
		   	_lungh_var  = LEN(ALLTRIM(M.DESCRI))
			STORE 'C1' TO find_str
			_posizione_da_destra=RAT(find_str,M.DESCRI)  
			IF _posizione_da_destra > 2
				M.DESCRI = SUBSTR(M.DESCRI,1,(_posizione_da_destra - 1)) + '  ' + SUBSTR(M.DESCRI,(_posizione_da_destra + 2),_lungh_var)
			ENDIF 
			
		   	
		   	_lungh_var  = LEN(ALLTRIM(M.DESCRI))
			STORE 'C2' TO find_str
			_posizione_da_destra=RAT(find_str,M.DESCRI)  
			IF _posizione_da_destra > 2
				M.DESCRI = SUBSTR(M.DESCRI,1,(_posizione_da_destra - 1)) + '  ' + SUBSTR(M.DESCRI,(_posizione_da_destra + 2),_lungh_var)
			ENDIF 
		   	
		   	
		   	_lungh_var  = LEN(ALLTRIM(M.DESCRI))
			STORE 'C3' TO find_str
			_posizione_da_destra=RAT(find_str,M.DESCRI)  
			IF _posizione_da_destra > 2
				M.DESCRI = SUBSTR(M.DESCRI,1,(_posizione_da_destra - 1)) + '  ' + SUBSTR(M.DESCRI,(_posizione_da_destra + 2),_lungh_var)
			ENDIF 


		   	_lungh_var  = LEN(ALLTRIM(M.DESCRI))
			STORE 'C4' TO find_str
			_posizione_da_destra=RAT(find_str,M.DESCRI)  
			IF _posizione_da_destra > 2 
				M.DESCRI = SUBSTR(M.DESCRI,1,(_posizione_da_destra - 1)) + '  ' + SUBSTR(M.DESCRI,(_posizione_da_destra + 2),_lungh_var)
			ENDIF 


		   	_lungh_var  = LEN(ALLTRIM(M.DESCRI))
			STORE 'VAR' TO find_str
			_posizione_da_destra=RAT(find_str,M.DESCRI)  
			IF _posizione_da_destra > 2 
				M.DESCRI = SUBSTR(M.DESCRI,1,(_posizione_da_destra - 1)) + '  ' + SUBSTR(M.DESCRI,(_posizione_da_destra + 3),_lungh_var)
			ENDIF 


		   	_lungh_var  = LEN(ALLTRIM(M.DESCRI))
			STORE 'RB' TO find_str
			_posizione_da_destra=RAT(find_str,M.DESCRI)  
			IF _posizione_da_destra > 2
				M.DESCRI = SUBSTR(M.DESCRI,1,(_posizione_da_destra - 1)) + '  ' + SUBSTR(M.DESCRI,(_posizione_da_destra + 2),_lungh_var)
			ENDIF 
		   	
	   			   

		   	M.I_LIBERA	 	= ALLTRIM(__LIBERA)
		   	M.I_LIBERA	 	= APITOSPA(M.I_LIBERA)



			_RIBA 			= " "
			IF SUBSTR(M.DESCRI,1,2) = "RB" OR SUBSTR(M.DESCRI,1,3) = "R.B"		&& RICEVUTA BANCARIA
				_RIBA 			= "X"			
			ENDIF

			_POSIZIONE_FM = AT("fm",M.DESCRI)
			IF _POSIZIONE_FM = 0
				_FINE_MESE = "DF"
			ELSE
				_FINE_MESE = "FM"			
			ENDIF


			M.SCAFISS = VAL(SUBSTR(M.I_LIBERA,40,04))			&& GIORNI DA SOMMARE FISSI AL FINE MESE
			
			M.SOLOIMPIVA = ""
			IF SUBSTR(M.I_LIBERA,28,02)	= "RB"					
				M.SOLOIMPIVA = "IVA"								&& SCORPORA L'IMPORTO IVA 
			ENDIF			


			_POSIZIONE_IVA = AT("iva",M.DESCRI)					
			IF _POSIZIONE_IVA > 0
				M.SOLOIMPIVA = "IVA"								&& SCORPORA L'IMPORTO IVA 
			ENDIF

			_POSIZIONE_IVA = AT("IVA",M.DESCRI)					
			IF _POSIZIONE_IVA > 0
				M.SOLOIMPIVA = "IVA"								&& SCORPORA L'IMPORTO IVA 
			ENDIF
 


			*!*	CPA 108-116-118 : B.B.iva+50%imp.60gg 50%imp.90gg 10s                                                                                                                                                                                                                           
			*!*	2 30  3 S F         N   2  C3  60  50  10   8/08  8/08  9/09 12/12 12/12  1/01
			M.PERIMPO    = VAL(SUBSTR(M.I_LIBERA,36,02))		&& PERCENTUALE SULL'IMPONIBILE : 50%imp.



			_NUMERO_SCADENZE 		= VAL(SUBSTR(M.I_LIBERA,01,01))					&& NUMERO SCADENZE
			_GIORNI_SCADENZE_NUM 	= VAL(SUBSTR(M.I_LIBERA,02,03))					&& GIORNI SCADENZE			

			*!*	CPA 108-116-118
			*!*	2 30  3 S F         N   2  C3  60  50  10   8/08  8/08  9/09 12/12 12/12  1/01
			_GIORNI_SCADENZE_PARTICOLARI    = VAL(SUBSTR(M.I_LIBERA,32,02))			&& CASO IN CUI CAMBIA LA PARTENZA DEI GIORNI DI SCADENZA
			
			
			NR_LOOP 			= 0
			_STRINGA_GIORNI 	= ""
			_GIORNI_SCADENZE_  	= 0
			
			DO WHILE .T.
			
				NR_LOOP = NR_LOOP +1
				IF NR_LOOP > _NUMERO_SCADENZE 
					EXIT
				ENDIF
				
				IF NR_LOOP = 1
					_GIORNI_SCADENZE_CHR 	= ALLTRIM(STR(_GIORNI_SCADENZE_NUM,3,0))
					IF _GIORNI_SCADENZE_PARTICOLARI    > 0
						_GIORNI_SCADENZE_CHR 	= ALLTRIM(STR(_GIORNI_SCADENZE_PARTICOLARI,3,0))
						_STRINGA_GIORNI 		= _GIORNI_SCADENZE_CHR
						_GIORNI_SCADENZE_       = _GIORNI_SCADENZE_PARTICOLARI
					ELSE
						_STRINGA_GIORNI 		= _GIORNI_SCADENZE_CHR
						_GIORNI_SCADENZE_       = _GIORNI_SCADENZE_NUM					
					ENDIF
				ELSE
					_GIORNI_SCADENZE_ 		= _GIORNI_SCADENZE_ + _GIORNI_SCADENZE_NUM
					_GIORNI_SCADENZE_CHR 	= STR(_GIORNI_SCADENZE_,3,0)
					_STRINGA_GIORNI 		= _STRINGA_GIORNI + " " + ALLTRIM(_GIORNI_SCADENZE_CHR)
				ENDIF
				
				
				
			ENDDO
			
			
			IF EMPTY(ALLTRIM(_STRINGA_GIORNI))
			  =ATTRIBUISCE_I_GIORNI_DALLA_DESCRIZIONE()
			ENDIF
			
                                                                                                                                                                                          			
*!*	123456789_123456789_123456789_
*!*	FM       X60 90 120                                                                                                                                                                                     
*!*	FM BON    60      

            IF _RIBA  = "X"                                                                                                                                                                                      
				M.LIBERA = _FINE_MESE + SPACE(07) + _RIBA + _STRINGA_GIORNI 
			ELSE
				M.LIBERA = _FINE_MESE + SPACE(01) + "BON" + SPACE(03) + _RIBA + _STRINGA_GIORNI 
			ENDIF
			



		   	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
		   	APPEND BLANK
		   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

									   
		   	_CTR = _CTR +1
		   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
		   


		    	
		    SELECT IMPORTAXLS
			SKIP

		ENDDO


		SELECT curs_PARA
		GO TOP


		****** AGGIORNA TABELLA PARASQL
		IF !ExecRW('','PARA','I','','curs_PARA')
		   return(.f.)
		ENDIF
			 



		=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

		SET DEFAULT TO &PUB_DIR

		RETURN


***********************************************
FUNCTION ATTRIBUISCE_I_GIORNI_DALLA_DESCRIZIONE
***********************************************

_STRINGA_GIORNI_30 		= ""
_STRINGA_GIORNI_60 		= "" 
_STRINGA_GIORNI_90 		= "" 
_STRINGA_GIORNI_120 	= "" 
_STRINGA_GIORNI_150 	= ""  
_STRINGA_GIORNI_180 	= ""  
_STRINGA_GIORNI_210 	= ""  

_POSIZIONE_IVA = AT("30",M.DESCRI)					
IF _POSIZIONE_IVA > 0
	_STRINGA_GIORNI_30 = "30"
ENDIF

_POSIZIONE_IVA = AT("60",M.DESCRI)					
IF _POSIZIONE_IVA > 0
	_STRINGA_GIORNI_60 = "60"
ENDIF

_POSIZIONE_IVA = AT("90",M.DESCRI)					
IF _POSIZIONE_IVA > 0
	_STRINGA_GIORNI_90 = "90"
ENDIF

_POSIZIONE_IVA = AT("120",M.DESCRI)					
IF _POSIZIONE_IVA > 0
	_STRINGA_GIORNI_120 = "120"
ENDIF

_POSIZIONE_IVA = AT("150",M.DESCRI)					
IF _POSIZIONE_IVA > 0
	_STRINGA_GIORNI_150 = "150"
ENDIF

_POSIZIONE_IVA = AT("180",M.DESCRI)					
IF _POSIZIONE_IVA > 0
	_STRINGA_GIORNI_180 = "180"
ENDIF

_POSIZIONE_IVA = AT("210",M.DESCRI)					
IF _POSIZIONE_IVA > 0
	_STRINGA_GIORNI_210 = "210"
ENDIF

IF !EMPTY(_STRINGA_GIORNI_30)
	_STRINGA_GIORNI = _STRINGA_GIORNI_30
ENDIF

IF !EMPTY(_STRINGA_GIORNI_60)
	_STRINGA_GIORNI = _STRINGA_GIORNI + " " + _STRINGA_GIORNI_60
ENDIF

IF !EMPTY(_STRINGA_GIORNI_90)
	_STRINGA_GIORNI = _STRINGA_GIORNI + " " + _STRINGA_GIORNI_90
ENDIF

IF !EMPTY(_STRINGA_GIORNI_120)
	_STRINGA_GIORNI = _STRINGA_GIORNI + " " + _STRINGA_GIORNI_120
ENDIF


IF !EMPTY(_STRINGA_GIORNI_150)
	_STRINGA_GIORNI = _STRINGA_GIORNI + " " + _STRINGA_GIORNI_150
ENDIF


IF !EMPTY(_STRINGA_GIORNI_180)
	_STRINGA_GIORNI = _STRINGA_GIORNI + " " + _STRINGA_GIORNI_180
ENDIF


IF !EMPTY(_STRINGA_GIORNI_210)
	_STRINGA_GIORNI = _STRINGA_GIORNI + " " + _STRINGA_GIORNI_210
ENDIF




RETURN