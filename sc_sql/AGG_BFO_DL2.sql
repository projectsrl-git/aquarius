
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DL] ADD 
	[ORD_FLGIMB] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DL_ORD_FLGIMB] DEFAULT (0) FOR [ORD_FLGIMB]
go

UPDATE U_BFO_DL SET ORD_FLGIMB = 0
