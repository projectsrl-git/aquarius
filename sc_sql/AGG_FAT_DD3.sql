/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ORD_DESIMB varchar(30) COLLATE Latin1_General_CI_AS NULL,
	 ORD_LOTMIN numeric(6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_DESIMB] DEFAULT ('') FOR [ORD_DESIMB],
	CONSTRAINT [DF_U_FAT_DD_ORD_LOTMIN] DEFAULT (0) FOR [ORD_LOTMIN]
go

UPDATE U_FAT_DD SET ORD_DESIMB = SPACE(30)
UPDATE U_FAT_DD SET ORD_LOTMIN = 0
