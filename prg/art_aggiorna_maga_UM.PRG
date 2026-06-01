*****************************************************************************
* PROCEDURA PER AGGIORNARE UM/QTA/VALORE DA KG A T							*
*****************************************************************************
*!*	-          01.002.0004              Colla 
*!*	-          01.002.0003              Colla 
*!*	-          01.002.0005              Colla 
*!*	-          01.004.0001              Sali per ignifugo 

x_cond = "ART_CODPRI in ('01.002.0004','01.002.0003','01.002.0005','01.004.0001')"
cSql   = "select ART_CODPRI,ART_UNIMIS,ART_UMMAGA from U_ART_PR where " + x_cond 
IF !ExecCommand(cSql,"TMP_ART_PR")
   return(.f.)
ENDIF
SELECT TMP_ART_PR
GO TOP
IF EOF()
	MESSAGEBOX("Nessun articolo trovato per i codici:" + REPLICATE(CHR(13),2) + ;
		"'01.002.0004','01.002.0003','01.002.0005','01.004.0001'" + REPLICATE(CHR(13),2) + ;
		"Operazione abbandonata",64,"Attenzione")
	RETURN .F.
ELSE
	_ALREDY_TONS = .F.
	SCAN
		IF ALLTRIM(ART_UNIMIS) == 'T' OR ALLTRIM(ART_UMMAGA) == 'T'
			MESSAGEBOX("Almeno un articolo per i codici:" + REPLICATE(CHR(13),2) + ;
				"'01.002.0004','01.002.0003','01.002.0005','01.004.0001'" + REPLICATE(CHR(13),2) + ;
				"avente già Unità di Misura Acq./Mag. TONNELLATE." + REPLICATE(CHR(13),2) + ;
				"Operazione abbandonata",64,"Attenzione")
			RETURN .F.
		ENDIF
	ENDSCAN
ENDIF


