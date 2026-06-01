/* 
**************************************************************  
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RISURAPP] DROP CONSTRAINT [DF_RisURapp_CONTOCONT]
go

ALTER TABLE [dbo].[RISURAPP] DROP COLUMN [CONTOCONT] 	
go

ALTER TABLE [dbo].[RISURAPP] ADD  
	[CONTOCONT] varchar(13) COLLATE Latin1_General_CI_AS NULL 
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RISURAPP] WITH NOCHECK ADD 
	CONSTRAINT [DF_RisURapp_CONTOCONT] DEFAULT ('') FOR [CONTOCONT]
go

UPDATE [RISURAPP] SET CONTOCONT=''
