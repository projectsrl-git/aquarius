
********************************************************************************************************************************************************************************************************************
FUNCTION VERIFICA_SPEDITO_CON_MAGAZZINO
********************************************************************************************************************************************************************************************************************
PARAMETERS _AQM_CODCLI,_AQM_DATADA,_AQM_DATAA,_AQM_OPZAGG

PUB_TOT_TT = 0
PUB_TOT_DD = 0

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
SET FILTER TO TAGGANCIO > ULTIMO_DOCUMENTO_NON_AQMLIB("BOL")  && PROCEDURA ESEGUIBILE SOLO SU BOLLE GESTITE TRAMITE AQMLIB
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
   
    WAIT WINDOWS "Controllo esistenza e corrispondenza quantità Movimenti in funzione dei dettagli DDT in corso..." + CHR(13) + ;
    	"NUMERO DDT IN ELABORAZIONE : " + ORD_NUMORD + " del " + RIBALTA2(ORD_DATORD) NOWAIT
    
    _NUMORD = ORD_NUMORD 
    _DATORD = ORD_DATORD

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
		AQM_NUMDDT = _NUMORD
		AQM_DATDDT = _DATORD
		AQM_QTADDT = ORD_QTAORD

		SELECT AQM_U_BOL_DD
		
		AQM_VERIFICA  	= "02"  		&& VERIFICA L'ESISTENZA DEL MOVIMENTO DI MAGAZZINO GENERATO DAL DETTAGLIO DELLA DDT
		AQM_AGG_MAGGG  	= "NO"  		&& NON EFFETTUA NESSUN AGGIORNAMENTO SU U_MAG_GG
		IF _AQM_OPZAGG = 2
			AQM_AGG_MAGMO = "SI"  		&& EFFETTUA AGGIORNAMENTO SU U_MAG_MO
		ELSE
			AQM_AGG_MAGMO = "NO"  		&& NON EFFETTUA NESSUN AGGIORNAMENTO SU U_MAG_MO
		ENDIF
		AQM_ACCESSO_GG  = 1				&& ACCESSO PER MAGAZZINO+ARTICOLO
		AQM_ACCESSO_MO  = 4				&& ACCESSO PER LEGSYS
		AQM_CODMAG 		= ORD_MAGA  
		AQM_CODART      = ORD_CODART   
		*AQM_LEGSYS      = ORD_LEGSYS	&& CODICE SYS IDENTIFICATIVO CHE LEGA U_MAG_GG+U_MAG_MO AI DOCUMENTI TRAMITE ORD_LEGSYS
		AQM_LEGSYS      = ORD_SYSMAG	&& CODICE SYS IDENTIFICATIVO CHE LEGA U_MAG_GG+U_MAG_MO AI DOCUMENTI TRAMITE ORD_LEGSYS (SOLO DDT CREATE TRAMITE AQMLIB)

		=CALCOLA_GIACENZE_VALORI_MAGAZZINO(AQM_VERIFICA,AQM_AGG_MAGGG,AQM_AGG_MAGMO,AQM_ACCESSO_GG,AQM_ACCESSO_MO,AQM_CODMAG,AQM_CODART,AQM_CODFOR,AQM_LEGSYS,AQM_NUMIDE,AQM_UNIQUE,AQM_NRLINT,AQM_DTREGI,AQM_SERIE,AQM_FILA_X,AQM_PIAN_N,AQM_UBIC_X)
		
		PUB_TOT_DD = PUB_TOT_DD + 1

	    SELECT AQM_U_BOL_DD
	    SKIP +1
	      	
	      				   
	ENDDO WHILE .NOT.EOF()   
	
    PUB_TOT_TT = PUB_TOT_TT + 1
   
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
IF AQM_NONMOV
	RETURN
ENDIF

DO CASE 


	CASE AQM_VERIFICA = "01"	&& CONFRONTA LA GIACENZA DI U_MAG_GG CON LA GIACENZA DI U_MAG_MO E SCRIVE LOG_NEW_MAG / = NO NON CONFRONTA LE GIACENZE

		AQM_SCRIVE_LOG_ERRORI = .T.
		=CALCOLA_SALDO_MAGAZZINO_SU_U_MAG_MO(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_MO)
		=CALCOLA_SALDO_MAGAZZINO_SU_U_MAG_GG(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_GG)
		=CONFRONTA_GIACENZA_MAGAZZINO()



	CASE AQM_VERIFICA = "02"	&& VERIFICA L'ESISTENZA DEL MOVIMENTO DI MAGAZZINO GENERATO DAL DETTAGLIO DELLA DDT

		AQM_SCRIVE_LOG_ERRORI = .T.
		=CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_MO(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_MO,_AQM_AGG_MAGMO)


	CASE AQM_VERIFICA = "03"	&& CALCOLA LA GIACENZA SU U_MAG_MO

		AQM_SCRIVE_LOG_ERRORI = .F.
		=CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_MO(_AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_MO,_AQM_AGG_MAGMO)


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

*AQM_NONMOV = .F.
AQM_NONMOV = .T.
AQM_DESART = ""

IF !EMPTY(_AQM_CODART)
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + ALLTRIM(_AQM_CODART) + "'"
	x_cond = x_soci + " and " + x_codi
	Csql   = "select ART_DESCR,ART_NONMOV from u_art_pr where " + x_cond
	IF !ExecCommand(cSql,"AQM_U_ART_PR")
	   SELECT(AABBSS)
	   return(.f.)
	ENDIF
	SELECT AQM_U_ART_PR
	GO TOP
	IF EOF()
	*   RETURN
	*ENDIF
	ELSE
		AQM_DESART = ART_DESCR
		AQM_NONMOV = ART_NONMOV		&& SE = .T. NON DEVE AGGIORNARE IL MAGAZZINO
	ENDIF
ELSE
    AQM_DESART = ""
	*AQM_NONMOV = .F.     		&& SE = .F. DEVE AGGIORNARE IL MAGAZZINO
	AQM_NONMOV = .T.     		&& SE = .F. DEVE AGGIORNARE IL MAGAZZINO
ENDIF

SELECT(AABBSS)


RETURN 


************************************************************************************************
FUNCTION CALCOLA_GIACENZA_VALORE_MAGAZZINO_SU_U_MAG_MO
************************************************************************************************
PARAMETERS _AQM_CODMAG,_AQM_CODART,_AQM_CODFOR,_AQM_LEGSYS,_AQM_UNIQUE,_AQM_NUMIDE,_AQM_ACCESSO_MO,_AQM_AGG_MAGMO


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
M.AQM_MO_PREACQ = 0  && ERASMO - 29/04/2011
M.AQM_GG_PRZCON = 0  && ERASMO - 29/04/2011

