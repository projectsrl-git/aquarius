*****************************************************************************
* 			  funzione di spedizione / ricezione del file dati				*
*****************************************************************************

* il seguente programma esegue un ciclo sulla tabella U_FTP_AN , nella quale sono presenti
* i dati necessari alla spedizione e/o ricezione dati verso e/o dai Punti di Vendita
*
* per questo sono eseguite le seguenti attività :
*

	*  1 - elabora tabella U_FTP_AN estraendo dati utili per le routine FTP
	*  2 - identifica directory del singolo punto di vendita con i nomi dei file 
	*  3 - identifica directory del server centrale
	*  4 - crea una cartella dove scrivere i log
	*  5 - si connette al punto di vendita e 

	  * =============================================================
	   *  SE  RICEZIONE  dal punto di vendita verso la sede
		* ===========================================================

		*  6 - esegue la routine di ricezione via FTP (.GetFromFtp), mettendo i file nelle cartella di
		*      destinazione specificata nella tabella U_FTP_AN

   	  * =============================================================
	   *  SE  spedizione dalla SEDE al punto di vendita
		* ===========================================================

		*  6 - esegue la routine di invio via FTP (.PutToFtp)
		*  7 - copia i file in una DIR di backup con data e ora (ci sarà poi una procedura di RAR in tempi prefissati)
		*  8 - cancella i file spediti dalla dir della sede 		

*
*	APOLLO è un programa che viene eseguito in BackGround. La sua esecuzione viene decisa dallo 
*   Schedulatore di programmi (Polling), che ne decide la frequenza e il periodo di esecuzione
*

PARAMETERS _codicePuntoVendita

********************************************************************************
*!*	RICEZIONE FILE E/O CONTENUTO CARTELLE
********************************************************************************

**cSql="select * from U_FTP_AN order by ftp_codpdv"

** PRENDO SOLO FORMIA
**cSql="select * from U_FTP_AN where ftp_numser='125412'"

*** Query CORRETTA
cSql="select * from U_FTP_AN where ftp_tipcom='S' and ftp_execute=1 and ftp_codpdv = '"+ALLTRIM(_codicePuntoVendita)+"' order by ftp_codpdv"


*** Query per provare i soli INVII
**cSql="select * from U_FTP_AN where ftp_tipcom='S' and ftp_tipo='I' order by ftp_codpdv"

IF !ExecCommand(cSql,"CU_FTP_AN")
   return(.f.)
ENDIF

SET STEP ON 

SELECT CU_FTP_AN

GO TOP 

do while !eof()
    
	SCATTER MEMVAR MEMO
	
	_tipoAzione = ALLTRIM(m.ftp_tipo)
	_desPDV     = UPPER(m.ftp_despdv)
	_codPDV     = ALLTRIM(m.ftp_codpdv)
	_hostIP     = ALLTRIM(m.ftp_host)
	_hostUser   = ALLTRIM(m.ftp_user)
	_hostPwd    = ALLTRIM(m.ftp_passwo)
	_dirDa      = ALLTRIM(m.ftp_pathda) 
	_dirA       = ALLTRIM(m.ftp_pathal)
	_nomeFile   = ALLTRIM(m.ftp_nomefi)
	_tipoComp	= ALLTRIM(m.ftp_tipcom)
	_TSP_isWorking = .F. 
	



	*!* --------------------------------------------------
	*!* creazione cartella in cui scrivere i log dei PDV
	*!* --------------------------------------------------
	IF !w_creadir("\Log\LogFtp")
		RETURN
	ELSE
		_file_log	=	"\Log\LogFtp\Log_PDV" + _codPDV + "." + DTOS(DATE())+".log"
		IF !FILE(_file_log)
			_hd=FCREATE(_file_log)
			IF _hd < 1
				=MESSAGEBOX("Errore durante la creazione del file di log",16,"*** ATTENZIONE ***")
				RETURN
			ENDIF
			=FPUTS(_hd,"Log del giorno "+DTOC(DATE()))
			=FPUTS(_hd,"")
			=FCLOSE(_hd)
		ENDIF 
	ENDIF



