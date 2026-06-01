DO SETLIB
    

*!*	AQM_CODCLI = ""
*!*	AQM_DATADA = RIBALTA2(DTOC(DATE()))
*!*	AQM_DATAA  = RIBALTA2(DTOC(DATE()))

*!*	=VERIFICA_SPEDITO_CON_MAGAZZINO(AQM_CODCLI,AQM_DATADA,AQM_DATAA)


AQM_CODMAG			= ""
AQM_CODART			= ""
AQM_ACCESSO_GG		= 4		&& 1=TUTTI I MOVIMENTI U_MAG_GG/2=MAGAZZINO+ARTICOLO/3=ARTICOLO/4=DATA DA/A
AQM_DATADA 			= RIBALTA2(DTOC(DATE()))
AQM_DATAA  			= RIBALTA2(DTOC(DATE()))

=RICALCOLA_IMPEGNATO_SU_U_MAG_GG(AQM_CODMAG,AQM_CODART,AQM_ACCESSO_GG,AQM_DATADA,AQM_DATAA)




RETURN


*!*	##################################################################################################################################àà


********************************************************************************************************************************************************************************************************************
FUNCTION VERIFICA_SPEDITO_CON_MAGAZZINO
********************************************************************************************************************************************************************************************************************
PARAMETERS _AQM_CODCLI,_AQM_DATADA,_AQM_DATAA

*!*	ELABORA DDT PER PERIODO/CLIENTE

X_SOCI = "ORD_CODSOC = '" + PUB_CODSOC + "'"

IF EMPTY(_AQM_CODCLI)
	X_CLIE = "ORD_CODCLI = ORD_CODCLI"
ELSE
	X_CLIE = "ORD_CODCLI = '" + ALLTRIM(_AQM_CODCLI) + "'"
ENDIF

X_DATA = "ORD_DATORD BETWEEN '" + _AQM_DATADA + "' AND '" + _AQM_DATAA + "'"


X_COND = X_SOCI + " AND " + X_CLIE + " AND " + X_DATA 

CSQL = "SELECT * FROM U_BOL_TT WHERE " + X_COND + " ORDER BY ORD_CODSOC,ORD_DATORD,ORD_NUMORD"

IF !ExecCommand(cSql,"AQM_U_BOL_TT")
   return(.f.)
ENDIF

SELECT AQM_U_BOL_TT
GO TOP

DO WHILE .NOT.EOF()

    IF DELETED()
      SELECT AQM_U_BOL_TT
      SKIP +1
      LOOP
    ENDIF
    
    IF ORD_FORNI						&& SCARTA BOLLE A FORNITORI
      SELECT AQM_U_BOL_TT
      SKIP +1
      LOOP
    ENDIF
   
    WAIT WINDOWS "NUNERO DDT IN ELABORAZIONE : "+ORD_NUMORD NOWAIT

	XX_COND = "DAGGANCIO = '" + ALLTRIM(TAGGANCIO) + "'"
	CSQL = "SELECT * FROM U_BOL_DD WHERE " + XX_COND + " ORDER BY ORD_CODART,ORD_SEQUEN"

	IF !ExecCommand(cSql,"AQM_U_BOL_DD")
	   return(.f.)
	ENDIF

	SELECT AQM_U_BOL_DD
	GO TOP

	DO WHILE .NOT.EOF()

	   	IF DELETED()
	      	SELECT AQM_U_BOL_DD
	      	SKIP +1
	      	LOOP
	   	ENDIF

	   	IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
	      	SELECT AQM_U_BOL_DD
	      	SKIP +1
	      	LOOP
	   	ENDIF

		DO PRG\STARTUP_NEW_MAG

		SELECT AQM_U_BOL_DD
		
		AQM_VERIFICA  	= "02"  		&& VERIFICA L'ESISTENZA DEL MOVIMENTO DI MAGAZZINO GENERATO DAL DETTAGLIO DELLA DDT
		AQM_AGG_MAGGG  	= "NO"  		&& NON EFFETTUA NESSUN AGGIORNAMENTO SU U_MAG_GG
		AQM_AGG_MAGMO  	= "NO"  		&& NON EFFETTUA NESSUN AGGIORNAMENTO SU U_MAG_MO
		AQM_ACCESSO_GG  = 1				&& ACCESSO PER MAGAZZINO+ARTICOLO
		AQM_ACCESSO_MO  = 4				&& ACCESSO PER LEGSYS
		AQM_CODMAG 		= ORD_MAGA  
		AQM_CODART      = ORD_CODART   
		AQM_LEGSYS      = ORD_LEGSYS	&& CODICE SYS IDENTIFICATIVO CHE LEGA U_MAG_GG+U_MAG_MO AI DOCUMENTI TRAMITE ORD_LEGSYS

		=CALCOLA_GIACENZE_VALORI_MAGAZZINO(AQM_VERIFICA,AQM_AGG_MAGGG,AQM_AGG_MAGMO,AQM_ACCESSO_GG,AQM_ACCESSO_MO,AQM_CODMAG,AQM_CODART,AQM_CODFOR,AQM_LEGSYS,AQM_NUMIDE,AQM_UNIQUE,AQM_NRLINT,AQM_DTREGI,AQM_SERIE,AQM_FILA_X,AQM_PIAN_N,AQM_UBIC_X)

	    SELECT AQM_U_BOL_DD
	    SKIP +1
	      	
	      				   
	ENDDO WHILE .NOT.EOF()   
   
   SELECT AQM_U_BOL_TT
   SKIP +1
   
