
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_AN] ADD 
	 MAG_BYPASS [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_AN_MAG_BYPASS] DEFAULT (0) FOR [MAG_BYPASS]
go

UPDATE U_MAG_AN SET MAG_BYPASS = 0

