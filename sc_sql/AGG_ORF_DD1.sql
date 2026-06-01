
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 ORD_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORD_UNIQUE] DEFAULT ('') FOR [ORD_UNIQUE]
go
