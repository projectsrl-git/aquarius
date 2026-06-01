***********************************************************************
* 				      VERIFICA CONTENUTO DELLE DIRECTORY              *
***********************************************************************
* LA PROCEDURA VERIFICA L'ESISTENZA DI EVENTUALI VIRUS ALL'INTERNO
* DELLE DIRECTORY PASSATE



SET STATUS BAR OFF
SET AUTOSAVE ON
SET CENTURY ON
SET CLOCK STATUS
SET DATE TO GERMAN
SET DELETED ON
SET ESCAPE OFF
SET EXACT ON
SET EXCLUSIVE OFF
SET HOURS TO 24
SET NEAR ON
SET REPROCESS TO AUTOMATIC
SET SAFETY OFF
SET TALK OFF
SET POINT TO


RIT  =MESSAGEBOX('VUOI PROSEGUIRE ',292,'*** ATTENZIONE ***')  
IF RIT = 7
  RETURN
ENDIF


RELEASE _FILE_SCONOSCIUTI
PUBLIC _FILE_SCONOSCIUTI
_FILE_SCONOSCIUTI = .F.

**=> LEGGE LE DIRECTORY DA VERIFICARE
_PATH_AQUARIUS=LEGGE_CONFIG("AQ_SCHEDULER_CONFIG.CFG","PATH_AQUARIUS")						&& RICERCA VARIABILE
SET DEFA TO &_path_aquarius

**=> CREAZIONE CURSORI DI SUPPORTO

CREATE CURSOR AQ_EXT  (EXT_FILE  C(100))
SELECT AQ_EXT
INDEX ON EXT_FILE TAG I_EXT ADDITIVE
SET ORDER TO I_EXT 
GO TOP

CREATE CURSOR AQ_ERRORI(NOME_DIR C(250) , ; 
                       NOME_FILE_TROVATO C(250)) 
SELECT AQ_ERRORI
GO TOP

CREATE CURSOR AQ_DIR  (NOME_DIR C(250) , ; 
                       NOME_DIR_COMPLETO C(250)) 
SELECT AQ_DIR  
GO TOP


**=> CARICA LE DIRECTORY DA CONTROLLARE

_AQ_DIRECTORY=LEGGE_DIRECTORY("AQ_SECURITY_DIRECTORY.CFG","AQ_DIRECTORY")					&& CARICA LE DIRECTORY DA CONTROLLARE

IF _AQ_DIRECTORY <> "ELABORAZIONE EFFETTUATA"

	SET DEFA TO &_path_aquarius

	CLOSE DATABASES
	SET STATUS BAR OFF
	SET AUTOSAVE ON
	SET CENTURY ON
	SET CLOCK STATUS
	SET DATE TO GERMAN
	SET DELETED ON
	SET ESCAPE OFF
	SET EXACT ON
	SET EXCLUSIVE OFF
	SET HOURS TO 24
	SET NEAR ON
	SET REPROCESS TO AUTOMATIC
	SET SAFETY OFF
	SET TALK OFF
	SET EXCLUSIVE OFF
	CLOSE DATABASES
	CLOSE ALL
	CLEAR
	QUIT
	
ENDIF 



_FILE_SCONOSCIUTI=CONTROLLA_CONTENUTO_DIRECTORY()											&& CONTROLLA IL CONTENUTO DELLA DIRECTORY

IF _FILE_SCONOSCIUTI
	=MESSAGEBOX("PRESENZA VIRUS"+CHR(13)+"PER SICUREZZA FACCIO LO SHOUTDOWN DELLA MACCHINA")

*!*		SELECT AQ_ERRORI
*!*		GO TOP
*!*		BROWSE NORMAL

*!*			_COMMAND = "RUN shutdown /l"
*!*			&_COMMAND

ENDIF




RETURN
RETURN
RETURN
RETURN
RETURN
RETURN



SET DEFA TO &_path_aquarius

CLOSE DATABASES
SET STATUS BAR OFF
SET AUTOSAVE ON
SET CENTURY ON
SET CLOCK STATUS
SET DATE TO GERMAN
SET DELETED ON
SET ESCAPE OFF
SET EXACT ON
SET EXCLUSIVE OFF
SET HOURS TO 24
SET NEAR ON
SET REPROCESS TO AUTOMATIC
SET SAFETY OFF
SET TALK OFF


RETURN 

SET EXCLUSIVE OFF

=MESSAGEBOX("CONTROLLO DIRECTOTY COMPLETATO"+CHR(13)+"PER ULTERIORI CONTROLLI CHIUDO L'APPLICAZIONE")
CLOSE DATABASES
CLOSE ALL
CLEAR
QUIT

**************************************
FUNCTION CONTROLLA_CONTENUTO_DIRECTORY
**************************************

LOCAL ERRORI_FILE

ERRORI_FILE = .F.

SELECT AQ_DIR 
GO top

