
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AVA_SP] ADD 
	 AVA_LOTFIN numeric(8) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AVA_SP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AVA_SP_AVA_LOTFIN] DEFAULT (0) FOR [AVA_LOTFIN]
go

UPDATE U_AVA_SP SET AVA_LOTFIN = 1

	