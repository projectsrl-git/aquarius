
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_DD] ADD 
		 ORD_SC4 numeric (7,3) NULL ,
		 ORD_SC5 numeric (7,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_DD_ORD_SC4] DEFAULT (0) FOR [ORD_SC4],
        CONSTRAINT [DF_U_FAT_DD_ORD_SC5] DEFAULT (0) FOR [ORD_SC5]
go

UPDATE U_FAT_DD SET ORD_SC4 = 0 
UPDATE U_FAT_DD SET ORD_SC5	= 0 
