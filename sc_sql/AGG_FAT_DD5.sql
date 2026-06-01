/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ORD_CDAPRD varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DSAPRD varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_CDAPRD] DEFAULT ('') FOR [ORD_CDAPRD],
	CONSTRAINT [DF_U_FAT_DD_ORD_DSAPRD] DEFAULT ('') FOR [ORD_DSAPRD]
go

UPDATE U_FAT_DD SET ORD_CDAPRD = SPACE(16)
UPDATE U_FAT_DD SET ORD_DSAPRD = SPACE(50)
