
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ASS_TT] ADD 
	 SELEZIONE varchar(10) COLLATE Latin1_General_CI_AS NULL
	 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ASS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ASS_TT_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]
	go

UPDATE U_ASS_TT SET SELEZIONE=''