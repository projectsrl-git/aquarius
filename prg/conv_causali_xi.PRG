*************************************************************************************************
*							CONVERSIONE CAUSALI			 										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"anagrafica CAUSALI da foglio Execl	 ?",292,"ATTENZIONE")
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

		IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
		   return
		ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA CAUSALI SQL 


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CAUSALI" NOWAIT


		cSql = "delete from PARA where CODICE LIKE 'TOP%' "
		IF !ExecCommand(cSql,"PARA")
		   return(.f.)
		ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




		gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file EXCEL >>>>>>>>>>> "+gcFile 		

		CREATE CURSOR IMPORTAXLS (CAMPO1  c(100),;
			B   	c(20),;	
			C   	c(20),;	
			D   	c(20),;	
			E   	c(20),;	
			F   	c(20),;	
			G   	c(20),;	
			H   	c(20),;	
			I   	c(20),;	
			J   	c(20),;	
			K   	c(20),;	
			L   	c(20),;	
			M   	c(20),;	
			N   	c(20),;	
			O   	c(20),;	
			P   	c(20),;	
			Q   	c(20),;	
			R   	c(20),;	
			S   	c(20),;	
			T   	c(20))
			
		APPEND FROM (gcFile) TYPE xls	



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS
GO TOP 

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    
    
*!*	#####################################################


	M.CODICE 	= "TOP"+SUBSTR(CAMPO1,1,3)
   	M.DESCRI 	= ALLTRIM(SUBSTR(CAMPO1,7,100))
   		
    M.NAT		= ALLTRIM(SUBSTR(E,01,01))
    IF M.NAT	= "D" OR M.NAT	= "A"
    ELSE
    	M.NAT	= "D"
    ENDIF
     
     
     
    __FAT	= ALLTRIM(SUBSTR(H,01,01))
    __INS	= ALLTRIM(SUBSTR(R,01,01))
    
    
    
    DO CASE 
    	CASE __FAT = "V"						&& VENDITA
							M.FAT = "S"
							M.NOTA= "N"
       	CASE __FAT = "A" 						&& AUTOFATTURA
							M.FAT = "S"
							M.NOTA= "N"
       	CASE __FAT = "C" 						&& RICEVUTE FISCALI/CORRISPETTIVI
							M.FAT = "C"
							M.NOTA= "N"
       	CASE __FAT = "C" 						&& NOTA CREDITO
							M.FAT = "S"
							M.NOTA= "S"
       	CASE __FAT = "R" 						&& RESI SU NOTA CREDITO
							M.FAT = "S"
							M.NOTA= "S"
       	CASE __FAT = "S" 						&& NOTE A CREDITO IN SOSPENSIONE
							M.FAT = "S"
							M.NOTA= "S"
       	CASE __FAT = "Z" 						&& SCARICO IVA 
							M.FAT = "S"
							M.NOTA= "S"
    	OTHERWISE 
       		    			M.FAT = "N"
       		    			M.NOTA= "N"
    	
    ENDCASE
    

    IF __INS = "S"		&& INSOLUTO
    	M.FAT = "I"
    	M.NOTA= "N"
    ENDIF

    IF UPPER(SUBSTR(M.DESCRI,1,3)) = "PAG"	&& PAGAMENTO
    	M.FAT = "P"
    	M.NOTA= "N"
    ENDIF
    
    IF M.FAT = "S"		&& BOLLATO IVA
    	M.BOLL='S'
    ELSE
    	M.BOLL='N'
    ENDIF
    
 
  

    IF SUBSTR(M.DESCRI,1,3) = "Ricevuta bancaria"	&& RICEVUTA BANCARIA
    	M.RIC='S'
    ELSE
    	M.RIC='N'
    ENDIF
  
    
    
    __LIBCLI	= ALLTRIM(SUBSTR(B,01,01))
    __LIBFOR	= ALLTRIM(SUBSTR(C,01,01))    
    
    M.LIB='A'					&& CLIENTE/FORNITORE/ALTRO
	M.CREAPART='N'				&& CREAZIONE PARTITARI

    IF __LIBCLI = "S"
    	M.LIB		='C'				&& CLIENTE
		M.CREAPART	='S'
	ELSE
	    IF __LIBFOR = "S"
	    	M.LIB		='F'			&& FORNITORE
			M.CREAPART	='S'
	    ENDIF
	ENDIF



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
    _POSIZIONE_PAROLA_CEE = AT(_CERCA_PAROLA_CEE,CAMPO1)   
    IF _POSIZIONE_PAROLA_CEE <> 0
    	M.CEE='E'
    ENDIF
    _CERCA_PAROLA_REVERSE = "reverse"
    _POSIZIONE_PAROLA_REVERSE = AT(_CERCA_PAROLA_REVERSE,CAMPO1)   
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
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 