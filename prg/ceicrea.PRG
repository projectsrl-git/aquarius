**********************************************************************************************
* 			 CREAZIONE ARCHIVIO CESSIONI INTRACOMUNITARIE				       				 *
*																			 				 *
**********************************************************************************************

RELEASE V_PESO_TESTATA_FATTURA   
PUBLIC V_PESO_TESTATA_FATTURA   
V_PESO_TESTATA_FATTURA  = 0

RELEASE _DESCRIZIONE_ANOMALIE,ESISTONO_ERRORI
PUBLIC  _DESCRIZIONE_ANOMALIE,ESISTONO_ERRORI
_DESCRIZIONE_ANOMALIE = "VENDITE"
ESISTONO_ERRORI = .F.

RELEASE  PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_PESO,perdal,peral
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_PESO,perdal,peral
XDESF    = "REGISTRAZIONE AUTOMATICA"
COMPENSO = 0
TIVA     = 0
CIVA     = 0
TOP_TOP  = SPACE(03)
V_PESO   = 0
V_CLDOG  = "68101939???     "

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CREATE CURSOR W_ERR (W_CODFOR  C(13),    ;
					 W_DESERR  C(100))
SELECT W_ERR 
INDEX ON W_CODFOR  TAG DETTA


CREATE CURSOR W_FAT (W_IVACEE  C(20),    ;
					 W_CLDOG   C(16),    ;
					 W_RIGA    N(05),    ;
					 W_NATURA  C(01),    ;
					 W_PERI    C(07),    ;
                     W_IMPONI  N(17,3),  ;
                     W_VALSTA  N(17,3),  ;
                     W_MANETT  N(17,0),  ;
                     W_SPTRAS  N(17,3),  ;
                     W_QTA     N(17,0),  ;
                     W_PUBBLI  N(17,0),  ;
                     W_CONDCO  C(01),    ;
                     W_MODTRA  C(01),    ;
                     W_PAEDES  C(02),    ;
                     W_SEGN  C(01),    ;
                     W_ORD_ANNO  C(04),    ;
                     W_PAEORI  C(02))

SELECT W_FAT
INDEX ON ALLTRIM(W_IVACEE) + ALLTRIM(W_CLDOG) + ALLTRIM(W_CONDCO) TAG DETTA  
SET ORDER TO DETTA

* CONTROLLA SE LE FATTURE SONO STATE TUTTE PROTOCOLLATE E SE IL CAMBIO E' ATTRIBUITO

PERDAL   = RIBALTA2(DATADAL)
PERAL    = RIBALTA2(DATAAL)
CT       = 0
CTRELAB  = 0
FL_OK    = .T.
FL_OKCAM = .T.

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_data = "ord_datord >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_data
Csql = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_datord"
IF !ExecRW(Csql,"U_FAT_TT","R")
   return(.f.)
ENDIF
SELECT U_FAT_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ORD_DATORD > PERAL
      EXIT
   ENDIF

   V_CODCLI = ORD_CODCLI

   x_soci   = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
   x_cond   = x_soci + " and " + x_codi
   Csql     = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"cur_cliente")
      return(.f.)
   ENDIF
   SELECT cur_cliente
   GO TOP
   IF !EOF()
      V_IVACEE  = CLI_IVACEE
   ELSE
      V_IVACEE  = SPACE(20)
   ENDIF

   SELECT U_FAT_TT

   IF EMPTY(V_IVACEE)  	
	  SKIP +1
	  LOOP
   ENDIF

   CTRELAB=CTRELAB+1
   WAIT WINDOW  "Fatture Elaborate "+STR(CTRELAB,6,0) NOWAIT

   IF EMPTY(ORD_NPROT)                            && VERIFICA N.PROTOCOLLO
  	  FL_OK = .F.
      EXIT
   ENDIF

   IF ORD_VALUTA = PUB_VALRIF
      REPLACE ORD_CAMBIO WITH 1		&& FORZA IL CAMBIO A 1
   ELSE
      IF ORD_CAMBIO = 0
	  	 FL_OKCAM = .F.
	     EXIT
	  ENDIF
   ENDIF

   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_FAT_TT","W")
   return(.f.)
ENDIF

IF !FL_OK
   =MESSAGEBOX("Funzione non permessa devi protocollare le fatture",62,"ATTENZIONE")
   RELEASE WINDOW DISPLAY
   RETURN
ENDIF

IF !FL_OKCAM
   =MESSAGEBOX("Funzione non permessa devi attribuire correttamente il cambio",62,"ATTENZIONE")
   RELEASE WINDOW DISPLAY
   RETURN
ENDIF