********************************************************************************
*!*	RICEZIONE FILE E/O CONTENUTO CARTELLE - IF _tipoAzione = "R" (ricezione)
********************************************************************************
	IF (_tipoAzione = "R")
		
		*!* --------------------------------------------------
		*!* creazione della connessione FTP con i PDV
		*!* --------------------------------------------------
		
		PRIVATE objFtp 
		objFtp = CreateObject("Tftp") 

		* -->> Variabili per la scrittura nel log
		* --------------------------------------------

		_host_remoto	=	_hostIP+_dirDa
		_host_locale	=	_dirA

		FOR _volte=1 TO 3
			objFtp.FtpConnect(_hostIP,_hostUser,_hostPwd) 
			IF Not objFtp.IsConnected 
			    WAIT WINDOW NOWAIT "Tentativo di connessione a " + _desPDV + " n." + STR(_volte,1) + " in corso..." 
			    _dicitura="Tentativo di connessione a " + _desPDV + " n." + STR(_volte,1) + " in corso..."
			    =scrivi_log(_dicitura)
			ELSE 
				EXIT 
			ENDIF 	
		NEXT 
		IF _volte > 3
			_dicitura="Tentativo di connessione a " + _desPDV + " FALLITA!!!!!!!!!!!!!!"
			=scrivi_log(_dicitura)
			SELECT CU_FTP_AN
			skip+1
			loop
		ENDIF 
		


		* --------------------------------------------
		* -->> settaggio delle directory di default
		* --------------------------------------------

		IF EMPTY(_dirDa)
			_dirDa = "/"
		ENDIF

		IF EMPTY(_dirA)
			_dirA = "c:\"
		ENDIF

		* ---------------------------------------------------------------
		* -->> Verifica di non esistenza file nella directory per ovviare
		* -->> al caso in cui "demoni" pdv funzionano correttamente ma 
		* -->> sulla sede centrale funziona correttamente il solo apollo
		* -->> ma non il ric_pdv_sede con conseguente perdita di dati
		* -->> in quanto gli scontrini pdv vanno in sovrapposizione a 
		* -->> quelli precedenti (Rino 28/08/2003)
		* ------------------------------------------------------------
 
        IF ADIR(PIPPO,_dirA+'*.*') <> 0
           SELECT cu_ftp_an
           SKIP +1
           LOOP
        ENDIF
        
		* ------------------------------------------------------------
		* -->> Ricezione di un file o del contenuto di una cartella
		* ------------------------------------------------------------
 
		WITH objFtp 
		    .SetCurrentDir(_dirDa) 
	
			**********************************************************			
			** Se esiste il file SEMAFORO.PD2 sulla SEDE  
			** sta elaborando RIC_PDV_SEDE; non faccio nulla	
			**********************************************************
			IF FILE(_dirA+"SEMAFORO.PD2")
			ELSE

				*******************************************************				
				** Creo file SEMAFORO.SE2 sulla SEDE
				*******************************************************
				_a =FCREATE(_dirA+"SEMAFORO.SE2")
				IF _a < 1
***					=MESSAGEBOX("Errore durante la creazione del file SEMAFORO.SE2",16,"*** ATTENZIONE ***")
					=FCLOSE(_a)				
					RETURN
				ENDIF
				=FCLOSE(_a)				


				*******************************************************
				** GetFtp di un unico File	
				*******************************************************
				IF !EMPTY(_nomeFile)

					* se esiste SEMAFORO.PD1 posso prelevare anche il
					* file richiesto
					* ---------------------------------------------------
			    	IF .GetFromFtp("SEMAFORO.PD1", "c:\SEMAFORO.PD1")	
				    	IF .GetFromFtp(_nomefile, _dirA+_nomeFile)
			    	  		** Cancellazione file remoto
				    		.DeleteFile(_nomeFile)
							.DeleteFile(_dirDa+"SEMAFORO.PD1")
					    ENDIF 
				    ENDIF 
				    
				** GetFtp del contenuto di una cartella
				ELSE
				    .DirToCursor("cur_remoto")  
				    
				    SELECT cur_remoto
					GO top
					SCAN
						* se esiste SEMAFORO.PD1 posso scaricare tutti i file remoti
						* tranne i SEMAFORI
						IF ("SEMAFORO.PD1" $ ALLTRIM(UPPER(cur_remoto.filename)))
						    GO top
						    SCAN
						    	** Per non fare il Get anche del file semaforo
								IF ! ("SEMAFORO" $ ALLTRIM(UPPER(cur_remoto.filename)))
									WAIT WINDOW "Inizio ricezione di : "+ALLTRIM(cur_remoto.filename)+ " dal PDV: " + _desPDV nowait
						    		IF .GetFromFtp(ALLTRIM(cur_remoto.filename), _dirA+ALLTRIM(cur_remoto.filename)) 
										.DeleteFile(ALLTRIM(cur_remoto.filename))
							    	ENDIF
									WAIT WINDOW "FINE ricezione di : "+ALLTRIM(cur_remoto.filename)+ " dal PDV: " + _desPDV  nowait				    	
						    	ENDIF 
						    ENDSCAN
						    ** Ripristino a file SEMAFORO per successiva transazione
							.DeleteFile(_dirDa+"SEMAFORO.PD1")
							** Cancellazione file SEMAFORO.SE2 sulla SEDE
							EXIT 
						ENDIF 
					ENDSCAN
									    
				ENDIF 

	    		_flagSemaforo = _dirA+"SEMAFORO.SE2"
				ERASE &_flagSemaforo

			ENDIF
		
		ENDWITH 

