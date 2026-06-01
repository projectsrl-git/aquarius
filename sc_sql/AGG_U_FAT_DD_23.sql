
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ord_ccodet varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ord_ccodet] DEFAULT ('') FOR [ord_ccodet]
go

UPDATE U_FAT_DD SET ord_ccodet = ''