*--> CANCELLA LA CESSIONE VECCHIA

DO CEIDELE

*--> PRELEVA I DATI AZIENDALI

x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"u_azi_an")
   return(.f.)
ENDIF
SELECT u_azi_an
GO TOP
IF !EOF()
   M.ORD_CODCLI	= AZI_CODCLI
   M.ORD_RAGSOC	= AZI_RAGSOC
   M.ORD_INDIRI	= AZI_INDIRI
   M.ORD_CAP		= AZI_CAP
   M.ORD_LOCALI	= AZI_LOCALI
   M.ORD_PARIVA	= AZI_PIVA
   V_CONDCO    	= AZI_CONDCO
   V_MODTRA    	= AZI_MODTRA
   V_PAEORI    	= AZI_PAEORI
   V_NATURA    	= AZI_NATURA
   V_TELEFO        = AZI_TELEFO
ELSE
   M.ORD_CODCLI	= SPACE(10)
   M.ORD_RAGSOC	= SPACE(40)
   M.ORD_INDIRI	= SPACE(40)
   M.ORD_CAP		= SPACE(05)
   M.ORD_LOCALI	= SPACE(40)
   M.ORD_PARIVA	= SPACE(11)
   V_CONDCO    	= SPACE(01)
   V_MODTRA    	= SPACE(01)
   V_PAEORI    	= SPACE(02)
   V_NATURA    	= SPACE(01)	
   V_TELEFO        = ""
   WAIT WINDOW "Per cortesia codifica i dati anagrafici AZIENDA nei parametri di sistema"
ENDIF

CT       = 0
CTRELAB  = 0
V_TOTALE = 0



x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_data = "ord_datord >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_data
Csql = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_datord"
IF !ExecCommand(Csql,"U_FAT_TT")
   return(.f.)
ENDIF
SELECT U_FAT_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SELECT U_FAT_TT
      SKIP +1
      LOOP
   ENDIF

   IF ORD_DATORD > PERAL
      EXIT
   ENDIF


