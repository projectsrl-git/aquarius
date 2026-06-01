
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
		 ORD_COSTTR numeric (17,2) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_TT_ORD_COSTTR] DEFAULT (0) FOR [ORD_COSTTR]
go

UPDATE U_FAT_TT SET ORD_COSTTR = 0 

