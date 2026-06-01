/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_DA] ADD 
	 MAG_ALTRES numeric(5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_DA_MAG_ALTRES] DEFAULT (0) FOR [MAG_ALTRES]
go

UPDATE U_MAG_DA SET MAG_ALTRES = 0

