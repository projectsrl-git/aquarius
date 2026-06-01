
**********************************************************
PROCEDURE STR_FILL_ZERO
*
* CONVERTE UN NUMERO IN STRINGA E LO RIEMPI CON ZERI NON
* SIGNIFICATIVI ALL'INIZIO DELLA STRINGA FINO A RAGGIUNGERE
* UNA LUNGHEZZA PARI AL PARAMERO <_NUMERO_DI_CIFRE> PASSATO
* 
* sintassi:  STR_FILL_ZERO(<numero da convertire>,<NUMRO DI CIFRE>)
*
* ? STR_FILL_ZERO(10,5)
*
* RISULTA:  
*
* 00010 
*
**********************************************************
	LPARAMETERS _NUMERO_DA_RIEMPIRE,_NUMERO_DI_CIFRE


	_STRINGA_DA_RIEMPIRE=REPLICATE("0",_NUMERO_DI_CIFRE)+ALLTRIM(STR(_NUMERO_DA_RIEMPIRE)) 
	_STRINGA_DA_RIEMPIRE=SUBSTR(_STRINGA_DA_RIEMPIRE,LEN(_STRINGA_DA_RIEMPIRE)-_NUMERO_DI_CIFRE+1)
	
	RETURN _STRINGA_DA_RIEMPIRE
		
* FINE - PROCEDURE FILLZERO
**********************************************************		



**********************************************************
PROCEDURE GET_MESE
*
* RESTITUISCE L'INDICAZIONE IN LETTERE DEL MESE PASSATO
* COME NUMERO
* 
* sintassi:  GET_MESE(<numero del mese>)
*
* ? GET_MESE(3)
*
* ---> Marzo
*
**********************************************************

LPARAMETERS _MESE_NUMERO

LOCAL _MESE_LETTERE

DO CASE 
		CASE _MESE_NUMERO =1
			_MESE_LETTERE="Gennaio"

		CASE _MESE_NUMERO =2
			_MESE_LETTERE="Febbraio"

		CASE _MESE_NUMERO =3
			_MESE_LETTERE="Marzo"
			
		CASE _MESE_NUMERO =4
			_MESE_LETTERE="Aprile"
			
		CASE _MESE_NUMERO =5
			_MESE_LETTERE="Maggio"
			
		CASE _MESE_NUMERO =6
			_MESE_LETTERE="Giugno"
			
		CASE _MESE_NUMERO =7
			_MESE_LETTERE="Luglio"
			
		CASE _MESE_NUMERO =8
			_MESE_LETTERE="Agosto"
			
		CASE _MESE_NUMERO =9
			_MESE_LETTERE="Settembre"
			
		CASE _MESE_NUMERO =10
			_MESE_LETTERE="Ottobre"
			
		CASE _MESE_NUMERO =11
			_MESE_LETTERE="Novembre"
			
		CASE _MESE_NUMERO =12
			_MESE_LETTERE="Dicembre"
			
		OTHERWISE			
			_MESE_LETTERE="...MESE NON VALIDO..."

ENDCASE

RETURN _MESE_LETTERE

* FINE - PROCEDURE GET_MESE
**********************************************************




**********************************************************
PROCEDURE CALCOLA_LUNGHEZZA_TAPPETO_FINO_ALLA_SEZIONE
*
* Calcola la lunghezza complessiva del tappeto da splamare
* fino all'inizio della sezione passata in input
*
**********************************************************
	LPARAMETERS _SEZIONE
	
	LOCAL _LUNGHEZZA
	
	*** PUSH SELECT
	LOCAL _SWWS,_OWWO,_RWWR
	_SWWS=SELECT()
	_OWWO=ORDER()
	_RWWR=RECNO()
	*** PUSH SELECT
			
	_LUNGHEZZA=0
	
    SELECT SEZIONI
    SET ORDER TO SEZIONE
    GO TOP
    DO WHILE !EOF()
    
    	IF DELETED()
    		SKIP
    		LOOP
    	ENDIF

    	IF SEZIONE > _SEZIONE
    		EXIT
    	ENDIF
    	    
    	_LUNGHEZZA=_LUNGHEZZA+LUNGH
    	
    	SKIP
    ENDDO
    
    *** POP SELECT
    SELECT(_SWWS)
	SET ORDER TO &_OWWO
	IF _RWWR<RECCOUNT()
		GO _RWWR
	ELSE
		GO BOTTOM
	ENDIF
	*** POP SELECT
    
    RETURN _LUNGHEZZA
    
* FINE - PROCEDURE CALCOLA_LUNGHEZZA_TAPPETO_FINO_ALLA_SEZIONE
**********************************************************


**********************************************************
PROCEDURE CALCOLA_FASCIA
*
* DATA UN ALTEZZA IN INGRESSO CALCOLA L'ALTEZZA DELLA FASCIA
* INTESA COME ALTEZZA DELLA PRIMA BOBINA IN ANAGRAFICA ARCHIVI
* PIU' ALTA DELLA FASCIA SPECIFICATA
*
* LA BOBINA VIENE RICERCATA OLTRE CHE PER ALTEZZA MAGGIORE
* DELL'ALTEZZA SPECIFICATA IN INGRESSO, ANCHE PER GRUPPO PRODUTTIVO
* CORRISPONDENTE AL GRUPPO SPECIFICATO NEL VALORE DI PUB_GRUPPO_PRODUTTIVO
*
* SINTASSI: CALCOLA_FASCIA(<ALTEZZA DA PRODURRE>)
*
**********************************************************
	LPARAMETERS _ALTEZZA,_GRP_PROD
	
	LOCAL _SWWS,_FASCIA,_RESTO_DELLA_DIVISIONE_PER_DIECI
		
	_SWWS=SELECT()		
	
	cSql = "SELECT * FROM U_ART_PR WHERE  ART_CODCAT='BO' AND ART_CODPRI='"+ALLTRIM(_GRP_PROD)+"' ORDER BY ART_CODPRI"
	IF !ExecCommand(cSql,"FASCE")
		SELECT(_SWWS)
		return -1
	ENDIF
	SELECT FASCE
	GO TOP
	IF EOF()
		SELECT(_SWWS)
		
* 		art_codpri = codice senza fascia
* 		art_descr = descrizione, ora penso a come tirarla fuori
* 		art_codcat = 'BO'
* 		art_tipart = 'A'
* 		art_altezz = '1050'
		
		RETURN -1
	ENDIF
	
    ***_FASCIA=ART_ALTEZZ
    
    _FASCIA=_ALTEZZA
    _RESTO_DELLA_DIVISIONE_PER_DIECI=_FASCIA%10
    IF _RESTO_DELLA_DIVISIONE_PER_DIECI>0
    	_FASCIA=_ALTEZZA +(10-_RESTO_DELLA_DIVISIONE_PER_DIECI)
    ENDIF
    
    
    SELECT(_SWWS)
    
    RETURN _FASCIA
    
* FINE - PROCEDURE CALCOLA_FASCIA
**********************************************************

**********************************************************
PROCEDURE CALCOLA_DATA_ORA_DA_LUNGHEZZA
**********************************************************
	LPARAMETERS _LUNGHEZZA
	
	LOCAL _TIMESTAMP,_MINUTI_FINALI
	
	*** CALCOLO DATA DI PRODUZIONE DELLA LUNGHEZZA PASSATA IN INPUT
			
	_MINUTI_FINALI=0
	IF VELOCITA_SPALM>0
		_MINUTI_FINALI=ROUND(_LUNGHEZZA/VELOCITA_SPALM,0)
	ENDIF
	
	_TIMESTAMP=CALCOLA_DATA_ORA(_MINUTI_FINALI)
	
	RETURN _TIMESTAMP
	
* FINE - PROCEDURE CALCOLA_DATA_ORA_DA_LUNGHEZZA
**********************************************************



