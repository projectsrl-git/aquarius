/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_DIS_DD] ADD 
	 DIS_PERC numeric(7,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_DIS_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_DIS_DD_DIS_PERC] DEFAULT (0) FOR [DIS_PERC]
go

UPDATE U_DIS_DD SET DIS_PERC = 0
