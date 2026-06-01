*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CAMBI 										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2013 : Rumi				 														*
*************************************************************************************************




** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "RUM"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'RUM' non configurato" + CHR(13) + CHR(13) + ;
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

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

RIT = MESSAGEBOX("Conversione anagrafica cambi da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_VVA_CH SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica valute...  -  Prego Attendere" NOWAIT
cSql = "delete from U_VVA_CH where 1=1"
IF !ExecCommand(cSql,"U_VVA_CH")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_VVA_CH where 1=0"
IF !ExecCommand(cSql,"CU_VVA_CH")
   return(.f.)
ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0

**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
			


CREATE CURSOR IMPORTAXLS ( ;
			cgdatcam	  c(50),;
			cgcodval	  c(50),;	
			cgcambio	  c(50),;	
			vadesval	  c(50))
	
APPEND FROM (gcFile) TYPE XLS



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS
GO TOP 

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(CGDATCAM)) = "CGDATCAM"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
					
	M.VVA_CODSOC = PUB_CODSOC
	M.VVA_CODVAL = ALLTRIM(M.cgcodval)	
	M.VVA_NOMVAL = ALLTRIM(M.vadesval)
	
	__AA	= SUBSTR(M.cgdatcam,7,4)
	__MM	= SUBSTR(M.cgdatcam,4,2)
	__GG	= SUBSTR(M.cgdatcam,1,2)

	M.VVA_DATA   = RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))
    M.VVA_DATA   = ALLTRIM(CONV_CLEAR(M.VVA_DATA))
	M.VVA_CHANGE = VAL(ALLTRIM(M.cgcambio))
   

    SELECT CU_VVA_CH
    APPEND BLANK
    DO U_VVA_CH



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO

	 
WAIT WINDOWS "Scrittura archivio dell'Anagrafica valute sul DataBase In Corso... -- Prego Attendere --" nowait  
IF !ExecRW('','u_vva_ch','I','','CU_VVA_CH')
   return(.f.)
ENDIF

WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
**=> ERASMO - FINE 15/10/2013


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 