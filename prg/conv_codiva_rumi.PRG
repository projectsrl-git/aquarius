*************************************************************************************************
*							CONVERSIONE CODICI IVA      										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2013 : Rumi	 				 													*
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

RIT = MESSAGEBOX("Conversione parametro iva da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF




****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA ZONE SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA IVA" NOWAIT


cSql = "delete from PARA where CODICE LIKE 'IVA%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


CREATE CURSOR IMPORTAXLS ( ;
	ivcodiva	C(15), ;
	ivdesiva 	C(100), ;
	ivperiva	C(100), ;	
	ivperind	C(100), ;
	ivmaciva	C(100), ;
	ivacqint	C(15), ;
	ivimpexp	C(100), ;
	ivplaiva	C(100), ;
	ivproiva	C(100), ;	
	ivboliva	C(100), ;
	ivdtobso	C(100), ;
	ivflvaff	C(15), ;
	ivcodint	C(100), ;
	ivrigque	C(100), ;
	ivrigquf	C(100), ;	
	utcc		C(100), ;
	utcv		C(100), ;
	utdc	    C(15), ;
	utdv		C(100), ;
	ivdtinva	C(100), ;
	ivdatana	C(100), ;	
	ivdatanp	C(100), ;
	ivtippla	C(100), ;
	ivautcom	C(100), ;
	ivcodinv	C(100), ;
	ivcodauv	C(100), ;	
	ivrevcha	C(100))



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
    
    IF UPPER(ALLTRIM(IVCODIVA)) = "IVCODIVA"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 
    
    SCATTER MEMVAR MEMO


    ___ivperiva = ALLTRIM(M.ivperiva)

	M.CODICE1 	=ALLTRIM(M.ivcodiva)	
	M.CODICE1   =CONV_CLEAR(APITOSPA(ALLTRIM(M.CODICE1))) 	
	M.CODICE2   =CONVERTE_CODICE_IVA_ZUCCHETTI(M.CODICE1)
	M.CODICE    ="IVA"+M.CODICE2
    M.DESCRI 	=ALLTRIM(APITOSPA(ALLTRIM(M.ivdesiva)))	
	M.DESCRI    =CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 


    _CONTO_CLI = "1414002" 
    _CONTO_FOR = "1414001" 
    
    
*campo libera  	
*D22  1414002                1414001                                                                I        100                                                                                                                                               
*21S  1414002                1414001                                                                I         60                                                                                                                                        
*22   1414002                1414001                                                                                                                                                                                                                     
*021  2092201                1011101                                                                I         40                                                                                         
*123456789012345678901234567890
*IND.POS 72 
*PER.IND 11   
    

    *LEN_CODICE2 	=LEN(M.CODICE2)
    *M.CODICE2X  	=M.CODICE2+REPLICATE(" ",(5-LEN_CODICE2)) 
    *M.LIBERA    	=M.CODICE2X
    
    LEN_CODICE2 	=LEN(___IVPERIVA)
    M.CODICE2X  	=___IVPERIVA+REPLICATE(" ",(5-LEN_CODICE2)) 
    M.LIBERA    	=M.CODICE2X
    



    LEN_CONTO_CLI   =LEN(_CONTO_CLI)
    _CONTO_CLIX		=_CONTO_CLI+REPLICATE(" " ,(23-LEN_CONTO_CLI))
    M.LIBERA    	=M.LIBERA + _CONTO_CLIX

    LEN_CONTO_FOR   =LEN(_CONTO_FOR)
    _CONTO_FORX		=_CONTO_FOR+REPLICATE(" " ,(71-LEN_CONTO_FOR))
    M.LIBERA    	=M.LIBERA + _CONTO_FORX


    IF VAL(ALLTRIM(M.IVPERIND)) > 0			&& IVA INDEDUCIBILE
    
    	LEN_IVPERIND   =LEN(M.IVPERIND)
    	IF LEN_IVPERIND   = 2
      	    M.LIBERA 		=M.LIBERA + "I"
		    LEN_IVPERINDX   =LEN(ALLTRIM(M.IVPERIND))
		    _IVPERINDX		=REPLICATE(" " ,(11-LEN_IVPERINDX))+ALLTRIM(M.IVPERIND)
		    M.LIBERA    	=M.LIBERA + _IVPERINDX
        ELSE
      	    M.LIBERA 		=M.LIBERA + "I"
		    LEN_IVPERINDX   =LEN(ALLTRIM(M.IVPERIND))
		    _IVPERINDX		=REPLICATE(" " ,(12-LEN_IVPERINDX))+ALLTRIM(M.IVPERIND)
		    M.LIBERA    	=M.LIBERA + _IVPERINDX
        ENDIF
        
    ENDIF
    
	
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
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 