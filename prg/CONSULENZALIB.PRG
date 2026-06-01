*!*	##############################################################################################################
  
					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE APPLICAZIONI DI CONSULENZA                        ***
					***                                                                                        ***
		  			**********************************************************************************************

*!*	##############################################################################################################




***********************************************************************************
*      CALCOLO DEL TOTALE DELLE ATTIVITA' GESTIONE STUDI PROFESSIONISTI
***********************************************************************************
PROCEDURE CALCOLO_TOTALE_ATTIVITA_DA_CURSORE
***********************************************************************************
*!*	IL CALCOLO AVVIENE ELABORANDO IL CURSORE PRECEDENEMENTE LETTO
PARA _NOME_CURSORE

*!*	M.ValCosto 	= 0
*!*	M.ValRicavo = 0
*!*	M.ValUtile	= 0


_TOT_VALCOSTO = 0
_TOT_VALRICAVO = 0
_TOT_VALUTILE = 0

SELECT &_NOME_CURSORE 
GO TOP
SCAN
   	IF VALRICAVO > 0
   		_TOT_VALCOSTO = _TOT_VALCOSTO + ValCosto
   		_TOT_VALRICAVO = _TOT_VALRICAVO + ValRicavo 
   		_TOT_VALUTILE = _TOT_VALRICAVO - _TOT_VALCOSTO 
   	ENDIF
ENDSCAN
GO TOP

RETURN


***********************************************************************************
*     CALCOLO DEL TOTALE DELLE ATTIVITA' GESTIONE STUDI PROFESSIONISTI
***********************************************************************************
PROCEDURE CALCOLO_TOTALE_DELLA_ATTIVITA_CORRENTE
***********************************************************************************__________________________ ROUTIN CENTRALE PER IL CALCOLO COSTI/RICAVI
*!*	IL CALCOLO AVVIENE ELABORANDO IL CURSORE PRECEDENEMENTE LETTO AL III LIVELLO
*!*	ED IN FUNZIONE DELL'OPZIONE DI AGGIORNAMENTO CONTROAGGIORNA IL CURSORE DI III LIVELLO 
*!*	RICALCOLANDO,COSTI,RICAVI,ULITI

PARA _NOME_CURSORE,_AGGIORNA_CURSORE


VSP_VAL_COSTO  = 0
VSP_VAL_RICAVO = 0
VSP_VAL_UTILE  = 0

LOC_VAL_COSTO  = 0
LOC_VAL_RICAVO = 0
LOC_VAL_UTILE  = 0


SELECT &_NOME_CURSORE
GO TOP
SCAN


	DO CASE
	


			CASE  UMricavo = "NR"
			
				   	IF PrzRicavo > 0
				   		VSP_VAL_RICAVO = VSP_VAL_RICAVO + (PrzRicavo * QtaRicavo)
				   		VSP_VAL_COSTO  = VSP_VAL_COSTO  + (PrzCosto * QtaCosto) 
						VSP_VAL_UTILE  = VSP_VAL_RICAVO - VSP_VAL_COSTO	
						
				   		LOC_VAL_RICAVO = (PrzRicavo * QtaRicavo)
				   		LOC_VAL_COSTO  = (PrzCosto * QtaCosto) 
						LOC_VAL_UTILE  = LOC_VAL_RICAVO - LOC_VAL_COSTO				   	
				   	ENDIF

   	

			OTHERWISE
	
				   	IF PrzRicavo > 0
				   		VSP_VAL_RICAVO = VSP_VAL_RICAVO + (PrzRicavo)
				   		VSP_VAL_COSTO  = VSP_VAL_COSTO  + (PrzCosto) 
						VSP_VAL_UTILE  = VSP_VAL_RICAVO - VSP_VAL_COSTO	
						
				   		LOC_VAL_RICAVO = (PrzRicavo)
				   		LOC_VAL_COSTO  = (PrzCosto) 
						LOC_VAL_UTILE  = LOC_VAL_RICAVO - LOC_VAL_COSTO	
				   	ENDIF			
	
			
	
	ENDCASE
	


	IF _AGGIORNA_CURSORE
		SELECT &_NOME_CURSORE		&& aggiorna il totale calcolato della attività corrente sul cursore tabella attività di III livello
		REPLACE Ricavo 	WITH LOC_VAL_RICAVO
		REPLACE Costo 	WITH LOC_VAL_COSTO		
		REPLACE Utile 	WITH LOC_VAL_UTILE
	ENDIF


ENDSCAN
GO TOP

RETURN



***********************************************************************************
*      CALCOLO DEL TOTALE DELLE ATTIVITA' GESTIONE STUDI PROFESSIONISTI
***********************************************************************************
PROCEDURE RICALCOLA_IL_VALORE_DEI_CONTRATTI
***********************************************************************************
*!*	IL CALCOLO AVVIENE ELABORANDO IL DATABASE
*!*	SE IL NUMERO DEL CONTRATTO è = 999999 LA FUNZIONE RICALCOLA IL VALORE DI TUTTI I CONTRATTI 
*!*	DELL'ANNO INDICATO E IN TUTTI I CASI AGGIORNA IL DATA BASE
*!*	IL CALCOLO AVVIENE ELABORANDO IL CURSORE PRECEDENEMENTE LETTO AL III LIVELLO
*!*	IN FUNZIONE DELL'OPZIONE DI AGGIORNAMENTO CONTROAGGIORNA IL CURSORE DI III LIVELLO 
*!*	RICALCOLANDO,COSTI,RICAVI,ULITI
PARA _numero_contratto,_anno,_aggiorna_cursore_iii_livello

VSP_NUMERO_CONTRATTO 		= _numero_contratto
VSP_ANNO					= _anno
VSP_AGGIORNA_III_LIVELLO	= _aggiorna_cursore_iii_livello

VSP_VAL_COSTO  = 0
VSP_VAL_RICAVO = 0
VSP_VAL_UTILE  = 0


IF _numero_contratto = "999999"
	DO ELABORA_E_AGGIORNA_TUTTI_I_CONTRATTI
ELSE
	DO ELABORA_E_AGGIORNA_SINGOLO_CONTRATTO
ENDIF

RETURN


***********************************************************************************
*      CALCOLO DEL TOTALE DELLE ATTIVITA' GESTIONE STUDI PROFESSIONISTI
***********************************************************************************
PROCEDURE ELABORA_E_AGGIORNA_SINGOLO_CONTRATTO

*********************************************************************************** IN LAVORAZIONE SERGIO
*********************************************************************************** IN LAVORAZIONE SERGIO
*********************************************************************************** IN LAVORAZIONE SERGIO
*********************************************************************************** IN LAVORAZIONE SERGIO
*********************************************************************************** IN LAVORAZIONE SERGIO
*********************************************************************************** IN LAVORAZIONE SERGIO


   x_codi = "NUMERO = '" + ALLTRIM(VSP_NUMERO_CONTRATTO ) + "'" 
   x_anno = "substring(DATA,1,4) = '" + VSP_ANNO + "'" 
   x_cond = x_codi + " and " + x_anno 
   cSql   = "select * from CONTRSTUDI where " + x_cond
   IF !ExecCommand(cSql,"CU_CONTRSTUDI")
     return(.f.)
   ENDIF
   
   
   SELECT CU_CONTRSTUDI
   GO TOP
   IF EOF()
      MESSAGEBOX("Numero contratto " + ALLTRIM(VSP_NUMERO_CONTRATTO) + " inesistente per l'anno " + VSP_ANNO,16,"Attenzione")
      RETURN .F.
   ENDIF


RETURN


***********************************************************************************
*      CALCOLO DEL TOTALE DELLE ATTIVITA' GESTIONE STUDI PROFESSIONISTI
***********************************************************************************
PROCEDURE ELABORA_E_AGGIORNA_TUTTI_I_CONTRATTI
***********************************************************************************


    x_cond = "substring(DATA,1,4) = '" + VSP_ANNO + "'" 
    cSql   = "select * from CONTRSTUDI where " + x_cond  + " ORDER BY NUMERO"
    IF !ExecCommand(cSql,"CU_CONTRSTUDI")
       return(.f.)
    ENDIF
   
   
    SELECT CU_CONTRSTUDI
    GO TOP
    IF EOF()
       MESSAGEBOX("Nessun contratto elaborato per l'anno " + VSP_ANNO,16,"Attenzione")
       RETURN .F.
    ENDIF


    SELECT CU_CONTRSTUDI	
    GO top

	*!*	ELABORA I CONTRATTI A I LIVELLO
	DO WHILE .NOT. EOF()


		IF DELETED()
		    SELECT CU_CONTRSTUDI
	  		SKIP +1
	  		LOOP		
		ENDIF


			   SCATTER MEMVAR MEMO
			   
			   WAIT WINDOWS "Contratto in elaborazione n. :" + numero nowait
			   
			*!*	ACCEDE AL II LIVELLO PER ELABORARE OGNI SINGOLA ATTIVITA'
			
			   x_codi = "DAGGANCIO = '" + M.TAGGANCIO + "'"
			   x_cond = x_codi
			   cSql = "select * from CONTRST_DD where " + x_cond
			   IF !ExecCommand(cSql,"CU_CONTRST_DD")
				  return(.f.)
			   ENDIF

			   SELECT CU_CONTRST_DD
			   GO TOP
			   SCAN


					SCATTER MEMVAR MEMO
					*!*	ACCEDE AL III LIVELLO PER ELABORARE I MESI PREVISTI ED EFFETTUA IL CALCOLO COSTI/RICAVI/UTILI
					x_codi = "DAGGANCIO = '" + M.TAGGANCIO + "'"
					x_atti = "IDATTIVITA = '" + M.IDATTIVITA + "'" 
					x_cond = x_codi + " and " + x_atti
					cSql = "select * from CONTRST_DL where " + x_cond
					IF !ExecCommand(cSql,"CU_CONTRST_DL")
					  return(.f.)
					ENDIF

					
					VSP_VAL_COSTO  = 0
					VSP_VAL_RICAVO = 0
					VSP_VAL_UTILE  = 0
					
					
					DO CALCOLO_TOTALE_DELLA_ATTIVITA_CORRENTE  WITH "CU_CONTRST_DL",VSP_AGGIORNA_III_LIVELLO


					SELECT CU_CONTRST_DD	&& aggiorna il totale calcolato della attività corrente sul cursore tabella attività di II livello
					
					REPLACE ValCosto 	WITH VSP_VAL_COSTO
					REPLACE ValRicavo 	WITH VSP_VAL_RICAVO
					REPLACE ValUtile 	WITH VSP_VAL_UTILE


			   ENDSCAN



			   *!*	AGGIORNA IL DATA BASE DELLE ATTIVITA' A III LIVELLO
			   
			   IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
				   return(.f.)
			   ENDIF


			   *!*	AGGIORNA IL DATA BASE DELLE ATTIVITA' A II LIVELLO
			   
			   IF !ExecRW('','CONTRST_DD','I','','CU_CONTRST_DD')
				   return(.f.)
			   ENDIF


			   * -->> Creazione cursore vuoto di dettaglio contratto II livello
			   * --------------------------------------------------------------
			   IF !ExecCommand("select * from CONTRST_DD where 0=1","CU_CONTRST_DD")
				  return(.f.)
			   ENDIF


			   * -->> Creazione cursore vuoto di dettaglio contratto III livello
			   * ---------------------------------------------------------------
			   IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
				  return(.f.)
			   ENDIF


  		SELECT CU_CONTRSTUDI
  		SKIP +1

  		
	ENDDO
	


RETURN



***********************************************************************************
*      ELABORAZIONE MENSILE CEDOLINI PAGA ZUCCHETTI
***********************************************************************************
PROCEDURE ELABORA_CEDOLINI_PAGA_ZUCCHETTI
***********************************************************************************

PARAMETERS _PERCORSO_E_NOMEFILE,_ANNOMESE,_AGG_CONTRSTUDI,_AGG_ATTIVEXCED,_DIR_MOVEFILE

IF PARAMETERS() < 2
	MESSAGEBOX("Nessun parametro passato",16,"Attenzione")
	RETURN
ENDIF

IF TYPE("_AGG_CONTRSTUDI") == "U"
	_AGG_CONTRSTUDI = .F.
ENDIF
IF TYPE("_AGG_ATTIVEXCED") == "U"
	_AGG_ATTIVEXCED = .F.
ENDIF

IF TYPE("_DIR_MOVEFILE") == "U"
	_DIR_MOVEFILE = ""
ENDIF


*!*	*!*	SER-XILOPAN
*!*	*!*	################################### DBASE TEMPORANEO PER CODIFICHE XILOPAN #############################################
*!*	CREATE CURSOR CU_XILOPAN ;
*!*	       (CODICEDIP C(14), NOMEDIP C(50))
*!*	INDEX ON CODICEDIP TAG I_CODICEDIP   
*!*	*!*	################################### DBASE TEMPORANEO PER CODIFICHE XILOPAN #############################################



*!*	################################### DEFINIZIONE DELLE VARIABILI #############################################

RELEASE KEY_PREC
PUBLIC KEY_PREC

KEY_PREC	= ""

RELEASE __scarta_cedolino
PUBLIC __scarta_cedolino 
__scarta_cedolino = .F.


RELEASE __ANNO_UTENTE,__MESE_UTENTE
PUBLIC __ANNO_UTENTE,__MESE_UTENTE
__ANNO_UTENTE = SUBSTR(_ANNOMESE,1,4)
__MESE_UTENTE = SUBSTR(_ANNOMESE,6,2)



RELEASE _DESMESE
PUBLIC _DESMESE
_DESMESE  = ""


RELEASE M.CED_CODCLI,M.CED_DESCLI
PUBLIC M.CED_CODCLI,M.CED_DESCLI
M.CED_CODCLI  	= ""
M.CED_DESCLI  	= ""


RELEASE M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 
PUBLIC M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 

M.TAGGANCIO = ""
M.DAGGANCIO = ""
M.DAGGANCIO_DD = ""
M.DAGGANCIO_DL = ""

RELEASE MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
PUBLIC MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
MESE_CEDOLINO_PAGA_ZUCCHETTI = ""
ANNO_CEDOLINO_PAGA_ZUCCHETTI = ""


RELEASE __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
PUBLIC __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
__PATH__ 	= ""
CONTA_CEDOLINI  = 0
_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA = .F.


RELEASE ___VERIFICHE_INCROCIATE_ZUCCHETTI
PUBLIC ___VERIFICHE_INCROCIATE_ZUCCHETTI
___VERIFICHE_INCROCIATE_ZUCCHETTI = .T.


RELEASE _NUMERO_CEDOLINI_DINAMICI
PUBLIC _NUMERO_CEDOLINI_DINAMICI
_NUMERO_CEDOLINI_DINAMICI = 0


RELEASE _NUM_CEDOLINI_RICALCOLATO
PUBLIC _NUM_CEDOLINI_RICALCOLATO
_NUM_CEDOLINI_RICALCOLATO = 0

RELEASE _PREZZO_COSTO_ATTIVITA,_PREZZO_RICAVO_ATTIVITA
PUBLIC _PREZZO_COSTO_ATTIVITA,_PREZZO_RICAVO_ATTIVITA
_PREZZO_COSTO_ATTIVITA	= 0
_PREZZO_RICAVO_ATTIVITA	= 0


RELEASE _NUMERO_CEDOLINI_TFR,_NUMERO_CEDOLINI_ANTICIPO_TFR
PUBLIC _NUMERO_CEDOLINI_TFR,_NUMERO_CEDOLINI_ANTICIPO_TFR
_NUMERO_CEDOLINI_TFR			= 0
_NUMERO_CEDOLINI_ANTICIPO_TFR	= 0

*!*	################################### APERTURA TABELLE DI SUPPORTO #############################################

* -->> Creazione cursore vuoto per caricare i cedolini zucchetti
* --------------------------------------------------------------
CREATE CURSOR CED_ZUCCHETTI (RIGA C(250))
        
 
* -->> Creazione cursore vuoto di elaborazioni mensili
* ----------------------------------------------------
IF USED("CU_ELAB_MENS")
  SELECT CU_ELAB_MENS
  USE
ENDIF
IF !ExecCommand("select * from ELAB_MENS where 0=1","CU_ELAB_MENS")
  return(.f.)
ENDIF
SELECT CU_ELAB_MENS
INDEX ON CODCLI_AQUARIUS TAG I_CODCLI 
SET ORDER TO I_CODCLI  


IF USED("DYN_CONTRST_DL")
  SELECT DYN_CONTRST_DL
  USE
ENDIF

* -->> Creazione cursore vuoto di dettaglio contratto III livello
* ---------------------------------------------------------------
IF !ExecCommand("select * from CONTRST_DL where 0=1","DYN_CONTRST_DL")
  return(.f.)
ENDIF
SELECT DYN_CONTRST_DL
INDEX ON TIPO_ELAB + AAAAMM TAG I_AAAAMM
SET ORDER TO I_AAAAMM

     
        
        
* -->> Creazione cursore vuoto di testata cedolino I livello
* -----------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI where 0=1","CU_CEDOLINI")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI
INDEX ON CED_CODCLI TAG I_CODCLI 
SET ORDER TO I_CODCLI 


* -->> Creazione cursore vuoto di dettaglio cedolino II livello
* --------------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI_DD where 0=1","CU_CEDOLINI_DD")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI_DD
INDEX ON DAGGANCIO TAG I_DAGGA  
INDEX ON AAAA + MM TAG I_AAAAMM  
SET ORDER TO I_AAAAMM


* -->> Creazione cursore vuoto di dettaglio cedolino III livello
* ---------------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI_DL where 0=1","CU_CEDOLINI_DL")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI_DL
INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE 
SET ORDER TO I_NOMDIP 


* -->> Creazione cursore vuoto per caricare il terzo livello
* --------------------------------------------------------------
CREATE CURSOR CURS_CEDOLINI_DL ;
       (KEY_DIP C(100),    DAGGANCIO_DD C(10),   CED_CODCLI C(10),      CED_NOMDIP C(50),   CED_CODCON C(3),   CED_TIPOCO C(25),     ;
        Annotazioni C(250))
INDEX ON KEY_DIP 				TAG I_KEYDIP ADDITIVE
INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE
SET ORDER TO I_KEYDIP 


_ANNO__    = SUBSTR(_ANNOMESE,1,4)
_MESE__    = SUBSTR(_ANNOMESE,6,2)

*!*	################################### CANCELLA LE ATTIVITA' EXTRA CEDOLINO DEL MESE #############################################

*!*	sospeso sergio !!!!!!!!!!!!!!
*!*	*!*	AGGIORNAMENTO TABELLA ATTIVEXCED
*!*	*!*	CANCELLA RECORD PRECEDENTI

*!*	__ANNOMESE__  = _ANNO__ + "/" + _MESE__    

*!*	x_cond       = "AAAAMM = '" + __ANNOMESE__ + "'"
*!*	cSql   = "delete from ATTIVEXCED where " + x_cond 
*!*	IF !ExecCommand(cSql,"ATTIVEXCED")
*!*	   return(.f.)
*!*	ENDIF




*!*	################################### ELABORAZIONE CLIENTI ZUCCHETTI #############################################



*!*	CREA IL CURSORE DELLE ELABORAZIONI DEL MESE PER I SOLI CLIENTI ZUCCHETTI
___AZIENDE_ZUCCHETTI___  = ""
x_cond = "codcli_zucchetti <> '" + ___AZIENDE_ZUCCHETTI___ + "'"
cSql = "select * from u_cli_ex where " + x_cond + " order by codcli_zucchetti"
 
IF !ExecCommand(cSql,"cu_aziende_zucchetti")
  return(.f.)
ENDIF



SELECT CU_AZIENDE_ZUCCHETTI
GO TOP
DO WHILE .NOT. EOF()


	SELECT CU_AZIENDE_ZUCCHETTI
	SCATTER MEMVAR MEMO
	
	
	
	SELECT CU_ELAB_MENS	
	APPEND BLANK
	
    REPLACE TIPO_ELAB 			WITH "ZUCCHETTI"
    REPLACE AAAAMM 				WITH _ANNOMESE
    REPLACE CODCLI_AQUARIUS 	WITH M.CODCLI_AQUARIUS 
    REPLACE RAGSOC_AQUARIUS 	WITH M.RAGSOC_AQUARIUS 
	REPLACE ELAB_FATTA  		WITH .F. 		


	SELECT CU_AZIENDE_ZUCCHETTI
	SKIP +1

ENDDO




*!*	################################### ELABORAZIONE CEDOLINI PAGA #############################################


_TOT_CEDOLINI_ZUCCHETTI = 0
_TOT_CLIENTI = 0



GG_FILE = _PERCORSO_E_NOMEFILE
SELECT CED_ZUCCHETTI
_COMANDO = "APPEND FROM '" + GG_FILE + "' SDF"
&_COMANDO



___VERIFICHE_INCROCIATE_ZUCCHETTI = .T.
=CONTROLLI_INCROCIATI_SUL_CEDOLINO_ZUCCHETTI()
IF !___VERIFICHE_INCROCIATE_ZUCCHETTI
	RETURN
ENDIF

RELEASE ___TFR_ZUCCHETTI,___ANTICIPO_TFR_ZUCCHETTI,___COCOPRO_ZUCCHETTI,___BORSISTI_ZUCCHETTI,___CEDOLINI_PARTICOLARI_ZUCCHETTI  
PUBLIC ___TFR_ZUCCHETTI,___ANTICIPO_TFR_ZUCCHETTI,___COCOPRO_ZUCCHETTI,___BORSISTI_ZUCCHETTI,___CEDOLINI_PARTICOLARI_ZUCCHETTI  
___TFR_ZUCCHETTI 		 			= .F.
___ANTICIPO_TFR_ZUCCHETTI 			= .F.
___COCOPRO_ZUCCHETTI 				= .F.
___BORSISTI_ZUCCHETTI 				= .F.
___CEDOLINI_PARTICOLARI_ZUCCHETTI  	= .F.


SELECT CED_ZUCCHETTI
GO TOP
KEY_PREC	= ""
 

DO WHILE .NOT. EOF()

	IF EOF()
		EXIT
	ENDIF
	


	SCATTER MEMVAR MEMO
	
	___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,80)))    
 	___WORD_RIDOTTA___ = SUBSTR(APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,80))),1,11)   
        
	
	IF EMPTY(___WORD___)			&& VERIFICA SE E' STATO TROVATO IL CLIENTE STUDIO
		SELECT CED_ZUCCHETTI
		SKIP +1
		LOOP
	ENDIF


	*!*	RICERCA CODICE CLIENTE AQUARIUS PASSANDO DAL CODICE CLIENTE ZUCCHETTI

  	x_cond = "codcli_zucchetti = '" + ___WORD___ + "'"
  	cSql = "select * from u_cli_ex where " + x_cond + " order by codcli_zucchetti"
 
  	IF !ExecCommand(cSql,"curs_cli_ex")
	  	return(.f.)
  	ENDIF

  	SELECT curs_cli_ex 
  	IF reccount() = 0				&& VERIFICA SE E' STATO TROVATO IL CLIENTE STUDIO
  	
  	    ** RIPETE L'ACCESSO PER KIAVE RIDOTTA (CI SONO CLIENTI CHE HANNO IN CHIAVE L'ACCENTO PER CUI PRENDO SOLO I PRIMI 11 CHR DEL CODICE CHIAVE CHE DEVE CORRISPONDERE IN U_CLI_EX)
	  	x_cond = "codcli_zucchetti = '" + ___WORD_RIDOTTA___ + "'"
	  	cSql = "select * from u_cli_ex where " + x_cond + " order by codcli_zucchetti"
	 
	  	IF !ExecCommand(cSql,"curs_cli_ex")
		  	return(.f.)
	  	ENDIF
  	
   		IF reccount() = 0				&& VERIFICA SE E' STATO TROVATO IL CLIENTE STUDIO
 			SELECT CED_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF
  	
  	ENDIF


    *!*	CONTROAGGIORNA LA TABELLA ELAB_MENS CON : CLIENTE IN ELABORAZIONE !!!!!

    SELECT CU_ELAB_MENS
    SET ORDER TO I_CODCLI  
   
    V_SEEK  	= CURS_CLI_EX.CODCLI_AQUARIUS
   
    SEEK V_SEEK  
    IF FOUND()
         REPLACE ELAB_FATTA WITH .T.
    ENDIF

	*!*	IF ___WORD___  = "COTRAI0101CO.TRA.IN.A. CONSORZIO INTERAZIENDALE"
	*!*		SET STEP ON 
	*!*	ENDIF

	
  	SELECT curs_cli_ex 
  	IF ALLTRIM(KEY_PREC) <> ALLTRIM(CODCLI_AQUARIUS)

  		IF !EMPTY(KEY_PREC)
  			=FUNZIONI_A_ROTTURA_CLIENTE_STUDIO_ZUCCHETTI()
  			SELECT curs_cli_ex 
  			KEY_PREC  	= CODCLI_AQUARIUS
		ELSE
			SELECT curs_cli_ex 
			KEY_PREC  	= CODCLI_AQUARIUS
		ENDIF

	ENDIF
  	
  	
	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################
	    SELECT CED_ZUCCHETTI
  		
  		=DETERMINA_DATI_CLIENTE_STUDIO_ZUCCHETTI()
  		
  	    =CERCA_MESE_CEDOLINO_ZUCCHETTI()
	  	IF VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) > 0 AND VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) < 13
	  	ELSE
	  		   =MESSAGEB("FILE CEDOLINI PAGA ZUCCHETTI NON CORRETTI ?? : INTERROMPO L'ELABORAZIONE",16,"*** ATTENZIONE ***")
	  		   SET DEFA TO &PUB_DIR
	  		   RETURN
	  	ENDIF
	  	
	  	PERI = MESE_CEDOLINO_PAGA_ZUCCHETTI +'-'+ ANNO_CEDOLINO_PAGA_ZUCCHETTI
	  	IF VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) == VAL(SUBSTR(_ANNOMESE,6,2)) .AND. VAL(ANNO_CEDOLINO_PAGA_ZUCCHETTI) == VAL(SUBSTR(_ANNOMESE,1,4))
	  	ELSE
			MESSAGEBOX("Verificare che il mese selezionato corrisponda a quello dei cedolini contenuti nel file selezionato cliente :" + ALLTRIM(M.CED_DESCLI) + CHR(13) + CHR(13) + ;
				"Periodo errato: "+PERI ,48,"Attenzione")
			RETURN
	  	ENDIF
	  	
	  	
		__SCARTA_CEDOLINO = .F.
		=SCARTA_CEDOLINO()
		IF __SCARTA_CEDOLINO 
	 		SELECT CED_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF

	  	
	  	=ELABORA_RISORSA_CEDOLINO_ZUCCHETTI()
	  	
	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################


	SELECT CED_ZUCCHETTI
	SKIP +1
	
ENDDO


=FUNZIONI_A_ROTTURA_CLIENTE_STUDIO_ZUCCHETTI()


* -->> Creazione cursore vuoto per caricare i cedolini zucchetti
* --------------------------------------------------------------
CREATE CURSOR CED_ZUCCHETTI (RIGA C(250))

  
* -->> Creazione cursore vuoto per caricare il terzo livello
* --------------------------------------------------------------
CREATE CURSOR CURS_CEDOLINI_DL ;
       (KEY_DIP C(100),    DAGGANCIO_DD C(10),   CED_CODCLI C(10),      CED_NOMDIP C(50),   CED_CODCON C(3),   CED_TIPOCO C(25),     ;
        Annotazioni C(250))
