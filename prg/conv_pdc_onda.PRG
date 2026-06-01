*************************************************************************************************
*							CONVERSIONE PIANO DEI CONTI											*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2018 : Onda					 														*
*************************************************************************************************



** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "OND"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'OND' non configurato" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	USE
	RETURN .F.
ENDIF

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH






* -->> Creazione cursore vuoto 
* --------------------------------------------------------------
CREATE CURSOR CURS_DBSOCIETA ;
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

    SELECT CURS_DBSOCIETA 
    APPEND BLANK
    REPLACE NOME_DATA_BASE 	WITH	__NOME_DBASE__
    REPLACE CODICE 			WITH	M.CODICE		
    

    SELECT DBSOCIETA 
  	SKIP
  	
  	
  ENDDO
  
ENDIF FILE("DBSOCIETA.DBF")




**=>> SELEZIONA DATA BASE HONDA

SELECT CURS_DBSOCIETA 
GO TOP
SET FILTER TO CODICE = "0000000990"
SET DEFA TO &PUB_DIR

   


__ok_database_selezionato = .f.


SELECT CURS_DBSOCIETA
GO TOP


SELECT CURS_DBSOCIETA
__NOME_DATA_BASE__ = ALLTRIM(NOME_DATA_BASE)

IF !SwicthDBConnection(ALLTRIM(__NOME_DATA_BASE__))
   WAIT WINDOWS "DataBase " + ALLTRIM(__NOME_DATA_BASE__) + " inesistente" NOWAIT
   IF !SetHomeDB()
      RETURN(.f.)
   ENDIF
   RETURN .F.
ENDIF





SET STEP ON 

cSql = "Select * from STDPianoDeiConti"
IF !ExecCommand(cSql,"CU_STDPianoDeiConti")
  return(.f.)
ENDIF



SELECT CU_STDPianoDeiConti
GO TOP
BROWSE NORMAL

**=>> MI RIPOSIZIONO SUL DATABASE ORIGINALE
SET FILTER TO CODICE = "0000000010"
SET DEFA TO &PUB_DIR
SELECT CURS_DBSOCIETA
__NOME_DATA_BASE__ = ALLTRIM(NOME_DATA_BASE)

IF !SwicthDBConnection(ALLTRIM(__NOME_DATA_BASE__))
   WAIT WINDOWS "DataBase " + ALLTRIM(__NOME_DATA_BASE__) + " inesistente" NOWAIT
   IF !SetHomeDB()
      RETURN(.f.)
   ENDIF
   RETURN .F.
ENDIF


RETURN




