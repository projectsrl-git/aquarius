*!*	##############################################################################################################
  
					**********************************************************************************************
					***     PROJECT SRL - CARICA LA TABELLA MENU SU TUTTI I DATABASE PREVISTI DA DBSOCIETA     ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################
  
CLEAR ALL
CLOSE ALL
SET MULTILOCKS ON 
SET CENTURY ON 
SET DATE TO GERMAN 
CLOSE DATABASES ALL

WAIT WINDOWS "Carica tbl_menu" TIMEOUT 1

RELEASE _path_aquarius																&& VARIABILI USATE PER LA GESTIONE DEGLI SCRIPT
PUBLIC _path_aquarius																&& VARIABILI USATE PER LA GESTIONE DEGLI SCRIPT


_path_aquarius=legge_config("build_config.cfg","PATH_AQUARIUS")						&& RICERCA VARIABILE

SET DEFA TO &_path_aquarius	  

SET PROCEDURE TO BUILDSQL.PRG 				ADDITIVE

PUBLIC pub_sqlhd,pub_datawh
pub_sqlhd  = 0
pub_datawh = ""


IF !FILE("TBL_MENU.DBF")												&& SE NON ESISTE LA TBL_MENU NELLA DIRECTORY AMBIENTE NON DEVE FARE NESSUN CARICAMENTO
   RETURN
ENDIF


DO ricerca_database_ambiente											&& CARICA I DATABESE PREVISTI NELLA DBSOCIETA DI QUELLO SPECIFICO AMBIENTE


DO carica_tbl_menu_sui_database_ambiente								&& CARICA LA TBL_MENU

_FILEIN	= SYS(5)+SYS(2003)+"\tbl_menu.*"
_FILEOU	= SYS(5)+SYS(2003)+"\TBL_MENU\tbl_menu.*"

ERASE &_FILEOU															&& CANCELLA ULTIMA COPIA DI TBL_MENU

_COMM="COPY FILE "+_FILEIN+" TO "+_FILEOU								&& SALVATAGGIO TBL_MENU
&_COMM																	&& SALVATAGGIO TBL_MENU

ERASE &_FILEIN															&& CANCELLA TBL_MENU CARICATA



CLOSE DATABASES ALL
RETURN 

***********************************************************************  
* Procedura - prepara_tbl_menu  Data: 04/05/2013   Autore: Project
***********************************************************************
*
*  PERMETTE LA PREDISPOSIZIONE DELLA TABELLA DBF TBL_MENU
*  PER VARIE OPZIONI PRIMA DEL CARICAMENTO DELLE VOCI DI MENU
*
***********************************************************************
PROCEDURE prepara_tbl_menu
***********************************************************************
*!*	_RISP = MESSAGEBOX("Ignorare il caricamento delle abilitazioni utente?" + CHR(13) + CHR(13) + ;
*!*	                   "Rispondendo 'SI' verranno mantenute le varie" + CHR(13) + ;
*!*	                   "abilitazioni alle voci di menu per gli utenti già presenti sul sistema." + CHR(13) + CHR(13) + ;
*!*	                   "Rispondendo 'NO' verranno caricate anche le varie" + CHR(13) + ;
*!*	                   "abilitazioni alle voci di menu per gli utenti.",36,"Attenzione")
*!*	IF _RISP = 6
*!*	ELSE
*!*	   RETURN
*!*	ENDIF

*!*	opzione = SI

IF FILE("TBL_MENU.DBF")
ELSE
   *MESSAGEBOX("File TBL_MENU.DBF non trovato",16,"Attenzione")
   RETURN
ENDIF

cSql = "select * from TBL_MENU order by menu,ordine"
IF !ExecCommand(cSql,"CU_OLD_MENU")
  return(.f.)
ENDIF
SELECT CU_OLD_MENU
INDEX ON ALLTRIM(MENU) + ALLTRIM(LABEL) TAG I_INDEX

cSql = "select * from TBL_MENU where 1=0"
IF !ExecCommand(cSql,"CU_MENU_STA")
  return(.f.)
ENDIF
SELECT CU_MENU_STA
INDEX ON ALLTRIM(MENU) + ALLTRIM(STR(ORDINE,2,0)) TAG I_INDEX

* -->> Apro tabella FOX cambiando l'alias
* --------------------------------------------
USE TBL_MENU ALIAS CX_TBL_MENU IN 0 AGAIN

