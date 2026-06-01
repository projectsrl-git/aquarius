
/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Documenti", sottoschede varie dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Riporta le Scadenze speciali in un commento nei dettagli <documento>
***		- Riporta le Scadenze speciali nell'apposita sezione delle scadenze (fino a 7 scadenze max, altrimenti come commento)
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_SSPORD NUMERIC(1,0) NULL,
	AZI_SSPFAP NUMERIC(1,0) NULL,
	AZI_SSPFAT NUMERIC(1,0) NULL,
	AZI_SSPORF NUMERIC(1,0) NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_SSPORD] DEFAULT (1) FOR [AZI_SSPORD],
	CONSTRAINT [DF_U_AZI_PA_AZI_SSPFAP] DEFAULT (1) FOR [AZI_SSPFAP],
	CONSTRAINT [DF_U_AZI_PA_AZI_SSPFAT] DEFAULT (1) FOR [AZI_SSPFAT],
	CONSTRAINT [DF_U_AZI_PA_AZI_SSPORF] DEFAULT (1) FOR [AZI_SSPORF]
GO

UPDATE U_AZI_PA SET AZI_SSPORD = 1
UPDATE U_AZI_PA SET AZI_SSPFAP = 1
UPDATE U_AZI_PA SET AZI_SSPFAT = 1
UPDATE U_AZI_PA SET AZI_SSPORF = 1
