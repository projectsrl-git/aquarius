/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
        ORD_INCASS [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_INCASS] DEFAULT (0) FOR [ORD_INCASS]

go

UPDATE U_FAT_TT SET ORD_INCASS = 0