**********************************************************
PROCEDURE CALCOLA_DATA_ORA_DA_SEZIONE
*
* CALCOLATA IN FUNZIONE DELLA VELOCITA' DI SPALMATURA USATA
* PER L'INTERO TAPPETO ---> VELOCITA_SPALM
*
**********************************************************
	LPARAMETERS _SEZIONE
	
	LOCAL _TIMESTAMP,_MINUTI_FINALI
	
	*** CALCOLO DATA DI PRODUZIONE DELLA SEZIONE PASSATA IN INPUT
			
	_MINUTI_FINALI=0
	IF VELOCITA_SPALM>0
		_MINUTI_FINALI=ROUND(CALCOLA_LUNGHEZZA_TAPPETO_FINO_ALLA_SEZIONE(_SEZIONE)/VELOCITA_SPALM,0)
	ENDIF
	
	_TIMESTAMP=CALCOLA_DATA_ORA(_MINUTI_FINALI)
	
	RETURN _TIMESTAMP
	
* FINE - PROCEDURE CALCOLA_DATA_ORA_DA_SEZIONE
**********************************************************

**********************************************************	
PROCEDURE CALCOLA_QTA_ADESIVO_PER_ARTICOLO_FINALE
*
* CALCOLATA IN FUNZIONE DEL CODICE ADESIVO USATO 
* PER L'INTERO TAPPETO ---> PUB_CODICE_ADESIVO
*
**********************************************************	

	LPARAMETERS _CODART
	
	LOCAL _QTA_ADESIVO

	*** PUSH SELECT
	LOCAL _SWWS,_OWWO,_RWWR
	_SWWS=SELECT()
	_OWWO=ORDER()
	_RWWR=RECNO()
	*** PUSH SELECT	
	
	cSql = "SELECT DIS_QTA AS QTA_ADESIVO FROM U_DIS_DD WHERE  DIS_GRUPPO='"+_CODART+"' AND DIS_CODART='"+PUB_CODICE_ADESIVO+"' "
    IF !ExecCommand(CSQL,"CUR_ADESIVO")
       RETURN (.f.)
    ENDIF  
    SELECT CUR_ADESIVO
    _QTA_ADESIVO=0
    IF !EOF()
    	_QTA_ADESIVO=QTA_ADESIVO
    ENDIF

    *** POP SELECT
    SELECT(_SWWS)
	SET ORDER TO &_OWWO
	IF _RWWR<RECCOUNT()
		GO _RWWR
	ELSE
		GO BOTTOM
	ENDIF
	*** POP SELECT
	
	RETURN _QTA_ADESIVO	
    
* FINE - PROCEDURE CALCOLA_QTA_ADESIVO_PER_ARTICOLO_FINALE
**********************************************************		


**********************************************************	
PROCEDURE AGGIORNA_QTA_ADESIVO_IN_GIACENZA
*
* Durante la  creazione e conferma del tappeto produttivo:
*
* E' necessario nel tappeto rilevare la disponibilità a magazzino dell'adesivo per ogni bobina. 
* Per la bobina con progressivo 00001 sono necessari in totale 70 KG; il programma ne trova ad 
* esempio uno compatibile in magazzino con codice interno "HI 473K.28000407", 
* dopo aver effettuato una ricerca su U_MAG_GG. La quantità disponibile a magazzino è data da 
* MAG_GIACEN - MAG_QTAIMP (50), 
* perché una parte dell'adesivo potrebbe essere impegnato da un altro programma di produzione in essere (vedi avanti); 
* se ne deduce che la ricerca deve prescindere dal flag MAG_PRENOT, potendo essere la giacenza NON completamente impegnata.
* La riga di U_PRD_D3, relativamente ai campi dell'adesivo, deve essere popolata in questo modo:
*
* Di conseguenza il programma di produzione, deve aggiornare le giacenze U_MAG_GG:
* o	Impostando a True il flag MAG_PRENOT 
* o	Aumentando di 50 il campo MAG_QTAIMP
*
**********************************************************	
	LPARAMETERS _PR3_QUANTI


	LOCAL _PR3_QTADGI,_MAG_QTAIMP

	*** PUSH SELECT
	LOCAL _SWWS,_OWWO,_RWWR
	_SWWS=SELECT()
	_OWWO=ORDER()
	_RWWR=RECNO()
	*** PUSH SELECT	
	
	cSql = "SELECT * FROM U_MAG_GG WHERE MAG_ANAART='"+PUB_CODICE_ADESIVO+"' "
    IF !ExecCommand(CSQL,"CUR_ADESIVO")
       RETURN (.f.)
    ENDIF  
    SELECT CUR_ADESIVO
    GO TOP
    
    _PR3_QTADGI=0
    
    DO WHILE !EOF()
    
    	_PR3_QTADGI=MAG_GIACEN - MAG_QTAIMP
    
    	IF _PR3_QTADGI >= _PR3_QUANTI
    		_MAG_QTAIMP=MAG_QTAIMP+_PR3_QUANTI
    	ELSE
    		_MAG_QTAIMP=MAG_GIACEN
    	ENDIF
    		
		cSql = "UPDATE U_MAG_GG SET MAG_PRENOT=1, MAG_QTAIMP ="+ALLTRIM(STR(_MAG_QTAIMP))+" WHERE MAG_ANAART='"+PUB_CODICE_ADESIVO+"' "
	    IF !ExecCommand(CSQL,"UPDATE_ADESIVO")
	       RETURN (.f.)
	    ENDIF  
	
	    EXIT
	    
	    SELECT CUR_ADESIVO
    	SKIP
    	LOOP
    ENDDO
    
    *** POP SELECT
    SELECT(_SWWS)
	SET ORDER TO &_OWWO
	IF _RWWR<RECCOUNT()
		GO _RWWR
	ELSE
		GO BOTTOM
	ENDIF
	*** POP SELECT
	
	RETURN _PR3_QTADGI	
    
* FINE - PROCEDURE AGGIORNA_QTA_ADESIVO_IN_GIACENZA
**********************************************************		



**********************************************************
PROCEDURE ALTEZZA2TOP
**********************************************************
	LPARAMETERS _OFORM,_ALTEZZA
	
	LOCAL _SWWS,_TOP
		
	_SWWS=SELECT()
	
	_TOP=0
	
	posizione_y0=_OFORM.TAPPETO.Top+_OFORM.TAPPETO.Height

	_TOP=posizione_y0-_ALTEZZA
	
	SELECT(_SWWS)	
	
	RETURN _TOP
	
* FINE PROCEDURE ALTEZZA2TOP
**********************************************************


**********************************************************
PROCEDURE LUNGHEZZA2LEFT
**********************************************************
	LPARAMETERS _OFORM,_LUNGHEZZA
	
	LOCAL _SWWS,_LEFT
		
	_SWWS=SELECT()
	
	_LEFT=0
	
	posizione_x0=_OFORM.TAPPETO.Left
	
	_LEFT=posizione_x0+_LUNGHEZZA

	
	SELECT(_SWWS)	
	
	RETURN _LEFT
	
* FINE PROCEDURE LUNGHEZZA2LEFT
**********************************************************

**********************************************************
PROCEDURE LUNGEZZA2PIXEL
**********************************************************
	LPARAMETERS _LUNGHEZZA
	
	RETURN ROUND(_LUNGHEZZA*LUNGHEZZA_TAPPETO_SROTOLATO/LUNGHEZZA_BOBINA,0)

* FINE - PROCEDURE LUNGEZZA2PIXEL
**********************************************************

**********************************************************
PROCEDURE ALTEZZA2PIXEL
**********************************************************
	LPARAMETERS _ALTEZZA
	
	RETURN ROUND(_ALTEZZA*TAPPETO_HEIGHT/ALTEZZA_BOBINA,0)
	
* FINE - PROCEDURE ALTEZZA2PIXEL
**********************************************************


