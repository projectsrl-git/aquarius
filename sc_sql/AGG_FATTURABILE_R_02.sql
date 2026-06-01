/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_R] ADD 
	IDClientiC varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_R] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_R_IDClientiC] DEFAULT ('') FOR [IDClientiC]
go

UPDATE FATTURABILE_R SET IDClientiC = ''
