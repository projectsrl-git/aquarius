
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_SP] ADD 
	 STA_SCARTO [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_SP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_SP_STA_SCARTO] DEFAULT (0) FOR [STA_SCARTO]
go

UPDATE U_PRG_SP SET STA_SCARTO = 0