********************************************************************************
*!*	SPEDIZIONE FILE E/O CONTENUTO CARTELLE - IF _tipoAzione = "I" (invio)
********************************************************************************
	ELSE 

		PRIVATE objFtp 
		objFtp = CreateObject("Tftp") 

		* -->> Variabili per la scrittura nel log
		* --------------------------------------------
		_host_remoto	=	_hostIP+_dirA
		_host_locale	=	_dirDA



		FOR _volte=1 TO 5
			objFtp.FtpConnect(_hostIP,_hostUser,_hostPwd) 
			IF Not objFtp.IsConnected 
			    WAIT WINDOW NOWAIT "Tentativo di connessione a " + _desPDV + " n." + STR(_volte,1) + " in corso..." 
			    _dicitura="Tentativo di connessione a " + _desPDV + " n." + STR(_volte,1) + " in corso..."
			    =scrivi_log(_dicitura)
			ELSE 
				EXIT 
			ENDIF 	
		NEXT 
		IF _volte > 5
			_dicitura="Tentativo di connessione a " + _desPDV + " FALLITA!!!!!!!!!!!!!!"
			=scrivi_log(_dicitura)
			SELECT CU_FTP_AN
			skip+1
			loop
		ENDIF 



		* --------------------------------------------
		* -->> settaggio delle directory di default
		* --------------------------------------------
		IF EMPTY(_dirDa)
			_dirDa = "c:\"
		ENDIF

		IF EMPTY(_dirA)
			_dirA = "/"
		ENDIF	



		* ------------------------------------------------------------
		* -->> Spedizione di un file o del contenuto di una cartella
		* ------------------------------------------------------------
		WITH objFtp 

		    .SetCurrentDir(_dirDa)
		    
				IF FILE(_dirDa+"SEMAFORO.SED")		&& Sta lavorando TRA_SEDE_PDV
			  	ELSE

					** Se la directory sulla SEDE è PIENA
					IF ADIR(CURS_DIR,_dirDa+'*.*') > 0
				
						.SetCurrentDir(_dirA)

	    				.DirToCursor("cur_remoto")  
							

						*** Se nella dir sul dito FTP del PDV esiste il file "SEMAFORO.PDV",
						*** sta lavorando RIC_SEDE_PDV; non faccio nulla
						SELECT cur_remoto
						
						GO TOP 
						SCAN 							
							IF ("SEMAFORO.PDV" $ ALLTRIM(UPPER(cur_remoto.filename)))
								_TSP_isWorking = .T.
							ENDIF
						ENDSCAN 						

						
						*** 'T'ra 'S'ede 'P'dv is working (sta lavorando TRA_SEDE_PDV) 
						IF !(_TSP_isWorking )

							*******************************************************				
							** Creo file	SEMAFORO.APO	sulla SEDE
							*******************************************************
							_a =FCREATE(_dirDa+"SEMAFORO.APO")
							IF _a < 1
								=FCLOSE(_a)				
								RETURN
							ENDIF
							=FCLOSE(_a)	
							

							.SetCurrentDir(_dirA)
							.RenameFile("SEMAFORO","SEMAFORO.APO")
							  
								IF !EMPTY(_nomeFile)
									**WAIT WINDOW "Sto inviando: "+_nomeFile nowait
							    	IF .PutToFtp(_dirDa+ALLTRIM(_nomeFile), ALLTRIM(_nomeFile)) 
							    		_fileinviato = _dirDa+ALLTRIM (_nomeFile)

							    		** Pulizia file inviati
							    		ERASE &_fileinviato 
							    		
							    		.RenameFile("SEMAFORO.APO","SEMAFORO")
							    		
								    ENDIF 
								ELSE
								    =DirLocalToCur("cur_locale",_dirDa) 

								    SELECT cur_locale

								    GO TOP 
								    SCAN 
				
											
											** Per non fare il PUT anche del file semaforo
											IF ! ("SEMAFORO.APO" $ ALLTRIM(UPPER(cur_locale.filename)))
												WAIT WINDOW "Inizio INVIO di : "+ALLTRIM(cur_locale.filename)+ " AL PDV: " + _desPDV nowait
									    		IF .PutToFtp(_dirDa+ALLTRIM(cur_locale.filename), _dira + ALLTRIM(cur_locale.filename)) 
									    		
									    			_curFile = _dirDa + ALLTRIM(cur_locale.filename)
									    			 
													** Pulizia file inviati
										    		ERASE &_curFile 
								    		 	    		
										    	ENDIF
												WAIT WINDOW "Fine INVIO di : "+ALLTRIM(cur_locale.filename)+ " AL PDV: " + _desPDV nowait 
										    ENDIF 
										    
									    
								    ENDSCAN

					    			.RenameFile("SEMAFORO.APO","SEMAFORO")				    							    						    	
								
									_semApoSede = _dirDa + "SEMAFORO.APO"
									ERASE &_semApoSede 		    			
									EXIT 
								ENDIF
						
						ENDIF    && tra_pdv_sede is working

					ENDIF && Se la directory è PIENA						
					
				ENDIF && if file(SEMAFORO.SED)	

		ENDWITH 

	ENDIF 
	
	SELECT CU_FTP_AN
	skip

