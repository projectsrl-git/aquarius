
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_DD] ADD 
		ORD_CONDET varchar (13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_DD_ORD_CONDET] DEFAULT ('') FOR [ORD_CONDET]
go



UPDATE U_FAT_DD SET ORD_CONDET 	= ''


