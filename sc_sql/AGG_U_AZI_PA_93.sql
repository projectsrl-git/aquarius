
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Packing list",
*** sottoscheda "Packing list produzione pannelli truciolari" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Inizializza il Numero Camion di una nuova packing list con quello dell'ultima packing list + 1
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_PKNCAU BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_PKNCAU] DEFAULT (0) FOR [AZI_PKNCAU]
GO

UPDATE U_AZI_PA SET AZI_PKNCAU = 1
