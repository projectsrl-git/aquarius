
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la gestione della produzione film protettivi con pianificazione
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PRDFPR BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_PRDFPR] DEFAULT (0) FOR [AZI_PRDFPR]
GO

UPDATE U_AZI_PB SET AZI_PRDFPR = 0