ENDDO WHILE .T.





RETURN

********************************************************************************************************************************************************************************************************************
FUNCTION CALCOLA_GIACENZE_VALORI_MAGAZZINO 
********************************************************************************************************************************************************************************************************************
PARAMETERS _AQM_VERIFICA,_AQM_AGG_MAGGG,_AQM_AGG_MAGMO,_AQM_ACCESSO_GG,_AQM_ACCESSO_MO,_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_NUMIDE,_AQM_UNIQUE,_AQM_NRLINT,_AQM_DTREGI,_AQM_SERIE,_AQM_FILA_X,_AQM_PIAN_N,_AQM_UBIC_X
*!*			
*!*		INPUT :	
*!*			
*!*			 _AQM_VERIFICA  		: = "01" CONFRONTA LA GIACENZA DI U_MAG_GG CON LA GIACENZA DI U_MAG_MO E SCRIVE LOG_NEW_MAG / = NO NON CONFRONTA LE GIACENZE
*!*	 								: = "02" VERIFICA L'ESISTENZA DEL MOVIMENTO DI MAGAZZINO GENERATO DAL DETTAGLIO DELLA DDT
*!*	 								: = "03" CALCOLA LA GIACENZA SU U_MAG_MO
*!*	 								: = "04" CALCOLA LA GIACENZA SU U_MAG_GG
*!*	
*!*			
*!*			_AQM_AGG_MAGGG  		: = NO   NON EFFETTEUA NESSUN AGGIORNAMENTO SU U_MAG_GG        		/  = SI AGGIORNA U_MAG_GG
*!*			_AQM_AGG_MAGMO 			: = NO   NON EFFETTEUA NESSUN AGGIORNAMENTO SU U_MAG_MO        		/  = SI AGGIORNA U_MAG_MO
*!*			_AQM_ACCESSO_GG			: = ...	 PERMETTE DI ACCEDERE A U_MAG_GG CON UNA CHIAVE DI ACCESSO DESIDERATA
*!*			_AQM_ACCESSO_MO			: = ...	 PERMETTE DI ACCEDERE A U_MAG_MO CON UNA CHIAVE DI ACCESSO DESIDERATA
*!*			
*!*			_AQM_CODMAG         	: CODICE MAGAZZINO  
*!*			_AQM_CODART          	: CODICE ARTICOLO  
*!*			_AQM_CODFOR          	: CODICE FORNITORE  
*!*			_AQM_LEGSYS         	: CODICE SYS IDENTIFICATIVO CHE LEGA U_MAG_GG+U_MAG_MO AI DOCUMENTI TRAMITE ORD_LEGSYS
*!*			_AQM_NUMIDE          	: CODICE IDENTIFICATIVO DEL MOVIMENTO  RIPORTATO ANCHE SUI DETTAGLI DEI DOCUMENTI CON ORS_NUMIDE
*!*			_AQM_UNIQUE          	: CODICE SYS CHE IDENTIFICA IL SINGOLO RECORD DI U_MAG_GG E U_MAG_MO
*!*			_AQM_NRLINT          	: NUMERO LOTTO INTERNO CHE LEGA I RECORD DI U_MAG_GG CON IL RECORD DI U_MAG_MO
*!*			_AQM_DTREGI          	: DATA DI REGISTRAZIONE MOVIMENTO , PER U_MAG_GG VIENE CONFRONTATA CON MAG_DATAGG
*!*			
*!*			_AQM_SERIE           	: MAGAZZINO FISCALE   - NUMERO DI SERIE
*!*			_AQM_FILA_X          	: MAGAZZINO_LOCAZIONE - FILA 
*!*			_AQM_PIAN_X          	: MAGAZZINO_LOCAZIONE - PIANO
*!*			_AQM_UBIC_X          	: MAGAZZINO_LOCAZIONE - UBICAZIONE
*!*			_AQM_FILA_N          	: MAGAZZINO_LOCAZIONE - FILA 
*!*			_AQM_PIAN_N          	: MAGAZZINO_LOCAZIONE - PIANO
*!*			_AQM_UBIC_N          	: MAGAZZINO_LOCAZIONE - UBICAZIONE
*!*	
*!*									:
*!*		ACCESSI TABELLARI			:
*!*									:
*!*		((((U_MAG_MO))))  			:  
*!*									:
*!*		  _AQM_ACCESSO_MO			: 	= 1 ACCESSO PER	:	_AQM_CODMAG+_AQM_CODART
*!*									:	= 2 ACCESSO PER :	_AQM_CODMAG+_AQM_CODART+_AQM_CODFOR
*!*	 								:	= 3 ACCESSO PER :	_AQM_CODART+_AQM_LEGSYS
*!*	 								:	= 4 ACCESSO PER :	_AQM_LEGSYS
*!*	 								:	= 5 ACCESSO PER :	_AQM_UNIQUE
*!*	 								:	= 6 ACCESSO PER :	_AQM_NUMIDE
*!*									:
*!*		((((U_MAG_GG))))  			:  
*!*									:
*!*		  _AQM_ACCESSO_GG			: 	= 1 ACCESSO PER	:	_AQM_CODMAG+_AQM_CODART
*!*									:	= 2 ACCESSO PER :	_AQM_CODMAG+_AQM_CODART+_AQM_CODFOR
*!*	 								:	= 3 ACCESSO PER :	_AQM_CODART+_AQM_LEGSYS
*!*	 								:	= 4 ACCESSO PER :	_AQM_LEGSYS
*!*	 								:	= 5 ACCESSO PER :	_AQM_UNIQUE
*!*	 								:	= 6 ACCESSO PER :	_AQM_NUMIDE
*!*									:
*!*		OUTPUT :	
*!*			
*!*			AQM_MO_QTAMOV      		: SU U_MAG_MO - CONTIENE IL TOTALE DELLE QUANTITA'  DEI MOVIMENTI
*!*			AQM_MO_QTAKG           	: SU U_MAG_MO - CONTIENE IL TOTALE DELLE QUANTITA'  DEI MOVIMENTI IN CHILOGRAMMI
*!*			AQM_MO_QTAMQ           	: SU U_MAG_MO - CONTIENE IL TOTALE DELLE QUANTITA'  DEI MOVIMENTI IN METRI QUADRI
*!*			AQM_MO_QTAML           	: SU U_MAG_MO - CONTIENE IL TOTALE DELLE QUANTITA'  DEI MOVIMENTI IN METRI LINEARI
*!*			
*!*			AQM_GG_GIACEN          	: SU U_MAG_GG - CONTIENE IL TOTALE DELLE GIACENZE
*!*			AQM_GG_QTAKG           	: SU U_MAG_GG - CONTIENE IL TOTALE DELLE GIACENZE IN CHILOGRAMMI
*!*			AQM_GG_QTAMQ          	: SU U_MAG_GG - CONTIENE IL TOTALE DELLE GIACENZE IN METRI QUADRI
*!*			AQM_GG_QTAML           	: SU U_MAG_GG - CONTIENE IL TOTALE DELLE GIACENZE IN METRI LINEARI
*!*					
*!*					
*!*					
*!*					
*!*					
*!*					



