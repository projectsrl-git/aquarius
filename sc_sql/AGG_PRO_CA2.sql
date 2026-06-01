/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRO_CA] ADD 
	 CAP_LUMIFN numeric(6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRO_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_CA_CAP_LUMIFN] DEFAULT (0) FOR [CAP_LUMIFN]
go

UPDATE U_PRO_CA SET CAP_LUMIFN = 0

