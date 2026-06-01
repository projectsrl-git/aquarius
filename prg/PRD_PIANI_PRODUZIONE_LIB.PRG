**********************************************************
PROCEDURE LOAD_CURSORI_PIANO
**********************************************************

	DO LOAD_U_PRD_D1 

	DO LOAD_U_PRD_D2 WITH "","CUR_U_PRD_D2"
	
	DO LOAD_U_PRD_D3 WITH "","CUR_U_PRD_D3"
	
	DO LOAD_U_PRD_D4 WITH "","CUR_U_PRD_D4"
	
	DO LOAD_U_PRD_DR WITH "","CUR_U_PRD_DR"
		
	DO LOAD_U_PRD_D5 WITH "","CUR_U_PRD_D5"
	
	DO LOAD_DATE WITH "","CUR_DATE"

* PROCEDURE LOAD_CURSORI_PIANO
**********************************************************


**********************************************************
PROCEDURE LOAD_LIVELLI_PIANO_SPECIFICO
**********************************************************

	LPARAMETERS _PJ_PRGPRD1
	
	DO LOAD_U_PRD_D2 WITH _PJ_PRGPRD1
	
	DO LOAD_U_PRD_D3 WITH _PJ_PRGPRD1
	
	DO LOAD_U_PRD_D4 WITH _PJ_PRGPRD1
	
	DO LOAD_U_PRD_DR WITH _PJ_PRGPRD1	
	
	DO LOAD_U_PRD_D5 WITH _PJ_PRGPRD1

	DO LOAD_DATE WITH _PJ_PRGPRD1

* PROCEDURE LOAD_LIVELLI_PIANO_SPECIFICO
**********************************************************


**********************************************************
PROCEDURE LOAD_U_PRD_D1
**********************************************************


	*** cancella i dati di U_PRD_D1 
	***
	IF USED("U_PRD_D1")
		TABLEREVERT(.T.,"U_PRD_D1")
	ENDIF
		
***	cSql = "select * from U_PRD_D1 ORDER BY PR1_DTFIPR,PR1_HRFIPR"
	cSql = "select * from U_PRD_D1 ORDER BY PR1_NUMPRG DESC,PR1_DATPRG"
	IF !ExecCommand(cSql,"U_PRD_D1")
		return(.f.)
	ENDIF
	
* PROCEDURE LOAD_U_PRD_D1
**********************************************************

**********************************************************
PROCEDURE LOAD_U_PRD_D2
**********************************************************

	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="U_PRD_D2"
	ENDIF
		
	
	cSql = "select * from U_PRD_D2 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF
	
* PROCEDURE LOAD_U_PRD_D2
**********************************************************	

**********************************************************
PROCEDURE LOAD_U_PRD_D3
**********************************************************
	
	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="U_PRD_D3"
	ENDIF
		
		
	cSql = "select * from U_PRD_D3 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2,PJ_PRGPRD3"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF

* PROCEDURE LOAD_U_PRD_D3
**********************************************************	



**********************************************************
PROCEDURE LOAD_U_PRD_DR
**********************************************************
	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="U_PRD_DR"
	ENDIF
		
	cSql = "select * from U_PRD_DR where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2,PJ_PRGPRD3,PJ_PRGPRD4"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF

* PROCEDURE LOAD_U_PRD_DR
**********************************************************	


**********************************************************
PROCEDURE LOAD_U_PRD_D4
**********************************************************
	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="U_PRD_D4"
	ENDIF
		
		
		
	cSql = "select * from U_PRD_D4 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2,PJ_PRGPRD3,PJ_PRGPRD4"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF

* PROCEDURE LOAD_U_PRD_D4
**********************************************************	
	
**********************************************************
PROCEDURE LOAD_U_PRD_D5
**********************************************************
	
	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="U_PRD_D5"
	ENDIF
		
		
	cSql = "select * from U_PRD_D5 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2,PJ_PRGPRD3,PJ_PRGPRD4,PJ_PRGPRD5"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF

* PROCEDURE LOAD_U_PRD_D5
**********************************************************	
	
