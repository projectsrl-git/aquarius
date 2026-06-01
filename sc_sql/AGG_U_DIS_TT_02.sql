/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_DIS_TT] ADD 
	 DIT_SYSTT varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_DIS_TT] WITH NOCHECK ADD 

	CONSTRAINT [DF_U_DIS_TT_DIT_SYSTT] DEFAULT ('') FOR [DIT_SYSTT]
go


UPDATE U_DIS_TT SET DIT_SYSTT 	= ''