**********************************************************
PROCEDURE SEZIONE2LUNGHEZZA
**********************************************************
	LPARAMETERS _SEZIONE
	
	LOCAL _SWWS,_ALIAS,_LUNGHEZZA_DA_VISUALIZZARE
		
	_SWWS=SELECT()	

	IF _SEZIONE<SEZIONE_TAGLIO_INIZIALE OR _SEZIONE>SEZIONE_TAGLIO_FINALE
		RETURN -1
	ENDIF
		
	SELECT SEZIONI
		
	_ALIAS=SYS(2015)
	SELECT SUM(LUNGH) AS LUNGH FROM SEZIONI WHERE SEZIONE<_SEZIONE AND SEZIONE>=SEZIONE_TAGLIO_INIZIALE AND FLGVIEW=.T. INTO CURSOR &_ALIAS
	SELECT &_ALIAS
	
	IF EOF()	
		_LUNGHEZZA_DA_VISUALIZZARE=0
	ELSE
		_LUNGHEZZA_DA_VISUALIZZARE=LUNGH
	ENDIF
	
	SELECT &_ALIAS
	USE
	
	SELECT(_SWWS)	
	
	RETURN _LUNGHEZZA_DA_VISUALIZZARE

* FINE PROCEDURE SEZIONE2LUNGHEZZA
**********************************************************

**********************************************************
PROCEDURE POSTSEZIONE2LUNGHEZZA
**********************************************************
	LPARAMETERS _SEZIONE

	LOCAL _SWWS,_ALIAS,_LUNGHEZZA_DA_VISUALIZZARE
		
	_SWWS=SELECT()	
	
	IF _SEZIONE<SEZIONE_TAGLIO_INIZIALE OR _SEZIONE>SEZIONE_TAGLIO_FINALE
		RETURN -1
	ENDIF
		
	SELECT SEZIONI
	
	_ALIAS=SYS(2015)
	SELECT SUM(LUNGH) AS LUNGH FROM SEZIONI WHERE SEZIONE=<_SEZIONE AND SEZIONE>=SEZIONE_TAGLIO_INIZIALE AND FLGVIEW=.T. INTO CURSOR &_ALIAS
	SELECT &_ALIAS
	IF EOF()	
		_LUNGHEZZA_DA_VISUALIZZARE=0
	ELSE
		_LUNGHEZZA_DA_VISUALIZZARE=LUNGH
	ENDIF
	
	SELECT &_ALIAS
	USE
	
	SELECT(_SWWS)	
	
	RETURN _LUNGHEZZA_DA_VISUALIZZARE

* FINE PROCEDURE POSTSEZIONE2LUNGHEZZA
**********************************************************




**********************************************************
PROCEDURE MINUTI_DA_ORARIO
**********************************************************
LPARAMETERS _ORARIO

RETURN VAL(SUBSTR(_ORARIO,4,2))

* FINE PROCEDURE MINUTI_DA_ORARIO
**********************************************************

**********************************************************
PROCEDURE ORE_DA_ORARIO
**********************************************************
LPARAMETERS _ORARIO

RETURN VAL(SUBSTR(_ORARIO,1,2))

* FINE PROCEDURE ORE_DA_ORARIO
**********************************************************


**********************************************************
PROCEDURE CALCOLA_DATA_ORA
**********************************************************
	LPARAMETERS _MINUTI

	LOCAL ;
		_MINUTI_INIZIALI,;
		_ORE_INIZIALI,;
		_MINUTI_FINALI,;
		_ORE_FINALI,;
		_DATA_FINALE,;
		_MINUTI_IN_UN_GIORNO,;
		_SHIFT_GIORNI,;
		_SHIFT_ORE,;
		_SHIFT_MINUTI,;
		_SCARTO_MINUTI
		
	_MINUTI_IN_UN_GIORNO=1440

		
	_MINUTI_INIZIALI=MINUTI_DA_ORARIO(ORA_INIZIO_SPALM)
	_ORE_INIZIALI	=ORE_DA_ORARIO(ORA_INIZIO_SPALM)
	_MINUTI_INIZIALI=_MINUTI_INIZIALI+_ORE_INIZIALI*60

	_MINUTI_FINALI 	=_MINUTI_INIZIALI
	_ORE_FINALI		=0

	_SHIFT_GIORNI=0
	_SHIFT_ORE=0
	_SHIFT_MINUTI=0
	
	_SHIFT_GIORNI=INT((_MINUTI+_MINUTI_INIZIALI)/_MINUTI_IN_UN_GIORNO)
	_SCARTO_MINUTI=	_MINUTI+_MINUTI_INIZIALI-_SHIFT_GIORNI*_MINUTI_IN_UN_GIORNO
	
	_ORE_FINALI=INT(_SCARTO_MINUTI/60)
	_MINUTI_FINALI = _SCARTO_MINUTI-_ORE_FINALI*60

	_ORE_FINALI		=STR_FILL_ZERO(_ORE_FINALI,2)
	_MINUTI_FINALI 	=STR_FILL_ZERO(_MINUTI_FINALI,2)
	
	_DATA_FINALE	=DATA_FINE_DA_GIORNI(DATA_INIZIO_SPLAM,_SHIFT_GIORNI)
	
	RETURN _DATA_FINALE+" "+_ORE_FINALI+":"+_MINUTI_FINALI

* PROCEDURE CALCOLA_DATA_ORA
**********************************************************


**********************************************************
PROCEDURE CALCOLA_DATA_ORA_GENERICA
**********************************************************
	LPARAMETERS _TIMESTAMP_INIZIALE,_MINUTI

	LOCAL ;
		_DATA_INIZIALE,;
		_ORA_INIZIALE,;
		_MINUTI_INIZIALI,;
		_ORE_INIZIALI,;
		_MINUTI_FINALI,;
		_ORE_FINALI,;
		_DATA_FINALE,;
		_MINUTI_IN_UN_GIORNO,;
		_SHIFT_GIORNI,;
		_SHIFT_ORE,;
		_SHIFT_MINUTI,;
		_SCARTO_MINUTI
		
	_MINUTI_IN_UN_GIORNO=1440

	_DATA_INIZIALE=SUBSTR(_TIMESTAMP_INIZIALE,1,10)
	_ORA_INIZIALE =SUBSTR(_TIMESTAMP_INIZIALE,12)
	
	_MINUTI_INIZIALI=MINUTI_DA_ORARIO(_ORA_INIZIALE)
	_ORE_INIZIALI	=ORE_DA_ORARIO(_ORA_INIZIALE)
	_MINUTI_INIZIALI=_MINUTI_INIZIALI+_ORE_INIZIALI*60

	_MINUTI_FINALI 	=_MINUTI_INIZIALI
	_ORE_FINALI		=0

	_SHIFT_GIORNI=0
	_SHIFT_ORE=0
	_SHIFT_MINUTI=0
	
	_SHIFT_GIORNI=INT((_MINUTI+_MINUTI_INIZIALI)/_MINUTI_IN_UN_GIORNO)
	_SCARTO_MINUTI=	_MINUTI+_MINUTI_INIZIALI-_SHIFT_GIORNI*_MINUTI_IN_UN_GIORNO
	
	_ORE_FINALI=INT(_SCARTO_MINUTI/60)
	_MINUTI_FINALI = _SCARTO_MINUTI-_ORE_FINALI*60

	_ORE_FINALI		=STR_FILL_ZERO(_ORE_FINALI,2)
	_MINUTI_FINALI 	=STR_FILL_ZERO(_MINUTI_FINALI,2)
	
	_DATA_FINALE	=DATA_FINE_DA_GIORNI(_DATA_INIZIALE,_SHIFT_GIORNI)
	
	RETURN _DATA_FINALE+" "+_ORE_FINALI+":"+_MINUTI_FINALI

* PROCEDURE CALCOLA_DATA_ORA_GENERICA
**********************************************************



