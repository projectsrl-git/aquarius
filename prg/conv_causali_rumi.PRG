*************************************************************************************************
*							CONVERSIONE CAUSALI	CONTABILI 										*
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

RIT = MESSAGEBOX("Conversione causali contabili da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF




****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA CAUSALI SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CAUSALI" NOWAIT


*cSql = "delete from PARA where CODICE LIKE 'TOP%' AND SUBSTRING(LIBERA,42,1) = 'C'"  && ERASMO - 15/10/2013 - SOLO CAUSALI CONTABILI
cSql = "delete from PARA where CODICE LIKE 'TOP%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0

**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA



		CREATE CURSOR IMPORTAXLS ( ;
					cctop	  	  c(50),;
					cccodice	  c(50),;	
					ccdescri	  c(50),;	
					ccflpart	  c(50),;	
					ccflsali	  c(50),;	
					ccflsalf	  c(50),;	
					ccflcomp	  c(50),;	
					ccflrife	  c(50),;	
					cctipdoc	  c(50),;	
					cctipreg	  c(50),;	
					ccnumreg	  c(50),;	
					ccnumdoc	  c(50),;	
					ccflivdf	  c(50),;	
					ccflstda	  c(50),;	
					cccaldoc	  c(50),;	
					cctesdoc	  c(50),;	
					ccdtobso	  c(50),;	
					ccserdoc	  c(50),;	
					ccserpro	  c(50),;	
					cccfdave	  c(50),;	
					aicodiva	  c(50),;	
					aitipcon	  c(50),;	
					aicondet	  c(50),;	
					aiconind	  c(50),;	
					aitipreg	  c(50),;	
					ainumreg	  c(50),;	
					apflpart	  c(50),;
					tipo   		  c(50),;	
					ccflanal	  c(50),;	
					apfldave	  c(50),;	
					ccconiva	  c(50),;	
					ccflrite	  c(50),;	
					ccflpdoc	  c(50),;	
					ccflppro	  c(50),;	
					ccflstat	  c(50),;	
					ccflasse	  c(50),;	
					ccgesrit	  c(50),;	
					ccflauto	  c(50))

			
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
    
    IF UPPER(ALLTRIM(cctop)) = "cctop"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
					
	*M.CODICE 	= "TOP"+DECODIFICA_TOP_ZUCCHETTI(ALLTRIM(M.tdtipdoc))
	M.CODICE 	= "TOP"+ALLTRIM(M.cctop)
   	M.CODICE2	= ALLTRIM(M.cccodice)
   	M.DESCRI 	= ALLTRIM(M.ccdescri)
	
	_TIPO_DOC = "ALTRO DOC"
	IF "FATT" $ UPPER(ALLTRIM(M.ccdescri))
		_TIPO_DOC = "FATTURA"
	ENDIF
	IF "NOTA" $ UPPER(ALLTRIM(M.ccdescri))
		_TIPO_DOC = "NOTA CR"
	ENDIF

	*!*	NOTA CREDITO RUMI
	*!*	FATTURA ITALIA RUMI IMMEDIATA
    
    DO CASE 
    	CASE _TIPO_DOC = "FATTURA"
			M.FAT = "S"
			M.NOTA= "N"
			
    	CASE _TIPO_DOC = "NOTA CR"
			M.FAT = "S"
			M.NOTA= "S"
    	
		OTHERWISE    
			M.FAT = "N"
			M.NOTA= "N"  
    ENDCASE
    	
*!*	ccflrife	cctipdoc	cctipreg
*!*	C             F             V    		
    _TIPO_		= ALLTRIM(M.cctipreg)
    
    IF _TIPO_	= "V" 
    	M.NAT	= "D"	&& VENDITE
    ELSE
    	M.NAT	= "A"	&& ACQUISTI
    ENDIF

	IF "INCASS" $ UPPER(ALLTRIM(M.ccdescri))	&& INCASSO
    	M.FAT = "P"
    	M.NOTA= "N"
    	M.NAT = "A"
    ENDIF


	IF "INSOLUT" $ UPPER(ALLTRIM(M.ccdescri))	&& INSOLUTO
    	M.FAT = "I"
    	M.NOTA= "N"
    	M.NAT = "D"
    ENDIF

	IF "PAGAMEN" $ UPPER(ALLTRIM(M.ccdescri))	&& PAGAMENTO
    	M.FAT = "P"
    	M.NOTA= "N"
    	M.NAT = "D"
    ENDIF
    
    IF M.FAT = "S"		&& BOLLATO IVA
    	M.BOLL='S'
    ELSE
    	M.BOLL='N'
    ENDIF


	M.RIC='N'

	IF "RIBA" $ UPPER(ALLTRIM(M.ccdescri))	&& RICEVUTA BANCARIA
    	M.RIC='S'
    	M.NAT='A'    	
    ELSE
    	M.RIC='N'
    ENDIF
  
    
    
    __CLI_FOR	= ALLTRIM(m.ccflrife)

    
    M.LIB='A'							&& CLIENTE/FORNITORE/ALTRO
	M.CREAPART='N'						&& CREAZIONE PARTITARI

    IF __CLI_FOR = "C"
    	M.LIB		='C'				&& CLIENTE
		M.CREAPART	='S'
	ELSE
	    IF __CLI_FOR = "A"
	    	M.LIB		='F'			&& FORNITORE
			M.CREAPART	='S'
	    ENDIF
	ENDIF


	DO CASE
		CASE  M.FAT = "P"	&& PAGAMENTO
			M.CREAPART	='S'
		CASE  M.FAT = "I"	&& INSOLUTO
			M.CREAPART	='S'
	ENDCASE


	DO CASE
		CASE M.RIC='S'			&& RICEVUTA
	    	M.LIB		='C'	&& CLIENTE
			M.CREAPART	='S'
	ENDCASE

    M.TOP_COL			=SPACE(03)
    
    M.NO_AUT			=' '
    M.PR_NO				=' '
    M.PR_SI				=' '
    M.PR_TOP			=' '
    M.PR_ANA			=' '
    M.PR_LIS			=' '
    M.PR_LAN			=' '
	M.AGGANCIAPARTITARI	=' '		&& AGGANCIA PARTITARI ANCHE PER LE PARTITE CHIUSE


    M.CEE=' '
    
    _CERCA_PAROLA_CEE = "CEE"
    _POSIZIONE_PAROLA_CEE = AT(_CERCA_PAROLA_CEE,M.ccdescri)   
    IF _POSIZIONE_PAROLA_CEE <> 0
    	M.CEE='E'
    ENDIF
    _CERCA_PAROLA_REVERSE = "REVERSE"
    _POSIZIONE_PAROLA_REVERSE = AT(_CERCA_PAROLA_REVERSE,M.ccdescri)   
    IF _POSIZIONE_PAROLA_REVERSE <> 0
    	M.CEE='R'
    ENDIF
 
   
    M.INTRA				=' '
    M.CSC				=' '
    M.IMPE				=' '
    M.RFOR				=' '
    M.RCLI				=' '
    M.CLAV				=' '
    M.CDEP				=' '
    M.IL_CCO			=' '
    M.IN_CCO			=' '
	M.TMOV   			= SPACE(02)
	M.CONCAU 			= SPACE(03)
	M.TPROC  			= SPACE(03)    

	M.FASCIACOMPETENZA	='C'				&& CONTABILE
	M.RPRO   			= SPACE(01)

	M.CANT				= SPACE(01)
	M.NOQUADRA 			= SPACE(01)
	M.CALCIMPOS			= SPACE(01)
	M.PINCAMULTI		= SPACE(01)
	M.CONTRCCO  		= SPACE(01)
	M.SITFIN    		= SPACE(01)
	M.SITCPA			= SPACE(01)
	M.NOCOMMESSA		= SPACE(01)
    M.VENACQ 			= SPACE(02)



    M.LIBERA=M.NAT+M.FAT+'      '+M.BOLL+M.RIC+M.NOTA+M.LIB+M.TOP_COL+M.NO_AUT+M.PR_NO+M.PR_SI+M.PR_TOP+M.PR_ANA+M.PR_LIS+M.PR_LAN+M.CEE+M.INTRA+M.CSC+M.IMPE+M.RFOR+M.RCLI+M.CLAV+M.CDEP+M.IL_CCO+M.IN_CCO+M.TMOV+M.CONCAU+M.TPROC+M.CREAPART+M.FASCIACOMPETENZA+M.RPRO+M.AGGANCIAPARTITARI+M.CANT+m.noquadra+M.calcimpos+m.pincamulti+m.contrcco+m.sitfin+M.VENACQ+m.sitcpa+m.nocommessa
   

 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO

	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF


**=> ERASMO - INIZIO 15/10/2013
*** INSERIMENTO CAUSALI DI CHIUSURA E APERTURA AUTOMATICA ANNI CONTABILI
cSql=""     
cNomeCursorSql="INS_PARA_TOP"
TEXT TO cSql NOSHOW

	DECLARE @DATA_OGGI_ISO_cAAAAMMGG VARCHAR(8)
	DECLARE @DATA_OGGI_TXT_cAAAAMMGG VARCHAR(10)

	SET @DATA_OGGI_ISO_cAAAAMMGG = CONVERT(VARCHAR(8), Getdate(), 112)
	SET @DATA_OGGI_TXT_cAAAAMMGG = Substring(@DATA_OGGI_ISO_cAAAAMMGG, 1, 4) + '/' +
								   Substring(@DATA_OGGI_ISO_cAAAAMMGG, 5, 2) + '/' +
								   Substring(@DATA_OGGI_ISO_cAAAAMMGG, 7, 2)

	DELETE FROM PARA WHERE CODICE = 'TOPCHI'
	INSERT INTO PARA
	            (CODICE,
	             DESCRI,
				 LIBERA,
				 PAR_DATINS)
	VALUES		('TOPCHI',
				 'CHIUSURA AUTOMATICA',
				 'DP      NNNA                             C',
				 @DATA_OGGI_TXT_cAAAAMMGG)

	DELETE FROM PARA WHERE CODICE = 'TOPAPE'
	INSERT INTO PARA
	            (CODICE,
	             DESCRI,
				 LIBERA,
				 PAR_DATINS)
	VALUES		('TOPAPE',
				 'APERTURA AUTOMATICA',
				 'DN      NNNA                            NC',
				 @DATA_OGGI_TXT_cAAAAMMGG)

ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

_CTR = _CTR + 2
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
**=> ERASMO - FINE 15/10/2013


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 