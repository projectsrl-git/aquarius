
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per Autocontrollo
***		- Allinea il piano dei conti da esercizio precedente se conto contabile movimentato su esercizio precedente
***		- Ricrea il piano dei conti se conto contabile movimentato su esercizio in corso (caso di errore software)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ALLPDC BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ALLPDC] DEFAULT (0)
GO

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CREAPDC BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CREAPDC] DEFAULT (0)
GO

