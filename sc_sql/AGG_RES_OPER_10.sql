/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	 	 RES_dtrdcda  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_dtrdcal  varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_RES_dtrdcda] DEFAULT ('') FOR [RES_dtrdcda],
	CONSTRAINT [DF_RES_OPER_RES_dtrdcal]  DEFAULT ('') FOR [RES_dtrdcal]
go

UPDATE RES_OPER SET RES_dtrdcda	= ''
UPDATE RES_OPER SET RES_dtrdcal	= ''
