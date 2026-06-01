/*
*** Variabili per le opzioni gestite nel nel "form\DATI_AZIENDALI_CU.scx" richiamato dal tasto "Dati Aziendali" nel "form\MENU_CERTIFICAZIONI_UNICHE.scx":
***		- Intermediario Fornitura comunicazione
***		- Tipo Fornitore
***		- Codice Fiscale Rappresentante Firmatario
***		- Codice Carica (da 1 a 9 oppure da 11 a 15)
***		- Cognome Rappresentante Firmatario
***		- Nome Rappresentante Firmatario
*/
        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_INTERMEDIARIO_CU VARCHAR(10) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_INTERMEDIARIO_CU] DEFAULT (''),
	AZI_TIPO_FORN_CU NUMERIC(1,0) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_TIPO_FORN_CU] DEFAULT (0),
	AZI_CF_RAPPR_CU VARCHAR(16) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_CF_RAPPR_CU] DEFAULT (''),
	AZI_CARICA_RAPPR_CU NUMERIC(2,0) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_CARICA_RAPPR_CU] DEFAULT (0),
	AZI_COGNOME_RAPPR_CU VARCHAR(10) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_COGNOME_RAPPR_CU] DEFAULT (''),
	AZI_NOME_RAPPR_CU VARCHAR(10) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_NOME_RAPPR_CU] DEFAULT ('')
	
GO
