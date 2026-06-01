****************************************************************************************************************
*																											   *
* 			                		CONTABILIZZA RATEI / RISCONTI PREVISIONALI			       				   *
*																											   *
****************************************************************************************************************
* ATTRIBUISCE UN NUOVO NUMERO DI REGISTRAZIONE
* CONTABILIZZA LA REGISTRAZIONE IN BASE ALLA DATA INDICATA DALL'UTENTE


__DATADAL  = RIBALTA2(DATADAL)
__DATAAL   = RIBALTA2(DATAAL)
__RAT_RIS  = 'RAT-RIS' 

cSql=""     
cNomeCursorSql="RATEI_RISCONTI_CUR"
			
TEXT TO cSql NOSHOW

	SELECT 
	    '   ' AS SELEZIONE,
		MOV_NUMPRO, 
		MOV_NREGIS, 
		MOV_DTREG, 
		MOV_NDOC, 
		MOV_DTDOC,
		MOV_TOP, 
		MOV_REGAUT,
		SUM(MOV_IMP) AS MOV_IMP 
	FROM MOV_CONT
	WHERE MOV_REGAUT = '<<__RAT_RIS>>'  
		  AND MOV_DTREG BETWEEN '<<__DATADAL>>' AND '<<__DATAAL>>'
		  AND MOV_TMOV = 'A'
		  AND MOV_CONTABILITA_PREVISIONALE = 'P'
	GROUP BY MOV_NUMPRO,MOV_NREGIS,MOV_DTREG,MOV_NDOC,MOV_DTDOC,MOV_TOP,MOV_REGAUT

	
ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	

SELECT RATEI_RISCONTI_CUR
GO TOP

DO prg\browseview WITH "RATEI_RISCONTI_CUR","Seleziona i ratei risconti previsionali da contabilizzare","W:20;MOV_NREGIS:nr. registrazione,W:10;MOV_DTREG:data registrazione,W:20;MOV_NDOC:nr. documento,W:10;MOV_DTDOC:data documento,W:5;MOV_TOP:top,W:6;MOV_IMP:importo.,W:13;",500,652,.T.,.T.

SELECT RATEI_RISCONTI_CUR
GO TOP

IF NumeroRecordLetti = 0

	MESSAGGIO_STILE_WIN8("Contabilizzazione ratei / risconti :" + CHR(13) + CHR(13) +"Nessuna registrazione selezionata da contabilizzare"+ CHR(13) + CHR(13) + "Fare click su OK per continuare")
    RETURN 

ELSE

   LOCAL _MESSAGGIO_DATA_REGISTRAZIONE
   _MESSAGGIO_DATA_REGISTRAZIONE=""

   IF 7= MESSAGEBOX("Contabilizzazione ratei / risconti :" + CHR(13) + CHR(13) +"Confermi la contabilizzazione del Nr."+ALLTRIM(STR(NumeroRecordLetti,4,0))+" ratei / risconti selezionati?"+CHR(13)+CHR(13)+_MESSAGGIO_DATA_REGISTRAZIONE,292,'Contabilizzazione ratei / risconti') 
		=MESSAGEBOX("Nessuna movimento rateo / risconto contabilizzato in contabilità generale !!!",62,"ATTENZIONE")
	    RETURN 
   ENDIF


ENDIF


SELECT RATEI_RISCONTI_CUR
GO TOP


DO WHILE !EOF()

	IF DELETED()
		SELECT RATEI_RISCONTI_CUR
		SKIP +1
		LOOP
	ENDIF
	   
	IF EMPTY(SELEZIONE)
		SELECT RATEI_RISCONTI_CUR
		SKIP +1
		LOOP
	ENDIF

	SCATTER MEMVAR MEMO

    _NREG_ = ""
    DO REG_NUMREG										&& RICARICA IL NUOVO NUMERO DI REGISTRAZIONE DA ATTRIBUIRE ALLA REGISTRAZIONE EFFETTIVA CONTABILIZZATA
    
    =CONTABILIZZA_RATEI_RISCONTI(M.MOV_NUMPRO,_NREG_) 	&& ELABORA INDICE/MOV_CONT/CONTI/PART_CLI/PART_FOR


	SELECT RATEI_RISCONTI_CUR
	SKIP +1

ENDDO WHILE !EOF()


=MESSAGEBOX("Contabilizzazione ratei / risconti previsionali terminato correttamente",62,"ATTENZIONE")


RETURN 

*********************************************************************
FUNCTION CONTABILIZZA_RATEI_RISCONTI
*********************************************************************
LPARAMETERS __NUMPRO__,__NREG__

RELEASE _CLI_FOR_
PUBLIC _CLI_FOR_
_CLI_FOR_= ""