INDEX ON KEY_DIP 				TAG I_KEYDIP ADDITIVE
INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE
SET ORDER TO I_KEYDIP 



*!*	################################### AGGIORNA TABELLE CEDOLINI PAGA  #############################################


**=> ERASMO - INIZIO 21/07/2010
*** SALVATAGGIO CEDOLINI NELLA DIRECTORY MESE IN ELABORAZIONE

IF _V_OPZ_SPOSTAFILE
	IF !EMPTY(_DIR_MOVEFILE) .AND. DIRECTORY(_DIR_MOVEFILE,1)
		
		IF RIGHT(_DIR_MOVEFILE,1) == "\"
		ELSE
			_DIR_MOVEFILE = _DIR_MOVEFILE + "\"
		ENDIF
		_FILE_DI_ARRIVO = _DIR_MOVEFILE + JUSTFNAME(GG_FILE)
		
	  	WAIT WINDOWS "SPOSTAMENTO FILE CEDOLINI ZUCCHETTI ELABORATO: " + GG_FILE NOWAIT
	  	
	    _COMANDO = "COPY FILE '" + GG_FILE + "' TO '" + _FILE_DI_ARRIVO + "'"
		&_COMANDO 
		
	    _COMANDO = "ERASE '" + GG_FILE + "'"
		&_COMANDO 
	  	
	  	WAIT CLEAR
	  	
	ENDIF
ENDIF 
**=> ERASMO - FINE 21/07/2010





RELEASE FLAG_STAMPA,FLAG_PREVIEW,W_STATO
PUBLIC  FLAG_STAMPA,FLAG_PREVIEW,W_STATO


FLAG_STAMPA = .F.
FLAG_PREVIEW= .T.



SELECT CU_ELAB_MENS
SET FILTER TO ELAB_FATTA = .f.
GO TOP



W_STATO = "Clienti NON elaborati con la procedura ZUCCHETTI--- Mensilità"

IF _V_OPZ_ELAB_13_ZUCCHETTI
	W_STATO = "Clienti NON elaborati con la procedura ZUCCHETTI --- Tredicesima Mensilità"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	W_STATO = "Clienti NON elaborati con la procedura ZUCCHETTI --- Quattordicesima Mensilità"
ENDIF




DO PRG\MENUSTA WITH "CU_ELAB_MENS",FLAG_PREVIEW,FLAG_STAMPA,"XXX","ELAB_MENS","ELAB_MENS.FRX" && ELENCO AZIENDE ZUCCHETTI NON ELABORATE
SET FILTER TO 


SELECT CU_ELAB_MENS
SET FILTER TO ELAB_FATTA = .t.
GO TOP

W_STATO = "Clienti elaborati con la procedura ZUCCHETTI--- Mensilità"

IF _V_OPZ_ELAB_13_ZUCCHETTI
	W_STATO = "Clienti elaborati con la procedura ZUCCHETTI --- Tredicesima Mensilità"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	W_STATO = "Clienti elaborati con la procedura ZUCCHETTI --- Quattordicesima Mensilità"
ENDIF




DO PRG\MENUSTA WITH "CU_ELAB_MENS",FLAG_PREVIEW,FLAG_STAMPA,"XXX","ELAB_MENS","ELAB_MENS.FRX" && ELENCO AZIENDE ZUCCHETTI NON ELABORATE


SELECT CU_ELAB_MENS
SET FILTER TO ELAB_FATTA = .t.
GO TOP


*!*	AGGIORNAMENTO TABELLA ELAB_MENS
*!*	CANCELLA RECORD PRECEDENTI
_TIPOELAB    = "ZUCCHETTI"
x_aamm       = "AAAAMM = '" + _ANNOMESE + "'"
x_tipo_elab  = "TIPO_ELAB = '" + _TIPOELAB + "'"
x_cond       = x_aamm + " and " + x_tipo_elab  
cSql   = "delete from ELAB_MENS where " + x_cond 
IF !ExecCommand(cSql,"ELAB_MENS")
   return(.f.)
ENDIF



*!*	AGGIORNA LA TABELLA DELLE ELABORAZIONI MENSILI RICARICANDOLA
  
IF !ExecRW('','ELAB_MENS','I','','CU_ELAB_MENS')
 return(.f.)
ENDIF


SET DEFA TO &PUB_DIR


*!*	*!*	SER-XILOPAN CREA IL DB SUPPORTO XILOPAN
*!*	SELECT 1
*!*	USE XILOPAN

*!*	SELECT CU_XILOPAN 
*!*	GO TOP
*!*	BROWSE NORMAL

*!*	DO WHILE .NOT. EOF()


*!*		SELECT CU_XILOPAN 
*!*		SCATTER MEMVAR MEMO
*!*		
*!*		SELECT XILOPAN 
*!*		APPEND BLANK
*!*		GATHER MEMVAR MEMO


*!*		SELECT CU_XILOPAN 
*!*		SKIP +1
*!*		
*!*	ENDDO
*!*	*!*	SER-XILOPAN


RETURN




***********************************************************************************
*      CREAZIONE DEI CURSORI A LIVELLO DI CLIENTE STUDIO
***********************************************************************************
FUNCTION FUNZIONI_A_ROTTURA_CLIENTE_STUDIO_ZUCCHETTI
AABBSS__    = SELECT()

	IF EMPTY(ALLTRIM(M.CED_CODCLI))
		SELECT(AABBSS__)
		RETURN .F.
	ENDIF

	WAIT WINDOWS "CLIENTE STUDIO ZUCCHETTI IN ELABORAZIONE : "+ALLTRIM(M.CED_DESCLI) NOWAIT

	=CREA_CURSORE_DATI_CLIENTE_STUDIO_ZUCCHETTI()
	=CANCELLA_ELABORAZIONI_PRECEDENTI_ZUCCHETTI()
	=IMPOSTA_DAGGANCIO_DD_CURSORE_CEDOLINO_DL_ZUCCHETTI()
	=CREA_CURSORE_DATI_MESE_ELABORAZIONE_ZUCCHETTI()	


	*!*	AGGIORNAMENTO TABELLE CEDOLINI
	* -------------------------------- 

   	IF !ExecRW('','CEDOLINI','I','','CU_CEDOLINI')		&& INSERISCE LA TABELLA CEDOLINO PER LA PRIMA VOLTA
	   return(.f.)
   	ENDIF
	
   	IF !ExecRW('','CEDOLINI_DD','I','','CU_CEDOLINI_DD')
	   return(.f.)
   	ENDIF

   	IF !ExecRW('','CEDOLINI_DL','I','','CU_CEDOLINI_DL')
	   return(.f.)
   	ENDIF
   	


   	
	**=> ERASMO - INIZIO 13/07/2010
	IF _AGG_CONTRSTUDI
		
		WAIT WINDOWS "Aggiornamento dettagli contratti in corso..." NOWAIT

		RELEASE _NUMERO_CEDOLINI 
		PUBLIC _NUMERO_CEDOLINI 
		_NUMERO_CEDOLINI = 0
				
		
		SELECT CU_CEDOLINI_DD
		GO TOP
		_NUMERO_CEDOLINI = NUM_CEDOLINI			&& NUMERO CEDOLINI TOTALE DEL MESE PER OGNI ATTIVITA' COMPRENSIVO DEI RECORD DINAMICI DEI CONTRATTI STUDIO
		
		
	    SELECT CU_ELAB_MENS
	    SET ORDER TO I_CODCLI  
	    V_SEEK  	= CU_CEDOLINI_DD.CED_CODCLI
	   
	    SEEK V_SEEK  
	    IF FOUND()
	         REPLACE NUM_CEDOLINI WITH _NUMERO_CEDOLINI 
        ENDIF
		
		
		_FLAG_ATTRIBUZIONE_DAGGANCIO_PER_DETTAGLI_DINAMICI  = .F.
	
			
		SELECT CU_CEDOLINI_DD
		GO TOP
		SCAN
		
			_NUM_CEDOLINI = NUM_CEDOLINI
			__CED_CODCLI = ALLTRIM(CED_CODCLI)			
			x_clie = "contrstudi.CODCLI = '" + ALLTRIM(CED_CODCLI) + "'"	
			x_aamm = "contrst_dl.AAAAMM = '" + ALLTRIM(AAAA) + "/" + ALLTRIM(MM) + "'"
			x_unim = "contrst_dl.UMRICAVO = 'NR'"	
			x_cond = x_clie + " and " + x_aamm + " and " + x_unim
			Csql =  "select codcli,ragsoc,codattiv,desattiv,numero,data,taggancio,* from contrst_dl " + ;
					"left outer join contrst_dd on contrst_dd.daggancio = contrst_dl.daggancio and contrst_dd.idattivita = contrst_dl.idattivita " + ;
					"left outer join contrstudi on contrstudi.taggancio = contrst_dl.daggancio where " + x_cond + "order by codcli,codattiv "
			IF !ExecCommand(cSql,'CX_CONTRST_DL')
			   return(.f.)
			ENDIF
			
			
			*!*	CONTA I RECORD DINAMICI INSERITI SUL DATABASE (SONO SOLO CREATI NELL'ATTIVITA' 00001



			_PREZZO_COSTO_ATTIVITA		= 0
			_PREZZO_RICAVO_ATTIVITA		= 0
			

			SELECT CX_CONTRST_DL					&& SOLO PER L'ATTIVITA 00001 CREA I RECORD DINAMICI
			GO TOP
			
			DO WHILE .NOT.EOF()
			
				IF TIPO_ELAB = 'M' AND CODATTIV = '00001'
				ELSE
					SELECT CX_CONTRST_DL
					SKIP +1
					LOOP
				ENDIF
				
				_PREZZO_COSTO_ATTIVITA		= PRZCOSTO
				_PREZZO_RICAVO_ATTIVITA		= PRZRICAVO		
				
		    	__DAGGANCIO_PRIMA_ATTIVITA 	= DAGGANCIO
		    	__IDATTIVITA_PRIMA_ATTIVITA = IDATTIVITA
		    	
		    	=CREA_DETTAGLI_DINAMICI()
		    	
		    	EXIT

			ENDDO	

			SELECT CX_CONTRST_DL					&& CONTA I RECORD DINAMICI CREATI DIRETTAMENTE SUL DATABASE (POSSONO ESISTERE ALTRE RECORD DINAMICI CREATI DA ELABORAZIONI PRECEDENTI)
			GO TOP
			_NUMERO_CEDOLINI_DINAMICI 		= 0	
			_NUMERO_CEDOLINI_TFR			= 0
			_NUMERO_CEDOLINI_ANTICIPO_TFR	= 0
			DO WHILE .NOT.EOF()
				
				SELECT CX_CONTRST_DL
				=CONTA_CEDOLINI_DINAMICI()			&& CONTA I RECORD DINAMICI INSERITI SUL DATABASE (SIA I RECORD INSERITI IN QUESTA ELABORAZIONE CHE NELLE PRECEDENTI)
				IF _NUMERO_CEDOLINI_DINAMICI > 0
					EXIT
				ENDIF
				
				SELECT CX_CONTRST_DL
				SKIP +1
				
			ENDDO							


			
			SELECT CX_CONTRST_DL
			GO TOP
			DO WHILE .NOT.EOF()
				
			    _NUM_CEDOLINI_RICALCOLATO = 0 					   		&& RICALCOLA TOTALE CEDOLINO 
			    =RAGGRUPPA_CEDOLINI_DD_PER_CLIENTE_AAAA_MM_ZUCCHETTI()
				SELECT CX_CONTRST_DL
			    IF CODATTIV = '00001'
			    	NUOVO_NUMERO_CEDOLINI = (_NUM_CEDOLINI_RICALCOLATO  - _NUMERO_CEDOLINI_DINAMICI)	
			    ELSE
			    	NUOVO_NUMERO_CEDOLINI = (_NUM_CEDOLINI_RICALCOLATO  - (_NUMERO_CEDOLINI_ANTICIPO_TFR + _NUMERO_CEDOLINI_ANTICIPO_TFR)) 					    	
			    ENDIF	

						
				x_codi = "IDATTIVITA = '" + IDATTIVITA + "'"			&& CONTROAGGIORNA LE ATTIVITA' DEL CONTRATTO CON IL NUMERO DEL CEDOLINO RICALCOLATO
				x_mese = "AAAAMM = '" + AAAAMM + "'"
				__TIPO_ELAB= "M"
				IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
					__TIPO_ELAB= "M"
				ENDIF
				IF _V_OPZ_ELAB_13_ZUCCHETTI
					__TIPO_ELAB= "T"
				ENDIF
				IF _V_OPZ_ELAB_14_ZUCCHETTI
					__TIPO_ELAB= "Q"
				ENDIF
				x_te = "tipo_elab = '" + __TIPO_ELAB + "'"				
				x_cond = x_codi + " and " + x_mese + " and " + x_te				


				Csql = "select * from CONTRST_DL where " + x_cond
				IF !ExecRW(cSql,"CONTRST_DL","R")
				   return(.f.)
				ENDIF
				IF !EOF()
				    SELECT CONTRST_DL	
					REPLACE QTARICAVO WITH NUOVO_NUMERO_CEDOLINI   && CONTIENE IL TOTALE DEI CEDOLINI MENSILI+COCOPRO+BORSISTI ...... ESCLUSO TREDICESIMA E QUATTORDICESIMA
					REPLACE QTACOSTO  WITH NUOVO_NUMERO_CEDOLINI   && CONTIENE IL TOTALE DEI CEDOLINI MENSILI+COCOPRO+BORSISTI ...... ESCLUSO TREDICESIMA E QUATTORDICESIMA
				ENDIF
				IF !ExecRW(cSql,"CONTRST_DL","W")
				   return(.f.)
				ENDIF
			
			
				SELECT CX_CONTRST_DL
				SKIP +1
				
			ENDDO							

			
	
		
			SELECT DISTINCT NUMERO,DATA,TAGGANCIO FROM CX_CONTRST_DL INTO CURSOR TMP_CONTRATTI
			
			SELECT TMP_CONTRATTI
			GO TOP
			SCAN
			
			   WAIT WINDOWS "Aggiornamento contratto n° " + ALLTRIM(NUMERO) + " del " + RIBALTA2(DATA) NOWAIT
			   
			   *!*	ACCEDE AL II LIVELLO PER ELABORARE OGNI SINGOLA ATTIVITA'
			
			   x_codi = "DAGGANCIO = '" + TAGGANCIO + "'"
			   x_cond = x_codi
			   cSql = "select * from CONTRST_DD where " + x_cond
			   IF !ExecCommand(cSql,"CU_CONTRST_DD")
				  return(.f.)
			   ENDIF
			   SELECT CU_CONTRST_DD
			   GO TOP
			   SCAN

					*!*	ACCEDE AL III LIVELLO PER ELABORARE I MESI PREVISTI ED EFFETTUA IL CALCOLO COSTI/RICAVI/UTILI
					x_codi = "DAGGANCIO = '" + DAGGANCIO + "'"
					x_atti = "IDATTIVITA = '" + IDATTIVITA + "'" 
					x_cond = x_codi + " and " + x_atti
					cSql = "select * from CONTRST_DL where " + x_cond
					IF !ExecCommand(cSql,"CU_CONTRST_DL")
					  return(.f.)
					ENDIF

					
					VSP_VAL_COSTO  = 0
					VSP_VAL_RICAVO = 0
					VSP_VAL_UTILE  = 0
					
					
					DO CALCOLO_TOTALE_DELLA_ATTIVITA_CORRENTE  WITH "CU_CONTRST_DL",.T.
					
					*!*	AGGIORNA IL DATA BASE DELLE ATTIVITA' A III LIVELLO
					IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
						return(.f.)
					ENDIF

					SELECT CU_CONTRST_DD	&& aggiorna il totale calcolato della attività corrente sul cursore tabella attività di II livello
					
					REPLACE ValCosto 	WITH VSP_VAL_COSTO
					REPLACE ValRicavo 	WITH VSP_VAL_RICAVO
					REPLACE ValUtile 	WITH VSP_VAL_UTILE


			   ENDSCAN


			   *!*	AGGIORNA IL DATA BASE DELLE ATTIVITA' A II LIVELLO
			   
			   IF !ExecRW('','CONTRST_DD','I','','CU_CONTRST_DD')
				   return(.f.)
			   ENDIF
			
			ENDSCAN
			
		ENDSCAN
		
	ENDIF
	**=> ERASMO - FINE 13/07/2010


  	


    _TOT_CLIENTI = _TOT_CLIENTI + 1
	        
	* -->> Creazione cursore vuoto di testata cedolino I livello
	* -----------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI where 0=1","CU_CEDOLINI")
	  return(.f.)
	ENDIF
	SELECT CU_CEDOLINI
	INDEX ON CED_CODCLI TAG I_CODCLI 
	SET ORDER TO I_CODCLI 


	* -->> Creazione cursore vuoto di dettaglio cedolino II livello
	* --------------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI_DD where 0=1","CU_CEDOLINI_DD")
	  return(.f.)
	ENDIF
	SELECT CU_CEDOLINI_DD
	INDEX ON DAGGANCIO TAG I_DAGGA  
	INDEX ON AAAA + MM TAG I_AAAAMM  
	SET ORDER TO I_AAAAMM


	* -->> Creazione cursore vuoto di dettaglio cedolino III livello
	* ---------------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI_DL where 0=1","CU_CEDOLINI_DL")
	  return(.f.)
	ENDIF
	SELECT CU_CEDOLINI_DL
	INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
	INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
	INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE 
	SET ORDER TO I_NOMDIP 



	* -->> Creazione cursore vuoto per caricare il terzo livello
	* --------------------------------------------------------------
	CREATE CURSOR CURS_CEDOLINI_DL ;
	       (KEY_DIP C(100),    DAGGANCIO_DD C(10),   CED_CODCLI C(10),      CED_NOMDIP C(50),   CED_CODCON C(3),   CED_TIPOCO C(25),     ;
	        Annotazioni C(250))
	INDEX ON KEY_DIP 				TAG I_KEYDIP ADDITIVE
	INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
	INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
	INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE
	SET ORDER TO I_KEYDIP 


	IF USED("DYN_CONTRST_DL")
	  SELECT DYN_CONTRST_DL
	  USE
	ENDIF

	* -->> Creazione cursore vuoto di dettaglio contratto III livello
	* ---------------------------------------------------------------
	IF !ExecCommand("select * from CONTRST_DL where 0=1","DYN_CONTRST_DL")
	  return(.f.)
	ENDIF
	SELECT DYN_CONTRST_DL
	INDEX ON TIPO_ELAB + AAAAMM TAG I_AAAAMM
	SET ORDER TO I_AAAAMM



	* -->> REIMPOSTA LE VARIABILI PER RIGHE DINAMICHE SUI CONTRATTI
	* -------------------------------------------------------------

	___ANTICIPO_TFR_ZUCCHETTI 			= .F.
	___TFR_ZUCCHETTI 			 		= .F.
	___COCOPRO_ZUCCHETTI 				= .F.
	___BORSISTI_ZUCCHETTI 				= .F.
	___CEDOLINI_PARTICOLARI_ZUCCHETTI  	= .F.


SELECT(AABBSS__)

RETURN


********************************
FUNCTION CONTA_CEDOLINI_DINAMICI
********************************


SELECT CX_CONTRST_DL
XSS__      = SELECT()
__SISI_QUI = RECNO()

__K_CODCLI     = CODCLI
__K_DAGGANCIO  = DAGGANCIO
__K_IDATTIVITA = IDATTIVITA
__K_AAAAMM     = AAAAMM

*********************************************DYN**
** TIPO_ELAB = M - MENSILITA				*
** TIPO_ELAB = T - TREDICESIMA				*
** TIPO_ELAB = Q - QUATTORDICESIMA			*
** TIPO_ELAB = A - ANTICIPO TFR				* SI
** TIPO_ELAB = F - TFR						* SI
** TIPO_ELAB = C - CO.CO.CO					* SI
** TIPO_ELAB = B - BORSISTI					* SI
** TIPO_ELAB = 1 - AZIENDE DISTACCATE		* SI ** TIPO ELAB:1 **   5,00** Intercetta cedolini particolari zucchetti   
** TIPO_ELAB = 2 - AGENZIA SOMMINISTRAZIONE	* SI ** TIPO ELAB:2 **   6,00** Intercetta cedolini particolari zucchetti   
** TIPO_ELAB = 3 -  						* SI * TABELLA ICP INTERCETTA CEDOLINI PARTICOLARI
** TIPO_ELAB = 4 -  						* SI * TABELLA ICP INTERCETTA CEDOLINI PARTICOLARI
** TIPO_ELAB = 5 -  						* SI * TABELLA ICP INTERCETTA CEDOLINI PARTICOLARI
** TIPO_ELAB = 6 -  						* SI * TABELLA ICP INTERCETTA CEDOLINI PARTICOLARI
** TIPO_ELAB = 7 -  						* SI * TABELLA ICP INTERCETTA CEDOLINI PARTICOLARI
** TIPO_ELAB = 8 -  						* SI * TABELLA ICP INTERCETTA CEDOLINI PARTICOLARI
** TIPO_ELAB = 9 -  						* SI * TABELLA ICP INTERCETTA CEDOLINI PARTICOLARI
*********************************************DYN**



__campi__="daggancio,idattivita"
__somma__=", sum(qtaricavo) as qta_dyn"
__condi__="daggancio = ?__K_DAGGANCIO  and idattivita = ?__K_IDATTIVITA  and tipo_elab = 'F' and aaaamm = ?__K_AAAAMM"  
__orderby__=" daggancio,idattivita"

cSql="SELECT "+__campi__+__somma__+" FROM CONTRST_DL WHERE " + __condi__ +  ;
    					                          " group by "+__campi__+" order by "+__orderby__
IF !ExecCommand(cSql,"DYTFR_CONTRST_DL")
   return(.f.)
ENDIF

SELECT DYTFR_CONTRST_DL
_NUMERO_CEDOLINI_TFR	= _NUMERO_CEDOLINI_TFR + QTA_DYN


__campi__="daggancio,idattivita"
__somma__=", sum(qtaricavo) as qta_dyn"
__condi__="daggancio = ?__K_DAGGANCIO  and idattivita = ?__K_IDATTIVITA  and tipo_elab = 'A' and aaaamm = ?__K_AAAAMM"  
__orderby__=" daggancio,idattivita"

cSql="SELECT "+__campi__+__somma__+" FROM CONTRST_DL WHERE " + __condi__ +  ;
    					                          " group by "+__campi__+" order by "+__orderby__
IF !ExecCommand(cSql,"DYATFR_CONTRST_DL")
   return(.f.)
ENDIF

SELECT DYATFR_CONTRST_DL
_NUMERO_CEDOLINI_ANTICIPO_TFR 	= _NUMERO_CEDOLINI_ANTICIPO_TFR + QTA_DYN



__campi__="daggancio,idattivita"
__somma__=", sum(qtaricavo) as qta_dyn"
__condi__="daggancio = ?__K_DAGGANCIO  and idattivita = ?__K_IDATTIVITA  and tipo_elab <> 'M' and tipo_elab <> 'T' and tipo_elab <> 'Q' and aaaamm = ?__K_AAAAMM"  
__orderby__=" daggancio,idattivita"

cSql="SELECT "+__campi__+__somma__+" FROM CONTRST_DL WHERE " + __condi__ +  ;
    					                          " group by "+__campi__+" order by "+__orderby__
IF !ExecCommand(cSql,"DYY_CONTRST_DL")
   return(.f.)
ENDIF

SELECT DYY_CONTRST_DL
_NUMERO_CEDOLINI_DINAMICI = _NUMERO_CEDOLINI_DINAMICI  + QTA_DYN


SELECT(XSS__)
GO __SISI_QUI


RETURN


*******************************
FUNCTION CREA_DETTAGLI_DINAMICI
*******************************

_FLAG_ATTRIBUZIONE_DAGGANCIO_PER_DETTAGLI_DINAMICI  = .T.


SELECT DYN_CONTRST_DL
GO TOP
IF EOF()
	RETURN
ENDIF


DO WHILE .NOT.EOF()

	REPLACE DAGGANCIO 		WITH 	__DAGGANCIO_PRIMA_ATTIVITA 
	REPLACE IDATTIVITA		WITH 	__IDATTIVITA_PRIMA_ATTIVITA 

	*!*	 NO FORZATURA PER TFR E ANTICIPO TFR E CEDOLINI PARTICOLARE
	IF TIPO_ELAB = 'F' OR TIPO_ELAB = "A" 	OR TIPO_ELAB = "1" OR TIPO_ELAB = "2" OR TIPO_ELAB = "3" OR TIPO_ELAB = "4" OR TIPO_ELAB = "5" OR TIPO_ELAB = "6" OR TIPO_ELAB = "7" OR TIPO_ELAB = "8" OR TIPO_ELAB = "9" OR TIPO_ELAB = "0" 
	ELSE
		REPLACE PRZCOSTO		WITH	_PREZZO_COSTO_ATTIVITA	
		REPLACE PRZRICAVO		WITH	_PREZZO_RICAVO_ATTIVITA	
	ENDIF

	SELECT DYN_CONTRST_DL
	SKIP +1
	
ENDDO

*!*	** HO TROVATO SICURAMENTE UN DETTAGIO DIMAMICO , CANCELLO I DETTAGLI DINAMICI DELL'ELABORAZIONE PRECEDENTE IN FUNZIONE DEL RECORD DINAMICO TROVATO
Z_dagga = "daggancio = '" + __DAGGANCIO_PRIMA_ATTIVITA  + "'"
Z_idatt = "idattivita = '" + __IDATTIVITA_PRIMA_ATTIVITA  + "'"
Z_cond  = Z_dagga + " and " + Z_idatt 


cSql   = "select * from CONTRST_DL where " + Z_cond 
IF !ExecCommand(cSql,"CV_CONTRST_DL")
   return(.f.)
ENDIF


SELECT CV_CONTRST_DL
GO TOP

DO WHILE .NOT.EOF()

	IF ___ANTICIPO_TFR_ZUCCHETTI 
		IF TIPO_ELAB = 'A'
			DELETE
		ENDIF
	ENDIF
	
	
	IF ___TFR_ZUCCHETTI 	
		IF TIPO_ELAB = 'F'
			DELETE
		ENDIF
	ENDIF

			
	IF ___COCOPRO_ZUCCHETTI 		
		IF TIPO_ELAB = 'C'
			DELETE
		ENDIF
	ENDIF

	IF ___BORSISTI_ZUCCHETTI 		
		IF TIPO_ELAB = 'B'
			DELETE
		ENDIF
	ENDIF


	IF ___CEDOLINI_PARTICOLARI_ZUCCHETTI  
		IF TIPO_ELAB = '1'
			DELETE
		ENDIF
		IF TIPO_ELAB = '2'
			DELETE
		ENDIF
		IF TIPO_ELAB = '3'
			DELETE
		ENDIF
		IF TIPO_ELAB = '4'
			DELETE
		ENDIF
		IF TIPO_ELAB = '5'
			DELETE
		ENDIF
		IF TIPO_ELAB = '6'
			DELETE
		ENDIF
		IF TIPO_ELAB = '7'
			DELETE
		ENDIF
		IF TIPO_ELAB = '8'
			DELETE
		ENDIF
		IF TIPO_ELAB = '9'
			DELETE
		ENDIF
		IF TIPO_ELAB = '0'
			DELETE
		ENDIF
	ENDIF


	
	SELECT CV_CONTRST_DL
	SKIP +1
	
ENDDO


IF !ExecRW('','CONTRST_DL','I','','CV_CONTRST_DL')
   return(.f.)
ENDIF


*!*	AGGIORNAMENTO TABELLE CONTRATTI RIPORTANDO I RECORD DINAMICI RELATIVI A TFR,ANTICIPI,BORSISTI,CO.CO.C0 ......
* ---------------------------------------------------------------------------------------------------------------

IF !ExecRW('','CONTRST_DL','I','','DYN_CONTRST_DL')
   return(.f.)
ENDIF


RETURN


***********************************************************************************
*      IMPOSTA I DATI ANAGRAFICI DEL CLIENTE STUDIO
***********************************************************************************
FUNCTION DETERMINA_DATI_CLIENTE_STUDIO_ZUCCHETTI

AABBSS__    = SELECT()


SELECT curs_cli_ex 

M.CED_CODCLI  	= CODCLI_AQUARIUS
M.CED_DESCLI  	= RAGSOC_AQUARIUS 


SELECT(AABBSS__)

RETURN



***********************************************************************************
*      IMPOSTA I DATI ANAGRAFICI DEL CLIENTE STUDIO
***********************************************************************************
FUNCTION CREA_CURSORE_DATI_CLIENTE_STUDIO_ZUCCHETTI

AABBSS__    = SELECT()



M.TAGGANCIO   	= SYS(2015)
M.DAGGANCIO   	= M.TAGGANCIO

M.DAGGANCIO_DL 	= SYS(2015)
M.DAGGANCIO_DD 	= M.DAGGANCIO_DL

M.ORAINS      	= ""
M.UTENTEINS   	= PUB_CODOPE 
M.DATAINS     	= DTOC(DATE())    


M.NOTE 			= ""		
M.UTENTEMOD 	= ""
M.DATAMOD 		= ""
M.ORAMOD 		= ""



SELECT CU_CEDOLINI
SET ORDER TO I_CODCLI
____SEEK = M.CED_CODCLI
SEEK ____SEEK
IF !FOUND()
	APPEND BLANK
ENDIF

DO CEDOLINI


SELECT(AABBSS__)

RETURN

***********************************************************************************
*      IMPOSTA LEGAME TRA CEDOLINI_DD E CEDOLINI_DL
***********************************************************************************
FUNCTION IMPOSTA_DAGGANCIO_DD_CURSORE_CEDOLINO_DL_ZUCCHETTI
AABBSS__    = SELECT()


SELECT CURS_CEDOLINI_DL
SET ORDER TO I_CODCCL 
GO TOP
DO WHILE .NOT.EOF()

    CONTA_CEDOLINI = CONTA_CEDOLINI + 1
    
    _TOT_CEDOLINI_ZUCCHETTI = _TOT_CEDOLINI_ZUCCHETTI + 1
	    
	SELECT CU_CEDOLINI_DL
	APPEND BLANK

	DO CURS_CEDOLINI_DL
	REPLACE DAGGANCIO_DD 	WITH M.DAGGANCIO_DD 

	SELECT CURS_CEDOLINI_DL
	SKIP +1
	
ENDDO



SELECT(AABBSS__)

RETURN


***********************************************************************************
*      IMPOSTA I DATI MESE ELABORAZIONE
***********************************************************************************
FUNCTION CREA_CURSORE_DATI_MESE_ELABORAZIONE_ZUCCHETTI

AABBSS__    = SELECT()

M.AAAA 			= ANNO_CEDOLINO_PAGA_ZUCCHETTI 
M.MM 			= MESE_CEDOLINO_PAGA_ZUCCHETTI 
M.NUM_CEDOLINI 	= CONTA_CEDOLINI 
M.Annotazioni	= "" 


** SERGIO 21/09/2010
M.TIPO_FATT   = " "
M.TIPO_ELAB	  = "M"
IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	M.TIPO_ELAB	  = "M"
ENDIF
IF _V_OPZ_ELAB_13_ZUCCHETTI
	M.TIPO_ELAB	  = "T"
ENDIF
IF _V_OPZ_ELAB_14_ZUCCHETTI
	M.TIPO_ELAB	  = "Q"
ENDIF



SELECT CU_CEDOLINI_DD
SET ORDER TO I_AAAAMM 
____SEEK = M.AAAA + M.MM
SEEK ____SEEK
IF !FOUND()
	APPEND BLANK
ENDIF


DO CEDOLINI_DD

CONTA_CEDOLINI = 0
M.NUM_CEDOLINI = CONTA_CEDOLINI 

SELECT(AABBSS__)

RETURN

***********************************************************************************
*      CERCA I DATI ANAGRAFICI DELLA RISORSA
***********************************************************************************
** LA PROCEDURA ELABORA LE RISORSE DEL CEDOLINO E INTERPRETA IL TIPO DI CONTRATTO 
FUNCTION ELABORA_RISORSA_CEDOLINO_ZUCCHETTI

RELEASE M.Annotazioni
PUBLIC M.Annotazioni  
M.Annotazioni  = ""

SELECT CED_ZUCCHETTI

AABBSS__    = SELECT()
__SONO_QUI=RECNO()

SKIP +9
__CODIDIP      = ALLTRIM(SUBSTR(RIGA,01,14)) 
M.CED_NOMDIP   = APITOSPA(UPPER(ALLTRIM(SUBSTR(RIGA,15,50))))
M.Annotazioni  = ""

*!*	*!*	SER-XILOPAN
*!*	SELECT CU_XILOPAN 
*!*	SET ORDER TO I_CODICEDIP
*!*	SEEK __CODIDIP
*!*	IF !FOUND()
*!*		APPEND BLANK
*!*		REPLACE CODICEDIP WITH __CODIDIP 
*!*		REPLACE NOMEDIP   WITH M.CED_NOMDIP
*!*	ENDIF
*!*	SELECT CED_ZUCCHETTI
*!*	*!*	SER-XILOPAN

SKIP +1

M.CED_TIPOCO   = UPPER(ALLTRIM(SUBSTR(RIGA,28,25)))
M.CED_CODCON   = ''


*!*	IF M.CED_NOMDIP = "BATTAGLIA EMANUELE"
*!*		SET STEP ON 
*!*	ENDIF


=CERCA_BORSISTI()							&& CERCA CEDOLINI BORSISTI
=CERCA_COCOPRO()							&& CERCA CEDOLINI CO.CO.PRO
=CERCA_VOCI_PAGA_ZUCCHETTI()				&& INTERPRETA LE VOCI PAGA 


IF M.CED_NOMDIP = "*****      RIEPILOGO GENERALE **********"
ELSE

	SELECT CURS_CEDOLINI_DL 
	SET ORDER TO I_KEYDIP 
	____SEEK = M.CED_NOMDIP+M.CED_TIPOCO
	SEEK ____SEEK
	IF FOUND()
		IF !empty(M.Annotazioni)
			IF empty(Annotazioni)
				REPLACE Annotazioni WITH ALLTRIM(M.Annotazioni)
			ELSE
				m.Annotazioni = ALLTRIM(Annotazioni)+"-"+ALLTRIM(M.Annotazioni)
				REPLACE Annotazioni WITH ALLTRIM(M.Annotazioni)
			ENDIF 
		ENDIF 
	ELSE
		APPEND BLANK
		REPLACE KEY_DIP 		WITH ____SEEK 
		DO CEDOLINI_DL
	ENDIF


ENDIF
	  		

SELECT CED_ZUCCHETTI
GO __SONO_QUI
SELECT(AABBSS__)

RETURN





******************************************************************************************
*      ANALISI CEDOLINO PAGA ZUCCHETTI PER ESTRARRE LE VOCI PAGA DA RIFATTURARE AL CLIENTE
******************************************************************************************
*!*	NON CONTA I CEDOLINI PAGA PER CASI DI AZIENDA DISTACCANTE , AZIENDA DI SOMMINISTRAZIONE ............
FUNCTION SCARTA_CEDOLINO

SELECT CED_ZUCCHETTI
ZAABBSS__    = SELECT()
__SONO_QUI_DI_NUOVO=RECNO()

SKIP +11



__SCARTA_CEDOLINO = .F.
	
__NUMERO_RIGHE_CEDOLINO_ZUCCHETTI = 30
FOR FF = 1 TO __NUMERO_RIGHE_CEDOLINO_ZUCCHETTI 

	__WORD_PARA__= APITOSPA(ALLTRIM(SUBSTR(RIGA,1,80)))   
	
	x_codi = "codice like 'ESC%'"
	x_desc = "descri = '" + ALLTRIM(__WORD_PARA__) + "'"
	x_cond = x_codi + " and " + x_desc 
	Csql   = "select * from para where " + x_cond + " order by codice"
	IF !ExecCommand(cSql,"cur_para_esc")
	   return(.f.)
	ENDIF
	SELECT cur_para_esc
	GO TOP
	IF !EOF()
		__SCARTA_CEDOLINO = .T.
		EXIT
	ENDIF

	
	SELECT CED_ZUCCHETTI
	SKIP +1

ENDFOR

SELECT CED_ZUCCHETTI
GO __SONO_QUI_DI_NUOVO
SELECT(ZAABBSS__)

RETURN







******************************************************************************************
*      ANALISI CEDOLINO PAGA ZUCCHETTI PER ESTRARRE LE VOCI PAGA DA RIFATTURARE AL CLIENTE
******************************************************************************************
FUNCTION CERCA_VOCI_PAGA_ZUCCHETTI

 
SELECT CED_ZUCCHETTI
SKIP +11


	
__NUMERO_RIGHE_CEDOLINO_ZUCCHETTI = 30
FOR FF = 1 TO __NUMERO_RIGHE_CEDOLINO_ZUCCHETTI 

	__VOCE_CEDOLINO_ZUCCHETTI =  ALLTRIM(SUBSTR(RIGA,6,4))
	
	=CERCA_VOCE_PAGA_EXTRA_CEDOLINO_ZUCCHETTI()			&& CERCA VOCE PAGA EXTRA CEDOLINO DA RIFATTURARE AL CLIENTE
	=CERCA_VOCE_PAGA_TFR_ZUCCHETTI()					&& CERCA VOCE PAGA TFR
	=CERCA_VOCE_PAGA_ANTICIPO_TFR_ZUCCHETTI()			&& CERCA VOCE PAGA ANTICIPO TFR
	=CERCA_CEDOLINI_PARTICOLARI_ZUCCHETTI()				&& CERCA CEDOLINI PARTICOLARI ZUCCHETTI

	
	SELECT CED_ZUCCHETTI
	SKIP +1

ENDFOR


RETURN




******************************************************************************************
*      ANALISI CEDOLINO PAGA ZUCCHETTI : INTERCETTA CEDOLINI PARTICOLARI
******************************************************************************************
*!*	I CEDOLINI PARTICOLARI HANNO UN COSTO DA RIFATTURARE AL CLIENTE DIVERSO PER CUI
*!*	TRAMITE IL PARAMETRO ICP SI IDENTIFICA SIA IL TIPO DI ELABORAZIONE CHE IL RICAVO SUL CLIENTE

*!*	'ICP00010','Azienda distaccante           :''** TIPO ELAB:1 * COSTO:   2.50**  RICAVO:   5.00** 
*!*	'ICP00020','Agenzia di somministrazione   :''** TIPO ELAB:2 * COSTO:   3.00**  RICAVO:   6.00** 



FUNCTION CERCA_CEDOLINI_PARTICOLARI_ZUCCHETTI



SELECT CED_ZUCCHETTI
__WORD_PARA__ICP__= APITOSPA(ALLTRIM(SUBSTR(RIGA,1,80)))   

x_codi = "codice like 'ICP%'"
x_desc = "descri = '" + ALLTRIM(__WORD_PARA__ICP__) + "'"
x_cond = x_codi + " and " + x_desc 
Csql   = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"cur_para_icp")
   return(.f.)
