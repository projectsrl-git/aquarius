/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[RDA_TT] ADD 
	ACQUISTATO varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[RDA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_RDA_TT_ACQUISTATO] DEFAULT ('') FOR [ACQUISTATO]
go


UPDATE RDA_TT SET ACQUISTATO = '' 