**********************************************************
PROCEDURE LOAD_DATE
**********************************************************
	
	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="DATE"
	ENDIF
		
	*** VERIFICO LA PRESENZA DI ORDINI DI CUI VARIARE LA DATA DI CONSEGNA
	cSql=""     
			
	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
	
	SELECT 
		PR5_CODCLI,
		PR5_RAGSOC,
		PR5_NUMORD,
		PR5_DATORD,
		PR5_DATCON,
		MAX(PR5_DTCON2) AS PR5_DTCON2 
	FROM U_PRD_D5 
	WHERE 
		PR5_DTCON2>PR5_DATCON
		AND PR5_CODCLI NOT IN (SELECT AZI_CODCLI FROM U_AZI_AN)
		AND PJ_PRGPRD1='<<_PJ_PRGPRD1>>'
	GROUP BY PR5_CODCLI,PR5_RAGSOC,PR5_NUMORD,PR5_DATORD,PR5_DATCON 
	ORDER BY PR5_RAGSOC,PR5_NUMORD,PR5_DATORD
	
	ENDTEXT					&& FINE SCRITTURA QUERY
	
	IF !ExecPreparedCommand(cSql,_ALIAS)
		return(.F.)
	ENDIF	
		

* PROCEDURE LOAD_DATE
**********************************************************	

**********************************************************
PROCEDURE REFRESH_CURSORE_GRIGLIA
**********************************************************

	LPARAMETERS _ALIAS

	LOCAL _CUR_GRIGLIA

	_CUR_GRIGLIA="CUR_"+_ALIAS
	
	SELECT &_CUR_GRIGLIA
	DELETE ALL
	
	SELECT &_ALIAS
	GO TOP
	
	DO WHILE !EOF()
		
		SCATTER MEMVAR
		
		SELECT &_CUR_GRIGLIA
		APPEND BLANK
		GATHER MEMVAR
	
		SELECT  &_ALIAS
		SKIP
	ENDDO
	
	SELECT &_CUR_GRIGLIA
	GO TOP

* PROCEDURE REFRESH_CURSORE_GRIGLIA
**********************************************************

**********************************************************
* Classe CheckBoxPerGrigliaPianiProduzione
**********************************************************
DEFINE CLASS CheckBoxPerGrigliaPianiProduzione AS CheckBox
	
    WIDTH = 18
    AUTOSIZE = .T.
    CAPTION = ""
    NAME = "CheckBoxPerGrigliaPianiProduzione"

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click

		SELECT (this.Parent.Parent.RECORDSOURCE)
		IF RECCOUNT()=0
			RETURN
		ENDIF
	
		SELECT (THIS.Parent.Parent.RecordSource) 
		IF EMPTY(SELEZIONE)
			REPLACE SELEZIONE WITH THIS.Parent.Parent.SimboloSelezione
		ELSE
			REPLACE SELEZIONE WITH SPACE(0)
		ENDIF


		WITH this
			_ALIAS=.Parent.Parent.RecordSourceAlias
			SELECT &_ALIAS
			_RECNO=ALLTRIM(STR(RECNO()))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",COLORE('ROSSO'),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+", COLORE('GIALLO'),COLORE('NERO'))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			
			.Parent.Parent.Parent.VEDI_GRIGLIE_DEL_PIANO()
			
			.Parent.Parent.Refresh()
		ENDWITH
		
		
	ENDPROC
	*- FINE Metodo: Click
    ***************************

ENDDEFINE
*- FINE CLASSE CheckBoxPerGrigliaPianiProduzione
**********************************************************


**********************************************************
* Classe CasellaDiTestoPerPianiProduzione
**********************************************************
DEFINE CLASS CasellaDiTestoPerPianiProduzione AS TestoPerGriglia
  		  
	*****************************
	* Metodo PROCEDURE Init
	*****************************
	PROCEDURE Init
		
		WITH this
			.height=20
			.FontName=this.Parent.Parent.FontName
			.FontSize=this.Parent.Parent.FontSize
			.FontBold=this.Parent.Parent.FontBold
			.SpecialEffect=1
			.BorderStyle=0 && 0-none 1-fixed single
			.BackColor=RGB(255,255,255)
			.ForeColor=RGB(0,0,0)
		ENDWITH	

	ENDPROC
	*- FINE Metodo: Init
    ***************************
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		WITH this
			_ALIAS=.Parent.Parent.RecordSourceAlias
			SELECT &_ALIAS
			_RECNO=ALLTRIM(STR(RECNO()))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",COLORE('ROSSO'),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+", COLORE('GIALLO'),COLORE('NERO'))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			.Parent.Parent.Parent.VEDI_GRIGLIE_DEL_PIANO()
			.Parent.Parent.Refresh()
		ENDWITH
		
	RETURN
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
	
	RETURN
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaDiTestoPerPianiProduzione
**********************************************************



