/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRV_AN] ADD 
	 PRV_COSTTR numeric(17,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRV_AN_PRV_COSTTR] DEFAULT (0) FOR [PRV_COSTTR]
go

UPDATE U_PRV_AN SET PRV_COSTTR = 0