**********************************************************
PROCEDURE CALCOLA_DATA_GENERICA_DA_MINUTI
**********************************************************
	LPARAMETERS _DATA_INIZIALE,_MINUTI
	
	_DATA_FINALE	=CALCOLA_DATA_ORA_GENERICA(_DATA_INIZIALE+" 00:00",_MINUTI)
	
	RETURN _DATA_FINALE

* PROCEDURE CALCOLA_DATA_GENERICA_DA_MINUTI
**********************************************************


**********************************************************
PROCEDURE CALCOLA_DATA_GENERICA_DA_ORE_MINUTI
**********************************************************
	LPARAMETERS _DATA_INIZIALE,_ORE_MINUTI
	
	LOCAL _MINUTI
	
	_MINUTI=VAL(SUBSTR(ALLTRIM(_ORE_MINUTI),1,2))*60+VAL(SUBSTR(ALLTRIM(_ORE_MINUTI),4,2))
	
	_DATA_FINALE	=CALCOLA_DATA_ORA_GENERICA(_DATA_INIZIALE+" 00:00",_MINUTI)
	
	RETURN _DATA_FINALE

* PROCEDURE CALCOLA_DATA_GENERICA_DA_ORE_MINUTI
**********************************************************

**********************************************************
PROCEDURE CALCOLA_DATA_GENERICA_DA_GIORNI
**********************************************************
	LPARAMETERS _DATA_INIZIALE,_GIORNI
	
	_DATA_FINALE	=CALCOLA_DATA_ORA_GENERICA(_DATA_INIZIALE+" 00:00",_GIORNI*1440)
	
	RETURN _DATA_FINALE

* PROCEDURE CALCOLA_DATA_GENERICA_DA_GIORNI
**********************************************************



**********************************************************
PROCEDURE DATA_FINE_DA_GIORNI
**********************************************************
	LPARAMETERS _DATINI,_GGPREV

	*** PUSH SELECT
	LOCAL _SWWS,_OWWO,_RWWR
	_SWWS=SELECT()
	_OWWO=ORDER()
	_RWWR=RECNO()
	*** PUSH SELECT	
	
	LOCAL ;
		x_cond,;
		_XX_DATA,;
		_XX_MESE,;
		_XX_GGMS,;
		_V_GGMESE

	IF _GGPREV < 0
	   _GGPREV = 0
	ENDIF
	
	IF _GGPREV = 0
	   RETURN _DATINI
	ENDIF
	
	_DATFIN = _DATINI
	IF EMPTY(ALLTRIM(_DATINI)) .OR. _DATINI = "  /  /    "
	ELSE
	
	   I = 0
	   **_XX_DATA = CTOD(_DATINI) - 1		&& SIMONE - 16/09/2009
	   _XX_DATA = CTOD(_DATINI)
	   _XX_MESE = SUBSTR(DTOC(_XX_DATA+1),4,2)
	   _XX_GGMS = 0
	   DO WHILE I < _GGPREV
	      _XX_DATA = _XX_DATA + 1
	      x_cond = "cal_datamg = '" + RIBALTA2(DTOC(_XX_DATA)) + "'"
	      cSql   = "SELECT * FROM U_CAL_LA WHERE " + x_cond
	      IF !ExecCommand(cSql,"CUR_CAL_LA")
	         return(.f.)
	      ENDIF
	      SELECT CUR_CAL_LA
	      GO TOP
	      IF EOF()
	         MESSAGEBOX("Calendario lavorativo incompleto",16,"Attenzione")
	         RETURN .F.
	      ENDIF
	      IF CAL_LAVO
	            I = I + 1
	      ENDIF
	   ENDDO
	   _DATFIN = DTOC(_XX_DATA)
	ENDIF
	
    *** POP SELECT
    SELECT(_SWWS)
	SET ORDER TO &_OWWO
	IF _RWWR<RECCOUNT()
		GO _RWWR
	ELSE
		GO BOTTOM
	ENDIF
	*** POP SELECT
		
	RETURN _DATFIN
* FINE PROCEDURE DATA_FINE_DA_GIORNI
**********************************************************





**********************************************************
PROCEDURE DATA_FINE_DA_GIORNI_backup_simone_20090916
**********************************************************
	LPARAMETERS _DATINI,_GGPREV

	*** PUSH SELECT
	LOCAL _SWWS,_OWWO,_RWWR
	_SWWS=SELECT()
	_OWWO=ORDER()
	_RWWR=RECNO()
	*** PUSH SELECT	
	
	LOCAL ;
		x_cond,;
		_XX_DATA,;
		_XX_MESE,;
		_XX_GGMS,;
		_V_GGMESE

	IF _GGPREV < 0
	   _GGPREV = 0
	ENDIF
	
	IF _GGPREV = 0
	   
	   RETURN _DATINI
	ENDIF
	
	_DATFIN = _DATINI
	IF EMPTY(ALLTRIM(_DATINI)) .OR. _DATINI = "  /  /    "
	ELSE
	   x_cond = "cal_datamg = '" + RIBALTA2(_DATINI) + "'"
	   cSql   = "SELECT * FROM U_CAL_LA WHERE " + x_cond
	   IF !ExecCommand(cSql,"CUR_CAL_LA")
	      return(.f.)
	   ENDIF
	   SELECT CUR_CAL_LA
	   GO TOP
	   IF EOF()
	      MESSAGEBOX("Data Inizio NON presente nel calendario lavorativo",16,"Attenzione")
	      
	      RETURN .F.
	   ELSE
	*!*	      IF CAL_LAVO
	*!*	      ELSE
	*!*	         MESSAGEBOX("Data Inizio NON lavorativa rispetto al calendario lavorativo",16,"Attenzione")
	*!*	         
	*!*	         RETURN .F.
	*!*	      ENDIF
	   ENDIF
	   I = 0
	   _XX_DATA = CTOD(_DATINI) - 1
	   _XX_MESE = SUBSTR(DTOC(_XX_DATA+1),4,2)
	   _XX_GGMS = 0
	   DO WHILE I < _GGPREV
	      _XX_DATA = _XX_DATA + 1
	      x_cond = "cal_datamg = '" + RIBALTA2(DTOC(_XX_DATA)) + "'"
	      cSql   = "SELECT * FROM U_CAL_LA WHERE " + x_cond
	      IF !ExecCommand(cSql,"CUR_CAL_LA")
	         return(.f.)
	      ENDIF
	      SELECT CUR_CAL_LA
	      GO TOP
	      IF EOF()
	         MESSAGEBOX("Calendario lavorativo incompleto",16,"Attenzione")
	         
	         RETURN .F.
	      ENDIF
	      
	      IF CAL_LAVO
	            I = I + 1
	      ENDIF
	   ENDDO
	   _DATFIN = DTOC(_XX_DATA)
	ENDIF
	
    *** POP SELECT
    SELECT(_SWWS)
	SET ORDER TO &_OWWO
	IF _RWWR<RECCOUNT()
		GO _RWWR
	ELSE
		GO BOTTOM
	ENDIF
	*** POP SELECT
		
	RETURN _DATFIN
* FINE PROCEDURE DATA_FINE_DA_GIORNI
**********************************************************


**********************************************************
PROCEDURE LOGGER
**********************************************************


	PARAMETERS _str_da_loggare
	
	LOCAL _TIMESTAMP,gnLogFile
	
	_TIMESTAMP=dtoc(date())+" - "+time()
	
	IF FILE(PUB_LOGFILE)  && Does file exist? 
	   gnLogFile = FOPEN(PUB_LOGFILE,2)  && If so, open read-write
	   FSEEK(gnLogFile,0,2)
	ELSE
	   gnLogFile = FCREATE(PUB_LOGFILE)  && If not, create it
	ENDIF
	

	IF gnLogFile >= 0 && Verifica errore in apertura del file
		FWRITE(gnLogFile,_TIMESTAMP+" - "+ _str_da_loggare )
		FWRITE(gnLogFile,chr(13))
	ENDIF

	FCLOSE(gnLogFile) 
	
	
