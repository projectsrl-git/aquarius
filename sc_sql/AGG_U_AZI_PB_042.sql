
/*
*** Variabile per l' opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva personalizzazione layout documenti (su report di stampa predisposti)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PERSDOC BIT NOT NULL DEFAULT (0)
GO