*!*	IF VAL(ORD_NUMORD) <> 450
*!*	      SELECT U_FAT_TT
*!*	      SKIP +1
*!*	      LOOP
*!*	ENDIF


   CTRELAB=CTRELAB+1
   WAIT WINDOW  "Fatture Elaborate"+STR(CTRELAB,6,0) NOWAIT

   ****  DATI DI TESTATA DELLA SINGOLA FATTURA ****

   SELECT U_FAT_TT
   V_PORTO  = ORD_PORTO
   V_CODCLI = ORD_CODCLI
   V_CONPAG = ORD_CPA
   V_DTSCA  = ORD_DTSCAD
   XDESF    = ORD_RAGSOC
   XVALUTA  = ORD_VALUTA
   XCAMBIO  = ORD_CAMBIO
   XSCONTO  = ORD_PERPAG
   V_SEEK   = TAGGANCIO
   SPESE    = ORD_SPBOLL + ORD_SPTRAS
   SP_INCA  = ORD_SPBOLL       && SPESE INCASSO
   SP_TRAS  = ORD_SPTRAS       && SPESE TRASPORTO
   VALFAT   = ORD_VALORE
   TOP_TOP  = ORD_CAUS         && FATTURE/NOTE CREDITO
   V_SEGN = '' 
   V_RIFER  = "DATA FATT. :"+RIBALTA2(ORD_DATORD)+ " NUMERO FATT. " + ORD_NUMORD
   NUMF     = ORD_NUMORD
   V_ORD_ANNO = SUBSTR(ORD_DATORD,1,4) && LUCA 2013



   V_PESO = 0
   V_PESO_TESTATA_FATTURA = ROUND(ORD_PESNET,0)
   
   v_seek	= 'TOP' + TOP_TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      NOTAC	=SUBSTR(LIBERA,11,1)
   ELSE   

      =CREACURSORERRORI(V_CODCLI,"Errore manca parametro TOP :"+TOP_TOP,V_RIFER)      
      TOP_TOP ="VEN"
      NOTAC =' '
   ENDIF

   v_seek	= 'POR'+V_PORTO
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V_CONDCO=SUBSTR(LIBERA,1,1)
   ELSE
      =CREACURSORERRORI(V_CODCLI,"Errore manca parametro porto : "+V_PORTO+"<<<<",V_RIFER)     
      V_CONDCO=""
   ENDIF

   SELECT U_FAT_TT
   V_SEGN = '-' 
   IF NOTAC   <> "S"            && FORZA TOP FATTURA DI VENDITA SE <> NOTA CREDITO
	  TOP_TOP = "VEN"
	  V_SEGN = '+' 
   ENDIF


   x_soci   = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
   x_cond   = x_soci + " and " + x_codi
   Csql     = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"cur_cliente")
      return(.f.)
   ENDIF
   SELECT cur_cliente
   GO TOP
   IF !EOF()
      V_IVACEE  = ALLTRIM(CLI_IVACEE)
   ELSE
      V_IVACEE  = SPACE(20)
   ENDIF

   IF EMPTY(V_IVACEE)
      SELECT U_FAT_TT  	
	  SKIP +1
	  LOOP
   ENDIF



   SELECT U_FAT_TT
   V_SEEK = TAGGANCIO
   x_agga = "daggancio = '" + ALLTRIM(V_SEEK) + "'"
   x_cond = x_agga
   Csql   = "select * from u_fat_dd where " + x_cond + " order by daggancio"
   IF !ExecCommand(Csql,"U_FAT_DD")
      return(.f.)
   ENDIF
 
   **==> CONTA QUANTE CLASSI DOGANALI CI SONO INSERITE NELLE RIGHE DELLA FATTURA
   _CONTA_CLDOG=0		&& NUMERO CLASSI DOGANALI PRESENTI NEI DETTAGLI DELLA FATTURA
   _LISTA_CLDOG=""
   
   SELECT U_FAT_DD
   GO TOP
   DO WHILE .T.
   
         IF EOF()
            EXIT
         ENDIF
  		 IF ORD_VALORE = 0
  		    SELECT U_FAT_DD
 	        SKIP +1
	        LOOP
	     ENDIF
         IF "*** COMMENTO ***" $ ORD_DESART
            SELECT U_FAT_DD
	        SKIP +1
	        LOOP
         ENDIF
 
         XIVA = ALLTRIM(ORD_IVA)
         XART = ORD_CODART

 
	     v_seek	= 'IVI'+XIVA 			&& SCARTA ARTICOLI CON CODICE IVA NON GESTITO PER INTRASTAT
	     v_chiave = "codice"
	     IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	     ELSE
		    SELECT U_FAT_DD
	        SKIP +1
	        LOOP
	     ENDIF

 
         V_PESO    = 0					&& CALCOLATO DENTRO VEDIART

	     IF SUBSTR(XART,1,3) <> ".SC"   && SE SCONTO CONSIDERA ULTIMA CLASSE DOGANALE
		     CLDOG = ALLTRIM(VEDIART(XART))
  		 ENDIF

		 IF !EMPTY(CLDOG)  
			 IF CLDOG  $ _LISTA_CLDOG
			 ELSE 
				_CONTA_CLDOG=_CONTA_CLDOG+1
		   		_LISTA_CLDOG=_LISTA_CLDOG+","+CLDOG 
		   	 ENDIF
		 ENDIF   

         SELECT U_FAT_DD
         SKIP + 1
         
	ENDDO
      
    IF  _CONTA_CLDOG>0
    	V_PESO_TESTATA_FATTURA  = INT(V_PESO_TESTATA_FATTURA  /_CONTA_CLDOG)
    ENDIF

 
   SELECT U_FAT_DD
   GO TOP
   IF !EOF()
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
  		 IF ORD_VALORE = 0
  		    SELECT U_FAT_DD
 	        SKIP +1
	        LOOP
	     ENDIF
         IF "*** COMMENTO ***" $ ORD_DESART
            SELECT U_FAT_DD
	        SKIP +1
	        LOOP
         ENDIF
 
         XIVA = ALLTRIM(ORD_IVA)
         XART = ORD_CODART

 
	     v_seek	= 'IVI'+XIVA 			&& SCARTA ARTICOLI CON CODICE IVA NON GESTITO PER INTRASTAT
	     v_chiave = "codice"
	     IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	     ELSE
		    SELECT U_FAT_DD
	        SKIP +1
	        LOOP
	     ENDIF

 
         V_PESO    = 0					&& CALCOLATO DENTRO VEDIART

	     IF SUBSTR(XART,1,3) <> ".SC"   && SE SCONTO CONSIDERA ULTIMA CLASSE DOGANALE
		     CLDOG = VEDIART(XART)
  		 ENDIF


         SELECT U_FAT_DD
         
	     VALORE    = CAMBIO(XVALUTA,ORD_VALORE,XCAMBIO)
         AR_PU     = ALLTRIM(ORD_PUBBLI)
	     *V_TOTALE  = V_TOTALE + VALORE
		 V_QTA     = ORD_QTAORD


	     IF NOTAC  = "S"       && VERIFICA NOTA CREDITO
	  	    VALORE = VALORE * -1
	 	 ENDIF