ENDIF
SELECT cur_para_icp
GO TOP
IF EOF()
	RETURN	&& NON E' UN CEDOLINO PARTICOLARE
ENDIF


___CEDOLINI_PARTICOLARI_ZUCCHETTI  	= .T.

__PRZ_COSTO_PARTICOLARE				= VAL(SUBSTR(LIBERA,24,7))
__PRZ_RICAVO_PARTICOLARE 			= VAL(SUBSTR(LIBERA,42,7))
___ANNOTAZIONI 						= ALLTRIM(DESCRI)
M.CED_CODCON   						= SUBSTR(LIBERA,14,1)

_ANNO__    							= SUBSTR(_ANNOMESE,1,4)
_MESE__    							= SUBSTR(_ANNOMESE,6,2)


=DESCRIZIONE_MESE_ELABORAZIONE(_MESE__)  
		    
___AAAAMM = _ANNO__+"/"+_MESE__    


SELECT DYN_CONTRST_DL 
SET ORDER TO I_AAAAMM

___SEEK = M.CED_CODCON + ___AAAAMM 

SEEK ___SEEK 
IF FOUND()

	REPLACE QTACOSTO 		WITH QTACOSTO   + 1
	REPLACE QTARICAVO 		WITH QTARICAVO  + 1
	REPLACE COSTO			WITH PRZCOSTO   * QTACOSTO  
	REPLACE RICAVO 			WITH PRZRICAVO  * QTARICAVO  
	REPLACE UTILE 			WITH RICAVO - COSTO

ELSE

	APPEND BLANK 
	REPLACE ID_UNIQUE   	WITH ""   		    
	REPLACE DAGGANCIO 		WITH ""  
	REPLACE IDATTIVITA 		WITH "00001"		&& LIBRO UNICO/CALCOLO CEDOLINI
	REPLACE AAAAMM 			WITH ___AAAAMM 
	REPLACE QTACOSTO 		WITH 1
	REPLACE UMCOSTO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH 0
	REPLACE COSTO 			WITH 0
	REPLACE QTARICAVO 		WITH 1
	REPLACE QtaRicavo2      WITH 0
	REPLACE UMRICAVO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH __PRZ_COSTO_PARTICOLARE
	REPLACE COSTO 			WITH __PRZ_COSTO_PARTICOLARE
	REPLACE PRZRICAVO 		WITH __PRZ_RICAVO_PARTICOLARE 
	REPLACE RICAVO 			WITH __PRZ_RICAVO_PARTICOLARE 	
	REPLACE UTILE 			WITH RICAVO - COSTO
	REPLACE ANNOTAZIONI 	WITH ___ANNOTAZIONI 
	REPLACE Tipo_fatt       WITH "" 
	REPLACE FLGFATTURAB 	WITH .F.
	REPLACE TIPO_ELAB 		WITH M.CED_CODCON	
	REPLACE IDDETTAGLI 		WITH SYS(2015)


ENDIF


SELECT CED_ZUCCHETTI

RETURN




***********************************************************************************
*      CERCA VOCI PAGA TFR
***********************************************************************************
FUNCTION CERCA_VOCE_PAGA_TFR_ZUCCHETTI

IF M.CED_NOMDIP = "*****      RIEPILOGO GENERALE **********"
	RETURN
ENDIF

v_seek  = 'KEY'+"00040"
v_chiave= "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

SELECT CU_PARA
IF RECCOUNT() <> 0			&& KEY TROVATA
	__KEY_CONFRONTO = ALLTRIM(LIBERA)
ELSE
	__KEY_CONFRONTO = "**********KEY NON TROVATA**********"
ENDIF

IF __VOCE_CEDOLINO_ZUCCHETTI <> __KEY_CONFRONTO 
	RETURN
ENDIF


___TFR_ZUCCHETTI = .T.

** RICERCA IL VALORE DI RICAVO
v_seek  = 'TFR'+"ZUCCHETTI"
v_chiave= "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

SELECT CU_PARA
IF RECCOUNT() <> 0			&& KEY TROVATA
	__PRZ_RICAVO_TFR = VAL(ALLTRIM(LIBERA))
ELSE
	__PRZ_RICAVO_TFR = 0
ENDIF

_ANNO__    = SUBSTR(_ANNOMESE,1,4)
_MESE__    = SUBSTR(_ANNOMESE,6,2)


=DESCRIZIONE_MESE_ELABORAZIONE(_MESE__)  

    
___AAAAMM = _ANNO__+"/"+_MESE__    
*!*	___ANNOTAZIONI = "Elaborazione T.F.R. mese di "+_DESMESE + " " + _ANNO__
___ANNOTAZIONI = "calcolo T.F.R."

M.CED_CODCON   = 'F'

SELECT DYN_CONTRST_DL 
SET ORDER TO I_AAAAMM

___SEEK = "F" + ___AAAAMM 

SEEK ___SEEK 
IF FOUND()

	REPLACE QTACOSTO 		WITH QTACOSTO   + 1
	REPLACE QTARICAVO 		WITH QTARICAVO  + 1
	REPLACE COSTO			WITH PRZCOSTO   * QTACOSTO  
	REPLACE RICAVO 			WITH PRZRICAVO  * QTARICAVO  
	REPLACE UTILE 			WITH RICAVO - COSTO

ELSE

	APPEND BLANK 
	REPLACE ID_UNIQUE   	WITH ""   		    
	REPLACE DAGGANCIO 		WITH ""  
	REPLACE IDATTIVITA 		WITH "00001"		&& LIBRO UNICO/CALCOLO CEDOLINI
	REPLACE AAAAMM 			WITH ___AAAAMM 
	REPLACE QTACOSTO 		WITH 1
	REPLACE UMCOSTO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH 0
	REPLACE COSTO 			WITH 0
	REPLACE QTARICAVO 		WITH 1
	REPLACE QtaRicavo2      WITH 0
	REPLACE UMRICAVO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH _PREZZO_COSTO_ATTIVITA
	REPLACE COSTO 			WITH _PREZZO_COSTO_ATTIVITA
	REPLACE PRZRICAVO 		WITH __PRZ_RICAVO_TFR 
	REPLACE RICAVO 			WITH __PRZ_RICAVO_TFR 
	REPLACE UTILE 			WITH RICAVO - COSTO
	REPLACE ANNOTAZIONI 	WITH ___ANNOTAZIONI 
	REPLACE Tipo_fatt       WITH "" 
	REPLACE FLGFATTURAB 	WITH .F.
	REPLACE TIPO_ELAB 		WITH "F" 	
	REPLACE IDDETTAGLI 		WITH SYS(2015)


ENDIF




RETURN



***********************************************************************************
*      CERCA VOCI PAGA ANTICIPO TFR
***********************************************************************************
FUNCTION CERCA_VOCE_PAGA_ANTICIPO_TFR_ZUCCHETTI

IF M.CED_NOMDIP = "*****      RIEPILOGO GENERALE **********"
	RETURN
ENDIF

v_seek  = 'KEY'+"00050"
v_chiave= "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

SELECT CU_PARA
IF RECCOUNT() <> 0			&& KEY TROVATA
	__KEY_CONFRONTO = ALLTRIM(LIBERA)
ELSE
	__KEY_CONFRONTO = "**********KEY NON TROVATA**********"
ENDIF

IF __VOCE_CEDOLINO_ZUCCHETTI <> __KEY_CONFRONTO 
	RETURN
ENDIF

___ANTICIPO_TFR_ZUCCHETTI = .T.


** RICERCA IL VALORE DI RICAVO
v_seek  = 'ATF'+"ZUCCHETTI"
v_chiave= "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

SELECT CU_PARA
IF RECCOUNT() <> 0			&& KEY TROVATA
	__PRZ_RICAVO_ANTICIPO_TFR = VAL(ALLTRIM(LIBERA))
ELSE
	__PRZ_RICAVO_ANTICIPO_TFR = 0
ENDIF


_ANNO__    = SUBSTR(_ANNOMESE,1,4)
_MESE__    = SUBSTR(_ANNOMESE,6,2)


=DESCRIZIONE_MESE_ELABORAZIONE(_MESE__)  
		    
___AAAAMM = _ANNO__+"/"+_MESE__    
*!*	___ANNOTAZIONI = "Elaborazione ANTICIPO T.F.R. mese di "+_DESMESE + " " + _ANNO__
___ANNOTAZIONI = "Calcolo ANTICIPO T.F.R."


M.CED_CODCON   = 'A'

SELECT DYN_CONTRST_DL 
SET ORDER TO I_AAAAMM

___SEEK = "A" + ___AAAAMM 

SEEK ___SEEK 
IF FOUND()

	REPLACE QTACOSTO 		WITH QTACOSTO   + 1
	REPLACE QTARICAVO 		WITH QTARICAVO  + 1
	REPLACE COSTO			WITH PRZCOSTO   * QTACOSTO  
	REPLACE RICAVO 			WITH PRZRICAVO  * QTARICAVO  
	REPLACE UTILE 			WITH RICAVO - COSTO

ELSE

	APPEND BLANK 
	REPLACE ID_UNIQUE   	WITH ""   		    
	REPLACE DAGGANCIO 		WITH ""  
	REPLACE IDATTIVITA 		WITH "00001"		&& LIBRO UNICO/CALCOLO CEDOLINI
	REPLACE AAAAMM 			WITH ___AAAAMM 
	REPLACE QTACOSTO 		WITH 1
	REPLACE UMCOSTO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH 0
	REPLACE COSTO 			WITH 0
	REPLACE QTARICAVO 		WITH 1
	REPLACE QtaRicavo2      WITH 0
	REPLACE UMRICAVO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH _PREZZO_COSTO_ATTIVITA
	REPLACE COSTO 			WITH _PREZZO_COSTO_ATTIVITA
	REPLACE PRZRICAVO 		WITH __PRZ_RICAVO_ANTICIPO_TFR 
	REPLACE RICAVO 			WITH __PRZ_RICAVO_ANTICIPO_TFR 	
	REPLACE UTILE 			WITH RICAVO - COSTO
	REPLACE ANNOTAZIONI 	WITH ___ANNOTAZIONI 
	REPLACE Tipo_fatt       WITH "" 
	REPLACE FLGFATTURAB 	WITH .F.
	REPLACE TIPO_ELAB 		WITH "A"	
	REPLACE IDDETTAGLI 		WITH SYS(2015)


ENDIF



RETURN

***********************
FUNCTION CERCA_BORSISTI
***********************


v_seek  = 'KEY'+"00060"
v_chiave= "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

SELECT CU_PARA
IF RECCOUNT() <> 0			&& KEY TROVATA
	__KEY_CONFRONTO = ALLTRIM(LIBERA)
ELSE
	__KEY_CONFRONTO = "**********KEY NON TROVATA**********"
ENDIF

IF UPPER(M.CED_TIPOCO) <> UPPER(__KEY_CONFRONTO) 
	RETURN
ENDIF



___BORSISTI_ZUCCHETTI = .T.


_ANNO__    = SUBSTR(_ANNOMESE,1,4)
_MESE__    = SUBSTR(_ANNOMESE,6,2)

=DESCRIZIONE_MESE_ELABORAZIONE(_MESE__)  
		    
___AAAAMM = _ANNO__+"/"+_MESE__    
*!*	___ANNOTAZIONI = "Elaborazione BORSISTI mese di "+_DESMESE + " " + _ANNO__
___ANNOTAZIONI = "Calcolo BORSISTI" 


M.CED_CODCON   = 'B'

SELECT DYN_CONTRST_DL 
SET ORDER TO I_AAAAMM

___SEEK = "B" + ___AAAAMM 

SEEK ___SEEK 
IF FOUND()

	REPLACE QTACOSTO 		WITH QTACOSTO   + 1
	REPLACE QTARICAVO 		WITH QTARICAVO  + 1
	REPLACE COSTO			WITH PRZCOSTO   * QTACOSTO  
	REPLACE RICAVO 			WITH PRZRICAVO  * QTARICAVO  
	REPLACE UTILE 			WITH RICAVO - COSTO

ELSE

	APPEND BLANK 
	REPLACE ID_UNIQUE   	WITH ""   		    
	REPLACE DAGGANCIO 		WITH ""  
	REPLACE IDATTIVITA 		WITH "00001"		&& LIBRO UNICO/CALCOLO CEDOLINI
	REPLACE AAAAMM 			WITH ___AAAAMM 
	REPLACE QTACOSTO 		WITH 1
	REPLACE UMCOSTO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH 0
	REPLACE COSTO 			WITH 0
	REPLACE QTARICAVO 		WITH 1
	REPLACE QtaRicavo2      WITH 0
	REPLACE UMRICAVO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH _PREZZO_COSTO_ATTIVITA
	REPLACE COSTO 			WITH _PREZZO_COSTO_ATTIVITA
	REPLACE PRZRICAVO 		WITH _PREZZO_RICAVO_ATTIVITA
	REPLACE RICAVO 			WITH _PREZZO_RICAVO_ATTIVITA 	
	REPLACE UTILE 			WITH RICAVO - COSTO
	REPLACE ANNOTAZIONI 	WITH ___ANNOTAZIONI 
	REPLACE Tipo_fatt       WITH "" 
	REPLACE FLGFATTURAB 	WITH .F.
	REPLACE TIPO_ELAB 		WITH "B"	
	REPLACE IDDETTAGLI 		WITH SYS(2015)


ENDIF




RETURN

**********************
FUNCTION CERCA_COCOPRO
**********************


v_seek  = 'KEY'+"00030"
v_chiave= "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

SELECT CU_PARA
IF RECCOUNT() <> 0			&& KEY TROVATA
	__KEY_CONFRONTO = ALLTRIM(LIBERA)
ELSE
	__KEY_CONFRONTO = "**********KEY NON TROVATA**********"
ENDIF

IF UPPER(M.CED_TIPOCO) <> UPPER(__KEY_CONFRONTO) 
	RETURN
ENDIF

___COCOPRO_ZUCCHETTI = .T.


_ANNO__    = SUBSTR(_ANNOMESE,1,4)
_MESE__    = SUBSTR(_ANNOMESE,6,2)

=DESCRIZIONE_MESE_ELABORAZIONE(_MESE__)  

		    
___AAAAMM = _ANNO__+"/"+_MESE__    
*!*	___ANNOTAZIONI = "Elaborazione CO.CO.CO mese di "+_DESMESE + " " + _ANNO__
___ANNOTAZIONI = "Calcolo CO.CO.CO" 


M.CED_CODCON   = 'C'

SELECT DYN_CONTRST_DL 
SET ORDER TO I_AAAAMM

___SEEK = "C" + ___AAAAMM 

SEEK ___SEEK 
IF FOUND()

	REPLACE QTACOSTO 		WITH QTACOSTO   + 1
	REPLACE QTARICAVO 		WITH QTARICAVO  + 1
	REPLACE COSTO			WITH PRZCOSTO   * QTACOSTO  
	REPLACE RICAVO 			WITH PRZRICAVO  * QTARICAVO  
	REPLACE UTILE 			WITH RICAVO - COSTO

