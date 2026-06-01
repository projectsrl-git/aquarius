/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_AVA_SP] ADD 
	 AVA_SYSMAN varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AVA_SP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AVA_SP_AVA_SYSMAN] DEFAULT ('') FOR [AVA_SYSMAN]
go

UPDATE U_AVA_SP SET AVA_SYSMAN = SPACE(10)
