
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti" , sottoscheda "Rda" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Gestione completa delle richieste di acquisto OPPURE Gestione sintetica delle richieste di acquisto (senza gestione magazzino nè ordini fornitori)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_TYPERDA NUMERIC(1,0) NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_TYPERDA] DEFAULT (1) FOR [AZI_TYPERDA]
GO

UPDATE U_AZI_PB SET AZI_TYPERDA = 1