ELSE

	APPEND BLANK 
	REPLACE ID_UNIQUE   	WITH ""   		    
	REPLACE DAGGANCIO 		WITH ""  
	REPLACE IDATTIVITA 		WITH "00001"		&& LIBRO UNICO/CALCOLO CEDOLINI
	REPLACE AAAAMM 			WITH ___AAAAMM 
	REPLACE QTACOSTO 		WITH 1
	REPLACE UMCOSTO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH 0
	REPLACE COSTO 			WITH 0
	REPLACE QTARICAVO 		WITH 1
	REPLACE QtaRicavo2      WITH 0
	REPLACE UMRICAVO 		WITH 'NR'
	REPLACE PRZCOSTO 		WITH _PREZZO_COSTO_ATTIVITA
	REPLACE COSTO 			WITH _PREZZO_COSTO_ATTIVITA
	REPLACE PRZRICAVO 		WITH _PREZZO_RICAVO_ATTIVITA
	REPLACE RICAVO 			WITH _PREZZO_RICAVO_ATTIVITA
	REPLACE UTILE 			WITH RICAVO - COSTO
	REPLACE ANNOTAZIONI 	WITH ___ANNOTAZIONI 
	REPLACE Tipo_fatt       WITH "" 
	REPLACE FLGFATTURAB 	WITH .F.
	REPLACE TIPO_ELAB 		WITH "C"	
	REPLACE IDDETTAGLI 		WITH SYS(2015)


ENDIF


RETURN

**************************************
FUNCTION DESCRIZIONE_MESE_ELABORAZIONE
**************************************
PARAMETERS MESE_ELAB

_DESMESE  = "xxxxxxxxxxxxxxxxx"	

IF MESE_ELAB  = "01"
	_DESMESE  = "Gennaio"
ENDIF
IF MESE_ELAB  = "02"
	_DESMESE  = "Febbraio"
ENDIF
IF MESE_ELAB  = "03"
	_DESMESE  = "Marzo"
ENDIF
IF MESE_ELAB  = "04"
	_DESMESE  = "Aprile"
ENDIF
IF MESE_ELAB  = "05"
	_DESMESE  = "Maggio"
ENDIF
IF MESE_ELAB  = "06"
	_DESMESE  = "Giugno"
ENDIF
IF MESE_ELAB  = "07"
	_DESMESE  = "Luglio"
ENDIF
IF MESE_ELAB  = "08"
	_DESMESE  = "Agosto"
ENDIF
IF MESE_ELAB  = "09"
	_DESMESE  = "Settembre"
ENDIF
IF MESE_ELAB  = "10"
	_DESMESE  = "Ottobre"
ENDIF
IF MESE_ELAB  = "11"
	_DESMESE  = "Novembre"
ENDIF
IF MESE_ELAB  = "12"
	_DESMESE  = "Dicembre"
ENDIF


RETURN


***********************************************************************************
*      CERCA VOCI PAGA EXTRA CEDOLINO ZUCCHETTI DA RIFATTURARE AL CLIENTE
***********************************************************************************
FUNCTION CERCA_VOCE_PAGA_EXTRA_CEDOLINO_ZUCCHETTI

v_seek  = 'CZU'+__VOCE_CEDOLINO_ZUCCHETTI
v_chiave= "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

SELECT CU_PARA
IF RECCOUNT() <> 0			&& VOCE CEDOLINO PAGA TROVATA QUINDI DA RIFATTURARE

	IF EMPTY(M.Annotazioni)
		M.Annotazioni  = __VOCE_CEDOLINO_ZUCCHETTI 
	ELSE
		M.Annotazioni  = M.Annotazioni + "-" + __VOCE_CEDOLINO_ZUCCHETTI 
	ENDIF
	
	**=> ERASMO - INIZIO 20/07/2010
	*** MEMORIZZO IN APPOSITA TABELLA LE ATTIVITA' SOGGETTE A POSSIBILE CREAZIONE DEL FATTURABILE
	IF _AGG_ATTIVEXCED
		IF "RIEPILOGO GENERALE" $ ALLTRIM(M.CED_NOMDIP)
		ELSE
			__DESCRIZIONE_VOCE = ALLTRIM(DESCRI)
			x_clie = "CODCLI = '" + ALLTRIM(M.CED_CODCLI) + "'"
			x_aamm = "AAAAMM = '" + _ANNOMESE + "'"
			x_atti = "CODATTIV = '" + ALLTRIM(__VOCE_CEDOLINO_ZUCCHETTI) + "'"
			*x_fatt = "FLGFATTURAB = 0"
			x_cond = x_clie + " and " + x_aamm + " and " + x_atti 
			cSql   = "select * from ATTIVEXCED where " + x_cond
			IF !ExecRW(cSql,'ATTIVEXCED','R')
			   return(.f.)
			ENDIF
			SELECT ATTIVEXCED
			GO TOP
			IF EOF()
				APPEND BLANK
				M.IDATTIVEXCED = SYS(2015)
				M.CODCLI = ALLTRIM(M.CED_CODCLI)
				M.RAGSOC = ALLTRIM(M.CED_DESCLI)
				M.AAAAMM = _ANNOMESE 
				M.CODATTIV = ALLTRIM(__VOCE_CEDOLINO_ZUCCHETTI)
				M.DESATTIV = __DESCRIZIONE_VOCE 
				M.NUMCED = 1
				M.ANNOTAZIONI = ALLTRIM(M.CED_NOMDIP)
				M.FLGFATTURAB = .F.
				DO ATTIVEXCED
			ELSE
				IF ALLTRIM(M.CED_NOMDIP) $ ANNOTAZIONI
				ELSE
					REPLACE NUMCED WITH NUMCED + 1
					REPLACE ANNOTAZIONI WITH ANNOTAZIONI + "; " + ALLTRIM(M.CED_NOMDIP)
				ENDIF
			ENDIF
			IF !ExecRW(cSql,'ATTIVEXCED','W')
			   return(.f.)
			ENDIF
		ENDIF
	ENDIF
	**=> ERASMO - FINE 20/07/2010
	
ENDIF


RETURN




***********************************************************************************
*      CERCA IL MESE DI ELABORAZIONE NEL CEDOLINO PAGA ZUCCHETTI
***********************************************************************************
FUNCTION CERCA_MESE_CEDOLINO_ZUCCHETTI


SELECT CED_ZUCCHETTI

AABBSS__    = SELECT()
__SONO_QUI=RECNO()

*!*	MI SPOSTO SUL RECORD PER PRELEVARE IL DEL MESE 
*!*	123456789-123456789-123456789-123456789-123456789-123456789-123456789-12Marzo     2010
SKIP +6



MESE_CEDOLINO_PAGA = UPPER(ALLTRIM(SUBSTR(RIGA,73,10)))
ANNO_CEDOLINO_PAGA_ZUCCHETTI = SUBSTR(RIGA,83,4)



IF MESE_CEDOLINO_PAGA = "GENNAIO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "01"
ENDIF

IF MESE_CEDOLINO_PAGA = "FEBBRAIO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "02"
ENDIF

IF MESE_CEDOLINO_PAGA = "MARZO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "03"
ENDIF

IF MESE_CEDOLINO_PAGA = "APRILE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "04"
ENDIF

IF MESE_CEDOLINO_PAGA = "MAGGIO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "05"
ENDIF

IF MESE_CEDOLINO_PAGA = "GIUGNO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "06"
ENDIF

IF MESE_CEDOLINO_PAGA = "LUGLIO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "07"
ENDIF

IF MESE_CEDOLINO_PAGA = "AGOSTO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "08"
ENDIF

IF MESE_CEDOLINO_PAGA = "SETTEMBRE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "09"
ENDIF

IF MESE_CEDOLINO_PAGA = "OTTOBRE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "10"
ENDIF

IF MESE_CEDOLINO_PAGA = "NOVEMBRE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "11"
ENDIF

IF MESE_CEDOLINO_PAGA = "DICEMBRE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "12"
ENDIF


GO __SONO_QUI
SELECT(AABBSS__)

RETURN



***********************************************************************************
*      CANCELLA DATI MESE PRECEDENTEMETE ELABORATI
***********************************************************************************
FUNCTION CANCELLA_ELABORAZIONI_PRECEDENTI_ZUCCHETTI

*!*	CANCELLA IL MESE IN ELABORAZIONE

__ANNO= ANNO_CEDOLINO_PAGA_ZUCCHETTI 
__MESE= MESE_CEDOLINO_PAGA_ZUCCHETTI 


** SERGIO 21/09/2010
__TIPO_ELAB= "M"
IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	__TIPO_ELAB= "M"
ENDIF
IF _V_OPZ_ELAB_13_ZUCCHETTI
	__TIPO_ELAB= "T"
ENDIF
IF _V_OPZ_ELAB_14_ZUCCHETTI
	__TIPO_ELAB= "Q"
ENDIF


*!*	CANCELLA RECORD CLIENTE
x_cond = "ced_codcli = '" + m.ced_codcli + "'"
cSql   = "delete from CEDOLINI where " + x_cond 
IF !ExecCommand(cSql,"CEDOLINI")
   return(.f.)
ENDIF

x_codc = "ced_codcli = '" + m.ced_codcli + "'"
x_aaaa = "AAAA = '" + __ANNO + "'"
x_mm = "MM = '" + __MESE + "'"


** SERGIO 21/09/2010
x_te = "tipo_elab = '" + __TIPO_ELAB + "'"
x_cond = x_codc + " and " + x_aaaa + " and " + x_mm + " and " + x_te


cSql   = "select * from CEDOLINI_DD where " + x_cond 
IF !ExecCommand(cSql,"CEDOLINI_DD")
   return(.f.)
ENDIF

SELECT CEDOLINI_DD
IF reccount() <> 0

	___DAGGANCIO    = DAGGANCIO
	___DAGGANCIO_DD = DAGGANCIO_DL	
	
	
	*!*	CANCELLA IL MESE IN ELABORAZIONE
	x_codc = "ced_codcli = '" + m.ced_codcli + "'"
	x_dagga = "DAGGANCIO = '" + ___daggancio + "'"
	x_cond = x_codc + " and " + x_dagga
	
	cSql   = "delete from CEDOLINI_DD where " + x_cond 
	IF !ExecCommand(cSql,"CEDOLINI_DD")
	   return(.f.)
	ENDIF

	*!*	CANCELLA IL DETTAGLI MESE
	x_codc = "ced_codcli = '" + m.ced_codcli + "'"
	x_dagga = "DAGGANCIO_DD = '" + ___daggancio_dd + "'"
	x_cond = x_codc + " and " + x_dagga

	cSql   = "delete from CEDOLINI_DL where " + x_cond 
	IF !ExecCommand(cSql,"CEDOLINI_DL")
	   return(.f.)
	ENDIF


ENDIF

   	

RETURN



***********************************************************************************
*      ELABORAZIONE MENSILE CEDOLINI PAGA SISPAC
***********************************************************************************
PROCEDURE ELABORA_CEDOLINI_PAGA_SISPAC
***********************************************************************************

PARAMETERS _PERCORSO_E_NOMEFILE,_ANNOMESE,_AGG_CONTRSTUDI,_AGG_ATTIVEXCED,_DIR_MOVEFILE

IF PARAMETERS() < 2
	MESSAGEBOX("Nessun parametro passato",16,"Attenzione")
	RETURN
ENDIF

**=> ERASMO - INIZIO 13/07/2010
IF TYPE("_AGG_CONTRSTUDI") == "U"
	_AGG_CONTRSTUDI = .F.
ENDIF
IF TYPE("_AGG_ATTIVEXCED") == "U"
	_AGG_ATTIVEXCED = .F.
ENDIF
**=> ERASMO - FINE 13/07/2010

**=> ERASMO - INIZIO 21/07/2010
IF TYPE("_DIR_MOVEFILE") == "U"
	_DIR_MOVEFILE = ""
ENDIF
**=> ERASMO - FINE 21/07/2010

RELEASE KEY_PREC
PUBLIC KEY_PREC

KEY_PREC	= ""



RELEASE M.CED_CODCLI,M.CED_DESCLI
PUBLIC M.CED_CODCLI,M.CED_DESCLI
M.CED_CODCLI  	= ""
M.CED_DESCLI  	= ""


RELEASE M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 
PUBLIC M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 

M.TAGGANCIO = ""
M.DAGGANCIO = ""
M.DAGGANCIO_DD = ""
M.DAGGANCIO_DL = ""

RELEASE MESE_CEDOLINO_PAGA_SISPAC,ANNO_CEDOLINO_PAGA_SISPAC  
PUBLIC MESE_CEDOLINO_PAGA_SISPAC,ANNO_CEDOLINO_PAGA_SISPAC  
MESE_CEDOLINO_PAGA_SISPAC = ""
ANNO_CEDOLINO_PAGA_SISPAC = ""


RELEASE __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
PUBLIC __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
__PATH__ 	= ""
CONTA_CEDOLINI  = 0
_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA = .F.

RELEASE _NUM_CEDOLINI_RICALCOLATO
PUBLIC _NUM_CEDOLINI_RICALCOLATO
_NUM_CEDOLINI_RICALCOLATO = 0


*!*	################################### APERTURA TABELLE DI SUPORTO #############################################

* -->> Creazione cursore vuoto per caricare i cedolini SISPAC
* --------------------------------------------------------------
CREATE CURSOR CED_SISPAC (RIGA C(250))
        
 
* -->> Creazione cursore vuoto di elaborazioni mensili
* ----------------------------------------------------

IF USED("CU_ELAB_MENS")
  SELECT CU_ELAB_MENS
  USE
ENDIF

IF !ExecCommand("select * from ELAB_MENS where 0=1","CU_ELAB_MENS")
  return(.f.)
ENDIF
SELECT CU_ELAB_MENS
INDEX ON CODCLI_AQUARIUS TAG I_CODCLI 
SET ORDER TO I_CODCLI  
 
        
* -->> Creazione cursore vuoto di testata cedolino I livello
* -----------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI where 0=1","CU_CEDOLINI")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI
INDEX ON CED_CODCLI TAG I_CODCLI 
SET ORDER TO I_CODCLI 


* -->> Creazione cursore vuoto di dettaglio cedolino II livello
* --------------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI_DD where 0=1","CU_CEDOLINI_DD")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI_DD
INDEX ON DAGGANCIO TAG I_DAGGA  
INDEX ON AAAA + MM TAG I_AAAAMM  
SET ORDER TO I_AAAAMM


* -->> Creazione cursore vuoto di dettaglio cedolino III livello
* ---------------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI_DL where 0=1","CU_CEDOLINI_DL")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI_DL
INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE 
SET ORDER TO I_NOMDIP 


* -->> Creazione cursore vuoto di testata cedolino I livello
* -----------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI where 0=1","____CU_CEDOLINI")
  return(.f.)
ENDIF
SELECT ____CU_CEDOLINI
AA = AFIELDS(BB)
CREATE CURSOR SAVE_CU_CEDOLINI FROM ARRAY BB	
INDEX ON CED_CODCLI TAG I_CODCLI 
SET ORDER TO I_CODCLI 




* -->> Creazione cursore vuoto di dettaglio cedolino II livello
* --------------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI_DD where 0=1","____CU_CEDOLINI_DD")
  return(.f.)
ENDIF
SELECT ____CU_CEDOLINI_DD
AA = AFIELDS(BB)
CREATE CURSOR SAVE_CU_CEDOLINI_DD FROM ARRAY BB	
INDEX ON DAGGANCIO TAG I_DAGGA  
INDEX ON CED_CODCLI + AAAA + MM TAG I_AAAAMM  
SET ORDER TO I_AAAAMM



* -->> Creazione cursore vuoto di dettaglio cedolino III livello
* ---------------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI_DL where 0=1","____CU_CEDOLINI_DL")
  return(.f.)
ENDIF
SELECT ____CU_CEDOLINI_DL
AA = AFIELDS(BB)
CREATE CURSOR SAVE_CU_CEDOLINI_DL FROM ARRAY BB	
INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE 
SET ORDER TO I_NOMDIP 



* -->> Creazione cursore vuoto per caricare il terzo livello
* --------------------------------------------------------------
CREATE CURSOR CURS_CEDOLINI_DL ;
       (KEY_DIP C(100),    DAGGANCIO_DD C(10),   CED_CODCLI C(10),      CED_NOMDIP C(50),   CED_CODCON C(3),   CED_TIPOCO C(25),     ;
        Annotazioni C(250))
INDEX ON KEY_DIP 				TAG I_KEYDIP ADDITIVE
INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE
SET ORDER TO I_KEYDIP 




*!*	################################### ELABORAZIONE CLIENTI SISPAC #############################################



*!*	CREA IL CURSORE DELLE ELABORAZIONI DEL MESE PER I SOLI CLIENTI SISPAC
___AZIENDE_SISPAC___  = ""
x_cond = "codcli_SISPAC <> '" + ___AZIENDE_SISPAC___ + "'"
cSql = "select * from u_cli_ex where " + x_cond + " order by codcli_SISPAC"
 
IF !ExecCommand(cSql,"cu_aziende_SISPAC")
  return(.f.)
ENDIF



SELECT CU_AZIENDE_SISPAC
GO TOP
DO WHILE .NOT. EOF()


	SELECT CU_AZIENDE_SISPAC
	SCATTER MEMVAR MEMO
	
	
	
	SELECT CU_ELAB_MENS	
	APPEND BLANK
	
    REPLACE TIPO_ELAB 			WITH "SISPAC"
    REPLACE AAAAMM 				WITH _ANNOMESE
    REPLACE CODCLI_AQUARIUS 	WITH M.CODCLI_AQUARIUS 
    REPLACE RAGSOC_AQUARIUS 	WITH M.RAGSOC_AQUARIUS 
	REPLACE ELAB_FATTA  		WITH .F. 		


	SELECT CU_AZIENDE_SISPAC
	SKIP +1

ENDDO




*!*	################################### ELABORAZIONE CEDOLINI PAGA #############################################


*!*	__PATH__ = __PATH__+PUB_ANNO
*!*	SET DEFA TO &__PATH__

*!*	NUMFILE = ADIR(MATFILE,'*.TXT')

*!*	IF NUMFILE > 0
*!*	ELSE

*!*	   =MESSAGEB("Nessun cedolino paga SISPAC elaborato , li hai copiati nella directory del mese ?",16,"*** ATTENZIONE ***")
*!*	   RETURN

*!*	ENDIF

_TOT_CEDOLINI_SISPAC = 0
_TOT_CLIENTI = 0


*FOR FF = 1 TO NUMFILE							&& ELABORAZIONE MULTIPLIPA DEI FILE CEDOLINI CONTENUTI NELLA DIRECTORY

  	*GG_FILE = MATFILE[FF,1]
  	GG_FILE = _PERCORSO_E_NOMEFILE

	SELECT CED_SISPAC
	
	_COMANDO = "APPEND FROM '" + GG_FILE + "' SDF"
	&_COMANDO
	
	GO TOP

*!*	16/09/2010 SERGIO
RELEASE ___VERIFICHE_INCROCIATE_SISPAC
PUBLIC ___VERIFICHE_INCROCIATE_SISPAC
___VERIFICHE_INCROCIATE_SISPAC = .T.
=CONTROLLI_INCROCIATI_SUL_CEDOLINO_SISPAC()
IF !___VERIFICHE_INCROCIATE_SISPAC
	RETURN
ENDIF



RELEASE ____FINE_ELABORAZIONE
PUBLIC ____FINE_ELABORAZIONE
____FINE_ELABORAZIONE = .F.


SELECT CED_SISPAC
GO TOP


	DO WHILE .NOT. EOF()
		
		
		IF EOF()
			EXIT
		ENDIF
		
		
		SCATTER MEMVAR MEMO
		
		___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               


		____FINE_ELABORAZIONE = .F.
        =CERCA_RISORSA_ELABORABILE_SISPAC()
        
        IF ____FINE_ELABORAZIONE 
        	EXIT
        ENDIF


				
		*!*	    CONTROAGGIORNA LA TABELLA ELAB_MENS 

	    SELECT CU_ELAB_MENS
	    SET ORDER TO I_CODCLI  
	   
	    V_SEEK  	= CURS_CLI_EX.CODCLI_AQUARIUS
	   
	    SEEK V_SEEK  
	    IF FOUND()
	         REPLACE ELAB_FATTA WITH .T.
	    ENDIF

	    CONTA_CEDOLINI = CONTA_CEDOLINI + 1
	    

	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

	    SELECT CED_SISPAC
	    
  		=DETERMINA_DATI_CLIENTE_STUDIO_SISPAC()
 		
  	    =CERCA_MESE_CEDOLINO_SISPAC()
  	    
	  	IF VAL(MESE_CEDOLINO_PAGA_SISPAC) > 0 AND VAL(MESE_CEDOLINO_PAGA_SISPAC) < 13
	  	ELSE
	  		   =MESSAGEB("FILE CEDOLINI PAGA SISPAC NON CORRETTI ?? : INTERROMPO L'ELABORAZIONE",16,"*** ATTENZIONE ***")
	  		   SET DEFA TO &PUB_DIR
	  		   RETURN
	  	ENDIF
	  	
	  	IF VAL(MESE_CEDOLINO_PAGA_SISPAC) == VAL(SUBSTR(_ANNOMESE,6,2)) .AND. VAL(ANNO_CEDOLINO_PAGA_SISPAC) == VAL(SUBSTR(_ANNOMESE,1,4))
	  	ELSE
			MESSAGEBOX("Verificare che il mese selezionato corrisponda a quello dei cedolini contenuti nel file selezionato" + CHR(13) + CHR(13) + ;
				"Impossibile continuare con l'elaborazione dei cedolini",48,"Attenzione")
			RETURN
	  	ENDIF
	  	
	  	=CERCA_RISORSA_CEDOLINO_SISPAC()
	  	
	  	=PREPARA_CURSORI_A_LIVELLO_DI_CLIENTE_STUDIO_SISPAC()
	  	
	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

  	
	
		SELECT CED_SISPAC
		SKIP +1
		
	ENDDO


    =IMPOSTA_DAGGANCIO_DD_CURSORE_CEDOLINO_DL_SISPAC()
	=SCRIVE_CURSORI_A_LIVELLO_DI_CLIENTE_STUDIO_SISPAC()

	* -->> Creazione cursore vuoto per caricare i cedolini SISPAC
	* --------------------------------------------------------------
	CREATE CURSOR CED_SISPAC (RIGA C(250))

      
	* -->> Creazione cursore vuoto per caricare il terzo livello
	* --------------------------------------------------------------
	CREATE CURSOR CURS_CEDOLINI_DL ;
	       (KEY_DIP C(100),    DAGGANCIO_DD C(10),   CED_CODCLI C(10),      CED_NOMDIP C(50),   CED_CODCON C(3),   CED_TIPOCO C(25),     ;
	        Annotazioni C(250))
	INDEX ON KEY_DIP 				TAG I_KEYDIP ADDITIVE
	INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
	INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
	INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE
	SET ORDER TO I_KEYDIP 

	 	

 	


*ENDFOR



*!*	################################### AGGIORNA TABELLE CEDOLINI PAGA  #############################################


**=> ERASMO - INIZIO 21/07/2010
*** SALVATAGGIO CEDOLINI NELLA DIRECTORY MESE IN ELABORAZIONE

IF _V_OPZ_SPOSTAFILE
	IF !EMPTY(_DIR_MOVEFILE) .AND. DIRECTORY(_DIR_MOVEFILE,1)
		
		IF RIGHT(_DIR_MOVEFILE,1) == "\"
		ELSE
			_DIR_MOVEFILE = _DIR_MOVEFILE + "\"
		ENDIF
		_FILE_DI_ARRIVO = _DIR_MOVEFILE + JUSTFNAME(GG_FILE)
		
	  	WAIT WINDOWS "SPOSTAMENTO FILE CEDOLINI SISPAC ELABORATO: " + GG_FILE NOWAIT
	  	
	    _COMANDO = "COPY FILE '" + GG_FILE + "' TO '" + _FILE_DI_ARRIVO + "'"
		&_COMANDO 
		
	    _COMANDO = "ERASE '" + GG_FILE + "'"
		&_COMANDO 
	  	
	  	WAIT CLEAR
	  	
	ENDIF
ENDIF 
**=> ERASMO - FINE 21/07/2010





RELEASE FLAG_STAMPA,FLAG_PREVIEW,W_STATO
PUBLIC  FLAG_STAMPA,FLAG_PREVIEW,W_STATO


FLAG_STAMPA = .F.
FLAG_PREVIEW= .T.




SELECT CU_ELAB_MENS
SET FILTER TO ELAB_FATTA = .f.
GO TOP

W_STATO = "Clienti NON elaborati con la procedura SISPAC --- Mensilità"

IF _V_OPZ_ELAB_13_SISPAC
	W_STATO = "Clienti NON elaborati con la procedura SISPAC --- Tredicesima Mensilità"
ENDIF


IF _V_OPZ_ELAB_14_SISPAC
	W_STATO = "Clienti NON elaborati con la procedura SISPAC --- Quattordicesima Mensilità"
ENDIF


IF _V_OPZ_ELAB_BORSISTI_SISPAC
	W_STATO = "Clienti NON elaborati con la procedura SISPAC --- Borsisti"
ENDIF

IF _V_OPZ_ELAB_COCOPRO_SISPAC 
	W_STATO = "Clienti NON elaborati con la procedura SISPAC --- Contratti a Progetto"
ENDIF



DO PRG\MENUSTA WITH "CU_ELAB_MENS",FLAG_PREVIEW,FLAG_STAMPA,"XXX","ELAB_MENS","ELAB_MENS.FRX" && ELENCO AZIENDE SISPAC NON ELABORATE
SET FILTER TO 


SELECT CU_ELAB_MENS
SET FILTER TO ELAB_FATTA = .t.
GO TOP
W_STATO = "Clienti elaborati con la procedura SISPAC --- Mensilità"

IF _V_OPZ_ELAB_13_SISPAC
	W_STATO = "Clienti elaborati con la procedura SISPAC --- Tredicesima Mensilità"
ENDIF


IF _V_OPZ_ELAB_14_SISPAC
	W_STATO = "Clienti elaborati con la procedura SISPAC --- Quattordicesima Mensilità"
ENDIF


IF _V_OPZ_ELAB_BORSISTI_SISPAC
	W_STATO = "Clienti elaborati con la procedura SISPAC --- Borsisti"
ENDIF

IF _V_OPZ_ELAB_COCOPRO_SISPAC 
	W_STATO = "Clienti elaborati con la procedura SISPAC --- Contratti a Progetto"
ENDIF


DO PRG\MENUSTA WITH "CU_ELAB_MENS",FLAG_PREVIEW,FLAG_STAMPA,"XXX","ELAB_MENS","ELAB_MENS.FRX" && ELENCO AZIENDE SISPAC NON ELABORATE


SELECT CU_ELAB_MENS
SET FILTER TO ELAB_FATTA = .t.
GO TOP


*!*	AGGIORNAMENTO TABELLA ELAB_MENS
*!*	CANCELLA RECORD PRECEDENTI
_TIPOELAB    = "SISPAC"
x_aamm       = "AAAAMM = '" + _ANNOMESE + "'"
x_tipo_elab  = "TIPO_ELAB = '" + _TIPOELAB + "'"
x_cond       = x_aamm + " and " + x_tipo_elab  
cSql   = "delete from ELAB_MENS where " + x_cond 
IF !ExecCommand(cSql,"ELAB_MENS")
   return(.f.)
ENDIF


*!*	AGGIORNA LA TABELLA DELLE ELABORAZIONI MENSILI RICARICANDOLA
  
IF !ExecRW('','ELAB_MENS','I','','CU_ELAB_MENS')
 return(.f.)
ENDIF


SET DEFA TO &PUB_DIR


RETURN



***********************************************************************************
*      PREPARA I CURSORI A LIVELLO DI CLIENTE STUDIO
***********************************************************************************
FUNCTION PREPARA_CURSORI_A_LIVELLO_DI_CLIENTE_STUDIO_SISPAC
AABBSS__    = SELECT()