RIT = MESSAGEBOX("Procedo con l'aggiornamento dell'Unità di Misura in TONNELLATE con il ricalcolo di ORF / BFO / MAG / MOV / DI.BA / PROD. per i codici:" + REPLICATE(CHR(13),2) + ;
		"'01.002.0004','01.002.0003','01.002.0005','01.004.0001'  ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


*!*	**##################################################################################################################### U_ORF_DD ##########################
WAIT windows "Aggiornamento ordini fornitori ........." nowait

PUBLIC V_CONTA
V_CONTA = 0


*!*	___NUMORD = '000944'
*!*	x_cond = "ORD_NUMORD = '" + ALLTRIM(___NUMORD) + "'"
*!*	cSql="select * from U_ORF_TT where "  + x_cond + " order by ORD_NUMORD" 

cSql="select * from U_ORF_TT where 0=0 order by ord_numord" 


IF !ExecCommand(cSql,"CkU_ORF_TT")
   RETURN .F.
ENDIF 

SELECT CkU_ORF_TT
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

		SCATTER MEMVAR MEMO
		
*!*			IF M.ORD_CHIUSO					&& non tratta gli ordini chiusi
*!*				SELECT CKU_ORF_TT
*!*				SKIP +1
*!*				LOOP 
*!*			ENDIF 
		
		WAIT WINDOWS "Ordine a fornitore in elaborazione : " +m.ord_numord nowait
		___TAGGANCIO = TAGGANCIO

		x_cond = "DAGGANCIO = '" + ALLTRIM(___TAGGANCIO) + "'"

		cSql="select * from U_ORF_DD where "  + x_cond + " order by ORD_CODART" 
		IF !ExecRW(cSql,"U_ORF_DD","R")
		   return(.f.)
		ENDIF
		SELECT U_ORF_DD
		GO TOP

		DO WHILE .T.
		   
		   IF EOF()
		      EXIT
		   ENDIF
		   
		   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***" 			&& commenti 
		   	  SELECT U_ORF_DD
		   	  SKIP +1
		   	  LOOP
		   ENDIF
		 
		   SCATTER MEMVAR MEMO

		*!*	-          01.002.0004              Colla 
		*!*	-          01.002.0003              Colla 
		*!*	-          01.002.0005              Colla 
		*!*	-          01.004.0001              Sali per ignifugo 

			DO CASE
		    	CASE ORD_CODART = '01.002.0004'
		    	CASE ORD_CODART = '01.002.0003'
		    	CASE ORD_CODART = '01.002.0005'
		    	CASE ORD_CODART = '01.004.0001'
				
				OTHERWISE  
		    	
		    	  SELECT U_ORF_DD
			   	  SKIP +1
		   		  LOOP
		 
		 	ENDCASE
		 	
*!*			 	IF ALLTRIM(ORD_UM) = 'KG'
*!*			 	ELSE
*!*			    	  SELECT U_ORF_DD
*!*				   	  SKIP +1
*!*			   		  LOOP 
*!*			 	ENDIF
		 	
		 
		  
		   	SELECT U_ORF_DD
		   	REPLACE ORD_UM WITH 'T'	&& TONNELLATE
		   	REPLACE ORD_QTAORD	WITH ORD_QTAORD / 1000
		   	REPLACE ORD_QTAEV	WITH ORD_QTAEV  / 1000
		   	REPLACE ORD_PREZZO   WITH ORD_PREZZO * 1000

			VPRE         = ORD_PREZZO
			VPRE         = VPRE-ROUND((VPRE*ORD_SC1/100),6)
			VPRE         = VPRE-ROUND((VPRE*ORD_SC2/100),6)
			VPRE         = VPRE-ROUND((VPRE*ORD_SC3/100),6)
			*VPRE         = VPRE-ROUND((VPRE*ORD_SC4/100),6)  && ERASMO - 01/12/2011
			*VPRE         = VPRE-ROUND((VPRE*ORD_SC5/100),6)  && ERASMO - 01/12/2011
			M.ORD_PRZNET = VPRE
			M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
			M.ORD_VALORE = ROUND((M.ORD_PRZNET*ORD_QTAORD),2)

		   	REPLACE ORD_PRZNET	WITH M.ORD_PRZNET
		   	REPLACE ORD_VALORE	WITH M.ORD_VALORE

		   V_CONTA = V_CONTA + 1
		   WAIT WINDOWS "RECORDS AGGIORNATI : "+STR(V_CONTA,10,0) NOWAIT
		   
		   SELECT U_ORF_DD
		   SKIP +1
		   
		ENDDO

		IF !ExecRW(cSql,"U_ORF_DD","W")
		   return(.f.)
		ENDIF

		** RICALCOLA TOTALE DOCUMENTO
		SELECT CkU_ORF_TT
	    =CALCdocge1(___TAGGANCIO,"orfhookd","U_ORF_DD","U_ORF_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE

	
	
	
	
	SELECT CkU_ORF_TT	
	SKIP +1


ENDDO WHILE .T.


*!*	**##################################################################################################################### U_BFO_DD ##########################
WAIT windows "Aggiornamento bolle di carico da fornitori ........." nowait

PUBLIC V_CONTA
V_CONTA = 0


*!*	___NUMORD = '000447'
*!*	x_cond = "ORD_NUMORD = '" + ALLTRIM(___NUMORD) + "'"
*!*	cSql="select * from U_BFO_TT where "  + x_cond + " order by ORD_NUMORD" 

cSql="select * from U_BFO_TT where 0=0 order by ord_numord" 

IF !ExecCommand(cSql,"CkU_BFO_TT")
   RETURN .F.
ENDIF 

SELECT CkU_BFO_TT
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

		SCATTER MEMVAR MEMO
		
*!*			IF M.ORD_CHIUSO					&& non tratta i documenti chiusi ??????????????
*!*				SELECT CKU_BFO_TT
*!*				SKIP +1
*!*				LOOP 
*!*			ENDIF 
		
		WAIT WINDOWS "Bolla di carico fornitore in elaborazione : " +m.ord_numord nowait
		___TAGGANCIO = TAGGANCIO

		x_cond = "DAGGANCIO = '" + ALLTRIM(___TAGGANCIO) + "'"

		cSql="select * from U_BFO_DD where "  + x_cond + " order by ORD_CODART" 
		IF !ExecRW(cSql,"U_BFO_DD","R")
		   return(.f.)
		ENDIF
		SELECT U_BFO_DD
		GO TOP

		DO WHILE .T.
		   
		   IF EOF()
		      EXIT
		   ENDIF
		   
		   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***" 			&& commenti 
		   	  SELECT U_BFO_DD
		   	  SKIP +1
		   	  LOOP
		   ENDIF
		 
		   SCATTER MEMVAR MEMO

		*!*	-          01.002.0004              Colla 
		*!*	-          01.002.0003              Colla 
		*!*	-          01.002.0005              Colla 
		*!*	-          01.004.0001              Sali per ignifugo 

			DO CASE
		    	CASE ORD_CODART = '01.002.0004'
		    	CASE ORD_CODART = '01.002.0003'
		    	CASE ORD_CODART = '01.002.0005'
		    	CASE ORD_CODART = '01.004.0001'
				
				OTHERWISE  
		    	
		    	  SELECT U_BFO_DD
			   	  SKIP +1
		   		  LOOP
		 
		 	ENDCASE
		 	
*!*			 	IF ALLTRIM(ORD_UM) = 'KG'
*!*			 	ELSE
*!*			    	  SELECT U_BFO_DD
*!*				   	  SKIP +1
*!*			   		  LOOP 
*!*			 	ENDIF
		  
		   	SELECT U_BFO_DD
		   	REPLACE ORD_UM WITH 'T'	&& TONNELLATE
		   	REPLACE ORD_QTAORD	WITH ORD_QTAORD / 1000
		   	REPLACE ORD_QTAEV	WITH ORD_QTAEV  / 1000
		   	REPLACE ORD_PREZZO   WITH ORD_PREZZO * 1000

			VPRE         = ORD_PREZZO
			VPRE         = VPRE-ROUND((VPRE*ORD_SC1/100),6)
			VPRE         = VPRE-ROUND((VPRE*ORD_SC2/100),6)
			VPRE         = VPRE-ROUND((VPRE*ORD_SC3/100),6)
			*VPRE         = VPRE-ROUND((VPRE*ORD_SC4/100),6)  && ERASMO - 01/12/2011
			*VPRE         = VPRE-ROUND((VPRE*ORD_SC5/100),6)  && ERASMO - 01/12/2011
			M.ORD_PRZNET = VPRE
			M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
			M.ORD_VALORE = ROUND((M.ORD_PRZNET*ORD_QTAORD),2)

		   	REPLACE ORD_PRZNET	WITH M.ORD_PRZNET
		   	REPLACE ORD_VALORE	WITH M.ORD_VALORE

		   V_CONTA = V_CONTA + 1
		   WAIT WINDOWS "RECORDS AGGIORNATI : "+STR(V_CONTA,10,0) NOWAIT
		   
		   SELECT U_BFO_DD
		   SKIP +1
		   
		ENDDO

		IF !ExecRW(cSql,"U_BFO_DD","W")
		   return(.f.)
		ENDIF

		** RICALCOLA TOTALE DOCUMENTO
		SELECT CkU_BFO_TT
	    =CALCdocge1a(___TAGGANCIO,"bfohookd","U_BFO_DD","U_BFO_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE

	
	
	
	
	SELECT CkU_BFO_TT	
	SKIP +1


ENDDO WHILE .T.




*!*	**##################################################################################################################### U_MAG_GG ##########################
 
WAIT WINDOWS "Giacenze di magazzino in elaborazione "  nowait

PUBLIC V_CONTA
V_CONTA = 0

x_cond = "MAG_ANAART in ('01.002.0004','01.002.0003','01.002.0005','01.004.0001')"
cSql   = "select * from U_MAG_GG where " + x_cond 
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   

   SCATTER MEMVAR MEMO

*!*	-          01.002.0004              Colla 
*!*	-          01.002.0003              Colla 
*!*	-          01.002.0005              Colla 
*!*	-          01.004.0001              Sali per ignifugo 


	DO CASE
    	CASE MAG_ANAART = '01.002.0004'
    	CASE MAG_ANAART = '01.002.0003'
    	CASE MAG_ANAART = '01.002.0005'
    	CASE MAG_ANAART = '01.004.0001'
		
		OTHERWISE  
    	
    	  SELECT U_MAG_GG
	   	  SKIP +1
   		  LOOP
 
 	ENDCASE
 	

  
   	SELECT U_MAG_GG
   	REPLACE MAG_GIACEN	WITH MAG_GIACEN / 1000
   	REPLACE MAG_QTAIMP	WITH MAG_QTAIMP / 1000
*!*	   	REPLACE MAG_QTAMC	WITH MAG_QTAMC  / 1000
*!*	   	REPLACE MAG_QTAKG	WITH MAG_QTAKG  / 1000
*!*	   	REPLACE MAG_QTAMQ	WITH MAG_QTAMQ  / 1000
*!*	   	REPLACE MAG_QTAML	WITH MAG_QTAML  / 1000
	REPLACE MAG_PRZCON	WITH MAG_PRZCON * 1000
	REPLACE MAG_PRZUFF	WITH MAG_PRZUFF * 1000
   	
   	
   	
 
   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS AGGIORNATI : "+STR(V_CONTA,10,0) NOWAIT
   
   SELECT U_MAG_GG
   SKIP +1
   
ENDDO

IF !ExecRW(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF



*!*	**##################################################################################################################### U_MAG_MO ##########################

WAIT WINDOWS "Movimenti di magazzino in elaborazione "  nowait

PUBLIC V_CONTA
V_CONTA = 0


x_cond = "MOV_ANAART in ('01.002.0004','01.002.0003','01.002.0005','01.004.0001')"
cSql   = "select * from U_MAG_MO where " + x_cond
IF !ExecRW(cSql,"U_MAG_MO","R")
   return(.f.)
ENDIF
SELECT U_MAG_MO
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   

   SCATTER MEMVAR MEMO

*!*	-          01.002.0004              Colla 
*!*	-          01.002.0003              Colla 
*!*	-          01.002.0005              Colla 
*!*	-          01.004.0001              Sali per ignifugo 


	DO CASE
    	CASE MOV_ANAART = '01.002.0004'
    	CASE MOV_ANAART = '01.002.0003'
    	CASE MOV_ANAART = '01.002.0005'
    	CASE MOV_ANAART = '01.004.0001'
		
		OTHERWISE  
    	
    	  SELECT U_MAG_MO
	   	  SKIP +1
   		  LOOP
 
 	ENDCASE
 	

  
   	SELECT U_MAG_MO
   	REPLACE MOV_QTAMOV	WITH MOV_QTAMOV / 1000
   	REPLACE MOV_UM 		WITH "T"
   	REPLACE MOV_PREACQ 	WITH MOV_PREACQ * 1000
   	REPLACE MOV_PREVEN 	WITH MOV_PREVEN * 1000
   	REPLACE MOV_VALVEN  WITH MOV_QTAMOV * MOV_PREVEN
    REPLACE MOV_VALACQ  WITH MOV_QTAMOV * MOV_PREACQ
   	
*!*	   	REPLACE MOV_QTAMC	WITH MOV_QTAMC  / 1000
*!*	   	REPLACE MOV_QTAKG	WITH MOV_QTAKG  / 1000
*!*	   	REPLACE MOV_QTAMQ	WITH MOV_QTAMQ  / 1000
*!*	   	REPLACE MOV_QTAML	WITH MOV_QTAML  / 1000
   	
   	
   	
 
   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS AGGIORNATI : "+STR(V_CONTA,10,0) NOWAIT
   
   SELECT U_MAG_MO
   SKIP +1
   
ENDDO

IF !ExecRW(cSql,"U_MAG_MO","W")
   return(.f.)
ENDIF



*!*	#########################################################  TESTATE DISTINTA BASE ################################################################
W_CTRLETTI = 0
W_CTRAGGIO = 0

WAIT WINDOWS "ATTENDERE PREGO, STO CARICANDO E AGGIORNANDO LE TESTATE DELLE DISTINTE BASI" NOWAIT

x_cond = "DIT_GRUPPO in ('01.002.0004','01.002.0003','01.002.0005','01.004.0001')"
cSql   = "select * from U_DIS_TT where " + x_cond 
IF !ExecRW(cSql,'U_DIS_TT','R')
   return(.f.)
ENDIF
SELECT U_DIS_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF


	
		DO CASE
	    	CASE DIT_GRUPPO = '01.002.0004'
	    	CASE DIT_GRUPPO = '01.002.0003'
	    	CASE DIT_GRUPPO = '01.002.0005'
	    	CASE DIT_GRUPPO = '01.004.0001'
			
			OTHERWISE  
	    	
	    	  SELECT U_DIS_TT
		   	  SKIP +1
	   		  LOOP
	 
	 	ENDCASE
	 	


*!*		 	IF ALLTRIM(DIT_UM) = 'KG'
*!*		 	ELSE
*!*		    	  SELECT U_DIS_TT
*!*			   	  SKIP +1
*!*		   		  LOOP 
*!*		 	ENDIF
	 	
	 

        SELECT U_DIS_TT
      	REPLACE DIT_UM  WITH "T"		&& UNITA' DI MISURA DI VENDITA
      	
      	
     	W_CTRAGGIO = W_CTRAGGIO + 1

	   	W_CTRLETTI = W_CTRLETTI + 1

   SKIP +1

ENDDO

WAIT WINDOWS "ATTENDERE PREGO, AGGIORNAMENTO TESTATE DISTINTA BASE IN CORSO" NOWAIT
IF !ExecRW(cSql,'U_DIS_TT','W')
   return(.f.)
ENDIF




*!*	#########################################################  DETTAGLI DISTINTA BASE ################################################################
W_CTRLETTI = 0
W_CTRAGGIO = 0

WAIT WINDOWS "ATTENDERE PREGO, STO CARICANDO E AGGIORNANDO I DETTAGLI DELLE DISTINTE BASI" NOWAIT


x_cond = "DIS_CODART in ('01.002.0004','01.002.0003','01.002.0005','01.004.0001')"
cSql   = "select * from U_DIS_DD where " + x_cond 
IF !ExecRW(cSql,'U_DIS_DD','R')
   return(.f.)
ENDIF
SELECT U_DIS_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

		DO CASE
	    	CASE DIS_CODART = '01.002.0004'
	    	CASE DIS_CODART = '01.002.0003'
	    	CASE DIS_CODART = '01.002.0005'
	    	CASE DIS_CODART = '01.004.0001'
			
			OTHERWISE  
	    	
	    	  SELECT U_DIS_DD
		   	  SKIP +1
	   		  LOOP
	 
	 	ENDCASE
	 	


*!*		 	IF ALLTRIM(DIS_UM) = 'KG'
*!*		 	ELSE
*!*		    	  SELECT U_DIS_DD
*!*			   	  SKIP +1
*!*		   		  LOOP 
*!*		 	ENDIF
 
        SELECT U_DIS_DD
      	REPLACE DIS_UM  WITH "T"		&& UNITA' DI MISURA DI VENDITA
     	REPLACE DIS_QTA WITH DIS_QTA / 1000
     	
     	
     	W_CTRAGGIO = W_CTRAGGIO + 1

	   	W_CTRLETTI = W_CTRLETTI + 1

   SKIP +1

ENDDO

WAIT WINDOWS "ATTENDERE PREGO, AGGIORNAMENTO DETTAGLI DISTINTA BASE IN CORSO" NOWAIT
IF !ExecRW(cSql,'U_DIS_DD','W')
   return(.f.)
ENDIF

*!*	=MESSAGEBOX("Agiornamento distinte basi terminato correttamente"+CHR(13)+ ;
*!*	            "Totale records letti : " + ALLTRIM(STR(W_CTRLETTI,10,0)) + ;
*!*	            " di cui aggiornati : " + ALLTRIM(STR(W_CTRAGGIO,10,0)),64,"*** ATTENZIONE ***")
            



WAIT WINDOWS "Anagrafica articoli in elaborazione" nowait


PUBLIC V_CONTA
V_CONTA = 0

x_cond = "ART_CODPRI in ('01.002.0004','01.002.0003','01.002.0005','01.004.0001')"
cSql   = "select * from U_ART_PR where " + x_cond 
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   

   SCATTER MEMVAR MEMO

*!*	-          01.002.0004              Colla 
*!*	-          01.002.0003              Colla 
*!*	-          01.002.0005              Colla 
*!*	-          01.004.0001              Sali per ignifugo 

	DO CASE
    	CASE ART_CODPRI = '01.002.0004'
    	CASE ART_CODPRI = '01.002.0003'
    	CASE ART_CODPRI = '01.002.0005'
    	CASE ART_CODPRI = '01.004.0001'
		
		OTHERWISE  
    	
    	  SELECT U_ART_PR
	   	  SKIP +1
   		  LOOP
 
 	ENDCASE
 	
 
  
   	SELECT U_ART_PR
   	REPLACE ART_UNIMIS WITH 'T'	&& TONNELLATE
   	REPLACE ART_UMMAGA WITH 'T'	&& TONNELLATE
   	
   	REPLACE ART_PRZCOS WITH ART_PRZCOS * 1000 
   	
   	REPLACE ART_PRZCO1 WITH ART_PRZCO1 * 1000
   	REPLACE ART_PRZCO2 WITH ART_PRZCO2 * 1000
   	REPLACE ART_PRZCO3 WITH ART_PRZCO3 * 1000
   	REPLACE ART_PRZCO4 WITH ART_PRZCO4 * 1000
   	REPLACE ART_PRZCO5 WITH ART_PRZCO5 * 1000
   	


   V_CONTA = V_CONTA + 1
   WAIT WINDOWS "RECORDS AGGIORNATI : "+STR(V_CONTA,10,0) NOWAIT
   
   SELECT U_ART_PR
   SKIP +1
   
ENDDO

IF !ExecRW(cSql,"U_ART_PR","W")
   return(.f.)
ENDIF


*** CORREZIONE TABELLA DI PRODUZIONE
WAIT WINDOWS "CORREZIONE TABELLA DI PRODUZIONE..." NOWAIT

cSql = "UPDATE PRODUZIONE SET UM = (SELECT ART_UMMAGA FROM U_ART_PR WHERE ART_CODPRI = PRODUZIONE.COMP) WHERE PRODUZIONE.PARENT <> ''"
IF !ExecCommand(cSql,'UPD_PRODUZIONE')
   return(.f.)
ENDIF

cSql = "UPDATE PRODUZIONE SET QTA=QTA/1000, DIS_QTA=DIS_QTA/1000 WHERE COMP IN ('01.002.0004','01.002.0003','01.002.0005','01.004.0001') AND PRODUZIONE.PARENT <> ''"
IF !ExecCommand(cSql,'UPD_PRODUZIONE')
   return(.f.)
ENDIF


=MESSAGEBOX("Operazione terminata correttamente ",62,"ATTENZIONE")

RETURN