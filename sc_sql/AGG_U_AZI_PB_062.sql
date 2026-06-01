
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Stampa intestazione e Logo azienda in estrazioni Excel generalizzate
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_INTXLS BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_AZI_INTXLS] DEFAULT (0)
GO

UPDATE U_AZI_PB SET AZI_INTXLS = 1

