/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ORD_NOTEBO [text] COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_NOTEBO] DEFAULT ('') FOR [ORD_NOTEBO]
go

UPDATE U_FAT_DD SET ORD_NOTEBO = SPACE(1)
