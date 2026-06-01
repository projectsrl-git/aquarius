/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[COMM_GROUP_COMP] ADD 
	[AGGSYS]        [varchar] (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[COMM_GROUP_COMP] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMM_GROUP_COMP_AGGSYS] DEFAULT ('') FOR [AGGSYS]
go