=VERIFICA_SE_ARTICOLO_DEVE_GESTIRE_IL_MAGAZZINO(_AQM_CODART)



DO CASE 


	CASE AQM_VERIFICA = "01"	&& CONFRONTA LA GIACENZA DI U_MAG_GG CON LA GIACENZA DI U_MAG_MO E SCRIVE LOG_NEW_MAG / = NO NON CONFRONTA LE GIACENZE

		AQM_SCRIVE_LOG_ERRORI = .T.
		=CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_MO(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_MO)
		=CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_GG(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_GG)
		=CONFRONTA_GIACENZA_MAGAZZINO()



	CASE AQM_VERIFICA = "02"	&& VERIFICA L'ESISTENZA DEL MOVIMENTO DI MAGAZZINO GENERATO DAL DETTAGLIO DELLA DDT

		AQM_SCRIVE_LOG_ERRORI = .T.
		=CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_MO(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_MO)


	CASE AQM_VERIFICA = "03"	&& CALCOLA LA GIACENZA SU U_MAG_MO

		AQM_SCRIVE_LOG_ERRORI = .F.
		=CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_MO(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_MO)


	CASE AQM_VERIFICA = "04"	&& CALCOLA LA GIACENZA SU U_MAG_GG

		AQM_SCRIVE_LOG_ERRORI = .F.
		=CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_GG(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_GG)



