
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[SALDI_FOR] ADD 
	 PAR_ANOMAX varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[SALDI_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_SALDI_FOR_PAR_ANOMAX] DEFAULT ('') FOR [PAR_ANOMAX]
go

UPDATE SALDI_FOR SET PAR_ANOMAX = SPACE(03)