**********************************************************
PROCEDURE CANCELLA_PIANO_PRODUZIONE
**********************************************************
	LPARAMETERS _PJ_PRGPRD1
	
	cSql = "DELETE from U_PRD_D1 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' "
    IF !ExecCommand(CSQL,"U_PRD_D1")
       RETURN (.f.)
    ENDIF  	

	cSql = "DELETE from U_PRD_D2 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' "
    IF !ExecCommand(CSQL,"U_PRD_D2")
       RETURN (.f.)
    ENDIF  
    

    *** SBLOCCA GLI ORDINI IN PRODUZIONE LEGATI AL PIANO DI PRODUZIONE
    ***		
	cSql=""     
	cNomeCursorSql=SYS(2015)
	

	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

      UPDATE U_MAG_GG 
      SET MAG_PRENOT=0
	  WHERE MAG_CODART IN (
	  SELECT PR3_CODINT FROM U_PRD_D3 WHERE PJ_PRGPRD1='<<ALLTRIM(_PJ_PRGPRD1)>>')
         
	ENDTEXT					&& FINE SCRITTURA QUERY
		
	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF    
	
	cSql = "DELETE from U_PRD_D3 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"'"
    IF !ExecCommand(CSQL,"U_PRD_D3")
       RETURN (.f.)
    ENDIF  
    
    cSql = "DELETE from U_PRD_D4 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"'"
    IF !ExecCommand(CSQL,"U_PRD_D4")
       RETURN (.f.)
    ENDIF  

    *** SBLOCCA GLI ORDINI IN PRODUZIONE LEGATI AL PIANO DI PRODUZIONE
    ***		
	cSql=""     
	cNomeCursorSql=SYS(2015)
	

	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

      UPDATE U_ORD_DD 
      SET ORD_INPROD=0
	  WHERE ORD_CODSYS IN (
	  SELECT DISTINCT PR5_ORDSYS FROM U_PRD_D5 WHERE PJ_PRGPRD1='<<ALLTRIM(_PJ_PRGPRD1)>>')
	  AND ORD_CODSYS<>''      
         
	ENDTEXT					&& FINE SCRITTURA QUERY
		
	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF
		    
    cSql = "DELETE from U_PRD_D5 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"'"
    IF !ExecCommand(cSql,"U_PRD_D5")
       RETURN (.f.)
    ENDIF  
    
		    
    cSql = "DELETE from U_PRD_DR where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"'"
    IF !ExecCommand(cSql,"U_PRD_DR")
       RETURN (.f.)
    ENDIF  
        
    
* PROCEDURE CANCELLA_PIANO_PRODUZIONE
**********************************************************	
	


