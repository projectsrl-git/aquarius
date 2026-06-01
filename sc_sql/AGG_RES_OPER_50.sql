/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	 	 RES_dtrdada   varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_dtrdaal  varchar(10) COLLATE Latin1_General_CI_AS NULL


go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_RES_dtrdada] DEFAULT (' ') FOR [RES_dtrdada],
	CONSTRAINT [DF_RES_OPER_RES_dtrdaal] DEFAULT (' ') FOR [RES_dtrdaal]


go

UPDATE RES_OPER SET RES_dtrdada 	= SPACE(10)
UPDATE RES_OPER SET RES_dtrdaal 	= SPACE(10)
