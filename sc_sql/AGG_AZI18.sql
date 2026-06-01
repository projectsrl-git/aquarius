
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_AN] ADD 
	[azi_nfatdifferita] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_AN_azi_nfatdifferita] DEFAULT (0) FOR [azi_nfatdifferita]
go

UPDATE U_AZI_AN SET azi_nfatdifferita = 0
