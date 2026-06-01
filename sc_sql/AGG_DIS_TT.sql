/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_DIS_TT] ADD 
	 DIT_GGATCQ numeric(3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_DIS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_DIS_TT_DIT_GGATCQ] DEFAULT (0) FOR [DIT_GGATCQ]
go

UPDATE U_DIS_TT SET DIT_GGATCQ = 0
