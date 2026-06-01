
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LOC_AN] ADD 
	 LOC_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LOC_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LOC_AN_LOC_PROVIN] DEFAULT ('') FOR [LOC_PROVIN]
go
