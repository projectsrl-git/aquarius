/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	 	 RES_dtrisda  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_dtrisal  varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_RES_dtrisda] DEFAULT ('') FOR [RES_dtrisda],
	CONSTRAINT [DF_RES_OPER_RES_dtrisal]  DEFAULT ('') FOR [RES_dtrisal]
go

UPDATE RES_OPER SET RES_dtrisda	= ''
UPDATE RES_OPER SET RES_dtrisal	= ''
