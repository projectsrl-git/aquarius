
/*
*** Variabile per opzione gestita nella scheda "Altro", sottoscheda "Documenti", sotteoscheda "Ordini clienti" di "form\menu_azi000.scx":
***		- Ricalcola scadenze pagamenti in base alla Data Consegna definita in testata ordine
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ORDSCADTC BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ORDSCADTC] DEFAULT (0)
GO