* FINE PROCEDURE LOGGER
**********************************************************


**********************************************************
PROCEDURE LOGERROR
**********************************************************

LOCAL _messaggio

_messaggio= "Errore:    "+str(ERROR())+CHR(13)+;
               "Messaggio: "+MESSAGE()+CHR(13)+;
               "Codice:    "+MESSAGE(1) +CHR(13)+;
               "Tabella in uso: "+alias(select())+CHR(13)+;
               "Rec-number: "+str(recno())+CHR(13)
               
LOGGER(_messaggio)               

**********************************************************
* FINE PROCEDURE LOGERROR
**********************************************************


**********************************************************
PROCEDURE GetTimestamp
**********************************************************

	LPARAMETERS pFormato
	
	LOCAL data,;
			ora,;
			timestamp,;
			AAAA,;
			MM,;
			GG,;
			hh,;
			pp,;
			ss,;
		    mmm,;
		    nNumeroParametri
		
	nNumeroParametri=PARAMETERS()
		
	data=dtoc(date())
	ora=TimeMillisec()
	
	AAAA=substr(data,7,4)
	MM=substr(data,4,2)
	GG=substr(data,1,2)
	
	hh=substr(ora,1,2)
	pp=substr(ora,4,2)
	ss=substr(ora,7,2)
	mmm=substr(ora,10,3)
	
	timestamp=""
	
	IF nNumeroParametri>=1
	  timestamp=timestamp+&pFormato
	ELSE
	  timestamp=timestamp;
					+AAAA;
					+MM;
					+GG;		&& data in formato AAAAMMGG
					+hh;
					+pp;
					+ss;
					+mmm		&& ora in formato HHMMssmmm
	ENDIF
	
	RETURN timestamp

**********************************************************
* FINE PROCEDURE GetTimestamp
**********************************************************


**********************************************************
PROCEDURE TimeMillisec
**********************************************************

  LOCAL data,;
  		ora,;
  		timestamp,;
  		secondiDaMezzanotte,;
  		millisecondi,;
  		str_millisecondi

  secondiDaMezzanotte=seconds()
  ora=substr(TIME(secondiDaMezzanotte),1,8)
  
  millisecondi=(secondiDaMezzanotte-int(secondiDaMezzanotte))*1000
  str_millisecondi="000"+alltrim(str(millisecondi,3,0))
  str_millisecondi=substr(str_millisecondi,len(str_millisecondi)-2)
  
  return ora+":"+str_millisecondi

**********************************************************
* FINE PROCEDURE TimeMillisec
**********************************************************

**********************************************************
PROCEDURE AGGIUNGI_PRENOTAZIONE_MAGAZZINO
**********************************************************
LPARAMETERS _CODICE_ARTICOLO_INTERNO,_BARRA_DA_PRENOTARE

LOCAL _SWWS
_SWWS=SELECT()

SELECT PRENOTA_MAGA
APPEND BLANK
REPLACE MAG_CODART 	WITH _CODICE_ARTICOLO_INTERNO
REPLACE SEZIONE 	WITH _BARRA_DA_PRENOTARE

	
SELECT(_SWWS)	
* Fine - PROCEDURE AGGIUNGI_PRENOTAZIONE_MAGAZZINO
**********************************************************

**********************************************************
PROCEDURE SPRENOTA_UNA_BARRA_DAL_CURSORE_PRENOTAZIONI
**********************************************************
LPARAMETERS _BARRA_DA_SPRENOTARE

LOCAL _SWWS
_SWWS=SELECT()

SELECT PRENOTA_MAGA
DELETE FOR SEZIONE=_BARRA_DA_SPRENOTARE
	
SELECT(_SWWS)	
* Fine - PROCEDURE SPRENOTA_UNA_BARRA_DAL_CURSORE_PRENOTAZIONI
**********************************************************

**********************************************************
PROCEDURE TOLGO_TUTTI_I_CODICI_INTERNI_DAL_TAPPETO_PER_BARRA
**********************************************************
LPARAMETERS _BARRA_DA_SPRENOTARE
LOCAL _POSIZIONE_INIZIALE

LOCAL _SWWS
_SWWS=SELECT()

SELECT TAPPETO_TMP0
IF !EOF()
	_POSIZIONE_INIZIALE=RECNO()
	REPLACE CODINT WITH "" FOR SEZIONE = _BARRA_DA_SPRENOTARE
	GO _POSIZIONE_INIZIALE
ELSE
	REPLACE CODINT WITH "" FOR SEZIONE = _BARRA_DA_SPRENOTARE
	GO BOTTOM
ENDIF


SELECT(_SWWS)	
* Fine - PROCEDURE TOLGO_TUTTI_I_CODICI_INTERNI_DAL_TAPPETO_PER_BARRA
**********************************************************

**********************************************************
PROCEDURE RENDO_EFFETTIVA_SU_DB_LA_PRENOTAZIONE_DEI_ROTOLI_E_BARRE_A_MAGAZZINO
**********************************************************
LOCAL _CODICE_ARTICOLO_INTERNO

LOCAL _SWWS
_SWWS=SELECT()

_CODICE_ARTICOLO_INTERNO=""

SELECT PRENOTA_MAGA
SET ORDER TO SEZIONE
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP 
	ENDIF

	_CODICE_ARTICOLO_INTERNO = MAG_CODART
	_ALIAS=SYS(2015)
	cSql = "UPDATE U_MAG_GG SET MAG_PRENOT=1 WHERE MAG_CODART='"+ALLTRIM(_CODICE_ARTICOLO_INTERNO)+"' "
	IF !Execcommand(cSql,_ALIAS)
	    SELECT(_SWWS)
		return(.f.)
	ENDIF
	
	SELECT PRENOTA_MAGA
	SKIP
ENDDO
	
SELECT(_SWWS)	
* Fine - PROCEDURE RENDO_EFFETTIVA_SU_DB_LA_PRENOTAZIONE_DEI_ROTOLI_E_BARRE_A_MAGAZZINO
**********************************************************


**********************************************************
PROCEDURE IMPOSTA_BARRA_NON_DA_SPALMARE
**********************************************************
LPARAMETERS _BARRA,_CODICE_ARTICOLO_INTERNO

LOCAL _SWWS
_SWWS=SELECT()
				
SELECT SEZIONI
SET ORDER TO SEZIONE
SEEK _BARRA
IF FOUND()
	REPLACE SPALMARE WITH .F.
	REPLACE CODINT   WITH _CODICE_ARTICOLO_INTERNO	
ENDIF

SELECT(_SWWS)	
* PROCEDURE IMPOSTA_BARRA_NON_DA_SPALMARE
**********************************************************

**********************************************************
PROCEDURE IMPOSTA_BARRA_DA_SPALMARE
**********************************************************
LPARAMETERS _BARRA
				
LOCAL _SWWS
_SWWS=SELECT()

SELECT SEZIONI
SET ORDER TO SEZIONE
SEEK _BARRA
IF FOUND()
	REPLACE SPALMARE WITH .T.
ENDIF

SELECT(_SWWS)
* PROCEDURE IMPOSTA_BARRA_DA_SPALMARE
**********************************************************


**********************************************************
PROCEDURE BARRA_DA_SPALMARE
**********************************************************
LPARAMETERS _BARRA

LOCAL _SPALMARE

LOCAL _SWWS
_SWWS=SELECT()
				
SPALMARE=.F.

SELECT SEZIONI
SET ORDER TO SEZIONE
SEEK _BARRA
IF !FOUND()
	SELECT(_SWWS)
	RETURN .F.
ENDIF

_SPALMARE=SPALMARE

SELECT(_SWWS)	

RETURN _SPALMARE
* FINE PROCEDURE BARRA_DA_SPALMARE
**********************************************************


