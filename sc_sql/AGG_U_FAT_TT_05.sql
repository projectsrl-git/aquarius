
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
		ORD_NUMCOC varchar (30) COLLATE Latin1_General_CI_AS NULL,
		ORD_DATCOC varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_TT_ORD_NUMCOC] DEFAULT ('') FOR [ORD_NUMCOC],
        CONSTRAINT [DF_U_FAT_TT_ORD_DATCOC] DEFAULT ('') FOR [ORD_DATCOC]
go



UPDATE U_FAT_TT SET ORD_NUMCOC 	= ''
UPDATE U_FAT_TT SET ORD_DATCOC 	= ''

