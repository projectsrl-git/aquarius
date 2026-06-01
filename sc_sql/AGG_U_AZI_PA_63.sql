/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	azi_yeslogbol bit NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_azi_yeslogbol] DEFAULT (0) FOR [azi_yeslogbol]
go

UPDATE u_azi_pa SET azi_yeslogbol = azi_logbol


ALTER TABLE [dbo].[u_azi_pa] ADD 
	azi_dogcom bit NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_azi_dogcoml] DEFAULT (0) FOR [azi_dogcom]
go

UPDATE u_azi_pa SET azi_dogcom = 0

