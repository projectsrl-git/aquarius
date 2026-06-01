
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 ORS_SYSFAT varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORS_SYSFAT] DEFAULT ('') FOR [ORS_SYSFAT]
go

UPDATE U_ORD_DD SET ORS_SYSFAT = ''


