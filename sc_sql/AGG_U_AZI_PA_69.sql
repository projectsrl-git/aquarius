
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_CAUVBA varchar(3) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_CAUVBA] DEFAULT ('') FOR [AZI_CAUVBA]
go

UPDATE u_azi_pa SET AZI_CAUVBA = ''