ENDCASE

RETURN



*******************************************************
FUNCTION VERIFICA_SE_ARTICOLO_DEVE_GESTIRE_IL_MAGAZZINO
*******************************************************
PARAMETERS _AQM_CODART

AABBSS    = SELECT()

*==> ACCESSO ALLA ANAGRAFICA ARTICOLI PER VERIFICARE SE TRATTASI DI ARTICOLO CHE MOVIMENTA 
*==> LA GIACENZA O MENO

AQM_NONMOV = .F.
AQM_DESART = ""

IF !EMPTY(_AQM_CODART)
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + ALLTRIM(_AQM_CODART) + "'"
	x_cond = x_soci + " and " + x_codi
	Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
	IF !ExecCommand(cSql,"AQM_U_ART_PR")
	   SELECT(AABBSS)
	   return(.f.)
	ENDIF
	SELECT AQM_U_ART_PR
	IF EOF()
	   RETURN
	ENDIF
	AQM_DESART = ART_DESCR
	AQM_NONMOV = ART_NONMOV		&& SE = .T. NON DEVE AGGIORNARE IL MAGAZZINO
ELSE
    AQM_DESART = ""
	AQM_NONMOV = .F.     		&& SE = .F. DEVE AGGIORNARE IL MAGAZZINO
ENDIF

SELECT(AABBSS)


RETURN


************************************************************************************************
FUNCTION CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_MO
************************************************************************************************
PARAMETERS _AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_MO



IF EMPTY(_AQM_CODMAG)
	x_maga = "mov_codmag = mov_codmag" 
ELSE
	x_maga = "mov_codmag = '" + ALLTRIM(_AQM_CODMAG) + "'"
ENDIF

IF EMPTY(_AQM_CODART)
	x_arti = "mov_anaart = mov_anaart" 
ELSE
	x_arti = "mov_anaart = '" + ALLTRIM(_AQM_CODART) + "'"
ENDIF

IF EMPTY(_AQM_CODFOR)
	x_forn = "mov_codfor = mov_codfor" 
ELSE
	x_forn = "mov_codfor = '" + ALLTRIM(_AQM_CODFOR) + "'"
ENDIF

IF EMPTY(_AQM_LEGSYS)
	x_legsy = "mov_legsys = mov_legsys" 
ELSE
	x_legsy = "mov_legsys = '" + ALLTRIM(_AQM_LEGSYS) + "'"
ENDIF

IF EMPTY(_AQM_UNIQUE)
	x_uniq = "mov_unique = mov_unique" 
ELSE
	x_uniq = "mov_unique = '" + ALLTRIM(_AQM_UNIQUE) + "'"
ENDIF

IF EMPTY(_AQM_NUMIDE)
	x_numi = "mov_numide = mov_numide" 
ELSE
	x_numi = "mov_numide = '" + ALLTRIM(_AQM_NUMIDE) + "'"
ENDIF




DO CASE


	CASE _AQM_ACCESSO_MO = 1
		x_cond = x_maga + " and " + x_arti									&& accesso per magazzino+articolo 
		
	CASE _AQM_ACCESSO_MO = 2
		x_cond = x_maga + " and " + x_arti + " and " + x_forn				&& accesso per magazzino+articolo+fornitore

	CASE _AQM_ACCESSO_MO = 3
		x_cond = x_arti + " and " + x_legsy									&& accesso per articolo+legsys

	CASE _AQM_ACCESSO_MO = 4
		x_cond = x_legsy  													&& accesso per legsys
	
	CASE _AQM_ACCESSO_MO = 5
		x_cond = x_uniq  													&& accesso per unique
	
	CASE _AQM_ACCESSO_MO = 6
		x_cond = x_numi  													&& accesso per numide

	
	OTHERWISE
		x_cond = x_maga + " and " + x_arti 									&& accesso per magazzino+articolo 
	
	
ENDCASE



