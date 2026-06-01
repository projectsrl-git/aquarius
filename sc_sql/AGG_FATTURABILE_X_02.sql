/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_X] ADD 
	IDClientiC varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_X] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_X_IDClientiC] DEFAULT ('') FOR [IDClientiC]
go

UPDATE FATTURABILE_X SET IDClientiC = ''
