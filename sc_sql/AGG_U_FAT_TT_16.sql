
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
		ORD_CONCON varchar (13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_TT_ORD_CONCON] DEFAULT ('') FOR [ORD_CONCON]
go



UPDATE U_FAT_TT SET ORD_CONCON 	= ''


