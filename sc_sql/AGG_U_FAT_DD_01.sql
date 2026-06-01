
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 	 ORS_SYSDDT varchar (50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORS_SYSDDT] DEFAULT ('') FOR [ORS_SYSDDT]
go


UPDATE U_FAT_DD SET ORS_SYSDDT = ''
