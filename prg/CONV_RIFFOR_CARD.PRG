*************************************************************************************************
*							CONVERSIONE RIFERIMENTI ANAGRAFICA FORNITORI						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Settembre 2013 : Cardioline			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei riferimenti anagrafica fornitori in formato testo ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
		
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO

SELECT PERCORSO
V_PATH = ALLTRIM(PER_PATH)

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH 

****** DEFINIZIONE DEI CURSORI STP


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHI RIFERIMENTI ANAGRAFICA CLIENTI" NOWAIT

IF !ExecCommand("select * from U_RIF_CF where 1=0","curs_U_RIF_CF")
   return
ENDIF

_CLIFOR  = 'F'
x_cond  = "rif_clifor = '" + _CLIFOR + "'"

cSql   = "delete from U_RIF_CF where " + x_cond 
IF !ExecCommand(cSql,"U_RIF_CF")
   return(.f.)
ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA,_CODICE_PERSONA 
PUBLIC _CODICE_ZONA,_CODICE_PERSONA 
_CODICE_ZONA = 0
_CODICE_PERSONA  = 0


RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO TESTO


gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	
	RETURN
ENDIF



WAIT WINDOWS "Selezionato file FORMATO TXT >>>>>>>>>>> "+gcFile 		

CREATE CURSOR IMPORTATXT (CAMPO  c(250))
APPEND FROM (gcFile) TYPE sdf	

***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP
SELECT IMPORTATXT
GO TOP 



DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTATXT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF SUBSTR(CAMPO,1,5) = SPACE(05)
       SELECT IMPORTATXT   && scarto record
       SKIP +1
       LOOP
    ENDIF 


    IF SUBSTR(CAMPO,1,5) = '99999'
       SELECT IMPORTATXT   && scarto record
       SKIP +1
       LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
    
    
*!*	#####################################################

	M.RIF_CLIFOR = "F" 
    M.ID_UNIQUE  = ""
	M.RIF_FUNAZI = ""
	M.RIF_LOCUFF = ""
	M.RIF_INDUFF = ""
	M.RIF_CAPUFF = ""
	M.RIF_ATTIVO = ""   
	M.RIF_NOTE   = ""  
	M.RIF_CODFUN = ""
	    	
    DO CASE 
    
    	CASE SUBSTR(CAMPO,1,8) = "CLIENTE:"
    		
    		_CODCLI      = VAL(ALLTRIM(SUBSTR(CAMPO,32,9)))
    		
    		    		
    		M.RIF_CODCLI = STR(_CODCLI,9,0)
		 	M.RIF_CODCLI = ALLTRIM (M.RIF_CODCLI)
		   	M.RIF_CODCLI = UPPER(M.RIF_CODCLI)
		    M.RIF_CODCLI = APITOSPA(M.RIF_CODCLI)


