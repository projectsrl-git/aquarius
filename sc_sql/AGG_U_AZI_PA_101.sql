/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la gestione della produzione dispositivi medicali
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_PRDISP BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_PRDISP] DEFAULT (0) FOR [AZI_PRDISP]
GO

UPDATE U_AZI_PA SET AZI_PRDISP = 0