SELECT AQM_U_MAG_MO
GO TOP
IF EOF()						&& NON HO TROVATO NESSUN RECORD SUL U_MAG_MO E SE STO FACENDO UNA VERIFICA CREO IL LOG DEGLI ERRORI
	IF AQM_SCRIVE_LOG_ERRORI 
		M.AQM_ERROR       	= "MANCA_U_MAG_MO"
		*M.AQM_MESSAGE   	= "NON E' STATO AGGIORNATO IL MAGAZZINO"
		M.AQM_MESSAGE   	= "NON E' STATO SCRITTO ALCUN MOVIMENTO DI MAGAZZINO"
		=SCRIVE_LOG_ERRORI()	
		PUB_MOVLOG = PUB_MOVLOG + 1
	ENDIF
	RETURN	
ENDIF
   
SELECT AQM_U_MAG_MO
GO TOP
XX_TOT_MOVIM = 0   && ERASMO - 13/05/2011
XX_ID_UNIQUE = ""  && ERASMO - 13/05/2011
DO WHILE .NOT. EOF()

   	IF DELETED()
      SELECT AQM_U_MAG_MO
      SKIP +1
      LOOP
   	ENDIF

   	SELECT AQM_U_MAG_MO
   	
   	XX_TOT_MOVIM = XX_TOT_MOVIM + 1	&& ERASMO - 13/05/2011
   	XX_ID_UNIQUE = ID_UNIQUE		&& ERASMO - 13/05/2011

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


IF AQM_SCRIVE_LOG_ERRORI
	_QTA_MOVIMENTATA = AQM_MO_QTAMOV * -1
	IF _QTA_MOVIMENTATA <> AQM_QTADDT
		M.AQM_ERROR       	= "QTAMOV_DIVERSA_DA_QTADDT"
		M.AQM_MESSAGE   	= "LA QUANTITA' IN DDT E' DIVERSA DALLA QUANTITA' MOVIMENTATA"
		**=> ERASMO - INIZIO 13/05/2011
		*IF _AQM_OPZAGG = 2  && 1 = VERIFICA ; 2 = AGGIORNA
		IF ALLTRIM(_AQM_AGG_MAGMO) == "SI"
			DO CASE
				CASE XX_TOT_MOVIM < 1
					M.AQM_MESSAGE = M.AQM_MESSAGE + " => IMPOSSIBILE AGGIORNARE LA QTA NEL MOVIMENTO PERCHE' MOVIMENTO INESISTENTE"
				CASE XX_TOT_MOVIM > 1
					M.AQM_MESSAGE = M.AQM_MESSAGE + " => IMPOSSIBILE AGGIORNARE LA QTA NEL MOVIMENTO PERCHE' ESISTONO PIU' MOVIMENTI LEGATI"
				OTHERWISE
					XX_QTAMOV = ALLTRIM(STR(AQM_QTADDT,12,2))
					XX_QTAMOV = STRTRAN(XX_QTAMOV,",",".")
					u_Cond = "id_unique = '" + XX_ID_UNIQUE + "'"
					uSql   = "UPDATE U_MAG_MO SET MOV_QTAMOV = " + XX_QTAMOV + " WHERE " + u_Cond
					IF !ExecCommand(uSql,"AQM_U_MAG_MO")
					   return(.f.)
					ENDIF
					M.AQM_MESSAGE = M.AQM_MESSAGE + " => AGGIORNAMENTO DELLA QTA' NEL MOVIMENTO EFFETTUATO"
			ENDCASE
		ENDIF
		**=> ERASMO - FINE 13/05/2011
		=SCRIVE_LOG_ERRORI()
		PUB_MOVLOG = PUB_MOVLOG + 1
	ENDIF
ENDIF


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

M.AQM_MO_PREACQ = 0  && ERASMO - 29/04/2011
M.AQM_GG_PRZCON = 0  && ERASMO - 29/04/2011


IF	AQM_GG_GIACEN  = AQM_MO_QTAMOV 		&& GIACENZA CORRETTA : NESSUNA OPERAZIONE
	RETURN
ENDIF

M.AQM_ERROR       	= "GIACENZA-KO-KO-KO"
M.AQM_MESSAGE   	= "TOTALE GIACENZA <> TOTALE MOVIMENTI (ENTRATE-USCITE)"
=SCRIVE_LOG_ERRORI()
PUB_MOGLOG = PUB_MOGLOG + 1

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
*REPLACE LOG_DATLOG      WITH   RIBALTA2(DTOC(DATE()))                                                                                                                                                                              
*REPLACE LOG_ORALOG      WITH   TIME()                                                                                                                                                                                    
REPLACE LOG_DATLOG      WITH   PUB_DATLOG
REPLACE LOG_ORALOG      WITH   PUB_ORALOG
REPLACE LOG_NOTLOG      WITH   AQM_MESSAGE
REPLACE ORD_NUMORD		WITH   AQM_NUMDDT
REPLACE ORD_DATORD		WITH   AQM_DATDDT
REPLACE ORD_QTAORD		WITH   AQM_QTADDT
*REPLACE id_unique       WITH   ""                                                                                                                                                                                           
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
REPLACE AQM_GG_QTAIMP   WITH   M.AQM_GG_QTAIMP
REPLACE AQM_PK_QTAIMP   WITH   M.AQM_PK_QTAIMP
REPLACE AQM_MO_PREACQ   WITH   M.AQM_MO_PREACQ  && ERASMO - 29/04/2011
REPLACE AQM_GG_PRZCON   WITH   M.AQM_GG_PRZCON  && ERASMO - 29/04/2011
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

PUB_TOTLOG = PUB_TOTLOG + 1

IF !ExecRW('','LOG_NEW_MAG','I','','CU_LOG_NEW_MAG')
   return(.f.)
ENDIF


RETURN



********************************************************************************************************************************************************************************************************************
FUNCTION VERIFICA_SPEDITO_CON_IMPEGNATO
********************************************************************************************************************************************************************************************************************
PARAMETERS _AQM_CODCLI,_AQM_DATADA,_AQM_DATAA,_AQM_OPZAGG

*!*	ELABORA DDT PER PERIODO/CLIENTE

