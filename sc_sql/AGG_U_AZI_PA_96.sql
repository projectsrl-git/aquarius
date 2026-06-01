
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione pannelli truciolari" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Nr. giorni per chiusura automatica programmi di produzione
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_PGGCLS NUMERIC(3,0) NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_PGGCLS] DEFAULT (0) FOR [AZI_PGGCLS]
GO

UPDATE U_AZI_PA SET AZI_PGGCLS = 30
