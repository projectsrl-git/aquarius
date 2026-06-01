
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_SP] ADD 
	 STA_ALTCOM numeric(5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_SP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_SP_STA_ALTCOM] DEFAULT (0) FOR [STA_ALTCOM]
go

UPDATE U_PRG_SP SET STA_ALTCOM = 0

