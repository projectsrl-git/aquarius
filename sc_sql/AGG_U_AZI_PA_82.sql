
/*
*** Variabile per l'opzione "Scarico magazzino nelle consegne a fornitore" gestita nella scheda "Altro", sottoscheda "Magazzino", sottoscheda "Generale" 
*** dei parametri di sistama nel "form\menu_azi000.scx"
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_SAUFOR BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_SAUFOR] DEFAULT (0) FOR [AZI_SAUFOR]
GO

UPDATE U_AZI_PA SET AZI_SAUFOR = 0