**************************************************************************	
PROCEDURE CONTROLLA_A_MAGAZZINO_ROTOLI_E_BARRE_E_CONFRONTA_CON_PRENOTATI
**************************************************************************	
LPARAMETERS _CODART,_SPESS,_ALTEZ,_LUNGH

LOCAL _CODINT
_CODINT=""


*** SIMONE - 12/06/2009 - QUESTA FUNZIONE NON DEVE PRELEVARE I ROTOLI
***                       DA MAGAZZINO FINO A QUANDO NON VIENE FATTO L'INVENTARIO FISICO
***
*** >>> PER FABIANO <<<
***		COMUNQUE IL PROGRAMMA SBAGLIA, INFATTI PRELEVA SEMPRE LO STESSO ROTOLO,
***     DOPO CHE L'HA PRELEVATO, DEVE IMPOSTARE PER QUEL ROTOLO IL PRENOTATO A TRUE,
***     ALTRIMENTI LO VEDRA' "PER SEMPRE" LIBERO
***
*** ############################ ############################ 
*** ############################ ############################ 
***
***		FORZO L'USCITA DA PROGRAMMA
***
*** ############################ ############################ 
*** ############################ ############################ 

RETURN SPACE(0)




LOCAL _SWWS
_SWWS=SELECT()

_ALIAS=SYS(2015)
cSql = "SELECT * FROM U_MAG_GG WHERE MAG_ANAART='"+ALLTRIM(_CODART)+"' AND MAG_ALTEZZ='"+ALLTRIM(STR(_ALTEZ))+"' AND MAG_LUNGHE='"+ALLTRIM(STR(_LUNGH))+"' AND MAG_GIACEN>0 AND MAG_PRENOT=0 ORDER BY MAG_CODART"
IF !Execcommand(cSql,_ALIAS)
	SELECT(_SWWS)
	return(.f.)
ENDIF

SELECT &_ALIAS
GO TOP

DO WHILE !EOF()

	_CODINT=MAG_CODART
	
	SELECT PRENOTA_MAGA
	SET ORDER TO MAG_CODART
	SEEK _CODINT
	
	IF !FOUND()
		SELECT(_SWWS)
		RETURN _CODINT			
	ENDIF

	SELECT &_ALIAS
	SKIP 
ENDDO	
		
SELECT &_ALIAS
USE
		
SELECT(_SWWS)

RETURN SPACE(0)
	
* FINE PROCEDURE CONTROLLA_A_MAGAZZINO_ROTOLI_E_BARRE_E_CONFRONTA_CON_PRENOTATI
**********************************************************	


**********************************************************
PROCEDURE DECINA_SUPERIORE
**********************************************************
LPARAMETERS _NUMERO_DA_APPROSSIMARE_ALLA_DECINA_SUPERIORE

LOCAL _RISULTATO
	
_RISULTATO=_NUMERO_DA_APPROSSIMARE_ALLA_DECINA_SUPERIORE

_RESTO_DELLA_DIVISIONE_PER_DIECI=_RISULTATO%10
IF _RESTO_DELLA_DIVISIONE_PER_DIECI>0
	_RISULTATO=_RISULTATO +(10-_RESTO_DELLA_DIVISIONE_PER_DIECI)
ENDIF

RETURN _RISULTATO

* FINE PROCEDURE DECINA_SUPERIORE
**********************************************************


**********************************************************
PROCEDURE CALCOLO_DIMENSIONE_MASSIMA_BOBINA
**********************************************************
*** CALCOLA LA DIMENSIONE MASSIMA DELLA BOBINA
*** IN LUNGHEZZA
*** IN FUNZIONE DEL GRUPPO PRODUTTIVO
***

LOCAL _DIMENSIONE_MASSIMA_BOBINA

_DIMENSIONE_MASSIMA_BOBINA=15000

cSql = "select * from PARA WHERE CODICE='LMBDEFAULT'"
IF !ExecCommand(cSql,"PARALMB")
	return(.f.)
ENDIF
SELECT PARALMB
GO TOP
IF !EOF()
	_DIMENSIONE_MASSIMA_BOBINA=VAL(SUBSTR(LIBERA,1,10))
ENDIF

cSql = "select * from PARA WHERE CODICE='LMB"+ALLTRIM(PUB_GRUPPO_PRODUTTIVO)+"'"
IF !ExecCommand(cSql,"PARALMB")
	return(.f.)
ENDIF
SELECT PARALMB
GO TOP
IF !EOF()
	_DIMENSIONE_MASSIMA_BOBINA=VAL(SUBSTR(LIBERA,1,10))
ENDIF

LUNGHEZZA_BOBINA=_DIMENSIONE_MASSIMA_BOBINA

* FINE PROCEDURE CALCOLO_DIMENSIONE_MASSIMA_BOBINA
**********************************************************


**********************************************************
PROCEDURE RICALCOLA_ALTEZZA_MAX_BOBINA
**********************************************************

* IF 6=MESSAGEBOX("SET STEP ON ?",4+32,"")	
* 	SET STEP ON
* ENDIF

SELECT CAMBI_BOBINA
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF
	
	ALTEZZA_BOBINA=DECINA_SUPERIORE(ALTEZ)
	
	EXIT
ENDDO

* FINE PROCEDURE RICALCOLA_ALTEZZA_MAX_BOBINA
**********************************************************



**********************************************************
PROCEDURE PUSH_TAPPETO
**********************************************************

SELECT POP_ROTOLI
DELETE ALL
SELECT TAPPETO
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF	

	SCATTER MEMVAR MEMO
	SELECT POP_ROTOLI
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	SELECT TAPPETO
	SKIP
ENDDO

SELECT POP_BARRE
DELETE ALL
SELECT SEZIONI
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF	

	SCATTER MEMVAR MEMO
	SELECT POP_BARRE
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	SELECT SEZIONI
	SKIP
ENDDO

SELECT POP_BOBINE
DELETE ALL
SELECT CAMBI_BOBINA
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF	

	SCATTER MEMVAR MEMO
	SELECT POP_BOBINE
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	SELECT CAMBI_BOBINA
	SKIP
ENDDO
* FINE PROCEDURE PUSH_TAPPETO
**********************************************************

**********************************************************
PROCEDURE POP_TAPPETO
**********************************************************

SELECT TAPRIBOB
DELETE ALL

SELECT TAPPETO
DELETE ALL

SELECT POP_ROTOLI
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF	

	SCATTER MEMVAR MEMO
	SELECT TAPPETO
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	SELECT POP_ROTOLI
	SKIP
ENDDO

SELECT SEZIONI
DELETE ALL
 
SELECT POP_BARRE
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF	

	SCATTER MEMVAR MEMO
	SELECT SEZIONI
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	SELECT POP_BARRE
	SKIP
ENDDO

SELECT CAMBI_BOBINA
DELETE ALL
SELECT POP_BOBINE
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF	

	SCATTER MEMVAR MEMO
	SELECT CAMBI_BOBINA
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	SELECT POP_BOBINE
	SKIP
ENDDO

* FINE PROCEDURE POP_TAPPETO
**********************************************************


**********************************************************
PROCEDURE ANNULLA_RIBOBINATURA
**********************************************************
LPARAMETERS _FORM

SELECT TAPRIBOB
GO TOP
IF EOF()
	=MESSAGEBOX("Nessunna barra ribobinata",48,"Annullo ribobinatura")
	RETURN	
ENDIF

DO POP_TAPPETO

_FORM.TASTO_ELABORA.Click()

* FINE PROCEDURE ANNULLA_RIBOBINATURA
**********************************************************


**********************************************************
PROCEDURE POP_TUNING
**********************************************************
LOCAL _ALIAS_ROTOLI,_ALIAS_BARRE

SELECT TUNING
SET ORDER TO TUNING 
GO TOP

