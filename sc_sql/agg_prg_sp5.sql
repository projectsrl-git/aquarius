
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_SP] ADD 
	 STA_FLGELI varchar(2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_SP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_SP_STA_FLGELI] DEFAULT ('') FOR [STA_FLGELI]
go

UPDATE U_PRG_SP SET STA_FLGELI = SPACE(02)
