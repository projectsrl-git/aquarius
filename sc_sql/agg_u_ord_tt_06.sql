/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_EVAFOR bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_EVAFOR] DEFAULT (0) FOR [ORD_EVAFOR]
go

UPDATE U_ORD_TT SET ORD_EVAFOR = 0