PUB_TOT_TT = 0
PUB_TOT_DD = 0

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
SET FILTER TO TAGGANCIO > ULTIMO_DOCUMENTO_NON_AQMLIB("BOL")  && PROCEDURA ESEGUIBILE SOLO SU BOLLE GESTITE TRAMITE AQMLIB
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
   
    WAIT WINDOWS "Controllo quantità impegnata in giacenze per gli articoli in dettagli DDT in corso..." + CHR(13) + ;
    	"NUMERO DDT IN ELABORAZIONE : " + ORD_NUMORD + " del " + RIBALTA2(ORD_DATORD) NOWAIT
    
    _NUMORD = ORD_NUMORD 
    _DATORD = ORD_DATORD

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
		AQM_NUMDDT = _NUMORD
		AQM_DATDDT = _DATORD
		AQM_QTADDT = ORD_QTAORD

		SELECT AQM_U_BOL_DD
		
		_CODMAG	= ORD_MAGA
		_CODART	= ORD_CODART
		IF _AQM_OPZAGG = 1
			_ELABOR = 1  && 1 = VERIFICA ; 2 = AZZERA ; 3 = RICALCOLA
		ELSE
			_ELABOR = 3  && 1 = VERIFICA ; 2 = AZZERA ; 3 = RICALCOLA
		ENDIF
		*_AQM_LEGSYS = ORD_LEGSYS
		_AQM_LEGSYS = ORD_SYSMAG	&& CODICE SYS IDENTIFICATIVO CHE LEGA U_MAG_GG+U_MAG_MO AI DOCUMENTI TRAMITE ORD_LEGSYS (SOLO DDT CREATE TRAMITE AQMLIB)
		=RICALCOLA_IMPEGNATO_SU_U_MAG_GG(_CODMAG,_CODART,_ELABOR)
		
		PUB_TOT_DD = PUB_TOT_DD + 1
		
	    SELECT AQM_U_BOL_DD
	    SKIP +1
	      	
	      				   
	ENDDO WHILE .NOT.EOF()   
	
	PUB_TOT_TT = PUB_TOT_TT + 1
   
   SELECT AQM_U_BOL_TT
   SKIP +1
   
ENDDO WHILE .T.

RETURN


************************************************************************************************
FUNCTION RICALCOLA_IMPEGNATO_SU_U_MAG_GG
************************************************************************************************
PARAMETERS _AQM_CODMAG,_AQM_CODART,_AQM_ELABOR

x_giac = "mag_giacen > 0"
x_data = "mag_datagg <> ''"
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

x_cond = x_giac + " and " + x_data + " and " + x_maga + " and " + x_arti
cSql   = "SELECT MAG_ANAART, SUM(MAG_GIACEN) AS TOT_MAG_GIACEN, SUM(MAG_QTAIMP) AS TOT_MAG_QTAIMP FROM U_MAG_GG WHERE " + x_cond + ;
         "GROUP BY MAG_ANAART"
IF !ExecCommand(cSql,"AQM_U_MAG_GG")
   return(.f.)
ENDIF 

SELECT AQM_U_MAG_GG
GO TOP
IF !EOF()
   	SELECT AQM_U_MAG_GG
	SCATTER MEMVAR
	_CODART = M.MAG_ANAART
	_FUNZIO = ""
	DO CASE
		CASE _AQM_ELABOR = 1
			_FUNZIO = "VERIFICA"
		CASE _AQM_ELABOR = 2
			_FUNZIO = "AZZERA"
		CASE _AQM_ELABOR = 3
			_FUNZIO = "RICALCOLA"
		OTHERWISE
			_FUNZIO = "VERIFICA"
	ENDCASE
	
	_TOT_QUANTI = CALCIMPEGNATO(_CODART,"VERIFICA")
	
   	SELECT AQM_U_MAG_GG
   	
	IF _TOT_QUANTI == M.TOT_MAG_QTAIMP
	ELSE
		IF _FUNZIO <> "VERIFICA"
			=CALCIMPEGNATO(_CODART,_FUNZIO)
		ENDIF
		M.AQM_GG_GIACEN = M.TOT_MAG_GIACEN
		M.AQM_ERROR     = "IMPEGNATO-KO"
		M.AQM_MESSAGE   = "TOTALE QUANTITA' IMPEGNATA IN PACKING LIST <> TOTALE QUANTITA' IMPEGNATA IN GIACENZE"
		IF _FUNZIO = "RICALCOLA"
			M.AQM_MESSAGE = M.AQM_MESSAGE + " => RICALCOLO QTA' IMPEGNATA GIACENZE IN BASE ALLE PACKING LIST EFFETTUATO"
		ENDIF
		M.AQM_GG_QTAIMP = M.TOT_MAG_QTAIMP
		M.AQM_PK_QTAIMP = _TOT_QUANTI
		M.AQM_MO_PREACQ = 0  && ERASMO - 29/04/2011
		M.AQM_GG_PRZCON = 0  && ERASMO - 29/04/2011
		=SCRIVE_LOG_ERRORI()
		PUB_IMPLOG = PUB_IMPLOG + 1
	ENDIF

ENDIF



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



***********************************
FUNCTION CALCIMPEGNATO
***********************************
PARAMETERS _ARTICOLO,_FUNZIONE 


** FUNZIONE PER IL RICALCOLO DELLA QUANTITA' IMPEGNATA DALLE PACKING LIST PER LA GESTIONE DELLE LISTE DI PRELIEVO 
** TRMITE PDA
**
** 1) ACCEDO CON L'ARTICOLO AI DETTAGLI DELLE PACKING LIST (U_PCK_DD) E PER OGNI DETTAGLIO :
**
**    VERIFICO SE E' STATA CREATA UNA DDT TRAMITE LA TABELLA DI LEGAME U_BOL_LE :
**
**         PER QUESTO LEGGO GLI ARTICOLI APPARTENENTI ALLE RIGHE DI PAKING LIST ANCORA APERTE
**                            E LE SALVO IN SAVE_PCK_LE 
**
** 2) RIELABORO LA TABELLA SAVE_PCK_LE E PER OGNI RECORD ACCEDO A U_MAG_GG(MAG_UNIQUE) TRAMITE LEG_SYSMAG 
**    E AZZERO LA QUANTITA' MAG_QTAIMP = 0 SIA A LIVELLO DI RECORD-RIEPILOGO CHE A LIVELLO DI RECORD-DETTAGLIO
**
**
** 3) RIELABORO LA TABELLA SAVE_PCK_LE E PER OGNI RECORD ACCEDO TRAMITE MAG_SYSMAG AL RECORD DEL MAGAZZINO U_MAG_GG 
**    E SOMMO IN  MAG_QTAIMP , LEG_QUANTITA SIA A LIVELLO DI RECORD-RIEPILOGO CHE A LIVELLO DI RECORD-DETTAGLIO
**
**


_RIT = 0

** 0) --- 

IF USED("SAVE_PCK_LE")
	SELECT SAVE_PCK_LE
	USE
ENDIF

cSql   = "select * from u_pck_le where 1=0"
IF !ExecCommand(Csql,"SAVE_PCK_LE")				&& CONTIENE I RIFERIMENTI PER AGGIORNARE LA QUANTITA' IMPEGNATA
   return(.f.)
ENDIF


** 1) ----

