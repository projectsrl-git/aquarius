
/*
*** Variabili per la gestione dei listini prezzi di vendita a scalare
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_LISVESCA bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_LISVESCA] DEFAULT (0)
GO
