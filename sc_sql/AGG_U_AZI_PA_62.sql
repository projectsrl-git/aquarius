/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	azi_GGRIBA  numeric (3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_azi_GGRIBA] DEFAULT (0) FOR [azi_GGRIBA]
go

UPDATE u_azi_pa SET AZI_GGRIBA = 0
