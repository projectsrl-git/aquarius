
/*
*** Variabile gestita nella scheda "Ordini clienti2/fatture clienti1", di "form\menu_azi000.scx"  per la gestione fatturazione ordini rateizzata
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_ORDRATEI bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_ORDRATEI_PREFIX] DEFAULT (0)
GO

