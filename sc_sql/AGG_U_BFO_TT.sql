/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_BFO_TT] ADD 
	 ORD_CARCONF bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_TT_ORD_CARCONF] DEFAULT (0) FOR [ORD_CARCONF]
go

UPDATE U_BFO_TT SET ORD_CARCONF = 0