IF _FUNZIONE = "VERIFICA" .OR. _FUNZIONE = "AZZERA" .OR. _FUNZIONE = "RICALCOLA"

   x_cart = "U_PCK_LE.LEG_ANAART = '" + ALLTRIM(_ARTICOLO) + "'"
   x_comm = "U_PCK_DD.ORD_DESART <> '*** COMMENTO ***'"
   x_clst = "U_PCK_DD.ORD_CHIUSO = 0"
   x_clsd = "U_PCK_TT.ORD_CHIUSO = 0"
   x_cond = x_cart + " and " + x_comm + " and " + x_clst + " and " + x_clsd 
   cSql   = "select U_PCK_TT.ORD_NUMORD,U_PCK_TT.ORD_DATORD,U_PCK_TT.ORD_CHIUSO,* from u_pck_le " + ;
            "LEFT OUTER JOIN U_PCK_DD ON u_pck_le.LEG_AGGANC = U_PCK_DD.DAGGANCIO AND u_pck_le.LEG_SYSPCK = U_PCK_DD.ORD_CODSYS " + ;
            "LEFT OUTER JOIN U_PCK_TT ON u_pck_le.LEG_AGGANC = U_PCK_TT.TAGGANCIO where " + x_cond 
   IF !ExecCommand(Csql,"K_PCK_LE")
      return(.f.)
   ENDIF
   SELECT K_PCK_LE
   GO TOP
   DO WHILE !EOF()
      SCATTER MEMVAR MEMO
      SELECT SAVE_PCK_LE
      APPEND BLANK
      GATHER MEMVAR MEMO
      _RIT = _RIT + M.LEG_QUANTI
      SELECT K_PCK_LE
      SKIP +1
   ENDDO

ENDIF

** 2) ----

IF _FUNZIONE = "AZZERA" .OR. _FUNZIONE = "RICALCOLA"
	
*!*		SELECT SAVE_PCK_LE
*!*	    GO TOP 
*!*	    
*!*	    DO WHILE .NOT. EOF()
*!*	   
*!*	       SCATTER MEMVAR MEMO 
*!*	       
*!*		   *=> Azzera quantità impegnata sulla giacenza di dettaglio
*!*		   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
*!*		   Csql   = "select * from u_mag_gg where " + x_cond 
*!*		   IF !ExecRW(cSql,"U_MAG_GG","R")
*!*		      return(.f.)
*!*		   ENDIF
*!*		   
*!*		   SELECT U_MAG_GG
*!*		   IF RECCOUNT() <> 0
*!*	           REPLACE MAG_QTAIMP WITH 0
*!*	           IF MAG_NRLINT > 50000000 
*!*		          REPLACE MAG_FLGRIB WITH .T.
*!*		       ENDIF
*!*		   ENDIF

*!*	       SCATTER MEMVAR MEMO   

*!*	       IF !ExecRW(cSql,"U_MAG_GG","W")
*!*	         return(.f.)
*!*	       ENDIF


*!*		   *=> Aggiornamento quantità impegnata sulla giacenza di riepilogo
*!*	       *=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
*!*	       IF TYPE("PUB_GGDTSP") = "L"
*!*	       ELSE
*!*	          PUB_GGDTSP = .T.
*!*	       ENDIF
*!*	       IF PUB_GGDTSP
*!*			   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
*!*			   x_data   = "mag_datagg = '" + SPACE(10) + "'"
*!*			   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
*!*			   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
*!*			   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
*!*			   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
*!*		       **=> ERASMO - INIZIO 07/02/2011
*!*			   Csql   = "UPDATE u_mag_gg SET MAG_QTAIMP = 0 where " + x_cond 
*!*			   IF !ExecCommand(cSql,"UPD_MAG_GG")
*!*			      return(.f.)
*!*			   ENDIF
*!*			   **=> ERASMO - FINE 07/02/2011
*!*		   ENDIF

*!*		   SELECT SAVE_PCK_LE
*!*		   SKIP +1

*!*		ENDDO


	**=> ERASMO - INIZIO 07/03/2011
	*** L'AZZERAMENTO NON DIPENDE DALLE PACKING LIST IN PIEDI, IN QUANTO SICURAMENTE ESISTONO GIACENZE SENZA PACKING LIST ASSOCIATE
	*=> Azzera quantità impegnata sulle giacenza di dettaglio
	x_arti = "mag_anaart = '" + ALLTRIM(_ARTICOLO) + "'"
	x_giac = "mag_giacen > 0"
	x_data = "mag_datagg <> ''"
	x_cond = x_arti + " and " + x_giac + " and " + x_data 
	Csql   = "select * from u_mag_gg where " + x_cond 
	IF !ExecRW(cSql,"U_MAG_GG","R")
	    return(.f.)
	ENDIF
	SELECT U_MAG_GG
	SCAN
		SCATTER MEMVAR MEMO
		REPLACE MAG_QTAIMP WITH 0

		*=> Aggiornamento quantità impegnata sulle giacenza di riepilogo
		*=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
		IF TYPE("PUB_GGDTSP") = "L"
		ELSE
			PUB_GGDTSP = .T.
		ENDIF
		IF PUB_GGDTSP
			x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
			x_data   = "mag_datagg = '" + SPACE(10) + "'"
			x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
			x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
			x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
			x_giac   = "mag_giacen > 0"
			x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_giac
			Csql1    = "UPDATE u_mag_gg SET MAG_QTAIMP = 0 where " + x_cond 
			IF !ExecCommand(Csql1,"UPD_MAG_GG")
				return(.f.)
			ENDIF
		ENDIF   
   ENDSCAN
   IF !ExecRW(cSql,"U_MAG_GG","W")
     return(.f.)
   ENDIF
   **=> ERASMO - FINE 07/03/2011

ENDIF


** 3) ----

