/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_LEVIGA1 varchar(6) COLLATE Latin1_General_CI_AS NULL ,
	AZI_LEVIGA2 varchar(6) COLLATE Latin1_General_CI_AS NULL ,
	AZI_LEVIGA3 varchar(6) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_LEVIGA1] DEFAULT ('') FOR [AZI_LEVIGA1],
	CONSTRAINT [DF_u_azi_pa_AZI_LEVIGA2] DEFAULT ('') FOR [AZI_LEVIGA2],
	CONSTRAINT [DF_u_azi_pa_AZI_LEVIGA3] DEFAULT ('') FOR [AZI_LEVIGA3]
go

UPDATE u_azi_pa SET AZI_LEVIGA1 = ''
UPDATE u_azi_pa SET AZI_LEVIGA2 = ''
UPDATE u_azi_pa SET AZI_LEVIGA3 = ''


