
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_TT] ADD 
	 ORD_NUMIDE varchar(06) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_TT_ORD_NUMIDE] DEFAULT ('') FOR [ORD_NUMIDE]
go

UPDATE U_BFO_TT SET ORD_NUMIDE = SPACE(06)