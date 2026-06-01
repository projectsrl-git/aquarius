/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_DIS_DD] ADD 
	 DIS_FITTIZ BIT NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_DIS_DD] WITH NOCHECK ADD 

	CONSTRAINT [DF_U_DIS_DD_DIS_FITTIZ] DEFAULT (0) FOR [DIS_FITTIZ]
go


UPDATE U_DIS_DD SET DIS_FITTIZ	= 0

