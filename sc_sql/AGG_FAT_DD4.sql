/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ORD_QTAKGI numeric(11,2) NULL,
	 ORD_QTAKGE numeric(11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_QTAKGI] DEFAULT (0) FOR [ORD_QTAKGI],
	CONSTRAINT [DF_U_FAT_DD_ORD_QTAKGE] DEFAULT (0) FOR [ORD_QTAKGE]
go

UPDATE U_FAT_DD SET ORD_QTAKGI = 0
UPDATE U_FAT_DD SET ORD_QTAKGE = 0
