
/*
*** Scheda IVA: definisce il codice IVA abbinato per la percentuale di iva indeducibile
*/

ALTER TABLE [DBO].[PARA] ADD 
	CODICE_ABBINATO  [varchar](8) NULL
GO

ALTER TABLE [DBO].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_CODICE_ABBINATO] DEFAULT ('') FOR [CODICE_ABBINATO]
GO

UPDATE PARA SET CODICE_ABBINATO = ''