cSql   = "SELECT * FROM U_MAG_MO WHERE " + x_cond
IF !ExecCommand(cSql,"AQM_U_MAG_MO")
   return(.f.)
ENDIF 


AQM_MO_QTAMOV      = 0			&& SU U_MAG_MO - CONTIENE IL TOTALE DELLE QUANTITA'  DEI MOVIMENTI
AQM_MO_QTAKG       = 0			&& SU U_MAG_MO - CONTIENE IL TOTALE DELLE QUANTITA'  DEI MOVIMENTI IN CHILOGRAMMI
AQM_MO_QTAMQ       = 0 			&& SU U_MAG_MO - CONTIENE IL TOTALE DELLE QUANTITA'  DEI MOVIMENTI IN METRI QUADRI
AQM_MO_QTAML       = 0			&& SU U_MAG_MO - CONTIENE IL TOTALE DELLE QUANTITA'  DEI MOVIMENTI IN METRI LINEARI

SELECT AQM_U_MAG_MO
GO TOP
IF EOF()						&& NON HO TROVATO NESSUN RECORD SUL U_MAG_MO E SE STO FACENDO UNA VERIFICA CREO IL LOG DEGLI ERRORI
	IF AQM_SCRIVE_LOG_ERRORI 
		M.AQM_ERROR       	= "MANCA_U_MAG_MO"
		M.AQM_MESSAGE   	= "NON E' STATO AGGIORNATO IL MAGAZZINO"
		=SCRIVE_LOG_ERRORI()	
	ENDIF
	RETURN	
ENDIF
   
SELECT AQM_U_MAG_MO
GO TOP
                     
DO WHILE .NOT. EOF()

   	IF DELETED()
      SELECT AQM_U_MAG_MO
      SKIP +1
      LOOP
   	ENDIF

   	SELECT AQM_U_MAG_MO


	DO 	CASE
	
		CASE MOV_SEGNO = '+'

			AQM_MO_QTAMOV	= AQM_MO_QTAMOV + MOV_QTAMOV
			AQM_MO_QTAKG	= AQM_MO_QTAKG  + MOV_QTAKG
			AQM_MO_QTAMQ  	= AQM_MO_QTAMQ  + MOV_QTAMQ   
			AQM_MO_QTAML   	= AQM_MO_QTAML  + MOV_QTAML 


		CASE MOV_SEGNO = '-'	
	
			AQM_MO_QTAMOV	= AQM_MO_QTAMOV - MOV_QTAMOV
			AQM_MO_QTAKG	= AQM_MO_QTAKG  - MOV_QTAKG
			AQM_MO_QTAMQ  	= AQM_MO_QTAMQ  - MOV_QTAMQ   
			AQM_MO_QTAML   	= AQM_MO_QTAML  - MOV_QTAML 
	

	
	ENDCASE
	


    SELECT AQM_U_MAG_MO      
   	SKIP +1
      
ENDDO




RETURN



************************************************************************************************
FUNCTION CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_GG
************************************************************************************************
PARAMETERS _AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_GG



IF EMPTY(_AQM_CODMAG)
	x_maga = "mag_codmag = mag_codmag" 
ELSE
	x_maga = "mag_codmag = '" + ALLTRIM(_AQM_CODMAG) + "'"
ENDIF

IF EMPTY(_AQM_CODART)
	x_arti = "mag_anaart = mag_anaart" 
ELSE
	x_arti = "mag_anaart = '" + ALLTRIM(_AQM_CODART) + "'"
ENDIF

IF EMPTY(_AQM_CODFOR)
	x_forn = "mag_fornit = mag_fornit" 
ELSE
	x_forn = "mag_fornit = '" + ALLTRIM(_AQM_CODFOR) + "'"
ENDIF

IF EMPTY(_AQM_LEGSYS)
	x_legsy = "mag_legsys = mag_legsys" 
ELSE
	x_legsy = "mag_legsys = '" + ALLTRIM(_AQM_LEGSYS) + "'"
ENDIF

IF EMPTY(_AQM_UNIQUE)
	x_uniq = "mag_unique = mag_unique" 
ELSE
	x_uniq = "mag_unique = '" + ALLTRIM(_AQM_UNIQUE) + "'"
ENDIF

IF EMPTY(_AQM_NUMIDE)
	x_numi = "mag_numide = mag_numide" 
ELSE
	x_numi = "mag_numide = '" + ALLTRIM(_AQM_NUMIDE) + "'"
ENDIF




