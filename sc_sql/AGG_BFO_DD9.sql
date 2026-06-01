/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_NUMBOE numeric(6) NULL,
	 ORD_NUMBOD numeric(6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_NUMBOE] DEFAULT (0) FOR [ORD_NUMBOE],
	CONSTRAINT [DF_U_BFO_DD_ORD_NUMBOD] DEFAULT (0) FOR [ORD_NUMBOD]
go

UPDATE U_BFO_DD SET ORD_NUMBOE = 0
UPDATE U_BFO_DD SET ORD_NUMBOD = 0