IF EOF()
	RETURN
ENDIF

_ALIAS_ROTOLI=CUR_ROTOLI
_ALIAS_BARRE =CUR_BARRE

SELECT TAPPETO_TMP0
ZAP

SELECT &_ALIAS_ROTOLI
GO TOP
DO WHILE !EOF()

	SCATTER MEMVAR MEMO
	
	SELECT TAPPETO_TMP0
	APPEND BLANK
	GATHER MEMVAR MEMO

	SELECT &_ALIAS_ROTOLI
	SKIP
ENDDO

SELECT SEZIONI
ZAP

SELECT &_ALIAS_BARRE
GO TOP
DO WHILE !EOF()

	SCATTER MEMVAR MEMO
	
	SELECT SEZIONI
	APPEND BLANK
	GATHER MEMVAR MEMO

	SELECT &_ALIAS_BARRE
	SKIP
ENDDO

* FINE PROCEDURE POP_TUNING
**********************************************************


**********************************************************
PROCEDURE PUSH_TUNING
**********************************************************
LOCAL _ALIAS_ROTOLI,_ALIAS_BARRE,_NR_FASCE,_HMAX_FASCE

_ALIAS_ROTOLI=ALLTRIM("ROTOLI"+SYS(2015))
_ALIAS_BARRE =ALLTRIM("BARRE"+SYS(2015))

SELECT * FROM TAPPETO_TMP0 INTO CURSOR &_ALIAS_ROTOLI

SELECT * FROM SEZIONI INTO CURSOR &_ALIAS_BARRE

SELECT DISTINCT ALTEZ FROM SEZIONI ORDER BY ALTEZ DESC INTO CURSOR FASCE

SELECT FASCE
GO TOP

_NR_FASCE=0
_HMAX_FASCE=0

DO WHILE !EOF()
	
	IF DELETED()
		SKIP
		LOOP
	ENDIF
	
	IF ALTEZ<=0
		SKIP
		LOOP
	ENDIF
	
	*** LE FASCE SONO IN ORDINE DI 
	*** ALTEZZA DECRESCENTE
	*** PER AVERE L'ALTEZZA MASSIMA 
	*** E' SUFFICIENTE PRENDERE IL PRIMO RECORD
	***
	IF _HMAX_FASCE=0
		_HMAX_FASCE=ALTEZ
	ENDIF
	
	_NR_FASCE=_NR_FASCE+1
	
	SELECT FASCE
	SKIP

ENDDO

SELECT FASCE
USE

SELECT SEZIONI
ZAP

SELECT TAPPETO_TMP0
ZAP

SELECT TUNING
APPEND BLANK

REPLACE CUR_ROTOLI WITH _ALIAS_ROTOLI
REPLACE CUR_BARRE  WITH _ALIAS_BARRE
REPLACE HMAX_FASCE WITH STR_FILL_ZERO(_HMAX_FASCE,5)
REPLACE NR_FASCE   WITH STR_FILL_ZERO(_NR_FASCE,5) 

* FINE PROCEDURE PUSH_TUNING
**********************************************************

* **********************************************************
* PROCEDURE DISPONI_ROTOLI
* **********************************************************
* * !!!ATTENZIONE!!! - E' QUI CHE VIENE CREARTA LA COMPOSIZIONE
* * DELLE BARRE
* *
* * QUESTA PROCEDURA SI OCCUPA DI RAGGRUPPARE I ROTOLI 
* * COMPONENDO LE BARRE IN MODO TALE CHE
* *
* * 1) VENGANO RIEMPITE LE BARRE (QUI CHIAMATE "SEZIONI") NEL 
* *    MIGLIOR MODO POSSIBILE IN ALTEZZA.
* *    PRIMA VENGONO SIAPOSTI I ROTOLI CON ALTEZZA MAGGIORE
* *
* * 2) VENGANO RIEMPITE LE BARRE (QUI CHIAMATE "SEZIONI")  
* *    IN MODO ORDINATO PER LUNGHEZZA PARTENDO DAI ROTOLI PIU' LUNGHI
* *
* * 3) VENGANO RIEMPITI DISPOSTI I ROTOLI IN TENENDO VICINI 
* *    QUELLO DELLO STESSO ORDINE IN MODO CHE NON CI SIA UN
* *    TAPPETO TROPPO "ARLECCHINO".
* *    N.B.: I ROTOLI DI UNO STESSO ORDINE AVRANNO SUL TAPPETO
* *    LO STESSO COLORE
* *
* **********************************************************

* LOCAL _NUMORD,;
* 	  _DTCONS,;
* 	  _ALTEZ,;
* 	  _LUNGH,;
* 	  _QTA,;
* 	  _RAGSOC,;
* 	  _DATORD,;
* 	  _CODCLI,;
* 	  _CODICE_SEZIONE_VALIDO,;
* 	  _SCARTO,;
* 	  _ALTEZZA_GIA_OCCUPATA_NELLA_BARRA,;
* 	  _ALTEZZA_ANCORA_DISPONIBILE_NELLA_BARRA,;
* 	  _ORDER_BY,;
* 	  _QUERY_ROTOLI_ORDINI

* _ORDER_BY=""

* * 1) VENGANO RIEMPITE LE BARRE (QUI CHIAMATE "SEZIONI") NEL 
* *    MIGLIOR MODO POSSIBILE IN ALTEZZA.
* *    PRIMA VENGONO SIAPOSTI I ROTOLI CON ALTEZZA MAGGIORE
* * 
* IF PUB_OTTIMIZZA_ALTEZZA_ROTOLI=1
* 	_ORDER_BY=' ALTEZ DESC ' +IIF(!EMPTY(_ORDER_BY),",","")+_ORDER_BY
* ENDIF

* * 2) VENGANO RIEMPITE LE BARRE (QUI CHIAMATE "SEZIONI")  
* *    IN MODO ORDINATO PER LUNGHEZZA PARTENDO DAI ROTOLI PIU' LUNGHI
* *
* IF PUB_OTTIMIZZA_LUNGHEZZA_ROTOLI=1
* 	_ORDER_BY=' LUNGH ' +IIF(!EMPTY(_ORDER_BY),",","")+_ORDER_BY
* ENDIF

* * 3) VENGANO RIEMPITI DISPOSTI I ROTOLI IN TENENDO VICINI 
* *    QUELLO DELLO STESSO ORDINE IN MODO CHE NON CI SIA UN
* *    TAPPETO TROPPO "ARLECCHINO".
* *    N.B.: I ROTOLI DI UNO STESSO ORDINE AVRANNO SUL TAPPETO
* *    LO STESSO COLORE
* *
* IF PUB_OTTIMIZZA_NO_ARLECCHINO=1
* 	_ORDER_BY=' NUMORD ' +IIF(!EMPTY(_ORDER_BY),",","")+_ORDER_BY
* ENDIF

* * 4) VENGONO DISPOSTI I ROTOLI METTENDO PRIMA QUELLI CON
* *    DATA DI CONSEGNA INFERIORE
* *
* IF PUB_OTTIMIZZA_PER_DATA_CONSEGNA=1
* 	_ORDER_BY=' DTCONS ' +IIF(!EMPTY(_ORDER_BY),",","")+_ORDER_BY
* ENDIF

* _QUERY_ROTOLI_ORDINI="SELECT * FROM PROGPROD ORDER BY "+_ORDER_BY+" INTO CURSOR PROGPROD_ELAB"

* &_QUERY_ROTOLI_ORDINI

* SELECT PROGPROD_ELAB
* GO TOP

* DO WHILE !EOF()
* 	
* 	IF DELETED()	
* 		SKIP
* 		LOOP
* 	ENDIF

