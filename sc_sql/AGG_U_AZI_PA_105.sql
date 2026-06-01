/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture clienti" nel "form\menu_azi000.scx":
***		- Proponi la selezione delle opzioni avanzate di stampa in gestionale fatture
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_OASFAT BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_OASFAT] DEFAULT (0) FOR [AZI_OASFAT]
GO

UPDATE U_AZI_PA SET AZI_OASFAT = 0
