*!*	##############################################################################################################
  
					**********************************************************************************************
					***     		PROJECT SRL - PROCEDURA PER LA COMPILAZIONE DEL PROGETTO AQUARIUS    	   ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################
  

CLEAR ALL
CLOSE ALL
SET MULTILOCKS ON 
SET CENTURY ON 
SET DATE TO GERMAN 
CLOSE DATABASES ALL


 
  
*!*	LA PROCEDURA EFFETTUA LE SEGUENTI FUNZIONI :
*!*	
*!*	01) CANCELLA I PROGRAMMI OBSOLETI DA APPOSITO MODULO
*!*	02) GESTISCE LA NUOVA VESRIONE DI AQUARIUS
*!*	03) COMILA IN MODO ESEGUIBILE IL PROGETTO AQUARIUS
*!*	
*!*	

_path_aquarius=legge_config("build_config.cfg","PATH_AQUARIUS")						&& RICERCA VARIABILE
*!*	PUB_DIR = "c:\aquarius"										&& DIRECTORY AMBIENTE
SET DEFA TO &_path_aquarius


SET PROCEDURE TO BUILDSQL.PRG 				ADDITIVE


*!*	WAIT WINDOWS "Sto cancellando i .FXP e ricompilando i .PRG"  NOWAIT

*!*	ERASE PRG\*.FXP
*!*	ERASE PRG\*.BAK
*!*	COMPILE PRG\*.PRG
*!*	ERASE RICERCHE\*.FXP
*!*	ERASE RICERCHE\*.BAK
*!*	COMPILE RICERCHE\*.PRG


*!*	WAIT WINDOWS "Sto compilando Aquarius" NOWAIT

*!*	BUILD EXE AQUARIUS FROM AQUARIUS
        
WAIT WINDOWS "Sto caricando la TBL_MENU per i vari DATABASE di Aquarius" NOWAIT

DO CARICA_TBL_MENU

WAIT WINDOWS "Sto aggiornando la VERSIONE di Aquarius" NOWAIT

DO CANCELLA_OBSOLETI

DO VERSIONE
        
WAIT WINDOWS "Fine compilazione progetti" NOWAIT

QUIT


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


*************************
FUNCTION CERCA_CHR
*************************
* RESTITUISCE LA POSIZIONE DEL PUNTATORE DELLA STRINGA DA CERCARE

PARA _STRINGA,_STRINGA_DA_CERCARE,_LUNGHEZZA_DA_CERCARE

_LA_STRINGA_PARTE_DA_QUI = 0
IST = 0

DO WHILE .T.

   IST=IST + 1
   CARATT = SUBSTR(_STRINGA,IST,1)
   IF CARATT = SUBSTR(_STRINGA_DA_CERCARE,1,1)
   
      IF SUBSTR(_STRINGA,IST,_LUNGHEZZA_DA_CERCARE) = SUBSTR(_STRINGA_DA_CERCARE,1,_LUNGHEZZA_DA_CERCARE)
	      
	      _LA_STRINGA_PARTE_DA_QUI = LEN(SUBSTR(_STRINGA,1,IST))
          EXIT
      
      ENDIF
   
   ENDIF

   IF IST = 300
     EXIT
   ENDIF

ENDDO

RETURN(_LA_STRINGA_PARTE_DA_QUI)



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




***********************************************************************
* Funzione - RIBALTA2     Data: 15.11.95   Autore: Project
***********************************************************************
*
*  Consente di convertire il formato data
*  AAAA.MM.GG in GG.MM.AAAA e viceversa
*  Sintassi: RIBALTA(Stringa da convertire)
*  Parametro: Carattere
*  Ritorna:   Carattere
*  Se il contenuto di GG,MM,AA è nullo ritorna SPACE(10)
*
***********************************************************************
FUNCTION RIBALTA2
*****************

PARAMETER _VALCAMPO

_SEPARA="/.-"

DO CASE
   CASE SUBSTR(_VALCAMPO,3,1) $ _SEPARA   && GG.MM.AAAA
        _SEPARA=SUBSTR(_VALCAMPO,3,1)
        _GIORNO=SUBSTR(_VALCAMPO,1,2)
        _MESE  =SUBSTR(_VALCAMPO,4,2)
        _ANNO  =SUBSTR(_VALCAMPO,7,4)
        _TUTTO =_ANNO+_SEPARA+_MESE+_SEPARA+_GIORNO
   CASE SUBSTR(_VALCAMPO,5,1) $ _SEPARA   && AAAA.MM.GG
        _SEPARA=SUBSTR(_VALCAMPO,5,1)
        _GIORNO=SUBSTR(_VALCAMPO,9,2)
        _MESE  =SUBSTR(_VALCAMPO,6,2)
        _ANNO  =SUBSTR(_VALCAMPO,1,4)
        _TUTTO =_GIORNO+_SEPARA+_MESE+_SEPARA+_ANNO
   OTHERWISE                              && NON VALIDO !
        _TUTTO=SPACE(10)
ENDCASE

RETURN(_TUTTO)

