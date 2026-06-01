
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
		ORD_NUCONS varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_NUMLEI varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_DATLEI varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_TT_ORD_NUCONS] DEFAULT ('') FOR [ORD_NUCONS],        
		CONSTRAINT [DF_U_FAT_TT_ORD_NUMLEI] DEFAULT ('') FOR [ORD_NUMLEI],
        CONSTRAINT [DF_U_FAT_TT_ORD_DATLEI] DEFAULT ('') FOR [ORD_DATLEI]
go


UPDATE U_FAT_TT SET ORD_NUCONS	= ''
UPDATE U_FAT_TT SET ORD_NUMLEI	= ''
UPDATE U_FAT_TT SET ORD_DATLEI	= ''
