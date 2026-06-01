
*!*	------------------------------------------------------------------------------------------------------
*!*	------------------------------------------------------------------------------------------------------
*!*	------------------------------------------------------------------------------------------------------

*!*	------------------------------------------------------------------------------------------------------
*!*	-->> esempi di utilizzo
*!*	------------------------------------------------------------------------------------------------------

*!*	-->> esempio di ricezione del contenuto di una directory
*!*	---------------------------------------------------------
*!*	DO esempioftp WITH "R","80.206.228.30","project","pippo10","/","","c:\invio\ambrosi\"

*!*	-->> esempio di ricezione di un singolo file
*!*	---------------------------------------------------------
*!*	DO esempioftp WITH "R","80.206.228.30","project","pippo10","/","inizio.sql","c:\invio\ambrosi\"

*!*	-->> esempio di invio del contenuto di una directory
*!*	---------------------------------------------------------
*!*	DO esempioftp WITH "I","80.206.228.30","project","pippo10","c:\invio\moka\","","/test/"

*!*	-->> esempio di invio di un singolo file
*!*	---------------------------------------------------------
*!*	DO esempioftp WITH "I","80.206.228.30","project","pippo10","c:\invio\moka\","inizio.sql","/test/"

*!*	------------------------------------------------------------------------------------------------------
*!*	------------------------------------------------------------------------------------------------------
*!*	------------------------------------------------------------------------------------------------------



*!* ------------------------------------------------------------------------------------------------------------------------------------
*!* -->> Come utilizzare le procedure di connessione ftp e quali funzioni sono disponibili
*!* -->> nell'oggetto FTP creato, il loro significato e il loro utilizzo
*!* ------------------------------------------------------------------------------------------------------------------------------------
*!* 
*!*	dell'oggetto 'objFtp' si possono testare le seguenti variabili:
*!*	    .LastErr 		-->>	codice ultimo messaggio di errore
*!*	    .ErrMsg 		-->>	messaggio di errore
*!*	    .host 			-->>	url del sito FTP (ftp.microsoft.com)
*!*	    .usr 			-->>	user-id
*!*	    .pswd 			-->>	password
*!*	    .IsConnected	-->>	flag di connessione al sito FTP  (.F. = non connesso - .T. = connesso)
*!*	    .hInternet	 	-->>	flag di connessione a internet (1 = connesso - 0 = disconnesso)
*!*	    .hConn			-->>	numero del canale aperto per la connessione FTP (0 = nessun canale aperto)
*!* ------------------------------------------------------------------------------------------------------------------------------------
*!*	dell'oggetto 'objFtp' si possono utilizzare le seguenti funzioni:
*!*		.FtpConnect("sito","user-id","password")		-->>	effettua la connessione al sito FTP
*!*		.SetCurrentDir("/dir1/dir2/dir3") 				-->>	setta una directory sul sito FTP
*!*		.GetCurrentDir() 								-->>	legge in quale directory siamo sul sito FTP
*!*		.DirExists("/dir1/dir2/dir3")					-->>	verifica l'esistenza di una directory sul sito FTP
*!*		.CreateDir("/dir1/dir2/dir3")					-->>	crea una directory sul sito FTP
*!*		.RemoveDir("/dir1/dir2/dir3") 					-->>	elimina una directory sul sito FTP
*!*		.DirToCursor("nome-cursore")					-->>	inserisce in un cursore il contenuto della directory del sito FTP
*!*		.GetFromFtp("file.est","c:\dir\file.est")		-->>	scarica dal sito ftp il file DA e lo salva in locale nel file A
*!*		.PutToFtp("c:\dir\file.est","file.est")			-->>	invia al sito ftp il file DA e lo salva in remoto nel file A
*!*		.DeleteFile("file.est")							-->>	cancella un file sil server FTP remoto
*!*
*!* ------------------------------------------------------------------------------------------------------------------------------------
PARAMETERS _tipo,_host,_user,_password,_directory_partenza,_nomefile,_directory_arrivo

_para = PARAMETERS()
IF _para < 4
	=MESSAGEBOX("Parametri insufficienti",16,"*** ATTENZIONE ***")
	RETURN 
ENDIF

* -->> settaggio delle directory di default
* --------------------------------------------
IF _tipo = "I"
	* -->> se comando di invio a host remoto
	* ----------------------------------------
	IF EMPTY(_directory_partenza)
		_directory_partenza = "c:\"
	ENDIF

	IF EMPTY(_directory_arrivo)
		_directory_arrivo = "/"
	ENDIF
ELSE 
	* -->> se comando di ricezione da host remoto
	* ----------------------------------------------
	IF EMPTY(_directory_partenza)
		_directory_partenza = "/"
	ENDIF

	IF EMPTY(_directory_arrivo)
		_directory_arrivo = "c:\"
	ENDIF
ENDIF


*!* --------------------------------------------------
*!* creo la cartella in cui scrivere i log
*!* --------------------------------------------------
IF !w_creadir("\Log\LogFtp")
	RETURN
ELSE
	_file_log	=	"\Log\LogFtp\Log_"+DTOS(DATE())+".log"
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

SET PROCEDURE TO PRG\ftplib ADDITIVE 

PUBLIC _host_remoto,_host_locale
PRIVATE objFtp 
objFtp = CreateObject("Tftp") 

