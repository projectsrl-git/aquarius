
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Abilita inserimento commenti presenti in fattura per la generazione del file XML
*/



ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_FECOMM BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FECOMM] DEFAULT (0)
GO