**********************************************************
PROCEDURE CONFERMA_PIANI_DI_PRODUZIONE
**********************************************************
	RELEASE V_OKGENERATO,V_ORD_NUMORD,V_ORD_DATORD,_PJ_PRGPRD1
	PUBLIC  V_OKGENERATO,V_ORD_NUMORD,V_ORD_DATORD,_PJ_PRGPRD1

	LOCAL _PRIMO_ORDINE_GENERATO,_ULTIMO_ORDINE_GENERATO,_FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE
	_PRIMO_ORDINE_GENERATO =""
	_ULTIMO_ORDINE_GENERATO=""
	_FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE=.F.	
	_PJ_PRGPRD1=""	

	
	SELECT U_PRD_D1
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
	
		IF EMPTY(SELEZIONE)
			SKIP
			LOOP
		ENDIF

				
		IF PR1_STAPRG!=PUB_STATO_PROGRAMMA_IN_PROGRAMMAZIONE
			SKIP
			LOOP
		ENDIF
				
		_PJ_PRGPRD1=PJ_PRGPRD1
		
	    cSql = "UPDATE U_PRD_D1 SET PR1_STAPRG='"+PUB_STATO_PROGRAMMA_PRONTO_PER_SPALMATURA+"' WHERE PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"'"
		cNomeCursorSql="___CU_PRD_D1"		
	    IF !ExecCommand(cSql,cNomeCursorSql)
	       RETURN (.f.)
	    ENDIF  
		
	    cSql = "UPDATE U_PRD_D2 SET PR2_STASEQ='"+PUB_STATO_PROGRAMMA_PRONTO_PER_SPALMATURA+"' WHERE PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"'"
		cNomeCursorSql="___CU_PRD_D2"		
	    IF !ExecCommand(cSql,cNomeCursorSql)
	       RETURN (.f.)
	    ENDIF  
	    	    
	    SELECT U_PRD_D1
	   	REPLACE PR1_STAPRG WITH PUB_STATO_PROGRAMMA_PRONTO_PER_SPALMATURA 
	
	    SELECT U_PRD_D2
	   	REPLACE PR2_STASEQ WITH PUB_STATO_PROGRAMMA_PRONTO_PER_SPALMATURA 

	   	SELECT U_PRD_D1
	   	
	*   IF 7=MESSAGEBOX("Procedere con la generazione degli ordini interni per il piano di produzione "+_PJ_PRGPRD1+"?",4+32,"Conferma generazione ordini interni")
	* 		RETURN
	* 	ENDIF
		
		_FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE=.F.
		
		IF _ESISTE_QUALCOSA_DA_SPALMARE
		
			**********************************************************
			* INIZIO GENERAZIONE ORDINI INTERNI 
			**********************************************************		
		
			cSql=""     
			cNomeCursorSql="CU_SCO_MI"
					
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
		
			SELECT 
				COUNT(*) AS SCO_SUBSCO,
				PR5_ALTEZZ AS SCO_ALTEZZ,
				PR5_LUNGHE AS SCO_LUNGHE,
				PR5_CODART AS SCO_CODART 
			FROM U_PRD_D5 
			WHERE PR5_CODCLI='<<PUB_CLISOC>>'  
				AND PJ_PRGPRD1='<<_PJ_PRGPRD1>>'
			GROUP BY PR5_CODART,PR5_ALTEZZ,PR5_LUNGHE
			
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF

			V_OKGENERATO = .F.
			V_ORD_NUMORD = SPACE(06)
			V_ORD_DATORD = SPACE(10)
			
			SELECT CU_SCO_MI
			GO TOP		
			IF !EOF()
			
				_FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE= .F.
				
			    **********************************************************			
				DO GENERA_ORDINE_INTERNO
			    **********************************************************
			
				IF V_OKGENERATO
				   WAIT WINDOW "Generazione Automatica Ordine Interno" + CHR(13) + CHR(13) +;
				              "Nuovo Ordine: N° " + V_ORD_NUMORD + " del " + RIBALTA2(V_ORD_DATORD) NOWAIT
					_FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE= .T.		              
				ELSE
				   MESSAGEBOX("Errore in generazione ordine",16,"Attenzione")
				   _FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE= .F.
				ENDIF	
				
				WAIT WINDOW "Generazione Automatica Ordine Interno In Corso  -  Prego Attendere..." NOWAIT 
			ELSE
				_FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE= .F.		              
			ENDIF
		
		    **********************************************************
		    * FINE GENERAZIONE ORDINI INTERNI 
		    **********************************************************			
		ENDIF 
	    
		IF _FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE
		
			*** AGGIORNO CODICE ORDINE INTERNO IN PROGRAMMA DI PRODUZIONE
			cSql=""     
			cNomeCursorSql="_CU_U_PRD_D5"
					
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
		
			UPDATE U_PRD_D5 
			SET PR5_NUMORD = '<<V_ORD_NUMORD>>' ,
			    PR5_DATORD = '<<V_ORD_DATORD>>' 
			WHERE PR5_CODCLI='<<PUB_CLISOC>>' 
			AND PJ_PRGPRD1='<<_PJ_PRGPRD1>>'
			
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF		
		
			IF EMPTY(_PRIMO_ORDINE_GENERATO)
				_PRIMO_ORDINE_GENERATO =V_ORD_NUMORD
			ENDIF
			_ULTIMO_ORDINE_GENERATO=V_ORD_NUMORD
		ENDIF
	

 **########################################################################################################################		
 **#### SIMONE - 10/09/2009 - INIZIO
 **####          L'AGGIORNAMENTO DELLE DATE DI CONSEGNA NON DEVE ESSERE FATTO
 **########################################################################################################################		
