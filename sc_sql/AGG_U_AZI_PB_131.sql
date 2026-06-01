
/*
*** Variabili per i campo gestito in MENU_AZI000 per la gestione dei bollati iva
***		- Cartella contabilita\impostazioni varie (2)
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CIVAPN BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CIVAPN] DEFAULT (0)
GO

