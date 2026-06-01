/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	[DES_PERIVA_NON_DED] [varchar] (100)  COLLATE Latin1_General_CI_AS NULL,
	PERIVA_NON_DED	[numeric] (8,3) NULL 		
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_DES_PERIVA_NON_DED] DEFAULT ('') FOR [DES_PERIVA_NON_DED],
	CONSTRAINT [DF_PARA_PERIVA_NON_DED]	DEFAULT (0)  FOR [PERIVA_NON_DED]
go

update PARA set DES_PERIVA_NON_DED = ''
UPDATE PARA SET PERIVA_NON_DED = 0

