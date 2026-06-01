/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_DL] ADD 
	 ORD_NRBOBT numeric(6) NULL,
	 ORD_QUANTT numeric(11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DL_ORD_NRBOBT] DEFAULT (0) FOR [ORD_NRBOBT],
	CONSTRAINT [DF_U_ORD_DL_ORD_QUANTT] DEFAULT (0) FOR [ORD_QUANTT]
go

UPDATE U_ORD_DL SET ORD_NRBOBT = 0
UPDATE U_ORD_DL SET ORD_QUANTT = 0