enddo

*!*	*!* ------------------------------------------------------------------------------------------------------------------------------------
*!*	*!* -->> Come utilizzare le procedure di connessione ftp e quali funzioni sono disponibili
*!*	*!* -->> nell'oggetto FTP creato, il loro significato e il loro utilizzo
*!*	*!* ------------------------------------------------------------------------------------------------------------------------------------
*!*	*!* 
*!*	*!*	dell'oggetto 'objFtp' si possono testare le seguenti variabili:
*!*	*!*	    .LastErr 		-->>	codice ultimo messaggio di errore
*!*	*!*	    .ErrMsg 		-->>	messaggio di errore
*!*	*!*	    .host 			-->>	url del sito FTP (ftp.microsoft.com)
*!*	*!*	    .usr 			-->>	user-id
*!*	*!*	    .pswd 			-->>	password
*!*	*!*	    .IsConnected	-->>	flag di connessione al sito FTP  (.F. = non connesso - .T. = connesso)
*!*	*!*	    .hInternet	 	-->>	flag di connessione a internet (1 = connesso - 0 = disconnesso)
*!*	*!*	    .hConn			-->>	numero del canale aperto per la connessione FTP (0 = nessun canale aperto)
*!*	*!* ------------------------------------------------------------------------------------------------------------------------------------
*!*	*!*	dell'oggetto 'objFtp' si possono utilizzare le seguenti funzioni:
*!*	*!*		.FtpConnect("sito","user-id","password")		-->>	effettua la connessione al sito FTP
*!*	*!*		.SetCurrentDir("/dir1/dir2/dir3") 				-->>	setta una directory sul sito FTP
*!*	*!*		.GetCurrentDir() 								-->>	legge in quale directory siamo sul sito FTP
*!*	*!*		.DirExists("/dir1/dir2/dir3")					-->>	verifica l'esistenza di una directory sul sito FTP
*!*	*!*		.CreateDir("/dir1/dir2/dir3")					-->>	crea una directory sul sito FTP
*!*	*!*		.RemoveDir("/dir1/dir2/dir3") 					-->>	elimina una directory sul sito FTP
*!*	*!*		.DirToCursor("nome-cursore")					-->>	inserisce in un cursore il contenuto della directory del sito FTP
*!*	*!*		.GetFromFtp("file.est","c:\dir\file.est")		-->>	scarica dal sito ftp il file DA e lo salva in locale nel file A
*!*	*!*		.PutToFtp("c:\dir\file.est","file.est")			-->>	invia al sito ftp il file DA e lo salva in remoto nel file A
*!*	*!*		.DeleteFile("file.est")							-->>	cancella un file sul sito FTP remoto
*!*	*!*
*!*	*!* ------------------------------------------------------------------------------------------------------------------------------------



