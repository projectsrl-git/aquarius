
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoschede "Ordini clienti" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Attiva la gestione dell'invio e-mail di notifica al cliente sullo stato degli ordini
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_EMLTRACKORD BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_EMLTRACKORD] DEFAULT (0)
GO