IF _tipo = "I"
	* -->> se comando di invio a host remoto
	* ----------------------------------------
	_host_remoto	=	_host+_directory_arrivo
	_host_locale	=	_directory_partenza
ELSE 
	* -->> se comando di ricezione da host remoto
	* ----------------------------------------------
	_host_remoto	=	_host+_directory_partenza
	_host_locale	=	_directory_arrivo
ENDIF

*objFtp.FtpConnect("ftp.mokasirs.com", "user-id", "password") 

objFtp.FtpConnect(_host, _user, _password) 

IF Not objFtp.IsConnected 
    WAIT WINDOW NOWAIT "Connessione rifiutata" 
    RETURN 
ENDIF 

***SET STEP ON

IF _tipo = "I"
	* -->> se comando di invio a host remoto
	* ----------------------------------------
	WITH objFtp 
	    .SetCurrentDir(_directory_arrivo) 
*** 	   WAIT WINDOW .GetCurrentDir() 
		IF !EMPTY(_nomefile)
			WAIT WINDOW "Sto inviando: "+_nomefile nowait
	    	IF .PutToFtp(_directory_partenza+ALLTRIM(_nomefile), ALLTRIM(_nomefile)) 
	   			_fileinviato=_directory_partenza+ALLTRIM(_nomefile)
	   			ERASE  &_fileinviato
		    ENDIF 
		else
		    =DirLocalToCur("cur_locale",_directory_partenza) 
		    SELECT cur_locale
		    GO top
		    scan
				WAIT WINDOW "Sto inviando: "+ALLTRIM(cur_locale.filename) nowait
	    		IF .PutToFtp(_directory_partenza+ALLTRIM(cur_locale.filename), ALLTRIM(cur_locale.filename))
	    			_fileinviato=_directory_partenza+ALLTRIM(cur_locale.filename)
	    			ERASE  &_fileinviato
		    	ENDIF 
		    ENDSCAN
		ENDIF 
	ENDWITH 
ELSE 
	* -->> se comando di ricezione da host remoto
	* ----------------------------------------------
	WITH objFtp 
	    .SetCurrentDir(_directory_partenza) 
*** 	   ? .GetCurrentDir() 
		IF !EMPTY(_nomefile)
			WAIT WINDOW "Sto ricevendo: "+_nomefile nowait
	    	IF .GetFromFtp(_nomefile, _directory_arrivo+_nomefile) 
				.DeleteFile(_nomefile)
		    ENDIF 
		else
		    .DirToCursor("cur_remoto") 
		    SELECT cur_remoto
		    GO top
		    scan
				WAIT WINDOW "Sto ricevendo: "+ALLTRIM(cur_remoto.filename) nowait
	    		IF .GetFromFtp(ALLTRIM(cur_remoto.filename), _directory_arrivo+ALLTRIM(cur_remoto.filename)) 
		    		.DeleteFile(ALLTRIM(cur_remoto.filename))
		    	ENDIF 
		    ENDSCAN
		ENDIF 
	ENDWITH 
ENDIF 

RETURN


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
	_hd=FOPEN("\Log\LogFtp\Log_"+DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - Inizio trasferimento da "+_host_locale+" verso "+_host_remoto
	=FPUTS(_hd,_vmsg)
    _vmsg= ttoc(datetime())+" - Da "+_host_locale+" il file "+lcLocalFile+" --->>> arriva a "+_host_remoto+" nel file "+lcRemoteFile+" ..." 
	=FPUTS(_hd,_vmsg)
	=FCLOSE(_hd)
RETURN .T. 

PROCEDURE AfterPutFile(lcLocalFile, lcRemoteFile, lResult) 
	_hd=FOPEN("\Log\LogFtp\Log_"+DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - Da "+_host_locale+" il file "+lcLocalFile+" --->>> arriva a "+_host_remoto+" nel file "+lcRemoteFile+IIF(lResult," TRASFERITO"," ......... !!!! KO !!!!")
	=FPUTS(_hd,_vmsg)
*    _vmsg= ttoc(datetime())+" - Fine trasferimento da "+_host_locale+" verso "+_host_remoto
	_vmsg=""
	=FPUTS(_hd,_vmsg)
	=FCLOSE(_hd)

FUNCTION BeforeGetFile(lcRemoteFile, lcLocalFile) 
* return .F. to cancel file transfer 
	_hd=FOPEN("\Log\LogFtp\Log_"+DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - Inizio trasferimento da "+_host_remoto+" verso "+_host_locale
	=FPUTS(_hd,_vmsg)
    _vmsg= ttoc(datetime())+" - Da "+_host_remoto+" il file "+lcRemoteFile+" --->>> arriva a "+_host_locale+" nel file "+lcLocalFile+" ..." 
	=FPUTS(_hd,_vmsg)
	=FCLOSE(_hd)
RETURN .T. 

PROCEDURE AfterGetFile(lcRemoteFile, lcLocalFile, lResult) 
	_hd=FOPEN("\Log\LogFtp\Log_"+DTOS(DATE())+".log",2)
	=FSEEK(_hd,0,2)
    _vmsg= ttoc(datetime())+" - Da "+_host_remoto+" il file "+lcRemoteFile+" --->>> arriva a "+_host_locale+" nel file "+lcLocalFile+IIF(lResult," TRASFERITO"," ......... !!!! KO !!!!")
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
