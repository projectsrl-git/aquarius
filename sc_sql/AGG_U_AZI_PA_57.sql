/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	 azi_prgplet [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_azi_prgplet] DEFAULT (0) FOR [azi_prgplet]
go


UPDATE u_azi_pa SET azi_prgplet = 0 