IF _FUNZIONE = "RICALCOLA"

	SELECT SAVE_PCK_LE
    GO TOP 
    DO WHILE .NOT. EOF()
   
       SCATTER MEMVAR MEMO 
       
	   *=> Ricalcola e aggiorna la quantità impegnata sulla giacenza di dettaglio
	   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
	   Csql   = "select * from u_mag_gg where " + x_cond 
	   IF !ExecRW(cSql,"U_MAG_GG","R")
	      return(.f.)
	   ENDIF
	   
	   SELECT U_MAG_GG
	   IF RECCOUNT() <> 0
          REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
          IF MAG_NRLINT > 50000000 
             REPLACE MAG_FLGRIB WITH .T.
          ENDIF
	   ENDIF

       SCATTER MEMVAR MEMO   

       IF !ExecRW(cSql,"U_MAG_GG","W")
         return(.f.)
       ENDIF

       **=> ERASMO - INIZIO 07/02/2011
	   *=> Determino la QTA impegnata totale di tutte le giacenze significative a livello di ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
	   _QTAIMP_TOT = 0
	   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
	   x_data   = "mag_datagg <> '" + SPACE(10) + "'"
	   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
	   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
	   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
	   x_giac   = "mag_giacen > 0"
	   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_giac
	   Csql     = "select MAG_QTAIMP from u_mag_gg where " + x_cond
	   IF !ExecCommand(cSql,"QI_MAG_GG")
	      return(.f.)
	   ENDIF
	   SELECT QI_MAG_GG
	   GO TOP
	   SCAN
	      _QTAIMP_TOT = _QTAIMP_TOT + MAG_QTAIMP
	   ENDSCAN
       **=> ERASMO - FINE 07/02/2011

	   *=> Ricalcola e aggiorna la impegnata sulla giacenza di riepilogo
       *=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
       IF TYPE("PUB_GGDTSP") = "L"
       ELSE
          PUB_GGDTSP = .T.
       ENDIF
       IF PUB_GGDTSP
		   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
		   x_data   = "mag_datagg = '" + SPACE(10) + "'"
		   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
		   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
		   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
		   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
		   Csql     = "select * from u_mag_gg where " + x_cond
		   IF !ExecRW(cSql,"U_MAG_GG","R")
		      return(.f.)
		   ENDIF
		   SELECT U_MAG_GG
		   IF RECCOUNT() <> 0
		      *REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
		      REPLACE MAG_QTAIMP WITH _QTAIMP_TOT  && ERASMO - 07/02/2011
              IF MAG_NRLINT > 50000000 
                 REPLACE MAG_FLGRIB WITH .T.
              ENDIF
		   ENDIF
		   SCATTER MEMVAR MEMO   
		   IF !ExecRW(cSql,"U_MAG_GG","W")
		      return(.f.)
		   ENDIF
	   ENDIF


	   SELECT SAVE_PCK_LE
	   SKIP +1

	ENDDO
ENDIF

IF _FUNZIONE = "VERIFICA"
    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+ALLTRIM(_ARTICOLO)+" verificato"
ENDIF

IF _FUNZIONE = "AZZERA"
    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+ALLTRIM(_ARTICOLO)+" azzerato"
ENDIF

IF _FUNZIONE = "RICALCOLA"
    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+ALLTRIM(_ARTICOLO)+" ricalcolato"
ENDIF

IF USED("SAVE_PCK_LE")
	SELECT SAVE_PCK_LE
	USE
ENDIF

RETURN _RIT




********************************************************************************************************************************************************************************************************************
FUNCTION VERIFICA_SPEDITO_CON_PREZZO_DI_COSTO  && ERASMO - 29/04/2011
********************************************************************************************************************************************************************************************************************
PARAMETERS _AQM_CODCLI,_AQM_DATADA,_AQM_DATAA,_AQM_OPZAGG

*!*	ELABORA DDT PER PERIODO/CLIENTE

PUB_TOT_TT = 0
PUB_TOT_DD = 0

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
SET FILTER TO TAGGANCIO > ULTIMO_DOCUMENTO_NON_AQMLIB("BOL")  && PROCEDURA ESEGUIBILE SOLO SU BOLLE GESTITE TRAMITE AQMLIB
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
   
    WAIT WINDOWS "Controllo prezzo di costo in movimenti per gli articoli in dettagli DDT in corso..." + CHR(13) + ;
    	"NUMERO DDT IN ELABORAZIONE : " + ORD_NUMORD + " del " + RIBALTA2(ORD_DATORD) NOWAIT
    
    _NUMORD = ORD_NUMORD 
    _DATORD = ORD_DATORD

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
		AQM_NUMDDT = _NUMORD
		AQM_DATDDT = _DATORD
		AQM_QTADDT = ORD_QTAORD
		_AQM_CODMAG = ORD_MAGA
		_AQM_CODART = ORD_CODART
		AQM_DESART = ORD_DESART

		SELECT AQM_U_BOL_DD
		
		_CODART	= ORD_CODART
		IF _AQM_OPZAGG = 1
			_ELABOR = 1  && 1 = VERIFICA ; 2 = AGGIORNA
		ELSE
			_ELABOR = 2  && 1 = VERIFICA ; 2 = AGGIORNA
		ENDIF
		*_AQM_LEGSYS = ORD_LEGSYS
		_AQM_LEGSYS = ORD_SYSMAG	&& CODICE SYS IDENTIFICATIVO CHE LEGA U_MAG_GG+U_MAG_MO AI DOCUMENTI TRAMITE ORD_LEGSYS (SOLO DDT CREATE TRAMITE AQMLIB)
		=RICALCOLA_PREZZO_COSTO_SU_U_MAG_MO(_AQM_LEGSYS,_CODART,_ELABOR)
		
		PUB_TOT_DD = PUB_TOT_DD + 1
		
	    SELECT AQM_U_BOL_DD
	    SKIP +1
	      	
	      				   
	ENDDO WHILE .NOT.EOF()   
	
	PUB_TOT_TT = PUB_TOT_TT + 1
   
   SELECT AQM_U_BOL_TT
   SKIP +1
   
ENDDO WHILE .T.

RETURN


************************************************************************************************
FUNCTION RICALCOLA_PREZZO_COSTO_SU_U_MAG_MO  && ERASMO - 29/04/2011
************************************************************************************************
PARAMETERS _PAR_LEGSYS,_PAR_ANAART,_PAR_ELABOR

IF EMPTY(_PAR_LEGSYS)
	M.AQM_ERROR     = "PREACQ_MOVIMENTO-KO"
	*M.AQM_MESSAGE   = "NESSUN LEGAME U_BOL_DD.ORD_LEGSYS PER LA VERIFICA DEL PREZZO DI ACQUISTO NEI MOVIMENTI"
	M.AQM_MESSAGE   = "NESSUN LEGAME U_BOL_DD.ORD_SYSMAG PER LA VERIFICA DEL PREZZO DI ACQUISTO NEI MOVIMENTI"
	IF _PAR_ELABOR = 2
		M.AQM_MESSAGE = M.AQM_MESSAGE + " => IMPOSSIBILE AGGIORNARE IL PREZZO NEL MOVIMENTO"
	ENDIF
	M.AQM_MO_PREACQ = 0
	M.AQM_GG_PRZCON = 0
	M.AQM_MO_QTAMOV = 0
	M.AQM_GG_QTAIMP = 0
	M.AQM_PK_QTAIMP = 0
	=SCRIVE_LOG_ERRORI()
	PUB_PRZLOG = PUB_PRZLOG + 1
	RETURN
ENDIF

