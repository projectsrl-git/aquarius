
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	[MOV_NOTE] [text] COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_NOTE] DEFAULT ('') FOR [MOV_NOTE]
go
