

*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA PER LA GESTIONE DELLA PRODUZONE                         ***
					***                       E PER IL CALCOLO FABBISOGNI			                           ***
					**********************************************************************************************

*!*	##############################################################################################################


***************************************************************************** 
FUNCTION CERCA_IL_NUMERO_DI_PANNELLI_PER_PACCO
***************************************************************************** 
* REGOLE PER DETERMINARE IL NUMERO DI PANNELLI PER PACCO :
* ACCEDERE AL PARAMETRO SHT CON CHIAVE :
* PRIMO ACCESSO 	:SHT+altezza pacco+spessore prodotto
* SECONDO ACCESSO 	:SHT+tipo prodotto+spessore prodotto
* TERZO ACCESSO 	:SHT+altezza massima pannello+spessore prodotto
PARAMETERS _par_codart__,_par_altezza_pacco__,_par_spesso__,_par_altezz__


_W_QTANR__ = 0 

v_seek	 = 'SHT'+ALLTRIM(STR(_par_altezza_pacco__,4,0))+ALLTRIM(STR(_par_spesso__,2,0))		&& altezza pacco + spessore
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'ChR_PARA')
   SELECT ChR_PARA
   _W_QTANR__ =VAL(ALLTRIM(LIBERA))
ELSE
   _W_QTANR__ =0
ENDIF

v_seek	 = 'SHT'+SUBSTR(_par_codart__,1,2)+ALLTRIM(STR(_par_spesso__,2,0))					&& tipo prodotto + spessore
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'ChR_PARA')
   SELECT ChR_PARA
   _W_QTANR__ =VAL(ALLTRIM(LIBERA))
ENDIF


v_seek	 = 'SHT'+ALLTRIM(STR(_par_altezz__,4,0))+ALLTRIM(STR(_par_spesso__,2,0))			&& altezza massima pannello + spessore
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'ChR_PARA')
   SELECT ChR_PARA
   _W_QTANR__ =VAL(ALLTRIM(LIBERA))
ENDIF



RETURN(_W_QTANR__)


***************************************************************************** 
FUNCTION DEFINISCE_FABBISOGNI
***************************************************************************** 

**=> ERASMO - INIZIO 17/09/2007
*** NON CHIEDERMI PERCHE' MA EVIDENTEMENTE IL CREATE CURSOR, ESEGUITO SE IL CURSORE GIA' ESISTE,
*** DISABILITA GLI EVENTI SULLE GRIGLIE CHE HANNO COME CONTROLSOURCE TALE CURSORE
IF USED("CURSORE_FABBISOGNI")
   SELECT CURSORE_FABBISOGNI
   ZAP
   RETURN
ENDIF
**=> ERASMO - FINE 17/09/2007

