/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_DIS_TT] ADD 
	 DIT_CILRET numeric(3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_DIS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_DIS_TT_DIT_CILRET] DEFAULT (0) FOR [DIT_CILRET]
go

UPDATE U_DIS_TT SET DIT_CILRET = 0
