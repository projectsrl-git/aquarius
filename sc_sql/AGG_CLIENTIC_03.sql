/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CLIENTIC] ADD 
	IDClientiC varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[CLIENTIC] WITH NOCHECK ADD 
	CONSTRAINT [DF_CLIENTIC_IDClientiC] DEFAULT ('') FOR [IDClientiC]
go

UPDATE CLIENTIC SET IDClientiC = ''
