********************************************************
* INBOUND.PRG
*-------------------------------------------------------
*
* Interfaccia importazione dati per Tesoreria
*
* 1) importa dati dello scadenziario
* 2) importa dati dei saldi delle risorse (Conti Correnti Bancari)
* 3) popola tabella delle causali dei movimenti
********************************************************

* 1) Importazione dati scadenziario

*=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","A","NO","ESTRAITUTTELEPARTITE")


USE CSALDI_PARTITE IN 0 AGAIN 
SELECT CSALDI_PARTITE 

SELECT PAGAMENTI
ZAP
SELECT CSALDI_PARTITE 
GO TOP 

DO WHILE !EOF()
	SCATTER MEMVAR MEMO 
	SELECT PAGAMENTI
	APPEND BLANK

	GATHER MEMVAR MEMO
	
   	SELECT CSALDI_PARTITE 
   	SKIP +1
ENDDO
SELECT PAGAMENTI

BROWSE NORMAL

GO TOP


* 2) importa dati saldi risorse

cSql="select * FROM U_CCO_TT "
IF !ExecCommand(cSql,"CUR_CONTI")
    return(.f.)
ENDIF
SELECT CUR_CONTI
GO TOP
DO WHILE !EOF()
	SELECT CUR_CONTI
 	SCATTER MEMVAR
	 	
 	SELECT SALDI
	APPEND BLANK
	REPLACE CODRISORSA 	WITH M.ORD_CODCCO ,;
			DESRISORSA 	WITH M.ORD_DESCCO ,;
			SALDO 		WITH M.ORD_SALDOCONT,;
			FIDO 		WITH M.ORD_FIDOCONTO,;
			DISPONIB 	WITH M.ORD_SALDOCONT+M.ORD_FIDOCONTO
			

	SELECT CUR_CONTI
	SKIP
ENDDO
 	 	

	SELECT SALDI
	GO TOP

	
* 3) popola la tabella delle causali dei movimenti


*** popolo la tabella delle causali con dati di test
INSERT INTO   CAUSALI (;
		CODCAUSALE ,;
		DESCAUSALE ,;
		SEGNO	   ,;
		ENTRATA    ,;
		ASSEGNI    ,;
		INCASSI    ,;
		BONIFICI   ,;
		RIBA	   ,;
		TRASF	   ,;
		RID		   );
	VALUES (;
		 "USC_ASS",; 
		 "Assegno Usc.",;
		 -1,;    
		.F.,;            
		.T.,;            
		.F.,;            
		.F.,;            
		.F.,;            
		.F.,;            
		.F.)              
	
INSERT INTO   CAUSALI (;
		CODCAUSALE ,;
		DESCAUSALE ,;
		SEGNO	   ,;
		ENTRATA    ,;
		ASSEGNI    ,;
		INCASSI    ,;
		BONIFICI   ,;
		RIBA	   ,;
		TRASF	   ,;
		RID		   );
	VALUES (;
		"USC_TRAS",;
		"Trasf.Usc.",;
		-1,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.T.,; 
		.F.)             
		
INSERT INTO   CAUSALI (;
		CODCAUSALE ,;
		DESCAUSALE ,;
		SEGNO	   ,;
		ENTRATA    ,;
		ASSEGNI    ,;
		INCASSI    ,;
		BONIFICI   ,;
		RIBA	   ,;
		TRASF	   ,;
		RID		   );
	VALUES (;
		"USC_BONI",;
		"Bonifico Usc.",;
		-1,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.T.,; 
		.F.)              

INSERT INTO   CAUSALI (;
		CODCAUSALE ,;
		DESCAUSALE ,;
		SEGNO	   ,;
		ENTRATA    ,;
		ASSEGNI    ,;
		INCASSI    ,;
		BONIFICI   ,;
		RIBA	   ,;
		TRASF	   ,;
		RID		   );
	VALUES (;
		"ENT_ASS",; 
		"Assegno Ent.",;
		1,; 
		.T.,; 
		.T.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.F.)            

INSERT INTO   CAUSALI (;
		CODCAUSALE ,;
		DESCAUSALE ,;
		SEGNO	   ,;
		ENTRATA    ,;
		ASSEGNI    ,;
		INCASSI    ,;
		BONIFICI   ,;
		RIBA	   ,;
		TRASF	   ,;
		RID		   );
	VALUES (;
		"ENT_TRAS",; 
		"Trasf.Ent.",;
		1,; 
		.T.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.T.,; 
		.F.)              

	

INSERT INTO   CAUSALI (;
		CODCAUSALE ,;
		DESCAUSALE ,;
		SEGNO	   ,;
		ENTRATA    ,;
		ASSEGNI    ,;
		INCASSI    ,;
		BONIFICI   ,;
		RIBA	   ,;
		TRASF	   ,;
		RID		   );
	VALUES (;
		"ENT_BONI",; 
		"Bonifici Ent.",;
		1,; 
		.T.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.F.,; 
		.T.,; 
		.F.)              
	