*!*	IF EMPTY(ALLTRIM(M.CED_CODCLI))
*!*		SELECT(AABBSS__)
*!*		RETURN .F.
*!*	ENDIF

WAIT WINDOWS "CLIENTE STUDIO SISPAC IN ELABORAZIONE : "+ALLTRIM(M.CED_DESCLI) NOWAIT

=CREA_CURSORE_DATI_CLIENTE_STUDIO_SISPAC()
=CANCELLA_ELABORAZIONI_PRECEDENTI_SISPAC()
=CREA_CEDOLINO_DL_SISPAC()
=CREA_CURSORE_DATI_MESE_ELABORAZIONE_SISPAC()	



*!*	SALVATAGGIO CURSORI DI SUPPORTO A LIVELLO DI CLIENTE STUDIO




   	
SELECT CU_CEDOLINI
GO TOP
DO WHILE .NOT.EOF()

	SELECT CU_CEDOLINI
	
	__TAGGANCIO   	= TAGGANCIO
	__CED_CODCLI    = CED_CODCLI
	__CED_DESCLI    = CED_DESCLI
	__NOTE          = NOTE

	__ORAINS      	= ORAINS      
	__UTENTEINS   	= UTENTEINS   
	__DATAINS     	= DATAINS      


	__NOTE 			= NOTE 		
	__UTENTEMOD 	= UTENTEMOD 
	__DATAMOD 		= DATAMOD 
	__ORAMOD 		= ORAMOD 



	SELECT SAVE_CU_CEDOLINI
	SET ORDER TO I_CODCLI
	____SEEK = __CED_CODCLI    
	SEEK ____SEEK
	IF !FOUND()
		APPEND BLANK
	ENDIF

	REPLACE TAGGANCIO 	WITH __TAGGANCIO 
	REPLACE CED_CODCLI	WITH __CED_CODCLI    
	REPLACE CED_DESCLI 	WITH __CED_DESCLI     
	REPLACE NOTE 		WITH __NOTE          
	REPLACE UTENTEINS 	WITH __UTENTEINS   
	REPLACE DATAINS 	WITH __DATAINS     
	REPLACE ORAINS 		WITH __ORAINS       
	REPLACE UTENTEMOD 	WITH __UTENTEMOD 
	REPLACE DATAMOD 	WITH __DATAMOD 
	REPLACE ORAMOD 		WITH __ORAMOD 


	
	SELECT CU_CEDOLINI
	SKIP +1
	
ENDDO

SELECT CU_CEDOLINI_DD
GO TOP
DO WHILE .NOT.EOF()

	SELECT CU_CEDOLINI_DD


	__DAGGANCIO 	= DAGGANCIO
	__DAGGANCIO_DL 	= DAGGANCIO_DL 
	__CED_CODCLI 	= CED_CODCLI 
	__CED_DESCLI 	= CED_DESCLI 
	__AAAA 			= AAAA 	
	__MM 			= MM 	
	__NUM_CEDOLINI 	= NUM_CEDOLINI
	__ANNOTAZIONI 	= ANNOTAZIONI
	__TIPO_ELAB		= TIPO_ELAB
	__TIPO_FATT		= TIPO_FATT


	SELECT SAVE_CU_CEDOLINI_DD
	SET ORDER TO I_AAAAMM 
	____SEEK = __CED_CODCLI  + __AAAA + __MM
	SEEK ____SEEK
	IF !FOUND()
		APPEND BLANK
		REPLACE DAGGANCIO 		WITH __DAGGANCIO 
		REPLACE DAGGANCIO_DL 	WITH __DAGGANCIO_DL 
		REPLACE CED_CODCLI 		WITH __CED_CODCLI 
		REPLACE CED_DESCLI 		WITH __CED_DESCLI 
		REPLACE AAAA 			WITH __AAAA 
		REPLACE MM 				WITH __MM 
		REPLACE NUM_CEDOLINI 	WITH 0
		REPLACE ANNOTAZIONI 	WITH __ANNOTAZIONI 
		REPLACE TIPO_ELAB		WITH __TIPO_ELAB
		REPLACE TIPO_FATT		WITH __TIPO_FATT			
	ENDIF


	
	SELECT CU_CEDOLINI_DD
	SKIP +1
	
ENDDO




SELECT CU_CEDOLINI_DL
GO TOP

DO WHILE .NOT.EOF()


	SELECT CU_CEDOLINI_DL


	__DAGGANCIO_DD 	= DAGGANCIO_DD
	__CED_CODCLI 	= CED_CODCLI 
	__CED_NOMDIP 	= CED_NOMDIP
	__CED_TIPOCO 	= CED_TIPOCO 	
	__ANNOTAZIONI 	= ANNOTAZIONI


	SELECT SAVE_CU_CEDOLINI_DL
	SET ORDER TO I_NOMDIP 
	
	____SEEK = __CED_NOMDIP 
	
	SEEK ____SEEK
	IF !FOUND()
		APPEND BLANK
		REPLACE DAGGANCIO_DD 	WITH __DAGGANCIO_DD 
		REPLACE CED_CODCLI 		WITH __CED_CODCLI 
		REPLACE CED_NOMDIP 		WITH __CED_NOMDIP 
		REPLACE CED_TIPOCO 		WITH __CED_TIPOCO 
		REPLACE ANNOTAZIONI 	WITH __ANNOTAZIONI 
		_TOT_CEDOLINI_SISPAC = _TOT_CEDOLINI_SISPAC + 1
	ENDIF


	
	SELECT CU_CEDOLINI_DL
	SKIP +1
	
ENDDO




_TOT_CLIENTI = _TOT_CLIENTI + 1
        
* -->> Creazione cursore vuoto di testata cedolino I livello
* -----------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI where 0=1","CU_CEDOLINI")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI
INDEX ON CED_CODCLI TAG I_CODCLI 
SET ORDER TO I_CODCLI 


* -->> Creazione cursore vuoto di dettaglio cedolino II livello
* --------------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI_DD where 0=1","CU_CEDOLINI_DD")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI_DD
INDEX ON DAGGANCIO TAG I_DAGGA  
INDEX ON AAAA + MM TAG I_AAAAMM  
SET ORDER TO I_AAAAMM


* -->> Creazione cursore vuoto di dettaglio cedolino III livello
* ---------------------------------------------------------------
IF !ExecCommand("select * from CEDOLINI_DL where 0=1","CU_CEDOLINI_DL")
  return(.f.)
ENDIF
SELECT CU_CEDOLINI_DL
INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE 
SET ORDER TO I_NOMDIP 


* -->> Creazione cursore vuoto per caricare il terzo livello
* --------------------------------------------------------------
CREATE CURSOR CURS_CEDOLINI_DL ;
       (KEY_DIP C(100),    DAGGANCIO_DD C(10),   CED_CODCLI C(10),      CED_NOMDIP C(50),   CED_CODCON C(3),   CED_TIPOCO C(25),     ;
        Annotazioni C(250))
INDEX ON KEY_DIP 				TAG I_KEYDIP ADDITIVE
INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE
SET ORDER TO I_KEYDIP 







SELECT(AABBSS__)

RETURN


***********************************************************************************
*      IMPOSTA I DATI MESE ELABORAZIONE
***********************************************************************************
FUNCTION CREA_CURSORE_DATI_MESE_ELABORAZIONE_SISPAC

AABBSS__    = SELECT()

M.AAAA 			= ANNO_CEDOLINO_PAGA_SISPAC 
M.MM 			= MESE_CEDOLINO_PAGA_SISPAC 
M.Annotazioni	= "" 
M.NUM_CEDOLINI 	= 0



** SERGIO 16/09/2010
M.TIPO_FATT   = " "
M.TIPO_ELAB	  = "M"
IF _V_OPZ_ELAB_MENSILITA_SISPAC
	M.TIPO_ELAB	  = "M"
ENDIF
IF _V_OPZ_ELAB_13_SISPAC
	M.TIPO_ELAB	  = "T"
ENDIF
IF _V_OPZ_ELAB_14_SISPAC
	M.TIPO_ELAB	  = "Q"
ENDIF
IF _V_OPZ_ELAB_BORSISTI_SISPAC
	M.TIPO_ELAB	  = "B"
ENDIF
IF _V_OPZ_ELAB_COCOPRO_SISPAC
	M.TIPO_ELAB	  = "C"
ENDIF
	
	



SELECT CU_CEDOLINI_DD
SET ORDER TO I_AAAAMM 
____SEEK = M.AAAA + M.MM
SEEK ____SEEK
IF !FOUND()
	APPEND BLANK
ENDIF


DO CEDOLINI_DD


SELECT(AABBSS__)

RETURN



					
******************************************
FUNCTION CERCA_RISORSA_ELABORABILE_SISPAC
******************************************
** LA FUNZIONE SI RIPOSIZIONA SULLA SUCCESSIVA
** RISORSA PER LA VERIFICA SULLA ELABORAZIONE 
** O MENO IN BASE ALLA TABELLA U_CLI_EX
    
    
	SELECT CED_SISPAC
	
	DO WHILE .NOT. EOF()

		SCATTER MEMVAR MEMO
		
		___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               

		DO CASE  && SCARTA I RECORD SINO ALLA PROSSIMA RISORSA ELABORABILE

			CASE substr(___WORD___,1,5) = "Ditta"			 

				SELECT CED_SISPAC
				SKIP +1
				
				___WORD1___ = APITOSPA(ALLTRIM(SUBSTR(RIGA,1,100)))               


				*!*	RICERCA CODICE CLIENTE AQUARIUS PASSANDO DAL CODICE CLIENTE SISPAC
 
			  	x_cond = "codcli_SISPAC = '" + ___WORD1___ + "'"
			  	cSql = "select * from u_cli_ex where " + x_cond + " order by codcli_SISPAC"
 
			  	IF !ExecCommand(cSql,"curs_cli_ex")
				  	return(.f.)
			  	ENDIF

			  	SELECT curs_cli_ex 
			  	IF RECCOUNT() = 0				&& CLIENTE NON TRATTATO DALLA PROCEDURA PAGHE SISPAC
					SELECT CED_SISPAC
					SKIP +1
					LOOP
			  	ELSE
			  	
					SELECT CED_SISPAC
					SKIP -1
                	RETURN	
                			  	
			  	ENDIF


                
                
		OTHERWISE 
				
				SELECT CED_SISPAC
				SKIP +1
				LOOP

		ENDCASE
					

	ENDDO WHILE .NOT. EOF()
	
	____FINE_ELABORAZIONE = .T.

RETURN

***********************************************************************************
*      IMPOSTA I DATI ANAGRAFICI DEL CLIENTE STUDIO
***********************************************************************************
FUNCTION DETERMINA_DATI_CLIENTE_STUDIO_SISPAC

AABBSS__    = SELECT()


SELECT curs_cli_ex 

M.CED_CODCLI  	= CODCLI_AQUARIUS
M.CED_DESCLI  	= RAGSOC_AQUARIUS 


SELECT(AABBSS__)

RETURN


***********************************************************************************
*      CERCA IL MESE DI ELABORAZIONE NEL CEDOLINO PAGA SISPAC
***********************************************************************************
FUNCTION CERCA_MESE_CEDOLINO_SISPAC


SELECT CED_SISPAC

AABBSS__    = SELECT()
__SONO_QUI=RECNO()

*!*	MI SPOSTO SUL RECORD PER PRELEVARE IL DEL MESE 
*!*	123456789-123456789-123456789-123456789-123456789-123456789-123456789-12Marzo     2010
SKIP +9



MESE_CEDOLINO_PAGA_SISPAC = UPPER(ALLTRIM(SUBSTR(RIGA,19,2)))
ANNO_CEDOLINO_PAGA_SISPAC = SUBSTR(RIGA,22,4)




GO __SONO_QUI
SELECT(AABBSS__)

RETURN

***********************************************************************************
*      CERCA I DATI ANAGRAFICI DELLA RISORSA
***********************************************************************************
FUNCTION CERCA_RISORSA_CEDOLINO_SISPAC

RELEASE M.Annotazioni
PUBLIC M.Annotazioni  
M.Annotazioni  = ""

SELECT CED_SISPAC

AABBSS__    = SELECT()
__SONO_QUI=RECNO()

SKIP +3


M.CED_NOMDIP1   = APITOSPA(UPPER(ALLTRIM(SUBSTR(RIGA,29,33))))
M.CED_NOMDIP2   = APITOSPA(UPPER(ALLTRIM(SUBSTR(RIGA,62,40))))
M.CED_NOMDIP   = M.CED_NOMDIP1 + " " + M.CED_NOMDIP2

M.ANNOTAZIONI  = ""

*!*	MI SPOSTO SUL RECORD PER PRELEVARE IL TIPO DI CONTRATTO
*!*	123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-12345
*!*	OPERAIO                             OPERAIA              3                             04 - OP.CONVITTO            
SKIP +2
*!*	M.CED_TIPOCO   = APITOSPA(UPPER(ALLTRIM(SUBSTR(RIGA,28,25))))
M.CED_TIPOCO   = UPPER(ALLTRIM(SUBSTR(RIGA,37,25)))


*!*	CERCA VOCI PAGA EXTRA CEDOLINO DA RIFATTURARE AL CLIENTE
=CERCA_VOCI_PAGA_SISPAC_EXTRA_CEDOLINO()	

SELECT CURS_CEDOLINI_DL 
SET ORDER TO I_KEYDIP 
____SEEK = M.CED_NOMDIP+M.CED_TIPOCO
SEEK ____SEEK
IF FOUND()
	IF !EMPTY(M.ANNOTAZIONI)
		IF EMPTY(ANNOTAZIONI)
			REPLACE ANNOTAZIONI WITH ALLTRIM(M.ANNOTAZIONI)
		ELSE
			M.ANNOTAZIONI = ALLTRIM(ANNOTAZIONI)+"-"+ALLTRIM(M.ANNOTAZIONI)
			REPLACE ANNOTAZIONI WITH ALLTRIM(M.ANNOTAZIONI)
		ENDIF 
	ENDIF 
ELSE
	APPEND BLANK
	REPLACE KEY_DIP 		WITH ____SEEK 
	DO CEDOLINI_DL
ENDIF


SELECT CED_SISPAC
GO __SONO_QUI
SELECT(AABBSS__)

RETURN

******************************************************************************************
*      ANALISI CEDOLINO PAGA SISPAC PER ESTRARRE LE VOCI PAGA DA RIFATTURARE AL CLIENTE
******************************************************************************************
FUNCTION CERCA_VOCI_PAGA_SISPAC_EXTRA_CEDOLINO


SELECT CED_SISPAC
*!*	MI SPOSTO SUL PRIMO RECORD CONTENETE I DETTAGLI VOCI PAGA PARTENDO DALLA RIGA DI TIPO CONTRATTO
*!*	123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-12345
*!*   **7001 Retribuzione                       9,07665    170,00000 ORE                 1.543,03
SKIP +9
 

__NUMERO_RIGHE_CEDOLINO_SISPAC = 100
FOR FF = 1 TO __NUMERO_RIGHE_CEDOLINO_SISPAC 


	__FINE_ELABORAZIONE_VOCI_PAGA_SISPAC = SUBSTR(RIGA,1,5)


	IF __FINE_ELABORAZIONE_VOCI_PAGA_SISPAC = "Ditta"
	   EXIT
	ENDIF
	

	__VOCE_CEDOLINO_SISPAC =  ALLTRIM(SUBSTR(RIGA,5,3))
	
	IF LEN(__VOCE_CEDOLINO_SISPAC) = 1
		__VOCE_CEDOLINO_SISPAC = "00"+__VOCE_CEDOLINO_SISPAC 
	ENDIF

	IF LEN(__VOCE_CEDOLINO_SISPAC) = 2
		__VOCE_CEDOLINO_SISPAC = "0"+__VOCE_CEDOLINO_SISPAC 
	ENDIF
		

   	v_seek  = 'CSI'+__VOCE_CEDOLINO_SISPAC
    v_chiave= "codice"
    cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
    IF !ExecCommand(cSql,"CU_PARA")
       return(.f.)
    ENDIF

	___ANNOTAZIONI = ""
	
    SELECT CU_PARA
    IF RECCOUNT() <> 0			&& VOCE CEDOLINO PAGA TROVATA QUINDI DA RIFATTURARE

		IF EMPTY(M.ANNOTAZIONI)
			M.ANNOTAZIONI  = __VOCE_CEDOLINO_SISPAC 
		ELSE
			M.ANNOTAZIONI  = M.ANNOTAZIONI + "-" + __VOCE_CEDOLINO_SISPAC 
		ENDIF
		
		**=> ERASMO - INIZIO 20/07/2010
		*** MEMORIZZO IN APPOSITA TABELLA LE ATTIVITA' SOGGETTE A POSSIBILE CREAZIONE DEL FATTURABILE
		IF _AGG_ATTIVEXCED
			IF "RIEPILOGO GENERALE" $ ALLTRIM(M.CED_NOMDIP)
			ELSE
				__DESCRIZIONE_VOCE = ALLTRIM(DESCRI)
				x_clie = "CODCLI = '" + ALLTRIM(M.CED_CODCLI) + "'"
				x_aamm = "AAAAMM = '" + _ANNOMESE + "'"
				x_atti = "CODATTIV = '" + ALLTRIM(__VOCE_CEDOLINO_SISPAC) + "'"
				*x_fatt = "FLGFATTURAB = 0"
				x_cond = x_clie + " and " + x_aamm + " and " + x_atti 
				cSql   = "select * from ATTIVEXCED where " + x_cond
				IF !ExecRW(cSql,'ATTIVEXCED','R')
				   return(.f.)
				ENDIF
				SELECT ATTIVEXCED
				GO TOP
				IF EOF()
					APPEND BLANK
					M.IDATTIVEXCED = SYS(2015)
					M.CODCLI = ALLTRIM(M.CED_CODCLI)
					M.RAGSOC = ALLTRIM(M.CED_DESCLI)
					M.AAAAMM = _ANNOMESE 
					M.CODATTIV = ALLTRIM(__VOCE_CEDOLINO_SISPAC)
					M.DESATTIV = __DESCRIZIONE_VOCE 
					M.NUMCED = 1
					M.ANNOTAZIONI = ALLTRIM(M.CED_NOMDIP)
					M.FLGFATTURAB = .F.
					DO ATTIVEXCED
				ELSE
					IF ALLTRIM(M.CED_NOMDIP) $ ANNOTAZIONI
					ELSE
						REPLACE NUMCED WITH NUMCED + 1
						REPLACE ANNOTAZIONI WITH ANNOTAZIONI + "; " + ALLTRIM(M.CED_NOMDIP)
					ENDIF
				ENDIF
				IF !ExecRW(cSql,'ATTIVEXCED','W')
				   return(.f.)
				ENDIF
			ENDIF
		ENDIF
		**=> ERASMO - FINE 20/07/2010
		
	ENDIF
	
	SELECT CED_SISPAC
	
	IF EOF()
		EXIT
	ENDIF
		
	SKIP +1

ENDFOR



RETURN



***********************************************************************************
*      IMPOSTA I DATI ANAGRAFICI DEL CLIENTE STUDIO
***********************************************************************************
FUNCTION CREA_CURSORE_DATI_CLIENTE_STUDIO_SISPAC

AABBSS__    = SELECT()



M.TAGGANCIO   	= SYS(2015)
M.DAGGANCIO   	= M.TAGGANCIO

M.DAGGANCIO_DL 	= SYS(2015)
M.DAGGANCIO_DD 	= M.DAGGANCIO_DL

M.ORAINS      	= ""
M.UTENTEINS   	= PUB_CODOPE 
M.DATAINS     	= DTOC(DATE())    


M.NOTE 			= ""		
M.UTENTEMOD 	= ""
M.DATAMOD 		= ""
M.ORAMOD 		= ""



SELECT CU_CEDOLINI
SET ORDER TO I_CODCLI
____SEEK = M.CED_CODCLI
SEEK ____SEEK
IF !FOUND()
	APPEND BLANK
ENDIF

DO CEDOLINI


SELECT(AABBSS__)

RETURN







***********************************************************************************
*      CANCELLA DATI MESE PRECEDENTEMETE ELABORATI
***********************************************************************************
FUNCTION CANCELLA_ELABORAZIONI_PRECEDENTI_SISPAC

*!*	CANCELLA IL MESE IN ELABORAZIONE

__ANNO= ANNO_CEDOLINO_PAGA_SISPAC 
__MESE= MESE_CEDOLINO_PAGA_SISPAC


** SERGIO 16/09/2010
__TIPO_ELAB= "M"
IF _V_OPZ_ELAB_MENSILITA_SISPAC
	__TIPO_ELAB= "M"
ENDIF
IF _V_OPZ_ELAB_13_SISPAC
	__TIPO_ELAB= "T"
ENDIF
IF _V_OPZ_ELAB_14_SISPAC
	__TIPO_ELAB= "Q"
ENDIF
IF _V_OPZ_ELAB_BORSISTI_SISPAC
	__TIPO_ELAB= "B"
ENDIF
IF _V_OPZ_ELAB_COCOPRO_SISPAC
	__TIPO_ELAB= "C"
ENDIF


*!*	CANCELLA RECORD CLIENTE
x_cond = "ced_codcli = '" + m.ced_codcli + "'"
cSql   = "delete from CEDOLINI where " + x_cond 
IF !ExecCommand(cSql,"CEDOLINI")
   return(.f.)
ENDIF




x_codc = "ced_codcli = '" + m.ced_codcli + "'"
x_aaaa = "AAAA = '" + __ANNO + "'"
x_mm = "MM = '" + __MESE + "'"

** SERGIO 16/09/2010
x_te = "tipo_elab = '" + __TIPO_ELAB + "'"
x_cond = x_codc + " and " + x_aaaa + " and " + x_mm + " and " + x_te

cSql   = "select * from CEDOLINI_DD where " + x_cond 
IF !ExecCommand(cSql,"CEDOLINI_DD")
   return(.f.)
ENDIF


SELECT CEDOLINI_DD
IF reccount() <> 0

	___DAGGANCIO    = DAGGANCIO
	___DAGGANCIO_DD = DAGGANCIO_DL	
	
	
	*!*	CANCELLA IL MESE IN ELABORAZIONE
	x_codc = "ced_codcli = '" + m.ced_codcli + "'"
	x_dagga = "DAGGANCIO = '" + ___daggancio + "'"
	x_cond = x_codc + " and " + x_dagga

	cSql   = "delete from CEDOLINI_DD where " + x_cond 
	IF !ExecCommand(cSql,"CEDOLINI_DD")
	   return(.f.)
	ENDIF

	*!*	CANCELLA IL DETTAGLI MESE
	x_codc = "ced_codcli = '" + m.ced_codcli + "'"
	x_dagga = "DAGGANCIO_DD = '" + ___daggancio_dd + "'"
	x_cond = x_codc + " and " + x_dagga

	cSql   = "delete from CEDOLINI_DL where " + x_cond 
	IF !ExecCommand(cSql,"CEDOLINI_DL")
	   return(.f.)
	ENDIF





ENDIF

   	

RETURN

***********************************************************************************
*      IMPOSTA LEGAME TRA CEDOLINI_DD E CEDOLINI_DL
***********************************************************************************
FUNCTION IMPOSTA_DAGGANCIO_DD_CURSORE_CEDOLINO_DL_SISPAC
AABBSS__    = SELECT()




SELECT SAVE_CU_CEDOLINI_DD 
SET ORDER TO I_AAAAMM  
GO TOP

DO WHILE .NOT.EOF()

	    
	SELECT SAVE_CU_CEDOLINI_DD 
	
	__DAGGANCIO_DD__ 	= DAGGANCIO_DL
	__CED_CODCLI__ 		= CED_CODCLI
	__CONTA_QUANTI_CEDOLINI_SONO_STATI_ELABORATI = 0
	
	
	SELECT SAVE_CU_CEDOLINI_DL
	SET FILTER TO ALLTRIM(__CED_CODCLI__) = ALLTRIM(CED_CODCLI)
	GO TOP
	DO WHILE .NOT.EOF()
	
	
		REPLACE DAGGANCIO_DD WITH __DAGGANCIO_DD__  
	    __CONTA_QUANTI_CEDOLINI_SONO_STATI_ELABORATI = __CONTA_QUANTI_CEDOLINI_SONO_STATI_ELABORATI + 1


		SELECT SAVE_CU_CEDOLINI_DL
		SKIP +1
		
	
	ENDDO


	SELECT SAVE_CU_CEDOLINI_DL
	SET FILTER TO 	

	*!*	    CONTROAGGIORNA LA TABELLA ELAB_MENS 

    SELECT CU_ELAB_MENS
    SET ORDER TO I_CODCLI  
    V_SEEK  	= __CED_CODCLI__
    SEEK V_SEEK  
    IF FOUND()
         REPLACE NUM_CEDOLINI WITH __CONTA_QUANTI_CEDOLINI_SONO_STATI_ELABORATI 
    ENDIF

	SELECT SAVE_CU_CEDOLINI_DD 
	REPLACE NUM_CEDOLINI WITH __CONTA_QUANTI_CEDOLINI_SONO_STATI_ELABORATI 
	SKIP +1
	
ENDDO


SELECT SAVE_CU_CEDOLINI_DL
SET FILTER TO 


SELECT(AABBSS__)

RETURN


***********************************************************************************
*      CREAZIONE DEI CURSORI A LIVELLO DI CLIENTE STUDIO
***********************************************************************************
FUNCTION SCRIVE_CURSORI_A_LIVELLO_DI_CLIENTE_STUDIO_SISPAC
AABBSS__    = SELECT()




	*!*	AGGIORNAMENTO TABELLE CEDOLINI
	* -------------------------------- 

   	IF !ExecRW('','CEDOLINI','I','','SAVE_CU_CEDOLINI')		&& INSERISCE LA TABELLA CEDOLINO PER LA PRIMA VOLTA
	   return(.f.)
   	ENDIF
	
   	IF !ExecRW('','CEDOLINI_DD','I','','SAVE_CU_CEDOLINI_DD')
	   return(.f.)
   	ENDIF

   	IF !ExecRW('','CEDOLINI_DL','I','','SAVE_CU_CEDOLINI_DL')
	   return(.f.)
   	ENDIF


   	
	**=> ERASMO - INIZIO 13/07/2010
	IF _AGG_CONTRSTUDI
		
		WAIT WINDOWS "Aggiornamento dettagli contratti in corso..." NOWAIT
		
		SELECT SAVE_CU_CEDOLINI_DD
		GO TOP
		SCAN
			_NUM_CEDOLINI = NUM_CEDOLINI
			__CED_CODCLI = ALLTRIM(CED_CODCLI)
			x_clie = "contrstudi.CODCLI = '" + ALLTRIM(CED_CODCLI) + "'"	
			x_aamm = "contrst_dl.AAAAMM = '" + ALLTRIM(AAAA) + "/" + ALLTRIM(MM) + "'"
			x_unim = "contrst_dl.UMRICAVO = 'NR'"	
			x_cond = x_clie + " and " + x_aamm + " and " + x_unim
			Csql =  "select codcli,ragsoc,codattiv,desattiv,numero,data,taggancio,* from contrst_dl " + ;
					"left outer join contrst_dd on contrst_dd.daggancio = contrst_dl.daggancio and contrst_dd.idattivita = contrst_dl.idattivita " + ;
					"left outer join contrstudi on contrstudi.taggancio = contrst_dl.daggancio where " + x_cond + "order by codcli,codattiv "
			IF !ExecCommand(cSql,'CX_CONTRST_DL')
			   return(.f.)
			ENDIF
			SELECT CX_CONTRST_DL
			GO TOP
			SCAN
			
				** SERGIO 16/09/2010 
				__TIPO_ELAB= "M"
				IF _V_OPZ_ELAB_MENSILITA_SISPAC
					__TIPO_ELAB= "M"
				ENDIF
				IF _V_OPZ_ELAB_13_SISPAC
					__TIPO_ELAB= "T"
				ENDIF
				IF _V_OPZ_ELAB_14_SISPAC
					__TIPO_ELAB= "Q"
				ENDIF
