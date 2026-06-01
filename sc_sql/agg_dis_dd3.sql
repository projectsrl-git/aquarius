/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_DIS_DD] ADD 
	 DIS_QTACO2 numeric(17,7) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_DIS_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_DIS_DD_DIS_QTACO2] DEFAULT (0) FOR [DIS_QTACO2]
go

UPDATE U_DIS_DD SET DIS_QTACO2 = 0
