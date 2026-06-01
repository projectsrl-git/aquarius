/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PCK_DD] ADD 
	 ORD_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PCK_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_DD_ORD_UNIQUE] DEFAULT ('') FOR [ORD_UNIQUE]
go

UPDATE U_PCK_DD SET ORD_UNIQUE = SPACE(10)