DO CASE


	CASE _AQM_ACCESSO_GG = 1
		x_cond = x_maga + " and " + x_arti									&& accesso per magazzino+articolo 
		
	CASE _AQM_ACCESSO_GG = 2
		x_cond = x_maga + " and " + x_arti + " and " + x_forn				&& accesso per magazzino+articolo+fornitore

	CASE _AQM_ACCESSO_GG = 3
		x_cond = x_arti + " and " + x_legsy									&& accesso per articolo+legsys

	CASE _AQM_ACCESSO_GG = 4
		x_cond = x_legsy  													&& accesso per legsys
	
	CASE _AQM_ACCESSO_GG = 5
		x_cond = x_uniq  													&& accesso per unique
	
	CASE _AQM_ACCESSO_GG = 6
		x_cond = x_numi  													&& accesso per numide

	
	OTHERWISE
		x_cond = x_maga + " and " + x_arti 									&& accesso per magazzino+articolo 
	
	
ENDCASE



cSql   = "SELECT * FROM U_MAG_GG WHERE " + x_cond
IF !ExecCommand(cSql,"AQM_U_MAG_GG")
   return(.f.)
ENDIF 
   
AQM_GG_GIACEN      = 0			&& SU U_MAG_GG - CONTIENE IL TOTALE DELLE GIACENZE
AQM_GG_QTAKG       = 0			&& SU U_MAG_GG - CONTIENE IL TOTALE DELLE GIACENZE IN CHILOGRAMMI
AQM_GG_QTAMQ       = 0			&& SU U_MAG_GG - CONTIENE IL TOTALE DELLE GIACENZE IN METRI QUADRI
AQM_GG_QTAML       = 0			&& SU U_MAG_GG - CONTIENE IL TOTALE DELLE GIACENZE IN METRI LINEARI
 
   
SELECT AQM_U_MAG_GG
GO TOP
                     
DO WHILE .NOT. EOF()

   	IF DELETED()
      SELECT AQM_U_MAG_GG
      SKIP +1
      LOOP
   	ENDIF

   	SELECT AQM_U_MAG_GG

	AQM_GG_GIACEN  = AQM_GG_GIACEN + MAG_GIACEN
	AQM_GG_QTAKG   = AQM_GG_QTAKG  + MAG_QTAKG
	AQM_GG_QTAMQ   = AQM_GG_QTAMQ  + MAG_QTAMQ   
	AQM_GG_QTAML   = AQM_GG_QTAML  + MAG_QTAML 


    SELECT AQM_U_MAG_GG      
   	SKIP +1
      
ENDDO




RETURN


*************************************
FUNCTION CONFRONTA_GIACENZA_MAGAZZINO
*************************************


M.AQM_MO_QTAMOV   	= AQM_MO_QTAMOV
M.AQM_MO_QTAKG    	= AQM_MO_QTAKG
M.AQM_MO_QTAMQ    	= AQM_MO_QTAMQ
M.AQM_MO_QTAML    	= AQM_MO_QTAML

M.AQM_GG_GIACEN   	= AQM_GG_GIACEN
M.AQM_GG_QTAKG    	= AQM_GG_QTAKG
M.AQM_GG_QTAMQ    	= AQM_GG_QTAMQ
M.AQM_GG_QTAML    	= AQM_GG_QTAML


IF	AQM_GG_GIACEN  = AQM_MO_QTAMOV 		&& GIACENZA CORRETTA : NESSUNA OPERAZIONE
	RETURN
ENDIF

M.AQM_ERROR       	= "GIACENZA-KO-KO-KO"
M.AQM_MESSAGE   	= "TOTALE GIACENZA <> TOTALE MOVIMENTI (ENTRATE-USCITE)"
=SCRIVE_LOG_ERRORI()

RETURN

***********************************************
FUNCTION SCRIVE_LOG_ERRORI
***********************************************

AQM_ERRORI      = AQM_ERRORI  +1

CSQL = "select * from LOG_NEW_MAG where 0=1"
IF !ExecCommand(CSQL,"CU_LOG_NEW_MAG")
   return(.f.)
ENDIF


