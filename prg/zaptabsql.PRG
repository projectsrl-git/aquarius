*********************************************************************************************
*                     			       									   				   	*
*  								 CANCELLAZIONE TABELLE SQL 						 		   	*
*                     			       									   				   	*
*********************************************************************************************
*                     			       									   				   	*
*	QUESTO PROGRAMMA CANCELLA IL CONTENUTO DELLE TABELLE SQL								*
*	EVENTUALI CASI PARTICOLARI SONO GESTITI QUI DI SEGUITO									*
*           										  	             					   	*
********************************************************************************************* 

PUB_PJPWD=.F.
PUB_MESS="Cancellazione tabelle SQL Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 

IF !PUB_PJPWD
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF

PUB_ERRORE=MESSAGEBOX('Cancellazione tabelle SQL'+CHR(13)+'procedere',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE

PUB_ERRORE=MESSAGEBOX('Questa procedura cancella il contenuto delle tabelle SQL'+CHR(13)+'procedere',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE

PUB_ERRORE=MESSAGEBOX('Ultimo avviso'+CHR(13)+'procedere',292,'*** ATTENZIONE ***')
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE


*!*	RICAVO L'ELENCO DELLE TABELLE DALLA TABELLA DI SISTEMA DEL DB
*!*	CHE SI CHIAMA "SysObjects" 
cSql = "SELECT * FROM SysObjects where Type='U' ORDER BY NAME"
IF !ExecCommand(cSql,"ELENCO_TABELLE")
	RETURN .F.
ENDIF

SELECT ELENCO_TABELLE
GO TOP

_INIZIO_ELAB = TIME()

DO WHILE !EOF()
	IF DELETED()
		SKIP + 1
		LOOP
	ENDIF

	__TABVIA = UPPER(ALLTRIM(NAME))


	WAIT WINDOW "ELABORAZIONE TABELLA >>>>"+__TABVIA+"<<<< IN CORSO ..." NOWAIT
	

	*** GESTIONE DEI CASI PARTICOLARI
	DO CASE
	
	   *************************************************************	
	   *** TABELLE DI CONFIGURAZIONE
	   *************************************************************	
		CASE __TABVIA = "U_AZI_AN"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "U_AZI_PA"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "PARA"
			*** NON CANCELLA NULLA
				
		CASE __TABVIA = "PARA1"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "PARACONF"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "PARAX"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "PJTIPREP"
			*** NON CANCELLA NULLA				




	   *************************************************************	
	   *** TABELLE LEGATE AI MENU
	   *************************************************************	
		CASE __TABVIA = "RES_OPER"
			*** CANCELLA TUTTO TRANNE GLI UTENTI "SER" E "GEN" (I DUE UTENTI ASSISTENZA PROJECT)
			cSql = "DELETE FROM "+__TABVIA+" WHERE CODICE NOT IN ('SER','GEN')"
			IF !ExecCommand(cSql,__TABVIA)
				RETURN .F.
			ENDIF

		CASE __TABVIA = "RES_MENU"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "res_oper_conf"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "RES_PROC"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "RIC_ARC"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "TBL_MENU"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "_SUPP_MENU"
			*** NON CANCELLA NULLA



	   *************************************************************	
	   *** TABELLE DI ANAGRAFICHE CHE VANNO BENE PER TUTTI
	   *************************************************************
		CASE __TABVIA = "REGIONI"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "PROVINCE"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "COMUNI"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "ABICAB"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "U_BAN_AN"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "U_VVA_CH"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "U_CLI_AN"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "U_FOR_AN"
			*** NON CANCELLA NULLA


	   *************************************************************	
	   *** TABELLE LEGATE ALLA CONTABILITA'
	   *************************************************************
		CASE __TABVIA = "CCOSTO"
	        cSql = "select * from ccosto"
	        IF !ExecRW(cSql,"CCOSTO","R")
	           RETURN .F.
	        ENDIF
	        SELECT CCOSTO
	        GO TOP   
	  	    DO WHILE .T.
	  	       IF EOF()
	  	          EXIT
	  	       ENDIF
		       REPLACE CON_IMP_D WITH 0
		       REPLACE CON_DA01  WITH 0
		  	   REPLACE CON_DA02  WITH 0
		  	   REPLACE CON_DA03  WITH 0
		  	   REPLACE CON_DA04  WITH 0
		  	   REPLACE CON_DA05  WITH 0
		  	   REPLACE CON_DA06  WITH 0
		  	   REPLACE CON_DA07  WITH 0
		       REPLACE CON_DA08  WITH 0
		  	   REPLACE CON_DA09  WITH 0
		  	   REPLACE CON_DA10  WITH 0
		  	   REPLACE CON_DA11  WITH 0
	  		   REPLACE CON_DA12  WITH 0
	  		   SKIP +1
		    ENDDO
	        IF !ExecRW(cSql,"CCOSTO","W")
	           RETURN .F.
	        ENDIF

		
		CASE __TABVIA = "CONTI"
	        cSql = "select * from conti"
	        IF !ExecRW(cSql,"CONTI","R")
	           RETURN .F.
	        ENDIF
	        SELECT CONTI
	        GO TOP   
	 	    DO WHILE .T.
	 	       IF EOF()
	 	          EXIT
	 	       ENDIF
	  	       REPLACE CON_IMP_D WITH 0
		       REPLACE CON_IMP_A WITH 0
	  		   REPLACE CON_DA01 WITH 0
		       REPLACE CON_AV01 WITH 0
	  		   REPLACE CON_DA02 WITH 0
		  	   REPLACE CON_AV02 WITH 0
		  	   REPLACE CON_DA03 WITH 0
		  	   REPLACE CON_AV03 WITH 0
		  	   REPLACE CON_DA04 WITH 0
		  	   REPLACE CON_AV04 WITH 0 
		  	   REPLACE CON_DA05 WITH 0
		  	   REPLACE CON_AV05 WITH 0
	  		   REPLACE CON_DA06 WITH 0
		  	   REPLACE CON_AV06 WITH 0
	  		   REPLACE CON_DA07 WITH 0
		  	   REPLACE CON_AV07 WITH 0
		  	   REPLACE CON_DA08 WITH 0
		  	   REPLACE CON_AV08 WITH 0
	  		   REPLACE CON_DA09 WITH 0
		  	   REPLACE CON_AV09 WITH 0
		  	   REPLACE CON_DA10 WITH 0
		  	   REPLACE CON_AV10 WITH 0
		  	   REPLACE CON_DA11 WITH 0
	  		   REPLACE CON_AV11 WITH 0
		  	   REPLACE CON_DA12 WITH 0
	  		   REPLACE CON_AV12 WITH 0
	  		   REPLACE CON_FATTURA WITH 0	  		   
		  	   SKIP +1
	 	    ENDDO  
	        IF !ExecRW(cSql,"CONTI","W")
	           RETURN .F.
	        ENDIF
	        
	        *** CANCELLA TUTTI I CONTI "CLIENTE" E "FORNITORE"
			cSql = "DELETE FROM "+__TABVIA+" WHERE con_tipoco in ('C','F')"
			IF !ExecCommand(cSql,__TABVIA)
				RETURN .F.
			ENDIF	        

	        

		
	   *************************************************************	
	   *** TABELLE PARTICOLARI
	   *************************************************************	
		CASE __TABVIA = "CHIUSURA"
			*** NON CANCELLA NULLA
			
		CASE __TABVIA = "LINGUE"
			*** NON CANCELLA NULLA
			
		CASE __TABVIA = "NEW_COM"
			*** NON CANCELLA NULLA
			
		CASE __TABVIA = "NOTE_COM"
			*** NON CANCELLA NULLA
			
		CASE __TABVIA = "NOTE_COM"
			*** NON CANCELLA NULLA
			
		CASE __TABVIA = "SETUP"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "STRINGSQL"
			*** NON CANCELLA NULLA
		
		CASE __TABVIA = "U_CAL_AS"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "U_CAL_CO"
			*** NON CANCELLA NULLA

		CASE __TABVIA = "U_CAL_LA"
			*** NON CANCELLA NULLA


		OTHERWISE
		
		   * ###########################################################		
		   * ###########################################################
		   *************************************************************	
		   *** TUTTE LE ALTRE TABELLE SQL VENGONO CANCELLATE
		   *************************************************************
		   * ###########################################################
		   * ###########################################################		   		   
		
			cSql = "DELETE FROM "+__TABVIA+" WHERE 1=1"
			IF !ExecCommand(cSql,__TABVIA)
				RETURN .F.
			ENDIF
		
	ENDCASE
	
	SELECT ELENCO_TABELLE
	SKIP + 1
	
ENDDO

SELECT ELENCO_TABELLE
USE


_FINE_ELAB = TIME()

MSG = "INIZIO ELABORAZIONE ORE : >>> " +_INIZIO_ELAB + " <<<" + CHR(13) +;
	  "FINE ELABORAZIONE ORE : >>> " + _FINE_ELAB + " <<<" 

=MESSAGEBOX(MSG,16,'*** ATTENZIONE ***')

__MESSAGGIO_FINALE = "OPERAZIONE TERMINATA!"+CHR(13)+"ORA E' POSSIBILE EFFETTUARE LA CONVERSIONE ARCHIVI"
MESSAGGIO_GROSSO_BLU(__MESSAGGIO_FINALE)

	
   


