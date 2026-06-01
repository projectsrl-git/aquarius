/* 
**************************************************************  
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RISURAPP] ADD  
	[DocContratt1] 	[text] COLLATE Latin1_General_CI_AS NULL ,
	[DocContratt2] 	[text] COLLATE Latin1_General_CI_AS NULL ,
	[DocContratt3] 	[text] COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RISURAPP] WITH NOCHECK ADD 
	CONSTRAINT [DF_RisURapp_DocContratt1] DEFAULT ('') FOR [DocContratt1],
	CONSTRAINT [DF_RisURapp_DocContratt2] DEFAULT ('') FOR [DocContratt2],
	CONSTRAINT [DF_RisURapp_DocContratt3] DEFAULT ('') FOR [DocContratt3]
go