CREATE CURSOR CURSORE_FABBISOGNI (FAB_MAGAZZ  C(06),  	;
                        FAB_CODART  C(30),  	;
                        FAB_DESART  C(45),  	;
                        FAB_UMVEND  C(03),  	;
                        FAB_UMACQU  C(03),  	;
                        FAB_GIACEN  N(11,3),  	;                        
                        FAB_QTTORC  N(11,3),  	;    
                        FAB_QTTORF  N(11,3),  	;   
                        FAB_QT_OCLI_01A  N(11,3),FAB_QT_OCLI_02A  N(11,3),FAB_QT_OCLI_03A  N(11,3),FAB_QT_OCLI_04A  N(11,3),FAB_QT_OCLI_05A  N(11,3),FAB_QT_OCLI_06A  N(11,3), FAB_QT_OCLI_07A  N(11,3),FAB_QT_OCLI_08A  N(11,3),FAB_QT_OCLI_09A  N(11,3),FAB_QT_OCLI_10A  N(11,3),FAB_QT_OCLI_11A  N(11,3),FAB_QT_OCLI_12A  N(11,3),  ;
                        FAB_QT_OCLI_01B  N(11,3),FAB_QT_OCLI_02B  N(11,3),FAB_QT_OCLI_03B  N(11,3),FAB_QT_OCLI_04B  N(11,3),FAB_QT_OCLI_05B  N(11,3),FAB_QT_OCLI_06B  N(11,3), FAB_QT_OCLI_07B  N(11,3),FAB_QT_OCLI_08B  N(11,3),FAB_QT_OCLI_09B  N(11,3),FAB_QT_OCLI_10B  N(11,3),FAB_QT_OCLI_11B  N(11,3),FAB_QT_OCLI_12B  N(11,3),  ;
                        FAB_QT_OFOR_01A  N(11,3),FAB_QT_OFOR_02A  N(11,3),FAB_QT_OFOR_03A  N(11,3),FAB_QT_OFOR_04A  N(11,3),FAB_QT_OFOR_05A  N(11,3),FAB_QT_OFOR_06A  N(11,3), FAB_QT_OFOR_07A  N(11,3),FAB_QT_OFOR_08A  N(11,3),FAB_QT_OFOR_09A  N(11,3),FAB_QT_OFOR_10A  N(11,3),FAB_QT_OFOR_11A  N(11,3),FAB_QT_OFOR_12A  N(11,3),  ;
                        FAB_QT_OFOR_01B  N(11,3),FAB_QT_OFOR_02B  N(11,3),FAB_QT_OFOR_03B  N(11,3),FAB_QT_OFOR_04B  N(11,3),FAB_QT_OFOR_05B  N(11,3),FAB_QT_OFOR_06B  N(11,3), FAB_QT_OFOR_07B  N(11,3),FAB_QT_OFOR_08B  N(11,3),FAB_QT_OFOR_09B  N(11,3),FAB_QT_OFOR_10B  N(11,3),FAB_QT_OFOR_11B  N(11,3),FAB_QT_OFOR_12B  N(11,3),  ;
                        FAB_DIS_TEO_01A  N(11,3),FAB_DIS_TEO_02A  N(11,3),FAB_DIS_TEO_03A  N(11,3),FAB_DIS_TEO_04A  N(11,3),FAB_DIS_TEO_05A  N(11,3),FAB_DIS_TEO_06A  N(11,3), FAB_DIS_TEO_07A  N(11,3),FAB_DIS_TEO_08A  N(11,3),FAB_DIS_TEO_09A  N(11,3),FAB_DIS_TEO_10A  N(11,3),FAB_DIS_TEO_11A  N(11,3),FAB_DIS_TEO_12A  N(11,3),  ;
                        FAB_DIS_TEO_01B  N(11,3),FAB_DIS_TEO_02B  N(11,3),FAB_DIS_TEO_03B  N(11,3),FAB_DIS_TEO_04B  N(11,3),FAB_DIS_TEO_05B  N(11,3),FAB_DIS_TEO_06B  N(11,3), FAB_DIS_TEO_07B  N(11,3),FAB_DIS_TEO_08B  N(11,3),FAB_DIS_TEO_09B  N(11,3),FAB_DIS_TEO_10B  N(11,3),FAB_DIS_TEO_11B  N(11,3),FAB_DIS_TEO_12B  N(11,3),  ;
                        FAB_DIS_EFF_01A  N(11,3),FAB_DIS_EFF_02A  N(11,3),FAB_DIS_EFF_03A  N(11,3),FAB_DIS_EFF_04A  N(11,3),FAB_DIS_EFF_05A  N(11,3),FAB_DIS_EFF_06A  N(11,3), FAB_DIS_EFF_07A  N(11,3),FAB_DIS_EFF_08A  N(11,3),FAB_DIS_EFF_09A  N(11,3),FAB_DIS_EFF_10A  N(11,3),FAB_DIS_EFF_11A  N(11,3),FAB_DIS_EFF_12A  N(11,3),  ;
                        FAB_DIS_EFF_01B  N(11,3),FAB_DIS_EFF_02B  N(11,3),FAB_DIS_EFF_03B  N(11,3),FAB_DIS_EFF_04B  N(11,3),FAB_DIS_EFF_05B  N(11,3),FAB_DIS_EFF_06B  N(11,3), FAB_DIS_EFF_07B  N(11,3),FAB_DIS_EFF_08B  N(11,3),FAB_DIS_EFF_09B  N(11,3),FAB_DIS_EFF_10B  N(11,3),FAB_DIS_EFF_11B  N(11,3),FAB_DIS_EFF_12B  N(11,3),  ;
                        FAB_DA_RIOR_01A  N(11,3),FAB_DA_RIOR_02A  N(11,3),FAB_DA_RIOR_03A  N(11,3),FAB_DA_RIOR_04A  N(11,3),FAB_DA_RIOR_05A  N(11,3),FAB_DA_RIOR_06A  N(11,3), FAB_DA_RIOR_07A  N(11,3),FAB_DA_RIOR_08A  N(11,3),FAB_DA_RIOR_09A  N(11,3),FAB_DA_RIOR_10A  N(11,3),FAB_DA_RIOR_11A  N(11,3),FAB_DA_RIOR_12A  N(11,3),  ;
                        FAB_DA_RIOR_01B  N(11,3),FAB_DA_RIOR_02B  N(11,3),FAB_DA_RIOR_03B  N(11,3),FAB_DA_RIOR_04B  N(11,3),FAB_DA_RIOR_05B  N(11,3),FAB_DA_RIOR_06B  N(11,3), FAB_DA_RIOR_07B  N(11,3),FAB_DA_RIOR_08B  N(11,3),FAB_DA_RIOR_09B  N(11,3),FAB_DA_RIOR_10B  N(11,3),FAB_DA_RIOR_11B  N(11,3),FAB_DA_RIOR_12B  N(11,3),  ;
                        FAB_VAL_COS_01A  N(17,3),FAB_VAL_COS_02A  N(17,3),FAB_VAL_COS_03A  N(17,3),FAB_VAL_COS_04A  N(17,3),FAB_VAL_COS_05A  N(17,3),FAB_VAL_COS_06A  N(17,3), FAB_VAL_COS_07A  N(17,3),FAB_VAL_COS_08A  N(17,3),FAB_VAL_COS_09A  N(17,3),FAB_VAL_COS_10A  N(17,3),FAB_VAL_COS_11A  N(17,3),FAB_VAL_COS_12A  N(17,3),  ;
                        FAB_VAL_COS_01B  N(17,3),FAB_VAL_COS_02B  N(17,3),FAB_VAL_COS_03B  N(17,3),FAB_VAL_COS_04B  N(17,3),FAB_VAL_COS_05B  N(17,3),FAB_VAL_COS_06B  N(17,3), FAB_VAL_COS_07B  N(17,3),FAB_VAL_COS_08B  N(17,3),FAB_VAL_COS_09B  N(17,3),FAB_VAL_COS_10B  N(17,3),FAB_VAL_COS_11B  N(17,3),FAB_VAL_COS_12B  N(17,3),  ;
                        FAB_VAL_RIC_01A  N(17,3),FAB_VAL_RIC_02A  N(17,3),FAB_VAL_RIC_03A  N(17,3),FAB_VAL_RIC_04A  N(17,3),FAB_VAL_RIC_05A  N(17,3),FAB_VAL_RIC_06A  N(17,3), FAB_VAL_RIC_07A  N(17,3),FAB_VAL_RIC_08A  N(17,3),FAB_VAL_RIC_09A  N(17,3),FAB_VAL_RIC_10A  N(17,3),FAB_VAL_RIC_11A  N(17,3),FAB_VAL_RIC_12A  N(17,3),  ;
                        FAB_VAL_RIC_01B  N(17,3),FAB_VAL_RIC_02B  N(17,3),FAB_VAL_RIC_03B  N(17,3),FAB_VAL_RIC_04B  N(17,3),FAB_VAL_RIC_05B  N(17,3),FAB_VAL_RIC_06B  N(17,3), FAB_VAL_RIC_07B  N(17,3),FAB_VAL_RIC_08B  N(17,3),FAB_VAL_RIC_09B  N(17,3),FAB_VAL_RIC_10B  N(17,3),FAB_VAL_RIC_11B  N(17,3),FAB_VAL_RIC_12B  N(17,3),  ;
                        FAB_SYSORF C(10),  	;
                        FAB_SYSORD C(10),  	;
						FAB_NOTE M)
