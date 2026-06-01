
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TR] ADD 
	 CON_ASSTRA [numeric](18, 0) NULL,
	 CON_ASSRIC [numeric](18, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TR_CON_ASSTRA] DEFAULT (0) FOR [CON_ASSTRA],
	CONSTRAINT [DF_U_CON_TR_CON_ASSRIC] DEFAULT (0) FOR [CON_ASSRIC]
go

UPDATE U_CON_TR SET CON_ASSTRA = 0
UPDATE U_CON_TR SET CON_ASSRIC = 0
