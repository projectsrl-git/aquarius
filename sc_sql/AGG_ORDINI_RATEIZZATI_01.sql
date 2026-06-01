
/*
*** Variabile gestita nella nell'archivio ORDINI_RATEIZZATI per la gestione della rateizzazione ordine
*/

        
ALTER TABLE [DBO].[ORDINI_RATEIZZATI] ADD 
	ORD_RATAFAT bit NOT NULL CONSTRAINT [DF_ORDINI_RATEIZZATI_ORD_RATAFAT_PREFIX] DEFAULT (0)
GO