cSql=""     
cNomeCursorSql="RATEI_RISCONTI_PN"
			
TEXT TO cSql NOSHOW

	SELECT * FROM MOV_CONT
	WHERE MOV_NUMPRO = '<<__NUMPRO__>>'  
	ORDER BY MOV_NUMPRO,MOV_SEQUEN

	
ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	


SELECT RATEI_RISCONTI_PN
GO TOP
DO WHILE !EOF()

	IF DELETED()
		SELECT RATEI_RISCONTI_PN
		SKIP +1
		LOOP
	ENDIF
	   
	SCATTER MEMVAR MEMO
	
	=AGGIORNA_INDICE_RATEI_RISCONTI(M.MOV_NUMPRO,M.MOV_ANNO,DATAREG,M.MOV_CONTO,M.MOV_IMP,M.MOV_TMOV,M.MOV_CAMBIO,M.MOV_VALUTA,__NREG__)

	=AGGIORNA_MOV_CONT_RATEI_RISCONTI(M.MOV_NUMPRO,M.MOV_ANNO,DATAREG,M.MOV_CONTO,M.MOV_IMP,M.MOV_TMOV,M.MOV_CAMBIO,M.MOV_VALUTA,M.ID_UNIQUE,__NREG__)

	=AGGIORNA_PIANO_DEI_CONTI_RATEI_RISCONTI(M.MOV_NUMPRO,M.MOV_ANNO,DATAREG,M.MOV_CONTO,M.MOV_IMP,M.MOV_TMOV,M.MOV_CAMBIO,M.MOV_VALUTA)

	=AGGIORNA_PARTITARI_RATEI_RISCONTI(M.MOV_NUMPRO,M.MOV_ANNO,DATAREG,M.MOV_CONTO,M.MOV_IMP,M.MOV_TMOV,M.MOV_CAMBIO,M.MOV_VALUTA,_CLI_FOR_,__NREG__)


	SELECT RATEI_RISCONTI_PN
	SKIP +1

ENDDO WHILE !EOF()




RETURN


	
****************************************************************************************************************
FUNCTION AGGIORNA_INDICE_RATEI_RISCONTI
****************************************************************************************************************
LPARAMETERS _NUMPRO,_ANNO_CONTABILE_,_DATA_REGIS_,_CONTO_CONTABILE_,_IMPORTO_,_TMOV_,_CAMBIO_,_VALUTA_,_NREG_

	_DATA_REGIS___ = RIBALTA2(_DATA_REGIS_)
  	_CONTABILITA_PREVISIONALE    = ""
	CSQL="UPDATE INDICE SET MOV_CONTABILITA_PREVISIONALE = '" + ALLTRIM(_CONTABILITA_PREVISIONALE) + "'" + " , MOV_NREGIS = '" + ALLTRIM(_NREG_) + "'" + " , MOV_DTREG = '" + ALLTRIM(_DATA_REGIS___) + "' WHERE MOV_NUMPRO = '"+_NUMPRO+"'"

	IF !ExecCommand(cSql,'_TEMP')
	   return(.f.)
	ENDIF




RETURN

****************************************************************************************************************
FUNCTION AGGIORNA_MOV_CONT_RATEI_RISCONTI
****************************************************************************************************************
LPARAMETERS _NUMPRO,_ANNO_CONTABILE_,_DATA_REGIS_,_CONTO_CONTABILE_,_IMPORTO_,_TMOV_,_CAMBIO_,_VALUTA_,_ID_UNIQUE_,_NREG_

 	_DATA_REGIS___ = RIBALTA2(_DATA_REGIS_)
 	_CONTABILITA_PREVISIONALE    = ""
	CSQL="UPDATE MOV_CONT SET MOV_CONTABILITA_PREVISIONALE = '" + ALLTRIM(_CONTABILITA_PREVISIONALE) + "'" + " , MOV_NREGIS = '" + ALLTRIM(_NREG_) + "'" + " , MOV_DTREG = '" + ALLTRIM(_DATA_REGIS___) + "' WHERE ID_UNIQUE = '"+_ID_UNIQUE_+"'"

	IF !ExecCommand(cSql,'_TEMP')
	   return(.f.)
	ENDIF

RETURN


****************************************************************************************************************
FUNCTION AGGIORNA_PARTITARI_RATEI_RISCONTI
****************************************************************************************************************
LPARAMETERS _NUMPRO,_ANNO_CONTABILE_,_DATA_REGIS_,_CONTO_CONTABILE_,_IMPORTO_,_TMOV_,_CAMBIO_,_VALUTA_,_CLI_FOR_,_NREG_

