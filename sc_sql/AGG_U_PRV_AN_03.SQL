/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRV_AN] ADD 
	 PRV_IMPRIC numeric(17,2) NULL,
	 PRV_SPEDIZ numeric(17,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRV_AN_PRV_IMPRIC] DEFAULT (0) FOR [PRV_IMPRIC],
	CONSTRAINT [DF_U_PRV_AN_PRV_SPEDIZ] DEFAULT (0) FOR [PRV_SPEDIZ]
go

UPDATE U_PRV_AN SET PRV_IMPRIC = 0
UPDATE U_PRV_AN SET PRV_SPEDIZ = 0