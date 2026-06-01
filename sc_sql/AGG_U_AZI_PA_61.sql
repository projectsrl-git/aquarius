/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	azi_TOPPNC  varchar(3) COLLATE Latin1_General_CI_AS NULL ,
	azi_TOPTRI  varchar(3) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_azi_TOPPNC] DEFAULT ('') FOR [azi_TOPPNC],
	CONSTRAINT [DF_u_azi_pa_azi_TOPTRI] DEFAULT ('') FOR [azi_TOPTRI]
go

UPDATE u_azi_pa SET AZI_TOPPNC = ''
UPDATE u_azi_pa SET azi_TOPTRI = ''
