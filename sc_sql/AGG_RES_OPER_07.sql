/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	 	 RES_dtmagda  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_dtmagal  varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_RES_DTMAGDA] DEFAULT (' ') FOR [RES_DTMAGDA],
	CONSTRAINT [DF_RES_OPER_RES_DTMAGAL]  DEFAULT (' ') FOR [RES_DTMAGAL]
go

UPDATE RES_OPER SET RES_DTMAGDA	= SPACE(10)
UPDATE RES_OPER SET RES_DTMAGAL	= SPACE(10)