*!*	         IF AR_PU = 'S' OR AR_PU = 'O'
*!*	            V_TOTALE = V_TOTALE - VALORE       && TOGLIE MATERIALE PUBBLICITARIO
*!*		     ENDIF

		 ** Calcolo sconto
		 _WW_IMPONI = VALORE
		 SC_PERC = ROUND(_WW_IMPONI * XSCONTO / 100 ,2)
	 	 _netto = ROUND(_WW_IMPONI - SC_PERC,2)



	     SELECT W_FAT
	     SET ORDER TO DETTA
	     _SEEK = ALLTRIM(V_IVACEE)+ALLTRIM(CLDOG)+ALLTRIM(V_CONDCO)  
	     
	     SEEK _SEEK 
	     IF FOUND()

 
	       REPLACE W_IMPONI WITH W_IMPONI + _netto
	       IF AR_PU = 'S'
		       REPLACE W_PUBBLI WITH W_PUBBLI + _netto   && ARTICOLO PUBBLICITARIO
		   ENDIF
          
           REPLACE W_MANETT WITH W_MANETT + ROUND(V_QTA * V_PESO,0)
             
  		   *REPLACE W_SPTRAS WITH SP_TRAS

           REPLACE W_QTA    WITH W_QTA     + V_QTA

           V_PESO = 0
           
           V_TOTALE = V_TOTALE + _netto
	     
	     ELSE
	     
	        APPEND BLANK
	        REPLACE W_IVACEE WITH V_IVACEE
	        REPLACE W_CLDOG  WITH CLDOG
	        REPLACE W_PERI   WITH SUBSTR(XDATA,7,4)+"/"+SUBSTR(XDATA,4,2)
	        REPLACE W_IMPONI WITH _netto
	        REPLACE W_SPTRAS WITH SP_TRAS
	        
	        V_TOTALE = V_TOTALE + _netto + SP_TRAS
	        
	        SP_TRAS = 0 	&& altrimenti raddoppia le spese di trasporto all'append successiva
	                
 		    REPLACE W_NATURA WITH V_NATURA
            REPLACE W_MANETT WITH ROUND(V_QTA * V_PESO,0)

	        REPLACE W_QTA    WITH V_QTA
	        V_PESO = 0

            REPLACE W_VALSTA WITH 0
            REPLACE W_CONDCO WITH V_CONDCO
            REPLACE W_MODTRA WITH V_MODTRA
            REPLACE W_PAEDES WITH SUBSTR(V_IVACEE,1,2)
            REPLACE W_PAEORI WITH V_PAEORI
            REPLACE W_SEGN WITH V_SEGN	 
            REPLACE W_ORD_ANNO WITH V_ORD_ANNO   


            IF AR_PU = 'S' OR AR_PU = 'O'
   		       REPLACE W_PUBBLI WITH  _netto				&& ARTICOLO PUBBLICITARIO
		    ENDIF
	     
	     ENDIF
	     
	     SELECT U_FAT_DD
	     SKIP +1
	  ENDDO
   ELSE
      =CREACURSORERRORI(V_CODCLI,'Non trovo le righe di dettaglio fattura '+V_SEEK,V_RIFER)     
   ENDIF


   SELECT U_FAT_DD
   *v_totale= v_totale+sp_tras



   SELECT U_FAT_TT

   CT = CT +1
   SKIP +1

ENDDO

*--> PRELEVA IL NUMERO DELLA CESSIONE

v_seek   = 'NUMCEI'+PUB_CODSOC
v_chiave = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   M.ORD_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
ELSE
   RIT = MSGBOX('Parametro numero CEI non trovato','ATTENZIONE',31)
   RETURN
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF


PUB_LNO      = 6
M.ORD_NUMORD = TRC(PUB_LNO,ALLTRIM(M.ORD_NUMORD))
M.ORD_ANNO   = PUB_ANNO


IF !ExecCommand("select * from u_cei_tt where 0=1","cu_cei_tt")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_cei_dd where 0=1","cu_cei_dd")
   return(.f.)
ENDIF

*--> CREA ARCHIVIO U_CEI_TT

M.TAGGANCIO	 = STR(NEWPROG('NUMCEI'),10)
M.ORD_CODSOC = PUB_CODSOC
M.ORD_CAMBIO = 1
M.TNUMERO    = M.ORD_NUMORD
M.ORD_VALUTA = PUB_VALRIF
M.ORD_DATORD = ribalta2(XDATA)
M.ORD_VALORE = V_TOTALE
M.ORD_CAUS	 = "CEI"
M.ORD_TELEFO = V_TELEFO
M.ID_UNIQUE  = ""