SELECT NOME_DIR FROM AQ_DIR GROUP BY NOME_DIR ORDER BY NOME_DIR INTO CURSOR AQ_DIRECTORY

SELECT AQ_DIRECTORY
GO TOP


DO WHILE .NOT. EOF()


	SELECT AQ_DIRECTORY
	SCATTER MEMVAR MEMO
	
	
	SET DEFA TO &NOME_DIR
	_NFILE = ADIR(ELENCO_FILE_DA_CONTROLLARE,'*.*')

	FOR TXT = 1 TO _NFILE
	  
	  	NOMEFILE = ELENCO_FILE_DA_CONTROLLARE[TXT,1]
	  
	  	**=> VERIFICO ESTENSIONE DEL FILE 
	  	**=> XXXXX.MDF
	 	_inizio_separatore=at(".",NOMEFILE)

     	_EXT_FILE = SUBSTR(NOMEFILE,_inizio_separatore)
      	_EXT_FILE = ALLTRIM(STRTRAN(_EXT_FILE,'"',''))       
	  	_seek = _EXT_FILE 
		SELECT AQ_EXT
		SET ORDER TO I_EXT   
	  	SEEK _SEEK
	  	IF !FOUND()	
	  		SELECT AQ_ERRORI
	  		APPEND BLANK 
	  		REPLACE NOME_DIR WITH M.NOME_DIR 
	  		REPLACE NOME_FILE_TROVATO WITH M.NOMEFILE
	  		ERRORI_FILE = .T.
	  	ENDIF	
	  	
 

	ENDFOR


	SELECT AQ_DIRECTORY
	SKIP + 1
	
ENDDO

IF !ERRORI_FILE 
	WAIT WINDOWS "Directory: " + ALLTRIM(NOME_DIR) +   " controllata con esito POSITIVO"
ELSE
	WAIT WINDOWS "Directory: " + ALLTRIM(NOME_DIR) +   " controllata con esito NEGATIVO"
ENDIF 

SET DEFA TO &_path_aquarius

RETURN(ERRORI_FILE)

*****************************
procedure legge_config
*****************************
parameters _configfile,_proprieta

LOCAL _valore

_valore=""

IF FILE(_configfile)	  && Esiste il file? 

	gnConfigFile = FOPEN(_configfile)	  	&& Se esiste, lo apre in lettura
	IF gnConfigFile >= 0  					&& Verifica errore in apertura del file
											&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=FGETS(gnConfigFile)
			
			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=allt(substr(riga,at("=",riga)+1))

				if	chiave=_proprieta
					_valore=valore
				endif
			endif
		enddo
	ENDIF
	=FCLOSE(gnConfigFile)	

ENDIF

return _valore

ENDPROC

*****************************
procedure legge_directory
*****************************
parameters _configdirectory,_proprieta

LOCAL _valore
 
_valore=""

IF FILE(_configdirectory)	  					&& Esiste il file? 

	gnConfigFile = FOPEN(_configdirectory)	  	&& Se esiste, lo apre in lettura
	IF gnConfigFile >= 0  						&& Verifica errore in apertura del file
												&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=FGETS(gnConfigFile)
			
			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=allt(substr(riga,at("=",riga)+1))
				if	chiave=_proprieta
				
					*  AQ_DIRECTORY="C:\Database\*.MDF"
					_inizio_carattere_jolly=at("*",riga)
					_inizio_nome_directory=at("=",riga) + 2
				    
				    _EXT_FILE = SUBSTR(RIGA,_inizio_carattere_jolly)
				    _EXT_FILE = STRTRAN(_EXT_FILE,'"','')     
				    _EXT_FILE = STRTRAN(_EXT_FILE,'*','')				      
					_NRCHR_EXT_FILE = LEN(_EXT_FILE)
					
					_NOME_DIR        		= SUBSTR(RIGA,_inizio_nome_directory)	
					_fine_nome_directory  	= at("*",_NOME_DIR)	- 1
					_NOME_DIR        		= SUBSTR(_NOME_DIR,1,_fine_nome_directory)	
				    _NOME_DIR		 		= STRTRAN(_NOME_DIR,'"','')       
					
					_VALORE			 = VALORE
				    _VALORE			 = STRTRAN(_VALORE,'"','')       
					
					SELECT AQ_DIR 
					APPEND BLANK 
					REPLACE NOME_DIR			WITH _NOME_DIR
					REPLACE NOME_DIR_COMPLETO 	WITH _VALORE
					
					SELECT AQ_EXT  
					APPEND BLANK 
					REPLACE EXT_FILE 	WITH _EXT_FILE 
					
					_VALORE = 'ELABORAZIONE EFFETTUATA'	
									
				ENDIF
			ENDIF
		ENDDO
	ENDIF
	=FCLOSE(gnConfigFile)	
ELSE

	_VALORE = 'MANCA FILE'

ENDIF


return _valore

ENDPROC


