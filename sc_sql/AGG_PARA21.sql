/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	[PAR_VALIDDAL] [varchar] (10)  COLLATE Latin1_General_CI_AS NULL,
	[PAR_VALIDAL] [varchar] (10)  COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_PAR_VALIDDAL] DEFAULT ('') FOR [PAR_VALIDDAL],
	CONSTRAINT [DF_PARA_PAR_VALIDAL] DEFAULT ('') FOR [PAR_VALIDAL]
go

update PARA set PAR_VALIDDAL = ''
update PARA set PAR_VALIDAL = ''