* 	_NUMORD      = NUMORD
* 	_DTCONS      = DTCONS
* 	_ALTEZ       = ALTEZ
* 	_LUNGH       = LUNGH
* 	_QTA         = QTA
* 	_RAGSOC	     = RAGSOC
* 	_DATORD      = DATORD
* 	_CODCLI      = CODCLI 
* 	_CODART      = CODART
* 	_DESART      = DESART
* 	_GRP_PROD    = GRP_PROD
* 	_MICROFORATO = MICROFORATO
* 	_ADESIVO     = ADESIVO
* 	_GGEVAS      = GGEVAS 
* 	_ORD_CODSYS	 = ORD_CODSYS
* 	_SPESS       = SPESS
* 	
* 	FOR I=1 TO _QTA	

* 		DO BLOCCA_ARTICOLO_CON_GIACENZA WITH _CODART,_ALTEZ,_LUNGH,_SPESS
* 	
* 		_CODICE_SEZIONE_VALIDO=0
* 		
* 		SELECT SEZIONI
* 		SET ORDER TO LUNGH
* 		GO TOP
* 			
* 		DO WHILE !EOF()
* 		
* 			IF DELETED()
* 				SKIP
* 				LOOP
* 			ENDIF
* 			
* 			IF LUNGH<_LUNGH
* 				SKIP
* 				LOOP
* 			ENDIF
* 			
* 			IF LUNGH>_LUNGH
* 				EXIT
* 			ENDIF
* 		
* 			*** TROVA UNA SEZIONE (O BARRA) GIA' CREATA CHE SIA CANDIDATA A CONTENERE
* 			*** IL MIO ROTOLO CHE STO ELABORANDO
* 			*** OSSIA ALTA MENO DELL'ALTEZZA DELLA BOBINA MADRE SOTRATTA DELL'ALTEZZA DEL ROTOLO
* 			*** E LUNGA COME IL ROTOLO
* 			***
* 			
* 			_ALTEZZA_GIA_OCCUPATA_NELLA_BARRA      = ALTEZ + SCARTO + SCARTO_TAGLIO
* 			_ALTEZZA_ANCORA_DISPONIBILE_NELLA_BARRA= ALTEZZA_BOBINA - _ALTEZZA_GIA_OCCUPATA_NELLA_BARRA
* 			
* 			IF _ALTEZZA_ANCORA_DISPONIBILE_NELLA_BARRA >= _ALTEZ
* 				_CODICE_SEZIONE_VALIDO=SEZIONE
* 				EXIT
* 			ENDIF
* 			
* 			SKIP 
* 			LOOP
* 		ENDDO
* 		
* 		*** NON TROVA NESSUNA SEZIONE (O BARRA) GIA' CREATA CHE SIA CANDIDATA A CONTENERE
* 		*** IL MIO ROTOLO CHE STO ELABORANDO
* 		***
* 		IF _CODICE_SEZIONE_VALIDO=0
* 			SELECT SEZIONI
* 			SET ORDER TO SEZIONE
* 			GO BOTT
* 			_CODICE_SEZIONE_VALIDO=SEZIONE+1

* 			*** creo una nuova sezione (O BARRA)
* 			*** di lunghezza opportuna
* 			***
* 			APPEND BLANK
* 			REPLACE SEZIONE WITH _CODICE_SEZIONE_VALIDO
* 			REPLACE LUNGH   WITH _LUNGH
* 			*** AGGIUNGO LO SCARTO NELLA SEZIONE (O BARRA) DATO DA
* 			*** SCARTO LATERALE (CIMOSA) + SCARTO DI TAGLIO
* 			***
* 			REPLACE SCARTO   WITH SCARTO_LATERALE - SCARTO_TAGLIO
* 			REPLACE ALTEZ    WITH SCARTO_LATERALE - SCARTO_TAGLIO
* 		ENDIF
* 		
* 		*** aggiorna la tabella delle SEZIONI (O BARRE)
* 		***
* 		SELECT SEZIONI
* 		REPLACE ALTEZ WITH ALTEZ +_ALTEZ + SCARTO_TAGLIO
* 		*** AGGIUNGO LO SCARTO NELLA SEZIONE (O BARRA) DATO DA
* 		*** SCARTO PRECEDENTE + SCARTO DI TAGLIO PER IL NUOVO TAGLIO
* 		***
* 		REPLACE SCARTO WITH SCARTO + SCARTO_TAGLIO		
* 				
* 		*** AGGIORNO IL CURSORE TEMPORANEO DEI ROTOLI
* 		*** 
* 		SELECT TAPPETO_TMP0 
* 		APPEND BLANK
* 		REPLACE NUMORD WITH _NUMORD,;
* 				DTCONS WITH _DTCONS,;
* 				SEZIONE WITH _CODICE_SEZIONE_VALIDO,;
* 				ALTEZ WITH _ALTEZ,;
* 				LUNGH WITH _LUNGH,;
* 				RAGSOC WITH _RAGSOC,;
* 				CODCLI WITH _CODCLI,;
* 		        DATORD WITH _DATORD,;
* 		        CODART WITH _CODART,;
* 				DESART WITH _DESART,;
* 		        CESTINO WITH .F.,;
* 				GRP_PROD WITH _GRP_PROD,;
* 				MICROFORATO WITH _MICROFORATO,;
* 				ADESIVO WITH _ADESIVO,;
* 				GGEVAS WITH _GGEVAS ,;
* 				ORD_CODSYS WITH _ORD_CODSYS

* 	NEXT

* 	SELECT PROGPROD_ELAB
* 	SKIP
* ENDDO

* SELECT TAPPETO_TMP0 

* * FINE PROCEDURE DISPONI_ROTOLI
* **********************************************************



**********************************************************
PROCEDURE MESSAGGIO_GROSSO_BLU
**********************************************************
LPARAMETERS _MESSAGGIO

SET CLASSLIB TO "proj_lib.vcx" additive
oForm=CreateObject("MsgErr") 
oform.edit1.Value=_MESSAGGIO
oform.Show
RELEASE oForm 		





**********************************************************
PROCEDURE GET_PRGPROD_DA_ORDSYS
*
* RITORNA IL NUMERO DI PROGRAMMA DI PRODUZIONE, PASSANDOGLI L'ORD_CODSYS (PRESO DA DETTAGLIO ORDINE)
*  -- SE TROVA IL PROGRAMMA RITORNA IL NUMERO DEL PROGRAMMA (VARCHAR)
*  -- SE NON TROVA CORRISPONDENZE, RITORNA UNA STRINGA FISSA "NON PROGRAMMATO"
* 
* sintassi:  GET_PRGPROD_DA_ORDSYS(<ORD_CODSYS>)
*
**********************************************************
	LPARAMETERS _ORD_CODSYS_PASSATO

	LOCAL _RET_PRG
	_RET_PRG = ""

	_SWWS_=SELECT()		

		cSql=""     
		cNomeCursorSql="CU_GET_PRGPROD"
					
		TEXT TO cSql NOSHOW  	

			SELECT DISTINCT PROGRAMMA.PR1_NUMPRG AS PRG
			FROM U_PRD_D5 AS ROTOLI
				LEFT OUTER JOIN U_PRD_D1 AS PROGRAMMA
				ON ROTOLI.PJ_PRGPRD1 = PROGRAMMA.PJ_PRGPRD1
			WHERE ROTOLI.PR5_ORDSYS = '<<_ORD_CODSYS_PASSATO>>'
			
		ENDTEXT

		IF !ExecPreparedCommand(cSql,cNomeCursorSql)
			SELECT(_SWWS_)
			return ''
		ENDIF

		SELECT CU_GET_PRGPROD
		_RET_PRG = CU_GET_PRGPROD.PRG
		
	    IF EMPTY(ALLTRIM(_RET_PRG)) 
	    	_RET_PRG = 'NON PROGRAMMATO'
	    ENDIF
    
    SELECT(_SWWS_)

	RETURN _RET_PRG
		
* FINE - PROCEDURE GET_PRGPROD_DA_ORDSYS
**********************************************************		

