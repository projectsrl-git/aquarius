
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CTL_DD] ADD 
	 ORD_CODSYS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CTL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CTL_DD_ORD_CODSYS] DEFAULT ('') FOR [ORD_CODSYS]
go

UPDATE U_CTL_DD SET ORD_CODSYS = ''
