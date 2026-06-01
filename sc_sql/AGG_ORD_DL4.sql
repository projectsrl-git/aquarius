/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_DL] ADD 
	 ORD_NRBOBY numeric(6) NULL,
	 ORD_QUANTY numeric(11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DL_ORD_NRBOBY] DEFAULT (0) FOR [ORD_NRBOBY],
	CONSTRAINT [DF_U_ORD_DL_ORD_QUANTY] DEFAULT (0) FOR [ORD_QUANTY]
go

UPDATE U_ORD_DL SET ORD_NRBOBY = 0
UPDATE U_ORD_DL SET ORD_QUANTY = 0
