/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	ORD_PRGANT NUMERIC (7,0)  NULL,
        ORD_CONANT [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_PRGANT] DEFAULT (0) FOR [ORD_PRGANT],
	CONSTRAINT [DF_U_FAT_TT_ORD_CONANT] DEFAULT (0) FOR [ORD_CONANT]

go

UPDATE U_FAT_TT SET ORD_PRGANT = 0
UPDATE U_FAT_TT SET ORD_CONANT = 0

