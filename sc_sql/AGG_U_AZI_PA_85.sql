
/*
*** Variabile per l'opzione "Abilita la gestione della tabella LOGSQL" gestita nella scheda "Altro", 
*** sottoscheda "Varie" dei parametri aziendali nel "form\menu_azi000.scx"
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	azi_cescom BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_cescom] DEFAULT (0) FOR [azi_cescom]
GO

UPDATE U_AZI_PA SET azi_cescom = 0