*!*			
*!*			**********************************************************
*!*			*** AGGIORNA DATE DI CONSEGNA
*!*			**********************************************************
*!*				
*!*			*** VERIFICO LA PRESENZA DI ORDINI DI CUI VARIARE LA DATA DI CONSEGNA
*!*			cSql=""     
*!*			cNomeCursorSql="_CUR_DATE_DA_MODIF"
*!*					
*!*			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
*!*			
*!*			SELECT 
*!*				PR5_CODCLI,
*!*				PR5_RAGSOC,
*!*				PR5_NUMORD,
*!*				PR5_DATORD,
*!*				PR5_DATCON,
*!*				MAX(PR5_DTCON2) AS PR5_DTCON2 
*!*			FROM U_PRD_D5 
*!*			WHERE 
*!*				PR5_DTCON2>PR5_DATCON
*!*				AND PR5_CODCLI NOT IN (SELECT AZI_CODCLI FROM U_AZI_AN)
*!*				AND PJ_PRGPRD1='<<_PJ_PRGPRD1>>'
*!*			GROUP BY PR5_CODCLI,PR5_RAGSOC,PR5_NUMORD,PR5_DATORD,PR5_DATCON 
*!*			ORDER BY PR5_RAGSOC,PR5_NUMORD,PR5_DATORD
*!*			
*!*			ENDTEXT					&& FINE SCRITTURA QUERY
*!*			
*!*			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
*!*				return(.F.)
*!*			ENDIF	
*!*			
*!*			SELECT _CUR_DATE_DA_MODIF
*!*			GO TOP
*!*			
*!*			DO WHILE !EOF()
*!*			
*!*				*** AGGIORNA TESTATE ORDINI
*!*				***
*!*				_NUMORD=PR5_NUMORD
*!*				_DATORD=PR5_DATORD
*!*				_DTCON2=PR5_DTCON2 
*!*			
*!*				cSql=""     
*!*				cNomeCursorSql="___AGG"
*!*						
*!*				TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
*!*				
*!*				UPDATE U_ORD_TT
*!*				SET ORD_DTCONS='<<_DTCON2>>'
*!*				WHERE ORD_NUMORD='<<_NUMORD>>' AND ORD_DATORD='<<_DATORD>>'
*!*				
*!*				ENDTEXT					&& FINE SCRITTURA QUERY
*!*				
*!*				IF !ExecPreparedCommand(cSql,cNomeCursorSql)
*!*					return(.F.)
*!*				ENDIF	
*!*				
*!*				IF USED(cNomeCursorSql)
*!*					TABLEREVERT(.T.,cNomeCursorSql)
*!*				ENDIF
*!*				
*!*				*** AGGIORNA DETTAGLI ORDINI
*!*				***
*!*				cSql=""     
*!*				cNomeCursorSql="___AGG"
*!*						
*!*				TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
*!*				
*!*				UPDATE U_ORD_DD
*!*				SET ORD_DATCON='<<_DTCON2>>'
*!*				WHERE DAGGANCIO IN (SELECT TAGGANCIO FROM U_ORD_TT WHERE ORD_NUMORD='<<_NUMORD>>' AND ORD_DATORD='<<_DATORD>>')
*!*				
*!*				ENDTEXT					&& FINE SCRITTURA QUERY
*!*				
*!*				IF !ExecPreparedCommand(cSql,cNomeCursorSql)
*!*					return(.F.)
*!*				ENDIF		
*!*				
*!*				SELECT _CUR_DATE_DA_MODIF
*!*				SKIP
*!*			ENDDO
*!*			
*!*					
*!*			**********************************************************
*!*			*** AGGIORNA DATE DI CONSEGNA
*!*			**********************************************************
 **########################################################################################################################		
 **#### SIMONE - 10/09/2009 - FINE
 **####          L'AGGIORNAMENTO DELLE DATE DI CONSEGNA NON DEVE ESSERE FATTO
 **########################################################################################################################		





		
	    SELECT U_PRD_D1
	    REPLACE SELEZIONE WITH ""
		
		SKIP
	ENDDO


    **********************************************************
    * INIZIO UTILITA' RISTAMPA DOCUMENTI 
    **********************************************************			
	IF _FLAG_GENERAZIONE_AVVENUTA_CORRETTAMENTE
	    _RISP = MESSAGEBOX("Aprire l'utilità di ristampa documenti per" + CHR(13) + ;
	                      "visualizzare e/o stampare gli ordini creati?",36,"Attenzione")
	    IF _RISP = 6
	    	do form form\menu_ristampa_doc with "ORD",_PRIMO_ORDINE_GENERATO,_ULTIMO_ORDINE_GENERATO
	    ENDIF

	    ___NUMERO_ORDINE_INTERNO=V_ORD_NUMORD 
	    ___DATA_ORDINE_INTERNO=RIBALTA2(V_ORD_DATORD )
    ENDIF

	
    **********************************************************
    * FINE UTILITA' RISTAMPA DOCUMENTI 
    **********************************************************	
    
* PROCEDURE CONFERMA_PIANI_DI_PRODUZIONE
**********************************************************	
	
