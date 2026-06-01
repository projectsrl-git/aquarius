/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_DA] ADD 
	 MAG_QTAIMP numeric(12,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_DA_MAG_QTAIMP] DEFAULT (0) FOR [MAG_QTAIMP]
go

UPDATE U_MAG_DA SET MAG_QTAIMP = 0

