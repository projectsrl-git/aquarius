/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_DL] ADD 
	 ORD_NRBOBO numeric(6) NULL,
	 ORD_QUANTO numeric(11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DL_ORD_NRBOBO] DEFAULT (0) FOR [ORD_NRBOBO],
	CONSTRAINT [DF_U_ORD_DL_ORD_QUANTO] DEFAULT (0) FOR [ORD_QUANTO]
go

UPDATE U_ORD_DL SET ORD_NRBOBO = 0
UPDATE U_ORD_DL SET ORD_QUANTO = 0