SELECT CX_TBL_MENU
GO TOP
SCAN
   _XX_MENU   = MENU
   _XX_LABEL  = LABEL
   _YY_UTENTI = ""
   SELECT CU_OLD_MENU
   SET ORDER TO I_INDEX
   GO TOP
   _SEEK = ALLTRIM(_XX_MENU) + ALLTRIM(_XX_LABEL)
   SEEK _SEEK
   IF FOUND()
      _YY_UTENTI = UTENTI
   ELSE
      _YY_UTENTI = "..SER."  && ERASMO - 22/01/2008
      SELECT CX_TBL_MENU
      SCATTER MEMVAR MEMO
      SELECT CU_MENU_STA
      APPEND BLANK
      REPLACE MENU WITH M.MENU
      REPLACE LABEL WITH M.LABEL
      REPLACE COMANDO WITH M.COMANDO
      REPLACE ICONA WITH M.ICONA
      REPLACE VISIBILE_SE  WITH M.VISIBILE_S
      REPLACE LIVELLO_MENU WITH M.LIVELLO_ME
   ENDIF
   SELECT CX_TBL_MENU
   REPLACE UTENTI WITH _YY_UTENTI 
ENDSCAN

SELECT CU_MENU_STA
SET ORDER TO I_INDEX
GO TOP
IF EOF()
ELSE
*!*	   _RISP = MESSAGEBOX("Rilevate nuove voci di menu senza abilitazioni utente." + CHR(13) + CHR(13) + ;
*!*	                      "Stampa una lista per abilitare manualmente le nuove voci di menu?",36,"Attenzione")
*!*	   IF _RISP = 6
*!*	      V_REPORT = "menu_no_users.FRX"
*!*	      DO PRG\MENUSTA WITH "CU_MENU_STA",.T.,.T.,"XXX","&V_REPORT","&V_REPORT"
*!*	   ENDIF
ENDIF

SELECT CX_TBL_MENU
USE

RETURN



***********************************************************************
PROCEDURE ricerca_database_ambiente	
***********************************************************************

**  carico DBSOCIETA' NEL CURSORE 

SET DEFA TO &_path_aquarius	 

* -->> Creazione cursore vuoto 
* --------------------------------------------------------------
CREATE CURSOR CU_DBSOCIETA_ ;
       (NOME_DATA_BASE C(40), CODICE C(10), Selezione C(05))
INDEX ON CODICE 	TAG I_CODICE 
SET ORDER TO I_CODICE 



IF FILE("DBSOCIETA.DBF")
  IF !USED("DBSOCIETA")
     USE DBSOCIETA IN 0 AGAIN SHARED
  ENDIF
  SELECT DBSOCIETA
  GO TOP
  V_CONTARECORD=0

  DO WHILE !EOF()

  	IF DELETED()
        SKIP
        LOOP
  	ENDIF
  	

    SELECT DBSOCIETA
    SCATTER MEMVAR MEMO
    
    
    
	*!*	CERCA PAROLA : "DATABASE="
	__STRINGA__ 				= M.NOMEDB
	__STRINGA_DA_CERCARE__		= "DATABASE="
	__LUNGHEZZA_DA_CERCARE__	= 9
	__PARTENZA_STRINGA__=CERCA_CHR(__STRINGA__,__STRINGA_DA_CERCARE__,__LUNGHEZZA_DA_CERCARE__)

    SELECT DBSOCIETA
	*!*	CERCA PAROLA : "; "
	__STRINGA__ 				= M.NOMEDB
	__STRINGA_DA_CERCARE__		= "; "
	__LUNGHEZZA_DA_CERCARE2__	= 2
	__POSIZIONE_FINALE__		=CERCA_CHR(__STRINGA__,__STRINGA_DA_CERCARE__,__LUNGHEZZA_DA_CERCARE__)


	__LUNGHEZZA_PAROLA__ 	= __POSIZIONE_FINALE__ - __PARTENZA_STRINGA__ - __LUNGHEZZA_DA_CERCARE__
	__NOME_DBASE__			= SUBSTR(ALLTRIM(__STRINGA__),(__PARTENZA_STRINGA__+__LUNGHEZZA_DA_CERCARE__),(__LUNGHEZZA_PAROLA__))

    SELECT CU_DBSOCIETA_ 
    APPEND BLANK
    REPLACE NOME_DATA_BASE 	WITH	__NOME_DBASE__
    REPLACE CODICE 			WITH	M.CODICE		
    REPLACE Selezione		WITH	'==>'
    

    SELECT DBSOCIETA 
  	SKIP
  	
  	
  ENDDO
  