*!*					IF _V_OPZ_ELAB_BORSISTI_SISPAC
*!*						__TIPO_ELAB= "B"
*!*					ENDIF
*!*					IF _V_OPZ_ELAB_COCOPRO_SISPAC
*!*						__TIPO_ELAB= "C"
*!*					ENDIF
			
				x_codi = "IDATTIVITA = '" + IDATTIVITA + "'"
				x_mese = "AAAAMM = '" + AAAAMM + "'"
				x_te = "tipo_elab = '" + __TIPO_ELAB + "'"				
				x_cond = x_codi + " and " + x_mese + " and " + x_te
			
				Csql = "select * from CONTRST_DL where " + x_cond
				IF !ExecRW(cSql,"CONTRST_DL","R")
				   return(.f.)
				ENDIF
				IF !EOF()
				    _NUM_CEDOLINI_RICALCOLATO = 0 
				    =RAGGRUPPA_CEDOLINI_DD_PER_CLIENTE_AAAA_MM_SISPAC()
				    SELECT CONTRST_DL
					REPLACE QTARICAVO WITH _NUM_CEDOLINI_RICALCOLATO  && CONTIENE IL TOTALE DEI CEDOLINI MENSILI+COCOPRO+BORSISTI ...... ESCLUSO TREDICESIMA E QUATTORDICESIMA
					REPLACE QTACOSTO  WITH _NUM_CEDOLINI_RICALCOLATO  && CONTIENE IL TOTALE DEI CEDOLINI MENSILI+COCOPRO+BORSISTI ...... ESCLUSO TREDICESIMA E QUATTORDICESIMA
				ENDIF
				IF !ExecRW(cSql,"CONTRST_DL","W")
				   return(.f.)
				ENDIF
				
			ENDSCAN
			
			SELECT DISTINCT NUMERO,DATA,TAGGANCIO FROM CX_CONTRST_DL INTO CURSOR TMP_CONTRATTI
			
			SELECT TMP_CONTRATTI
			GO TOP
			SCAN
			
			   WAIT WINDOWS "Aggiornamento contratto n° " + ALLTRIM(NUMERO) + " del " + RIBALTA2(DATA) NOWAIT
			   
			   *!*	ACCEDE AL II LIVELLO PER ELABORARE OGNI SINGOLA ATTIVITA'
			
			   x_codi = "DAGGANCIO = '" + TAGGANCIO + "'"
			   x_cond = x_codi
			   cSql = "select * from CONTRST_DD where " + x_cond
			   IF !ExecCommand(cSql,"CU_CONTRST_DD")
				  return(.f.)
			   ENDIF
			   SELECT CU_CONTRST_DD
			   GO TOP
			   SCAN

					*!*	ACCEDE AL III LIVELLO PER ELABORARE I MESI PREVISTI ED EFFETTUA IL CALCOLO COSTI/RICAVI/UTILI
					x_codi = "DAGGANCIO = '" + DAGGANCIO + "'"
					x_atti = "IDATTIVITA = '" + IDATTIVITA + "'" 
					x_cond = x_codi + " and " + x_atti
					cSql = "select * from CONTRST_DL where " + x_cond
					IF !ExecCommand(cSql,"CU_CONTRST_DL")
					  return(.f.)
					ENDIF

					
					VSP_VAL_COSTO  = 0
					VSP_VAL_RICAVO = 0
					VSP_VAL_UTILE  = 0
					
					
					DO CALCOLO_TOTALE_DELLA_ATTIVITA_CORRENTE  WITH "CU_CONTRST_DL",.T.
					
					*!*	AGGIORNA IL DATA BASE DELLE ATTIVITA' A III LIVELLO
					IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
						return(.f.)
					ENDIF

					SELECT CU_CONTRST_DD	&& aggiorna il totale calcolato della attività corrente sul cursore tabella attività di II livello
					
					REPLACE ValCosto 	WITH VSP_VAL_COSTO
					REPLACE ValRicavo 	WITH VSP_VAL_RICAVO
					REPLACE ValUtile 	WITH VSP_VAL_UTILE


			   ENDSCAN

			   *!*	AGGIORNA IL DATA BASE DELLE ATTIVITA' A II LIVELLO
			   
			   IF !ExecRW('','CONTRST_DD','I','','CU_CONTRST_DD')
				   return(.f.)
			   ENDIF
			
			ENDSCAN
			
		ENDSCAN
		
	ENDIF
	**=> ERASMO - FINE 13/07/2010

    _TOT_CLIENTI = _TOT_CLIENTI + 1
	        
	* -->> Creazione cursore vuoto di testata cedolino I livello
	* -----------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI where 0=1","CU_CEDOLINI")
	  return(.f.)
	ENDIF
	SELECT CU_CEDOLINI
	INDEX ON CED_CODCLI TAG I_CODCLI 
	SET ORDER TO I_CODCLI 


	* -->> Creazione cursore vuoto di dettaglio cedolino II livello
	* --------------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI_DD where 0=1","CU_CEDOLINI_DD")
	  return(.f.)
	ENDIF
	SELECT CU_CEDOLINI_DD
	INDEX ON DAGGANCIO TAG I_DAGGA  
	INDEX ON AAAA + MM TAG I_AAAAMM  
	SET ORDER TO I_AAAAMM


	* -->> Creazione cursore vuoto di dettaglio cedolino III livello
	* ---------------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI_DL where 0=1","CU_CEDOLINI_DL")
	  return(.f.)
	ENDIF
	SELECT CU_CEDOLINI_DL
	INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
	INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
	INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE 
	SET ORDER TO I_NOMDIP 



	* -->> Creazione cursore vuoto per caricare il terzo livello
	* --------------------------------------------------------------
	CREATE CURSOR CURS_CEDOLINI_DL ;
	       (KEY_DIP C(100),    DAGGANCIO_DD C(10),   CED_CODCLI C(10),      CED_NOMDIP C(50),   CED_CODCON C(3),   CED_TIPOCO C(25),     ;
	        Annotazioni C(250))
	INDEX ON KEY_DIP 				TAG I_KEYDIP ADDITIVE
	INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
	INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
	INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE
	SET ORDER TO I_KEYDIP 



	* -->> Creazione cursore vuoto di testata cedolino I livello
	* -----------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI where 0=1","____CU_CEDOLINI")
	  return(.f.)
	ENDIF
	SELECT ____CU_CEDOLINI
	AA = AFIELDS(BB)
	CREATE CURSOR SAVE_CU_CEDOLINI FROM ARRAY BB	
	INDEX ON CED_CODCLI TAG I_CODCLI 
	SET ORDER TO I_CODCLI 




	* -->> Creazione cursore vuoto di dettaglio cedolino II livello
	* --------------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI_DD where 0=1","____CU_CEDOLINI_DD")
	  return(.f.)
	ENDIF
	SELECT ____CU_CEDOLINI_DD
	AA = AFIELDS(BB)
	CREATE CURSOR SAVE_CU_CEDOLINI_DD FROM ARRAY BB	
	INDEX ON DAGGANCIO TAG I_DAGGA  
	INDEX ON AAAA + MM TAG I_AAAAMM  
	SET ORDER TO I_AAAAMM



	* -->> Creazione cursore vuoto di dettaglio cedolino III livello
	* ---------------------------------------------------------------
	IF !ExecCommand("select * from CEDOLINI_DL where 0=1","____CU_CEDOLINI_DL")
	  return(.f.)
	ENDIF
	SELECT ____CU_CEDOLINI_DL
	AA = AFIELDS(BB)
	CREATE CURSOR SAVE_CU_CEDOLINI_DL FROM ARRAY BB	
	INDEX ON CED_NOMDIP 			TAG I_NOMDIP ADDITIVE
	INDEX ON CED_NOMDIP+CED_TIPOCO 	TAG I_TIPOCO ADDITIVE
	INDEX ON CED_CODCLI 			TAG I_CODCCL ADDITIVE 
	SET ORDER TO I_NOMDIP 


SELECT(AABBSS__)

RETURN


***********************************************************************************
*      CREA TABELLA CEDOLINO_DL SISPAC
***********************************************************************************
FUNCTION CREA_CEDOLINO_DL_SISPAC
AABBSS__    = SELECT()


SELECT CURS_CEDOLINI_DL
SET ORDER TO I_CODCCL 
GO TOP
DO WHILE .NOT.EOF()

	    
	SELECT CU_CEDOLINI_DL
	APPEND BLANK
	DO CURS_CEDOLINI_DL

	SELECT CURS_CEDOLINI_DL
	SKIP +1
	
ENDDO



**************************************************
FUNCTION CONTROLLI_INCROCIATI_SUL_CEDOLINO_SISPAC
**************************************************



	IF !_V_OPZ_ELAB_14_SISPAC 
		___VERIFICA_MESE_SISPAC = .T.
		=CONTROLLO_MESE_SUL_CEDOLINO_SISPAC()
	    IF !___VERIFICA_MESE_SISPAC 
	    	___VERIFICHE_INCROCIATE_SISPAC = .F.
	    	RETURN
	    ENDIF
	ENDIF




	IF _V_OPZ_ELAB_MENSILITA_SISPAC
		___VERIFICA_ELAB_MENSILITA_SISPAC = .T.
		=CONTROLLO_MENSILITA_SUL_CEDOLINO_SISPAC()
		IF !___VERIFICA_ELAB_MENSILITA_SISPAC 
	    	___VERIFICHE_INCROCIATE_SISPAC = .F.
	    	RETURN
		ENDIF
	ENDIF	
	
		
	IF _V_OPZ_ELAB_13_SISPAC
		___VERIFICA_ELAB_13MA_14MA_SISPAC = .F.
		=CONTROLLO_13MA_14MA_SUL_CEDOLINO_SISPAC()
		IF !___VERIFICA_ELAB_13MA_14MA_SISPAC 
	    	___VERIFICHE_INCROCIATE_SISPAC = .F.
	    	RETURN
		ENDIF
	ENDIF	
	
	IF _V_OPZ_ELAB_14_SISPAC
		___VERIFICA_ELAB_13MA_14MA_SISPAC = .F.
		=CONTROLLO_13MA_14MA_SUL_CEDOLINO_SISPAC()
		IF !___VERIFICA_ELAB_13MA_14MA_SISPAC 
	    	___VERIFICHE_INCROCIATE_SISPAC = .F.
	    	RETURN
		ENDIF
	ENDIF	
	
				


	IF _V_OPZ_ELAB_COCOPRO_SISPAC
		___VERIFICA_ELAB_COCOPRO_SISPAC = .T.
		=CONTROLLO_COCOPRO_SUL_CEDOLINO_SISPAC()
		IF !___VERIFICA_ELAB_COCOPRO_SISPAC 
	    	___VERIFICHE_INCROCIATE_SISPAC = .F.
	    	RETURN
		ENDIF
	ENDIF	
	
		


RETURN




*******************************************
FUNCTION CONTROLLO_MESE_SUL_CEDOLINO_SISPAC
*******************************************

RELEASE ____FINE_ELABORAZIONE
PUBLIC ____FINE_ELABORAZIONE
____FINE_ELABORAZIONE = .F.


SELECT CED_SISPAC
GO TOP


DO WHILE .NOT. EOF()
	
	
	IF EOF()
		EXIT
	ENDIF
	
	
	SCATTER MEMVAR MEMO
	
	___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               


	____FINE_ELABORAZIONE = .F.
    =CERCA_RISORSA_ELABORABILE_SISPAC()
    
    IF ____FINE_ELABORAZIONE 
    	EXIT
    ENDIF

    

	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

    SELECT CED_SISPAC
    
  	=DETERMINA_DATI_CLIENTE_STUDIO_SISPAC()
 		
  	=CERCA_MESE_CEDOLINO_SISPAC()
  	    
  	IF VAL(MESE_CEDOLINO_PAGA_SISPAC) > 0 AND VAL(MESE_CEDOLINO_PAGA_SISPAC) < 13
  	ELSE
  		___VERIFICA_MESE_SISPAC = .F.
  		=MESSAGEB("FILE CEDOLINI PAGA SISPAC NON CORRETTI ?? : INTERROMPO L'ELABORAZIONE",16,"*** ATTENZIONE ***")
  		SET DEFA TO &PUB_DIR
  		RETURN
  	ENDIF
  	
  	IF VAL(MESE_CEDOLINO_PAGA_SISPAC) == VAL(SUBSTR(_ANNOMESE,6,2)) .AND. VAL(ANNO_CEDOLINO_PAGA_SISPAC) == VAL(SUBSTR(_ANNOMESE,1,4))
  	ELSE
  		___VERIFICA_MESE_SISPAC = .F.
		MESSAGEBOX("Verificare che il mese selezionato corrisponda a quello dei cedolini contenuti nel file selezionato" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione dei cedolini",48,"Attenzione")
		RETURN
  	ENDIF
  	
  	
	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

  	

	SELECT CED_SISPAC
	SKIP +1
	
ENDDO


RETURN


************************************************
FUNCTION CONTROLLO_MENSILITA_SUL_CEDOLINO_SISPAC
************************************************

RELEASE ____FINE_ELABORAZIONE
PUBLIC ____FINE_ELABORAZIONE
____FINE_ELABORAZIONE = .F.

SELECT CED_SISPAC
GO TOP

DO WHILE .NOT. EOF()
	
	IF EOF()
		EXIT
	ENDIF

	SCATTER MEMVAR MEMO
	
	___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               


	____FINE_ELABORAZIONE = .F.
    =CERCA_RISORSA_ELABORABILE_SISPAC()
    
    IF ____FINE_ELABORAZIONE 
    	EXIT
    ENDIF

	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

    SELECT CED_SISPAC
    
  	SKIP +5 && MI POSIZIONO SULLA RIGA DICITURA COLLABORATORE
  
  	IF SUBSTR(RIGA,4,13) = "COLLABORATORE"
  		___VERIFICA_ELAB_MENSILITA_SISPAC = .F.
		MESSAGEBOX("Hai selezionato un file cedolini CON CONTRATTI A PROGETTO SISPAC !!!" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione dei cedolini",48,"Attenzione")
		RETURN
  	ENDIF
 
	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

  	

	SELECT CED_SISPAC
	SKIP +1
	
ENDDO


**********************************************
FUNCTION CONTROLLO_COCOPRO_SUL_CEDOLINO_SISPAC
**********************************************

RELEASE ____FINE_ELABORAZIONE
PUBLIC ____FINE_ELABORAZIONE
____FINE_ELABORAZIONE = .F.

SELECT CED_SISPAC
GO TOP

DO WHILE .NOT. EOF()
	
	IF EOF()
		EXIT
	ENDIF

	SCATTER MEMVAR MEMO
	
	___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               


	____FINE_ELABORAZIONE = .F.
    =CERCA_RISORSA_ELABORABILE_SISPAC()
    
    IF ____FINE_ELABORAZIONE 
    	EXIT
    ENDIF

	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

    SELECT CED_SISPAC
    
  	SKIP +5 && MI POSIZIONO SULLA RIGA DICITURA COLLABORATORE
  
  	IF SUBSTR(RIGA,4,13) <> "COLLABORATORE"
  		___VERIFICA_ELAB_COCOPRO_SISPAC = .F.
		MESSAGEBOX("Hai selezionato un file cedolini senza CONTRATTI A PROGETTO SISPAC !!!" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione dei cedolini",48,"Attenzione")
		RETURN
  	ENDIF
 
	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

  	

	SELECT CED_SISPAC
	SKIP +1
	
ENDDO

************************************************
FUNCTION CONTROLLO_13MA_14MA_SUL_CEDOLINO_SISPAC
************************************************

RELEASE ____FINE_ELABORAZIONE
PUBLIC ____FINE_ELABORAZIONE
____FINE_ELABORAZIONE = .F.

SELECT CED_SISPAC
GO TOP

___VERIFICA_ELAB_13MA_14MA_SISPAC = .F.
		
DO WHILE .NOT. EOF()
	
	IF EOF()
		EXIT
	ENDIF

	SCATTER MEMVAR MEMO
	
	___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               


	____FINE_ELABORAZIONE = .F.
    =CERCA_RISORSA_ELABORABILE_SISPAC()
    
    IF ____FINE_ELABORAZIONE 
    	EXIT
    ENDIF



*!*	   SELECT CED_SISPAC
*!*	   SKIP +3
*!*		___RISORSA___ = APITOSPA(ALLTRIM(SUBSTR(RIGA,1,100)))      
*!*	   IF ___RISORSA___ = "0000000015\        15    MAGA                             ELENA RITA"
*!*			SET STEP ON
*!*	   ENDIF   
*!*	   SKIP -3
 

	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################


	=CERCA_13MA_14MA_CEDOLINO_SISPAC()
	IF ___VERIFICA_ELAB_13MA_14MA_SISPAC 	
	  EXIT
	ENDIF 
	

	*!*	############################################### FUNZIONI DI DETTAGLIO ####################################################

  	

	IF EOF()
		EXIT
	ENDIF	


	SELECT CED_SISPAC
	SKIP +1
	
ENDDO



IF _V_OPZ_ELAB_13_SISPAC
   	IF !___VERIFICA_ELAB_13MA_14MA_SISPAC  
		MESSAGEBOX("Hai selezionato un file SISPAC SENZA CEDOLINI 13ma !!!" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione dei cedolini",48,"Attenzione")
		RETURN
  	ENDIF
ENDIF 
 
IF _V_OPZ_ELAB_14_SISPAC
   	IF !___VERIFICA_ELAB_13MA_14MA_SISPAC  
		MESSAGEBOX("Hai selezionato un file SISPAC SENZA CEDOLINI 14ma !!!" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione dei cedolini",48,"Attenzione")
		RETURN
  	ENDIF
ENDIF 
  


RETURN



*********************************************************
*      CERCA LA VOCE PAGA 13MA / 14MA NEL CEDOLINO SISPAC
*********************************************************
FUNCTION CERCA_13MA_14MA_CEDOLINO_SISPAC



SELECT CED_SISPAC
SKIP +15



__NUMERO_RIGHE_CEDOLINO_SISPAC = 100
FOR FF = 1 TO __NUMERO_RIGHE_CEDOLINO_SISPAC 


	__FINE_ELABORAZIONE_VOCI_PAGA_SISPAC = SUBSTR(RIGA,1,5)


	IF __FINE_ELABORAZIONE_VOCI_PAGA_SISPAC = "Ditta"
	   EXIT
	ENDIF
	

	__VOCE_CEDOLINO_SISPAC =  ALLTRIM(SUBSTR(RIGA,5,3))
	
	
	IF _V_OPZ_ELAB_13_SISPAC		
		IF __VOCE_CEDOLINO_SISPAC = "13M"
			___VERIFICA_ELAB_13MA_14MA_SISPAC = .T.
			RETURN
		ENDIF
	ENDIF
	
	IF _V_OPZ_ELAB_14_SISPAC		
		IF __VOCE_CEDOLINO_SISPAC = "14M"
			___VERIFICA_ELAB_13MA_14MA_SISPAC = .T.
			RETURN
		ENDIF
	ENDIF
		

	SELECT CED_SISPAC
	
	IF EOF()
		EXIT
	ENDIF
		
	SKIP +1
	
	

ENDFOR




RETURN

****************************************************
FUNCTION CONTROLLI_INCROCIATI_SUL_CEDOLINO_ZUCCHETTI
****************************************************


*!*		IF !_V_OPZ_ELAB_14_ZUCCHETTI 
*!*			___VERIFICA_MESE_ZUCCHETTI = .T.
*!*			=CONTROLLO_MESE_SUL_CEDOLINO_ZUCCHETTI()
*!*		    IF !___VERIFICA_MESE_ZUCCHETTI 
*!*		    	___VERIFICHE_INCROCIATE_ZUCCHETTI = .F.
*!*		    	RETURN
*!*		    ENDIF
*!*		ENDIF



	IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
		___VERIFICA_ELAB_MENSILITA_ZUCCHETTI = .T.
		=CONTROLLO_MENSILITA_SUL_CEDOLINO_ZUCCHETTI()
		IF !___VERIFICA_ELAB_MENSILITA_ZUCCHETTI 
	    	___VERIFICHE_INCROCIATE_ZUCCHETTI = .F.
	    	RETURN
		ENDIF
	ENDIF	
	
	
		
	IF _V_OPZ_ELAB_13_ZUCCHETTI
		___VERIFICA_ELAB_13MA_14MA_ZUCCHETTI = .F.
		=CONTROLLO_13MA_14MA_SUL_CEDOLINO_ZUCCHETTI()
		IF !___VERIFICA_ELAB_13MA_14MA_ZUCCHETTI 
	    	___VERIFICHE_INCROCIATE_ZUCCHETTI = .F.
	    	RETURN
		ENDIF
	ENDIF	
	


	IF _V_OPZ_ELAB_14_ZUCCHETTI
		___VERIFICA_ELAB_13MA_14MA_ZUCCHETTI = .F.
		=CONTROLLO_13MA_14MA_SUL_CEDOLINO_ZUCCHETTI()
		IF !___VERIFICA_ELAB_13MA_14MA_ZUCCHETTI 
	    	___VERIFICHE_INCROCIATE_ZUCCHETTI = .F.
	    	RETURN
		ENDIF
	ENDIF	
	
				




RETURN


**********************************************
FUNCTION CONTROLLO_MESE_SUL_CEDOLINO_ZUCCHETTI
**********************************************
** LA FUNZIONE CERCA IL MESE DI ELABORAZIONE 
** E LO VERIFICA CON IL MESE SELEZIONATO :
** LA VERIFICA E' FATTA SOLO SUL PRIMO 
** CEDOLINO ELABORABILE
    
    
SELECT CED_ZUCCHETTI
GO TOP


DO WHILE .NOT. EOF()

	SCATTER MEMVAR MEMO
	
	___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               


  	IF EMPTY(___WORD___)
		SELECT CED_ZUCCHETTI
		SKIP +1
		LOOP
  	ENDIF
  	  	


	*!*	RICERCA CODICE CLIENTE AQUARIUS PASSANDO DAL CODICE CLIENTE ZUCCHETTI
 
  	x_cond = "codcli_ZUCCHETTI = '" + ___WORD___ + "'"
  	cSql = "select * from u_cli_ex where " + x_cond + " order by codcli_ZUCCHETTI"
 
  	IF !ExecCommand(cSql,"curs_cli_ex")
	  	return(.f.)
  	ENDIF

  	SELECT curs_cli_ex 
  	IF RECCOUNT() = 0				&& CLIENTE NON TRATTATO DALLA PROCEDURA PAGHE ZUCCHETTI
		SELECT CED_ZUCCHETTI
		SKIP +1
		LOOP
  	ENDIF
  	  	
  	
	SELECT CED_ZUCCHETTI			&& MI POSIZIONE SULLA RIGA DEL MESE
	SKIP +6



	MESE_CEDOLINO_PAGA = UPPER(ALLTRIM(SUBSTR(RIGA,73,10)))
	ANNO_CEDOLINO_PAGA_ZUCCHETTI = SUBSTR(RIGA,83,4)



	IF MESE_CEDOLINO_PAGA = "GENNAIO"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "01"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "FEBBRAIO"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "02"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "MARZO"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "03"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "APRILE"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "04"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "MAGGIO"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "05"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "GIUGNO"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "06"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "LUGLIO"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "07"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "AGOSTO"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "08"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "SETTEMBRE"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "09"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "OTTOBRE"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "10"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "NOVEMBRE"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "11"
	ENDIF

	IF MESE_CEDOLINO_PAGA = "DICEMBRE"
		MESE_CEDOLINO_PAGA_ZUCCHETTI = "12"
	ENDIF


  	IF VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) > 0 AND VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) < 13
  	ELSE
  		___VERIFICA_MESE_ZUCCHETTI = .F.
  		=MESSAGEB("FILE CEDOLINI PAGA ZUCCHETTI NON CORRETTI ?? : INTERROMPO L'ELABORAZIONE",16,"*** ATTENZIONE ***")
  		SET DEFA TO &PUB_DIR
  		EXIT
  	ENDIF
  	
  	IF VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) == VAL(SUBSTR(_ANNOMESE,6,2)) .AND. VAL(ANNO_CEDOLINO_PAGA_ZUCCHETTI) == VAL(SUBSTR(_ANNOMESE,1,4))
  	ELSE
  		___VERIFICA_MESE_ZUCCHETTI = .F.
		MESSAGEBOX("Verificare che il mese selezionato corrisponda a quello dei cedolini contenuti nel file selezionato" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione dei cedolini",48,"Attenzione")
		SET DEFA TO &PUB_DIR
		EXIT
  	ENDIF
  	
 

	SKIP -6
	
	
	EXIT

ENDDO WHILE .NOT. EOF()



RETURN


***************************************************
FUNCTION CONTROLLO_MENSILITA_SUL_CEDOLINO_ZUCCHETTI
***************************************************
** LA FUNZIONE CERCA IL MESE DI ELABORAZIONE 
** E LO VERIFICA CON IL MESE SELEZIONATO :
** LA VERIFICA E' FATTA SOLO SUL PRIMO 
** CEDOLINO ELABORABILE
    
    
SELECT CED_ZUCCHETTI

GO TOP
___VERIFICA_ELAB_MENSILITA_ZUCCHETTI = .T.

DO WHILE .NOT. EOF()

	SCATTER MEMVAR MEMO
	
	___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               


  	IF EMPTY(___WORD___)
		SELECT CED_ZUCCHETTI
		SKIP +1
		LOOP
  	ENDIF
  	  	


	*!*	RICERCA CODICE CLIENTE AQUARIUS PASSANDO DAL CODICE CLIENTE ZUCCHETTI
 
  	x_cond = "codcli_ZUCCHETTI = '" + ___WORD___ + "'"
  	cSql = "select * from u_cli_ex where " + x_cond + " order by codcli_ZUCCHETTI"
 
  	IF !ExecCommand(cSql,"curs_cli_ex")
	  	return(.f.)
  	ENDIF

  	SELECT curs_cli_ex 
  	IF RECCOUNT() = 0				&& CLIENTE NON TRATTATO DALLA PROCEDURA PAGHE ZUCCHETTI
		SELECT CED_ZUCCHETTI
		SKIP +1
		LOOP
  	ENDIF
  	  	
  	
	SELECT CED_ZUCCHETTI			&& MI POSIZIONE SULLA RIGA DEL MESE
    SKIP +1
    

	__NUMERO_RIGHE_CEDOLINO_ZUCCHETTI = 100
	FOR FF = 1 TO __NUMERO_RIGHE_CEDOLINO_ZUCCHETTI 
		__VOCE_CEDOLINO_ZUCCHETTI =  ALLTRIM(SUBSTR(RIGA,1,14))
		IF __VOCE_CEDOLINO_ZUCCHETTI = "**8822 14ma"
			___VERIFICA_ELAB_MENSILITA_ZUCCHETTI = .F.
			EXIT
		ENDIF
		SELECT CED_ZUCCHETTI
		SKIP +1
		IF EOF()
			EXIT
		ENDIF
	ENDFOR



  	IF !___VERIFICA_ELAB_MENSILITA_ZUCCHETTI 
  		=MESSAGEB("HAI SELEZIONATO UN FILE CONTENETE VOCE 13ma o 14ma ?? : INTERROMPO L'ELABORAZIONE",16,"*** ATTENZIONE ***")
  		SET DEFA TO &PUB_DIR
  		EXIT
  	ENDIF
  	
 
	EXIT

ENDDO WHILE .NOT. EOF()



RETURN


***************************************************
FUNCTION CONTROLLO_13MA_14MA_SUL_CEDOLINO_ZUCCHETTI
***************************************************
** LA FUNZIONE CERCA IL MESE DI ELABORAZIONE 
** E LO VERIFICA CON IL MESE SELEZIONATO :
** LA VERIFICA E' FATTA SOLO SUL PRIMO 
** CEDOLINO ELABORABILE
    
    
SELECT CED_ZUCCHETTI

GO TOP
___VERIFICA_ELAB_13MA_14MA_ZUCCHETTI = .F.

DO WHILE .NOT. EOF()

	SCATTER MEMVAR MEMO
	
	___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,100)))               


  	IF EMPTY(___WORD___)
		SELECT CED_ZUCCHETTI
		SKIP +1
		LOOP
  	ENDIF
  	  	


	*!*	RICERCA CODICE CLIENTE AQUARIUS PASSANDO DAL CODICE CLIENTE ZUCCHETTI
 
  	x_cond = "codcli_ZUCCHETTI = '" + ___WORD___ + "'"
  	cSql = "select * from u_cli_ex where " + x_cond + " order by codcli_ZUCCHETTI"
 
  	IF !ExecCommand(cSql,"curs_cli_ex")
	  	return(.f.)
  	ENDIF

  	SELECT curs_cli_ex 
  	IF RECCOUNT() = 0				&& CLIENTE NON TRATTATO DALLA PROCEDURA PAGHE ZUCCHETTI
		SELECT CED_ZUCCHETTI
		SKIP +1
		LOOP
  	ENDIF
  	  	
  	
	SELECT CED_ZUCCHETTI			&& MI POSIZIONE SULLA RIGA DEL MESE
    SKIP +1
    

	__NUMERO_RIGHE_CEDOLINO_ZUCCHETTI = 100
	FOR FF = 1 TO __NUMERO_RIGHE_CEDOLINO_ZUCCHETTI 
		__VOCE_CEDOLINO_ZUCCHETTI 		=  ALLTRIM(SUBSTR(RIGA,1,14))
		__VOCE_CEDOLINO_ZUCCHETTI_13ma 	=  ALLTRIM(SUBSTR(RIGA,11,04))		
		*!*	IF __VOCE_CEDOLINO_ZUCCHETTI = "**8800 13ma" .OR. __VOCE_CEDOLINO_ZUCCHETTI = "**8822 13ma" .OR. __VOCE_CEDOLINO_ZUCCHETTI = "**8822 14ma"
		*!*	a dicembre 2011 la voce 13ma è **8800 13ma
		IF __VOCE_CEDOLINO_ZUCCHETTI_13ma = "13ma" .OR. __VOCE_CEDOLINO_ZUCCHETTI = "**8822 14ma"
			___VERIFICA_ELAB_13MA_14MA_ZUCCHETTI = .T.
			EXIT
		ENDIF
		SELECT CED_ZUCCHETTI
		SKIP +1
		IF EOF()
			EXIT
		ENDIF
	ENDFOR



  	IF !___VERIFICA_ELAB_13MA_14MA_ZUCCHETTI 
  		=MESSAGEB("HAI SELEZIONATO UN FILE SENZA VOCI PAGA 13ma o 14ma ?? : INTERROMPO L'ELABORAZIONE",16,"*** ATTENZIONE ***")
  		SET DEFA TO &PUB_DIR
  		EXIT
  	ENDIF
  	
 
	EXIT