SELECT CU_LOG_NEW_MAG
APPEND BLANK
REPLACE LOG_TIPLOG      WITH   M.AQM_ERROR                                                                                                                                                                                 
REPLACE LOG_DATLOG      WITH   RIBALTA2(DTOC(DATE()))                                                                                                                                                                              
REPLACE LOG_ORALOG      WITH   TIME()                                                                                                                                                                                    
REPLACE LOG_NOTLOG      WITH   AQM_MESSAGE                                                                                                                                                                                                                                                                                                                                                                         
REPLACE id_unique       WITH   ""                                                                                                                                                                                           
REPLACE MAG_CODMAG      WITH   _AQM_CODMAG                                                                                                                                                                            
REPLACE MAG_ANAART      WITH   _AQM_CODART                                                                                                                                                                                
REPLACE MAG_DESART      WITH   AQM_DESART                                                                                                                                                                              
REPLACE AQM_GG_GIACEN   WITH   M.AQM_GG_GIACEN                                                                                                                                                                                                                 
REPLACE AQM_GG_QTAKG    WITH   M.AQM_GG_QTAKG                                                                                                                                                                                                           
REPLACE AQM_GG_QTAMQ    WITH   M.AQM_GG_QTAMQ                                                                                                                                                                                                         
REPLACE AQM_GG_QTAML    WITH   M.AQM_GG_QTAML                                                                                                                                                                                                            
REPLACE AQM_MO_QTAMOV   WITH   M.AQM_MO_QTAMOV                                                                                                                                                                                                         
REPLACE AQM_MO_QTAKG    WITH   M.AQM_MO_QTAKG                                                                                                                                                                                                         
REPLACE AQM_MO_QTAMQ    WITH   M.AQM_MO_QTAMQ                                                                                                                                                                                                      
REPLACE AQM_MO_QTAML    WITH   M.AQM_MO_QTAML                                                                                                                                                                                                            
REPLACE MAG_CODCLI      WITH   ""                                                                                                                                                                                  
REPLACE MAG_RAGSOC      WITH   ""                                                                                                                                                                                  
REPLACE MAG_NUMORD      WITH   ""                                                                                                                                                                                
REPLACE MAG_DATORD      WITH   ""                                                                                                                                                                            
REPLACE MAG_LEGAME      WITH   ""                                                                                                                                                                         
REPLACE MAG_LEGSYS      WITH   _AQM_LEGSYS                                                                                                                                                                         
REPLACE MAG_ALTEZZ      WITH   0                                                                                                                                                                                                              
REPLACE MAG_LUNGHE      WITH   0                                                                                                                                                                                                 
REPLACE MAG_NUMBOB      WITH   0                                                                                                                                                                                             
REPLACE MAG_SERBOL      WITH   SPACE(03)                                                                                                                                                                          
REPLACE MAG_ANNOPR      WITH   0                                                                                                                                                                                               
REPLACE MAG_SERNUM      WITH   SPACE(03)                                                                                                                                                                         
REPLACE MAG_NUMEDA      WITH   0                                                                                                                                                                                                      
REPLACE MAG_NUMEAL      WITH   0                                                                                                                                                                                                       
REPLACE MAG_AAPROD      WITH   0                                                                                                                                                                                                    
REPLACE MAG_FLGCEL      WITH   .F.                                                                                                                                                                                                                  
REPLACE MAG_SERIE       WITH   SPACE(03)                                                                                                                                                                               


IF !ExecRW('','LOG_NEW_MAG','I','','CU_LOG_NEW_MAG')
   return(.f.)
ENDIF


RETURN

************************************************************************************************
FUNCTION RICALCOLA_IMPEGNATO_SU_U_MAG_GG
************************************************************************************************
PARAMETERS _AQM_CODMAG,_AQM_CODART,_AQM_ACCESSO_GG,_AQM_DATADA,_AQM_DATAA
*!*									:
*!*									:
*!*		  _AQM_ACCESSO_GG			: 	= 1 ACCESSO PER	:	TUTTI I MOVIMENTI	()
*!*									:	= 2 ACCESSO PER :	MAGAZZINO+ARTICOLO  (_AQM_CODMAG,_AQM_CODART)
*!*	 								:	= 3 ACCESSO PER :	ARTICOLO			(_AQM_CODART)
*!*	 								:	= 4 ACCESSO PER :	DATA DA/A			(_AQM_DATADA,_AQM_DATAA)


=AZZERA_IMPEGNATO_SU_U_MAG_GG(_AQM_CODMAG,_AQM_CODART,_AQM_ACCESSO_GG,_AQM_DATADA,_AQM_DATAA)			&& AZZERA L'IMPEGNATO


IF EMPTY(_AQM_CODMAG)
	x_maga = "mag_codmag = mag_codmag" 
ELSE
	x_maga = "mag_codmag = '" + ALLTRIM(_AQM_CODMAG) + "'"
ENDIF

IF EMPTY(_AQM_CODART)
	x_arti = "mag_anaart = mag_anaart" 
