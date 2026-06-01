
/*
*** Variabili per i campo gestito in MENU_AZI000 per la gestione dei bollati iva
***		- cartella bollato iva note occasionali/bollato iva corrispettivi clienti
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	azi_bolnoc BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_azi_bolnoc] DEFAULT (0)
GO


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	azi_bolcor BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_azi_bolcor] DEFAULT (0)
GO

