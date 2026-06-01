
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Non inserire mai l'IBAN nel file XML
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_FENOIBAN BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FENOIBAN] DEFAULT (0)
GO
