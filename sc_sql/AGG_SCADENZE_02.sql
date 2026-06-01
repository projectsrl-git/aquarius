/* 
****************************************************************************
INSERIMENTO NUOVO CAMPO PER ORDINAMENTO GUIDATO TRANCHE IN SCADENZE SPECIALI
****************************************************************************
*/
ALTER TABLE [dbo].[SCADENZE] ADD 
	 SEQUEN numeric(10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[SCADENZE] WITH NOCHECK ADD 
	CONSTRAINT [DF_SCADENZE_SEQUEN] DEFAULT (0) FOR [SEQUEN]
go

UPDATE SCADENZE SET SEQUEN = 0