*!* ------------------------------------------------------------------------------------------------
*!* -->> Viene definita la classe TFTP partendo dalla classe originaria CLSFTP.
*!* -->> Nel definire la nuova classe, posso modificare alcune procedure e funzioni che sono definite
*!* -->> in modo virtuale nella classe originaria.
*!* -->> Di seguito le procedure e le funzioni modificabili durante la ridefinizione della classe
*!* -->> originaria ed il loro utilizzo.
*!*
*!* -->> TUTTE LE PROCEDURE/FUNZIONI ELENCATE, SONO RICHIAMATE DIRETTAMENTE DALLA CLASSE ORIGINARIA
*!* 
*!*	 Funzioni:
*!*		BeforePutFile(lcLocalFile, lcRemoteFile)				-->>	funzione eseguita prima di iniziare un invio di un file
*!*		BeforeGetFile(lcRemoteFile, lcLocalFile)				-->>	funzione eseguita prima di iniziare la ricezione di un file
*!*		
*!*	 Procedure:
*!*		AfterPutFile(lcLocalFile, lcRemoteFile, lResult)		-->>	funzione eseguita al termine di un invio file
*!*		AfterGetFile(lcRemoteFile, lcLocalFile, lResult)		-->>	funzione eseguita al termine di una ricezione file
*!*	 	
*!* ------------------------------------------------------------------------------------------------
DEFINE CLASS Tftp As clsFtp 

