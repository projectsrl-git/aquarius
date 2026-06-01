*************************************************************************************************
*					         	    CARICAMENTO DBF SCHEDE IMPIANTI   				            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Marzo 2022 : Assolo		 			 													*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA SCHEDE IMPIANTI ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	


WAIT WINDOWS "SELEZIONA LA TABELLA IMPIANTI: SCHEDE" 
**** CARICAMENTO DEL FILE DBF
TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(TABELLA_INPUT)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF
WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 



*** CANCELLAZIONE DEI RECORD DELLA TABELLA AQ_SCHEDE SQL
WAIT WINDOWS "Cancellazione AQ_SCHEDE ...  -  Prego Attendere" NOWAIT
cSql = "delete from AQ_SCHEDE where 1=1"
IF !ExecCommand(cSql,"AQ_SCHEDE")
   return(.f.)
ENDIF

_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
*=OPENDB(TABELLA_INPUT)
IF !USED(TABELLA_INPUT)
   USE &TABELLA_INPUT IN 0 AGAIN
ENDIF

SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio SCHEDE attendere prego ....." NOWAIT


SELECT &_NOME_TABELLA
GO TOP 

SCAN

	SCATTER MEMVAR MEMO
	
	M.ID_PMKEY = ALLTRIM(M.ID_PMKEY)
	
	WAIT WINDOWS "Impianto caricato: " + M.ID_PMKEY NOWAIT


	**==> CREAZIONE TABELLA IMPIANTO
		
	IF !ExecRW("select * from AQ_SCHEDE where 0=1","AQ_SCHEDE","R")
	   return(.f.)
	ENDIF
	SELECT AQ_SCHEDE
	APPEND BLANK
	GATHER MEMVAR MEMO

	REPLACE CSCAD_A     	WITH RIBALTA2(CSCAD_A)           
	REPLACE CSCAD_B     	WITH RIBALTA2(CSCAD_B)              
	REPLACE CSCAD_C     	WITH RIBALTA2(CSCAD_C)                
	REPLACE CSCAD_D1     	WITH RIBALTA2(CSCAD_D1)             
	REPLACE CSCAD_D2     	WITH RIBALTA2(CSCAD_D2)               
	REPLACE CSCAD_E1     	WITH RIBALTA2(CSCAD_E1)               
	REPLACE CSCAD_E2     	WITH RIBALTA2(CSCAD_E1)               
	REPLACE CSCAD_F1     	WITH RIBALTA2(CSCAD_F1)               
	REPLACE CSCAD_F2     	WITH RIBALTA2(CSCAD_F2)               
	REPLACE DT_INSTALL     	WITH RIBALTA2(DT_INSTALL)              
	REPLACE CINIZCONTR     	WITH RIBALTA2(CINIZCONTR)              
	REPLACE CSCADCONTR     	WITH RIBALTA2(CSCADCONTR)             
	*REPLACE CFLAGGARZ     	WITH RIBALTA2(CFLAGGARZ)                      
	REPLACE CDAINGARNZ     	WITH RIBALTA2(CDAINGARNZ)            
	REPLACE CDAFIGARNZ     	WITH RIBALTA2(CDAFIGARNZ)            
	REPLACE DT_REGIST     	WITH RIBALTA2(DT_REGIST)              
	REPLACE DT_CONFERM     	WITH RIBALTA2(DT_CONFERM)             
	REPLACE DT_DISDETT     	WITH RIBALTA2(DT_DISDETT)       
	REPLACE DT_INIZIO     	WITH RIBALTA2(DT_INIZIO)              
	REPLACE DT_FINE     	WITH RIBALTA2(DT_FINE)                
	REPLACE DT_ULT_MAN     	WITH RIBALTA2(DT_ULT_MAN)             
	REPLACE DT_INIZ_BV     	WITH RIBALTA2(DT_INIZ_BV)             
	REPLACE DT_SCAD_BV     	WITH RIBALTA2(DT_SCAD_BV)             
	REPLACE DT_ACCENSIONE   WITH RIBALTA2(DT_ACCENSIONE)        
	REPLACE DT_ULT_RISTRUTT WITH RIBALTA2(DT_ULT_RISTRUTT)    	
	
	IF !ExecRW("select * from AQ_SCHEDE where 0=1","AQ_SCHEDE","W")
	   return(.f.)
	ENDIF
	

	SELECT &_NOME_TABELLA
	
ENDSCAN


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

