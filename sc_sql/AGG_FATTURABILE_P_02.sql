/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_P] ADD 
	IDClientiC varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_P] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_P_IDClientiC] DEFAULT ('') FOR [IDClientiC]
go

UPDATE FATTURABILE_P SET IDClientiC = ''
