
/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT Clienti" dei parametri di sistama nel "form\menu_azi000.scx":
***		- Commento automatico classe doganale anche in DDT
***		- Riporta articoli in commento automatico classe doganale
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_DOGBOL BIT NULL,
	AZI_DOGART BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_DOGBOL] DEFAULT (0) FOR [AZI_DOGBOL],
	CONSTRAINT [DF_U_AZI_PA_AZI_DOGART] DEFAULT (0) FOR [AZI_DOGART]
GO

UPDATE U_AZI_PA SET AZI_DOGBOL = 0
UPDATE U_AZI_PA SET AZI_DOGART = 0
