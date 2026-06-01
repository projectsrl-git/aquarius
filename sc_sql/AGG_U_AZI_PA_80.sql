
/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Documenti standard" dei parametri di sistama nel "form\menu_azi000.scx":
***		- Abilita gestione Articolo cliente / Articolo magazzino in documenti (ordini, bolle, fatture)
***		- Visualizza un messaggio in caso di creazione ordine con articolo di produzione senza Distinta Base
***		- Blocca la creazione di ordini con articoli di produzione senza Distinta Base
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_CDAPRD BIT NULL,
	AZI_MSGORDNODB BIT NULL,
	AZI_LCKORDNODB BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_CDAPRD] DEFAULT (0) FOR [AZI_CDAPRD],
	CONSTRAINT [DF_U_AZI_PA_AZI_MSGORDNODB] DEFAULT (0) FOR [AZI_MSGORDNODB],
	CONSTRAINT [DF_U_AZI_PA_AZI_LCKORDNODB] DEFAULT (0) FOR [AZI_LCKORDNODB]
GO

UPDATE U_AZI_PA SET AZI_CDAPRD = 0
UPDATE U_AZI_PA SET AZI_MSGORDNODB = 0
UPDATE U_AZI_PA SET AZI_LCKORDNODB = 0
