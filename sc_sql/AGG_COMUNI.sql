/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[COMUNI] ADD 
	 SELEZIONE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[COMUNI] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMNUNI_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]
go

UPDATE COMUNI SET SELEZIONE = SPACE(10)

