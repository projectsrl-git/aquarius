/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	 stile_icone varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_stile_icone] DEFAULT ('   ') FOR [stile_icone]
go



UPDATE RES_OPER SET stile_icone 	= ''
