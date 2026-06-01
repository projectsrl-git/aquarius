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

IF FILE("C:\TEMP\TEST")
	USE CSALDI_PARTITE IN 0 AGAIN 
ENDIF

* 2) importa dati saldi risorse

IF FILE("C:\TEMP\TEST")
		SELECT SALDI 		
		
		APPEND BLANK
 		REPLACE ;
 			CODRISORSA WITH "INTESA1",;
			DESRISORSA WITH "BANCA INTESA CC 001001",;
			ABI	WITH "12345",;
			CAB WITH "12345",;
			CC	WITH "001001",;
			DT_SALDO WITH "2004/04/20",;
			SALDO 	WITH 10000,;
			FIDO 	WITH 10000,;
			CONTOCONT WITH "10101010" 

		APPEND BLANK
 		REPLACE ;
 			CODRISORSA WITH "SANPAOLO1",;
			DESRISORSA WITH "SAN PAOLO CC 002002",;
			ABI	WITH "67891",;
			CAB WITH "67891",;
			CC	WITH "002002",;
			DT_SALDO WITH "2004/04/20",;
			SALDO 	WITH 8000,;
			FIDO 	WITH 0 ,;
			CONTOCONT WITH "20202020" 
ENDIF
 	 	

	
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
	