x_lsys = "mov_legsys = '" + ALLTRIM(_PAR_LEGSYS) + "'"
x_arti = "mov_anaart = '" + ALLTRIM(_PAR_ANAART) + "'"
x_cond = x_lsys + " and " + x_arti 
*cSql   = "SELECT ID_UNIQUE,MOV_ANAART,MOV_LEGSYS,MOV_QTAMOV,MOV_PREACQ,MOV_VALACQ FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI,MOV_ORAMOV"
cSql   = "SELECT ID_UNIQUE,MOV_ANAART,MOV_LEGSYS,MOV_QTAMOV,MOV_PREACQ,MOV_VALACQ,MOV_CODART,MOV_LEGAME FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI,MOV_ORAMOV"
IF !ExecCommand(cSql,"AQM_U_MAG_MO")
   return(.f.)
ENDIF 

SELECT AQM_U_MAG_MO
GO TOP
DO WHILE .T.
	IF EOF()
		EXIT
	ENDIF
	
   	SELECT AQM_U_MAG_MO
	SCATTER MEMVAR

	IF M.MOV_QTAMOV <= 0
		M.AQM_ERROR     = "PREACQ_MOVIMENTO-KO"
		M.AQM_MESSAGE   = "NESSUNA QUANTITA' U_MAG_MO.MOV_QTAMOV PER LA VERIFICA DEL PREZZO DI ACQUISTO NEI MOVIMENTI"
		IF _PAR_ELABOR = 2
			M.AQM_MESSAGE = M.AQM_MESSAGE + " => IMPOSSIBILE AGGIORNARE IL PREZZO NEL MOVIMENTO"
		ENDIF
		M.AQM_MO_PREACQ = 0
		M.AQM_GG_PRZCON = 0
		M.AQM_MO_QTAMOV = 0
		M.AQM_GG_QTAIMP = 0
		M.AQM_PK_QTAIMP = 0
		=SCRIVE_LOG_ERRORI()
		PUB_PRZLOG = PUB_PRZLOG + 1
		SELECT AQM_U_MAG_MO
		SKIP +1
		LOOP
	ENDIF

	XX_QTAMOV  = ALLTRIM(STR(M.MOV_QTAMOV,13,3))
	XX_QTAMOV  = STRTRAN(XX_QTAMOV,",",".")
	XX_ID_UNIQUE = M.ID_UNIQUE
	XX_CODINT  = M.MOV_CODART  &&  ERASMO - 13/05/2011
	XX_LEGAME  = M.MOV_LEGAME
	
	M.AQM_MO_PREACQ = M.MOV_PREACQ
	M.AQM_GG_PRZCON = 0
	M.AQM_MO_QTAMOV = M.MOV_QTAMOV
	M.AQM_GG_QTAIMP = 0
	M.AQM_PK_QTAIMP = 0
	
