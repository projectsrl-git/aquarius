
/*
*** Variabili per i campo gestito in MENU_ART000 per controaggiornare o meno il gruppo , cartella anagrafica articol/distintebasi dei parametri di sistema nel "form\menu_azi000.scx":
***		- controaggiornare o meno il gruppo di u_art_pr se non esiste la DI.BA per l'articolo
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PLADFA BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_PLADFA] DEFAULT (0)
GO