*!*	IF M.RIF_CODCLI = '100199010'
*!*	SET STEP ON 
*!*	ENDIF
		
    		SKIP +1																		&& PERSONA DI RIFERIMENTO
			
			_CODICE_PERSONA = _CODICE_PERSONA +10
			_CODICE_PERSONA_X = ALLTRIM(STR(_CODICE_PERSONA,9,0))

			IF LEN(ALLTRIM(STR(_CODICE_PERSONA,9,0))) = 2
				_CODICE_PERSONA_X = "0000000"+ALLTRIM(STR(_CODICE_PERSONA,9,0)) 
			ENDIF
			IF LEN(ALLTRIM(STR(_CODICE_PERSONA,9,0))) = 3
				_CODICE_PERSONA_X = "000000"+ALLTRIM(STR(_CODICE_PERSONA,9,0)) 
			ENDIF
			IF LEN(ALLTRIM(STR(_CODICE_PERSONA,9,0))) = 4
				_CODICE_PERSONA_X = "00000"+ALLTRIM(STR(_CODICE_PERSONA,9,0)) 
			ENDIF
			IF LEN(ALLTRIM(STR(_CODICE_PERSONA,9,0))) = 5
				_CODICE_PERSONA_X = "0000"+ALLTRIM(STR(_CODICE_PERSONA,9,0)) 
			ENDIF
			IF LEN(ALLTRIM(STR(_CODICE_PERSONA,9,0))) = 6
				_CODICE_PERSONA_X = "000"+ALLTRIM(STR(_CODICE_PERSONA,9,0)) 
			ENDIF
			IF LEN(ALLTRIM(STR(_CODICE_PERSONA,9,0))) = 7
				_CODICE_PERSONA_X = "00"+ALLTRIM(STR(_CODICE_PERSONA,9,0)) 
			ENDIF
			IF LEN(ALLTRIM(STR(_CODICE_PERSONA,9,0))) = 8
				_CODICE_PERSONA_X = "0"+ALLTRIM(STR(_CODICE_PERSONA,9,0)) 
			ENDIF
			IF LEN(ALLTRIM(STR(_CODICE_PERSONA,9,0))) = 9
				_CODICE_PERSONA_X = ALLTRIM(STR(_CODICE_PERSONA,9,0)) 
			ENDIF
			
			M.RIF_CODICE = _CODICE_PERSONA_X    		
			M.RIF_COGNOM = ALLTRIM(SUBSTR(CAMPO,01,90))  	
		 	M.RIF_COGNOM = ALLTRIM (M.RIF_COGNOM)
		   	M.RIF_COGNOM = UPPER(M.RIF_COGNOM)
		    M.RIF_COGNOM = APITOSPA(M.RIF_COGNOM)

    		M.RIF_NOME   = "" 

    		SKIP +1																		&& TELEFONO/FAX
			
    		_PREFTELE 		= ALLTRIM(SUBSTR(CAMPO,22,10)) 
    		M.RIF_TELUFF 	= _PREFTELE + "-" + ALLTRIM(SUBSTR(CAMPO,33,10)) 
*!*	    		_PREFFAX  		= ALLTRIM(SUBSTR(CAMPO,165,15)) 
    		M.RIF_FAX    	= ALLTRIM(SUBSTR(CAMPO,46,90)) 
    		
 
    		SKIP +1																		&& CELLULARE
			
    		M.RIF_TELMOB    = ALLTRIM(SUBSTR(CAMPO,22,20)) 
  
    		SKIP +1																		&& EMAIL
			
    		M.RIF_EMAIL     = LOWER(ALLTRIM(SUBSTR(CAMPO,22,60))) 
  
	    	SELECT curs_U_RIF_CF				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
		   	APPEND BLANK
		   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
		    SCATTER MEMVAR MEMO
		    
 
   		
    ENDCASE 



*!*		x_codi = "rif_codcli = '" + M.RIF_CODCLI + "'"
*!*		x_cf   = "rif_clifor = '" + M.RIF_CLIFOR + "'"
*!*		
*!*		x_cond = x_codi + " and " + x_cf
*!*		cSql = "select * from U_RIF_CF where " + x_cond + " order by rif_codcli,rif_codice"

*!*		IF !ExecCommand(cSql,"U_RIF_CF")
*!*		   RETURN .F.
*!*		ENDIF

*!*		SELECT U_RIF_CF
*!*		GO TOP
*!*		IF EOF()
*!*			APPEND BLANK
*!*		ENDIF
*!*		DO U_RIF_CF
*!*		IF !ExecRW('','U_RIF_CF','I','','U_RIF_CF')
*!*		  return(.f.)
*!*		ENDIF	

							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   

    	
    SELECT IMPORTATXT
	SKIP

ENDDO




SELECT curs_U_RIF_CF
GO TOP

****** AGGIORNA TABELLA U_RIF_CF SQL
IF !ExecRW('','U_RIF_CF','I','','curs_U_RIF_CF')
   return(.f.)
ENDIF
	 




=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 