*!*		*** CERCO LA GIACENZA ORIGINARIA LEGATA AL MOVIMENTO DI SCARICO TRAMITE LA DDT
*!*		SELECT AQM_U_BOL_DD
*!*		IF EOF()
*!*		ELSE
*!*			x_agga = "leg_agganc = '" + DAGGANCIO + "'"
*!*			x_csys = "leg_sysbol = '" + ORD_CODSYS + "'"
*!*			x_qnti = "leg_quanti = " + XX_QTAMOV
*!*			x_cint = "leg_codart = '" + XX_CODINT + "'"  && ERASMO - 13/05/2011
*!*			x_cond = x_agga + " and " + x_csys + " and " + x_qnti + " and " + x_cint 
*!*			cSql   = "select leg_sysmag,leg_przcon from u_bol_le where " + x_cond
*!*			IF !ExecCommand(cSql,"CX_BOL_LE")
*!*				return(.f.)
*!*			ENDIF
*!*			SELECT CX_BOL_LE
*!*			GO TOP
*!*			IF EOF()
*!*				M.AQM_ERROR     = "PREACQ_MOVIMENTO-KO"
*!*				M.AQM_MESSAGE   = "NESSUN DETTAGLIO U_BOL_LE CORRISPONDENTE AD U_MAG_MO PER LA VERIFICA DEL PREZZO DI ACQUISTO NEI MOVIMENTI"
*!*				IF _PAR_ELABOR = 2
*!*					M.AQM_MESSAGE = M.AQM_MESSAGE + " => IMPOSSIBILE AGGIORNARE IL PREZZO NEL MOVIMENTO"
*!*				ENDIF
*!*				=SCRIVE_LOG_ERRORI()
*!*				PUB_PRZLOG = PUB_PRZLOG + 1
*!*				SELECT AQM_U_MAG_MO
*!*				SKIP +1
*!*				LOOP
*!*			ELSE
*!*				x_uniq = "mag_unique = '" + LEG_SYSMAG + "'"
*!*				x_cond = x_uniq
*!*				cSql   = "select mag_datagg,mag_legame,mag_przcon from u_mag_gg where " + x_cond
*!*				IF !ExecCommand(cSql,"CX_MAG_GG")
*!*					return(.f.)
*!*				ENDIF
*!*				SELECT CX_MAG_GG
*!*				GO TOP
*!*				IF EOF()
*!*					*** SE NON HO LA GIACENZA CORRISPONDENTE PERCHE' SU QUEL PARTICOLARE MAGAZZINO HO ATTIVA LA CANCELLAZIONE DELLE GIACENZE A ZERO
*!*					*** CONSIDERO IL PREZZO MEMORIZZATO IN U_BOL_LE
*!*					SELECT CX_BOL_LE
*!*					M.AQM_GG_PRZCON = LEG_PRZCON
*!*					IF M.AQM_MO_PREACQ <> M.AQM_GG_PRZCON
*!*						WAIT WINDOW "DDT IN ELABORAZIONE : " + AQM_NUMDDT + " del " + RIBALTA2(AQM_DATDDT) + CHR(13) + ;
*!*							"Movimento Articolo " + ALLTRIM(M.MOV_ANAART) + " con prezzo NON registrato correttamente" nowait
*!*						M.AQM_ERROR     = "PREACQ_MOVIMENTO-KO"
*!*						M.AQM_MESSAGE   = "PREZZO DI ACQUISTO NEL MOVIMENTO DIVERSO DAL PREZZO DI ACQUISTO PROVENIENTE DALLA GIACENZA ORIGINARIA (U_BOL_LE.LEG_PRZCON))"			
*!*						IF _PAR_ELABOR = 2
*!*							XX_NEWPREACQ = ALLTRIM(STR(M.AQM_GG_PRZCON,19,6))
*!*							XX_NEWPREACQ = STRTRAN(XX_NEWPREACQ,",",".")
*!*							x_uniq = "id_unique = '" + XX_ID_UNIQUE + "'"
*!*							x_cond = x_uniq
*!*							cSql = "UPDATE U_MAG_MO SET MOV_PREACQ = &XX_NEWPREACQ where " + x_cond
*!*							IF !ExecCommand(cSql,"UPD_U_MAG_MO1")
*!*								return(.f.)
*!*							ENDIF
*!*							cSql = "UPDATE U_MAG_MO SET MOV_VALACQ = (MOV_PREACQ * MOV_QTAMOV) where " + x_cond
*!*							IF !ExecCommand(cSql,"UPD_U_MAG_MO2")
*!*								return(.f.)
*!*							ENDIF
*!*							M.AQM_MESSAGE = M.AQM_MESSAGE + " => AGGIORNAMENTO DEL PREZZO NEL MOVIMENTO EFFETTUATO"
*!*						ENDIF
*!*						=SCRIVE_LOG_ERRORI()
*!*						PUB_PRZLOG = PUB_PRZLOG + 1
*!*						SELECT AQM_U_MAG_MO
*!*						SKIP +1
*!*						LOOP
*!*					ELSE
*!*						WAIT WINDOW "DDT IN ELABORAZIONE : " + AQM_NUMDDT + " del " + RIBALTA2(AQM_DATDDT) + CHR(13) + ;
*!*							"Movimento Articolo " + ALLTRIM(M.MOV_ANAART) + " con prezzo registrato correttamente" nowait
*!*					ENDIF
*!*				ELSE
*!*					M.AQM_GG_PRZCON = MAG_PRZCON
*!*					IF M.AQM_MO_PREACQ <> M.AQM_GG_PRZCON
*!*						WAIT WINDOW "DDT IN ELABORAZIONE : " + AQM_NUMDDT + " del " + RIBALTA2(AQM_DATDDT) + CHR(13) + ;
*!*							"Movimento Articolo " + ALLTRIM(M.MOV_ANAART) + " con prezzo NON registrato correttamente" nowait
*!*						M.AQM_ERROR     = "PREACQ_MOVIMENTO-KO"
*!*						M.AQM_MESSAGE   = "PREZZO DI ACQUISTO NEL MOVIMENTO DIVERSO DAL PREZZO DI ACQUISTO PROVENIENTE DALLA GIACENZA ORIGINARIA (U_MAG_GG.MAG_PRZCON)"			
*!*						IF _PAR_ELABOR = 2
*!*							XX_NEWPREACQ = ALLTRIM(STR(M.AQM_GG_PRZCON,19,6))
*!*							XX_NEWPREACQ = STRTRAN(XX_NEWPREACQ,",",".")
*!*							x_uniq = "id_unique = '" + XX_ID_UNIQUE + "'"
*!*							x_cond = x_uniq
*!*							cSql = "UPDATE U_MAG_MO SET MOV_PREACQ = &XX_NEWPREACQ where " + x_cond
*!*							IF !ExecCommand(cSql,"UPD_U_MAG_MO1")
*!*								return(.f.)
*!*							ENDIF
*!*							cSql = "UPDATE U_MAG_MO SET MOV_VALACQ = (MOV_PREACQ * MOV_QTAMOV) where " + x_cond
*!*							IF !ExecCommand(cSql,"UPD_U_MAG_MO2")
*!*								return(.f.)
*!*							ENDIF
*!*							M.AQM_MESSAGE = M.AQM_MESSAGE + " => AGGIORNAMENTO DEL PREZZO NEL MOVIMENTO EFFETTUATO"
*!*						ENDIF
*!*						=SCRIVE_LOG_ERRORI()
*!*						PUB_PRZLOG = PUB_PRZLOG + 1
*!*						SELECT AQM_U_MAG_MO
*!*						SKIP +1
*!*						LOOP
*!*					ELSE
*!*						WAIT WINDOW "DDT IN ELABORAZIONE : " + AQM_NUMDDT + " del " + RIBALTA2(AQM_DATDDT) + CHR(13) + ;
*!*							"Movimento Articolo " + ALLTRIM(M.MOV_ANAART) + " con prezzo registrato correttamente" nowait
*!*					ENDIF
*!*				ENDIF
*!*			ENDIF
*!*		ENDIF
	
	*** CERCO LA GIACENZA ORIGINARIA LEGATA AL MOVIMENTO DI SCARICO
	x_lega = "mag_legame = '" + XX_LEGAME + "'"
	x_cond = x_lega 
	cSql   = "select mag_datagg,mag_legame,mag_przcon from u_mag_gg where " + x_cond
	IF !ExecCommand(cSql,"CX_MAG_GG")
		return(.f.)
	ENDIF
	SELECT CX_MAG_GG
	GO TOP
	IF EOF()
		*** SE NON HO LA GIACENZA CORRISPONDENTE PERCHE' SU QUEL PARTICOLARE MAGAZZINO HO ATTIVA LA CANCELLAZIONE DELLE GIACENZE A ZERO
		*** NON POSSO IN ALCUN MODO RISALIRE AL PREZZO ORIGINARIO
		WAIT WINDOW "DDT IN ELABORAZIONE : " + AQM_NUMDDT + " del " + RIBALTA2(AQM_DATDDT) + CHR(13) + ;
			"Movimento Articolo " + ALLTRIM(M.MOV_ANAART) + " con prezzo non verificabile per giacenza originaria cancellata" nowait
		*M.AQM_ERROR     = "PREACQ_MOVIMENTO-KO"
		*M.AQM_MESSAGE   = "NESSUNA GIACENZA U_MAG_GG CORRISPONDENTE AD U_MAG_MO PER LA VERIFICA DEL PREZZO DI ACQUISTO NEI MOVIMENTI"
		*IF _PAR_ELABOR = 2
		*	M.AQM_MESSAGE = M.AQM_MESSAGE + " => IMPOSSIBILE AGGIORNARE IL PREZZO NEL MOVIMENTO"
		*ENDIF
		*=SCRIVE_LOG_ERRORI()
		*PUB_PRZLOG = PUB_PRZLOG + 1
		SELECT AQM_U_MAG_MO
		SKIP +1
		LOOP
	ELSE
		M.AQM_GG_PRZCON = MAG_PRZCON
		IF M.AQM_MO_PREACQ <> M.AQM_GG_PRZCON
			WAIT WINDOW "DDT IN ELABORAZIONE : " + AQM_NUMDDT + " del " + RIBALTA2(AQM_DATDDT) + CHR(13) + ;
				"Movimento Articolo " + ALLTRIM(M.MOV_ANAART) + " con prezzo NON registrato correttamente" nowait
			M.AQM_ERROR     = "PREACQ_MOVIMENTO-KO"
			M.AQM_MESSAGE   = "PREZZO DI ACQUISTO NEL MOVIMENTO DIVERSO DAL PREZZO DI ACQUISTO PROVENIENTE DALLA GIACENZA ORIGINARIA (U_MAG_GG.MAG_PRZCON)"			
			IF _PAR_ELABOR = 2
				XX_NEWPREACQ = ALLTRIM(STR(M.AQM_GG_PRZCON,19,6))
				XX_NEWPREACQ = STRTRAN(XX_NEWPREACQ,",",".")
				x_uniq = "id_unique = '" + XX_ID_UNIQUE + "'"
				x_cond = x_uniq
				cSql = "UPDATE U_MAG_MO SET MOV_PREACQ = &XX_NEWPREACQ where " + x_cond
				IF !ExecCommand(cSql,"UPD_U_MAG_MO1")
					return(.f.)
				ENDIF
				cSql = "UPDATE U_MAG_MO SET MOV_VALACQ = (MOV_PREACQ * MOV_QTAMOV) where " + x_cond
				IF !ExecCommand(cSql,"UPD_U_MAG_MO2")
					return(.f.)
				ENDIF
				M.AQM_MESSAGE = M.AQM_MESSAGE + " => AGGIORNAMENTO DEL PREZZO NEL MOVIMENTO EFFETTUATO"
			ENDIF
			=SCRIVE_LOG_ERRORI()
			PUB_PRZLOG = PUB_PRZLOG + 1
			SELECT AQM_U_MAG_MO
			SKIP +1
			LOOP
		ELSE
			WAIT WINDOW "DDT IN ELABORAZIONE : " + AQM_NUMDDT + " del " + RIBALTA2(AQM_DATDDT) + CHR(13) + ;
				"Movimento Articolo " + ALLTRIM(M.MOV_ANAART) + " con prezzo registrato correttamente" nowait
		ENDIF
	ENDIF

	SELECT AQM_U_MAG_MO
	SKIP +1
	LOOP
		