INDEX ON FAB_CODART TAG I_CODART ADDITIVE

RETURN



***************************************************************************** 
FUNCTION IDENTIFICA_ORDINI_SCADENTI_NEL_MESE
***************************************************************************** 
*  TIPO = ORF : ORDINI A FORNITORE
*  TIPO = ORD : ORDINI DA CLIENTE
*
*  RESTITUISCE ___sysorf CONTENETE IL SYS CHE IENTIFICA L'ORDINE A FORNITORE SCADENTE NEL MESE   
*  RESTITUISCE ___sysord CONTENETE IL SYS CHE IENTIFICA L'ORDINE DA CLIENTE SCADENTE NEL MESE   
*

PARAMETERS _tipo,_mese__,_anno__


IF _tipo = "ORF"


   	IF  _anno__ = pub_anno
        
		IF _mese__	= "01"
			IF EMPTY(ALLTRIM(___sysorf01A))
				___sysorf01A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf01A 
			RETURN
		ENDIF  
		IF _mese__	= "02"
			IF EMPTY(ALLTRIM(___sysorf02A))
				___sysorf02A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf02A 
			RETURN
		ENDIF  
		IF _mese__	= "03"
			IF EMPTY(ALLTRIM(___sysorf03A))
				___sysorf03A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf03A 
			RETURN
		ENDIF  
		IF _mese__	= "04"
			IF EMPTY(ALLTRIM(___sysorf04A))
				___sysorf04A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf04A 
			RETURN
		ENDIF  
		IF _mese__	= "05"
			IF EMPTY(ALLTRIM(___sysorf05A))
				___sysorf05A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf05A 
			RETURN
		ENDIF  
		IF _mese__	= "06"
			IF EMPTY(ALLTRIM(___sysorf06A))
				___sysorf06A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf06A 
			RETURN
		ENDIF  
		IF _mese__	= "07"
			IF EMPTY(ALLTRIM(___sysorf07A))
				___sysorf07A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf07A 
			RETURN
		ENDIF  
		IF _mese__	= "08"
			IF EMPTY(ALLTRIM(___sysorf08A))
				___sysorf08A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf08A 
			RETURN
		ENDIF  
		IF _mese__	= "09"
			IF EMPTY(ALLTRIM(___sysorf09A))
				___sysorf09A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf09A 
			RETURN
		ENDIF  
		IF _mese__	= "10"
			IF EMPTY(ALLTRIM(___sysorf10A))
				___sysorf10A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf10A 
			RETURN
		ENDIF  
		IF _mese__	= "11"
			IF EMPTY(ALLTRIM(___sysorf11A))
				___sysorf11A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf11A 
			RETURN
		ENDIF  
		IF _mese__	= "12"
			IF EMPTY(ALLTRIM(___sysorf12A))
				___sysorf12A = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf12A 
			RETURN
		ENDIF  


	ELSE
	

		IF _mese__	= "01"
			IF EMPTY(ALLTRIM(___sysorf01B))
				___sysorf01B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf01B 
			RETURN
		ENDIF  
		IF _mese__	= "02"
			IF EMPTY(ALLTRIM(___sysorf02B))
				___sysorf02B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf02B 
			RETURN
		ENDIF  
		IF _mese__	= "03"
			IF EMPTY(ALLTRIM(___sysorf03B))
				___sysorf03B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf03B 
			RETURN
		ENDIF  
		IF _mese__	= "04"
			IF EMPTY(ALLTRIM(___sysorf04B))
				___sysorf04B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf04B 
			RETURN
		ENDIF  
		IF _mese__	= "05"
			IF EMPTY(ALLTRIM(___sysorf05B))
				___sysorf05B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf05B 
			RETURN
		ENDIF  
		IF _mese__	= "06"
			IF EMPTY(ALLTRIM(___sysorf06B))
				___sysorf06B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf06B 
			RETURN
		ENDIF  
		IF _mese__	= "07"
			IF EMPTY(ALLTRIM(___sysorf07B))
				___sysorf07B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf07B 
			RETURN
		ENDIF  
		IF _mese__	= "08"
			IF EMPTY(ALLTRIM(___sysorf08B))
				___sysorf08B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf08B 
			RETURN
		ENDIF  
		IF _mese__	= "09"
			IF EMPTY(ALLTRIM(___sysorf09B))
				___sysorf09B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf09B 
			RETURN
		ENDIF  
		IF _mese__	= "10"
			IF EMPTY(ALLTRIM(___sysorf10B))
				___sysorf10B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf10B 
			RETURN
		ENDIF  
		IF _mese__	= "11"
			IF EMPTY(ALLTRIM(___sysorf11B))
				___sysorf11B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf11B 
			RETURN
		ENDIF  
		IF _mese__	= "12"
			IF EMPTY(ALLTRIM(___sysorf12B))
				___sysorf12B = SYS(2015)
			ENDIF	
			___sysorf = ___sysorf12B 
			RETURN
		ENDIF  


	ENDIF				
	

