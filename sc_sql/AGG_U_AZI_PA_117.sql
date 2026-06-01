
/*
*** Variabili per le opzioni gestite nella scheda "Impostazioni Varie" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Proponi Anteprima e Stampa in base a...
***		- Abilita possibilità di estrazione Excel generalizzata per tutte le stampe
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_OPZPRN numeric(1,0) NULL ,
	AZI_XLSALL bit NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_OPZPRN] DEFAULT (0) FOR [AZI_OPZPRN],
	CONSTRAINT [DF_U_AZI_PA_AZI_XLSALL] DEFAULT (0) FOR [AZI_XLSALL]
GO

UPDATE U_AZI_PA SET AZI_OPZPRN = 1
UPDATE U_AZI_PA SET AZI_XLSALL = 0