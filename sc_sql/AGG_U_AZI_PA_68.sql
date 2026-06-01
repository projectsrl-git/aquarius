/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_LIFSCO bit NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_LIFSCO] DEFAULT (0) FOR [AZI_LIFSCO]
go

UPDATE u_azi_pa SET AZI_LIFSCO = 0

