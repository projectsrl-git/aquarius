
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CURRICUL] ADD 
	[FIGPROFC] [varchar] (100) COLLATE Latin1_General_CI_AS NULL 
GO



go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CURRICUL] WITH NOCHECK ADD 
	CONSTRAINT [DF_CURRICUL_FIGPROFC] DEFAULT ('') FOR [FIGPROFC] 
go

UPDATE CURRICUL SET FIGPROFC = ''



