/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[CONTI] ADD 
	con_nocomme [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CONTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTI_con_nocomme] DEFAULT (0) FOR [con_nocomme]
go

UPDATE CONTI SET con_nocomme = 0
