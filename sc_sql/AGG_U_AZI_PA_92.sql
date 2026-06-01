
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Packing list",
*** sottoscheda "Packing list produzione pannelli truciolari" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Aumento percentuale massimo per Qtà già autorizzate senza necessità di nuova autorizzazione

*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT clienti":
***		- Impedisci la creazione di nuove DDT per clienti a Rischio 1 o Rischio 2
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_PKAUPE NUMERIC(3,0) NULL,
	AZI_DDTLCK BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_PKAUPE] DEFAULT (0) FOR [AZI_PKAUPE]
GO

UPDATE U_AZI_PA SET AZI_PKAUPE = 0
UPDATE U_AZI_PA SET AZI_DDTLCK = 0