ENDIF _tipo = "ORF"




RETURN




***************************************************************************** 
FUNCTION MOSTRA_ORDINI
***************************************************************************** 
parameters _colonna,seleziona_esposizione_colonne_


RELEASE __anno_mese_consegna_dal,__anno_mese_consegna_al 
PUBLIC __anno_mese_consegna_dal,__anno_mese_consegna_al 
__anno_mese_consegna_dal = ""
__anno_mese_consegna_al = ""


DO CASE 

	CASE SUBSTR(_colonna,1,3) = "ORF"
		_cursore_ordini = "PRODOTTI_ORDINATI_A_FORNITORE"




ENDCASE



SELECT &_cursore_ordini
GO top

DO WHILE .NOT.EOF()

	IF DELETED()
		SELECT &_cursore_ordini
		SKIP +1
		LOOP	
	ENDIF
	
	REPLACE SELEZIONE 	WITH '  ' 
	
	IF 	ORD_QTAORD >= ORD_QTAEV
		REPLACE ORD_QTADEV	WITH ORD_QTAORD - ORD_QTAEV
	ELSE
		REPLACE ORD_QTADEV	WITH 0	
	ENDIF
	


	SELECT &_cursore_ordini
	SKIP +1
	
ENDDO



SELECT &_cursore_ordini
GO TOP


