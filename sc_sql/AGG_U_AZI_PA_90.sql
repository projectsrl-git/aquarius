
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Packing list",
*** sottoscheda "Packing list produzione pannelli truciolari" dei parametri di sistama nel "form\menu_azi000.scx":
***		- Indirizzi e-mail di default per autorizzazione
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_PKREML varchar(254) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_PKREML] DEFAULT ('') FOR [AZI_PKREML]
GO

UPDATE U_AZI_PA SET AZI_PKREML = ''
