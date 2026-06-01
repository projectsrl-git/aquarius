
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Abilita gestione testo unico con formattazione RTF in personalizzazione documento
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_DOCRTF BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_DOCRTF] DEFAULT (0)
GO

