
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ALT_DA] ADD 
	 ALT_FLGRIB [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ALT_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ALT_DA_ALT_FLGRIB] DEFAULT (0) FOR [ALT_FLGRIB]
go

UPDATE U_ALT_DA SET ALT_FLGRIB = 0

