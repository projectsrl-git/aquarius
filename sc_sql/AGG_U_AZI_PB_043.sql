
/*
*** Variabile per l' opzione gestita nella scheda "Impostazioni varie" per gestire l'utilizzo del winmain oppure la gestione del menu su TBL_MENU
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NOWINM BIT NOT NULL DEFAULT (0)
GO
