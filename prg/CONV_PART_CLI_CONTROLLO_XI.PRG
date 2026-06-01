*************************************************************************************************
*							CONVERSIONE PARTITARI CLIENTI 										*
*							 																	*
*		Controllo partite aperte convertite in aquarius : calcola il saldo totale partite		*
*							 																	*
*							 																	*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Gennaio 2012 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con il controllo "+CHR(13)+"dei saldi convertiti del partitario clienti XILOPAN ?",292,"ATTENZIONE")
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

		IF !ExecCommand("select * from PART_CLI where 1=0","cursore_part_cli")
		   return
		ENDIF


*** CANCELLAZIONE DEI RECORD DEI PARTITARI SQL 



*!*			RIT = MESSAGEBOX("Desideri cancellare "+CHR(13)+"il partitario clienti XILOPAN ?",292,"ATTENZIONE")
*!*			IF RIT = 7
*!*			ELSE 
*!*			    WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE ARCHIVI PARTITARI CLIENTI" NOWAIT
*!*				cSql = "delete from PART_CLI"
*!*				IF !ExecCommand(cSql,"PART_CLI")
*!*				   return(.f.)
*!*				ENDIF
*!*			ENDIF




******** RECUPERO PARAMETRI SOTTOGRUPPO

x_cond = "codice = 'GEN" + PUB_CODSOC + "'"
cSql   = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF
SELECT PARA
IF reccount() > 0
   PUB_CC=SUBSTR(LIBERA,1,pub_sottog-1)
   PUB_FF=SUBSTR(LIBERA,18,pub_sottog-1)
ELSE
   =MESSAGEBOX("Parametro << GEN01 >> non trovato",16,"*** ATTENZIONE ***")
   RETURN
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = RIBALTA2(DTOC(DATE()))
_CTR = 0


RELEASE _TtDARE,_TtAVERE,_TtSALDO
PUBLIC _TtDARE,_TtAVERE,_TtSALDO
_TtDARE	 = 0
_TtAVERE = 0
_TtSALDO = 0

RELEASE    	__MANTIENE_PARTITA_CHIUSA
PUBLIC     	__MANTIENE_PARTITA_CHIUSA
__MANTIENE_PARTITA_CHIUSA = .F.


RELEASE M.PAR_NUMPRO   	
PUBLIC  M.PAR_NUMPRO 


RELEASE	M.PAR_CODICE 
RELEASE	M.PAR_CODCLI 
RELEASE	M.PAR_CODCLI 
RELEASE	M.PAR_RAGSOC 
RELEASE	M.PAR_TEL    
RELEASE	M.PAR_IVA    
RELEASE	M.PAR_CODPAG 
RELEASE	___NAZION  


RELEASE	M.PAR_TIPFAT
RELEASE	M.TOP     			
RELEASE	CONIVAX   			
RELEASE	TCOD01    			
RELEASE	TCOD02    			
RELEASE	TCOD03    			
RELEASE	TCOD04    			
RELEASE	DES       			 
RELEASE	TP        			
RELEASE	FATTURA   			
RELEASE	VER_CONTO 			
RELEASE	NATURA    			
RELEASE	NO_AUT	  			
RELEASE	PR_NO	  			
RELEASE	PR_SI	  			
RELEASE	PR_TOP	  			
RELEASE	PR_ANA	  			
RELEASE	PR_LIS    			
RELEASE	PR_LAN    			
RELEASE	__CEE     			
RELEASE	IL_CCO    			
RELEASE	IN_CCO    			
RELEASE	TPROC     			
RELEASE	AGGANCIAPARTITARI 	
RELEASE	CANT    			
RELEASE	noquadra            
RELEASE	pincamulti 			
RELEASE	NOTACREDITO         
RELEASE	CREAPART           
RELEASE	CONTRCCO  			
RELEASE	NOCOMME             



PUBLIC	M.PAR_TIPFAT
PUBLIC	M.TOP     			
PUBLIC	CONIVAX   			
PUBLIC	TCOD01    			
PUBLIC	TCOD02    			
PUBLIC	TCOD03    			
PUBLIC	TCOD04    			
PUBLIC	DES       			 
PUBLIC	TP        			
PUBLIC	FATTURA   			
PUBLIC	VER_CONTO 			
PUBLIC	NATURA    			
PUBLIC	NO_AUT	  			
PUBLIC	PR_NO	  			
PUBLIC	PR_SI	  			
PUBLIC	PR_TOP	  			
PUBLIC	PR_ANA	  			
PUBLIC	PR_LIS    			
PUBLIC	PR_LAN    			
PUBLIC	__CEE     			
PUBLIC	IL_CCO    			
PUBLIC	IN_CCO    			
PUBLIC	TPROC     			
PUBLIC	AGGANCIAPARTITARI 	
PUBLIC	CANT    			
PUBLIC	noquadra            
PUBLIC	pincamulti 			
PUBLIC	NOTACREDITO         
PUBLIC	CREAPART           
PUBLIC	CONTRCCO  			
PUBLIC	NOCOMME             


PUBLIC  M.PAR_CODICE 
PUBLIC	M.PAR_CODCLI 
PUBLIC	M.PAR_CODCLI 
PUBLIC	M.PAR_RAGSOC 
PUBLIC	M.PAR_TEL    
PUBLIC	M.PAR_IVA    
PUBLIC	M.PAR_CODPAG 
PUBLIC	___NAZION   