SELECT CU_CEI_TT
APPEND BLANK
GATHER MEMVAR MEMO

* CREA ARCHIVIO U_CEI_DD
CTR_RIGA = 0
SELECT W_FAT
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   
   IF W_IMPONI != W_SPTRAS   
   
   
   
	   IF W_PUBBLI <> 0
	      REPLACE W_IMPONI WITH  W_IMPONI - W_PUBBLI  && SE CONTROPARTITA CON MAT.PUBBLIC.
	   ENDIF
	   CTR_RIGA = CTR_RIGA +1
	   M.ORD_RIGA   = CTR_RIGA
	   M.ORD_IVACEE = W_IVACEE
  
	   M.ORD_VALORE = ROUND(W_IMPONI,0) + ROUND(W_SPTRAS,0)		
   
	   M.ORD_NATURA = W_NATURA
	   M.ORD_CLDOG  = W_CLDOG
	   M.ORD_MANETT = W_MANETT
	   M.ORD_QTA    = W_QTA
	   M.ORD_VALSTA = W_VALSTA
	   M.ORD_CONDCO = W_CONDCO
	   M.ORD_MODTRA = W_MODTRA
	   M.ORD_PAEDES = W_PAEDES
	   M.ORD_PAEORI = W_PAEORI
	   M.ORD_SEGN = W_SEGN   
	   M.ORD_ANNO = W_ORD_ANNO   

	   SELECT CU_CEI_DD
	   APPEND BLANK
	   GATHER MEMVAR MEMO
	   REPLACE DAGGANCIO	WITH   M.TAGGANCIO
  
  
  ENDIF		
  
  
   SELECT W_FAT
   SKIP +1
ENDDO

IF !ExecRW('','u_cei_tt','I','','CU_CEI_TT')
   return(.f.)
ENDIF
IF !ExecRW('','u_cei_dd','I','','CU_CEI_DD')
   return(.f.)
ENDIF

RELEASE WINDOW DISPLAY


IF !ESISTONO_ERRORI
	=MESSAGEBOX("Creazione archivio vendite cee"+CHR(13)+"terminata correttamente , numero fatture elaborate :"+str(CT,5,0),16,"*** ATTENZIONE ***")
ELSE
	=MESSAGEBOX("Creazione archivio vendite cee"+CHR(13)+"NON terminata correttamente (ESISTONO ANOMALIE)",16,"*** ATTENZIONE ***")

	SELECT W_ERR
	GO TOP
	IF !EOF()   
	   DO PRG\MENUSTA WITH "W_ERR",.T.,.T.,"XXX","ERRINTRA","ERRINTRA.FRX"
	ENDIF

ENDIF


RELEASE WINDOW DISPLAY

RETURN


*************
PROCEDURE CHK
*************
PUSH KEY CLEAR
IF SELEZIONE='=>'
   REPLACE SELEZIONE WITH ' '
ELSE
   REPLACE SELEZIONE WITH '=>'
ENDIF
POP KEY
KEYBOARD "{RIGHTARROW}+{LEFTARROW}"
RETURN


****************
FUNCTION VEDIART
****************
PARA FG

SELE=SELECT()

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(FG) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF !EOF()
   IF EMPTY(ART_CLDOG)
      =CREACURSORERRORI(V_CODCLI,"Manca la classe doganale dell'articolo : "+FG+"forzo la classe : "+V_CLDOG,V_RIFER)     
 	  RET=V_CLDOG
   ELSE
      RET=ART_CLDOG
   ENDIF

   SELECT cur_articoli
   IF ART_PESOUM = 0
      =CREACURSORERRORI(V_CODCLI,"Il peso dell'articolo "+FG+"è uguale a ZERO ",V_RIFER)     
      SELECT cur_articoli
      V_PESO = 0
   ELSE
      SELECT cur_articoli
      V_PESO = ART_PESOUM
   ENDIF
ELSE
   RET=V_CLDOG
   =CREACURSORERRORI(V_CODCLI,"Manca la classe doganale dell'articolo : "+FG+"forzo la classe : "+V_CLDOG,V_RIFER)     
ENDIF

SELECT U_FAT_DD

RETURN(RET)

*************************
FUNCTION CREACURSORERRORI			&& CREAZIONE CURSORE ERRORI RISCONTRATI
*************************
PARA _CODFOR,_MESSAGGIO,_RIFER

ESISTONO_ERRORI = .T.



SELECT W_ERR
APPEND BLANK
REPLACE W_CODFOR  WITH _CODFOR
REPLACE W_DESERR  WITH ALLTRIM(_MESSAGGIO) + "  " + _RIFER



RETURN

