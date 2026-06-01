
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Non inserire la seconda descrizione nei dettagli fattura per la generazione del file XML
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FENODES2 bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_FENODES2] DEFAULT (0)
GO