_DATA_REGIS___ = RIBALTA2(_DATA_REGIS_)

	DO CASE
	
		CASE _CLI_FOR_ = 'C'
		
		  	_CONTABILITA_PREVISIONALE    = ""
			CSQL="UPDATE PART_CLI SET PAR_CONTABILITA_PREVISIONALE = '" + ALLTRIM(_CONTABILITA_PREVISIONALE) + "'" + " , PAR_NREG = '" + ALLTRIM(_NREG_) + "'" + " , PAR_DTREG = '" + ALLTRIM(_DATA_REGIS___) + "' WHERE PAR_NUMPRO = '"+_NUMPRO+"'"

			IF !ExecCommand(cSql,'_TEMP')
			   return(.f.)
			ENDIF


		CASE _CLI_FOR_ = 'F'
		
		  	_CONTABILITA_PREVISIONALE    = ""
			CSQL="UPDATE PART_FOR SET PAR_CONTABILITA_PREVISIONALE = '" + ALLTRIM(_CONTABILITA_PREVISIONALE) + "'" + " , PAR_NREG = '" + ALLTRIM(_NREG_) + "'" + " , PAR_DTREG = '" + ALLTRIM(_DATA_REGIS___) + "' WHERE PAR_NUMPRO = '"+_NUMPRO+"'"

			IF !ExecCommand(cSql,'_TEMP')
			   return(.f.)
			ENDIF
	
	
		OTHERWISE

	ENDCASE
	
	
RETURN


****************************************************************************************************************
FUNCTION AGGIORNA_PIANO_DEI_CONTI_RATEI_RISCONTI
****************************************************************************************************************
LPARAMETERS _NUMPRO,_ANNO_CONTABILE_,_DATA_REGIS_,_CONTO_CONTABILE_,_IMPORTO_,_TMOV_,_CAMBIO_,_VALUTA_

* TOGLIE IL VALORE DALLA SEZIONE PREVISIONALE DEL PIANO DEI CONTI
* AGGIUNGE IL VALORE DALLA SEZIONE EFFETTIVA DEL PIANO DEI CONTI

IF _TMOV_ = 'D'
	____DARE 	= _IMPORTO_
	____AVERE	= 0
ELSE
	____DARE 	= 0
	____AVERE	= _IMPORTO_
ENDIF

_CLI_FOR_ = ""

*1) AGGIORNA PIANO DEI CONTI

   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + _ANNO_CONTABILE_ + "'"
   x_cont = "con_conto = '" + ALLTRIM(_CONTO_CONTABILE_) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   Csql  = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      return(.f.)
   ENDIF
   SELECT CONTI
   IF RECCOUNT() = 0
      PUB_ERRORE=MESSAGEBOX('Conto inesistente'+CHR(13)+"durante l'aggiornamento RATEI / risconti",64,'*** ATTENZIONE ***')
      RETURN
   ELSE
 
        
    	_CLI_FOR_ = SUBSTR(CON_TIPOCO,1,1)
        
		* TOGLIE IL VALORE DALLA SEZIONE PREVISIONALE DEL PIANO DEI CONTI

		P_IMPA  = PRE_IMP_A
		P_IMPD  = PRE_IMP_D
	    MESE    = SUBSTR(_DATA_REGIS_,4,2)
		VAR     = "PRE_AV"+MESE
	  	VAR2    = "PRE_DA"+MESE
	    REPLACE   PRE_IMP_D   WITH P_IMPD-CAMBIO(_VALUTA_,____DARE,_CAMBIO_)
	    REPLACE   PRE_IMP_A   WITH P_IMPA-CAMBIO(_VALUTA_,____AVERE,_CAMBIO_)
	    REPLACE   &VAR2       WITH CAMBIO(_VALUTA_,____DARE,_CAMBIO_)-&VAR2
		REPLACE   &VAR        WITH CAMBIO(_VALUTA_,____AVERE,_CAMBIO_)-&VAR

		* AGGIUNGE IL VALORE DALLA SEZIONE EFFETTIVA DEL PIANO DEI CONTI
	    P_IMPA= CON_IMP_A
	    P_IMPD= CON_IMP_D
	    MESE    = SUBSTR(_DATA_REGIS_,4,2)
	    VAR     = "CON_AV"+MESE
	    VAR2    = "CON_DA"+MESE
		REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(_VALUTA_,____DARE,_CAMBIO_)
	    REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(_VALUTA_,____AVERE,_CAMBIO_)
	    REPLACE   &VAR2       WITH CAMBIO(_VALUTA_,____DARE,_CAMBIO_)+&VAR2
	    REPLACE   &VAR        WITH CAMBIO(_VALUTA_,____AVERE,_CAMBIO_)+&VAR
	 


   ENDIF
   IF !ExecRW(cSql,"CONTI","W")
      return(.f.)
   ENDIF

RETURN

