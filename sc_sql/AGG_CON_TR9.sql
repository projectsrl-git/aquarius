
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TR] ADD 
	 CON_MOPTRA [numeric](18, 0) NULL,
	 CON_MOPRIC [numeric](18, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TR_CON_MOPTRA] DEFAULT (0) FOR [CON_MOPTRA],
	CONSTRAINT [DF_U_CON_TR_CON_MOPRIC] DEFAULT (0) FOR [CON_MOPRIC]
go

UPDATE U_CON_TR SET CON_MOPTRA = 0
UPDATE U_CON_TR SET CON_MOPRIC = 0