ENDDO



RETURN


***********************************************************************
FUNCTION PJ_INPUTDATE_CTRL
***********************************************************************

PARAMETERS _CINPUTPROMPT1,_CINPUTPROMPT2,_CDIALOGCAPTION,_CDEFAULTVALUE1,_CDEFAULTVALUE2

IF PARAMETERS() < 1 .OR. TYPE("_CINPUTPROMPT1") <> 'C'
   _CINPUTPROMPT = "Digitare il 1° valore"
ENDIF

IF PARAMETERS() < 1 .OR. TYPE("_CINPUTPROMPT2") <> 'C'
   _CINPUTPROMPT = "Digitare il 2° valore"
ENDIF

IF PARAMETERS() < 2 .OR. TYPE("_CDIALOGCAPTION") <> 'C'
   _CDIALOGCAPTION = "Aquarius"
ENDIF

IF PARAMETERS() < 3 .OR. TYPE("_CDEFAULTVALUE") <> 'C'
   _CDEFAULTVALUE = ""
ELSE
   _CDEFAULTVALUE = RTRIM(_CDEFAULTVALUE)
ENDIF

RELEASE _CRETURN1,_CRETURN2
PUBLIC _CRETURN1,_CRETURN2
_CRETURN1 = _CDEFAULTVALUE1
_CRETURN2 = _CDEFAULTVALUE2
_LCONTINUA = .F.

DO FORM FORM\PJ_INPUTDATE_CTRL WITH _CINPUTPROMPT1,_CINPUTPROMPT2,_CDIALOGCAPTION,_CDEFAULTVALUE1,_CDEFAULTVALUE2

RETURN _LCONTINUA



************************************************
FUNCTION VERIFICA_SPEDITO_CON_MOVIMENTI_GIACENZE
************************************************
PARAMETERS _AQM_CODCLI,_AQM_DATADA,_AQM_DATAA

PUB_TOT_TT = 0
PUB_TOT_DD = 0

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
SET FILTER TO TAGGANCIO > ULTIMO_DOCUMENTO_NON_AQMLIB("BOL")  && PROCEDURA ESEGUIBILE SOLO SU BOLLE GESTITE TRAMITE AQMLIB
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
   
    WAIT WINDOWS "Controllo quadratura saldo movimenti con giacenze per gli articoli in dettagli DDT in corso..." + CHR(13) + ;
    	"NUMERO DDT IN ELABORAZIONE : " + ORD_NUMORD + " del " + RIBALTA2(ORD_DATORD) NOWAIT
    
    _NUMORD = ORD_NUMORD 
    _DATORD = ORD_DATORD

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
		AQM_NUMDDT = _NUMORD
		AQM_DATDDT = _DATORD
		AQM_QTADDT = ORD_QTAORD

		SELECT AQM_U_BOL_DD
		
		AQM_VERIFICA  	= "01"  		&& CONFRONTA LA GIACENZA DI U_MAG_GG CON LA GIACENZA DI U_MAG_MO E SCRIVE SU LOG_NEW_MAG SE IL TOTALE GIACENZA NON COINCIDE COL SALDO MOVIMENTI
		AQM_AGG_MAGGG  	= "NO"  		&& NON EFFETTUA NESSUN AGGIORNAMENTO SU U_MAG_GG
		AQM_AGG_MAGMO  	= "NO"  		&& NON EFFETTUA NESSUN AGGIORNAMENTO SU U_MAG_MO
		AQM_ACCESSO_GG  = 1				&& ACCESSO GIACENZE PER MAGAZZINO+ARTICOLO
		AQM_ACCESSO_MO  = 1				&& ACCESSO MOVIMENTI PER MAGAZZINO+ARTICOLO
		AQM_CODMAG 		= ORD_MAGA  
		AQM_CODART      = ORD_CODART
		AQM_LEGSYS      = ""			&& CODICE SYS IDENTIFICATIVO CHE LEGA U_MAG_GG+U_MAG_MO AI DOCUMENTI TRAMITE ORD_LEGSYS (SOLO DDT CREATE TRAMITE AQMLIB)

		=CALCOLA_GIACENZE_VALORI_MAGAZZINO(AQM_VERIFICA,AQM_AGG_MAGGG,AQM_AGG_MAGMO,AQM_ACCESSO_GG,AQM_ACCESSO_MO,AQM_CODMAG,AQM_CODART,AQM_CODFOR,AQM_LEGSYS,AQM_NUMIDE,AQM_UNIQUE,AQM_NRLINT,AQM_DTREGI,AQM_SERIE,AQM_FILA_X,AQM_PIAN_N,AQM_UBIC_X)
		
		PUB_TOT_DD = PUB_TOT_DD + 1

	    SELECT AQM_U_BOL_DD
	    SKIP +1
	      	
	      				   
	ENDDO
	
    PUB_TOT_TT = PUB_TOT_TT + 1
   
   SELECT AQM_U_BOL_TT
   SKIP +1
   
ENDDO

RETURN


************************************************************************************************
FUNCTION CALCOLA_SALDO_MAGAZZINO_SU_U_MAG_MO
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
FUNCTION CALCOLA_SALDO_MAGAZZINO_SU_U_MAG_GG
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


*************************************************
PROCEDURE MSG_EXIT_PROCEDURE
*************************************************

WAIT WINDOWS "Si è verificato un errore generico" TIMEOUT 2

QUIT

ENDPROC
