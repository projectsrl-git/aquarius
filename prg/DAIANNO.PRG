

RELEASE PUB_ANNO
PUBLIC PUB_ANNO


DO WHILE .T.
   
   *IF !ExecCommand("select * from para where codice LIKE 'ANN'+?pub_codsoc+'%' order by codice","para")
   IF !ExecCommand("select * from para where codice LIKE 'ANN'+?pub_codsoc+'%' order by codice desc","para")  && ERASMO - 20/10/2022
      return
   ENDIF
  
   PUB_ANNO = SPACE(4)
   NUMERO   = 0

   SELECT PARA
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF DELETED()
         SKIP +1
         LOOP
      ENDIF
	  IF PUB_VISACH
         NUMERO=NUMERO+1
	  ELSE
	      IF SUBSTR(LIBERA,1,6)='APERTO'
	         PUB_ANNO=SUBSTR(LIBERA,10,4)
	         NUMERO=NUMERO+1   
	      ENDIF
	  ENDIF
      SKIP +1
   ENDDO

   IF NUMERO>=2
	  PUB_ANNO=SPACE(4) 
	  SELECT PARA
	  IF PUB_VISACH  && Se TRUE, visualizza anche gli anni contabili CHIUSI nella schermata di switch anno contabile
	  ELSE
	     SET FILTER TO SUBSTR(CODICE,1,3)=='ANN' .AND. SUBSTR(LIBERA,1,6)=='APERTO'
	  ENDIF
	  GO TOP
	  PUB_SELECT = SELECT()
	  PUB_SEEK   = ''
  	  PUB_TESTA  = '       CODICE ANNI CONTABILI APERTI '
	  PUB_VISTA  = "SUBSTR(CODICE,6,4)+' | '+SUBSTR(LIBERA,1,35)"
	  PUB_RIT    = 'SUBSTR(CODICE,6,4)'
	  DO FORM FORM\ACQANNO  WITH "Esercizio contabile" LINKED
 	  SELECT PARA
	  STORE SUBSTR(CODICE,6,4) TO PUB_RIT
	  PUB_TESTA=""
	  STORE PUB_RIT TO PUB_ANNO
	  
	  PUB_ANNOX = VAL(PUB_ANNO) - 1
	  PUB_ANNOP = STR(PUB_ANNOX,4,0)
	  PUB_ANNOY = VAL(PUB_ANNO) + 1
	  PUB_ANNOS = STR(PUB_ANNOY,4,0)


	  IF !ExecCommand("select * from para where codice = 'ANN'+?pub_codsoc+?pub_anno","cu_Para")
 	     return(.f.)
	  ENDIF
	  SELECT cu_PARA
	  IF reccount() > 0
		 PUB_VALRIF = SUBSTR(LIBERA,25,3)
		 IF EMPTY(PUB_VALRIF)
		    PUB_ERRORE=MESSAGEBOX('Anno contabile: '+">>>>"+PUB_ANNO+"<<<<<"+CHR(13)+'senza valuta di riferimento',64,'*** ATTENZIONE ***') 
			DO FORM FORM\VALRIFE
			PUB_VALRIF = VALRIF
	 	 ENDIF	
	  ELSE
		 PUB_ERRORE=MESSAGEBOX('Anno contabile: '+PUB_ANNO+CHR(13)+'non presente',64,'*** ATTENZIONE ***') 
	  ENDIF  
	  SELECT cu_PARA
	  SET FILTER TO
	  IF EMPTY(PUB_ANNO)
 	     PUB_ERRORE=MESSAGEBOX('Seleziona un anno contabile'+CHR(13)+'Grazie ',64,'*** ATTENZIONE ***') 
	     LOOP
	  ENDIF
  	  PUB_ERRORE=MESSAGEBOX('Anno contabile :'+PUB_ANNO+CHR(13)+'esatto',292,'*** ATTENZIONE ***') 
 	  DO CASE

		 CASE PUB_ERRORE= 6  && RISPOSTA SI
			 * 2016/10/16 SERGIO INIZIO
			 IF !EMPTY(Pub_xUsaSoloInVisualizzazione)
				IF VAL(PUB_ANNO) => VAL(Pub_xUsaSoloInVisualizzazione) && NON E' POSSIBILE PROSEGUIRE SULL'ESERCIZIO DIGITATO: E' SOLO POSSIBILE GESTIRE GLI ANNI PRECEDENTI
					Pub_DataVisualizzazione = "01/01/"+Pub_xUsaSoloInVisualizzazione
					DO FORM form\scadenza WITH 'smiley_29.gif',168,595,'4',Pub_DataVisualizzazione 
					PUB_ANNO =  PUB_ANNO_DIGITATO 
					PUB_ANNOX = VAL(PUB_ANNO) - 1
					PUB_ANNOP = STR(PUB_ANNOX,4,0)
					PUB_ANNOY = VAL(PUB_ANNO) + 1
					PUB_ANNOS = STR(PUB_ANNOY,4,0)		
				ENDIF 
			 ENDIF 
			 * 2016/10/16 SERGIO FINE		 
		 
		      DO PRG\SETUSER 
		      DO PRG\SAY_ESERCIZIO      
	          EXIT
	          
		 CASE PUB_ERRORE= 7  && RISPOSTA NO
	          LOOP
	          
	  ENDCASE
   ELSE
	  EXIT
   ENDIF
           
ENDDO


