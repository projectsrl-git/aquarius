
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_AN] ADD 
	 ART_PREPES [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_AN_ART_PREPES] DEFAULT (0) FOR [ART_PREPES]
go

UPDATE U_ART_AN SET ART_PREPES = 0

