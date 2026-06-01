
/*
*** Variabile per l'opzione "Abilita la gestione della tabella LOGSQL" gestita nella scheda "Altro", 
*** sottoscheda "Varie" dei parametri aziendali nel "form\menu_azi000.scx"
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_LOGSQL BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_LOGSQL] DEFAULT (0) FOR [AZI_LOGSQL]
GO

UPDATE U_AZI_PA SET AZI_LOGSQL = 0
