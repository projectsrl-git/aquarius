/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRO_CA] ADD 
	 CAP_ALMIFN numeric(5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRO_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_CA_CAP_ALMIFN] DEFAULT (0) FOR [CAP_ALMIFN]
go

UPDATE U_PRO_CA SET CAP_ALMIFN = 0

