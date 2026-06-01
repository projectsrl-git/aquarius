/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/  

ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 FOR_LOCDOC varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_LOCDOC] DEFAULT ('') FOR [FOR_LOCDOC]

go

UPDATE U_FOR_AN SET FOR_LOCDOC = ''