ENDDO WHILE .NOT. EOF()



RETURN


*********************************************************
FUNCTION RAGGRUPPA_CEDOLINI_DD_PER_CLIENTE_AAAA_MM_SISPAC
*********************************************************

IF _V_OPZ_ELAB_13_SISPAC OR _V_OPZ_ELAB_14_SISPAC
	_NUM_CEDOLINI_RICALCOLATO  = _NUM_CEDOLINI		&& MANTIENE IL TOTALE DEI CEDOLINI RELATIVI ALLA 13ma o14ma MENSILITA'
	RETURN
ENDIF 

__campi__="ced_codcli,ced_descli,aaaa,mm"
__somma__=", sum(num_cedolini) as num_cedolini"
__condi__="tipo_elab <> 'T' and tipo_elab <> 'Q' and ced_codcli = ?__CED_CODCLI"  
__orderby__=" ced_codcli,ced_descli,aaaa,mm"


cSql="SELECT "+__campi__+__somma__+" FROM CEDOLINI_DD WHERE " + __condi__ +  ;
    					                          " group by "+__campi__+" order by "+__orderby__
IF !ExecCommand(cSql,"RAG_CEDOLINI_DD")
   return(.f.)
ENDIF

SELECT RAG_CEDOLINI_DD
_NUM_CEDOLINI_RICALCOLATO  = NUM_CEDOLINI 




RETURN


************************************************************
FUNCTION RAGGRUPPA_CEDOLINI_DD_PER_CLIENTE_AAAA_MM_ZUCCHETTI
************************************************************

IF _V_OPZ_ELAB_13_ZUCCHETTI OR _V_OPZ_ELAB_14_ZUCCHETTI
	_NUM_CEDOLINI_RICALCOLATO  = _NUM_CEDOLINI		&& MANTIENE IL TOTALE DEI CEDOLINI RELATIVI ALLA 13ma o14ma MENSILITA'
	RETURN
ENDIF 


__campi__="ced_codcli,ced_descli,aaaa,mm"
__somma__=", sum(num_cedolini) as num_cedolini"
__condi__="tipo_elab <> 'T' and tipo_elab <> 'Q' and ced_codcli = ?__CED_CODCLI and aaaa = ?__ANNO_UTENTE and mm = ?__MESE_UTENTE"  
__orderby__=" ced_codcli,ced_descli,aaaa,mm"


cSql="SELECT "+__campi__+__somma__+" FROM CEDOLINI_DD WHERE " + __condi__ +  ;
    					                          " group by "+__campi__+" order by "+__orderby__
IF !ExecCommand(cSql,"RAG_CEDOLINI_DD")
   return(.f.)
ENDIF



SELECT RAG_CEDOLINI_DD
_NUM_CEDOLINI_RICALCOLATO  = NUM_CEDOLINI 


RETURN




***********************************************************************************
*      ELABORAZIONE MENSILE CEDOLINI PAGA ZUCCHETTI
***********************************************************************************
PROCEDURE ELABORA_STPENDI_ZUCCHETTI
***********************************************************************************

PARAMETERS _PERCORSO_E_NOMEFILE,_ANNOMESE

IF PARAMETERS() < 2
	MESSAGEBOX("Nessun parametro passato",16,"Attenzione")
	RETURN
ENDIF

RELEASE __scarta_cedolino
PUBLIC __scarta_cedolino 
__scarta_cedolino = .F.


RELEASE __ANNO_UTENTE,__MESE_UTENTE
PUBLIC __ANNO_UTENTE,__MESE_UTENTE
__ANNO_UTENTE = SUBSTR(_ANNOMESE,1,4)
__MESE_UTENTE = SUBSTR(_ANNOMESE,6,2)



RELEASE _DESMESE
PUBLIC _DESMESE
_DESMESE  = ""


RELEASE M.CED_CODCLI,M.CED_DESCLI
PUBLIC M.CED_CODCLI,M.CED_DESCLI
M.CED_CODCLI  	= ""
M.CED_DESCLI  	= ""


RELEASE M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 
PUBLIC M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 

M.TAGGANCIO = ""
M.DAGGANCIO = ""
M.DAGGANCIO_DD = ""
M.DAGGANCIO_DL = ""

RELEASE MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
PUBLIC MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
MESE_CEDOLINO_PAGA_ZUCCHETTI = ""
ANNO_CEDOLINO_PAGA_ZUCCHETTI = ""


RELEASE __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
PUBLIC __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
__PATH__ 	= ""
CONTA_CEDOLINI  = 0
_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA = .F.




*!*	################################### APERTURA TABELLE DI SUPPORTO #############################################

* -->> Creazione cursore vuoto di dettaglio cedolino II livello
* --------------------------------------------------------------
IF !ExecCommand("select * from U_GPP_MO where 0=1","CURS_U_GPP_MO")
  return(.f.)
ENDIF
SELECT CURS_U_GPP_MO
AA = AFIELDS(BB)
CREATE CURSOR CU_U_GPP_MO FROM ARRAY BB	


* -->> Creazione cursore vuoto per caricare i cedolini zucchetti
* --------------------------------------------------------------
CREATE CURSOR CED_ZUCCHETTI (RIGA C(250))
        
  

*!*	################################### ELABORAZIONE CEDOLINI PAGA #############################################




GG_FILE = _PERCORSO_E_NOMEFILE
SELECT CED_ZUCCHETTI
_COMANDO = "APPEND FROM '" + GG_FILE + "' SDF"				&& APPEND FILE CEDOLINI
&_COMANDO



SELECT CED_ZUCCHETTI
GO TOP

 

DO WHILE .NOT. EOF()


		SELECT CED_ZUCCHETTI
		SCATTER MEMVAR MEMO
	
		___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,13))) 	&& CARICA LA RIGA DEL CURSORE   
        
	
		IF ALLTRIM(___WORD___) <> "XILOPA0101"					&& INTERCETTA AZIENDA XILOPAN
			SELECT CED_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF

 		
  	    =CERCA_MESE_CEDOLINO()
  	    
	  	IF VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) > 0 AND VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) < 13
	  	ELSE
	  		   =MESSAGEB("FILE CEDOLINI PAGA NON CORRETTI ?? : INTERROMPO L'ELABORAZIONE",16,"*** ATTENZIONE ***")
	  		   SET DEFA TO &PUB_DIR
	  		   RETURN
	  	ENDIF
	  	
	  	IF VAL(MESE_CEDOLINO_PAGA_ZUCCHETTI) == VAL(SUBSTR(_ANNOMESE,6,2)) .AND. VAL(ANNO_CEDOLINO_PAGA_ZUCCHETTI) == VAL(SUBSTR(_ANNOMESE,1,4))
	  	ELSE
			MESSAGEBOX("Verificare che il mese selezionato corrisponda a quello dei cedolini contenuti nel file selezionato" + CHR(13) + CHR(13) + ;
				"Impossibile continuare con l'elaborazione dei cedolini",48,"Attenzione")
			RETURN
	  	ENDIF
	  	
	  	
	  	=CARICA_DATI_DIPENDENTE()								&& CARICA LE VARIABILI DEL DIPENDENTE E CREA IL CURSORE
	  	
	  	STRINGA_DA_CERCARE	= "XILOPA0101"						&& SI SPOSTA SUL DIPENDENTE SUCCESSIVO
	  	DA_POSIZIONE 		= 1
	  	PER 				= 13
	  	OK_POSIZIONATO      = .F.
		=CERCA_RIGA_DESIDERATA(STRINGA_DA_CERCARE,DA_POSIZIONE,PER)



	
ENDDO


=CREAZIONE_TABELLE_RISORSE()


SELECT CU_U_GPP_MO 
GO TOP



*!*	CANCELLA RECORD PRECEDENTI DALLA TABELLA STIPENDI

___TIPO  = "MM"

IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	___TIPO   = "MM"
ENDIF

IF _V_OPZ_ELAB_13_ZUCCHETTI
	___TIPO   = "13"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	___TIPO   = "14"
ENDIF



x_codi = "GPP_TIPO = '" + ___TIPO + "'" 
x_anno = "GPP_ANNO = '" + __ANNO_UTENTE  + "'" 
x_mese = "GPP_MESE = '" + __MESE_UTENTE + "'" 
x_cond = x_codi + " and " + x_anno + " and " + x_mese 

cSql   = "delete from U_GPP_MO where " + x_cond 
IF !ExecCommand(cSql,"U_GPP_MO")
   return(.f.)
ENDIF




*!*	AGGIORNAMENTO TABELLA STIPENDI

IF !ExecRW('','U_GPP_MO ','I','','CU_U_GPP_MO')
 return(.f.)
ENDIF




SET DEFA TO &PUB_DIR



RETURN

***********************************************************************************
*      CREAZIONE TABELLE RISORSE 
***********************************************************************************
FUNCTION CREAZIONE_TABELLE_RISORSE


SELECT CU_U_GPP_MO 
GO TOP

DO WHILE .NOT. EOF()


    SELECT CU_U_GPP_MO 
    SCATTER MEMVAR MEMO
   
   
    * VERIFICA SE LA MATRICOLA ESISTE E NEL CASO LA INSERISCE SU RISUMANA
	x_cond    = "matricola = '" + M.GPP_MATRI + "'"
	cSql      = "select * from RISURAPP where " + x_cond + " order by matricola"
	IF !ExecCommand(cSql,"RISURAPP")
	   return(.f.)
	ENDIF
	  
	IF RECCOUNT() = 0
       INSERISCI_RISUMANA()
	ENDIF 


	SELECT CU_U_GPP_MO
	SKIP +1
	
ENDDO



RETURN


***********************************************************************************
FUNCTION INSERISCI_RISUMANA
***********************************************************************************


	M.IDRISUMANA = NEWID32()
	M.TAGGANCIO  = NEWID32()
	   
	*** PRELEVA ULTIMO CODICE RISORSA 
	cSql = "select CODICE AS ULT_CODICE from RISUMANA ORDER BY CODICE DESC"
	IF !ExecCommand(cSql,"CODICI_RISUMANA")
	  return(.f.)
	ENDIF
	SELECT CODICI_RISUMANA
	GO TOP
	IF EOF()
	   M.CODICE = "00001"
	ELSE
	   M.CODICE = TRC(5,STR((VAL(ULT_CODICE) + 1),5,0))
	ENDIF

    * VERIFICA SE LA MATRICOLA ESISTE E NEL CASO LA INSERISCE SU RISUMANA
	x_cond    = "codice  = '" + M.CODICE + "'"
	cSql      = "select * from RISUMANA where " + x_cond + " order by CODICE"
	IF !ExecRW(cSql,"RISUMANA","R")
	   return(.f.)
	ENDIF
	  
	IF RECCOUNT() = 0
	   APPEND BLANK
	   REPLACE CODICE      WITH M.CODICE
	   REPLACE COGNOME     WITH SUBSTR(M.GPP_COGNOM,1,AT(" ",M.GPP_COGNOM))
	   REPLACE NOME        WITH SUBSTR(M.GPP_COGNOM,AT(" ",M.GPP_COGNOM)+1)
	   REPLACE NAZIONE     WITH "IT"
	   REPLACE SESSO       WITH "M"
	   REPLACE SIGLA       WITH SUBSTR(ALLTRIM(COGNOME),1,1)+SUBSTR(ALLTRIM(NOME),1,1)
	   REPLACE IDRisUmana  WITH M.IDRISUMANA
       REPLACE TAGGANCIO   WITH M.TAGGANCIO
	ENDIF 
	IF !ExecRW(cSql,"RISUMANA","W")
	   return(.f.)
	ENDIF

 
    =INSERISCI_RISURAPP()


RETURN

***********************************************************************************
FUNCTION INSERISCI_RISURAPP
***********************************************************************************

    M.D_DATA   = __ANNO_UTENTE  + "/" + __MESE_UTENTE + "/"+ "01"
    M.D_INIZIO = __ANNO_UTENTE  + "/" + __MESE_UTENTE + "/"+ "01"



	x_cond    = "matricola  = '" + M.GPP_MATRI + "'"
	cSql      = "select * from RISURAPP where " + x_cond + " order by matricola"
	IF !ExecRW(cSql,"RISURAPP","R")
	   return(.f.)
	ENDIF
	  
	IF RECCOUNT() = 0
	   APPEND BLANK
	   
       REPLACE DAGGANCIO    WITH M.TAGGANCIO
       REPLACE MATRICOLA    WITH M.GPP_MATRI	   
	   REPLACE D_DATA       WITH M.D_DATA
	   REPLACE D_INIZIO     WITH M.D_INIZIO
	   REPLACE B_INCORSO    WITH "S"
	   REPLACE TIPO_RISORSA WITH "societa"	   	   
	   REPLACE CENTRCOM     WITH "CM-01"
	   REPLACE ID_RAPPORTO  WITH M.IDRISUMANA
	   
	ENDIF 
	
	IF !ExecRW(cSql,"RISURAPP","W")
	   return(.f.)
	ENDIF


RETURN

***********************************************************************************
*      CARICA I DATI DEI DIPENDENTI 
***********************************************************************************
** LA PROCEDURA ELABORA LE RISORSE DEL CEDOLINO E INTERPRETA IL TIPO DI CONTRATTO 
FUNCTION CARICA_DATI_DIPENDENTE

SELECT CED_ZUCCHETTI

AABBSS__    = SELECT()
__SONO_QUI=RECNO()

SKIP +3

__CODIDIP      = ALLTRIM(SUBSTR(RIGA,01,14)) 
M.GPP_COGNOM   = APITOSPA(UPPER(ALLTRIM(SUBSTR(RIGA,15,50))))



IF M.GPP_COGNOM = "*****      RIEPILOGO GENERALE **********"
	SELECT CED_ZUCCHETTI
	GO __SONO_QUI
	SELECT(AABBSS__)
	RETURN
ENDIF



M.GPP_TIPO  = "MM"

IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	M.GPP_TIPO  = "MM"
ENDIF

IF _V_OPZ_ELAB_13_ZUCCHETTI
	M.GPP_TIPO  = "13"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	M.GPP_TIPO  = "14"
ENDIF



M.GPP_ANNO  = __ANNO_UTENTE 
M.GPP_MESE  = __MESE_UTENTE 
M.GPP_MATRI = ALLTRIM(SUBSTR(RIGA,90,06)) 
  		

_TOT_CEDOLINI_ZUCCHETTI = _TOT_CEDOLINI_ZUCCHETTI +1	


*!*	STRINGA_DA_CERCARE	= "Permessi"								&& SI SPOSTA SULLA RIGA PRIMA DELL'IMPORTO NETTO
*!*	          Imp. INPS     Imp. INAIL     Imp. IRPEF IRPEF pagata  Imp.Detassaz Imposta Det.

STRINGA_DA_CERCARE	= "Imp. INPS"								&& SI SPOSTA SULLA RIGA PRIMA DELL'IMPORTO NETTO
DA_POSIZIONE 		= 11
PER 				= 9
OK_POSIZIONATO      = .F.
=CERCA_RIGA_DESIDERATA(STRINGA_DA_CERCARE,DA_POSIZIONE,PER)


SKIP +8

*!*	1234567890123456789012345678901234567890123456789012345678901234567890X23456789012345678901234567890
*!*	                                                                                1.764,00


IF !EOF()
    _DAPAGA 	=ALLTRIM(SUBSTR(RIGA,71,18))					&& NETTO DA PAGARE AL DIPENDENTE
    _DAPAGA1	=STRTRAN(_DAPAGA, '.','')
    M.GPP_DAPAGA=STRTRAN(_DAPAGA1, ',','.')  
    M.GPP_DAPAGA=VAL(M.GPP_DAPAGA)  
ELSE
	M.GPP_DAPAGA = 0
ENDIF



DO CASE 
	CASE __MESE_UTENTE ="01"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/02/28'
	CASE __MESE_UTENTE ="02"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/03/31'
	CASE __MESE_UTENTE ="03"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/04/30'
	CASE __MESE_UTENTE ="04"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/05/31'
	CASE __MESE_UTENTE ="05"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/06/30'
	CASE __MESE_UTENTE ="06"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/07/31'
	CASE __MESE_UTENTE ="07"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/08/31'
	CASE __MESE_UTENTE ="08"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/09/30'
	CASE __MESE_UTENTE ="09"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/10/31'
	CASE __MESE_UTENTE ="10"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/11/30'
	CASE __MESE_UTENTE ="11"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/12/31'
	CASE __MESE_UTENTE ="12"
		M.GPP_DTSCAD=ALLTRIM(STR(VAL(__ANNO_UTENTE)+1)) +'/01/31'
	
ENDCASE



*!*	CREAZIONE CURSORE CONTENENTE I NETTI DEGLI STIPENDI

SELECT CU_U_GPP_MO 
APPEND BLANK
GATHER MEMVAR MEMO




RETURN



***********************************************************************************
*      CERCA IL MESE DI ELABORAZIONE NEL CEDOLINO PAGA ZUCCHETTI
***********************************************************************************
FUNCTION CERCA_MESE_CEDOLINO


SELECT CED_ZUCCHETTI

AABBSS__    = SELECT()
__SONO_QUI=RECNO()

*!*	MI SPOSTO SUL RECORD PER PRELEVARE IL DEL MESE 
*!*	123456789-123456789-123456789-123456789-123456789-123456789-123456789-12Marzo     2010
SKIP +6



MESE_CEDOLINO_PAGA = UPPER(ALLTRIM(SUBSTR(RIGA,73,10)))
ANNO_CEDOLINO_PAGA_ZUCCHETTI = SUBSTR(RIGA,83,4)



IF MESE_CEDOLINO_PAGA = "GENNAIO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "01"
ENDIF

IF MESE_CEDOLINO_PAGA = "FEBBRAIO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "02"
ENDIF

IF MESE_CEDOLINO_PAGA = "MARZO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "03"
ENDIF

IF MESE_CEDOLINO_PAGA = "APRILE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "04"
ENDIF

IF MESE_CEDOLINO_PAGA = "MAGGIO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "05"
ENDIF

IF MESE_CEDOLINO_PAGA = "GIUGNO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "06"
ENDIF

IF MESE_CEDOLINO_PAGA = "LUGLIO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "07"
ENDIF

IF MESE_CEDOLINO_PAGA = "AGOSTO"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "08"
ENDIF

IF MESE_CEDOLINO_PAGA = "SETTEMBRE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "09"
ENDIF

IF MESE_CEDOLINO_PAGA = "OTTOBRE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "10"
ENDIF

IF MESE_CEDOLINO_PAGA = "NOVEMBRE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "11"
ENDIF

IF MESE_CEDOLINO_PAGA = "DICEMBRE"
	MESE_CEDOLINO_PAGA_ZUCCHETTI = "12"
ENDIF



RETURN

***********************************************************************************
*      CERCA RIGA DESIDERATA
***********************************************************************************
FUNCTION CERCA_RIGA_DESIDERATA
***********************************************************************************

PARAMETERS _STRINGA_DA_CERCARE,_DA_POSIZIONE,_PER

OK_POSIZIONATO = .F.
    
DO WHILE .NOT. EOF()											&& SI POSIZIONA SULLA RIGA PRIMA DELL'IMPORTO NETTO


	_STRINGA = ALLTRIM(SUBSTR(RIGA,_DA_POSIZIONE,_PER))
	
	IF ALLTRIM(_STRINGA_DA_CERCARE) <>  ALLTRIM(_STRINGA) 
		SELECT CED_ZUCCHETTI
		SKIP +1
		LOOP
	ENDIF

    OK_POSIZIONATO = .T.
    
    EXIT

ENDDO


RETURN



***********************************************************************************
*      ELABORAZIONE MENSILE DISTINTA PAGAMENTI ZUCCHETTI
***********************************************************************************
PROCEDURE ELABORA_DISTINTA_ZUCCHETTI
***********************************************************************************

PARAMETERS _PERCORSO_E_NOMEFILE,_ANNOMESE

IF PARAMETERS() < 2
	MESSAGEBOX("Nessun parametro passato",16,"Attenzione")
	RETURN
ENDIF


RELEASE __scarta_cedolino
PUBLIC __scarta_cedolino 
__scarta_cedolino = .F.

RELEASE NUMERO_RECORD_ELABORATI
PUBLIC NUMERO_RECORD_ELABORATI
NUMERO_RECORD_ELABORATI = 0


RELEASE _TOT_DISTINTA_ZUCCHETTI,_TOTALE_NETTO_SOMMATO  
PUBLIC _TOT_DISTINTA_ZUCCHETTI,_TOTALE_NETTO_SOMMATO  
_TOT_DISTINTA_ZUCCHETTI  = 0
_TOTALE_NETTO_SOMMATO  = 0


RELEASE __ANNO_UTENTE,__MESE_UTENTE
PUBLIC __ANNO_UTENTE,__MESE_UTENTE
__ANNO_UTENTE = SUBSTR(_ANNOMESE,1,4)
__MESE_UTENTE = SUBSTR(_ANNOMESE,6,2)



RELEASE _DESMESE
PUBLIC _DESMESE
_DESMESE  = ""


RELEASE M.CED_CODCLI,M.CED_DESCLI
PUBLIC M.CED_CODCLI,M.CED_DESCLI
M.CED_CODCLI  	= ""
M.CED_DESCLI  	= ""


RELEASE M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 
PUBLIC M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 

M.TAGGANCIO = ""
M.DAGGANCIO = ""
M.DAGGANCIO_DD = ""
M.DAGGANCIO_DL = ""

RELEASE MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
PUBLIC MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
MESE_CEDOLINO_PAGA_ZUCCHETTI = ""
ANNO_CEDOLINO_PAGA_ZUCCHETTI = ""


RELEASE __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
PUBLIC __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
__PATH__ 	= ""
CONTA_CEDOLINI  = 0
_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA = .F.




*!*	################################### APERTURA TABELLE DI SUPPORTO #############################################

* -->> Creazione cursore vuoto di dettaglio cedolino II livello
* --------------------------------------------------------------
IF !ExecCommand("select * from U_GPP_MO where 0=1","CURS_U_GPP_MO")
  return(.f.)
ENDIF
SELECT CURS_U_GPP_MO
AA = AFIELDS(BB)
CREATE CURSOR CU_U_GPP_MO FROM ARRAY BB	


* -->> Creazione cursore vuoto per caricare i cedolini zucchetti
* --------------------------------------------------------------
CREATE CURSOR DISTINTA_ZUCCHETTI (RIGA C(250))
        
  

*!*	################################### ELABORAZIONE CEDOLINI PAGA #############################################

RELEASE NUMERO_DIPENDENTI,NETTO_TOTALE_DA_PAGARE  
PUBLIC NUMERO_DIPENDENTI,NETTO_TOTALE_DA_PAGARE  
NUMERO_DIPENDENTI = 0
NETTO_TOTALE_DA_PAGARE = 0


GG_FILE = _PERCORSO_E_NOMEFILE
SELECT DISTINTA_ZUCCHETTI
_COMANDO = "APPEND FROM '" + GG_FILE + "' SDF"				&& APPEND FILE CEDOLINI
&_COMANDO


SELECT DISTINTA_ZUCCHETTI
GO TOP

 

