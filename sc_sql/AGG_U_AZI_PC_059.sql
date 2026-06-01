/*
*** Variabili per le opzioni gestite nella scheda "Contabilità", sottoscheda "Controlli", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Richiedi password di protezione per la modifica delle registrazioni di tipo Fattura Cliente
***		- Richiedi password di protezione per la modifica delle registrazioni di tipo Fattura Fornitore
*/
        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CTRPWDFAT BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_CTRPWDFAT] DEFAULT (0),
	AZI_CTRPWDFAF BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_CTRPWDFAF] DEFAULT (0)
GO
