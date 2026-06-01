
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_DA] ADD 
	 MAG_FLGRIB [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_DA_MAG_FLGRIB] DEFAULT (0) FOR [MAG_FLGRIB]
go

UPDATE U_MAG_DA SET MAG_FLGRIB = 0