DO WHILE .NOT. EOF()


		SELECT DISTINTA_ZUCCHETTI
		SCATTER MEMVAR MEMO
	
		___WORD___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,1,11))) 	&& CARICA LA RIGA DEL CURSORE   
        
	
		IF ALLTRIM(___WORD___) = "Ditta.....:"					&& SCARTA MOVIMENTI
			SELECT DISTINTA_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF


		IF ALLTRIM(___WORD___) = "___________"					&& SCARTA MOVIMENTI
			SELECT DISTINTA_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF


		*!*	                    RIEPILOGO NETTI IN BUSTA PAGA RELATIVI AL MESE DI DICEMBRE  2011 TIPO CED.  0
		*!*	1234567890123456789012345678901234567890123456789012345678901234567890XXXXXXXXXX
		___WORD2___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,21,09))) 	&& CARICA LA RIGA DEL CURSORE   
        
		IF ALLTRIM(___WORD2___) = "RIEPILOGO"					&& CONTROLLA MESE IN ELABORAZIONE
			___WORD3___ = APITOSPA(ALLTRIM(SUBSTR(M.RIGA,71,10))) 	&& CARICA LA RIGA DEL CURSORE
			IF ___WORD3___ <> ALLTRIM(_mese_caricamento)
				MESSAGEBOX("Verificare che il mese selezionato corrisponda al mese della distinta di pagamento" + CHR(13) + CHR(13) + ;
					"Impossibile continuare con l'elaborazione delle distinte",48,"Attenzione")
				RETURN
			ENDIF 
			SELECT DISTINTA_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF

		IF ALLTRIM(___WORD___) = SPACE(11)						&& SCARTA MOVIMENTI
			SELECT DISTINTA_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF


		IF ALLTRIM(___WORD___) = "CODICE DIP."					&& SCARTA MOVIMENTI
			SELECT DISTINTA_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF


		IF ALLTRIM(___WORD___) = "TOTALE DITT"					&& SCARTA MOVIMENTI
			SELECT DISTINTA_ZUCCHETTI
			SKIP +1
			LOOP
		ENDIF

		*!*	Nr. dipendenti:     95                            211.787,31
		*!*	1234567890123456789012345678901234567890123456789X1234567890

		IF ALLTRIM(___WORD___) = "Nr. dipende"					&& SCARTA MOVIMENTI
			
			NUMERO_DIPENDENTI = VAL(APITOSPA(ALLTRIM(SUBSTR(M.RIGA,20,03)))) 			&& NUMERO DIPENDENTI
			_DAPAGAX= APITOSPA(ALLTRIM(SUBSTR(M.RIGA,50,11))) 						&& VALORE TOTALE NETTO
			_DAPAGA2					=STRTRAN(_DAPAGAX, '.','')
			NETTO_TOTALE_DA_PAGARE 	=VAL(_DAPAGA2)    
			SELECT DISTINTA_ZUCCHETTI
			SKIP +1
			LOOP
		
		ENDIF


  	
	  	=CARICA_DATI_DISTINTA()									&& CARICA LE VARIABILI DEL DIPENDENTE E CREA IL CURSORE

		SELECT DISTINTA_ZUCCHETTI
		SKIP +1
	
ENDDO


IF NETTO_TOTALE_DA_PAGARE <>_TOTALE_NETTO_SOMMATO 

	MESSAGEBOX("Totale della distinta : " + STR(_TOT_DISTINTA_ZUCCHETTI,17,2)+ CHR(13) + ;
		" diverso dal totale caricato automaticamente : " + STR(_TOTALE_NETTO_SOMMATO,17,2)+  CHR(13) + "IMPOSSIBILE PROSEGUIRE !!!!",48,"Attenzione")
	RETURN


ENDIF


=CREAZIONE_TABELLE_RISORSE()


SELECT CU_U_GPP_MO 
GO TOP



*!*	CANCELLA RECORD PRECEDENTI DALLA TABELLA STIPENDI

___TIPO  = "MM"

IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	___TIPO   = "MM"
ENDIF

IF _V_OPZ_ELAB_13_ZUCCHETTI
	___TIPO   = "13"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	___TIPO   = "14"
ENDIF



x_codi = "GPP_TIPO = '" + ___TIPO + "'" 
x_anno = "GPP_ANNO = '" + __ANNO_UTENTE  + "'" 
x_mese = "GPP_MESE = '" + __MESE_UTENTE + "'" 
x_cond = x_codi + " and " + x_anno + " and " + x_mese 

cSql   = "delete from U_GPP_MO where " + x_cond 
IF !ExecCommand(cSql,"U_GPP_MO")
   return(.f.)
ENDIF




*!*	AGGIORNAMENTO TABELLA STIPENDI

IF !ExecRW('','U_GPP_MO ','I','','CU_U_GPP_MO')
 return(.f.)
ENDIF




SET DEFA TO &PUB_DIR



RETURN



***********************************************************************************
*      CARICA I DATI DEL DIPENDENTE DALLA DISTINTA DI PAGAMENTO
***********************************************************************************
FUNCTION CARICA_DATI_DISTINTA

SELECT DISTINTA_ZUCCHETTI

AABBSS__    = SELECT()
__SONO_QUI=RECNO()

*!*	AGNMAR01 001 AGNELOTTI MARIANO          000089      2657,00
*!*	123456789012345678901234567890123456789012345678901234567890


__CODIDIP      = ALLTRIM(SUBSTR(RIGA,01,08)) 
M.GPP_COGNOM   = APITOSPA(UPPER(ALLTRIM(SUBSTR(RIGA,14,25))))



M.GPP_TIPO  = "MM"

IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	M.GPP_TIPO  = "MM"
ENDIF

IF _V_OPZ_ELAB_13_ZUCCHETTI
	M.GPP_TIPO  = "13"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	M.GPP_TIPO  = "14"
ENDIF



M.GPP_ANNO  = __ANNO_UTENTE 
M.GPP_MESE  = __MESE_UTENTE 
M.GPP_MATRI = ALLTRIM(SUBSTR(RIGA,42,5)) 
 
  		
IF M.GPP_COGNOM = 'MONTANARI MARCO'							&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
	IF EMPTY(M.GPP_MATRI)									&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
		M.GPP_MATRI = '999'									&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
	ENDIF													&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
ENDIF														&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE


NUMERO_RECORD_ELABORATI = NUMERO_RECORD_ELABORATI  +1	

*!*	AGNMAR01 001 AGNELOTTI MARIANO          000089      2657,00
*!*	12345678901234567890123456789012345678901234567X901234567890


_DAPAGA 	=ALLTRIM(SUBSTR(RIGA,48,12))					&& NETTO DA PAGARE AL DIPENDENTE
_DAPAGA1	=STRTRAN(_DAPAGA, '.','')
M.GPP_DAPAGA=VAL(_DAPAGA1)    

_TOTALE_NETTO_SOMMATO = _TOTALE_NETTO_SOMMATO + M.GPP_DAPAGA

DO CASE 
	CASE __MESE_UTENTE ="01"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/02/28'
	CASE __MESE_UTENTE ="02"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/03/31'
	CASE __MESE_UTENTE ="03"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/04/30'
	CASE __MESE_UTENTE ="04"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/05/31'
	CASE __MESE_UTENTE ="05"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/06/30'
	CASE __MESE_UTENTE ="06"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/07/31'
	CASE __MESE_UTENTE ="07"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/08/31'
	CASE __MESE_UTENTE ="08"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/09/30'
	CASE __MESE_UTENTE ="09"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/10/31'
	CASE __MESE_UTENTE ="10"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/11/30'
	CASE __MESE_UTENTE ="11"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/12/31'
	CASE __MESE_UTENTE ="12"
		M.GPP_DTSCAD=ALLTRIM(STR(VAL(__ANNO_UTENTE)+1)) +'/01/31'
	
ENDCASE



*!*	CREAZIONE CURSORE CONTENENTE I NETTI DEGLI STIPENDI

SELECT CU_U_GPP_MO 
APPEND BLANK
GATHER MEMVAR MEMO




RETURN





**=> ERASMO - INIZIO 01/02/2017
***********************************************************************************
*      ELABORAZIONE MENSILE DISTINTA PAGAMENTI DA CSV
***********************************************************************************
PROCEDURE ELABORA_DISTINTA_CSV
***********************************************************************************

PARAMETERS _PERCORSO_E_NOMEFILE,_ANNOMESE

IF PARAMETERS() < 2
	MESSAGEBOX("Nessun parametro passato",16,"Attenzione")
	RETURN
ENDIF


RELEASE __scarta_cedolino
PUBLIC __scarta_cedolino 
__scarta_cedolino = .F.

RELEASE NUMERO_RECORD_ELABORATI
PUBLIC NUMERO_RECORD_ELABORATI
NUMERO_RECORD_ELABORATI = 0


RELEASE _TOT_DISTINTA_CSV,_TOTALE_NETTO_SOMMATO  
PUBLIC _TOT_DISTINTA_CSV,_TOTALE_NETTO_SOMMATO  
_TOT_DISTINTA_CSV  = 0
_TOTALE_NETTO_SOMMATO  = 0


RELEASE __ANNO_UTENTE,__MESE_UTENTE
PUBLIC __ANNO_UTENTE,__MESE_UTENTE
__ANNO_UTENTE = SUBSTR(_ANNOMESE,1,4)
__MESE_UTENTE = SUBSTR(_ANNOMESE,6,2)



RELEASE _DESMESE
PUBLIC _DESMESE
_DESMESE  = ""


RELEASE M.CED_CODCLI,M.CED_DESCLI
PUBLIC M.CED_CODCLI,M.CED_DESCLI
M.CED_CODCLI  	= ""
M.CED_DESCLI  	= ""


RELEASE M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 
PUBLIC M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 

M.TAGGANCIO = ""
M.DAGGANCIO = ""
M.DAGGANCIO_DD = ""
M.DAGGANCIO_DL = ""

RELEASE MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
PUBLIC MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
MESE_CEDOLINO_PAGA_ZUCCHETTI = ""
ANNO_CEDOLINO_PAGA_ZUCCHETTI = ""


RELEASE __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
PUBLIC __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
__PATH__ 	= ""
CONTA_CEDOLINI  = 0
_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA = .F.




*!*	################################### APERTURA TABELLE DI SUPPORTO #############################################

* -->> Creazione cursore vuoto di dettaglio cedolino II livello
* --------------------------------------------------------------
IF !ExecCommand("select * from U_GPP_MO where 0=1","CURS_U_GPP_MO")
  return(.f.)
ENDIF
SELECT CURS_U_GPP_MO
AA = AFIELDS(BB)
CREATE CURSOR CU_U_GPP_MO FROM ARRAY BB	


* -->> Creazione cursore vuoto per caricare i cedolini altro
* --------------------------------------------------------------
CREATE CURSOR DISTINTA_CSV (;
	CAMPO1 C(250), ;
	CAMPO2 C(250), ;
	CAMPO3 C(250), ;
	CAMPO4 C(250), ;
	CAMPO5 C(250), ;
	CAMPO6 C(250), ;
	CAMPO7 C(250), ;
	CAMPO8 C(250), ;
	CAMPO9 C(250), ;
	CAMPO10 C(250), ;
	CAMPO11 C(250), ;
	CAMPO12 C(250), ;
	CAMPO13 C(250), ;
	CAMPO14 C(250))
	

*!*	################################### ELABORAZIONE CEDOLINI PAGA #############################################

RELEASE NUMERO_DIPENDENTI,NETTO_TOTALE_DA_PAGARE  
PUBLIC NUMERO_DIPENDENTI,NETTO_TOTALE_DA_PAGARE  
NUMERO_DIPENDENTI = 0
NETTO_TOTALE_DA_PAGARE = 0


GG_FILE = _PERCORSO_E_NOMEFILE
SELECT DISTINTA_CSV
_COMANDO = "APPEND FROM '" + GG_FILE + "' DELIMITED WITH CHARACTER ';'"				&& APPEND FILE CEDOLINI
&_COMANDO


SELECT DISTINTA_CSV
GO TOP
SCAN
	
	IF RECNO() > 1  && SALTA LA PRIMA RIGA IN CUI CI SONO LE INTESTAZIONI DI COLONNA
	ELSE
		LOOP
	ENDIF
	
	SELECT DISTINTA_CSV
	SCATTER MEMVAR MEMO

*!*		IF M.CAMPO1 <> ALLTRIM(_mese_caricamento)
*!*			MESSAGEBOX("Verificare che il mese selezionato corrisponda al mese della distinta di pagamento" + CHR(13) + CHR(13) + ;
*!*				"Impossibile continuare con l'elaborazione delle distinte",48,"Attenzione")
*!*			RETURN
*!*		ENDIF
	
	**=> ERASMO - INIZIO 10/03/2020
	IF M.CAMPO1 <> ALLTRIM(_mese_caricamento)
		MESSAGEBOX("Verificare che nel file non ci siano record vuoti e che il mese selezionato corrisponda al mese della distinta di pagamento (record n° " + ALLTRIM(STR(RECNO())) + ")" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione delle distinte",48,"Attenzione")
		NUMERO_DIPENDENTI = 0
		NETTO_TOTALE_DA_PAGARE = 0
		RETURN .F.
	ENDIF
	**=> ERASMO - FINE 10/03/2020
		  	
  	=CARICA_DATI_DISTINTA_CSV()									&& CARICA LE VARIABILI DEL DIPENDENTE E CREA IL CURSORE

ENDSCAN


=CREAZIONE_TABELLE_RISORSE()


SELECT CU_U_GPP_MO 
GO TOP



*!*	CANCELLA RECORD PRECEDENTI DALLA TABELLA STIPENDI

___TIPO  = "MM"

IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	___TIPO   = "MM"
ENDIF

IF _V_OPZ_ELAB_13_ZUCCHETTI
	___TIPO   = "13"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	___TIPO   = "14"
ENDIF



x_codi = "GPP_TIPO = '" + ___TIPO + "'" 
x_anno = "GPP_ANNO = '" + __ANNO_UTENTE  + "'" 
x_mese = "GPP_MESE = '" + __MESE_UTENTE + "'" 
x_cond = x_codi + " and " + x_anno + " and " + x_mese 

cSql   = "delete from U_GPP_MO where " + x_cond 
IF !ExecCommand(cSql,"U_GPP_MO")
   return(.f.)
ENDIF




*!*	AGGIORNAMENTO TABELLA STIPENDI

IF !ExecRW('','U_GPP_MO ','I','','CU_U_GPP_MO')
 return(.f.)
ENDIF




SET DEFA TO &PUB_DIR



RETURN



***********************************************************************************
*      CARICA I DATI DEL DIPENDENTE DALLA DISTINTA DI PAGAMENTO
***********************************************************************************
FUNCTION CARICA_DATI_DISTINTA_CSV


AABBSS__    = SELECT()
__SONO_QUI=RECNO()


M.GPP_COGNOM = ALLTRIM(M.CAMPO12)

M.GPP_TIPO = "MM"

IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	M.GPP_TIPO  = "MM"
ENDIF

IF _V_OPZ_ELAB_13_ZUCCHETTI
	M.GPP_TIPO  = "13"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	M.GPP_TIPO  = "14"
ENDIF

M.GPP_ANNO  = __ANNO_UTENTE 
M.GPP_MESE  = __MESE_UTENTE 
M.GPP_MATRI = PADL(ALLTRIM(M.CAMPO11),5,'0')
  		
IF M.GPP_COGNOM = 'MONTANARI MARCO'							&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
	IF EMPTY(M.GPP_MATRI)									&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
		M.GPP_MATRI = '999'									&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
	ENDIF													&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
ENDIF														&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE

NUMERO_RECORD_ELABORATI = NUMERO_RECORD_ELABORATI  +1	

M.GPP_DAPAGA = VAL(CAMPO14)    

_TOTALE_NETTO_SOMMATO = _TOTALE_NETTO_SOMMATO + M.GPP_DAPAGA

DO CASE 
	CASE __MESE_UTENTE ="01"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/02/28'
	CASE __MESE_UTENTE ="02"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/03/31'
	CASE __MESE_UTENTE ="03"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/04/30'
	CASE __MESE_UTENTE ="04"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/05/31'
	CASE __MESE_UTENTE ="05"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/06/30'
	CASE __MESE_UTENTE ="06"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/07/31'
	CASE __MESE_UTENTE ="07"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/08/31'
	CASE __MESE_UTENTE ="08"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/09/30'
	CASE __MESE_UTENTE ="09"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/10/31'
	CASE __MESE_UTENTE ="10"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/11/30'
	CASE __MESE_UTENTE ="11"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/12/31'
	CASE __MESE_UTENTE ="12"
		M.GPP_DTSCAD=ALLTRIM(STR(VAL(__ANNO_UTENTE)+1)) +'/01/31'
	
ENDCASE


*!*	CREAZIONE CURSORE CONTENENTE I NETTI DEGLI STIPENDI

SELECT CU_U_GPP_MO 
APPEND BLANK
GATHER MEMVAR MEMO

RETURN

**=> ERASMO - FINE 01/02/2017


**=> ERASMO - INIZIO 28/02/2025
***********************************************************************************
*      ELABORAZIONE MENSILE DISTINTA PAGAMENTI DA XLS
***********************************************************************************
PROCEDURE ELABORA_DISTINTA_XLS
***********************************************************************************

PARAMETERS _PERCORSO_E_NOMEFILE,_ANNOMESE

IF PARAMETERS() < 2
	MESSAGEBOX("Nessun parametro passato",16,"Attenzione")
	RETURN
ENDIF


RELEASE __scarta_cedolino
PUBLIC __scarta_cedolino 
__scarta_cedolino = .F.

RELEASE NUMERO_RECORD_ELABORATI
PUBLIC NUMERO_RECORD_ELABORATI
NUMERO_RECORD_ELABORATI = 0


RELEASE _TOT_DISTINTA_CSV,_TOTALE_NETTO_SOMMATO  
PUBLIC _TOT_DISTINTA_CSV,_TOTALE_NETTO_SOMMATO  
_TOT_DISTINTA_CSV  = 0
_TOTALE_NETTO_SOMMATO  = 0


RELEASE __ANNO_UTENTE,__MESE_UTENTE
PUBLIC __ANNO_UTENTE,__MESE_UTENTE
__ANNO_UTENTE = SUBSTR(_ANNOMESE,1,4)
__MESE_UTENTE = SUBSTR(_ANNOMESE,6,2)



RELEASE _DESMESE
PUBLIC _DESMESE
_DESMESE  = ""


RELEASE M.CED_CODCLI,M.CED_DESCLI
PUBLIC M.CED_CODCLI,M.CED_DESCLI
M.CED_CODCLI  	= ""
M.CED_DESCLI  	= ""


RELEASE M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 
PUBLIC M.TAGGANCIO,M.DAGGANCIO,M.DAGGANCIO_DD,M.DAGGANCIO_DL 

M.TAGGANCIO = ""
M.DAGGANCIO = ""
M.DAGGANCIO_DD = ""
M.DAGGANCIO_DL = ""

RELEASE MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
PUBLIC MESE_CEDOLINO_PAGA_ZUCCHETTI,ANNO_CEDOLINO_PAGA_ZUCCHETTI  
MESE_CEDOLINO_PAGA_ZUCCHETTI = ""
ANNO_CEDOLINO_PAGA_ZUCCHETTI = ""


RELEASE __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
PUBLIC __PATH__,CONTA_CEDOLINI,_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA 
__PATH__ 	= ""
CONTA_CEDOLINI  = 0
_OK_ANAGRAFICA_CLIENTE_STUDIO_TROVATA = .F.




*!*	################################### APERTURA TABELLE DI SUPPORTO #############################################

* -->> Creazione cursore vuoto di dettaglio cedolino II livello
* --------------------------------------------------------------
IF !ExecCommand("select * from U_GPP_MO where 0=1","CURS_U_GPP_MO")
  return(.f.)
ENDIF
SELECT CURS_U_GPP_MO
AA = AFIELDS(BB)
CREATE CURSOR CU_U_GPP_MO FROM ARRAY BB	

*!*	################################### ELABORAZIONE CEDOLINI PAGA #############################################

RELEASE NUMERO_DIPENDENTI,NETTO_TOTALE_DA_PAGARE  
PUBLIC NUMERO_DIPENDENTI,NETTO_TOTALE_DA_PAGARE  
NUMERO_DIPENDENTI = 0
NETTO_TOTALE_DA_PAGARE = 0

_cFileName = _PERCORSO_E_NOMEFILE
_OK_CURSORE = XLS_TO_VFP_CURSOR(_cFileName,"DISTINTA_XLS")

SELECT DISTINTA_XLS
GO TOP
SCAN
	
	IF RECNO() > 1  && SALTA LA PRIMA RIGA IN CUI CI SONO LE INTESTAZIONI DI COLONNA
	ELSE
		LOOP
	ENDIF
	
	SELECT DISTINTA_XLS
	SCATTER MEMVAR MEMO
	
	IF ALLTRIM(DMESE(M.A)) <> ALLTRIM(_mese_caricamento)
		MESSAGEBOX("Verificare che nel file non ci siano record vuoti e che il mese selezionato corrisponda al mese della distinta di pagamento (record n° " + ALLTRIM(STR(RECNO())) + ")" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione delle distinte",48,"Attenzione")
		NUMERO_DIPENDENTI = 0
		NETTO_TOTALE_DA_PAGARE = 0
		SELECT DISTINTA_XLS
		SCATTER MEMVAR MEMO BLANK
		RETURN .F.
	ENDIF
	
	IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI AND ALLTRIM(M.B) <> "0"
		MESSAGEBOX("Verificare che nel file non ci siano record vuoti e che il tipo di mensilità selezionata (Elabora mensilità / Elabora 13ma / Elabora 14ma) corrisponda alla tipologia di file da importare (record n° " + ALLTRIM(STR(RECNO())) + ")" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione delle distinte",48,"Attenzione")
		NUMERO_DIPENDENTI = 0
		NETTO_TOTALE_DA_PAGARE = 0
		SELECT DISTINTA_XLS
		SCATTER MEMVAR MEMO BLANK
		RETURN .F.
	ENDIF
	
	IF _V_OPZ_ELAB_13_ZUCCHETTI AND ALLTRIM(M.B) <> "13"
		MESSAGEBOX("Verificare che nel file non ci siano record vuoti e che il tipo di mensilità selezionata (Elabora mensilità / Elabora 13ma / Elabora 14ma) corrisponda alla tipologia di file da importare (record n° " + ALLTRIM(STR(RECNO())) + ")" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione delle distinte",48,"Attenzione")
		NUMERO_DIPENDENTI = 0
		NETTO_TOTALE_DA_PAGARE = 0
		SELECT DISTINTA_XLS
		SCATTER MEMVAR MEMO BLANK
		RETURN .F.
	ENDIF

	IF _V_OPZ_ELAB_14_ZUCCHETTI AND ALLTRIM(M.B) <> "14"
		MESSAGEBOX("Verificare che nel file non ci siano record vuoti e che il tipo di mensilità selezionata (Elabora mensilità / Elabora 13ma / Elabora 14ma) corrisponda alla tipologia di file da importare (record n° " + ALLTRIM(STR(RECNO())) + ")" + CHR(13) + CHR(13) + ;
			"Impossibile continuare con l'elaborazione delle distinte",48,"Attenzione")
		NUMERO_DIPENDENTI = 0
		NETTO_TOTALE_DA_PAGARE = 0
		SELECT DISTINTA_XLS
		SCATTER MEMVAR MEMO BLANK
		RETURN .F.
	ENDIF
		  	
  	=CARICA_DATI_DISTINTA_XLS()									&& CARICA LE VARIABILI DEL DIPENDENTE E CREA IL CURSORE

ENDSCAN

SELECT DISTINTA_XLS
SCATTER MEMVAR MEMO BLANK

=CREAZIONE_TABELLE_RISORSE()


SELECT CU_U_GPP_MO 
GO TOP



*!*	CANCELLA RECORD PRECEDENTI DALLA TABELLA STIPENDI

___TIPO  = "MM"

IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	___TIPO   = "MM"
ENDIF

IF _V_OPZ_ELAB_13_ZUCCHETTI
	___TIPO   = "13"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	___TIPO   = "14"
ENDIF



x_codi = "GPP_TIPO = '" + ___TIPO + "'" 
x_anno = "GPP_ANNO = '" + __ANNO_UTENTE  + "'" 
x_mese = "GPP_MESE = '" + __MESE_UTENTE + "'" 
x_cond = x_codi + " and " + x_anno + " and " + x_mese 

cSql   = "delete from U_GPP_MO where " + x_cond 
IF !ExecCommand(cSql,"U_GPP_MO")
   return(.f.)
ENDIF




*!*	AGGIORNAMENTO TABELLA STIPENDI

IF !ExecRW('','U_GPP_MO ','I','','CU_U_GPP_MO')
 return(.f.)
ENDIF




SET DEFA TO &PUB_DIR



RETURN



***********************************************************************************
*      CARICA I DATI DEL DIPENDENTE DALLA DISTINTA DI PAGAMENTO
***********************************************************************************
FUNCTION CARICA_DATI_DISTINTA_XLS

AABBSS__ = SELECT()
__SONO_QUI = RECNO()


M.GPP_COGNOM = ALLTRIM(M.H)

M.GPP_TIPO = "MM"

IF _V_OPZ_ELAB_MENSILITA_ZUCCHETTI
	M.GPP_TIPO  = "MM"
ENDIF

IF _V_OPZ_ELAB_13_ZUCCHETTI
	M.GPP_TIPO  = "13"
ENDIF


IF _V_OPZ_ELAB_14_ZUCCHETTI
	M.GPP_TIPO  = "14"
ENDIF

M.GPP_ANNO  = __ANNO_UTENTE 
M.GPP_MESE  = __MESE_UTENTE 
M.GPP_MATRI = PADL(ALLTRIM(M.G),5,'0')
  		
IF M.GPP_COGNOM = 'MONTANARI MARCO'							&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
	IF EMPTY(M.GPP_MATRI)									&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
		M.GPP_MATRI = '999'									&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
	ENDIF													&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE
ENDIF														&& FORZATURA DELLA MATRICOLA IN QUANTO NON ESISTE

NUMERO_RECORD_ELABORATI = NUMERO_RECORD_ELABORATI  +1	

M.GPP_DAPAGA = VAL(STRTRAN(ALLTRIM(M.K),".",","))

_TOTALE_NETTO_SOMMATO = _TOTALE_NETTO_SOMMATO + M.GPP_DAPAGA

DO CASE 
	CASE __MESE_UTENTE ="01"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/02/28'
	CASE __MESE_UTENTE ="02"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/03/31'
	CASE __MESE_UTENTE ="03"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/04/30'
	CASE __MESE_UTENTE ="04"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/05/31'
	CASE __MESE_UTENTE ="05"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/06/30'
	CASE __MESE_UTENTE ="06"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/07/31'
	CASE __MESE_UTENTE ="07"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/08/31'
	CASE __MESE_UTENTE ="08"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/09/30'
	CASE __MESE_UTENTE ="09"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/10/31'
	CASE __MESE_UTENTE ="10"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/11/30'
	CASE __MESE_UTENTE ="11"
		M.GPP_DTSCAD=__ANNO_UTENTE +'/12/31'
	CASE __MESE_UTENTE ="12"
		M.GPP_DTSCAD=ALLTRIM(STR(VAL(__ANNO_UTENTE)+1)) +'/01/31'
	
ENDCASE


*!*	CREAZIONE CURSORE CONTENENTE I NETTI DEGLI STIPENDI

SELECT CU_U_GPP_MO 
APPEND BLANK
GATHER MEMVAR MEMO

RETURN
**=> ERASMO - FINE 28/02/2025