DO CASE

	CASE SUBSTR(_colonna,1,3) = "ORF"     &&   "ORF-COL01" .............

			SELECT CURSORE_FABBISOGNI  
            
            if seleziona_esposizione_colonne_ = 1
	            __anno_mese_consegna_dal = PUB_ANNO + "/" + SUBSTR(_colonna,8,2) + "/01"
	            __anno_mese_consegna_al  = PUB_ANNO + "/" + SUBSTR(_colonna,8,2) + "/31"
			ELSE
	            __anno_mese_consegna_dal = PUB_ANNOS + "/" + SUBSTR(_colonna,8,2) + "/01"
	            __anno_mese_consegna_al  = PUB_ANNOS + "/" + SUBSTR(_colonna,8,2) + "/31"
			ENDIF
						
			SELECT &_cursore_ordini
			SET FILTER TO BETWEEN(ORD_DATCON,__anno_mese_consegna_dal,__anno_mese_consegna_al)
			GO TOP
			IF !EOF()
				DO prg\browseview WITH "PRODOTTI_ORDINATI_A_FORNITORE","Seleziona articoli e quantità da ordinare","ord_datcon:scadenza,W:10;ord_codart:codice articolo,W:16;ord_desart:descrizione articolo,W:52;ord_qtaord:qtà in consegna,W:6;ord_qtaev:qtà già consegata,W:6;ord_qtadev:qtà da consegnare,W:6;",500,960
			ELSE
           	 	PUB_ERRORE=MESSAGEBOX('Ordini non presenti'+CHR(13)+'nel mese selezionato',64,'*** ATTENZIONE ***')
			ENDIF


ENDCASE



SELECT &_cursore_ordini
GO TOP

RETURN

