
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Pannelli truciolari" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Peso specifico medio pannelli grezzi
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PPTPES NUMERIC(10,4) NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_PPTPES] DEFAULT (0)
GO
