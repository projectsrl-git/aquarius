/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	 azi_lis12 [bit] NULL,
	 azi_lis13 [bit] NULL,
	 azi_lis14 [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_azi_lis12] DEFAULT (0) FOR [azi_lis12],
	CONSTRAINT [DF_u_azi_pa_azi_lis13] DEFAULT (0) FOR [azi_lis13],
	CONSTRAINT [DF_u_azi_pa_azi_lis14] DEFAULT (0) FOR [azi_lis14]
go


UPDATE u_azi_pa SET azi_lis12 = 0
UPDATE u_azi_pa SET azi_lis13 = 0
UPDATE u_azi_pa SET azi_lis14 = 0

