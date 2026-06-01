
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_CODBUN varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DESBUN varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_CODBUN] DEFAULT ('') FOR [ORD_CODBUN],
	CONSTRAINT [DF_U_FAT_TT_ORD_DESBUN] DEFAULT ('') FOR [ORD_DESBUN]
go
