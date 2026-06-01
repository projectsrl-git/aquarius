/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_DA] ADD 
	 MAG_COMODO numeric(12,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_DA_MAG_COMODO] DEFAULT (0) FOR [MAG_COMODO]
go

UPDATE U_MAG_DA SET MAG_COMODO = 0

