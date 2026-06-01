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

SET STEP ON 

**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA



		WAIT WINDOWS "Selezionato file TESTO >>>>>>>>>>> "+gcFile 		


		CREATE CURSOR IMPORTAXLS ( ;
					tdtop	  	  c(50),;
					tdtipdoc	  c(50),;	
					tddesdoc	  c(50),;	
					tdcatdoc	  c(50),;	
					tdflveac	  c(50),;	
					tdalfdoc	  c(50),;	
					tdcaucon	  c(50),;	
					tdcaumag	  c(50),;	
					tdcodmag	  c(50),;	
					tdcodmat	  c(50),;	
					tdprgsta	  c(50),;	
					tdflacco	  c(50),;	
					tfflragg	  c(50),;	
					tdflrice	  c(50),;	
					tdflrisc	  c(50),;	
					tdflnsri	  c(50),;	
					tdflorat	  c(50),;	
					tdaspett	  c(50),;	
					tfflgefa	  c(50),;	
					tdfldatt	  c(50),;	
					dccolleg	  c(50),;	
					dccodice	  c(50),;	
					dcflinte	  c(50),;	
					dcflevas	  c(50),;	
					dcflacco	  c(50),;	
					dcdocagg	  c(50),;	
					tddesdoc1	  c(50),;	
					oudesprg	  c(50),;	
					oudescri	  c(50),;	
					tdflinte	  c(50),;	
					tdflesis	  c(50),;	
					tdfldisp	  c(50),;	
					tdflcash	  c(50),;	
					tdflcris	  c(50),;	
					tdflprov	  c(50),;	
					tdfldtpr	  c(50),;	
					tdnumsco	  c(50),;	
					tdflvsri	  c(50),;	
					tdflnsta	  c(50),;	
					tdflbudg	  c(50),;	
					tdflesec	  c(50),;	
					tdfldonc	  c(50),;	
					tdflpros	  c(50),;	
					tdconass	  c(50),;	
					tdflcvan	  c(50),;	
					tdflvalo	  c(50),;	
					tdflsili	  c(50),;	
					tdtpvdoc	  c(50),;	
					tdtpndoc	  c(50),;	
					tdflimac	  c(50),;	
					tdflpack	  c(50),;	
					tdflimpa	  c(50),;	
					tdflstlm	  c(50),;	
					tdemeric	  c(50),;	
					tdprzvac	  c(50),;	
					tdflstse	  c(50),;	
					tdrateva	  c(50),;	
					tdproalt	  c(50),;	
					oudescri1	  c(50),;	
					tdassces	  c(50),;	
					tdflrfid	  c(50),;	
					tdflmoul	  c(50),;	
					tdflrifi	  c(50),;	
					tdstoana	  c(50),;	
					tdfldtrc	  c(50),;	
					tdflglis	  c(50),;	
					tdflrips	  c(50),;	
					tdstadoc	  c(50),;	
					tdflintor	  c(50),;	
					tdconfig	  c(50),;	
					tdserpro	  c(50),;	
					tdflppro	  c(50),;	
					tdflagqt	  c(50),;	
					tdflgcon	  c(50),;	
					dcflrips	  c(50),;	
					lgcodlin	  c(50),;	
					lgdescod	  c(50),;	
					lgprgsta	  c(50),;	
					ordine		  c(50),;
					tdflgein	  c(50),;	
					tdflapca	  c(50),;	
					tdripcon	  c(50),;	
					tdnostco	  c(50),;	
					tdgenpro	  c(50),;	
					tdflries	  c(50),;	
					tdtpries	  c(50),;	
					tdflgrii	  c(50),;	
					tdflgric	  c(50),;	
					tdflgrit	  c(50),;	
					tdflprat	  c(50),;	
					tdflgkey	  c(50),;	
					tdnoanal	  c(50),;	
					tdcodstr	  c(50),;	
					tdmagdef	  c(50),;	
					tdricnom	  c(50),;	
					tdmtdclc	  c(50),;	
					tdcauass	  c(50),;	
					tdcausto	  c(50),;	
					tdflcont	  c(50),;	
					tdrivori	  c(50),;	
					tdcarmat	  c(50),;	
					tdscamat	  c(50))

			
		APPEND FROM (gcFile) TYPE sdf	



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS
GO TOP 

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(TDTOP)) = "TDTOP"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 

    SCATTER MEMVAR MEMO     
    
*!*	#####################################################

	M.CODICE 	= "TOP"+alltrim(M.tdtop)
   	M.CODICE2	= ALLTRIM(M.tdtipdoc)
   	M.DESCRI 	= ALLTRIM(M.tddesdoc)

    _TIPO_DOC	= ALLTRIM(SUBSTR(M.oudescri,1,07))

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
    	
   		
    _TIPO_		= ALLTRIM(M.tdflveac)
    
    IF _TIPO_	= "V" 
    	M.NAT	= "D"	&& VENDITE
    ELSE
    	M.NAT	= "A"	&& ACQUISTI
    ENDIF
     

*!*	    __INS	= ALLTRIM(SUBSTR(CAMPO1,07,03))
*!*	    IF __INS = "INS"		&& INSOLUTO
*!*	    	M.FAT = "I"
*!*	    	M.NOTA= "N"
*!*	    	M.NAT = "D"
*!*	    ENDIF

*!*	    IF UPPER(SUBSTR(M.DESCRI,1,3)) = "PAG"	&& PAGAMENTO
*!*	    	M.FAT = "P"
*!*	    	M.NOTA= "N"
*!*	    	M.NAT = "D"
*!*	    ENDIF
    
    IF M.FAT = "S"		&& BOLLATO IVA
    	M.BOLL='S'
    ELSE
    	M.BOLL='N'
    ENDIF


	M.RIC='N'

*!*	    __RIB	= ALLTRIM(SUBSTR(CAMPO1,07,03))
*!*	  
*!*	    IF __RIB = "*RB"	&& RICEVUTA BANCARIA
*!*	    	M.RIC='S'
*!*	    	M.NAT='A'    	
*!*	    ELSE
*!*	    	M.RIC='N'
*!*	    ENDIF
*!*	  
    
    
    __CLI_FOR	= ALLTRIM(m.tdflinte)

    
    M.LIB='A'							&& CLIENTE/FORNITORE/ALTRO
	M.CREAPART='N'						&& CREAZIONE PARTITARI

    IF __CLI_FOR = "C"
    	M.LIB		='C'				&& CLIENTE
		M.CREAPART	='S'
	ELSE
	    IF __CLI_FOR = "ACQ"
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
    _POSIZIONE_PAROLA_CEE = AT(_CERCA_PAROLA_CEE,M.tddesdoc)   
    IF _POSIZIONE_PAROLA_CEE <> 0
    	M.CEE='E'
    ENDIF
    _CERCA_PAROLA_REVERSE = "REVERSE"
    _POSIZIONE_PAROLA_REVERSE = AT(_CERCA_PAROLA_REVERSE,M.tddesdoc)   
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


 