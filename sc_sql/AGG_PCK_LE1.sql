/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PCK_LE] ADD 
	 LEG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PCK_LE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_LE_LEG_UNIQUE] DEFAULT ('') FOR [LEG_UNIQUE]
go

UPDATE U_PCK_LE SET LEG_UNIQUE = SPACE(10)
