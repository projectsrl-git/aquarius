/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIC_TT] ADD 
	 	 RIC_RICMAN varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIC_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIC_TT_RIC_RICMAN] DEFAULT  ('') FOR [RIC_RICMAN]

go

UPDATE U_RIC_TT SET RIC_RICMAN		= ''
