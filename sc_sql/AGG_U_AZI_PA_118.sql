
/*
*** Variabili per l' opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Carichi da fornitore", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Aggiorna il lead time articolo fornitore in base alle ultima 4 consegne (solo per ordini a fornitore non pianificati)
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_LDTBFO bit NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_LDTBFO] DEFAULT (0) FOR [AZI_LDTBFO]
GO

UPDATE U_AZI_PA SET AZI_LDTBFO = 0