FUNCTION BeforePutFile(lcLocalFile, lcRemoteFile) 
* return .F. to cancel file transfer 
	_hd=FOPEN("\Log\LogFtp\Log_PDV" + _codPDV + "." + DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - Inizio trasferimento da "+_host_locale+" verso "+_host_remoto
	=FPUTS(_hd,_vmsg) 
    _vmsg= TTOC(datetime())+" - Da "+_host_locale+" il file "+lcLocalFile+" --->>> arriva a "+_host_remoto+" nel file "+lcRemoteFile+" ..." 
	=FPUTS(_hd,_vmsg)
	=FCLOSE(_hd)
RETURN .T. 

PROCEDURE AfterPutFile(lcLocalFile, lcRemoteFile, lResult) 
	_hd=FOPEN("\Log\LogFtp\Log_PDV" + _codPDV + "." + DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - Da "+_host_locale+" il file "+lcLocalFile+" --->>> arriva a "+_host_remoto+" nel file "+lcRemoteFile+IIF(lResult," TRASFERITO"," ......... !!!! KO !!!!")
	=FPUTS(_hd,_vmsg)
*    _vmsg= ttoc(datetime())+" - Fine trasferimento da "+_host_locale+" verso "+_host_remoto
	_vmsg=""
	=FPUTS(_hd,_vmsg)
	=FCLOSE(_hd)

FUNCTION BeforeGetFile(lcRemoteFile, lcLocalFile) 
* return .F. to cancel file transfer 
	_hd=FOPEN("\Log\LogFtp\Log_PDV" + _codPDV + "." + DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - Inizio trasferimento da "+_host_remoto+" verso "+_host_locale
	=FPUTS(_hd,_vmsg)
    _vmsg= ttoc(datetime())+" - Da "+_host_remoto+" il file "+lcRemoteFile+" --->>> arriva a "+_host_locale+" nel file "+lcLocalFile+" ..." 
	=FPUTS(_hd,_vmsg)
	=FCLOSE(_hd)
RETURN .T. 

PROCEDURE AfterGetFile(lcRemoteFile, lcLocalFile, lResult) 
	_hd=FOPEN("\Log\LogFtp\Log_PDV" + _codPDV + "." + DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - Da "+_host_remoto+" il file "+lcRemoteFile+" --->>> arriva a "+_host_locale+" nel file "+lcLocalFile+IIF(lResult," RICEVUTO"," ......... !!!! KO !!!!")
	=FPUTS(_hd,_vmsg)
*    _vmsg= ttoc(datetime())+" - Fine trasferimento da "+_host_remoto+" verso "+_host_locale
	_vmsg=""
	=FPUTS(_hd,_vmsg)
	=FCLOSE(_hd)

ENDDEFINE 



***************************************************
FUNCTION w_creadir
***************************************************
PARAMETERS _string_dir

	_save_path=SYS(5)+SYS(2003)

    DECLARE INTEGER CreateDirectory IN kernel32; 
        STRING lpPathName, INTEGER lpSecurityAttr 

	_w_dir=OCCURS("\",_string_dir)
	IF RIGHT(_string_dir,1) <> "\"
		_w_dir=_w_dir+1
	ENDIF
	
	FOR h=1 TO _w_dir	
		_new_string_dir = ""
		FOR j=1 TO h
			_ddd=WSTR_EXTRACT(_string_dir,"\",j)
			_new_string_dir = _new_string_dir+_ddd+"\"
		NEXT 

	    IF CreateDirectory (_new_string_dir, 0) = 0 
    	    DECLARE INTEGER GetLastError IN kernel32 
	        *   3 = ERROR_PATH_NOT_FOUND 
    	    *   5 = ERROR_ACCESS_DENIED 
        	* 183 = ERROR_ALREADY_EXISTS 
			DO CASE 
				CASE GetLastError() = 3
					=MESSAGEBOX("Errore durante la ricerca dell'host dove creare il file di log",16,"*** ATTENZIONE ***")
					SET DEFAULT TO &_save_path
					return(.f.)			
				CASE GetLastError() = 5
					=MESSAGEBOX("Impossibile accedere all'host dove creare il file di log",16,"*** ATTENZIONE ***")
					SET DEFAULT TO &_save_path
					return(.f.)			
				OTHERWISE 
			ENDCASE 
	    ENDIF 
	    
	 NEXT 
	SET DEFAULT TO &_save_path
return(.t.)



********************
FUNCTION WSTR_EXTRACT
********************

PARA SRIG,DEL,OCC

SRIG=SRIG+DEL

FOR K=1 TO OCC-1
   STAR=AT(DEL,SRIG)+1
   IF STAR >LEN(SRIG)
      SRIG=""
      EXIT
   ENDIF
   SRIG=SUBSTR(SRIG,STAR)
NEXT

FINE=AT(DEL,SRIG)

IF SRIG==""
   RETURN("")
ELSE
   RETURN(SUBSTR(SRIG,1,FINE-1))
ENDIF



**************************
FUNCTION DirLocalToCur
**************************
PARAMETERS _cur_locale,_dir_locale

    CREATE CURSOR &_cur_locale (; 
        filename   C(250),; 
        filesize   N(12),; 
        created    T,; 
        accessed   T,; 
        modified   T,; 
        fileattrib N(12),; 
        rdonlyfile L,; 
        hiddenfile L,; 
        sysfile    L,; 
        folder     L,; 
        archfile   L,; 
        normalfile L,; 
        tempfile   L,; 
        compressed L,; 
        rootpath   M; 
    ) 

	_nd=ADIR(_cont_locale,_dir_locale+"*.*","A")

	INSERT INTO &_cur_locale FROM ARRAY _CONT_LOCALE

return(.t.)


*************************************************************************
* Funzione - STR_EXTRACT      Data: 26.07.94     Autore: Project
*************************************************************************
* Questa funzione permette di estrarre da una stringa determinate
* sottostringhe contenute tra il delimitatore specificato.
* Esempio:
*     AA="Pippo,Pluto,Paperino"
*     ? STR_EXTRACT(AA,",",2)      && Ritornerà  "Pluto"
* Sintassi:
*     STR_EXTRACT(<ExpC1>,<ExpC2>,<ExpN1>)
*     ExpC1 - Stringa di origine
*     ExpC2 - Carattere delimitatore di lista
*     ExpN1 - Numero di occorrenze nella lista
*
*************************************************************************
FUNCTION STR_EXTRACT
********************

PARA SRIG,DEL,OCC

SRIG=SRIG+DEL

FOR K=1 TO OCC-1
   STAR=AT(DEL,SRIG)+1
   IF STAR >LEN(SRIG)
      SRIG=""
      EXIT
   ENDIF
   SRIG=SUBSTR(SRIG,STAR)
NEXT

FINE=AT(DEL,SRIG)

IF SRIG==""
   RETURN("")
ELSE
   RETURN(SUBSTR(SRIG,1,FINE-1))
ENDIF

***********************************************************************************
FUNCTION scrivi_log
***********************************************************************************
PARAMETERS _vardic

	_hd=FOPEN("\Log\LogFtp\Log_PDV" + _codPDV + "." + DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - "+_vardic
	=FPUTS(_hd,_vmsg) 
	=FCLOSE(_hd)
return(.t.)