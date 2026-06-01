/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_AN] ADD 
	 MAG_ANAART varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_AN_MAG_ANAART] DEFAULT ('') FOR [MAG_ANAART]
go

UPDATE U_MAG_AN SET MAG_ANAART = SPACE(16)