ELSE
	x_arti = "mag_anaart = '" + ALLTRIM(_AQM_CODART) + "'"
ENDIF


DO CASE

	CASE _AQM_ACCESSO_GG = 1
		x_cond = "mag_codmag = mag_codmag"												&& accesso a tutti i movimenti 

	CASE _AQM_ACCESSO_GG = 2
		x_cond = x_maga + " and " + x_arti												&& accesso per magazzino+articolo 
		
	CASE _AQM_ACCESSO_GG = 3
		x_cond = x_arti 																&& accesso per articolo
	
	CASE _AQM_ACCESSO_GG = 4
	
		x_cond = "mag_datagg between '" + _aqm_datada + "' and '" + _aqm_dataa + "'"	&& accesso per data

	
	OTHERWISE
		x_cond = "mag_codmag = mag_codmag"												&& accesso a tutti i movimenti 
	

	
ENDCASE


cSql   = "SELECT * FROM U_MAG_GG WHERE " + x_cond
IF !ExecCommand(cSql,"AQM_U_MAG_GG")
   return(.f.)
ENDIF 
   
   
SELECT AQM_U_MAG_GG
GO TOP
                     
DO WHILE .NOT. EOF()

   	IF DELETED()
      SELECT AQM_U_MAG_GG
      SKIP +1
      LOOP
   	ENDIF

   	SELECT AQM_U_MAG_GG

	_CODART = MAG_ANAART
	_FUNZIO = "RICALCOLA"
	=CALCIMPE(_CODART,_FUNZIO)


    SELECT AQM_U_MAG_GG      
   	SKIP +1
      
ENDDO



RETURN

************************************************************************************************
FUNCTION AZZERA_IMPEGNATO_SU_U_MAG_GG
************************************************************************************************
PARAMETERS _AQM_CODMAG,_AQM_CODART,_AQM_ACCESSO_GG,_AQM_DATADA,_AQM_DATAA
*!*									:
*!*									:
*!*		  _AQM_ACCESSO_GG			: 	= 1 ACCESSO PER	:	TUTTI I MOVIMENTI	()
*!*									:	= 2 ACCESSO PER :	MAGAZZINO+ARTICOLO  (_AQM_CODMAG,_AQM_CODART)
*!*	 								:	= 3 ACCESSO PER :	ARTICOLO			(_AQM_CODART)


IF EMPTY(_AQM_CODMAG)
	x_maga = "mag_codmag = mag_codmag" 
ELSE
	x_maga = "mag_codmag = '" + ALLTRIM(_AQM_CODMAG) + "'"
ENDIF

IF EMPTY(_AQM_CODART)
	x_arti = "mag_anaart = mag_anaart" 
ELSE
	x_arti = "mag_anaart = '" + ALLTRIM(_AQM_CODART) + "'"
ENDIF



DO CASE

	CASE _AQM_ACCESSO_GG = 1
		x_cond = "mag_codmag = mag_codmag"												&& accesso a tutti i movimenti 

	CASE _AQM_ACCESSO_GG = 2
		x_cond = x_maga + " and " + x_arti												&& accesso per magazzino+articolo 
		
	CASE _AQM_ACCESSO_GG = 3
		x_cond = x_arti 																&& accesso per articolo

	CASE _AQM_ACCESSO_GG = 4
	
		x_cond = "mag_datagg between '" + _aqm_datada + "' and '" + _aqm_dataa + "'"	&& accesso per data

	
	OTHERWISE
		x_cond = "mag_codmag = mag_codmag"												&& accesso a tutti i movimenti 
	
ENDCASE



cSql   = "SELECT * FROM U_MAG_GG WHERE " + x_cond
IF !ExecCommand(cSql,"AQM_U_MAG_GG")
   return(.f.)
ENDIF 
   
   
SELECT AQM_U_MAG_GG
GO TOP
                     
DO WHILE .NOT. EOF()

   	IF DELETED()
      SELECT AQM_U_MAG_GG
      SKIP +1
      LOOP
   	ENDIF

   	SELECT AQM_U_MAG_GG

    REPLACE MAG_QTAIMP WITH 0								&& AZZERA LA QUANTITA' IMPERGNATA DEL SINGOLO ARTICOLO

    SELECT AQM_U_MAG_GG      
   	SKIP +1
      
ENDDO

IF !ExecRW('','U_MAG_GG','I','','AQM_U_MAG_GG')				&& RISCRIVE LA TABELLA
   return(.f.)
ENDIF



RETURN





