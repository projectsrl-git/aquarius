
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ORD_CLDOG varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 ORD_SERV_INTRA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_CLDOG] DEFAULT ('') FOR [ORD_CLDOG],
	CONSTRAINT [DF_U_FAT_DD_ORD_SERV_INTRA] DEFAULT ('') FOR [ORD_SERV_INTRA]
go

UPDATE U_FAT_DD SET ORD_CLDOG = ''
UPDATE U_FAT_DD SET ORD_SERV_INTRA = ''