ENDIF FILE("DBSOCIETA.DBF")



SELECT CU_DBSOCIETA_ 
GO TOP


RETURN



***********************************************************************
PROCEDURE carica_tbl_menu_sui_database_ambiente	
***********************************************************************

   

RELEASE __NOME_DATA_BASE__ 
PUBLIC __NOME_DATA_BASE__ 
__NOME_DATA_BASE__  = ''

SELECT CU_DBSOCIETA_ 
GO TOP



DO WHILE !EOF()

  	IF DELETED()
  	    SELECT CU_DBSOCIETA_ 
        SKIP
        LOOP
  	ENDIF
  	
  	
    IF ALLTRIM(Selezione) <>	'==>'
  	    SELECT CU_DBSOCIETA_ 
        SKIP
        LOOP
  	ENDIF    

    SELECT CU_DBSOCIETA_ 
    __NOME_DATA_BASE__ = ALLTRIM(NOME_DATA_BASE)

    IF !SwicthDBConnection(ALLTRIM(__NOME_DATA_BASE__))
       WAIT WINDOWS "DataBase " + ALLTRIM(__NOME_DATA_BASE__) + " inesistente" NOWAIT
       IF !SetHomeDB()
          RETURN(.f.)
       ENDIF
       RETURN .F.
    ENDIF

    WAIT WINDOWS "Caricamento tbl_menu per : " + ALLTRIM(__NOME_DATA_BASE__)  NOWAIT


	DO prepara_tbl_menu  													&& PREPARA IL CURSORE TBL_MENU


	IF !ExecCommand("delete from tbl_menu","_menu")							&& CANCELLA TABELLA TBL_MENU
	  return(.f.)
	ENDIF


	DO foxtosql2 WITH SYS(5)+SYS(2003)+"\tbl_menu"							&& CARICA IL MENU SQL DALLA TABELLA FOX


	IF !ExecCommand("UPDATE TBL_MENU SET AUTORIZZAZIONE = 1","_menu")		&& AUTORIZZA ALL'USO TUTTE LE RIGHE DI MENU
	  return(.f.)
	ENDIF


	**=> ERASMO/SERGIO INIZIO - 14/07/2017 : RIFACIMENTO MENU LISTINI DI VENDITA IN QUANTO NON ERANO FUNZIONALI

	*!*	LISTINI VENDITA CLIENTE/LINEA/ARTICOLO      
	IF !ExecCommand("UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'gestionelistini8' ORDER BY ORDINE) WHERE MENU = 'gestionelistini8'","upd_menu")
	  return(.f.)
	ENDIF
	*!*	LISTINI VENDITA CLIENTE/ARTICOLO      
	IF !ExecCommand("UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'gestionelistini2' ORDER BY ORDINE) WHERE MENU = 'gestionelistini2'","upd_menu")
	  return(.f.)
	ENDIF
	*!*	LISTINI VENDITA  CLIENTE/ARTICOLO/ALTEZZA/LUNGH  
	IF !ExecCommand("UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'Gestionelistini7' ORDER BY ORDINE) WHERE MENU = 'Gestionelistini7'","upd_menu")
	  return(.f.)
	ENDIF
	*!*	LISTINI VENDITA  ZONA AGENTE
	IF !ExecCommand("UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'Gestionelistini3' ORDER BY ORDINE) WHERE MENU = 'Gestionelistini3'","upd_menu")
	  return(.f.)
	ENDIF

	*!*	LISTINI VENDITA CLIENTE/TIPO PRODOTTO/SPESSORE 
	IF !ExecCommand("UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'gestionelistiniclientetipoprodottospessore' ORDER BY ORDINE) WHERE MENU = 'gestionelistiniclientetipoprodottospessore'","upd_menu")
	  return(.f.)
	ENDIF

	**=> ERASMO/SERGIO FINE - 14/07/2017 : RIFACIMENTO MENU LISTINI DI VENDITA IN QUANTO NON ERANO FUNZIONALI



    SELECT CU_DBSOCIETA_ 
  	SKIP +1
  	
  	
ENDDO




RETURN



