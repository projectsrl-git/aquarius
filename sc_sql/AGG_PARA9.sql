
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	 SOLOIVA varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_SOLOIVA] DEFAULT ('') FOR [SOLOIVA]
go
