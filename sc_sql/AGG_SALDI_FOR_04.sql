
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[SALDI_FOR] ADD 
	 PAR_BANCA varchar(5) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[SALDI_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_SALDI_FOR_PAR_BANCA] DEFAULT ('') FOR [PAR_BANCA]
go

UPDATE SALDI_FOR SET PAR_BANCA = SPACE(05)