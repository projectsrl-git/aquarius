/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	 	 RES_dtstpda  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_dtstpal  varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_RES_dtstpda] DEFAULT ('') FOR [RES_dtstpda],
	CONSTRAINT [DF_RES_OPER_RES_dtstpal]  DEFAULT ('') FOR [RES_dtstpal]
go

UPDATE RES_OPER SET RES_dtstpda	= ''
UPDATE RES_OPER SET RES_dtstpal	= ''
