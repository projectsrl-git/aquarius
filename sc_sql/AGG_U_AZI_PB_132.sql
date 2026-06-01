
/*
*** Variabili per i campo gestito in MENU_AZI000 per la gestione dei listini
***		- cartella listini clientii
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_LISMDB BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_LISMDB] DEFAULT (0)
GO

