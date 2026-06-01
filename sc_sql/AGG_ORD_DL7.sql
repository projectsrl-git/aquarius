/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_DL] ADD 
	 ORD_NRBOBR numeric(6) NULL,
	 ORD_QUANTR numeric(11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DL_ORD_NRBOBR] DEFAULT (0) FOR [ORD_NRBOBR],
	CONSTRAINT [DF_U_ORD_DL_ORD_QUANTR] DEFAULT (0) FOR [ORD_QUANTR]
go

UPDATE U_ORD_DL SET ORD_NRBOBR = 0
UPDATE U_ORD_DL SET ORD_QUANTR = 0