M.PAR_NUMPRO   	= ""

M.PAR_CODICE = SPACE(10)
M.PAR_CODCLI = SPACE(10)
M.PAR_CODCLI = SPACE(13)
M.PAR_RAGSOC = SPACE(50)
M.PAR_TEL    = SPACE(50)
M.PAR_IVA    = SPACE(50)
M.PAR_CODPAG = SPACE(03)
___NAZION    = SPACE(03)



	M.PAR_TIPFAT		= " "
	M.TOP     			= "   "
	CONIVAX   			= " " 
	TCOD01    			= " "
	TCOD02    			= " "
	TCOD03    			= " "
	TCOD04    			= " "
	DES       			= " "  
	TP        			= " "
	FATTURA   			= " "
	VER_CONTO 			= " "
	NATURA    			= " "
	NO_AUT	  			= " "
	PR_NO	  			= " "
	PR_SI	  			= " "
	PR_TOP	  			= " "
	PR_ANA	  			= " "
	PR_LIS    			= " "
	PR_LAN    			= " "
	__CEE     			= " "
	IL_CCO    			= " "
	IN_CCO    			= " "
	TPROC     			= " "
	AGGANCIAPARTITARI 	= " "
	CANT    			= " "
	noquadra            = " "
	pincamulti 			= " "
	NOTACREDITO         = " "
	CREAPART            = " "
	CONTRCCO  			= " "
	NOCOMME             = " "







**** CARICAMENTO DEL FILE IN FORMATO TXT




		gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file .TXT >>>>>>>>>>> "+gcFile 		


		CREATE CURSOR IMPORTATXT (CAMPO1  c(250))

		
		APPEND FROM (gcFile) TYPE sdf	



***** #########################################################################  ELABORA IL CURSORE transito PER CREARE IL CURSORE STP DI SUPPORTO

_CTR = 0
_TOTALE_DARE = 0
_TOTALE_AVERE = 0
_TOTALE_SALDO = 0

SELECT IMPORTATXT
GO TOP 
 

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTATXT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF SUBSTR(CAMPO1,01,07) = "Partite"
    ELSE 
       SELECT IMPORTATXT   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF      

    SCATTER MEMVAR MEMO



*!*	P Descrizione                Numero   Data   Dt Scad.  Altre div./Scad.                Dare            Avere
*!*	------------------------------------7-----------------------------------------X-----------------X------------
*!*	123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 
*!*	Partite v/credito!Effetti non emess!  Totale rimborsi! Tot. esposizione!   Saldo v/debito!     Totale rischio!
*!*	Partite v/credito!Effetti non emess!  Totale rimborsi! Tot. esposizione!  Saldo v/credito!     Totale rischio!

*!*	SUBSTR(CAMPO1,76,14) = "Saldo v/debito" CORRISPONDE A DARE > AVERE per cui deve pagare
*!*	SUBSTR(CAMPO1,75,15) = "Saldo v/credito" CORRISPONDE A DARE < AVERE IL CLIENTE DEVE RICEVERE

    
    _NATURA = ""    
    IF SUBSTR(CAMPO1,76,14) = "Saldo v/debito"
    	_NATURA = "D"
    ENDIF
    IF SUBSTR(CAMPO1,75,15) = "Saldo v/credito"
    	_NATURA = "A"
	ENDIF    



    SELECT IMPORTATXT
    SKIP +1
    IF !EOF()
    	_IMPORTO 	= SUBSTR(CAMPO1,75,15)
	    _CERCA_PAROLA_VIRGOLA = ","
	    _POSIZIONE_PAROLA_VIRGOLA = AT(_CERCA_PAROLA_VIRGOLA,_IMPORTO)   
		IF _POSIZIONE_PAROLA_VIRGOLA <> 0
			_VALUTA  = "EURO"
		ELSE
			_VALUTA  = "LIRE"
		ENDIF
    	_IMPORTO 	 = STRTRAN(_IMPORTO,".","")	
    	_IMPORTO     = VAL(_IMPORTO)
		IF _VALUTA  = "LIRE"
			_IMPORTO   = ROUND((_IMPORTO) / 1936.27,6)		
		ENDIF

        _DARE = 0
        _AVERE = 0
		IF _NATURA = "D"
		    _DARE    = ROUND((_IMPORTO),2)  
		    
		    IF _dare   < 0 
		       WAIT windows "**** valore dare  negativo" 
		    ENDIF 
		    		    		    
		    _TOTALE_DARE = _TOTALE_DARE + _DARE    
		ENDIF
		IF _NATURA = "A"

		    _AVERE    = ROUND((_IMPORTO),2) 
		    
		    IF _AVERE    < 0 
		       WAIT windows "**** valore avere negativo" 
		    ENDIF 
		    		     
		    _TOTALE_AVERE = _TOTALE_AVERE + _AVERE   
		ENDIF
    ENDIF
    SELECT IMPORTATXT
    SKIP -1



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS ELABORATI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTATXT
	SKIP

ENDDO


WAIT WINDOWS "TOTALE DARE :" + STR(_TOTALE_DARE,15,2)+ " TOTALE AVERE :"+STR(_TOTALE_AVERE,15,2)+ " TOTALE SALDO :"+STR(_TOTALE_SALDO,15,2)

	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR


RETURN

	
