
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_NUMSCO varchar(6) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DATSCO varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_ORASCO varchar(5) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_NUMSCO] DEFAULT ('') FOR [ORD_NUMSCO],
	CONSTRAINT [DF_U_FAT_TT_ORD_DATSCO] DEFAULT ('') FOR [ORD_DATSCO],
	CONSTRAINT [DF_U_FAT_TT_ORD_ORASCO] DEFAULT ('') FOR [ORD_ORASCO]
go
